# Bojin 游戏平台 - 开发环境配置指南

## 一、开发环境概述

本项目是一个Windows 32位C++桌面应用程序，需要以下核心技术栈：

| 技术领域 | 技术选型 |
|----------|----------|
| 开发语言 | C++ |
| 目标平台 | Windows 32位 (x86) |
| 图形API | DirectX 9.0c |
| UI框架 | 自研DirectUI引擎 |
| 音频库 | BASS Audio Library |
| 构建系统 | Visual Studio |

---

## 二、必装开发工具

### 2.1 集成开发环境 (IDE)

#### 推荐方案：Visual Studio 2019/2022

**下载地址**: https://visualstudio.microsoft.com/

**安装组件选择**:

```
Visual Studio Installer 工作负载选择：
┌─────────────────────────────────────────────────────────┐
│ ☑ 使用C++的桌面开发                                      │
│   └─ MSVC v143 - VS 2022 C++ x86/x64生成工具            │
│   └─ Windows 10 SDK                                      │
│   └─ C++ MFC for latest v143 build tools (x86 & x64)   │
│   └─ C++ ATL for latest v143 build tools (x86 & x64)   │
│                                                          │
│ ☑ Windows SDK                                           │
│   └─ Windows 10 SDK (10.0.19041.0 或更新)              │
│                                                          │
│ 可选组件：                                               │
│ ☐ .NET桌面开发（如需C#工具）                            │
│ ☐ Windows游戏开发（如有游戏开发需求）                   │
└─────────────────────────────────────────────────────────┘
```

**为什么选择 Visual Studio?**
- 原生支持Windows C++开发
- 内置MSVC编译器，兼容性最佳
- 强大的调试功能
- 支持DirectX开发
- 项目模板丰富

#### 备选方案：Visual Studio Code + 插件

如果偏好轻量级编辑器：

```
必装插件：
├── C/C++ (Microsoft)
├── C/C++ Extension Pack
├── CMake Tools
├── Visual Studio IntelliCode
└── GitLens
```

**注意**: VS Code需要配合独立的编译工具链使用。

---

### 2.2 编译工具链

#### Windows SDK

**下载地址**: https://developer.microsoft.com/en-us/windows/downloads/windows-sdk/

**需要安装的版本**:
- Windows 10 SDK (推荐 10.0.19041.0 或更高)
- 或 Windows 8.1 SDK (兼容旧项目)

#### DirectX SDK

**下载地址**: https://www.microsoft.com/en-us/download/details.aspx?id=6812

```
DirectX SDK (June 2010) 包含：
├── DirectX Headers & Libraries
├── D3DX9 库
├── D3DX10 库
├── D3DX11 库
├── D3DCompiler
├── HLSL Shader Compiler (fxc.exe)
├── DirectX 控制面板
└── 示例代码和文档
```

**安装注意事项**:
1. 安装路径建议使用默认路径
2. 安装后需要在VS中配置包含目录和库目录

#### MSVC 运行时库

项目使用了VC++ 2003运行时，如需兼容：

```
Visual C++ Redistributable:
├── Visual C++ 2003 Redistributable (x86)
├── Visual C++ 2005-2022 Redistributable (x86)
└── 建议安装所有版本以保证兼容性
```

---

### 2.3 图形开发工具

#### DirectX 纹理工具

```
工具名称：DirectX Texture Tool
用途：创建和编辑DDS纹理文件
位置：DirectX SDK 安装目录/Utilities/bin/x86
```

#### PIX for Windows

```
工具名称：PIX for Windows
用途：DirectX图形调试
功能：
├── 帧分析
├── API调用追踪
├── 性能分析
└── Shader调试
```

#### GPU调试工具（可选）

| 工具 | 支持GPU | 下载地址 |
|------|---------|----------|
| NVIDIA Nsight | NVIDIA | https://developer.nvidia.com/nsight-graphics |
| AMD Radeon GPU Profiler | AMD | https://gpuopen.com/rgp/ |
| Intel Graphics Performance Analyzers | Intel | https://www.intel.com/content/www/us/en/developer/tools/graphics-performance-analyzers/overview.html |
| RenderDoc | 通用 | https://renderdoc.org/ |

---

### 2.4 音频开发工具

#### BASS Audio Library

**下载地址**: https://www.un4seen.com/bass.html

```
需要下载：
├── BASS (主库)
├── BASS_FX (音效库)
├── BASS_WASAPI (Windows音频API)
└── 文档和示例
```

#### 音频编辑工具（可选）

| 工具 | 用途 | 类型 |
|------|------|------|
| Audacity | 音频编辑 | 免费 |
| Adobe Audition | 专业音频处理 | 付费 |
| GoldWave | 音频格式转换 | 付费 |

---

## 三、辅助开发工具

### 3.1 版本控制

#### Git

**下载地址**: https://git-scm.com/downloads

```
推荐安装：
├── Git for Windows
├── Git GUI (可选)
└── 配置全局用户信息
    git config --global user.name "Your Name"
    git config --global user.email "your@email.com"
```

