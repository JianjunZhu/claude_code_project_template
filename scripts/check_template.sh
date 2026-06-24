#!/usr/bin/env bash
# =============================================================================
# check_template.sh —— 模板自检（机械不变量 linter）
#
# 检查本仓库（模板或派生项目）是否满足一组**机械可判**的结构 / 卫生不变量：
#   1. 所有 *.sh 通过 bash -n 语法检查
#   2. 没有以 ```math 标注的代码围栏（VS Code 不渲染，模板禁用）
#   3. 没有"扁平" docs/<名>.md 引用（应为 docs/rules/ 或 docs/records/；
#      changelog 历史行除外，那里保留过去路径属于追加式历史）
#   4. 所有指向 .md 的本地 markdown 链接都能解析到真实文件（按各文件所在目录解析相对路径）
#   5. update_from_template.sh 的 ALLOW 规则文件都存在
#   6. docs/rules/ 与 docs/records/ 目录及其应有文件齐备
#   7. 追加式空目录里有 .gitkeep（归档目录不被 git 丢弃）
#
# 注意：这是**机械检查**，不判断"是否造假"——语义层面的反造假（指标 / 结论是否有
# artifact 支持）须靠 CLAUDE.md / RESEARCH_RULES.md 的人审与证据纪律，linter 不替代。
#
# 用法：scripts/check_template.sh            # 全部检查，有失败则退出码非 0
#       scripts/check_template.sh --quiet    # 仅打印失败与汇总
#       scripts/check_template.sh -h
# 适合挂 pre-commit / CI。bash 3.2 兼容。
# =============================================================================
set -uo pipefail
PROG="$(basename "$0")"

QUIET=0
case "${1:-}" in
  -h|--help)
    sed -n '2,28p' "$0" | sed 's/^# \{0,1\}//'; exit 0;;
  --quiet) QUIET=1;;
  "") :;;
  *) printf 'ERROR: 未知参数：%s（用 -h 查看用法）\n' "$1" >&2; exit 2;;
esac

ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "ERROR: 请在 git 仓库内运行" >&2; exit 2; }
cd "$ROOT"

FAILS=0          # 失败的检查项数
RED=''; GRN=''; YEL=''; RST=''
if [ -t 1 ]; then RED=$'\033[31m'; GRN=$'\033[32m'; YEL=$'\033[33m'; RST=$'\033[0m'; fi

pass() { [ "$QUIET" -eq 1 ] || printf '  %sPASS%s %s\n' "$GRN" "$RST" "$1"; }
fail() { printf '  %sFAIL%s %s\n' "$RED" "$RST" "$1"; FAILS=$((FAILS+1)); }
note() { [ "$QUIET" -eq 1 ] || printf '  %s· %s%s\n' "$YEL" "$1" "$RST"; }
hdr()  { [ "$QUIET" -eq 1 ] || printf '\n%s\n' "$1"; }

DOC_NAMES='PROJECT|TASK_BRIEF|EVIDENCE|EXPERIMENT_LOG|RESULT_AUDIT|PAPER_NOTES|RESEARCH_RULES|RESEARCH_LOOP|TEMPLATE_CHANGELOG'

# —— 1. bash -n 语法 ——
hdr "[1] shell 脚本语法（bash -n）"
while IFS= read -r f; do
  [ -n "$f" ] || continue
  if bash -n "$f" 2>/dev/null; then pass "$f"; else fail "$f 语法错误（bash -n）"; fi
done < <(git ls-files '*.sh')

# —— 2. 禁用 ```math 围栏 ——
hdr "[2] 无 \`\`\`math 代码围栏"
# 仅匹配"行首（可缩进）的代码围栏"，不误伤行内反引号里提到 ```math 的散文
mathhits="$(git grep -nE '^[[:space:]]*```math' -- '*.md' 2>/dev/null || true)"
if [ -z "$mathhits" ]; then pass "未发现 \`\`\`math 围栏"; else
  fail "发现 \`\`\`math 围栏（VS Code 不渲染，请改用 \$\$ ... \$\$）："; printf '%s\n' "$mathhits" | sed 's/^/      /'
fi

# —— 3. 无扁平 docs/<名>.md 引用（changelog 历史除外）——
hdr "[3] 无扁平 docs/<名>.md 引用（应为 docs/rules/ 或 docs/records/）"
flat="$(git grep -noE "docs/($DOC_NAMES)\.md" -- . ':!docs/rules/TEMPLATE_CHANGELOG.md' 2>/dev/null \
        | grep -vE 'docs/(rules|records)/' || true)"
