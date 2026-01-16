# 项目上下文

## 目的
这是一个 Flutter 移动端应用脚手架，聚焦认证与基础导航（登录 -> 首页），并包含环境化配置与服务初始化。

## 技术栈
- Flutter（Dart）
- 状态管理：flutter_bloc + equatable
- 网络：dio
- 本地存储：hive + hive_flutter
- 依赖注入：get_it

## 项目约定

### 代码风格
- 遵循 Dart/Flutter 默认规范；尽量使用 const 构造函数。
- 组件（Widget）保持小而专一；按 feature 组织目录。
- UI 状态使用 BLoC；state 保持不可变并实现 equatable。

### 架构模式
- Feature 维度分层：data / domain / presentation。
- domain 仅包含实体与仓储接口，data 提供实现。
- 路由集中在 `lib/core/routing`。
- 应用启动通过 `runAppWithConfig` 与 `get_it` 完成。

### 测试策略
- 使用 `flutter_test` 编写单元/组件测试。
- 目前没有稳定测试套件；新增功能尽量补测试。

### Git 工作流
- 仓库内未明确工作流；在假设分支/提交规范前先确认。

## 领域上下文
- 登录流程：调用 `POST /auth/login`，期望返回 `{id, name}`。
- 初始路由为登录页；成功后跳转到首页。
- baseUrl 与 appName 根据环境（dev/prod）变化。

## 重要约束
- 环境配置统一在 `AppConfig` 管理；不要在其他位置硬编码 URL。
- 未经审批不应改动登录 -> 首页的主流程。

## 外部依赖
- 通过 `AppConfig.baseUrl` 配置的后端 API。
- Hive 本地存储（settings box）。
