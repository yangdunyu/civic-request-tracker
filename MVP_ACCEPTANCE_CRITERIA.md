# CivicFlow MVP 功能验收文档

本文档用于验收 Ruby on Rails MVP：`Civic Request Tracker / Public Service Issue Tracker`。目标是帮助后续 AI 或人工 reviewer 按一致标准判断项目是否达到可展示、可面试、可部署的 MVP 水平。

## 1. 产品目标

一句话目标：

市民可以提交公共服务问题，政府或机构内部团队可以在后台完成分类、分派、跟进、状态流转和通知。

项目应体现：

- Ruby on Rails 全栈能力
- Public sector / civic tech 场景理解
- Positive impact 产品意识
- Accessible, usable, client-friendly UI
- Hotwire 驱动的轻量交互
- 基础测试、CI、部署准备
- AI-assisted workflow 的合理应用

## 2. MVP 范围

必须包含：

- 市民提交 issue
- 图片上传
- 管理员后台 Kanban 或列表式工作流
- 状态更新
- 内部备注
- 负责人分配
- 搜索和过滤
- 状态变更邮件通知
- AI 辅助摘要、分类和优先级建议
- 权限控制
- 基础测试
- README 说明

暂不要求：

- 复杂地图定位
- 多机构多租户
- SLA 计时器
- 实时聊天
- Sidekiq
- 完整 production-grade audit log
- 真实 OpenAI API 强依赖

## 3. 角色与权限

### 3.1 Citizen 用户

验收标准：

- 未登录用户或 citizen 用户可以访问 issue 提交页面。
- citizen 可以提交公共服务问题。
- citizen 不可以访问管理员后台。
- citizen 不可以修改 issue 状态。
- citizen 不可以查看内部备注。

验收步骤：

1. 访问首页或提交页面。
2. 创建一个 issue。
3. 尝试访问 admin dashboard。
4. 尝试直接访问 admin issue edit/update URL。

期望结果：

- issue 创建成功。
- 非管理员访问后台时被重定向或显示未授权。
- 非管理员不能修改状态、负责人、内部备注。

### 3.2 Admin 用户

验收标准：

- admin 可以登录后台。
- admin 可以查看所有 issues。
- admin 可以更新状态、负责人、优先级、分类。
- admin 可以添加内部备注。
- admin 可以搜索和过滤 issues。

验收步骤：

1. 使用 admin 账号登录。
2. 进入 admin dashboard。
3. 打开一个 issue。
4. 修改状态、分类、优先级和负责人。
5. 添加一条内部备注。

期望结果：

- 所有修改被保存。
- 后台列表或 Kanban 即时反映最新状态。
- 内部备注只在 admin 页面可见。

## 4. Issue 提交功能

### 4.1 表单字段

Issue 表单必须包含：

- 标题 `title`
- 描述 `description`
- 分类 `category`
- 地点 `location`
- 图片上传 `image`
- 联系邮箱 `contact_email`

允许的分类：

- Roads
- Waste
- Public Facilities
- Noise
- Other

验收标准：

- 必填字段缺失时显示清晰错误信息。
- 成功提交后显示确认页面或成功提示。
- 提交后的 issue 默认状态为 `New`。
- 图片上传后可在 admin 详情页查看。
- 联系邮箱格式必须校验。

验收步骤：

1. 提交空表单。
2. 提交格式错误的邮箱。
3. 提交完整有效表单。
4. 上传一张图片。
5. 到 admin 后台查看该 issue。

期望结果：

- 空表单和错误邮箱不能提交。
- 有效表单可以创建 issue。
- 图片能正常保存和显示。
- 新 issue 出现在 `New` 状态栏或列表中。

## 5. Admin Dashboard

### 5.1 状态流转

必须支持状态：

- New
- Triage
- In Progress
- Resolved

验收标准：

- admin 可以将 issue 从任意状态更新到另一个合法状态。
- 非法状态值不能被保存。
- 状态变更后列表、详情页和邮件内容保持一致。

验收步骤：

1. 创建一个新 issue。
2. admin 将状态从 `New` 改为 `Triage`。
3. 再改为 `In Progress`。
4. 再改为 `Resolved`。

期望结果：

- 每次状态变更都成功保存。
- UI 中展示的状态准确。
- 每次状态变更触发邮件通知。

### 5.2 Kanban 或列表视图

验收标准：

- 后台必须能按状态查看 issues。
- 如果使用 Kanban，每个状态有独立列。
- 如果使用列表，必须有状态过滤器。
- issue card 或 row 至少显示标题、分类、地点、状态、优先级。

验收步骤：

1. 创建多个不同状态的 issues。
2. 进入 admin dashboard。
3. 检查不同状态的展示区域。

期望结果：

- issue 出现在正确状态分组中。
- 状态修改后 issue 移动到对应状态分组。

### 5.3 搜索和过滤

必须支持：

