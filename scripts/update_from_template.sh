#!/usr/bin/env bash
# =============================================================================
# update_from_template.sh —— 把模板的「规则 / 脚手架文件」更新到本项目，
#                            并把旧的扁平 docs/ 布局迁移到 docs/rules + docs/records
#
# 适用于"从模板派生、已经在做的项目"：当模板的规则更新后，把规则文件同步过来，
# 而【绝不触碰】本项目自有内容（docs/records/ 下的记录、实验 / 数据 / 结果 / 代码）。
# 只同步下方 ALLOW 列表里"模板拥有的文件"。
#
# 自 v0.4.0-template 起，docs/ 物理分为两类：
#   docs/rules/    规则文件（模板拥有，固定，仅本脚本同步）：RESEARCH_RULES / RESEARCH_LOOP / TEMPLATE_CHANGELOG
#   docs/records/  记录文件（项目自有，随项目更新，本脚本绝不覆盖）：PROJECT / TASK_BRIEF / EVIDENCE /
#                  EXPERIMENT_LOG / RESULT_AUDIT / PAPER_NOTES
# 早于该版本派生的项目，文档是扁平的 docs/*.md。本脚本检测到扁平布局时会【一次性迁移】：
#   · 记录文件：git mv docs/<名>.md → docs/records/<名>.md（保留你填写的项目内容）
#   · 规则文件：git rm docs/<名>.md（旧扁平址），新版本随同步落到 docs/rules/
# 迁移幂等（已迁移则跳过）、非破坏性（记录内容只移动、不被覆盖）。
#
# 可选 --scaffold：额外补缺新目录脚手架（src/ results/ reports/ 等），只新建缺失、绝不覆盖。
# 可选 --rewrite-refs：迁移后把项目文件正文里对 docs/<名>.md 的引用确定性改写为
#                      docs/{rules,records}/<名>.md（会触碰项目内容，默认关闭）。
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
  docs/rules/RESEARCH_RULES.md
  docs/rules/RESEARCH_LOOP.md
  docs/rules/TEMPLATE_CHANGELOG.md
  configs/task_types
  scripts/bootstrap_new_project.sh
  scripts/update_from_template.sh
)

# —— 旧→新布局迁移：扁平 docs/<名>.md 的归属 ——
#   记录文件（项目自有）：迁到 docs/records/，保留内容
RECORD_NAMES=(PROJECT TASK_BRIEF EVIDENCE EXPERIMENT_LOG RESULT_AUDIT PAPER_NOTES)
#   规则文件（模板拥有）：删除扁平址，新版本随同步落到 docs/rules/
RULE_NAMES=(RESEARCH_RULES RESEARCH_LOOP TEMPLATE_CHANGELOG)

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

把模板的【规则 / 脚手架文件】更新到当前项目，并把旧的扁平 docs/ 布局迁移到
docs/rules/ + docs/records/。只覆盖模板拥有的文件，绝不覆盖你的记录内容
（docs/records/ 下的 PROJECT / EVIDENCE / EXPERIMENT_LOG / RESULT_AUDIT /
PAPER_NOTES / TASK_BRIEF）与实验 / 数据 / 结果 / 代码。
不自动提交，改完请自行 git diff 审阅 + commit。

模板来源（三选一）：
  --template <路径|URL>   本地 git 仓库路径，或 git URL（将浅克隆到临时目录）
  （或事先 git remote add template <url>，则可省略 --template）

可选：
  -r, --ref <ref>         模板 ref（默认 main；建议用 tag，如 v0.4.0-template）
      --scaffold          额外补缺新目录脚手架（src/ third_party/ results/ reports/
                          configs/experiments/ data/{raw,processed,validation}/ 的约定文件）；
                          只新建缺失文件、绝不覆盖已有，适合让旧项目补上新目录结构
      --rewrite-refs      迁移后把项目文件正文里对 docs/<名>.md 的引用确定性改写为
                          docs/{rules,records}/<名>.md（会触碰项目内容，默认关闭）
      --dry-run           只预览将迁移 / 更新 / 新建哪些文件，不写入
  -f, --force             工作区不干净时仍继续（默认要求干净，便于 review）
  -h, --help

