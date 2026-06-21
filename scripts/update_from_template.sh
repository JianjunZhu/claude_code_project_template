#!/usr/bin/env bash
# =============================================================================
# update_from_template.sh —— 把模板的「规则 / 脚手架文件」更新到本项目
#
# 适用于"从模板派生、已经在做的项目"：当模板的规则更新后，把规则文件同步过来，
# 而【绝不触碰】本项目自有内容（docs/PROJECT.md、EVIDENCE.md、实验 / 数据 / 结果、
# 代码等）。只同步下方 ALLOW 列表里"模板拥有的文件"。
# 可选 --scaffold：额外补缺新目录脚手架（src/ results/ reports/ 等），只新建缺失、绝不覆盖。
# 不自动提交 —— 改完请自行 `git diff` 审阅后再 `git commit`。
#
# 用法：scripts/update_from_template.sh --template <模板路径或URL> [-r <ref>] [--dry-run] [-f]
# 详见 -h。
# =============================================================================
set -euo pipefail
PROG="$(basename "$0")"

# —— 模板拥有的文件（会被同步 / 覆盖）。项目自有内容一律不在此列，故不会被动到。——
ALLOW=(
  CLAUDE.md
  docs/RESEARCH_RULES.md
  docs/RESEARCH_LOOP.md
  configs/task_types
  scripts/bootstrap_new_project.sh
  scripts/update_from_template.sh
)

# —— 可选脚手架（--scaffold）：新目录的约定文件。语义 = 只补缺、绝不覆盖已有。——
SCAFFOLD_FILES=(
  src/README.md
  third_party/README.md
  results/README.md
  reports/README.md
  reports/SUMMARY.md
  reports/archive/.gitkeep
  configs/experiments/README.md
  data/raw/.gitkeep
  data/processed/.gitkeep
  data/validation/.gitkeep
)