#### Git可视化工具

| 工具 | 特点 |
|------|------|
| GitHub Desktop | 简单易用，GitHub官方 |
| SourceTree | 功能丰富，免费 |
| GitKraken | 界面美观，部分功能收费 |
| TortoiseGit | Windows资源管理器集成 |

### 3.2 代码分析工具

#### 静态分析

```
Visual Studio 内置：
├── 代码分析 (Analyze -> Run Code Analysis)
├── 代码度量 (Analyze -> Calculate Code Metrics)
└── 代码克隆分析

第三方工具：
├── Cppcheck (免费开源)
├── PVS-Studio (付费，有免费版)
├── Clang-Tidy
└── SonarQube (团队协作)
```

#### 动态分析

```
内存检测：
├── Visual Studio 内存分析器
├── Dr. Memory (免费)
├── Visual Leak Detector (开源)
└── AddressSanitizer (VS 2019+)
```

### 3.3 反编译与调试工具

#### 逆向分析（用于研究现有代码）

| 工具 | 用途 | 说明 |
|------|------|------|
| IDA Pro | 反汇编 | 专业级，付费 |
| Ghidra | 反汇编 | NSA开源，免费 |
| x64dbg | 调试器 | 开源，支持x86/x64 |
| OllyDbg | 调试器 | 经典x86调试器 |
| Dependency Walker | 依赖分析 | 查看DLL依赖 |
| PE Explorer | PE文件分析 | 付费 |

#### 资源提取工具

| 工具 | 用途 |
|------|------|
| Resource Hacker | 提取EXE/DLL资源 |
| 7-Zip | 解压资源包 |
| Custom .fish文件解析器 | 需自行开发 |

---

## 四、完整安装清单

### 4.1 必装软件清单

```
必装开发环境（按安装顺序）：
┌────────────────────────────────────────────────────┐
│ 1. Visual Studio 2019/2022                         │
│    工作负载：使用C++的桌面开发                      │
│                                                    │
│ 2. Windows 10 SDK                                  │
│    版本：10.0.19041.0 或更高                       │
│                                                    │
│ 3. DirectX SDK (June 2010)                         │
│    路径：C:\Program Files (x86)\Microsoft DirectX SDK│
│                                                    │
│ 4. Git for Windows                                 │
│    版本：最新稳定版                                │
└────────────────────────────────────────────────────┘
```

### 4.2 可选软件清单

```
可选开发工具：
┌────────────────────────────────────────────────────┐
│ 调试分析：                                         │
│ ├── RenderDoc - 图形调试                          │
│ ├── Cppcheck - 静态分析                           │
│ └── Dr. Memory - 内存检测                         │
│                                                    │
│ 资源处理：                                         │
│ ├── Audacity - 音频编辑                           │
│ ├── Resource Hacker - 资源提取                    │
│ └── DirectX Texture Tool - 纹理处理               │
│                                                    │
│ 代码质量：                                         │
│ ├── Visual Assist - VS插件，代码增强              │
│ ├── ReSharper C++ - VS插件，代码分析              │
│ └── PVS-Studio - 静态分析                         │
│                                                    │
│ 版本控制：                                         │
│ ├── GitHub Desktop                                │
│ └── SourceTree                                    │
└────────────────────────────────────────────────────┘
```

---

## 五、环境变量配置

### 5.1 必要的环境变量

```batch
:: DirectX SDK
set DXSDK_DIR=C:\Program Files (x86)\Microsoft DirectX SDK (June 2010)

:: Windows SDK
set WindowsSdkDir=C:\Program Files (x86)\Windows Kits\10

:: Visual Studio
set VSINSTALLDIR=C:\Program Files\Microsoft Visual Studio\2022\Community

:: 添加到PATH
set PATH=%DXSDK_DIR%\Utilities\bin\x86;%PATH%
set PATH=%WindowsSdkDir%\bin\10.0.19041.0\x86;%PATH%
```

### 5.2 Visual Studio 项目配置

在VS项目属性中配置：

```
项目属性 → VC++ 目录：

包含目录：
├── $(DXSDK_DIR)\Include
├── $(WindowsSdkDir)\Include\10.0.19041.0\um
├── $(WindowsSdkDir)\Include\10.0.19041.0\shared
└── 项目特定的include目录

库目录：
├── $(DXSDK_DIR)\Lib\x86
├── $(WindowsSdkDir)\Lib\10.0.19041.0\um\x86
└── 项目特定的lib目录

链接器 → 输入 → 附加依赖项：
├── d3d9.lib
├── d3dx9.lib
├── dinput8.lib
├── dsound.lib
├── dxguid.lib
├── bass.lib
├── winmm.lib
└── 其他项目特定库
```

---

## 六、快速安装脚本

### 6.1 使用 winget 安装 (Windows 10/11)

