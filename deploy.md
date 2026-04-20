# Bojin 游戏平台部署文档

## 部署概述

本文档详细说明了Bojin游戏平台的完整部署流程，包括服务器端配置、客户端分发、环境准备等内容。

---

## 一、环境准备

### 1.1 服务器端要求

由于本项目为客户端程序，完整的游戏平台部署需要配套的游戏服务器。以下是推荐的服务器配置：

| 配置项 | 最低要求 | 推荐配置 |
|--------|----------|----------|
| CPU | 4核心 | 8核心+ |
| 内存 | 8 GB | 16 GB+ |
| 存储 | 100 GB SSD | 500 GB SSD |
| 带宽 | 10 Mbps | 100 Mbps+ |
| 操作系统 | Windows Server 2012 | Windows Server 2019 |

### 1.2 客户端运行环境

#### Windows系统要求
- Windows XP SP3 或更高版本
- Windows 7 / 8 / 8.1 / 10 / 11
- Windows Server 2008 R2 或更高版本

#### 必需软件组件

```
┌─────────────────────────────────────────────────────────────┐
│                    客户端运行时依赖                          │
├─────────────────────────────────────────────────────────────┤
│  1. DirectX 9.0c End-User Runtime                          │
│  2. Microsoft Visual C++ 2003 Redistributable (x86)        │
│  3. Adobe Flash Player ActiveX (可选，用于部分UI动画)       │
│  4. .NET Framework 2.0+ (可选，用于自动更新程序)            │
└─────────────────────────────────────────────────────────────┘
```

---

## 二、安装部署

### 2.1 客户端安装

#### 方式一：完整安装包部署

1. **准备安装包**
   ```batch
   # 安装包包含以下文件
   bojin-setup.exe           # 安装程序
   unins000.exe              # 卸载程序
   unins000.dat              # 卸载数据
   ```

2. **执行安装**
   - 双击安装程序
   - 选择安装目录（默认：C:\Program Files\Bojin）
   - 完成安装

3. **安装后检查**
   ```
   安装目录结构:
   C:\Program Files\Bojin\
   ├── GPManager.exe         # 主程序
   ├── *.dll                 # 核心组件
   ├── lkpy/                 # 游戏资源
   ├── Land/
   └── ...
   ```

#### 方式二：绿色版部署（免安装）

1. **复制文件**
   ```batch
   xcopy /E /I /Y "bojin-source" "C:\Games\Bojin"
   ```

2. **安装运行时依赖**
   ```batch
   # 安装 DirectX
   dxwebsetup.exe
   
   # 安装 VC++ 运行时
   vcredist_x86.exe /q
   ```

3. **创建桌面快捷方式**
   ```batch
   # 创建快捷方式到 GPManager.exe
   ```

### 2.2 依赖组件安装

#### DirectX 9.0c 安装

```batch
# 方式1: 使用DirectX Web安装程序
dxwebsetup.exe

# 方式2: 手动安装
# 从Microsoft官网下载DirectX End-User Runtime
# 运行安装程序并按提示操作
```

#### Visual C++ 运行时安装

```batch
# 静默安装 VC++ 2003 运行时
vcredist_x86.exe /q

# 或者安装VC++全系列运行时（推荐）
# 下载并安装 Microsoft Visual C++ All-in-One Runtimes
```

#### Flash Player ActiveX 安装（可选）

```batch
# 如果系统未安装Flash Player
# 下载Flash Player ActiveX安装程序
# 运行安装程序
```

---

## 三、配置说明

### 3.1 服务器连接配置

编辑 `ServerInfo.INI` 文件配置服务器连接：

```ini
[GlobalInfo]
; 服务器地址配置（加密格式）
; 格式：加密的服务器地址和端口信息
LastServerName=<加密的服务器信息>
```

#### 服务器配置说明

| 参数 | 说明 | 示例 |
|------|------|------|
| LastServerName | 加密存储的服务器地址 | 加密字符串 |

**配置步骤**：
1. 获取服务器地址（如：game.example.com）
2. 使用加密工具将服务器信息加密
3. 将加密结果填入 `LastServerName`

### 3.2 游戏等级配置

修改各游戏目录下的 `GameLevel.INI` 文件：

```ini
[LevelDescribe]
; 等级配置
; 格式: LevelItemN=等级名称,所需经验值
LevelItem1=新手
LevelItem2=初级,100
LevelItem3=中级,500
LevelItem4=高级,1500
LevelItem5=专家,5000
```

**参数说明**：
- `LevelItemN`: 第N个等级
- `等级名称`: 显示的等级名称
- `所需经验值`: 升级所需的经验值（首个等级无需经验值）

### 3.3 桌面资源配置

修改 `TableResource.INI` 文件配置游戏桌面：

