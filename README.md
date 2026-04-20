# Bojin 游戏平台

## 项目简介

Bojin（博金）是一个Windows桌面游戏平台客户端，提供多款经典棋牌游戏的在线娱乐服务。平台采用自主研发的游戏引擎，支持多种游戏类型，包括捕鱼游戏、棋牌游戏等。

## 技术架构

### 系统类型
- **平台**: Windows 32位桌面应用程序
- **架构**: PE32 (Intel i386)
- **界面引擎**: 自研UI引擎 (DirectUI风格)
- **图形引擎**: DirectX 9
- **网络引擎**: 自研网络通信模块

### 核心技术组件

| 组件 | 说明 |
|------|------|
| MTUIEngine.dll | UI引擎核心 |
| MT3DEngine.dll | 3D渲染引擎 |
| MTImage.dll | 图像处理模块 |
| MTNetworkEngine.dll | 网络通信引擎 |
| LKpyEngine.dll | 捕鱼游戏引擎 |
| magic.dll/magic3d.dll | 特效渲染模块 |

## 系统要求

### 最低配置
- **操作系统**: Windows XP / Windows 7 / Windows 10 / Windows 11
- **处理器**: Intel Pentium 4 或同等性能处理器
- **内存**: 512 MB RAM
- **显卡**: 支持DirectX 9.0c的显卡
- **硬盘**: 300 MB可用空间
- **网络**: 宽带互联网连接

### 推荐配置
- **操作系统**: Windows 10 / Windows 11
- **处理器**: Intel Core i3 或更高
- **内存**: 2 GB RAM
- **显卡**: 支持DirectX 9.0c的独立显卡
- **硬盘**: 500 MB可用空间
- **网络**: 稳定的宽带连接

## 目录结构

```
bojin/
├── GPManager.exe              # 主程序（游戏平台管理器）
├── ServerInfo.INI             # 服务器连接配置
├── GPManagerLog.txt           # 平台日志文件
├── DownLoadLog.txt            # 下载日志文件
│
├── 游戏可执行文件/
│   ├── lkpy.exe              # 李逵捕鱼
│   ├── Land.exe              # 斗地主
│   ├── SparrowER.exe         # 麻将
│   ├── OxNew.exe             # 牛牛
│   ├── ZaJinHua.exe          # 炸金花
│   ├── FiveStar.exe          # 五星宏辉
│   ├── BaccaratNew.exe       # 百家乐
│   ├── 28GangBattle.exe      # 28杠
│   └── BumperCarBattle.exe   # 碰碰车大战
│
├── 核心DLL组件/
│   ├── MTUI.dll              # UI组件库
│   ├── MTUIEngine.dll        # UI引擎
│   ├── MT3DEngine.dll        # 3D引擎
│   ├── MTImage.dll           # 图像处理
│   ├── MTNetworkEngine.dll   # 网络引擎
│   ├── LKpyEngine.dll        # 捕鱼引擎
│   ├── magic.dll             # 特效模块
│   ├── magic3d.dll           # 3D特效
│   └── ...
│
├── 游戏资源目录/
│   ├── lkpy/                 # 李逵捕鱼资源
│   │   ├── images/           # 游戏图片资源
│   │   ├── sounds/           # 音效资源
│   │   ├── GameLevel.INI     # 等级配置
│   │   └── TableResource.INI # 桌面资源配置
│   ├── Land/                 # 斗地主资源
│   ├── SparrowER/            # 麻将资源
│   ├── OxNew/                # 牛牛资源
│   ├── ZaJinHua/             # 炸金花资源
│   ├── FiveStar/             # 五星宏辉资源
│   ├── BaccaratNew/          # 百家乐资源
│   ├── 28GangBattle/         # 28杠资源
│   ├── BumperCarBattle/      # 碰碰车大战资源
│   └── DZShowHand/           # 德州扑克资源
│
├── 界面资源/
│   ├── PlatformFrame/        # 平台框架界面
│   ├── GPManagerPlatformFrame/ # 平台管理界面
│   ├── GameFrameWnd/         # 游戏框架窗口
│   └── GPManagerImage/       # 平台图片资源
│
└── 系统依赖/
    ├── D3DX9_43.dll          # DirectX 9
    ├── Msvcp71.dll           # VC++运行时
    ├── Msvcr71.dll           # VC++运行时
    ├── Flash.ocx             # Flash播放组件
    ├── wke.dll               # WebKit浏览器组件
    └── vcredist_x86.exe      # VC++运行时安装包
```

## 游戏模块说明

### 游戏列表

| 游戏 | 可执行文件 | 控制DLL | 说明 |
|------|-----------|---------|------|
| 李逵捕鱼 | lkpy.exe | lkpyCtrl.dll | 经典捕鱼游戏 |
| 斗地主 | Land.exe | LandCtrl.dll | 三人扑克游戏 |
| 麻将 | SparrowER.exe | SparrowERCtrl.dll | 经典麻将游戏 |
| 牛牛 | OxNew.exe | OxNewCtrl.dll | 扑克牛牛游戏 |
| 炸金花 | ZaJinHua.exe | ZaJinHuaCtrl.dll | 扑克炸金花 |
| 五星宏辉 | FiveStar.exe | FiveStarCtrl.dll | 老虎机类游戏 |
| 百家乐 | BaccaratNew.exe | BaccaratNewCtrl.dll | 赌场百家乐 |
| 28杠 | 28GangBattle.exe | 28GangBattleCtrl.dll | 骰子类游戏 |
| 碰碰车大战 | BumperCarBattle.exe | BumperCarBattleCtrl.dll | 休闲竞技游戏 |
| 德州扑克 | - | DZShowHandCtrl.dll | 扑克德州扑克 |