usage() {
  cat <<'EOF'
用法：scripts/update_from_template.sh --template <模板路径或URL> [选项]

把模板的【规则 / 脚手架文件】更新到当前项目（只覆盖模板拥有的文件，不动你的
PROJECT.md / EVIDENCE.md / EXPERIMENT_LOG / PAPER_NOTES / 实验 / 数据 / 结果 / 代码）。
不自动提交，改完请自行 git diff 审阅 + commit。

模板来源（三选一）：
  --template <路径|URL>   本地 git 仓库路径，或 git URL（将浅克隆到临时目录）
  （或事先 git remote add template <url>，则可省略 --template）

可选：
  -r, --ref <ref>         模板 ref（默认 main；建议用 tag，如 v0.3-template）
      --scaffold          额外补缺新目录脚手架（src/ third_party/ results/ reports/
                          configs/experiments/ data/{raw,processed,validation}/ 的约定文件）；
                          只新建缺失文件、绝不覆盖已有，适合让旧项目补上新目录结构
      --dry-run           只预览将更新 / 新建哪些文件，不写入
  -f, --force             工作区不干净时仍继续（默认要求干净，便于 review）
  -h, --help

同步范围：
  规则文件（会覆盖）：CLAUDE.md, docs/RESEARCH_RULES.md, docs/RESEARCH_LOOP.md,
    configs/task_types/*, scripts/bootstrap_new_project.sh, scripts/update_from_template.sh
  脚手架（仅 --scaffold，只补缺不覆盖）：src/README.md, third_party/README.md, results/README.md,
    reports/{README,SUMMARY}.md, reports/archive/.gitkeep, configs/experiments/README.md,
    data/{raw,processed,validation}/.gitkeep
EOF
}
die() { printf 'ERROR: %s\n' "$1" >&2; exit 1; }

need_val() { [[ -n "${2:-}" && "${2:-}" != -* ]] || die "$1 需要一个值（且不能以 - 开头）"; }

TPL=""; REF="main"; DRY=0; FORCE=0; SCAFFOLD=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --template)  need_val "$1" "${2:-}"; TPL="$2"; shift 2;;
    -r|--ref)    need_val "$1" "${2:-}"; REF="$2"; shift 2;;
    --scaffold)  SCAFFOLD=1; shift;;
    --dry-run)   DRY=1; shift;;
    -f|--force)  FORCE=1; shift;;
    -h|--help)   usage; exit 0;;
    *)           die "未知参数：$1（用 -h 查看用法）";;
  esac
done

CLEANUP=""; STAGE=""; SCAF_STAGE=""
_cleanup() { [[ -n "$CLEANUP" ]] && rm -rf "$CLEANUP"; [[ -n "$STAGE" ]] && rm -rf "$STAGE"; [[ -n "$SCAF_STAGE" ]] && rm -rf "$SCAF_STAGE"; }
trap _cleanup EXIT

# 必须在项目 git 仓库内
PROJ_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || die "请在项目 git 仓库内运行本脚本"
cd "$PROJ_ROOT"

# 工作区须干净（把本次同步作为一笔可 review 的独立改动）
if [[ -n "$(git status --porcelain)" && "$FORCE" -ne 1 ]]; then
  die "工作区有未提交改动；请先 commit / stash 再同步（或加 -f）。这样同步结果才便于 review。"
fi

# 解析模板来源
if [[ -z "$TPL" ]]; then
  TPL="$(git remote get-url template 2>/dev/null || true)"
  [[ -n "$TPL" ]] || die "未指定 --template，且无 template 远程；请 --template <路径|URL>。"
fi
if [[ "$TPL" == *://* || "$TPL" == *@*:* ]]; then
  CLEANUP="$(mktemp -d)"
  git clone --quiet "$TPL" "$CLEANUP" || die "克隆模板失败：$TPL"
  TPLDIR="$CLEANUP"
else
  TPLDIR="$(cd "$TPL" 2>/dev/null && pwd)" || die "模板路径不存在：$TPL"
  git -C "$TPLDIR" rev-parse --show-toplevel >/dev/null 2>&1 || die "不是 git 仓库：$TPL"
fi

# 校验 ref
git -C "$TPLDIR" rev-parse --verify --quiet "${REF}^{commit}" >/dev/null \
  || die "模板中不存在 ref：$REF"
SRC_FULL="$(git -C "$TPLDIR" rev-parse "${REF}^{commit}")"
SRC_SHORT="$(git -C "$TPLDIR" rev-parse --short "${REF}^{commit}")"
SRC_DESC="$(git -C "$TPLDIR" describe --tags --always "${REF}^{commit}" 2>/dev/null || echo "$SRC_SHORT")"

# 过滤出模板该 ref 下确实存在的同步路径（避免 archive 因缺路径报错）
TREE="$(git -C "$TPLDIR" ls-tree -r --name-only "$REF")"
exists() { printf '%s\n' "$TREE" | grep -qx "$1" || printf '%s\n' "$TREE" | grep -q "^$1/"; }
SPECS=(); for a in "${ALLOW[@]}"; do exists "$a" && SPECS+=("$a"); done
[[ ${#SPECS[@]} -gt 0 ]] || die "模板 ${REF} 下没有可同步的规则文件"

# 先暂存到临时目录，逐文件分类（新增 / 更新 / 未变），既支持 dry-run 也避免半途写坏
STAGE="$(mktemp -d)"
git -C "$TPLDIR" archive "$REF" -- "${SPECS[@]}" | tar -x -C "$STAGE"

NEW=(); UPD=(); SAME=()
while IFS= read -r f; do
  rel="${f#"$STAGE"/}"
  if [[ ! -f "$rel" ]]; then NEW+=("$rel")
  elif cmp -s "$f" "$rel"; then SAME+=("$rel")
  else UPD+=("$rel"); fi
done < <(find "$STAGE" -type f)

# —— 可选脚手架：补缺新目录的约定文件（只创建缺失的，绝不覆盖已有）——
SCAF_CREATE=()
if [[ "$SCAFFOLD" -eq 1 ]]; then
  SCAF_SPECS=(); for s in "${SCAFFOLD_FILES[@]}"; do exists "$s" && SCAF_SPECS+=("$s"); done
  if [[ ${#SCAF_SPECS[@]} -gt 0 ]]; then
    SCAF_STAGE="$(mktemp -d)"
    git -C "$TPLDIR" archive "$REF" -- "${SCAF_SPECS[@]}" | tar -x -C "$SCAF_STAGE"
    while IFS= read -r f; do
      rel="${f#"$SCAF_STAGE"/}"
      [[ -e "$rel" ]] || SCAF_CREATE+=("$rel")
    done < <(find "$SCAF_STAGE" -type f)
  fi
fi

echo "模板来源：${SRC_DESC} @ ${SRC_SHORT}（${TPL}）"
echo "更新 ${#UPD[@]} ・ 新增 ${#NEW[@]} ・ 未变 ${#SAME[@]}"
if [[ ${#UPD[@]} -gt 0 ]]; then for f in "${UPD[@]}"; do echo "  ~ 更新 $f"; done; fi
if [[ ${#NEW[@]} -gt 0 ]]; then for f in "${NEW[@]}"; do echo "  + 新增 $f"; done; fi
if [[ "$SCAFFOLD" -eq 1 ]]; then
  echo "脚手架补缺 ${#SCAF_CREATE[@]}（只新建缺失目录文件，不覆盖已有）"
  if [[ ${#SCAF_CREATE[@]} -gt 0 ]]; then for f in "${SCAF_CREATE[@]}"; do echo "  + 脚手架 $f"; done; fi
fi

if [[ "$DRY" -eq 1 ]]; then
  echo "（--dry-run：未写入任何文件）"; exit 0
fi
if [[ ${#UPD[@]} -eq 0 && ${#NEW[@]} -eq 0 && ${#SCAF_CREATE[@]} -eq 0 ]]; then
  echo "已是最新，无需更新。"; exit 0
fi

# 实际写入：只覆盖 ALLOW 范围内文件（项目自有内容不在范围内，绝不被动）
git -C "$TPLDIR" archive "$REF" -- "${SPECS[@]}" | tar -x -C "$PROJ_ROOT"

# 写入脚手架：只创建缺失文件（绝不覆盖已有项目内容）
if [[ ${#SCAF_CREATE[@]} -gt 0 ]]; then
  for rel in "${SCAF_CREATE[@]}"; do
    mkdir -p "$(dirname "$PROJ_ROOT/$rel")"
    cp "$SCAF_STAGE/$rel" "$PROJ_ROOT/$rel"
  done
fi

# 记录同步来源（可追溯）
printf 'synced-from: %s @ %s\nsynced-at: %s\nby: %s\n' \
  "$SRC_DESC" "$SRC_FULL" "$(date +%F)" "$PROG" > "$PROJ_ROOT/.template-sync"

echo
echo "✅ 已同步模板规则到 ${SRC_DESC}（脚手架补缺 ${#SCAF_CREATE[@]} 个）。项目自有内容（PROJECT / EVIDENCE / 实验 / 数据 / 结果）未改动。"
echo "下一步：git diff 审阅改动 → 满意后 git add -A && git commit。"
echo "（若某规则文件你本地有定制被覆盖，可对该文件 git checkout -- <文件> 撤销本次覆盖。）"
