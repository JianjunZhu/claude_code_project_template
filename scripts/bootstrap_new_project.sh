#!/usr/bin/env bash
# =============================================================================
# bootstrap_new_project.sh —— 从本科研模板一键派生新项目
#
# 作用：把模板在指定 git ref（默认 HEAD，可指定 tag/commit）的【已提交】内容导出
#       到新目录，重置为全新 git 历史，并写入可追溯的派生信息（模板 ref + commit
#       hash + 日期 + 项目名）。
# 不做：不编造任何项目事实（占位符与 TBD/PENDING 原样保留，待你填）；不自动 push
#       （仅在你传 --remote 时绑定 origin）。
#
# 用法：scripts/bootstrap_new_project.sh -n <项目名> [选项]
# 详见 -h。
# =============================================================================
set -euo pipefail

PROG="$(basename "$0")"

usage() {
  cat <<'EOF'
用法：scripts/bootstrap_new_project.sh -n <项目名> [选项]

从本科研模板一键派生新项目：把模板（默认 HEAD，可指定 tag/commit）的已提交内容
导出到新目录，重置为全新 git 历史，并写入可追溯的派生信息。不编造任何项目事实，
不自动 push。

必填：
  -n, --name <名称>        新项目名称

可选：
  -d, --dir  <路径>        目标目录（默认 ../<名称>，即模板上层目录下同名文件夹）
  -r, --ref  <ref>         从模板的哪个 commit/tag 派生（默认 HEAD；如 v0-template）
  -t, --task-type <类型>   记录启用的任务类型（如 segmentation；仅写入派生信息，不删其他配置）
      --remote <url>       绑定新项目 git 远程为 origin（不自动 push）
  -f, --force              目标目录已存在且非空时仍继续
  -h, --help               显示本帮助

示例：
  scripts/bootstrap_new_project.sh -n liver-seg -t segmentation
  scripts/bootstrap_new_project.sh -n my-bench -r v0-template \
      --remote git@github.com:me/my-bench.git
EOF
}

die() { printf 'ERROR: %s\n' "$1" >&2; exit 1; }
# 取值型参数校验：值缺失或以 - 开头（多半是漏写了值、误吞了下一个参数）即报错
need_val() { [[ -n "${2:-}" && "${2:-}" != -* ]] || die "$1 需要一个值（且不能以 - 开头）；用 -h 查看用法"; }

NAME=""; DIR=""; REF="HEAD"; TASKTYPE=""; REMOTE=""; FORCE=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    -n|--name)      need_val "$1" "${2:-}"; NAME="$2"; shift 2;;
    -d|--dir)       need_val "$1" "${2:-}"; DIR="$2"; shift 2;;
    -r|--ref)       need_val "$1" "${2:-}"; REF="$2"; shift 2;;
    -t|--task-type) need_val "$1" "${2:-}"; TASKTYPE="$2"; shift 2;;
    --remote)       need_val "$1" "${2:-}"; REMOTE="$2"; shift 2;;
    -f|--force)     FORCE=1; shift;;
    -h|--help)      usage; exit 0;;
    *)              die "未知参数：$1（用 -h 查看用法）";;
  esac
done

[[ -n "$NAME" ]] || { usage; echo; die "缺少 -n/--name 项目名称"; }

# 定位模板仓库根（脚本须位于模板 git 仓库内）
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_ROOT="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel 2>/dev/null)" \
  || die "脚本不在 git 仓库内，无法确定模板根目录"

# 校验 ref 存在
git -C "$TEMPLATE_ROOT" rev-parse --verify --quiet "${REF}^{commit}" >/dev/null \
  || die "模板中不存在 ref：$REF"

# 校验 git 身份（开跑前快速失败，避免留下半成品目录）
git -C "$TEMPLATE_ROOT" config user.email >/dev/null 2>&1 \
  || die "git 身份未配置：请先 git config --global user.name \"你的名字\" 与 user.email \"you@example.com\""

# 目标目录（默认 ../<名称>）
[[ -n "$DIR" ]] || DIR="$(dirname "$TEMPLATE_ROOT")/$NAME"
if [[ -e "$DIR" ]]; then
  if [[ -d "$DIR" && -z "$(ls -A "$DIR" 2>/dev/null)" ]]; then
    : # 空目录可用
  elif [[ "$FORCE" -eq 1 ]]; then
    printf 'WARN: 目标已存在且非空，--force 继续：%s\n' "$DIR" >&2
  else
    die "目标目录已存在且非空：$DIR（用 -f/--force 覆盖式继续）"
  fi