- 按状态过滤
- 按分类过滤
- 按关键词搜索标题或描述

验收标准：

- 过滤器可以单独使用。
- 搜索和过滤器可以组合使用。
- 没有结果时显示清晰 empty state。

验收步骤：

1. 创建至少 5 个不同分类、不同状态的 issues。
2. 使用状态过滤。
3. 使用分类过滤。
4. 使用关键词搜索。
5. 同时使用状态、分类和关键词。

期望结果：

- 结果只包含符合条件的 issues。
- 查询参数刷新后仍可保留。
- 无匹配项时页面不报错。

## 6. 内部备注

验收标准：

- admin 可以在 issue 详情页添加内部备注。
- 内部备注记录作者、时间和内容。
- 内部备注不会显示给 citizen。
- 空备注不能提交。

验收步骤：

1. admin 打开 issue 详情页。
2. 添加一条内部备注。
3. 刷新页面。
4. 使用 citizen 或未登录状态查看对应 issue 或提交确认页。

期望结果：

- admin 可以看到备注内容、作者和时间。
- citizen 或公开页面看不到内部备注。

## 7. 负责人分配

验收标准：

- admin 可以把 issue 分配给另一个 admin 用户。
- 未分配状态应清晰显示为 `Unassigned`。
- 被分配用户在 issue 详情和列表中可见。

验收步骤：

1. 创建至少两个 admin 用户。
2. 打开一个 issue。
3. 将负责人设置为某个 admin。
4. 再改回未分配。

期望结果：

- 负责人保存正确。
- 列表和详情页展示一致。
- 系统不允许分配给 citizen 用户。

## 8. 邮件通知

### 8.1 状态变更通知

验收标准：

- issue 状态变更后发送邮件给 `contact_email`。
- 邮件标题包含 request updated 或类似语义。
- 邮件正文包含最新状态。
- 只有状态实际变化时才发送邮件。
- 开发环境可通过 letter opener、Rails mailer preview、日志或测试确认邮件生成。

验收步骤：

1. 创建 issue，填写 contact email。
2. admin 修改状态为 `In Progress`。
3. 检查邮件发送记录或 mailer preview。
4. admin 保存 issue 但不改变状态。

期望结果：

- 第一次状态变化产生邮件。
- 邮件内容包含 `In Progress`。
- 未改变状态时不重复发送状态通知。

## 9. AI Assisted Triage

### 9.1 AI 输出

AI 功能可以是真实 OpenAI API，也可以是 mock service。MVP 必须清楚展示 workflow。

必须生成：

- `ai_summary`
- `ai_suggested_category`
- `priority`

验收标准：

- issue 创建后自动产生 AI 摘要。
- AI 建议分类显示在 admin 详情页。
- AI 建议优先级显示在 admin 详情页。
- 如果 AI 服务失败，issue 仍然可以创建。
- README 清楚说明当前 AI 是 mock 还是真实 API。

验收步骤：

1. 提交描述：`There is broken glass near the school bus stop.`
2. 查看 admin issue 详情页。
3. 临时模拟 AI 服务失败。
4. 再提交一个 issue。

期望结果：

- 正常情况下生成类似：
  - Summary: Broken glass reported near a school bus stop.
  - Suggested category: Public Safety 或 Other
  - Priority: High
- AI 失败时页面不崩溃。
- AI 失败的 issue 仍保存成功，并显示 fallback 状态。

## 10. Accessibility 验收

验收标准：

- 所有表单输入都有 label。
- 错误信息与对应字段清晰关联。
- 颜色对比度满足基本可读性。
- 页面可以用键盘完成主要流程。
- 按钮和链接有可理解的文本或 aria-label。
- 状态 badge 不只依赖颜色表达含义。

验收步骤：

1. 只用键盘完成 issue 提交。
2. 只用键盘完成 admin 登录、搜索、过滤和状态修改。
3. 检查表单 label。
4. 使用浏览器 Lighthouse 或 axe 检查明显问题。

期望结果：

- 核心流程无需鼠标即可完成。
- 无严重 accessibility 报错。
- 表单错误对用户清楚可见。

## 11. UI / UX 验收

验收标准：

- 首页直接提供提交 issue 的入口。
- citizen-facing 页面简洁、可信、移动端可用。
- admin dashboard 信息密度适中，方便扫描。
- 状态、分类、优先级有一致视觉表达。
- 成功、失败、空状态都有明确反馈。
- 移动端没有明显溢出、遮挡或不可点击元素。

验收步骤：

1. 在桌面宽度检查首页、提交页、admin dashboard、issue detail。
2. 在移动端宽度检查同样页面。
3. 制造表单错误、无搜索结果、成功提交等状态。

期望结果：

- UI 稳定，无文本重叠。
- 移动端可正常提交 issue。
- admin 页面可正常完成核心操作。

## 12. 数据模型验收

### 12.1 User

建议字段：

- `email`
- `encrypted_password`
- `role`

验收标准：

