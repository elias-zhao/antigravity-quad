# Antigravity 多智能体 API 调度速查指引

本手册面向使用 `quad` 技能的主控 Agent，汇总了 Antigravity 系统中多智能体调度的原生 API、参数规范及运行机制。

---

## 1. 核心派发工具：`invoke_subagent`

### 参数定义与规范
在调用 `invoke_subagent` 时，通过 `Subagents` 数组可以一次性并发派发多个子智能体（如 Batch 1 同时派发 Worker 1 与 Worker 2）：

```json
{
  "Subagents": [
    {
      "Role": "Feature Worker 1",
      "TypeName": "self",
      "Model": "flash",
      "Workspace": "inherit",
      "Prompt": "【任务性质】：单点特性攻坚与代码实现\n【推理强度与思考规范】：高推理（深度推演模式）\n【单分支文件独占约束】：crates/pq-state/src/worker.rs\n..."
    },
    {
      "Role": "Feature Worker 2",
      "TypeName": "self",
      "Model": "flash",
      "Workspace": "inherit",
      "Prompt": "【任务性质】：单点特性攻坚与代码实现\n【推理强度与思考规范】：高推理（深度推演模式）\n【单分支文件独占约束】：crates/pq-state/src/metrics.rs\n..."
    }
  ],
  "toolSummary": "Batch 1 并发攻坚派发",
  "toolAction": "并发派发攻坚员"
}
```

### 字段取值与推理控制规范：

| 字段 | 含义 | 本技能强制约定取值 | 说明 |
| :--- | :--- | :--- | :--- |
| **`Model`** | 子智能体采用的模型 | **`flash`** | 统一使用 `flash`，执行迅速、响应轻巧。未来若需要升级可在此替换。 |
| **`Workspace`** | 工作区模式 | **`inherit`** | 统一使用 `inherit`，保持单分支推进，不创建多余的 Git 分支与 worktree。 |
| **`TypeName`** | 智能体类型 | `research` / `self` / `code-reviewer` | - `research`：只读探索；<br>- `self`：继承主控能力的特性实现；<br>- `code-reviewer`：质量与测试门禁。 |
| **`Role`** | 2-5 个词的角色说明 | 如 `ClickHouse Researcher` | 简要表明其岗位或任务目标。 |
| **`Prompt`** | 任务提示词与推理控制 | 采用 `prompt_templates.md` 模板 | **在此处注入推理强度控制（方式 A）**：<br>- 侦察员：声明【低推理（快速直出模式）】<br>- 攻坚员：声明【高推理（深度推演模式）】<br>- 审查员：声明【高推理（深度推演模式）】 |

---

## 2. 推理强度控制机制（方式 A：Prompt 显式导引）

在 Antigravity 环境下，由于底层 API 没有显式的 `reasoning_effort` 参数字段，我们采用业界广泛认可且高度有效的 **Prompt-level Reasoning Guidance（提示词思维链导引）**：
- **低推理（直出模式）**：明确限制思考步数，强制要求以模式匹配和关键词精确定位为主，不展开冗余推演，实现极速吞吐。
- **高推理（深度推演模式）**：显式触发内部深度思考（Deep Thinking），强制要求在动笔前推演架构铁律、并发安全性、极端边界与异常恢复路径，审查时进行逆向攻击性审查。

---

## 3. 响应式事件唤醒机制 (Reactive Wakeup)

在 Antigravity 体系中，主智能体派发异步子任务后：
- **严禁轮询或空转**：主智能体**不需要**写 `sleep` 脚本，也**不需要**循环调用 `manage_subagents(Action='status')`。
- **自动事件恢复**：当子智能体完成任务或发来消息时，Antigravity 系统会自动触发主智能体的唤醒，将子智能体的输出完整送入上下文。主控派发后只需结束本轮工具调用即可静待通知。

---

## 4. 子智能体通信与管理

- **`send_message`**：若需要向运行中或处于空闲状态的子智能体追加新指令或补充上下文，通过其返回的 `conversationId` 发送。
- **`manage_subagents`**：
  - `Action: "list"`：列出当前存活的所有直接子智能体及其状态（running、idle、errored 等）。
  - `Action: "kill"`：终止指定的子智能体。
  - `Action: "kill_all"`：一键终止所有子智能体。

---

## 5. 流水线协同与验证硬门禁 (Pipeline Gatekeeping)

