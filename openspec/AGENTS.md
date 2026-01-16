# OpenSpec 指令

面向使用 OpenSpec 进行规范驱动开发的 AI 助手。

## TL;DR 快速检查清单

- 查找已有工作：`openspec spec list --long`、`openspec list`（仅在全文搜索时用 `rg`）
- 确定范围：新增能力 vs 修改现有能力
- 选唯一 `change-id`：kebab-case，动词开头（`add-`、`update-`、`remove-`、`refactor-`）
- 搭脚手架：`proposal.md`、`tasks.md`、`design.md`（仅必要时）以及按能力划分的 delta specs
- 写 delta：使用 `## ADDED|MODIFIED|REMOVED|RENAMED Requirements`；每个 requirement 至少一个 `#### Scenario:`
- 校验：`openspec validate [change-id] --strict --no-interactive` 并修复问题
- 申请审批：提案未批准前不要开始实现

## 三阶段工作流

### 阶段 1：创建变更
出现以下情况需要创建提案：
- 新增功能或能力
- 破坏性变更（API、schema）
- 架构或模式调整
- 性能优化（改变行为）
- 安全相关改动

触发示例：
- "Help me create a change proposal"
- "Help me plan a change"
- "Help me create a proposal"
- "I want to create a spec proposal"
- "I want to create a spec"

模糊匹配：
- 包含：`proposal`、`change`、`spec`
- 同时包含：`create`、`plan`、`make`、`start`、`help`

以下情况不需要提案：
- 修复 bug（恢复既有行为）
- 文字/格式/注释修改
- 依赖更新（非破坏性）
- 配置修改
- 针对既有行为的测试补充

**工作流**
1. 阅读 `openspec/project.md`、`openspec list`、`openspec list --specs` 了解当前上下文。
2. 选择唯一动词开头的 `change-id`，并在 `openspec/changes/<id>/` 下创建 `proposal.md`、`tasks.md`、可选 `design.md` 及 spec delta。
3. 使用 `## ADDED|MODIFIED|REMOVED Requirements` 起草 delta，并确保每个 requirement 至少一个 `#### Scenario:`。
4. 运行 `openspec validate <id> --strict --no-interactive` 并修复问题后再分享提案。

### 阶段 2：实现变更
将以下步骤作为 TODO 逐项完成。
1. **读 proposal.md** - 理解要构建的内容
2. **读 design.md**（若存在）- 了解技术决策
3. **读 tasks.md** - 获取实现清单
4. **按顺序实现任务** - 逐项完成
5. **确认完成** - 确保 `tasks.md` 中所有条目都已完成
6. **更新清单** - 全部完成后将任务勾为 `- [x]`
7. **审批门禁** - 提案未批准前不要开始实现

### 阶段 3：归档变更
部署后创建独立 PR：
- 将 `changes/[name]/` → `changes/archive/YYYY-MM-DD-[name]/`
- 若能力已变更，更新 `specs/`
- 工具类变更使用 `openspec archive <change-id> --skip-specs --yes`（务必显式传入 change-id）
- 运行 `openspec validate --strict --no-interactive` 确认归档通过

## 开始任何任务前

**上下文检查清单：**
- [ ] 阅读相关 specs：`specs/[capability]/spec.md`
- [ ] 检查 `changes/` 是否有冲突
- [ ] 阅读 `openspec/project.md` 了解约定
- [ ] 运行 `openspec list` 查看进行中的变更
- [ ] 运行 `openspec list --specs` 查看现有能力

**创建 specs 前：**
- 先检查能力是否已存在
- 优先修改已有 specs，避免重复
- 使用 `openspec show [spec]` 查看现状
- 若需求含糊，先问 1–2 个澄清问题再搭脚手架

### 搜索指引
- 枚举 specs：`openspec spec list --long`（脚本用 `--json`）
- 枚举 changes：`openspec list`（或 `openspec change list --json` - 已弃用但可用）
- 查看详情：
  - Spec：`openspec show <spec-id> --type spec`（过滤可用 `--json`）
  - Change：`openspec show <change-id> --json --deltas-only`
- 全文搜索（ripgrep）：`rg -n "Requirement:|Scenario:" openspec/specs`

## 快速开始

### CLI 命令

```bash
# 基础命令
openspec list                  # 列出进行中的变更
openspec list --specs          # 列出规格
openspec show [item]           # 查看变更或规格
openspec validate [item]       # 校验变更或规格
openspec archive <change-id> [--yes|-y]   # 部署后归档（非交互用 --yes）

# 项目管理
openspec init [path]           # 初始化 OpenSpec
openspec update [path]         # 更新指令文件

# 交互模式
openspec show                  # 交互选择
openspec validate              # 批量校验

# 调试
openspec show [change] --json --deltas-only
openspec validate [change] --strict --no-interactive
```

### 命令参数