## 配置文件说明

### 1. ServerInfo.INI（服务器配置）

```ini
[GlobalInfo]
; 服务器连接信息（加密存储）
LastServerName=加密的服务器地址
```

**配置说明**:
- `LastServerName`: 最近连接的服务器信息（加密存储）

### 2. GameLevel.INI（游戏等级配置）

每个游戏目录下都包含此配置文件，定义游戏等级系统：

```ini
[LevelDescribe]
; 等级配置格式: LevelItemN=等级名称,所需经验值
LevelItem1=农奴
LevelItem2=乞丐,60
LevelItem3=贫农,160
LevelItem4=流浪汉,320
LevelItem5=包身工,560
LevelItem6=短工,920
LevelItem7=长工,1400
LevelItem8=贫农,2080
LevelItem9=中农,3200
LevelItem10=富农,4800
LevelItem11=地主,7200
LevelItem12=土财主,10800
LevelItem13=大地主,16000
LevelItem14=大财主,27200
LevelItem15=恶霸地主,48000
LevelItem16=恶霸财主,80000
LevelItem17=奴隶主,136000
LevelItem18=大奴隶主,240000
LevelItem19=地方豪强,400000
LevelItem20=诸侯,1000000
```

### 3. TableResource.INI（桌面资源配置）

定义游戏桌面的UI布局和资源：

```ini
[Attribute]
; 桌子数量和椅子数量
TableItemCount=2
ChairItemCount=8

[Color]
; 玩家名称颜色
Color_Name=RGB(200,200,200)
Color_Member=RGB(0,255,255)
Color_Master=RGB(0,255,255)

[Position]
; 桌面元素位置配置
Point_Lock=138,148        ; 锁定位置
Point_TableID=196,340     ; 桌子ID位置
Point_Ready1=107,90       ; 准备按钮位置
Point_Chair1=120,35       ; 椅子位置
```

### 4. PlatformFrame.xml（平台界面配置）

定义游戏平台的主界面布局：

```xml
<?xml version="1.0" encoding="utf-8" standalone="yes" ?>
<Window size="1024,768" roundcorner="10,10" caption="0,0,0,39" mininfo="1024,768" maxinfo="1024,768">
  <!-- 界面布局定义 -->
  <HorizontalLayout>
    <!-- 左侧用户信息 -->
    <VerticalLayout width="194">
      <UserInfoCtrl name="userInfo" height="200" bkimage="PlatformFrame/PersonalInfo.png"/>
    </VerticalLayout>
    <!-- 右侧游戏区域 -->
    <VerticalLayout>
      <!-- 游戏中心标签页 -->
      <TabLayout name="TabPlazaView">
        <PlazaViewItem name="PlazaViewItem"/>
        <ServerViewItem name="ServerViewItem"/>
      </TabLayout>
    </VerticalLayout>
  </HorizontalLayout>
</Window>
```

## 依赖组件

### 必需运行时

| 组件 | 文件 | 说明 |
|------|------|------|
| DirectX 9.0c | D3DX9_43.dll | 图形渲染支持 |
| VC++ 2003运行时 | Msvcp71.dll, Msvcr71.dll | C++运行时库 |
| Flash Player | Flash.ocx | Flash动画播放 |
| WebKit | wke.dll | 内嵌浏览器支持 |
| BASS音频 | bass.dll | 音频播放支持 |

### 安装依赖

项目包含 `vcredist_x86.exe` 安装程序，用于安装Visual C++运行时组件。

## 资源文件格式

### .fish 文件
游戏使用自定义的 `.fish` 格式存储图片和音效资源，这是一种打包格式，包含：
- 图片资源：游戏界面元素、动画帧
- 音效资源：背景音乐、游戏音效

### 资源目录结构示例（以李逵捕鱼为例）

```
lkpy/
├── content.fish           # 主内容包
├── particle/              # 粒子特效
│   └── particle.ptc
├── images/                # 图片资源
│   ├── Fish/             # 鱼类图片
│   ├── cannon/           # 炮台图片
│   ├── bullet/           # 子弹图片
│   ├── Scene/            # 场景背景
│   ├── gui/              # 界面元素
│   └── ...
└── sounds/                # 音效资源
    ├── bgm/              # 背景音乐
    └── effect/           # 游戏音效
```

## 平台功能模块

### 用户系统
- 用户登录/注册
- 个人信息管理
- 等级系统
- 积分/金币管理

### 游戏大厅
- 游戏列表展示
- 房间选择
- 在线人数显示
- 快速匹配

### 其他功能
- 签到系统
- 活动中心
- 充值中心
- 银行系统（虚拟货币管理）
- 道具背包
- 排行榜

## 开发与调试

### 日志文件
- `GPManagerLog.txt` - 平台运行日志
- `DownLoadLog.txt` - 资源下载日志
- `UpdataCheckLog.txt` - 更新检查日志

### 窗口配置
- 默认分辨率: 1024 x 768
- 最小窗口: 1024 x 768
- 最大窗口: 1024 x 768

## 注意事项

1. **系统兼容性**: 程序为32位应用，在64位Windows系统上运行时需确保32位运行时已正确安装
2. **网络连接**: 需要稳定的网络连接才能正常使用
3. **防火墙设置**: 可能需要将程序添加到防火墙白名单
4. **管理员权限**: 某些情况下可能需要管理员权限运行

## 版本信息

- **创建时间**: 2017年11月2日
- **开发团队**: 猫推网络 (www.maotui.cn)

## 许可声明

本项目仅供学习和研究使用。请遵守当地法律法规，理性游戏。
