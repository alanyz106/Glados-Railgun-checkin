# Glados自动签到

## 食用方式：

### 注册一个GLaDOS的账号([注册地址](https://glados.space/landing/0A58E-NV28S-6U3QV-33VMG))

#### 我的邀请码：([0A58E-NV28S-6U3QV-33VMG](https://0a58e-nv28s-6u3qv-33vmg.glados.space)) 

### **Fork**本仓库

![图片加载失败](imgs/1.png)

### 添加**secret**

1. 跳转至自己的仓库的`Settings`->`Secrets and variables`->`Action`

2. 添加1个`repository secret`，命名为`GLADOS_COOKIES`，其值对应GLaDOS账号的cookie值中的有效部分（获取方式如下）

- 在GLaDOS的签到页面按`F12`

- 切换到`Network`页面下，刷新

![图片加载失败](imgs/2.png)

- 点击第一个选项卡后在`Request Headers`下找到`Cookie`，右键复制cookie的值即可

  > 参考格式：koa:sess=eyJ1c2xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxAwMH0=; koa:sess.sig=xJkOxxxxxxxxxxxxxxxtnM;

![图片加载失败](imgs/3.png)

- 多账号请再添加独立的 `repository secret`，命名为 `GLADOS_COOKIES_2`、`GLADOS_COOKIES_3`…（依次递增），每个 secret 对应一个账号的 cookie，无需拼接。当前最多支持 5 个账号（`GLADOS_COOKIES` 到 `GLADOS_COOKIES_5`）。

3. 配置积分兑换策略（非必须）

- 添加1个`repository secret`，命名为`GLADOS_EXCHANGE_PLAN`，配置自动兑换积分策略：

| 值 | 积分要求 | 兑换天数 |
|---|---------|---------|
| `plan100` | 100 积分 | 10 天 |
| `plan200` | 200 积分 | 30 天 |
| `plan500` | 500 积分 | 100 天 (默认) |

> 不配置时默认为 `plan500`，即积分达到 500 时自动兑换 100 天

4. 手机推送（非必须）

- 添加1个`repository secret`，命名为`PUSHDEER_SENDKEY`，其值对应 PushDeer key: ([获取地址](https://www.pushdeer.com/product.html))。

### **star**自己的仓库

![图片加载失败](imgs/4.png)

## 文件结构

```shell
│  checkin.py	# 签到脚本
│
├─.github
│  └─workflows
│          gladosCheck.yml	# Actions 配置文件
```

## 更新日志

- **2026-01**: 重构代码，添加log输出方便定位，支持新版网址，支持配置积分兑换策略。
- **2026-04**: 优化代码逻辑，优化日志输出，支持新版域名，在 GLADOS_COOKIES 中添加新版域名下的 cookies 即可使用。
- **2026-08**: 移除 railgun.info 域名支持，仅保留 glados.cloud 签到。
- **2026-08**: 多账号改为每个账号一个独立 secret（`GLADOS_COOKIES_2`、`GLADOS_COOKIES_3`…），不再使用 `&` 拼接。
- **2026-10**: 修复 `code:4 device-mismatch`（不再伪装浏览器 UA）；停用 Action 定时任务，改为本地 `run-local.sh` 运行。


## 本地运行（替代 GitHub Actions）

Action 的定时任务已停用，改为在本机运行。

1. 编辑 `.env` 填入 Cookie（格式：每行一个账号，`GLADOS_COOKIES`、`GLADOS_COOKIES_2`… 依次递增）：

```bash
GLADOS_COOKIES="gld:sess=xxx; gld:sess.sig=xxx"
GLADOS_COOKIES_2="gld:sess=yyy; gld:sess.sig=yyy"
GLADOS_EXCHANGE_PLAN="plan500"
GLADOS_AUTO_EXCHANGE="false"
```

> `.env` 已被 `.gitignore` 忽略，不会提交到仓库。

2. 执行签到：

```bash
./run-local.sh
```

3. 如需每日定时，加入 crontab：

```bash
0 12 * * * cd /root/Glados-Railgun-checkin && ./run-local.sh >> /root/glados-checkin.log 2>&1
```

### 关于 `code: 4 device-mismatch`

若日志出现：

```
❌ { code : 4, reason : device-mismatch, message : Automated check-in detected. Please sign in again to continue. }
```

**这通常不是 Cookie 过期**，而是 GLaDOS 新增了设备指纹校验：服务端会把请求 UA 解析成系统类型（Windows / macOS / iOS / Android / Linux），与登录时登记的设备比对，不一致即拒绝。

- 解决方法：**不要伪装浏览器 UA**。脚本已改为使用 `requests` 默认 UA，服务端无法解析设备类型时会跳过该校验。
- 若 Cookie 确实过期（接口返回 `code: -2 没有权限`），则需重新登录获取新 Cookie。

## 问题排查与定位
- 大家可以通过查询 actions 中的 running checkin 日志快速定位问题，有其他问题提交issue。

  <img width="1684" height="844" alt="image" src="https://github.com/user-attachments/assets/45348a5f-43e4-45f5-8fdf-ce84d343b30d" />

## 声明

本项目不保证稳定运行与更新, 因GitHub相关规定可能会删库, 请注意备份







