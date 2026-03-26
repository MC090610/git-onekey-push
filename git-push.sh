#!/bin/bash

# ========================
# Git 一键提交推送脚本（强制要求指定目录）
# 使用示例：
#   ./git-push.sh --dir rbkhic-hexo -删除了无用文件
#   ./git-push.sh -dir rbkhic-hexo "更新内容"
# ========================

FORCE=false
COMMIT_MSG=""
TARGET_DIR=""

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# ==================== 参数解析 ====================
while [[ $# -gt 0 ]]; do
    case "$1" in
        -y|--yes)
            FORCE=true
            shift
            ;;

        --dir=*)
            TARGET_DIR="${1#*=}"
            shift
            ;;

        --dir)
            TARGET_DIR="$2"
            shift 2
            ;;

        -dir=*)
            TARGET_DIR="${1#*=}"
            shift
            ;;

        -dir)
            TARGET_DIR="$2"
            shift 2
            ;;

        *)
            # 其它所有参数都视为提交信息
            COMMIT_MSG="$1"
            shift
            ;;
    esac
done

# ==================== 强制必须指定目录 ====================
if [[ -z "$TARGET_DIR" ]]; then
    echo "❌ 错误：必须指定目录！"
    echo "用法示例："
    echo "  ./git-push.sh --dir rbkhic-hexo -删除了无用文件"
    exit 1
fi

# ==================== 切换目录 ====================
if [[ -d "$SCRIPT_DIR/$TARGET_DIR" ]]; then
    echo "📂 已指定目录：$TARGET_DIR"
    echo "➡ 切换到：$SCRIPT_DIR/$TARGET_DIR"
    cd "$SCRIPT_DIR/$TARGET_DIR" || exit 1
else
    echo "❌ 错误：指定的目录不存在：$SCRIPT_DIR/$TARGET_DIR"
    exit 1
fi

echo "🚀 Git 一键提交脚本启动..."

# ==================== Git 检查 ====================
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "❌ 错误：该目录不是 Git 仓库！"
    exit 1
fi

# ==================== 强制模式处理 ====================
if $FORCE; then
    echo "⚡ 已启用强制模式 (-y)，跳过确认..."
else
    echo "📊 ===== git status ====="
    git status --short
    echo "========================"

    echo -e "\n📜 最近 5 次提交："
    git log --oneline -5
    echo "========================"

    echo -e "\n❓ 是否继续执行？输入 y/Y 确认："
    read -r confirm

    if [[ ! "$confirm" =~ ^[Yy] ]]; then
        echo "❌ 已取消操作。"
        exit 0
    fi
fi

# ==================== 处理提交信息 ====================
if [[ -z "$COMMIT_MSG" ]]; then
    COMMIT_MSG="Auto commit: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "⚠️ 未提供提交信息，使用默认：$COMMIT_MSG"
else
    echo "💬 提交信息：$COMMIT_MSG"
fi

# ==================== Git 操作 ====================
echo -e "\n➕ git add --all ..."
git add --all

echo -e "\n💾 执行 git commit ..."
if git commit -m "$COMMIT_MSG"; then
    echo "✅ Commit 成功"
else
    echo "⚠️ 没有内容可提交"
fi

echo -e "\n🚀 执行 git push ..."
if git push; then
    echo "🎉 Push 成功，已完成。"
else
    echo "❌ Push 失败"
fi

echo -e "\n✅ 脚本执行完毕。"