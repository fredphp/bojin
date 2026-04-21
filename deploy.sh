#!/bin/bash

################################################################################
#                    Bojin 游戏平台开发环境一键部署脚本
#                    
# 功能: 自动部署开发环境、检查依赖、配置权限
# 用法: bash deploy.sh [选项]
# 
# 选项:
#   --check      仅检查环境，不执行部署
#   --wine       安装Wine支持
#   --help       显示帮助信息
################################################################################

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 项目配置
PROJECT_NAME="Bojin"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="${SCRIPT_DIR}"
LOG_FILE="${SCRIPT_DIR}/deploy.log"
CONFIG_DIR="${SCRIPT_DIR}/config"

# 打印带颜色的消息
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${PURPLE}========================================${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${PURPLE}========================================${NC}"
}

# 显示帮助信息
show_help() {
    echo "Bojin 游戏平台开发环境一键部署脚本"
    echo ""
    echo "用法: bash deploy.sh [选项]"
    echo ""
    echo "选项:"
    echo "  --check      仅检查环境，不执行部署"
    echo "  --wine       安装Wine支持（用于Linux环境运行Windows程序）"
    echo "  --backup     备份当前配置"
    echo "  --restore    从备份恢复配置"
    echo "  --clean      清理临时文件和缓存"
    echo "  --help       显示此帮助信息"
    echo ""
    echo "示例:"
    echo "  bash deploy.sh              # 完整部署"
    echo "  bash deploy.sh --check      # 仅检查环境"
    echo "  bash deploy.sh --wine       # 部署并安装Wine"
    echo "  bash deploy.sh --backup     # 备份配置"
    exit 0
}

# 初始化日志
init_log() {
    echo "=== 部署日志 $(date '+%Y-%m-%d %H:%M:%S') ===" > "$LOG_FILE"
    log "日志文件: $LOG_FILE"
}

# 写入日志
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# 检查系统环境
check_system() {
    print_header "检查系统环境"
    
    # 检测操作系统
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$NAME
        VER=$VERSION_ID
    elif type lsb_release >/dev/null 2>&1; then
        OS=$(lsb_release -si)
        VER=$(lsb_release -sr)
    else
        OS=$(uname -s)
        VER=$(uname -r)
    fi
    
    print_info "操作系统: $OS $VER"
    log "操作系统: $OS $VER"
    
    # 检测系统架构
    ARCH=$(uname -m)
    print_info "系统架构: $ARCH"
    log "系统架构: $ARCH"
    
    if [ "$ARCH" != "x86_64" ] && [ "$ARCH" != "i686" ]; then
        print_warning "当前架构可能不完全支持Windows程序"
    fi
    
    print_success "系统环境检查完成"
}