- `--json` - 机器可读输出
- `--type change|spec` - 类型消歧
- `--strict` - 严格校验
- `--no-interactive` - 禁用交互
- `--skip-specs` - 归档时不更新 specs
- `--yes`/`-y` - 跳过确认（非交互）

## 目录结构

```
openspec/
├── project.md              # 项目约定
├── specs/                  # 当前事实 - 已构建的能力
│   └── [capability]/       # 单一能力
│       ├── spec.md         # 需求与场景
│       └── design.md       # 技术模式
├── changes/                # 提案 - 将要变更的内容
│   ├── [change-name]/
│   │   ├── proposal.md     # 为什么、做什么、影响
│   │   ├── tasks.md        # 实施清单
│   │   ├── design.md       # 技术决策（可选）
│   │   └── specs/          # Delta 变更
│   │       └── [capability]/
│   │           └── spec.md # ADDED/MODIFIED/REMOVED
│   └── archive/            # 已完成的变更
```

## 创建变更提案

### 决策树

```
New request?
├─ Bug fix restoring spec behavior? → Fix directly
├─ Typo/format/comment? → Fix directly  
├─ New feature/capability? → Create proposal
├─ Breaking change? → Create proposal
├─ Architecture change? → Create proposal
└─ Unclear? → Create proposal (safer)
```

### 提案结构

1. **创建目录：** `changes/[change-id]/`（kebab-case、动词开头、唯一）

2. **编写 proposal.md：**
```markdown
# Change: [Brief description of change]

## Why
[1-2 sentences on problem/opportunity]

## What Changes
- [Bullet list of changes]
- [Mark breaking changes with **BREAKING**]

## Impact
- Affected specs: [list capabilities]
- Affected code: [key files/systems]
```

3. **创建 spec deltas：** `specs/[capability]/spec.md`
```markdown
## ADDED Requirements
### Requirement: New Feature
The system SHALL provide...

#### Scenario: Success case
- **WHEN** user performs action
- **THEN** expected result

## MODIFIED Requirements
### Requirement: Existing Feature
[Complete modified requirement]

## REMOVED Requirements
### Requirement: Old Feature
**Reason**: [Why removing]
**Migration**: [How to handle]
```
如影响多个能力，在 `changes/[change-id]/specs/<capability>/spec.md` 下分别创建。

4. **创建 tasks.md：**
```markdown
## 1. Implementation
- [ ] 1.1 Create database schema
- [ ] 1.2 Implement API endpoint
- [ ] 1.3 Add frontend component
- [ ] 1.4 Write tests
```

5. **需要时创建 design.md：**
以下情况创建 `design.md`，否则省略：
- 跨模块变更或新架构模式
- 新外部依赖或重大数据模型变更
- 安全/性能/迁移复杂度较高
- 需求存在不确定性，需要先定技术方案

最小 `design.md` 模板：
```markdown
## Context
[Background, constraints, stakeholders]

## Goals / Non-Goals
- Goals: [...]
- Non-Goals: [...]

## Decisions
- Decision: [What and why]
- Alternatives considered: [Options + rationale]

## Risks / Trade-offs
- [Risk] → Mitigation

## Migration Plan
[Steps, rollback]

## Open Questions
- [...]
```

## Spec 文件格式

### 关键：Scenario 格式

**正确**（使用 #### 标题）：
```markdown
#### Scenario: User login success
- **WHEN** valid credentials provided
- **THEN** return JWT token
```

**错误**（不要用粗体或其他标题级别）：
```markdown
- **Scenario: User login**  ❌
**Scenario**: User login     ❌
### Scenario: User login      ❌
```

每个 requirement 必须至少一个 scenario。

### Requirement 文案
- 规范性需求使用 SHALL/MUST（避免 should/may，除非是有意非规范）

### Delta 操作类型

- `## ADDED Requirements` - 新增能力
- `## MODIFIED Requirements` - 修改行为
- `## REMOVED Requirements` - 弃用能力
- `## RENAMED Requirements` - 重命名

匹配时会对 header 进行 `trim`。

#### 何时使用 ADDED vs MODIFIED
- ADDED：引入可独立存在的新能力或子能力。若变更是正交新增，优先 ADDED。
- MODIFIED：改变已有 requirement 的行为/范围/验收标准。必须粘贴完整 requirement（标题 + 所有 scenarios）。归档会用此内容覆盖旧文本。
- RENAMED：仅名称变化时使用。若行为也变更，则同时使用 RENAMED（名称）+ MODIFIED（内容）。

常见陷阱：用 MODIFIED 增加新关注点但未包含旧内容，归档时会丢失旧细节。若不是明确修改旧 requirement，优先 ADDED。

正确编写 MODIFIED 的步骤：
1) 在 `openspec/specs/<capability>/spec.md` 找到原 requirement。
2) 复制整个 requirement（从 `### Requirement: ...` 到其 scenarios）。
3) 粘贴到 `## MODIFIED Requirements` 下并编辑。
4) 确保 header 文本完全一致，并至少保留一个 `#### Scenario:`。

