# ⚡ Antigravity Quad

> **High-throughput, anti-hallucination multi-agent orchestration framework custom-engineered for Google Antigravity (AGY).**  
> Powered universally by lightweight, lightning-fast `flash` models, Quad enforces **non-overlapping concurrent implementation**, **independent contract verification**, and **zero-source-code user acceptance** across a clean single Git branch.

**English** | [中文说明 (Chinese)](README_zh.md)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Antigravity Skill](https://img.shields.io/badge/Antigravity-Skill-blue.svg)](https://github.com/google)
[![Architecture: Multi--Agent](https://img.shields.io/badge/Architecture-Multi--Agent-green.svg)](SKILL.md)

---

## 📖 Table of Contents

- [Why Quad?](#-why-quad)
- [Key Advantages](#-key-advantages)
- [Example Usage (`/quad`)](#-example-usage-quad)
- [Three Core Design Philosophies](#-three-core-design-philosophies)
- [Four Specialized Roles Matrix](#-four-specialized-roles-matrix)
- [Six-Stage Orchestration Pipeline](#-six-stage-orchestration-pipeline)
- [One-Liner Quick Installation](#-one-liner-quick-installation)
- [License](#-license)

---

## 💡 Why Quad?

When modern AI agents write and refactor complex codebases, single-agent workflows and loosely coupled multi-agent systems suffer from **structural failure**. Regardless of prompt tone or model capability, unconstrained setups inevitably fail in four predictable ways:

```
Typical rubber-stamp review failure:
[Worker writes code] ➔ "I completed this and self-tests pass!" ➔ [Reviewer reads code diff & self-evaluation] ➔ "LGTM, looks clean!" (15+ critical bugs slip into production)
```

The root causes are structural:

1. **Inverted Frame of Reference (Diff vs. Contract)**  
   When a reviewer is asked to "review what the worker changed," its expectation is reverse-engineered from the code's existing behavior. **Assertions derived from implementation behavior are tautological—they always pass.**
2. **Context Pollution (Self-Evaluation Kills Critical Thinking)**  
   Phrases like *"completed," "all self-tests pass,"* or *"ready for review"* provide pre-baked answers in the LLM's context. `flash` models naturally rationalize and follow the existing narrative rather than re-deducing independently.
3. **Cross-Role Corruption (Test Author = Code Author)**  
   When an agent's objective function is "achieve 100% test pass rate," tweaking implementation code to accommodate a test is the path of least resistance. This is an objective flaw, not laziness.
4. **Visual & Arithmetic Blind Spots (Green Unit Tests ≠ Usable Software)**  
   Headless unit tests cannot catch modal dialogs that cannot be dismissed, broken keyboard input stepping, reconnection failures, or balance conservation violations where figures displayed on screen fail to reconcile.

**Quad breaks this deadlock** by injecting separation of powers, physical input isolation, and strict state machine gates into the multi-agent loop.

---

## ✨ Key Advantages

Quad provides enterprise-grade reliability and massive throughput gains over traditional multi-agent setups:

| Advantage | What Traditional Workflows Do | How Quad Solves It |
| :--- | :--- | :--- |
| ⚡ **Conflict-Free Concurrency** | Agents step on each other's files, create git lock conflicts, or cause complex branch merge hell. | **Single-Branch Zero Collision**: Concurrency is mathematically governed by disjoint file ownership ($Files(A) \cap Files(B) = \emptyset$). Global summary files are decoupled. Delivers **3x~5x higher delivery throughput** with 0% merge conflicts. |
| 🛡️ **Anti-Rubber-Stamp Rigor** | Reviewers read code diffs and worker praise ("all tests passed"), blindly stamping approvals while missing bugs. | **Physical Input Isolation**: Worker self-evaluations are scrubbed. Reviewers independently deduce expectations from specs and are **forbidden from modifying implementation code** (report only, never fix). |
| 🔒 **Build Cache & Port Immunity** | Concurrent tests fight for locks (`target/` or `.cargo`) or collide on shared network ports. | **Sandboxed Build Isolation**: Dynamically injects isolated target directories (`CARGO_TARGET_DIR=target/subagents/...`) and dynamic ports (port 0 / mocks). |
| 🚀 **1:1 Paired Zero-Queue Flow** | Sequential reviews create long queues; one slow task halts the entire batch. | **Pipeline Zero-Queueing**: The instant any Worker finishes, its paired Reviewer is launched concurrently. Testing overlaps seamlessly with adjacent feature work. |
| 🎯 **Visual & Arithmetic UAT** | Headless unit tests pass, but the UI is broken for real users (modals cannot close, balances fail to close). | **Zero-Code Acceptance**: A dynamic probe captures real browser evidence (screenshots, network logs). Acceptance agents inspect screens with **zero source code access**, auditing arithmetic reconciliation. |
| 💰 **Extreme Cost Efficiency** | Relies on expensive flagship models (Pro/Opus) to avoid simple mistakes. | **100% Flash-Powered**: By converting fuzzy instructions into checklists and isolated commands, lightweight `flash` models achieve higher reliability at **80%+ lower token costs and latency**. |

---

## 💡 Example Usage (`/quad`)

Trigger Quad in Antigravity by prepending `/quad` to your prompt, or let the assistant auto-activate it during large multi-module refactoring tasks:

### 1. User Prompt
```text
/quad Refactor the order calculation and balance ledger modules: ensure 6-decimal fixed-point precision, and verify that the UI correctly updates balances upon checkout.
```

### 2. Orchestrator Triage (2D Batch Matrix)
The master orchestrator analyzes file dependencies and outputs a non-overlapping execution plan:
```markdown
### Orchestration Plan (2D Batch Matrix)
- [Batch 1 (Concurrent Feature Workers)]:
  * Worker 1 (Order Calc) ➔ Exclusive File: [`crates/order/src/calc.rs`]
  * Worker 2 (Balance Ledger) ➔ Exclusive File: [`crates/settle/src/ledger.rs`]
  - Files are completely disjoint ($Files(W1) \cap Files(W2) = \emptyset$). Dispatched simultaneously in a single call.
- [Batch 2 (Dependent Integration)]:
  * Worker 3 (API Gateway) ➔ Exclusive File: [`crates/gateway/src/handler.rs`]
    - Non-concurrency Evidence: Relies on newly exported traits from Batch 1.
```

### 3. Execution & Independent Review (1:1 Paired Flow)
1. **Worker 1 & Worker 2** code concurrently in isolated build sandboxes (`CARGO_TARGET_DIR=target/subagents/worker-{ID}`).
2. The instant **Worker 1** finishes, **Reviewer 1** is spawned with strict input isolation:
   - Worker 1's self-evaluative conclusions are scrubbed.
   - Reviewer 1 receives concrete acceptance numbers: `50 shares * 10.25¢ = $5.13 frozen`.
   - Reviewer 1 creates exclusive test `tests/test_calc.rs` and checks the defect checklist (zero, overflow, precision).
3. **Worker 2** and **Reviewer 2** advance simultaneously without queue blocking.

### 4. User-Perspective UAT (Zero Code Access)
Since the task touches UI and financial balances:
- A dynamic probe script spins up a real browser, places an order, and saves screenshots and scraped values to `.data/investigation/uat-01/`.
- The **Acceptance Subagent** (`research`, strictly zero source code access) verifies on-screen values:
  $$\text{Available } \$94.87 + \text{Frozen } \$5.13 = \text{Total } \$100.00 \quad (\text{CLOSED } \checkmark)$$

### 5. Atomic Convergence
The master orchestrator runs `git status --short` to audit physical files, passes full test gates, and commits changes atomically per task!

---

## 🎯 Three Core Design Philosophies

- 🔹 **Flash executes verbs, not adjectives**  
  Demands like "adversarial deduction," "exhaustive check," or "deep audit" are ignored by compact models. Quality guarantees must be formulated as **checkable defect matrices** and **pre-filled, copy-paste executable terminal commands**.
- 🔹 **Independence comes from input isolation, not prompt sentiment**  
  Never yell at an LLM (*"find bugs or you fail"*). Emotional prompting creates noisy trivial edge cases. True independence is achieved by **physically stripping self-evaluations and implementation code from the reviewer's and acceptance tester's context**.
- 🔹 **Keep judgment with humans & orchestrators; delegate execution to flash**  
  Expected acceptance numbers must originate from specifications, mathematical formulas, or human operators. **AI subagents are strictly forbidden from inventing acceptance numbers.**

---

## 🎭 Four Specialized Roles Matrix

All subagents execute under `Model: "flash"` and `Workspace: "inherit"` within a single Git working branch:

| Role | Native TypeName | Reasoning Effort | Core Responsibility | Forbidden Boundaries |
| :--- | :--- | :--- | :--- | :--- |
| 🔍 **Scout** | `research` (read-only) | Low (Fast Direct Mode) | Read-only discovery of symbols, call graphs, PRDs, and contracts | Forbidden to create/modify files; forbidden to execute destructive commands |
| 🛠️ **Worker** | `self` | High (Deep Deduction) | Exclusive file ownership for feature coding; writes happy-path unit tests | Forbidden to touch unauthorized files; forbidden to run Git write commands; forbidden from emitting self-evaluative conclusions |
| 🛡️ **Reviewer** | `code-reviewer` | High (Deep Deduction) | Independent verification against task specifications; writes edge/negative tests; **reports only, never fixes** | **Forbidden to modify non-test files**; forbidden to deduce expectations from code diff; forbidden to issue sign-offs |
| 🎯 **Acceptance** | `research` (read-only) | Low to Medium | Inspects runtime evidence (screenshots/HAR/logs) against scenario cards; reconciles arithmetic balance | **Strictly forbidden from reading any source code**; forbidden to write code; validates that on-screen numbers close arithmetically |

---

## 🔄 Six-Stage Orchestration Pipeline

```mermaid
flowchart TD
    A["Stage 1: Task Triage & 2D Batch Matrix"] --> B["Stage 2: Reconnaissance (Scout Read-Only)"]
    B --> C["Stage 3: Single-Point Coding (Batch 1 Workers Concurrent Write)"]
    C --> D["Stage 4: Independent Verification (1:1 Paired Reviewers)"]
    D -->|Defect Discovered| C
    D -->|Tests Pass + Physical Check| E{"Affects UI or Financial Balances?"}
    E -- Yes --> F["Stage 5: Dynamic Probe + Zero-Code Acceptance (Reconcile Numbers)"]
    E -- No --> G["Stage 6: Physical Fact Audit & Orchestrator Gate"]
    F -->|Balances Reconciled| G
    F -->|Discrepancy Found| C
    G --> H["Atomic Git Commits per Task"]
```

### 1. Task Triage & 2D Batch Matrix
Worker concurrency is governed strictly by source file disjointness:
$$Files(Worker_A) \cap Files(Worker_B) = \emptyset \implies \text{Must dispatch concurrently in a single } invoke\_subagent \text{ call}$$
Serialization requires concrete evidence: unresolved physical compile symbol dependencies or unavoidable file collisions.

### 2. Reconnaissance & Two-Step Circuit Breaker
Scouts map symbols and contracts in seconds. The master orchestrator follows a two-step circuit breaker, never wasting context window reading extensive business logic in the main session.

### 3. Isolated Feature Coding (No Lock Contention)
Each Worker is granted exclusive ownership of specific source files and injected with isolated build caches (e.g., `CARGO_TARGET_DIR=target/subagents/worker-{ID}`).

### 4. Independent Verification (Input Isolation & Report Only)
- Paired 1:1 with workers the instant they deliver—zero queue latency;
- Orchestrators scrub all self-evaluative praise before dispatching prompts to reviewers;
- Reviewers author reproducing failing tests upon finding bugs, **keeping them red**. Fixing is returned to the Worker.

### 5. User-Perspective Acceptance (Zero-Code Visual & Math Check)
For UI or financial changes, a probe worker captures real browser screenshots and scraped values. The Acceptance subagent verifies that what the user sees satisfies mathematical identities, completely isolated from source code.

### 6. Convergence & Atomic Commits
The master orchestrator acts as the sole Git writer, runs `git status --short` to audit physical files, runs full test gates, and commits changes atomically per task.

---

## 🚀 One-Liner Quick Installation

Run either command in your terminal to install Quad and activate it instantly in Antigravity:

### Option A: Native Git One-Liner (Recommended)

```bash
git clone https://github.com/elias-zhao/antigravity-quad.git ~/.gemini/config/skills/quad
```

> 💡 **How to Update**: Whenever a new version is released, simply run:  
> `cd ~/.gemini/config/skills/quad && git pull`

---

### Option B: Curl Automated Installation

```bash
curl -fsSL https://raw.githubusercontent.com/elias-zhao/antigravity-quad/main/scripts/install.sh | bash
```

---

## 📄 License

This project is licensed under the [MIT License](LICENSE) - see the LICENSE file for details.