fi

# 脏工作树提醒（archive 只导出已提交内容）
if [[ "$REF" == "HEAD" && -n "$(git -C "$TEMPLATE_ROOT" status --porcelain)" ]]; then
  printf 'WARN: 模板工作树有未提交改动，这些改动不会被导出（archive 仅含已提交内容）。\n' >&2
fi

# 任务类型存在性提醒（不阻断）
if [[ -n "$TASKTYPE" && ! -f "$TEMPLATE_ROOT/configs/task_types/${TASKTYPE}.md" ]]; then
  printf 'WARN: 未找到 configs/task_types/%s.md（仍记录，请确认拼写）。\n' "$TASKTYPE" >&2
fi

# 采集派生信息（真实可追溯事实）；解引用到提交，注解标签也记录其指向的 commit hash
SRC_HASH="$(git -C "$TEMPLATE_ROOT" rev-parse "${REF}^{commit}")"
SRC_SHORT="$(git -C "$TEMPLATE_ROOT" rev-parse --short "${REF}^{commit}")"
SRC_DESC="$(git -C "$TEMPLATE_ROOT" describe --tags --always "$REF" 2>/dev/null || echo "$SRC_SHORT")"
DATE="$(date +%F)"

mkdir -p "$DIR"
# 导出模板内容：仅已提交的跟踪文件，不含模板的 .git 历史
git -C "$TEMPLATE_ROOT" archive --format=tar "$REF" | tar -x -C "$DIR"

# 写入派生信息到 docs/PROJECT.md（插入到 H1 标题之后），不改动占位符正文
PROJ="$DIR/docs/PROJECT.md"
if [[ -f "$PROJ" ]]; then
  BLOCK="$(cat <<EOF
> **派生信息（由 ${PROG} 自动写入，真实事实，请勿删除）**
>
> - 项目名称：${NAME}
> - 派生自模板：\`${SRC_DESC}\` @ \`${SRC_HASH}\`
> - 派生日期：${DATE}
> - 启用任务类型：${TASKTYPE:-未指定（TBD）}
>
> 下方原模板占位符（\`<...>\` 与 TBD / PENDING / NOT VERIFIED / INCOMPLETE）请按
> README 的「首次使用步骤」逐项替换为真实值；未知保留占位符，**不得猜测或编造**。
EOF
)"
  TMP="$(mktemp)"
  { head -n 1 "$PROJ"; printf '\n%s\n' "$BLOCK"; tail -n +2 "$PROJ"; } > "$TMP"
  mv "$TMP" "$PROJ"
fi

# 重置为全新 git 历史
git -C "$DIR" init -q -b main 2>/dev/null \
  || { git -C "$DIR" init -q; git -C "$DIR" symbolic-ref HEAD refs/heads/main; }

git -C "$DIR" add -A
git -C "$DIR" commit -q \
  -m "初始化项目 ${NAME}（派生自模板 ${SRC_DESC}@${SRC_SHORT}）" \
  -m "由 ${PROG} 从科研项目模板派生并重置 git 历史。除派生信息与创建日期外无任何真实项目事实，均为占位符，待填充。"

# 可选绑定远程（不自动 push）
[[ -n "$REMOTE" ]] && git -C "$DIR" remote add origin "$REMOTE"

# 摘要
ABS_DIR="$(cd "$DIR" && pwd)"
cat <<EOF

✅ 已派生新项目：${NAME}
   目录        ：${ABS_DIR}
   源模板      ：${SRC_DESC} @ ${SRC_SHORT}
   分支        ：main（全新历史，1 个初始提交）
   任务类型    ：${TASKTYPE:-未指定}
   远程 origin ：${REMOTE:-未绑定}

下一步：
  1. cd "${ABS_DIR}"
  2. 按 README「首次使用步骤」填写 docs/PROJECT.md（已写入派生信息，占位符待补）
EOF
if [[ -n "$REMOTE" ]]; then
  printf '  3. 推送：git push -u origin main\n'
else
  printf '  3. 如需推送：git remote add origin <仓库地址> && git push -u origin main\n'
fi