- role 至少支持 `citizen` 和 `admin`。
- role 有默认值。
- admin 权限判断集中且可测试。

### 12.2 Issue

建议字段：

- `title`
- `description`
- `category`
- `status`
- `priority`
- `location`
- `contact_email`
- `ai_summary`
- `ai_suggested_category`
- `assigned_to_id`

验收标准：

- 必填字段有 model validation。
- 枚举字段限制合法值。
- `assigned_to_id` 关联 admin user。
- issue 支持图片附件。

### 12.3 Comment

建议字段：

- `issue_id`
- `user_id`
- `body`
- `internal`

验收标准：

- comment 必须属于 issue。
- comment 必须有作者。
- body 不能为空。
- internal 默认为 true 或在 admin comment 创建时强制为 true。

## 13. 测试验收

最低测试覆盖：

- Issue model validations
- User role / authorization
- Issue creation request/system spec
- Admin status update
- Email notification
- AI triage service fallback
- Comment creation

验收标准：

- `bundle exec rspec` 可以通过。
- 测试数据库可自动准备。
- 至少有 model、request 或 system 层测试。
- 邮件通知有对应测试断言。

建议命令：

```bash
bundle exec rspec
```

期望结果：

- 测试全部通过。
- 没有 pending 或 skipped 的核心功能测试。

## 14. CI 验收

验收标准：

- GitHub Actions 在 push 或 pull request 时运行。
- CI 至少执行 bundle install、数据库准备、RSpec。
- CI 配置中包含 PostgreSQL service。
- CI 失败时能定位到测试或 lint 错误。

建议检查：

```bash
ls .github/workflows
```

期望结果：

- 存在 Rails/RSpec CI workflow。
- GitHub 上最新 workflow run 成功。

## 15. Docker 验收

验收标准：

- 项目包含 `Dockerfile`。
- 如使用本地多服务开发，应包含 `docker-compose.yml`。
- README 说明如何用 Docker 启动。

建议命令：

```bash
docker compose up --build
```

期望结果：

- Rails app 和 PostgreSQL 可以启动。
- 可以访问本地应用。

## 16. README 验收

README 必须包含：

- 项目简介
- 为什么这个项目贴合 public sector / civic tech
- 技术栈
- 本地启动步骤
- 测试命令
- AI triage 说明
- 截图或功能说明
- 部署说明或部署链接

推荐文案：

```text
Built with Ruby on Rails, PostgreSQL, Hotwire, Docker, GitHub Actions,
accessibility-first UI, and AI-assisted triage.
```

验收标准：

- 新 reviewer 可以根据 README 在本地跑起来。
- README 清楚说明 MVP 功能和取舍。
- README 不夸大未完成能力。

## 17. 部署验收

验收标准：

- 应用可部署到 Render、Fly.io、AWS 或类似平台。
- production 环境使用 PostgreSQL。
- Active Storage 在 production 有明确策略。
- 邮件发送在 production 有配置说明或降级说明。
- 环境变量列在 README 或 `.env.example`。

验收步骤：

1. 打开部署链接。
2. 提交一个 issue。
3. 登录 admin。
4. 修改状态。
5. 检查邮件或日志。

期望结果：

- 线上核心流程可用。
- 页面无 500 错误。
- 数据可以持久化。

## 18. 最终 Demo 验收脚本

AI 或人工 reviewer 应按以下顺序完成最终验收：

1. 阅读 README，确认项目目标和启动方式。
2. 安装依赖并启动 Rails app。
3. 运行测试套件。
4. 创建 citizen issue，包含图片和邮箱。
5. 登录 admin dashboard。
6. 搜索刚才提交的 issue。
7. 检查 AI 摘要、建议分类和优先级。
8. 添加内部备注。
9. 分配负责人。
10. 将状态从 `New` 改到 `Triage`。
11. 将状态改到 `In Progress`。
12. 检查邮件通知。
13. 将状态改到 `Resolved`。
14. 检查移动端页面。
15. 检查非 admin 是否无法访问后台。

通过标准：

- 上述 15 步全部完成，无阻塞性错误。
- 测试通过。
- README 准确。
- UI 可展示给面试官。

## 19. MVP 完成定义

项目可以视为 MVP 完成，当且仅当：

- citizen 可以成功提交 issue。
- admin 可以完成 triage、分配、备注和状态流转。
- 状态变化会通知提交人。
- AI triage workflow 可见且有 fallback。
- 权限边界清楚。
- 基础测试和 CI 存在。
- README 能让陌生 reviewer 跑起来。
- 部署或部署说明可用。

## 20. 非阻塞优化项

以下内容加分，但不影响 MVP 验收：

- Drag-and-drop Kanban
- 地图选点
- SLA / overdue 提醒
- CSV export
- 多语言支持
- 更完整 audit log
- Sidekiq background jobs
- 真实 OpenAI API 集成
- Admin analytics dashboard
- Public request tracking token