```ini
[Attribute]
; 桌子和椅子数量
TableItemCount=2          ; 桌子数量
ChairItemCount=8          ; 每桌椅子数

[Color]
; 颜色配置
Color_Name=RGB(200,200,200)      ; 普通玩家名称颜色
Color_Member=RGB(0,255,255)      ; 会员名称颜色
Color_Master=RGB(0,255,255)      ; 房主名称颜色

[Position]
; 位置配置（像素坐标）
Point_Lock=138,148               ; 锁定图标位置
Point_TableID=196,340            ; 桌号显示位置
Point_Chair1=120,35              ; 1号椅子位置
Point_Chair2=208,60              ; 2号椅子位置
Point_Chair3=228,133             ; 3号椅子位置
Point_Chair4=208,215             ; 4号椅子位置
Point_Chair5=120,237             ; 5号椅子位置
Point_Chair6=32,215              ; 6号椅子位置
Point_Chair7=17,133              ; 7号椅子位置
Point_Chair8=32,60               ; 8号椅子位置
```

### 3.4 平台界面配置

编辑 `PlatformFrame.xml` 文件自定义界面：

```xml
<?xml version="1.0" encoding="utf-8" standalone="yes" ?>
<Window size="1024,768" 
        roundcorner="10,10" 
        caption="0,0,0,39" 
        mininfo="1024,768" 
        maxinfo="1024,768">
  
  <!-- 字体配置 -->
  <Font id="0" name="宋体" size="12" bold="true" />
  <Font id="1" name="黑体" size="14" />
  
  <!-- 界面布局 -->
  <HorizontalLayout>
    <!-- 自定义布局内容 -->
  </HorizontalLayout>
</Window>
```

---

## 四、网络配置

### 4.1 端口配置

游戏平台可能使用以下端口：

| 端口 | 协议 | 用途 |
|------|------|------|
| 8000-8100 | TCP | 游戏服务器连接 |
| 80/443 | TCP | HTTP/HTTPS通信 |
| 自定义 | TCP/UDP | 游戏数据传输 |

### 4.2 防火墙设置

#### Windows防火墙配置

```powershell
# 添加主程序到防火墙白名单
netsh advfirewall firewall add rule name="Bojin Game Platform" `
    dir=in action=allow program="C:\Games\Bojin\GPManager.exe" enable=yes

# 添加所有游戏程序
$games = @("lkpy.exe", "Land.exe", "SparrowER.exe", "OxNew.exe", 
           "ZaJinHua.exe", "FiveStar.exe", "BaccaratNew.exe")

