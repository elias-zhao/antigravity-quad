#!/usr/bin/env bash
# Antigravity Quad Skill 极速安装脚本
set -e

TARGET_DIR="${HOME}/.gemini/config/skills/quad"
REPO_URL="https://github.com/elias-zhao/antigravity-quad.git"

echo "⚡ 正在安装 Antigravity Quad 技能..."

mkdir -p "$(dirname "$TARGET_DIR")"

# 判断是否是本地脚本运行还是 curl 管道执行
if [ -n "${BASH_SOURCE[0]}" ] && [ -f "${BASH_SOURCE[0]}" ]; then
    LOCAL_REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
else
    LOCAL_REPO_DIR=""
fi

if [ -d "$TARGET_DIR" ] || [ -L "$TARGET_DIR" ]; then
    echo "💡 检测到已存在安装目标: $TARGET_DIR"
    if [ -d "$TARGET_DIR/.git" ]; then
        echo "🔄 正在拉取最新版本..."
        git -C "$TARGET_DIR" pull --ff-only || true
        echo "✅ 更新完成！"
        exit 0
    else
        rm -rf "$TARGET_DIR"
    fi
fi

if [ -n "$LOCAL_REPO_DIR" ] && [ -f "$LOCAL_REPO_DIR/SKILL.md" ]; then
    # 本地环境：建立软链
    ln -s "$LOCAL_REPO_DIR" "$TARGET_DIR"
    echo "✅ 本地软链安装成功！已链接至: $TARGET_DIR"
else
    # 远程 curl 管道环境：直接 clone
    echo "📥 正在从远程仓库克隆..."
    git clone "$REPO_URL" "$TARGET_DIR"
    echo "✅ 远程安装成功！已就绪于: $TARGET_DIR"
fi

echo "🎉 提示：现在可以在 Antigravity 中直接使用 quad 多智能体编排技能了！"