if [ -z "$flat" ]; then pass "所有引用都在 docs/rules/ 或 docs/records/ 下"; else
  fail "发现扁平引用（旧布局，应迁移到 rules/ 或 records/）："; printf '%s\n' "$flat" | sed 's/^/      /'
fi

# —— 4. markdown 链接目标可解析 ——
hdr "[4] 本地 markdown 链接（指向 .md）可解析"
broken=0
while IFS= read -r mdfile; do
  [ -n "$mdfile" ] || continue
  dir="$(dirname "$mdfile")"
  # 抽取 ](target) 中以 .md（可带 #anchor）结尾、非 http 的目标
  while IFS= read -r target; do
    [ -n "$target" ] || continue
    case "$target" in http://*|https://*|'#'*) continue;; esac
    t="${target%%#*}"                      # 去掉 #anchor
    [ -n "$t" ] || continue
    if ! ( cd "$dir" 2>/dev/null && [ -e "$t" ] ); then
      fail "$mdfile → 链接目标不存在：$target"; broken=$((broken+1))
    fi
  done < <(grep -oE '\]\([^)]+\.md(#[^)]*)?\)' "$mdfile" | sed -E 's/^\]\(//; s/\)$//')
done < <(git ls-files '*.md')
[ "$broken" -eq 0 ] && pass "所有 .md 链接目标均存在"

# —— 5. ALLOW 规则文件存在 ——
hdr "[5] update_from_template ALLOW 规则文件齐备"
ALLOW="CLAUDE.md docs/rules/RESEARCH_RULES.md docs/rules/RESEARCH_LOOP.md docs/rules/TEMPLATE_CHANGELOG.md configs/task_types scripts/bootstrap_new_project.sh scripts/update_from_template.sh scripts/check_template.sh"
miss5=0
for p in $ALLOW; do [ -e "$p" ] || { fail "缺少 ALLOW 路径：$p"; miss5=$((miss5+1)); }; done
[ "$miss5" -eq 0 ] && pass "ALLOW 列表全部存在"

# —— 6. rules / records 目录与应有文件 ——
hdr "[6] docs/rules 与 docs/records 结构齐备"
miss6=0
for p in docs/rules/RESEARCH_RULES.md docs/rules/RESEARCH_LOOP.md docs/rules/TEMPLATE_CHANGELOG.md \
         docs/records/PROJECT.md docs/records/TASK_BRIEF.md docs/records/EVIDENCE.md \
         docs/records/EXPERIMENT_LOG.md docs/records/RESULT_AUDIT.md docs/records/PAPER_NOTES.md; do
  [ -f "$p" ] || { fail "缺少：$p"; miss6=$((miss6+1)); }
done
# 不应再有扁平 docs/<名>.md 文件残留
stray="$(git ls-files "docs/*.md" | grep -vE '^docs/(rules|records)/' || true)"
[ -z "$stray" ] || { fail "docs/ 根下有未迁移的扁平文件："; printf '%s\n' "$stray" | sed 's/^/      /'; miss6=$((miss6+1)); }
[ "$miss6" -eq 0 ] && pass "rules/ + records/ 文件齐备，无扁平残留"

# —— 7. 追加式空目录有 .gitkeep ——
hdr "[7] 追加式空目录保有 .gitkeep"
miss7=0
for d in experiments/records experiments/records_archive reports/archive data/raw data/processed data/validation; do
  if [ -d "$d" ]; then
    [ -f "$d/.gitkeep" ] || git ls-files "$d" | grep -q . || { fail "$d 既无 .gitkeep 也无跟踪文件（可能被 git 丢弃）"; miss7=$((miss7+1)); }
  fi
done
[ "$miss7" -eq 0 ] && pass ".gitkeep / 跟踪文件在位"

# —— 汇总 ——
printf '\n'
if [ "$FAILS" -eq 0 ]; then
  printf '%s✅ 模板自检通过：所有机械不变量满足。%s\n' "$GRN" "$RST"
  exit 0
else
  printf '%s❌ 模板自检失败：%d 项不通过（见上）。%s\n' "$RED" "$FAILS" "$RST"
  exit 1
fi