```powershell
# 安装 Visual Studio 2022 Community
winget install Microsoft.VisualStudio.2022.Community

# 安装 Git
winget install Git.Git

# 安装 Windows SDK
winget install Microsoft.WindowsSDK.10

# 安装 GitHub Desktop
winget install GitHub.GitHubDesktop

# 安装 RenderDoc
winget install RenderDoc.RenderDoc
```

### 6.2 使用 Chocolatey 安装

```powershell
# 首先安装 Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# 安装开发工具
choco install visualstudio2022community -y
choco install git -y
choco install directx-sdk -y
choco install windows-sdk-10 -y
choco install cppcheck -y
choco install renderdoc -y
```

---

## 七、验证安装

### 7.1 检查环境脚本

创建 `check_env.bat` 文件：

```batch
@echo off
echo ============================================
echo   Bojin 开发环境检查
echo ============================================
echo.

:: 检查 Visual Studio
where cl.exe >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] MSVC 编译器已安装
    cl.exe 2>&1 | findstr "版本"
) else (
    echo [X] MSVC 编译器未找到
)

:: 检查 DirectX SDK
if exist "%DXSDK_DIR%" (
    echo [OK] DirectX SDK 已安装
    echo     路径: %DXSDK_DIR%
) else (
    echo [X] DirectX SDK 未安装
)

:: 检查 Windows SDK
if exist "%WindowsSdkDir%" (
    echo [OK] Windows SDK 已安装
    echo     路径: %WindowsSdkDir%
) else (
    echo [X] Windows SDK 未安装
)

:: 检查 Git
where git >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Git 已安装
    git --version
) else (
    echo [X] Git 未安装
)

echo.
echo ============================================
pause
```

### 7.2 编译测试项目

创建简单的DirectX测试代码验证环境：

```cpp
// test_dx.cpp
#include <d3d9.h>
#include <d3dx9.h>
#include <iostream>

#pragma comment(lib, "d3d9.lib")
#pragma comment(lib, "d3dx9.lib")

int main() {
    // 初始化DirectX
    IDirect3D9* d3d = Direct3DCreate9(D3D_SDK_VERSION);
    if (d3d) {
        std::cout << "DirectX 9 初始化成功!" << std::endl;
        D3DCAPS9 caps;
        d3d->GetDeviceCaps(D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, &caps);
        std::cout << "设备名称: " << caps.DeviceName << std::endl;
        d3d->Release();
    } else {
        std::cout << "DirectX 9 初始化失败!" << std::endl;
        return 1;
    }
    return 0;
}
```

---

## 八、开发建议

### 8.1 学习资源

| 领域 | 推荐资源 |
|------|----------|
| DirectX 9 | 《Introduction to 3D Game Programming with DirectX 9》 |
| Windows编程 | 《Windows程序设计》Charles Petzold |
| C++ | 《Effective C++》Scott Meyers |
| 游戏引擎 | 《游戏引擎架构》Jason Gregory |
| DirectUI | 学习DuiLib、Duilib-Ultimate等开源项目 |

### 8.2 开发流程建议

```
推荐开发流程：
┌─────────────────────────────────────────────────────┐
│ 1. 搭建基础开发环境                                  │
│    └─ VS + Windows SDK + DirectX SDK                │
│                                                     │
│ 2. 分析现有代码                                      │
│    └─ 使用IDA/Ghidra逆向分析DLL                     │
│    └─ 研究.fish文件格式                             │
│                                                     │
│ 3. 构建项目框架                                      │
│    └─ 创建VS解决方案                                │
│    └─ 配置包含目录和库目录                          │
│    └─ 解决编译依赖                                  │
│                                                     │
│ 4. 模块化开发                                        │
│    └─ UI引擎 → 网络模块 → 游戏逻辑                  │
│                                                     │
│ 5. 持续集成                                          │
│    └─ 配置自动化构建                                │
│    └─ 单元测试                                      │
└─────────────────────────────────────────────────────┘
```

### 8.3 注意事项

1. **兼容性**: 项目使用VC++ 2003编译，新版本VS可能需要调整代码
2. **字符编码**: 注意处理多字节字符集和Unicode
3. **32位限制**: 项目为32位，注意内存限制(2GB)
4. **资源格式**: .fish为自定义格式，需要编写解析器
5. **网络协议**: 需要分析现有网络协议才能重构服务端

---

## 九、快速开始检查清单

```
开发环境检查清单：
┌────────────────────────────────────────────────────┐
│ □ Visual Studio 2019/2022 已安装                   │
│ □ "使用C++的桌面开发"工作负载已安装                │
│ □ Windows 10 SDK 已安装                            │
│ □ DirectX SDK (June 2010) 已安装                   │
│ □ Git 已安装并配置                                 │
│ □ DirectX 编译测试通过                             │
│ □ 项目代码已克隆到本地                             │
│ □ VS项目配置正确（包含目录、库目录）               │
└────────────────────────────────────────────────────┘
```

---

**文档版本**: 1.0  
**更新日期**: 2024年