RENAMED 示例：
```markdown
## RENAMED Requirements
- FROM: `### Requirement: Login`
- TO: `### Requirement: User Authentication`
```

## 排错

### 常见错误

**"Change must have at least one delta"**
- 检查 `changes/[name]/specs/` 是否存在且有 .md 文件
- 确保文件包含操作前缀（如 `## ADDED Requirements`）

**"Requirement must have at least one scenario"**
- 检查 scenario 是否使用 `#### Scenario:` 格式（四个 #）
- 不要用项目符号或粗体当作 scenario 标题

**Scenario 解析失败**
- 格式必须完全一致：`#### Scenario: Name`
- 用 `openspec show [change] --json --deltas-only` 调试

### 校验技巧

```bash
# 严格模式
openspec validate [change] --strict --no-interactive

# 调试 delta 解析
openspec show [change] --json | jq '.deltas'

# 查看特定 spec
openspec show [spec] --json -r 1
```

## Happy Path 脚本

```bash
# 1) 查看当前状态
openspec spec list --long
openspec list
# 可选全文搜索：
# rg -n "Requirement:|Scenario:" openspec/specs
# rg -n "^#|Requirement:" openspec/changes

# 2) 选择 change id 并搭脚手架
CHANGE=add-two-factor-auth
mkdir -p openspec/changes/$CHANGE/{specs/auth}
printf "## Why\n...\n\n## What Changes\n- ...\n\n## Impact\n- ...\n" > openspec/changes/$CHANGE/proposal.md
printf "## 1. Implementation\n- [ ] 1.1 ...\n" > openspec/changes/$CHANGE/tasks.md

# 3) 添加 deltas 示例
cat > openspec/changes/$CHANGE/specs/auth/spec.md << 'EOF'
## ADDED Requirements
### Requirement: Two-Factor Authentication
Users MUST provide a second factor during login.

#### Scenario: OTP required
- **WHEN** valid credentials are provided
- **THEN** an OTP challenge is required
EOF

# 4) 校验
openspec validate $CHANGE --strict --no-interactive
```

## 多能力示例

```
openspec/changes/add-2fa-notify/
├── proposal.md
├── tasks.md
└── specs/
    ├── auth/
    │   └── spec.md   # ADDED: Two-Factor Authentication
    └── notifications/
        └── spec.md   # ADDED: OTP email notification
```

auth/spec.md
```markdown
## ADDED Requirements
### Requirement: Two-Factor Authentication
...
```

notifications/spec.md
```markdown
## ADDED Requirements
### Requirement: OTP Email Notification
...
```

## 最佳实践

### 简单优先
- 默认新增代码 <100 行
- 未证明必要前优先单文件实现
- 避免无明确理由的框架引入
- 选择稳定、可预期的方案

### 复杂度触发条件
仅在以下情况引入复杂度：
- 有性能数据证明当前方案不够
- 明确规模需求（>1000 用户、>100MB 数据）
- 多个明确用例需要抽象

### 清晰引用
- 代码位置使用 `file.ts:42` 格式
- 规格引用 `specs/auth/spec.md`
- 关联相关变更与 PR

### 能力命名
- 动词-名词：`user-auth`、`payment-capture`
- 单一职责
- 10 分钟可理解原则
- 若描述包含 "AND"，考虑拆分

### Change ID 命名
- kebab-case，短且明确：`add-two-factor-auth`
- 优先动词前缀：`add-`、`update-`、`remove-`、`refactor-`
- 唯一性；若冲突加 `-2`、`-3`

## 工具选择指引

| 任务 | 工具 | 原因 |
|------|------|------|
| 按模式找文件 | Glob | 模式匹配快 |
| 搜索内容 | Grep | 正则搜索优化 |
| 读取文件 | Read | 直接读取 |
| 探索未知范围 | Task | 多步调查 |

## 错误恢复

### 变更冲突
1. 运行 `openspec list` 查看进行中的变更
2. 检查 specs 是否重叠
3. 与变更负责人协作
4. 视情况合并提案

### 校验失败
1. 使用 `--strict`
2. 检查 JSON 输出
3. 验证 spec 格式
4. 确保 scenario 正确格式化

### 上下文缺失
1. 先读 project.md
2. 查看相关 specs
3. 回顾近期归档
4. 询问澄清问题

## 快速参考

### 阶段指示
- `changes/` - 提案阶段，未实现
- `specs/` - 已实现并部署
- `archive/` - 已完成变更

### 文件用途
- `proposal.md` - 为什么、做什么
- `tasks.md` - 实施步骤
- `design.md` - 技术决策
- `spec.md` - 需求与行为

### CLI 要点
```bash
openspec list              # 进行中的变更
openspec show [item]       # 查看详情
openspec validate --strict --no-interactive  # 校验
openspec archive <change-id> [--yes|-y]  # 归档（自动化用 --yes）
```

请记住：Specs 是事实，Changes 是提案。保持同步。