foreach ($game in $games) {
    netsh advfirewall firewall add rule name="Bojin $game" `
        dir=in action=allow program="C:\Games\Bojin\$game" enable=yes
}
```

#### 企业网络配置

如需在企业网络环境部署，请联系网络管理员开放相应端口。

---

## 五、更新维护

### 5.1 客户端更新流程

```
┌─────────────────────────────────────────────────────────────┐
│                      更新流程图                              │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  客户端启动 ──→ 检查更新 ──→ 发现新版本 ──→ 下载更新包     │
│       │              │                                       │
│       │              └──→ 无更新 ──→ 启动游戏               │
│       │                                                      │
│       └──→ 下载完成 ──→ 应用更新 ──→ 重启程序               │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 5.2 更新服务器配置

更新服务器需要提供以下文件：

```
更新服务器目录结构:
/updates/
├── version.txt           # 版本信息
├── manifest.xml          # 更新清单
├── patches/              # 增量更新包
│   ├── patch_1.0.1.exe
│   └── patch_1.0.2.exe
└── full/                 # 完整安装包
    └── bojin_1.0.2.exe
```

#### version.txt 示例

```
[Version]
CurrentVersion=1.0.2
MinVersion=1.0.0
UpdateURL=http://update.example.com/updates/
ForceUpdate=0
```

### 5.3 日志维护

#### 日志文件位置

| 日志文件 | 路径 | 内容 |
|----------|------|------|
| 平台日志 | GPManagerLog.txt | 平台运行状态 |
| 下载日志 | DownLoadLog.txt | 资源下载记录 |
| 更新日志 | UpdataCheckLog.txt | 更新检查记录 |

#### 日志清理脚本

```batch
@echo off
:: 清理超过7天的日志
forfiles /p "C:\Games\Bojin" /m "*.txt" /d -7 /c "cmd /c del @path"
```

---

## 六、故障排除

### 6.1 常见问题

#### 问题1：程序无法启动

**症状**: 双击程序无反应或闪退

**解决方案**:
```batch
# 1. 检查运行时是否安装
# 安装 VC++ 运行时
vcredist_x86.exe /q

# 2. 检查 DirectX
dxwebsetup.exe

# 3. 以管理员身份运行
# 右键 -> 以管理员身份运行
```

#### 问题2：缺少DLL文件

**症状**: 提示缺少 xxx.dll

**解决方案**:
```
缺少 D3DX9_43.dll    → 安装 DirectX 9.0c
缺少 Msvcp71.dll     → 安装 VC++ 2003 运行时
缺少 Msvcr71.dll     → 安装 VC++ 2003 运行时
缺少 bass.dll        → 重新下载完整安装包
```

#### 问题3：无法连接服务器

**症状**: 登录超时或网络错误

**解决方案**:
```
1. 检查网络连接
2. 检查防火墙设置
3. 检查 ServerInfo.INI 配置
4. 联系服务器管理员确认服务器状态
```

#### 问题4：游戏画面异常

**症状**: 画面卡顿、花屏或显示不正常

**解决方案**:
```
1. 更新显卡驱动
2. 检查 DirectX 是否正确安装
3. 调整显示设置
4. 尝试兼容模式运行
```

### 6.2 兼容性设置

#### Windows 10/11 兼容性配置

1. 右键程序 → 属性
2. 切换到"兼容性"选项卡
3. 勾选"以兼容模式运行这个程序"
4. 选择"Windows 7"
5. 勾选"以管理员身份运行"
6. 点击"应用"并确定

#### 高DPI设置

```
1. 右键程序 → 属性
2. 切换到"兼容性"选项卡
3. 点击"更改高DPI设置"
4. 勾选"替代高DPI缩放行为"
5. 选择"应用程序"
```

### 6.3 性能优化

#### 内存优化

```batch
# 关闭不必要的后台程序
# 增加虚拟内存
# 系统属性 → 高级 → 性能设置 → 高级 → 虚拟内存
```

#### 网络优化

```
1. 使用有线网络连接
2. 关闭占用带宽的应用
3. 选择延迟较低的服务器
```

---

## 七、安全配置

### 7.1 文件权限设置

```batch
:: 设置程序目录权限
icacls "C:\Games\Bojin" /grant Users:(OI)(CI)RX
icacls "C:\Games\Bojin\GPManagerLog.txt" /grant Users:(OI)(CI)F
```

### 7.2 安全建议

1. **仅从官方渠道下载客户端**
2. **定期检查更新**
3. **不要修改游戏核心文件**
4. **保护账号密码安全**
5. **及时报告异常行为**

---

## 八、批量部署

### 8.1 网吧/企业批量部署

#### 部署脚本示例

```batch
@echo off
:: Bojin游戏平台批量部署脚本

:: 设置安装目录
set INSTALL_DIR=C:\Games\Bojin

:: 创建目录
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

:: 复制文件（从网络共享）
xcopy /E /Y /I "\\server\share\bojin\*" "%INSTALL_DIR%"

:: 安装运行时
"%INSTALL_DIR%\vcredist_x86.exe" /q

:: 创建桌面快捷方式
set SCRIPT="%TEMP%\%RANDOM%-%RANDOM%-%RANDOM%-%RANDOM%.vbs"
echo Set oWS = WScript.CreateObject("WScript.Shell") >> %SCRIPT%
echo sLinkFile = oWS.SpecialFolders("Desktop") ^& "\Bojin.lnk" >> %SCRIPT%
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> %SCRIPT%
echo oLink.TargetPath = "%INSTALL_DIR%\GPManager.exe" >> %SCRIPT%
echo oLink.WorkingDirectory = "%INSTALL_DIR%" >> %SCRIPT%
echo oLink.Save >> %SCRIPT%
cscript /nologo %SCRIPT%
del %SCRIPT%

:: 配置防火墙
netsh advfirewall firewall add rule name="Bojin Game Platform" dir=in action=allow program="%INSTALL_DIR%\GPManager.exe" enable=yes

echo 部署完成！
pause
```

### 8.2 无静默安装部署

```batch
:: 使用组策略或SCCM部署
:: 1. 创建MSI安装包
:: 2. 通过组策略分发
:: 3. 或使用PowerShell远程执行

# PowerShell 远程部署
Invoke-Command -ComputerName PC1,PC2,PC3 -ScriptBlock {
    Copy-Item -Path "\\server\share\bojin" -Destination "C:\Games\Bojin" -Recurse
    Start-Process "C:\Games\Bojin\vcredist_x86.exe" -ArgumentList "/q" -Wait
}
```

---

## 九、卸载说明

### 9.1 正常卸载

```batch
:: 运行卸载程序
unins000.exe
```

### 9.2 手动卸载

```batch
:: 1. 删除安装目录
rmdir /S /Q "C:\Games\Bojin"

:: 2. 删除桌面快捷方式
del "%USERPROFILE%\Desktop\Bojin.lnk"

:: 3. 删除开始菜单项
rmdir /S /Q "%PROGRAMDATA%\Microsoft\Windows\Start Menu\Programs\Bojin"

:: 4. 清理注册表（可选）
reg delete "HKLM\SOFTWARE\Bojin" /f
reg delete "HKCU\SOFTWARE\Bojin" /f
```

---

## 十、联系支持

### 技术支持

如遇到部署问题，请通过以下方式获取支持：

- **项目地址**: https://github.com/fredphp/bojin
- **问题反馈**: 通过GitHub Issues提交

---

**文档版本**: 1.0  
**更新日期**: 2024年  
**适用版本**: Bojin 游戏平台客户端