# 检查必需工具
check_tools() {
    print_header "检查必需工具"
    
    local tools=("wine" "unzip" "curl" "wget" "git")
    local missing_tools=()
    
    for tool in "${tools[@]}"; do
        if command -v "$tool" &> /dev/null; then
            local version=$(command "$tool" --version 2>&1 | head -n1)
            print_info "$tool: 已安装 ($version)"
            log "$tool: 已安装"
        else
            print_warning "$tool: 未安装"
            log "$tool: 未安装"
            missing_tools+=("$tool")
        fi
    done
    
    if [ ${#missing_tools[@]} -gt 0 ]; then
        print_warning "缺少以下工具: ${missing_tools[*]}"
        print_info "提示: 可以使用 --wine 选项自动安装Wine"
    fi
    
    print_success "工具检查完成"
}

# 检查项目文件完整性
check_project_files() {
    print_header "检查项目文件完整性"
    
    local required_files=(
        "GPManager.exe"
        "ServerInfo.INI"
        "MTUIEngine.dll"
        "MTNetworkEngine.dll"
        "LKpyEngine.dll"
        "D3DX9_43.dll"
        "bass.dll"
    )
    
    local required_dirs=(
        "lkpy"
        "Land"
        "PlatformFrame"
        "GPManagerImage"
    )
    
    local missing_files=0
    local missing_dirs=0
    
    # 检查必需文件
    for file in "${required_files[@]}"; do
        if [ -f "$INSTALL_DIR/$file" ]; then
            print_info "文件存在: $file"
            log "文件存在: $file"
        else
            print_warning "文件缺失: $file"
            log "文件缺失: $file"
            ((missing_files++))
        fi
    done
    
    # 检查必需目录
    for dir in "${required_dirs[@]}"; do
        if [ -d "$INSTALL_DIR/$dir" ]; then
            print_info "目录存在: $dir"
            log "目录存在: $dir"
        else
            print_warning "目录缺失: $dir"
            log "目录缺失: $dir"
            ((missing_dirs++))
        fi
    done
    
    # 统计游戏数量
    local game_count=$(find "$INSTALL_DIR" -maxdepth 1 -name "*.exe" -type f 2>/dev/null | wc -l)
    print_info "发现 $game_count 个游戏可执行文件"
    log "游戏数量: $game_count"
    
    if [ $missing_files -gt 0 ] || [ $missing_dirs -gt 0 ]; then
        print_warning "项目文件不完整，缺少 $missing_files 个文件和 $missing_dirs 个目录"
        return 1
    else
        print_success "项目文件完整"
        return 0
    fi
}

# 创建配置目录
create_config_dir() {
    print_header "创建配置目录"
    
    local dirs=(
        "$CONFIG_DIR"
        "$CONFIG_DIR/backup"
        "$CONFIG_DIR/logs"
        "$CONFIG_DIR/cache"
        "$CONFIG_DIR/screenshots"
    )
    
    for dir in "${dirs[@]}"; do
        if [ ! -d "$dir" ]; then
            mkdir -p "$dir"
            print_info "创建目录: $dir"
            log "创建目录: $dir"
        else
            print_info "目录已存在: $dir"
        fi
    done
    
    print_success "配置目录创建完成"
}

# 设置文件权限
set_permissions() {
    print_header "设置文件权限"
    
    # 设置可执行权限
    find "$INSTALL_DIR" -name "*.exe" -type f -exec chmod +x {} \; 2>/dev/null || true
    find "$INSTALL_DIR" -name "*.sh" -type f -exec chmod +x {} \; 2>/dev/null || true
    
    # 设置配置文件权限
    find "$INSTALL_DIR" -name "*.INI" -type f -exec chmod 644 {} \; 2>/dev/null || true
    find "$INSTALL_DIR" -name "*.xml" -type f -exec chmod 644 {} \; 2>/dev/null || true
    
    print_success "权限设置完成"
    log "文件权限设置完成"
}

# 配置Wine环境
setup_wine() {
    print_header "配置Wine环境"
    
    if ! command -v wine &> /dev/null; then
        print_warning "Wine未安装，正在尝试安装..."
        
        if [ -f /etc/debian_version ]; then
            # Debian/Ubuntu
            print_info "检测到Debian/Ubuntu系统"
            sudo apt-get update
            sudo apt-get install -y wine wine32 wine64
        elif [ -f /etc/redhat-release ]; then
            # RHEL/CentOS/Fedora
            print_info "检测到RHEL/CentOS/Fedora系统"
            sudo yum install -y wine
        elif [ -f /etc/arch-release ]; then
            # Arch Linux
            print_info "检测到Arch Linux系统"
            sudo pacman -S wine
        else
            print_error "无法自动安装Wine，请手动安装"
            return 1
        fi
    fi
    
    # 初始化Wine前缀
    export WINEPREFIX="$INSTALL_DIR/.wine"
    export WINEARCH=win32
    
    if [ ! -d "$WINEPREFIX" ]; then
        print_info "初始化Wine环境..."
        wineboot -i 2>/dev/null || true
        log "Wine环境初始化完成"
    fi
    
    # 安装必需的Windows组件
    print_info "配置DirectX..."
    if [ -f "$INSTALL_DIR/D3DX9_43.dll" ]; then
        cp "$INSTALL_DIR/D3DX9_43.dll" "$WINEPREFIX/drive_c/windows/system32/" 2>/dev/null || true
    fi
    
    print_success "Wine环境配置完成"
    log "Wine配置完成: WINEPREFIX=$WINEPREFIX"
}

# 创建默认配置文件
create_default_config() {
    print_header "创建默认配置文件"
    
    # 创建启动配置
    cat > "$CONFIG_DIR/bojin.conf" << 'EOF'
# Bojin 游戏平台配置文件
# 编辑此文件可以自定义启动参数

[General]
# 游戏窗口大小
WindowWidth=1024
WindowHeight=768

# 是否全屏启动 (0=否, 1=是)
FullScreen=0

# 音量设置 (0-100)
MusicVolume=80
EffectVolume=80

# 语言设置 (zh_CN, en_US)
Language=zh_CN

[Server]
# 服务器地址 (留空使用默认)
ServerAddress=
ServerPort=

[Debug]
# 启用调试模式 (0=否, 1=是)
DebugMode=0
# 启用日志记录 (0=否, 1=是)
EnableLog=1
EOF
    
    print_info "创建配置文件: $CONFIG_DIR/bojin.conf"
    log "创建默认配置文件"
    
    print_success "默认配置创建完成"
}

# 备份配置
backup_config() {
    print_header "备份当前配置"
    
    local backup_dir="$CONFIG_DIR/backup/$(date '+%Y%m%d_%H%M%S')"
    mkdir -p "$backup_dir"
    
    # 备份配置文件
    cp "$INSTALL_DIR/ServerInfo.INI" "$backup_dir/" 2>/dev/null || true
    cp -r "$INSTALL_DIR/"*/GameLevel.INI "$backup_dir/" 2>/dev/null || true
    cp -r "$INSTALL_DIR/"*/TableResource.INI "$backup_dir/" 2>/dev/null || true
    cp "$CONFIG_DIR/bojin.conf" "$backup_dir/" 2>/dev/null || true
    
    print_success "配置已备份到: $backup_dir"
    log "配置备份: $backup_dir"
}

# 恢复配置
restore_config() {
    print_header "恢复配置"
    
    local backup_dirs=("$CONFIG_DIR/backup"/*)
    
    if [ ${#backup_dirs[@]} -eq 0 ] || [ ! -d "${backup_dirs[0]}" ]; then
        print_error "没有找到备份文件"
        return 1
    fi
    
    # 列出可用备份
    echo "可用的备份:"
    local i=1
    for dir in "${backup_dirs[@]}"; do
        if [ -d "$dir" ]; then
            echo "  $i) $(basename "$dir")"
            ((i++))
        fi
    done
    
    # 选择备份
    read -p "请选择要恢复的备份编号: " choice
    
    local selected_backup="${backup_dirs[$((choice-1))]}"
    if [ ! -d "$selected_backup" ]; then
        print_error "无效的选择"
        return 1
    fi
    
    # 恢复配置
    cp "$selected_backup/ServerInfo.INI" "$INSTALL_DIR/" 2>/dev/null || true
    cp "$selected_backup/bojin.conf" "$CONFIG_DIR/" 2>/dev/null || true
    
    print_success "配置已从 $selected_backup 恢复"
    log "配置恢复: $selected_backup"
}

# 清理临时文件
clean_temp() {
    print_header "清理临时文件"

    local temp_dirs=(
        "$CONFIG_DIR/cache/*"
        "$WINEPREFIX/drive_c/users/*/Temp/*"
    )

    for pattern in "${temp_dirs[@]}"; do
        if ls $pattern 1> /dev/null 2>&1; then
            rm -rf $pattern 2>/dev/null
            print_info "清理: $pattern"
        fi
    done
    
    # 清理日志（保留最近7天）
    find "$CONFIG_DIR/logs" -name "*.log" -mtime +7 -delete 2>/dev/null || true
    
    print_success "清理完成"
    log "临时文件清理完成"
}

# 生成项目统计报告
generate_report() {
    print_header "项目统计报告"
    
    # 统计文件数量
    local exe_count=$(find "$INSTALL_DIR" -name "*.exe" -type f 2>/dev/null | wc -l)
    local dll_count=$(find "$INSTALL_DIR" -name "*.dll" -type f 2>/dev/null | wc -l)
    local ini_count=$(find "$INSTALL_DIR" -name "*.INI" -type f 2>/dev/null | wc -l)
    local xml_count=$(find "$INSTALL_DIR" -name "*.xml" -type f 2>/dev/null | wc -l)
    local fish_count=$(find "$INSTALL_DIR" -name "*.fish" -type f 2>/dev/null | wc -l)
    local png_count=$(find "$INSTALL_DIR" -name "*.png" -type f 2>/dev/null | wc -l)
    
    # 计算目录大小
    local total_size=$(du -sh "$INSTALL_DIR" 2>/dev/null | cut -f1)
    
    echo ""
    echo "┌──────────────────────────────────────┐"
    echo "│           项目统计报告               │"
    echo "├──────────────────────────────────────┤"
    printf "│  EXE文件:      %-20s │\n" "$exe_count 个"
    printf "│  DLL文件:      %-20s │\n" "$dll_count 个"
    printf "│  INI配置:      %-20s │\n" "$ini_count 个"
    printf "│  XML配置:      %-20s │\n" "$xml_count 个"
    printf "│  资源文件(.fish): %-18s │\n" "$fish_count 个"
    printf "│  图片文件(.png): %-19s │\n" "$png_count 个"
    printf "│  总大小:       %-20s │\n" "$total_size"
    echo "└──────────────────────────────────────┘"
    echo ""
    
    log "项目统计: EXE=$exe_count, DLL=$dll_count, 资源=$fish_count, 大小=$total_size"
}

# 主部署流程
main() {
    clear
    echo ""
    echo "╔══════════════════════════════════════════╗"
    echo "║     Bojin 游戏平台开发环境部署脚本       ║"
    echo "║              Version 1.0                  ║"
    echo "╚══════════════════════════════════════════╝"
    echo ""
    
    init_log
    
    # 解析参数
    local check_only=false
    local install_wine=false
    local do_backup=false
    local do_restore=false
    local do_clean=false
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --check)
                check_only=true
                shift
                ;;
            --wine)
                install_wine=true
                shift
                ;;
            --backup)
                do_backup=true
                shift
                ;;
            --restore)
                do_restore=true
                shift
                ;;
            --clean)
                do_clean=true
                shift
                ;;
            --help)
                show_help
                ;;
            *)
                print_error "未知参数: $1"
                show_help
                ;;
        esac
    done
    
    # 执行特定操作
    if [ "$do_backup" = true ]; then
        backup_config
        exit 0
    fi
    
    if [ "$do_restore" = true ]; then
        restore_config
        exit 0
    fi
    
    if [ "$do_clean" = true ]; then
        clean_temp
        exit 0
    fi
    
    # 检查环境
    check_system
    check_tools
    check_project_files
    
    if [ "$check_only" = true ]; then
        generate_report
        print_info "环境检查完成，使用不带参数运行进行完整部署"
        exit 0
    fi
    
    # 执行部署
    create_config_dir
    set_permissions
    create_default_config
    
    if [ "$install_wine" = true ]; then
        setup_wine
    fi
    
    generate_report
    
    echo ""
    print_success "════════════════════════════════════════"
    print_success "      部署完成！"
    print_success "════════════════════════════════════════"
    echo ""
    print_info "启动方式: bash start.sh"
    print_info "日志文件: $LOG_FILE"
    echo ""
}

# 执行主函数
main "$@"