主控在调度多智能体时，必须严格遵守协同状态机约束：
1. **1:1 结对即发（零等待流转）**：任何 Worker $i$ 汇报实现完成时，主控的第一优先级动作是**立即调用 `invoke_subagent(TypeName: "code-reviewer")` 拉起结对 Reviewer $i$**，绝不等待同批次其他 Worker，也严禁停下来等待用户催促。
2. **反串行排队禁区（Zero Queueing）**：同批次先后交付多个 Worker 时，必须各自拉起专属 Reviewer（后台形成 Reviewer 1 与 Reviewer 2 同时在跑）。**绝对禁止**输出“等待 Reviewer 1 验收后再推进”、“排队审查”等推迟话术。
3. **并发审查防撞锁与独占测试**：
   - 必须为每个 Reviewer 分配互斥的独占测试文件（如 Reviewer 1 独占写 `tests/test_a.rs`，Reviewer 2 独占写 `tests/test_b.rs`）；
   - 提示词必须明确指示审查员优先执行定向单测目标（如 `cargo test --test test_a`），严禁粗暴运行全局构建命令竞争构建锁。
4. **输入隔离（防审查沦为盖章）**：组装 Reviewer 的 Prompt 时，**必须过滤掉 Worker 自评里的一切结论话术**（“已完成”“已自测通过”“请签收”）。只传递：改了哪些文件、每个文件的改动点。Reviewer 的锚点必须是**任务书验收项原文（带具体数值）**，不是 diff。
5. **硬性落地测试代码 + 只报告不修复**：严禁审查员只看 diff 纯只读偷懒，必须落盘新建测试用例；同时**严禁审查员修改任何非测试文件**。发现缺陷时保留失败测试的失败状态，修复退回 Worker，Reviewer 下一轮复核。
6. **物理事实核验（主控必做，不可省略）**：接受任何 Reviewer 报告前，主控必须执行 `git status --short` 与 `git diff --stat`，核验：① 声明的独占测试文件真实落盘；② 非测试文件没有被 Reviewer 动过；③ 报告路径与工作区逐条一致。任一不符即驳回。**签收权归主控，Reviewer 只交发现报告，不输出“批准提交”。**
7. **用户视角独立验收（涉及界面的任务强制）**：凡改动用户可见行为的任务，Reviewer 闭合后必须追加一道 `TypeName: "research"` 的验收员，输入只有场景卡 + Playwright 运行证据目录，**明令禁止读取任何源码**。它的核心产出是对屏幕上每个金额的算术复核。
8. **提交阻断**：严禁在任何结对 Reviewer 未闭合、物理事实核验未通过、或适用的验收员未闭合前执行 `git commit` 或宣告交付。

---

## 6. 结构化呈现与人机协同 (Artifacts)

主控在进行任务统筹时，应合理利用 Markdown 产物（Artifacts）向用户展示架构与方案：
- 复杂方案与计划：写入 `<appDataDir>/brain/<conversation-id>/<plan_name>.md`，并设置 `RequestFeedback: true`。
- 任务执行完毕后：输出工作总结或验收记录。

---

## 7. 二维批次矩阵与调度硬卡扣 (2D Batch Matrix & Scheduling Clamps)

主控在规划与输出任务拆解时，必须严格遵守三大调度卡扣：
1. **双层嵌套批次矩阵语法**：外层遵循全局工作流规范（`### 任务执行计划（依据工作流规范）`），内层在涉及子智能体攻坚的 Task 中强制展开 `### 任务编排规划（强制二维批次矩阵）`，包含 `【Batch 1 (自动并发攻坚)】`、`【Batch 2 (依赖收敛/串行)】`。
2. **串行举证倒置（想串行？先写证明报告！）**：凡未归入同一 Batch 的串行任务，必须提供【不可并发证据】，指明具体写冲突文件全路径或编译强依赖符号。无证据串行一律判定违规。
3. **单文件交集判定铁律**：严禁以 crate 或目录粗暴判定互斥。只要 $\text{Files}(A) \cap \text{Files}(B) = \emptyset$，必须无条件在单次 `invoke_subagent` 中自动并发下发！
4. **侦查阻断与两步熔断铁律（Scout Barrier & 2-Step Breaker）**：
   - 严禁主控在主线程使用 `view_file` 阅读任何超过 50 行的业务脚本或代码，严禁在主线程发生长时间深入思考；
   - 遇到代码阅读、跨模块排查或任务书研读，必须立即调用 `invoke_subagent(TypeName: "research", Role: "Scout")`（锁死 `TypeName: "research"`，低推理直出）；
   - 若任务需运行命令复现环境/抓日志，严禁冒充 Scout，必须作为 **特性攻坚员 (Worker)** 编入 `Batch 1` 并发派发并划定独占留证路径。