行为范围：
  布局迁移（自动，幂等）：扁平 docs/{PROJECT,TASK_BRIEF,EVIDENCE,EXPERIMENT_LOG,RESULT_AUDIT,
    PAPER_NOTES}.md → git mv 入 docs/records/（保留内容）；扁平 docs/{RESEARCH_RULES,
    RESEARCH_LOOP,TEMPLATE_CHANGELOG}.md → git rm（新版本随同步落到 docs/rules/）。
  规则文件（会覆盖）：CLAUDE.md, docs/rules/RESEARCH_RULES.md, docs/rules/RESEARCH_LOOP.md,
    docs/rules/TEMPLATE_CHANGELOG.md, configs/task_types/*, scripts/bootstrap_new_project.sh,
    scripts/update_from_template.sh
  脚手架（仅 --scaffold，只补缺不覆盖）：src/README.md, third_party/README.md, results/README.md,
    reports/{README,SUMMARY}.md, reports/archive/.gitkeep, configs/experiments/README.md,
    data/{raw,processed,validation}/.gitkeep
EOF
}
die() { printf 'ERROR: %s\n' "$1" >&2; exit 1; }

need_val() { [[ -n "${2:-}" && "${2:-}" != -* ]] || die "$1 需要一个值（且不能以 - 开头）"; }

TPL=""; REF="main"; DRY=0; FORCE=0; SCAFFOLD=0; REWRITE=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --template)     need_val "$1" "${2:-}"; TPL="$2"; shift 2;;
    -r|--ref)       need_val "$1" "${2:-}"; REF="$2"; shift 2;;
    --scaffold)     SCAFFOLD=1; shift;;
    --rewrite-refs) REWRITE=1; shift;;
    --dry-run)      DRY=1; shift;;
    -f|--force)     FORCE=1; shift;;
    -h|--help)      usage; exit 0;;
    *)              die "未知参数：$1（用 -h 查看用法）";;
  esac
done

CLEANUP=""; STAGE=""; SCAF_STAGE=""
_cleanup() { [[ -n "$CLEANUP" ]] && rm -rf "$CLEANUP"; [[ -n "$STAGE" ]] && rm -rf "$STAGE"; [[ -n "$SCAF_STAGE" ]] && rm -rf "$SCAF_STAGE"; return 0; }
trap _cleanup EXIT

# 必须在项目 git 仓库内
PROJ_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || die "请在项目 git 仓库内运行本脚本"
cd "$PROJ_ROOT"

# 工作区须干净（把本次同步 + 迁移作为一笔可 review 的独立改动）
if [[ -n "$(git status --porcelain)" && "$FORCE" -ne 1 ]]; then
  die "工作区有未提交改动；请先 commit / stash 再同步（或加 -f）。这样同步 / 迁移结果才便于 review。"
fi

# —— 计算旧→新布局迁移计划（只填充数组，不改文件）——
MIG_MV_SRC=(); MIG_MV_DST=(); MIG_RM=(); MIG_SKIP=()
for n in "${RECORD_NAMES[@]}"; do
  if [[ -f "docs/${n}.md" ]]; then
    if [[ -e "docs/records/${n}.md" ]]; then
      MIG_SKIP+=("docs/${n}.md → docs/records/${n}.md 已存在，两者并存，请手动确认后处理")
    else
      MIG_MV_SRC+=("docs/${n}.md"); MIG_MV_DST+=("docs/records/${n}.md")
    fi
  fi
done
for n in "${RULE_NAMES[@]}"; do
  [[ -f "docs/${n}.md" ]] && MIG_RM+=("docs/${n}.md")
done

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
[[ ${#SPECS[@]} -gt 0 ]] || die "模板 ${REF} 下没有可同步的规则文件（该 ref 是否 < v0.4.0-template？新布局需 docs/rules/）"

# —— 关键安全闸：若有迁移要做（要 git rm 扁平规则 / git mv 记录），所选 ref 必须真的含 docs/rules/，
#    否则会删掉扁平规则却无新版本可同步，导致项目缺失规则文件。早于 v0.4.0-template 的 ref 在此拒绝。——
if [[ ${#MIG_RM[@]} -gt 0 || ${#MIG_MV_SRC[@]} -gt 0 ]]; then
  exists "docs/rules/RESEARCH_RULES.md" \
    || die "模板 ref ${REF} 不含 docs/rules/（早于 v0.4.0-template）；为避免删除扁平规则却无新版本同步，已拒绝迁移。请改用 -r v0.4.0-template 或更新的 ref。"
fi

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

# —— 报告 ——
echo "模板来源：${SRC_DESC} @ ${SRC_SHORT}（${TPL}）"
echo "布局迁移：迁移记录 ${#MIG_MV_SRC[@]} ・ 删除旧规则 ${#MIG_RM[@]} ・ 跳过 ${#MIG_SKIP[@]}"
if [[ ${#MIG_MV_SRC[@]} -gt 0 ]]; then
  i=0; while [[ $i -lt ${#MIG_MV_SRC[@]} ]]; do echo "  → 迁移 ${MIG_MV_SRC[$i]} ⇒ ${MIG_MV_DST[$i]}（git mv，保留内容）"; i=$((i+1)); done
fi
if [[ ${#MIG_RM[@]} -gt 0 ]]; then for f in "${MIG_RM[@]}"; do echo "  − 删除 ${f}（旧扁平规则，新版本将落到 docs/rules/）"; done; fi
if [[ ${#MIG_SKIP[@]} -gt 0 ]]; then for f in "${MIG_SKIP[@]}"; do echo "  ! 跳过 $f"; done; fi
echo "规则同步：更新 ${#UPD[@]} ・ 新增 ${#NEW[@]} ・ 未变 ${#SAME[@]}"
if [[ ${#UPD[@]} -gt 0 ]]; then for f in "${UPD[@]}"; do echo "  ~ 更新 $f"; done; fi
if [[ ${#NEW[@]} -gt 0 ]]; then for f in "${NEW[@]}"; do echo "  + 新增 $f"; done; fi
if [[ "$SCAFFOLD" -eq 1 ]]; then
  echo "脚手架补缺 ${#SCAF_CREATE[@]}（只新建缺失目录文件，不覆盖已有）"
  if [[ ${#SCAF_CREATE[@]} -gt 0 ]]; then for f in "${SCAF_CREATE[@]}"; do echo "  + 脚手架 $f"; done; fi
fi
[[ "$REWRITE" -eq 1 ]] && echo "引用改写：将把项目文件正文里 docs/<名>.md 改写为 docs/{rules,records}/<名>.md（--rewrite-refs）"

if [[ "$DRY" -eq 1 ]]; then
  echo "（--dry-run：未写入任何文件）"; exit 0
fi
if [[ ${#MIG_MV_SRC[@]} -eq 0 && ${#MIG_RM[@]} -eq 0 && ${#UPD[@]} -eq 0 && ${#NEW[@]} -eq 0 && ${#SCAF_CREATE[@]} -eq 0 && "$REWRITE" -ne 1 ]]; then
  echo "已是最新且无需迁移，无需更新。"; exit 0
fi

# —— 1. 先同步规则文件：只覆盖 ALLOW 范围内文件（项目记录内容不在范围内，绝不被动）。——
#    放在迁移之前：先把新规则写入 docs/rules/，确保删除扁平旧规则时新版本已就位（避免半途失败留下规则缺失）。
git -C "$TPLDIR" archive "$REF" -- "${SPECS[@]}" | tar -x -C "$PROJ_ROOT"

# —— 2. 再执行布局迁移（git mv 记录、git rm 旧扁平规则）——
if [[ ${#MIG_MV_SRC[@]} -gt 0 ]]; then
  i=0; while [[ $i -lt ${#MIG_MV_SRC[@]} ]]; do
    msrc="${MIG_MV_SRC[$i]}"; mdst="${MIG_MV_DST[$i]}"
    mkdir -p "$(dirname "$mdst")"
    if git ls-files --error-unmatch "$msrc" >/dev/null 2>&1; then
      git mv "$msrc" "$mdst"
    else
      mv "$msrc" "$mdst"; git add "$mdst"   # 未跟踪（已填写但未提交）的记录也安全迁移、不丢内容
    fi
    i=$((i+1))
  done
fi
if [[ ${#MIG_RM[@]} -gt 0 ]]; then
  for f in "${MIG_RM[@]}"; do
    if git ls-files --error-unmatch "$f" >/dev/null 2>&1; then git rm -q "$f"; else rm -f "$f"; fi
  done
fi

# —— 3. 写入脚手架：只创建缺失文件（绝不覆盖已有项目内容）——
if [[ ${#SCAF_CREATE[@]} -gt 0 ]]; then
  for rel in "${SCAF_CREATE[@]}"; do
    mkdir -p "$(dirname "$PROJ_ROOT/$rel")"
    cp "$SCAF_STAGE/$rel" "$PROJ_ROOT/$rel"
  done
fi

# —— 4. 可选：确定性改写项目文件正文里对扁平 docs/<名>.md 的引用 ——
REWROTE=0
if [[ "$REWRITE" -eq 1 ]]; then
  if ! command -v perl >/dev/null 2>&1; then
    echo "WARN: 未找到 perl，跳过 --rewrite-refs（请手动改写引用）。" >&2
  else
    # 排除模板拥有的文件（同步后其引用已正确），只改项目自有文件。
    # 锚点用 (/|$)：既排除文件型条目（如 CLAUDE.md），也排除目录型条目下的成员（如 configs/task_types/*）。
    ALLOW_RE="$(printf '%s\n' "${ALLOW[@]}" | sed 's/[.[\*^$/]/\\&/g' | paste -sd'|' -)"
    REF_LIST="$(mktemp)"
    git grep -lE 'docs/(PROJECT|TASK_BRIEF|EVIDENCE|EXPERIMENT_LOG|RESULT_AUDIT|PAPER_NOTES|RESEARCH_RULES|RESEARCH_LOOP|TEMPLATE_CHANGELOG)\.md' -- . \
      | grep -vE "^(${ALLOW_RE})(/|$)" > "$REF_LIST" || true
    if [[ -s "$REF_LIST" ]]; then
      # 逐文件处理（read-loop 对含空格的路径安全，优于 xargs 默认空白切分）
      while IFS= read -r rf; do
        [[ -n "$rf" ]] || continue
        perl -0pi -e '
          s{docs/(RESEARCH_RULES|RESEARCH_LOOP|TEMPLATE_CHANGELOG)\.md}{docs/rules/$1.md}g;
          s{docs/(PROJECT|TASK_BRIEF|EVIDENCE|EXPERIMENT_LOG|RESULT_AUDIT|PAPER_NOTES)\.md}{docs/records/$1.md}g;
        ' "$rf"
        REWROTE=$((REWROTE+1))
      done < "$REF_LIST"
    fi
    rm -f "$REF_LIST"
  fi
fi

# —— 5. 记录同步来源（可追溯）——
printf 'synced-from: %s @ %s\nsynced-at: %s\nby: %s\nlayout: docs/rules + docs/records (v0.4.0-template+)\n' \
  "$SRC_DESC" "$SRC_FULL" "$(date +%F)" "$PROG" > "$PROJ_ROOT/.template-sync"

echo
echo "✅ 已同步模板规则到 ${SRC_DESC}。"
echo "   布局迁移：记录迁移 ${#MIG_MV_SRC[@]} 个入 docs/records/（内容保留）・ 删除旧扁平规则 ${#MIG_RM[@]} 个 ・ 脚手架补缺 ${#SCAF_CREATE[@]} 个。"
[[ "$REWRITE" -eq 1 ]] && echo "   引用改写：已改写 ${REWROTE} 个项目文件内的 docs/<名>.md 引用。"
echo "   项目记录内容（docs/records/ 下的 PROJECT / EVIDENCE / 实验 / 数据 / 结果）未被覆盖。"
echo "下一步：git diff 审阅改动 → 满意后 git add -A && git commit。"
echo "（若某规则文件你本地有定制被覆盖，可对该文件 git checkout -- <文件> 撤销本次覆盖；记录文件的移动可用 git status 查看。）"
