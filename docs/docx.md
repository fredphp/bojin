# Bojin 游戏平台 - 项目结构详细分析文档

## 目录

1. [项目概述](#1-项目概述)
2. [根目录结构](#2-根目录结构)
3. [核心可执行文件](#3-核心可执行文件)
4. [核心动态链接库](#4-核心动态链接库)
5. [游戏模块目录](#5-游戏模块目录)
6. [界面框架目录](#6-界面框架目录)
7. [资源文件目录](#7-资源文件目录)
8. [配置文件说明](#8-配置文件说明)
9. [功能模块详解](#9-功能模块详解)

---

## 1. 项目概述

### 1.1 项目性质

Bojin（博金）是一个Windows桌面游戏平台客户端，采用C++开发，基于自研游戏引擎构建。平台支持多款棋牌类和捕鱼类游戏的在线娱乐服务。

### 1.2 技术栈

| 技术层 | 技术选型 |
|--------|----------|
| 开发语言 | C++ |
| 目标平台 | Windows 32位 (PE32) |
| 图形引擎 | DirectX 9.0c |
| UI框架 | 自研DirectUI引擎 |
| 音频系统 | BASS音频库 |
| 网络通信 | 自研网络引擎 |
| 资源格式 | 自定义.fish打包格式 |

### 1.3 项目规模统计

```
┌────────────────────────────────────────────┐
│            项目文件统计                     │
├────────────────────────────────────────────┤
│  可执行文件(.exe):        12 个            │
│  动态链接库(.dll):        40+ 个           │
│  配置文件(.INI/.xml):     30+ 个           │
│  资源文件(.fish):         300+ 个          │
│  图片资源(.png/.bmp):     1000+ 个         │
│  总大小:                  ~250 MB          │
└────────────────────────────────────────────┘
```

---

## 2. 根目录结构

```
bojin/
├── 📁 游戏可执行文件
│   ├── GPManager.exe          # 游戏平台管理器（主程序）
│   ├── lkpy.exe               # 李逵捕鱼
│   ├── Land.exe               # 斗地主
│   ├── SparrowER.exe          # 麻将
│   ├── OxNew.exe              # 牛牛
│   ├── ZaJinHua.exe           # 炸金花
│   ├── FiveStar.exe           # 五星宏辉
│   ├── BaccaratNew.exe        # 百家乐
│   ├── 28GangBattle.exe       # 28杠
│   ├── BumperCarBattle.exe    # 碰碰车大战
│   └── unins000.exe           # 卸载程序
│
├── 📁 核心DLL组件
│   ├── MTUIEngine.dll         # UI引擎
│   ├── MT3DEngine.dll         # 3D渲染引擎
│   ├── MTImage.dll            # 图像处理
│   ├── MTNetworkEngine.dll    # 网络通信
│   ├── LKpyEngine.dll         # 捕鱼游戏引擎
│   └── ... 更多DLL
│
├── 📁 游戏资源目录
│   ├── lkpy/                  # 李逵捕鱼资源
│   ├── Land/                  # 斗地主资源
│   ├── SparrowER/             # 麻将资源
│   ├── OxNew/                 # 牛牛资源
│   ├── ZaJinHua/              # 炸金花资源
│   ├── FiveStar/              # 五星宏辉资源
│   ├── BaccaratNew/           # 百家乐资源
│   ├── 28GangBattle/          # 28杠资源
│   ├── BumperCarBattle/       # 碰碰车大战资源
│   └── DZShowHand/            # 德州扑克资源
│
├── 📁 界面资源目录
│   ├── PlatformFrame/         # 平台框架界面
│   ├── GPManagerPlatformFrame/# 平台管理界面
│   ├── GameFrameWnd/          # 游戏框架窗口
│   └── GPManagerImage/        # 平台图片资源
│
├── 📁 配置文件
│   ├── ServerInfo.INI         # 服务器配置
│   ├── GPManagerLog.txt       # 平台日志
│   └── DownLoadLog.txt        # 下载日志
│
├── 📁 系统依赖
│   ├── D3DX9_43.dll           # DirectX 9
│   ├── Msvcp71.dll            # VC++运行时
│   ├── Msvcr71.dll            # VC++运行时
│   ├── Flash.ocx              # Flash组件
│   ├── wke.dll                # WebKit组件
│   ├── bass.dll               # 音频库
│   └── vcredist_x86.exe       # 运行时安装包
│
├── 📄 README.md               # 项目说明文档
├── 📄 deploy.md               # 部署文档
├── 📄 deploy.sh               # 一键部署脚本
└── 📄 start.sh                # 一键启动脚本
```

---

## 3. 核心可执行文件

### 3.1 主程序

| 文件名 | 大小 | 功能描述 |
|--------|------|----------|
| **GPManager.exe** | 6.6 MB | 游戏平台管理器，负责平台启动、用户登录、游戏列表展示、房间选择等核心功能 |

**GPManager.exe 主要功能**:
- 用户登录/注册界面
- 游戏大厅展示
- 房间列表管理
- 在线人数统计
- 用户信息管理
- 银行/充值系统
- 活动中心入口

### 3.2 游戏程序

| 游戏名称 | 可执行文件 | 大小 | 游戏类型 |
|----------|-----------|------|----------|
| 李逵捕鱼 | lkpy.exe | 728 KB | 捕鱼类 |
| 斗地主 | Land.exe | 22 MB | 棋牌类 |
| 麻将 | SparrowER.exe | 19 MB | 棋牌类 |
| 牛牛 | OxNew.exe | 22 MB | 棋牌类 |
| 炸金花 | ZaJinHua.exe | 26 MB | 棋牌类 |
| 五星宏辉 | FiveStar.exe | 33 MB | 老虎机类 |
| 百家乐 | BaccaratNew.exe | 11 MB | 赌场类 |
| 28杠 | 28GangBattle.exe | 7.9 MB | 骰子类 |
| 碰碰车大战 | BumperCarBattle.exe | 58 MB | 休闲竞技类 |

### 3.3 其他程序

| 文件名 | 功能 |
|--------|------|
| unins000.exe | 程序卸载器 |
| vcredist_x86.exe | Visual C++ 运行时安装包 |

---

## 4. 核心动态链接库

### 4.1 引擎核心库

| DLL文件 | 功能描述 |
|---------|----------|
| **MTUIEngine.dll** | UI引擎核心，处理界面渲染、事件分发、控件管理 |
| **MT3DEngine.dll** | 3D渲染引擎，处理游戏中的3D效果 |
| **MTImage.dll** | 图像处理模块，负责图片加载、解码、缓存 |
| **MTNetworkEngine.dll** | 网络通信引擎，处理Socket连接、协议解析 |
| **MTUI.dll** | UI组件库，提供基础UI控件 |
| **MTProcessService.dll** | 进程服务，管理游戏进程 |
| **MTSvrCenter.dll** | 服务器中心，处理服务器连接管理 |
| **MTBYMusic.dll** | 音乐播放模块 |

### 4.2 游戏控制库

| DLL文件 | 关联游戏 | 功能 |
|---------|----------|------|
| lkpyCtrl.dll | 李逵捕鱼 | 捕鱼游戏逻辑控制 |
| LandCtrl.dll | 斗地主 | 斗地主游戏逻辑 |
| SparrowERCtrl.dll | 麻将 | 麻将游戏逻辑 |
| OxNewCtrl.dll | 牛牛 | 牛牛游戏逻辑 |
| ZaJinHuaCtrl.dll | 炸金花 | 炸金花游戏逻辑 |
| FiveStarCtrl.dll | 五星宏辉 | 五星宏辉游戏逻辑 |
| BaccaratNewCtrl.dll | 百家乐 | 百家乐游戏逻辑 |
| 28GangBattleCtrl.dll | 28杠 | 28杠游戏逻辑 |
| BumperCarBattleCtrl.dll | 碰碰车 | 碰碰车游戏逻辑 |
| LKpyEngine.dll | 捕鱼引擎 | 捕鱼类游戏专用引擎 |

### 4.3 服务支持库

| DLL文件 | 功能描述 |
|---------|----------|
| CCGameSoa.dll | 游戏SOA服务架构 |
| CCShareCtrl.dll | 共享控制模块 |
| CCShareData.dll | 共享数据模块 |
| CCSvrAvatar.dll | 头像服务模块 |
| CCSvrUser.dll | 用户服务模块 |
| DownLoad.dll | 文件下载模块 |
| UpdateCheck.dll | 更新检查模块 |
| UpdateInfo.dll | 更新信息模块 |
| PlazaLog.dll | 广场日志模块 |

### 4.4 第三方依赖库

| DLL文件 | 来源 | 功能 |
|---------|------|------|
| D3DX9_43.dll | Microsoft | DirectX 9 图形库 |
| Msvcp71.dll | Microsoft | VC++ 2003 C++标准库 |
| Msvcr71.dll | Microsoft | VC++ 2003 C运行时 |
| bass.dll | un4seen | 音频播放库 |
| wke.dll | 开源WebKit | 内嵌浏览器引擎 |
| Flash.ocx | Adobe | Flash播放组件 |
| magic.dll | 自研 | 特效渲染模块 |
| magic3d.dll | 自研 | 3D特效模块 |

---

## 5. 游戏模块目录

每个游戏都有独立的资源目录，结构相似但内容各异。

### 5.1 通用游戏目录结构

```
游戏目录/
├── GameLevel.INI       # 游戏等级配置（必选）
├── TableResource.INI   # 桌面资源配置（必选）
├── Table.png           # 游戏桌面背景图
├── Ground.bmp          # 地面/背景图
├── Chair.png           # 椅子/座位图
├── Enter.png           # 入口界面图（部分游戏）
└── [其他游戏特定资源]
```

### 5.2 李逵捕鱼目录 (lkpy/)

**目录大小**: 52 MB（资源最丰富）

```
lkpy/
├── 📄 content.fish           # 主内容资源包
├── 📄 GameLevel.INI          # 等级配置
├── 📄 TableResource.INI      # 桌面配置
├── 📄 Table.png              # 桌面背景
├── 📄 Ground.bmp             # 地面图
├── 📄 Chair.png              # 椅子图
│
├── 📁 particle/              # 粒子特效
│   └── particle.ptc          # 粒子配置文件
│
├── 📁 images/                # 图片资源
│   ├── 📁 Fish/              # 鱼类图片（48种鱼）
│   │   ├── fish1.fish ~ fish24.fish    # 普通鱼
│   │   └── fish*_d.fish                # 鱼的死亡动画
│   │
│   ├── 📁 cannon/            # 炮台图片
│   │   ├── cannon*_norm.fish # 普通炮
│   │   ├── cannon*_double.fish # 双管炮
│   │   ├── cannon*_ion.fish  # 离子炮
│   │   └── gun*.fish         # 炮管
│   │
│   ├── 📁 bullet/            # 子弹图片
│   │   ├── bullet*_norm*.fish # 普通子弹
│   │   ├── bullet*_ion.fish   # 离子子弹
│   │   └── laser.fish         # 激光
│   │
│   ├── 📁 Scene/             # 场景背景
│   │   ├── bg1.fish ~ bg3.fish # 背景图
│   │   └── water*.fish        # 水波动画
│   │
│   ├── 📁 gui/               # 界面元素
│   │   ├── setDlg.fish       # 设置对话框
│   │   └── BT_OK.fish        # 确认按钮
│   │
│   ├── 📁 lock_fish/         # 锁定功能
│   │   └── lock_flag*.fish   # 锁定标记
│   │
│   ├── 📁 net/               # 渔网图片
│   ├── 📁 prize/             # 奖励界面
│   └── [其他UI元素]
│
└── 📁 sounds/                # 音效资源
    ├── 📁 bgm/               # 背景音乐
    │   ├── bgm1.fish ~ bgm4.fish
    │
    └── 📁 effect/            # 游戏音效
        ├── fire.fish         # 发射音效
        ├── catch.fish        # 捕获音效
        ├── fish*_1.fish      # 各种鱼的音效
        └── [更多音效文件]
```

**游戏特色功能**:
- 24种不同类型的鱼
- 4种炮台类型（普通、双管、离子）
- 多种场景背景
- 锁定功能
- 粒子特效系统
- 丰富的音效系统

### 5.3 斗地主目录 (Land/)

```
Land/
├── GameLevel.INI       # 等级配置（地主等级体系）
├── TableResource.INI   # 桌面配置
├── Table.png           # 牌桌背景
├── Ground.bmp          # 地面图
├── Chair.png           # 椅子图
└── [牌面资源在外部DLL中]
```

### 5.4 麻将目录 (SparrowER/)

```
SparrowER/
├── GameLevel.INI       # 等级配置
├── TableResource.INI   # 桌面配置（支持4人座位）
├── Table.png           # 牌桌背景
├── Ground.bmp          # 地面图
└── Chair.png           # 椅子图
```

### 5.5 其他游戏目录

| 目录 | 游戏类型 | 特殊配置 |
|------|----------|----------|
| OxNew/ | 牛牛 | 标准配置 |
| ZaJinHua/ | 炸金花 | 标准配置 |
| FiveStar/ | 五星宏辉 | 含Enter.png入口图 |
| BaccaratNew/ | 百家乐 | 含Enter.png入口图 |
| 28GangBattle/ | 28杠 | 标准配置 |
| BumperCarBattle/ | 碰碰车 | 标准配置 |
| DZShowHand/ | 德州扑克 | 标准配置 |

---

## 6. 界面框架目录

### 6.1 PlatformFrame/ - 平台框架界面

**功能**: 定义游戏平台主界面的UI元素和布局

```
PlatformFrame/
│
├── 📁 PlatformFrame/          # 主框架背景资源
│   ├── PlatformFrameBG.png    # 主背景图
│   ├── PersonalInfo.png       # 个人信息背景
│   ├── CheckGameCenter.png    # 游戏中心标签
│   ├── CheckRecharge.png      # 充值中心标签
│   ├── CheckCheckIn.png       # 签到标签
│   └── [更多UI元素]
│
├── 📁 DlgLogon/               # 登录界面
│   ├── logonBG.png            # 登录背景
│   ├── bt_EnterGame.png       # 进入游戏按钮
│   ├── bt_Register.png        # 注册按钮
│   └── [登录相关元素]
│
├── 📁 DlgRegister/            # 注册界面
│   ├── DlgBG.png              # 注册背景
│   ├── bt_Register.png        # 注册按钮
│   └── [注册表单元素]
│
├── 📁 DlgUserInfo/            # 用户信息界面
│   ├── backGround.png         # 信息背景
│   ├── account_label.png      # 账号标签
│   ├── password_label.png     # 密码标签
│   └── [信息表单元素]
│
├── 📁 DlgSetting/             # 设置界面
│   ├── DlgSettingBG.png       # 设置背景
│   ├── seliderBG.png          # 音量滑块背景
│   ├── seliderThumb.png       # 滑块按钮
│   └── [设置选项元素]
│
├── 📁 DlgCheckIn/             # 签到界面
│   ├── DlgBG1.png             # 签到背景
│   ├── bt_CheckIn.png         # 签到按钮
│   ├── Package1~3.png         # 礼包图标
│   └── [签到奖励元素]
│
├── 📁 DlgBackpack/            # 背包界面
│   ├── DlgBackPackBG.png      # 背包背景
│   ├── Prop.png               # 道具图标
│   └── [背包管理元素]
│
├── 📁 DlgInsureMain/          # 银行界面
│   ├── backGround.png         # 银行背景
│   ├── bt_SaveScore.png       # 存款按钮
│   ├── bt_TakeScore.png       # 取款按钮
│   └── [银行操作元素]
│
├── 📁 DlgService/             # 客服界面
│   ├── backGround.png         # 客服背景
│   ├── Message.png            # 消息图标
│   └── [客服功能元素]
│
├── 📁 DlgEmail/               # 邮件界面
│   ├── Email.png              # 邮件图标
│   ├── ContentBG.png          # 内容背景
│   └── [邮件系统元素]
│
├── 📁 DlgMatchIntroduce/      # 比赛介绍界面
│   ├── backGround.png         # 比赛背景
│   ├── bt_SignUp.png          # 报名按钮
│   └── [比赛信息元素]
│
├── 📁 DlgPersonalCenter/      # 个人中心
│   ├── bkimage.png            # 个人中心背景
│   ├── 📁 Face/               # 头像资源
│   │   ├── boy_head_1~6.png   # 男性头像
│   │   └── girl_head_1~6.png  # 女性头像
│   └── [个人中心元素]
│
├── 📁 DlgDownLoad/            # 下载界面
│   ├── DlgDownLoadBG.png      # 下载背景
│   ├── seliderBG.png          # 进度条背景
│   └── [下载管理元素]
│
├── 📁 DlgGameUpdate/          # 游戏更新界面
│   ├── bkimage.png            # 更新背景
│   └── [更新界面元素]
│
├── 📁 DlgWeb/                 # 网页容器界面
│   └── DlgWebBG.png           # 网页背景
│
├── 📁 DlgInputPassword/       # 密码输入界面
│   ├── bkimage.png            # 输入背景
│   └── [密码输入元素]
│
├── 📁 DlgStatus/              # 状态界面
│   ├── DlgStateBG.png         # 状态背景
│   └── [状态显示元素]
│
├── 📁 ServerViewItem/         # 服务器列表项
│   ├── ServerViewItemBG.png   # 列表项背景
│   └── [列表项元素]
│
├── 📁 PlazaViewItem/          # 广场视图项
│   ├── GameKindBG.png         # 游戏分类背景
│   ├── BtnEnterServer.png     # 进入服务器按钮
│   └── [广场视图元素]
│
├── 📁 MatchViewItem/          # 比赛视图项
│   ├── GameKindBG.png         # 比赛分类背景
│   └── [比赛视图元素]
│
├── 📁 PlazaEnquire/           # 广场查询界面
│   ├── enquireBG.png          # 查询背景
│   └── PlazaEnquire.xml       # 界面布局配置
│
├── 📁 UserInfo/               # 用户信息组件
│   ├── UserFace.png           # 用户头像框
│   ├── BK_GOLD.png            # 金币背景
│   └── UserInfoCtrl.xml       # 组件布局
│
├── 📁 GameTypeCtrl/           # 游戏类型控制
│   ├── opt_GameSaloon.png     # 游戏大厅选项
│   ├── opt_ActiveCenter.png   # 活动中心选项
│   └── [类型选择元素]
│
├── 📁 Public/                 # 公共资源
│   ├── DlgBG1.png             # 对话框背景1
│   ├── DlgBG2.png             # 对话框背景2
│   └── closebtn.png           # 关闭按钮
│
├── 📁 Flash/                  # Flash动画
│   ├── Banner.swf             # 横幅广告
│   ├── Logon.swf              # 登录动画
│   └── GameAction.swf         # 活动动画
│
├── 📁 Sound/                  # 平台音效
│   ├── BackMusic.mp3          # 背景音乐
│   └── ButtonEffect.mp3       # 按钮音效
│
├── 📁 KeyBoard/               # 软键盘
│   └── KeyBoard.res           # 键盘资源
│
├── 📁 InformationUI/          # 信息提示界面
│   ├── InformationBG.png      # 提示背景
│   ├── bt_Yes.png             # 是按钮
│   ├── bt_No.png              # 否按钮
│   └── [提示框元素]
│
├── PlatformFrame.xml          # 主框架布局配置
└── PlatformFrame.res          # 主框架资源定义
```

### 6.2 GPManagerPlatformFrame/ - 平台管理框架

**功能**: 提供平台管理的扩展界面元素

```
GPManagerPlatformFrame/
│
├── 📁 PlazaViewItem/          # 广场视图项扩展
│   ├── btn_GameCenter.png     # 游戏中心按钮
│   ├── btn_recharge.png       # 充值按钮
│   ├── btn_matchCenter.png    # 比赛中心按钮
│   └── [更多广场元素]
│
├── 📁 ServerViewItemPNG/      # 服务器列表项扩展
│   ├── VIP.png                # VIP标识
│   ├── Font.PNG               # 字体样式
│   ├── Enter.png              # 进入按钮
│   └── [列表项扩展元素]
│
├── 📁 DlgLogonImage/          # 登录界面扩展
│   ├── BackImage.png          # 登录背景
│   ├── btn_HomePage.png       # 主页按钮
│   └── [登录扩展元素]
│
├── 📁 DlgPersonalCenter/      # 个人中心扩展
│   ├── bk_showBkimage.png     # 背景展示
│   └── [个人中心扩展]
│
├── 📁 DlgInsureManager/       # 银行管理界面
│   ├── backGround.png         # 银行背景
│   ├── insureSaveBG.png       # 存款界面
│   ├── insureTransferBG.png   # 转账界面
│   └── [银行管理元素]
│
├── 📁 DlgInsurePlazaImage/    # 广场银行界面
│   ├── INSURE_ICON.PNG        # 银行图标
│   ├── BTN_OPERA_TRANSFER.png # 转账操作按钮
│   └── [广场银行元素]
│
├── 📁 DlgLotteryImage/        # 抽奖界面
│   ├── LotteryDetail.png      # 抽奖详情
│   ├── btn_Exchange.png       # 兑换按钮
│   └── [抽奖功能元素]
│
├── 📁 VipManagerImage/        # VIP管理界面
│   ├── VIP_LEVEL_0~8.png      # VIP等级图标
│   ├── btn_Recharge.png       # 充值按钮
│   └── [VIP管理元素]
│
├── 📁 WndUserInfoCtrlImage/   # 用户信息控制
│   ├── USER_AVATAR.png        # 用户头像
│   ├── 📁 VipLevel/           # VIP等级
│   │   └── VIP_LEVEL_0~8.png
│   └── [用户信息控制元素]
│
├── 📁 GameStorePortrayal/     # 游戏商店头像
│   ├── 📁 DefaultPortrayal/   # 默认头像
│   │   ├── boy.png / girl.png
│   │   └── boy_b.png / girl_b.png
│   ├── 📁 GameStorePortralResource/  # 商店资源
│   └── 📁 GameStoreBkGroundResource/ # 商店背景
│
├── 📁 Emotion/                # 表情包
│   ├── 0.gif ~ 134.gif        # 135个表情图片
│   └── IMAGE_SYSTEM.png       # 系统表情
│
├── 📁 InformationUI/          # 信息提示扩展
│   └── [提示框扩展元素]
│
├── 📁 DlgTrumpet/             # 喇叭广播界面
│   ├── BKIMAGE.png            # 广播背景
│   ├── btn_CONFIRM.png        # 确认按钮
│   └── [广播功能元素]
│
├── 📁 DlgPaltformTrumpet/     # 平台喇叭界面
│   ├── TRUMPET.png            # 喇叭图标
│   └── [平台广播元素]
│
├── 📁 DlgDownLoad/            # 下载管理扩展
│   ├── DownItemBG1~2.png      # 下载项背景
│   └── [下载扩展元素]
│
├── 📁 DlgStatusImage/         # 状态界面扩展
│   ├── DownLoadIng.png        # 下载中状态
│   └── [状态扩展元素]
│
├── 📁 DlgKickUser/            # 踢人界面
│   ├── btn_kickUser.png       # 踢人按钮
│   └── [踢人功能元素]
│
├── 📁 DlgLockMachineImge/     # 锁机界面
│   ├── bound.png              # 已绑定
│   ├── Unbound.png            # 未绑定
│   └── [锁机功能元素]
│
├── 📁 GameServerListNode/     # 游戏服务器列表节点
│   ├── OnlineLevel.png        # 在线等级
│   └── [服务器节点元素]
│
├── 📁 GameKindListNode/       # 游戏分类节点
│   ├── HotGame.PNG            # 热门游戏
│   ├── NewGame.PNG            # 新游戏
│   └── [分类节点元素]
│
├── 📁 GameTypeListNode/       # 游戏类型节点
│   └── [类型节点元素]
│
├── 📁 MenuWndUserIfo/         # 用户信息菜单
│   └── [菜单元素]
│
├── 📁 MenuPlatTray/           # 平台托盘菜单
│   └── [托盘菜单元素]
│
├── 📁 TreeNodePNG/            # 树节点图标
│   ├── list_btn.png           # 列表按钮
│   └── [树节点元素]
│
├── 📁 ListContainerPNG/       # 列表容器图标
│   └── VIP.png                # VIP图标
│
├── 📁 PlatformFramePNG/       # 平台框架图标
│   ├── LOGO.png               # 平台Logo
│   ├── LevelBK.png            # 等级背景
│   └── [框架图标元素]
│
├── 📁 ImageUtils/             # 图片工具
│   ├── Bank_Title.png         # 银行标题
│   ├── Store_Title.png        # 商店标题
│   └── [工具图片]
│
├── 📁 LastGame/               # 最近游戏
│   └── LastGame.res           # 最近游戏资源
│
├── 📁 DlgEnquireImage/        # 查询界面
│   ├── BT_ENQUIRE_PLAZA.png   # 广场查询
│   └── [查询界面元素]
│
├── 📁 DlgTablePasswordImage/  # 桌子密码界面
│   └── lock.PNG               # 锁定图标
│
├── 📁 DlgSearchImage/         # 搜索界面
│   ├── Search.png             # 搜索图标
│   └── [搜索界面元素]
│
├── 📁 DlgBagCenterImage/      # 背包中心界面
│   └── ObjectFrame.PNG        # 物品框
│
├── 📁 DlgDissmissGame/        # 解散游戏界面
│   └── [解散游戏元素]
│
├── 📁 DlgInssueMessage/       # 发布消息界面
│   └── [消息发布元素]
│
├── 📁 DlgModefyPersonInfoImage/ # 修改个人信息界面
│   └── [个人信息修改元素]
│
├── 📁 DlgServicePasswordImage/ # 服务密码界面
│   └── [密码服务元素]
│
├── 📁 DlgBaseEnsureImage/     # 基础确认界面
│   └── [确认界面元素]
│
├── 📁 DlgFontSelPopWndUI/     # 字体选择弹出界面
│   └── [字体选择元素]
│
├── 📁 ServerListView/         # 服务器列表视图
│   └── [列表视图元素]
│
├── 📁 ServerItemListImage/    # 服务器列表项图片
│   └── [列表项图片]
│
├── 📁 PlazaViewItemResoure/   # 广场视图项资源
│   └── [广场视图资源]
│
├── 📁 KeyBoardImage/          # 软键盘图片
│   └── KeyBoard.png           # 键盘图片
│
├── 📁 CUserInfoWnd/           # 用户信息窗口
│   └── BKimage.png            # 信息背景
│
├── 📁 DlgManagerUser/         # 用户管理界面
│   └── [用户管理元素]
│
├── 📁 MenuEditUI/             # 编辑菜单界面
│   └── [编辑菜单元素]
│
├── 📁 MenuWhisperMsgSet/      # 私聊消息设置菜单
│   └── [私聊设置元素]
│
├── 📁 MenuMessageControl/     # 消息控制菜单
│   └── [消息控制元素]
│
├── 📁 MenuColorEx/            # 颜色选择菜单
│   └── [颜色选择元素]
│
├── 📁 MenuServerUserInfo/     # 服务器用户信息菜单
│   └── [服务器用户信息元素]
│
├── 📁 MenuServerViewMoreChoose/ # 服务器视图更多选择菜单
│   └── [更多选择元素]
│
├── 📁 MenuShortMessage/       # 短消息菜单
│   └── [短消息元素]
│
├── 📁 Expression/             # 表情资源
│   └── Expression.res         # 表情定义
│
├── 📁 DlgGameUpdate/          # 游戏更新界面
│   └── [更新界面元素]
│
└── PlatformFrame.res          # 框架资源定义
```

### 6.3 GameFrameWnd/ - 游戏框架窗口

**功能**: 提供游戏内公共界面组件

```
GameFrameWnd/
│
├── 📁 DlgInsureMain/          # 游戏内银行界面
│   ├── backGround.png         # 银行背景
│   ├── insureSaveBG.png       # 存款界面
│   ├── insureTransferBG.png   # 转账界面
│   ├── bt_SaveScore.png       # 存款按钮
│   ├── bt_TakeScore.png       # 取款按钮
│   └── [银行操作元素]
│
├── 📁 SoundVolumeWnd/         # 音量调节窗口
│   ├── BackGround.png         # 音量背景
│   ├── seliderBG.png          # 滑块背景
│   ├── seliderThumb.png       # 滑块按钮
│   ├── bt_Add.png             # 增加按钮
│   ├── bt_Reduce.png          # 减少按钮
│   └── [音量调节元素]
│
├── 📁 InformationUI/          # 游戏内信息提示
│   ├── InformationBG.png      # 信息背景
│   ├── bt_Yes.png             # 是按钮
│   ├── bt_No.png              # 否按钮
│   ├── bt_Determine.png       # 确定按钮
│   ├── bt_Cancel.png          # 取消按钮
│   └── [信息提示元素]
│
└── 📁 KeyBoard/               # 游戏内软键盘
    ├── KeyBoard.res           # 键盘资源
    └── Close.PNG              # 关闭按钮
```

### 6.4 GPManagerImage/ - 平台图片资源

**功能**: 存储游戏分类图标和标题图片

```
GPManagerImage/
│
├── 📁 GameKind/               # 游戏分类图标
│   ├── GameKind_Lkpy.png      # 李逵捕鱼图标
│   ├── GameKind_Land.png      # 斗地主图标
│   ├── GameKind_SparrowER.png # 麻将图标
│   ├── GameKind_OxNew.png     # 牛牛图标
│   ├── GameKind_ZaJinHua.png  # 炸金花图标
│   ├── GameKind_FiveStar.png  # 五星宏辉图标
│   ├── GameKind_BaccaratNew.png # 百家乐图标
│   ├── GameKind_28GangBattle.png # 28杠图标
│   ├── GameKind_BumperCarBattle.png # 碰碰车图标
│   ├── GameKind_Fish3.png     # 捕鱼3图标
│   ├── GameKind_Lkfish.png    # 李逵捕鱼类图标
│   ├── GameKind_DZShowHand.png # 德州扑克图标
│   ├── GameKind_HKFiveCardNew.png # 五张牌图标
│   ├── GameKind_Thirteen.png  # 十三水图标
│   └── GameKind_Unknow*.png   # 未知游戏图标
│
├── 📁 GameTitle/              # 游戏标题图片
│   ├── GameTitle_Lkpy.png     # 李逵捕鱼标题
│   ├── GameTitle_Land.png     # 斗地主标题
│   ├── GameTitle_SparrowER.png # 麻将标题
│   ├── GameTitle_OxNew.png    # 牛牛标题
│   ├── GameTitle_ZaJinHua.png # 炸金花标题
│   ├── GameTitle_FiveStar.png # 五星宏辉标题
│   ├── GameTitle_BaccaratNew.png # 百家乐标题
│   ├── GameTitle_28GangBattle.png # 28杠标题
│   ├── GameTitle_BumperCarBattle.png # 碰碰车标题
│   ├── GameTitle_Jcby.png     # JC捕鱼标题
│   ├── GameTitle_Match_Land.png # 比赛斗地主标题
│   ├── MatchTitle_Immediate_*.png # 即时比赛标题
│   ├── MatchTitle_LockTime_*.png # 定时比赛标题
│   └── GameTitle_Unknow_Title.png # 未知标题
│
└── 📁 GameServer/             # 服务器图标
    └── GameServer_UnKnow.png  # 默认服务器图标
```

---

## 7. 资源文件目录

### 7.1 资源格式说明

| 格式 | 用途 | 说明 |
|------|------|------|
| .fish | 游戏资源包 | 自定义打包格式，包含图片/音效 |
| .png | 静态图片 | 界面元素、图标 |
| .bmp | 位图 | 背景图片 |
| .gif | 动画图片 | 表情动画 |
| .swf | Flash动画 | 动态广告/动画 |
| .mp3 | 音频文件 | 背景音乐、音效 |
| .res | 资源定义 | 界面资源定义文件 |
| .xml | 布局配置 | DirectUI界面布局 |
| .ptc | 粒子配置 | 粒子特效配置 |

### 7.2 .fish 文件格式

`.fish` 是项目自定义的资源打包格式，特点：
- 打包多个资源到单一文件
- 支持图片和音效
- 可能包含压缩和加密
- 游戏运行时动态加载

---

## 8. 配置文件说明

### 8.1 主配置文件

#### ServerInfo.INI

```ini
[GlobalInfo]
; 服务器连接信息（加密存储）
LastServerName=加密的服务器地址
```

**功能**: 存储最近连接的服务器信息

### 8.2 游戏配置文件

#### GameLevel.INI（每个游戏目录）

```ini
[LevelDescribe]
; 等级配置
; 格式: LevelItemN=等级名称,所需经验值
LevelItem1=农奴
LevelItem2=乞丐,60
LevelItem3=贫农,160
...
LevelItem20=诸侯,1000000
```

**功能**: 定义游戏的等级系统和升级所需经验值

#### TableResource.INI（每个游戏目录）

```ini
[Attribute]
TableItemCount=2          ; 桌子数量
ChairItemCount=8          ; 椅子数量

[Color]
Color_Name=RGB(200,200,200)    ; 普通玩家名称颜色
Color_Member=RGB(0,255,255)    ; 会员名称颜色
Color_Master=RGB(0,255,255)    ; 房主名称颜色

[Position]
Point_Lock=138,148        ; 锁定按钮位置
Point_TableID=196,340     ; 桌子ID位置
Point_Chair1=120,35       ; 椅子位置
...
```

**功能**: 定义游戏桌面的UI布局和显示参数

### 8.3 界面配置文件

#### PlatformFrame.xml

```xml
<?xml version="1.0" encoding="utf-8" standalone="yes" ?>
<Window size="1024,768" roundcorner="10,10" caption="0,0,0,39" mininfo="1024,768" maxinfo="1024,768">
  <Font id="0" name="宋体" size="12" bold="true" />
  ...
  <HorizontalLayout>
    <!-- 界面布局定义 -->
  </HorizontalLayout>
</Window>
```

**功能**: 定义主平台的界面布局、字体、控件位置

#### .res 文件

二进制或文本格式的资源定义文件，定义界面元素的图片资源和属性。

---

## 9. 功能模块详解

### 9.1 用户系统模块

| 功能 | 实现位置 | 说明 |
|------|----------|------|
| 用户登录 | PlatformFrame/DlgLogon/ | 账号密码登录、记住密码 |
| 用户注册 | PlatformFrame/DlgRegister/ | 新用户注册、验证码 |
| 个人信息 | PlatformFrame/DlgUserInfo/ | 修改个人信息 |
| 头像管理 | GPManagerPlatformFrame/GameStorePortrayal/ | 头像选择、自定义 |
| 个人中心 | PlatformFrame/DlgPersonalCenter/ | 个人中心入口 |
| VIP系统 | GPManagerPlatformFrame/VipManagerImage/ | VIP等级、特权 |

### 9.2 游戏大厅模块

| 功能 | 实现位置 | 说明 |
|------|----------|------|
| 游戏列表 | GPManagerImage/GameKind/ | 游戏分类展示 |
| 服务器列表 | PlatformFrame/ServerViewItem/ | 房间列表、在线人数 |
| 快速匹配 | GPManagerPlatformFrame/PlazaViewItem/ | 快速进入游戏 |
| 比赛系统 | PlatformFrame/MatchViewItem/ | 比赛报名、积分排名 |

### 9.3 金融系统模块

| 功能 | 实现位置 | 说明 |
|------|----------|------|
| 银行系统 | PlatformFrame/DlgInsureMain/ | 存取款、转账 |
| 银行管理 | GPManagerPlatformFrame/DlgInsureManager/ | 银行操作界面 |
| 充值中心 | 平台框架/ | 充值入口 |
| 金币兑换 | 平台框架/ | 金币兑换功能 |

### 9.4 社交系统模块

| 功能 | 实现位置 | 说明 |
|------|----------|------|
| 签到系统 | PlatformFrame/DlgCheckIn/ | 每日签到、奖励领取 |
| 背包系统 | PlatformFrame/DlgBackpack/ | 道具管理 |
| 邮件系统 | PlatformFrame/DlgEmail/ | 系统邮件、奖励领取 |
| 表情系统 | GPManagerPlatformFrame/Emotion/ | 135个表情图片 |
| 喇叭广播 | GPManagerPlatformFrame/DlgTrumpet/ | 全服广播 |

### 9.5 辅助功能模块

| 功能 | 实现位置 | 说明 |
|------|----------|------|
| 设置中心 | PlatformFrame/DlgSetting/ | 音量、显示设置 |
| 客服系统 | PlatformFrame/DlgService/ | 客服联系 |
| 下载管理 | PlatformFrame/DlgDownLoad/ | 游戏下载、更新 |
| 游戏更新 | PlatformFrame/DlgGameUpdate/ | 版本更新 |
| 软键盘 | GameFrameWnd/KeyBoard/ | 安全密码输入 |
| 消息提示 | GameFrameWnd/InformationUI/ | 系统消息弹窗 |

### 9.6 管理功能模块

| 功能 | 实现位置 | 说明 |
|------|----------|------|
| 锁机绑定 | GPManagerPlatformFrame/DlgLockMachineImge/ | 设备绑定 |
| 踢人功能 | GPManagerPlatformFrame/DlgKickUser/ | 房主踢人 |
| 解散房间 | GPManagerPlatformFrame/DlgDissmissGame/ | 解散游戏房间 |
| 用户管理 | GPManagerPlatformFrame/DlgManagerUser/ | 用户管理 |

---

## 10. 附录

### 10.1 文件扩展名速查

| 扩展名 | 类型 | 说明 |
|--------|------|------|
| .exe | 可执行文件 | 程序入口 |
| .dll | 动态链接库 | 功能模块 |
| .fish | 资源包 | 游戏资源 |
| .INI | 配置文件 | 游戏配置 |
| .xml | 布局文件 | UI布局 |
| .res | 资源定义 | 界面资源 |
| .png | 图片 | 静态图片 |
| .bmp | 位图 | 背景图 |
| .gif | 动画 | 表情动画 |
| .swf | Flash | 动画广告 |
| .mp3 | 音频 | 音乐音效 |
| .ptc | 粒子 | 特效配置 |

### 10.2 技术架构图

```
┌─────────────────────────────────────────────────────────────┐
│                    Bojin 游戏平台架构                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                   GPManager.exe                      │   │
│  │                   (主程序入口)                        │   │
│  └─────────────────────────────────────────────────────┘   │
│                           │                                 │
│  ┌────────────────────────┼────────────────────────┐       │
│  │                        ▼                        │       │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐     │       │
│  │  │MTUIEngine│  │MT3DEngine│  │MTNetwork │     │       │
│  │  │(UI引擎)  │  │(3D引擎)  │  │(网络引擎)│     │       │
│  │  └──────────┘  └──────────┘  └──────────┘     │       │
│  │                      核心引擎层                   │       │
│  └─────────────────────────────────────────────────┘       │
│                           │                                 │
│  ┌────────────────────────┼────────────────────────┐       │
│  │                        ▼                        │       │
│  │  ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ │       │
│  │  │ lkpy │ │ Land │ │Sparrow│ │ OxNew│ │ ...  │ │       │
│  │  │(捕鱼)│ │(斗地主)│ │(麻将)│ │(牛牛)│ │      │ │       │
│  │  └──────┘ └──────┘ └──────┘ └──────┘ └──────┘ │       │
│  │                      游戏模块层                   │       │
│  └─────────────────────────────────────────────────┘       │
│                           │                                 │
│  ┌────────────────────────┼────────────────────────┐       │
│  │                        ▼                        │       │
│  │  ┌──────────────────────────────────────────┐   │       │
│  │  │         DirectX 9.0c / BASS Audio        │   │       │
│  │  │              (系统依赖层)                  │   │       │
│  │  └──────────────────────────────────────────┘   │       │
│  └─────────────────────────────────────────────────┘       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 10.3 数据流程图

```
用户操作 → GPManager.exe → 游戏选择 → 加载游戏资源
                                        │
                    ┌───────────────────┼───────────────────┐
                    ▼                   ▼                   ▼
              MTUIEngine           MT3DEngine          MTNetwork
              (界面渲染)            (3D效果)            (网络通信)
                    │                   │                   │
                    └───────────────────┼───────────────────┘
                                        ▼
                                   游戏服务器
```

---

**文档版本**: 1.0  
**更新日期**: 2024年  
**适用项目**: Bojin 游戏平台客户端
