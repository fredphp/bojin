#!/bin/bash

################################################################################
#                    Bojin 游戏平台一键启动脚本
#                    
# 功能: 快速启动游戏平台或指定游戏
# 用法: bash start.sh [游戏名称] [选项]
# 
# 示例:
#   bash start.sh              # 启动主平台
#   bash start.sh lkpy         # 启动李逵捕鱼
#   bash start.sh --list       # 列出所有可用游戏
#   bash start.sh --debug      # 调试模式启动
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
CONFIG_DIR="${SCRIPT_DIR}/config"
LOG_DIR="${CONFIG_DIR}/logs"
WINEPREFIX="${SCRIPT_DIR}/.wine"

# 游戏映射表
declare -A GAMES=(
    ["manager"]="GPManager.exe|游戏平台主程序"
    ["lkpy"]="lkpy.exe|李逵捕鱼"
    ["land"]="Land.exe|斗地主"
    ["sparrow"]="SparrowER.exe|麻将"
    ["ox"]="OxNew.exe|牛牛"
    ["zajinhua"]="ZaJinHua.exe|炸金花"
    ["fivestar"]="FiveStar.exe|五星宏辉"
    ["baccarat"]="BaccaratNew.exe|百家乐"
    ["28gang"]="28GangBattle.exe|28杠"
    ["bumper"]="BumperCarBattle.exe|碰碰车大战"
)

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
    echo ""
    echo "Bojin 游戏平台一键启动脚本"
    echo ""
    echo "用法: bash start.sh [游戏名称] [选项]"
    echo ""
    echo "游戏名称:"
    echo "  manager    游戏平台主程序（默认）"
    echo "  lkpy       李逵捕鱼"
    echo "  land       斗地主"
    echo "  sparrow    麻将"
    echo "  ox         牛牛"
    echo "  zajinhua   炸金花"
    echo "  fivestar   五星宏辉"
    echo "  baccarat   百家乐"
    echo "  28gang     28杠"
    echo "  bumper     碰碰车大战"
    echo ""
    echo "选项:"
    echo "  --list       列出所有可用游戏"
    echo "  --debug      调试模式启动"
    echo "  --wine       使用Wine启动（Linux环境）"
    echo "  --native     尝试原生启动（Windows环境）"
    echo "  --windowed   窗口模式启动"
    echo "  --fullscreen 全屏模式启动"
    echo "  --help       显示此帮助信息"
    echo ""
    echo "示例:"
    echo "  bash start.sh              # 启动游戏平台"
    echo "  bash start.sh lkpy         # 启动李逵捕鱼"
    echo "  bash start.sh --list       # 列出所有游戏"
    echo "  bash start.sh lkpy --debug # 调试模式启动捕鱼"
    exit 0
}

# 初始化环境
init_environment() {
    # 创建必要目录
    mkdir -p "$LOG_DIR"
    mkdir -p "$CONFIG_DIR"
    
    # 设置Wine环境变量
    export WINEPREFIX="$WINEPREFIX"
    export WINEARCH=win32
}

# 检查Wine是否可用
check_wine() {
    if command -v wine &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# 检测操作系统
detect_os() {
    if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        echo "windows"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    else
        echo "unknown"
    fi
}

# 列出所有可用游戏
list_games() {
    echo ""
    echo "╔══════════════════════════════════════════════════════╗"
    echo "║              Bojin 游戏平台 - 游戏列表               ║"
    echo "╠══════════════════════════════════════════════════════╣"
    printf "║  %-12s  │  %-20s  │  %-8s  ║\n" "命令" "游戏名称" "状态"
    echo "╠══════════════════════════════════════════════════════╣"
    
    for key in "${!GAMES[@]}"; do
        IFS='|' read -r exe name <<< "${GAMES[$key]}"
        if [ -f "$SCRIPT_DIR/$exe" ]; then
            status="${GREEN}✓ 可用${NC}"
        else
            status="${RED}✗ 缺失${NC}"
        fi
        printf "║  %-12s  │  %-20s  │  " "$key" "$name"
        echo -e "$status  ║"
    done
    
    echo "╚══════════════════════════════════════════════════════╝"
    echo ""
}

# 启动游戏
start_game() {
    local game_key="$1"
    local debug_mode="$2"
    local force_wine="$3"
    
    # 默认启动主程序
    if [ -z "$game_key" ]; then
        game_key="manager"
    fi
    
    # 检查游戏是否存在
    if [ ! -n "${GAMES[$game_key]}" ]; then
        print_error "未知游戏: $game_key"
        print_info "使用 --list 查看可用游戏列表"
        exit 1
    fi
    
    # 获取游戏信息
    IFS='|' read -r exe name <<< "${GAMES[$game_key]}"
    
    # 检查可执行文件
    if [ ! -f "$SCRIPT_DIR/$exe" ]; then
        print_error "游戏文件不存在: $exe"
        print_info "请确保项目文件完整"
        exit 1
    fi
    
    print_header "启动 $name"
    print_info "可执行文件: $exe"
    
    # 检测操作系统并选择启动方式
    local os=$(detect_os)
    local launcher=""
    
    case $os in
        windows)
            # Windows环境直接启动
            launcher=""
            print_info "启动方式: 原生Windows"
            ;;
        linux)
            # Linux环境使用Wine
            if [ "$force_wine" = "false" ]; then
                if ! check_wine; then
                    print_error "Wine未安装，无法在Linux上运行Windows程序"
                    print_info "请运行: bash deploy.sh --wine 安装Wine支持"
                    exit 1
                fi
            fi
            launcher="wine"
            print_info "启动方式: Wine模拟器"
            ;;
        macos)
            # macOS环境尝试使用Wine
            if command -v wine &> /dev/null; then
                launcher="wine"
                print_info "启动方式: Wine模拟器"
            else
                print_error "macOS环境需要安装Wine"
                print_info "请运行: brew install --cask wine-stable"
                exit 1
            fi
            ;;
        *)
            print_error "不支持的操作系统: $os"
            exit 1
            ;;
    esac
    
    # 构建启动命令
    local cmd=""
    if [ -n "$launcher" ]; then
        cmd="$launcher"
        
        if [ "$debug_mode" = true ]; then
            cmd="$cmd --debug"
        fi
    fi
    
    cmd="$cmd $SCRIPT_DIR/$exe"
    
    # 记录启动日志
    local log_file="$LOG_DIR/start_$(date '+%Y%m%d_%H%M%S').log"
    print_info "日志文件: $log_file"
    
    echo "=== 启动日志 $(date '+%Y-%m-%d %H:%M:%S') ===" > "$log_file"
    echo "游戏: $name ($exe)" >> "$log_file"
    echo "命令: $cmd" >> "$log_file"
    echo "---" >> "$log_file"
    
    # 切换到项目目录
    cd "$SCRIPT_DIR"
    
    # 启动游戏
    print_success "正在启动..."
    echo ""
    
    if [ "$debug_mode" = true ]; then
        # 调试模式，显示详细输出
        $cmd 2>&1 | tee -a "$log_file"
    else
        # 正常模式，后台启动
        nohup $cmd >> "$log_file" 2>&1 &
        local pid=$!
        echo "游戏进程ID: $pid"
        echo "PID: $pid" >> "$log_file"
        
        # 等待一下检查是否启动成功
        sleep 2
        if kill -0 $pid 2>/dev/null; then
            print_success "$name 启动成功！"
            print_info "进程ID: $pid"
        else
            print_error "$name 启动失败，请查看日志: $log_file"
            exit 1
        fi
    fi
}

# 快速启动特定游戏（快捷方式）
quick_start() {
    local game="$1"
    shift
    
    case $game in
        捕鱼|李逵捕鱼|fishing)
            start_game "lkpy" "false" "false"
            ;;
        斗地主|doudizhu)
            start_game "land" "false" "false"
            ;;
        麻将|majiang)
            start_game "sparrow" "false" "false"
            ;;
        牛牛|niuniu)
            start_game "ox" "false" "false"
            ;;
        炸金花|zhajinhua)
            start_game "zajinhua" "false" "false"
            ;;
        *)
            start_game "$game" "false" "false"
            ;;
    esac
}

# 显示启动横幅
show_banner() {
    clear
    echo ""
    echo "╔══════════════════════════════════════════╗"
    echo "║        Bojin 游戏平台启动器              ║"
    echo "║             Version 1.0                  ║"
    echo "╚══════════════════════════════════════════╝"
    echo ""
}

# 交互式菜单
interactive_menu() {
    show_banner
    
    echo "请选择要启动的游戏:"
    echo ""
    
    local keys=("${!GAMES[@]}")
    local sorted_keys=($(echo "${keys[@]}" | tr ' ' '\n' | sort))
    
    local i=1
    for key in "${sorted_keys[@]}"; do
        IFS='|' read -r exe name <<< "${GAMES[$key]}"
        if [ -f "$SCRIPT_DIR/$exe" ]; then
            printf "  ${GREEN}%2d)${NC} %-12s %s\n" "$i" "$key" "$name"
        else
            printf "  ${RED}%2d)${NC} %-12s %s (不可用)\n" "$i" "$key" "$name"
        fi
        ((i++))
    done
    
    echo ""
    echo "  0) 退出"
    echo ""
    read -p "请输入选择 [0-$((${#GAMES[@]}))]: " choice
    
    if [ "$choice" = "0" ] || [ -z "$choice" ]; then
        echo "已退出"
        exit 0
    fi
    
    local selected_key="${sorted_keys[$((choice-1))]}"
    
    if [ -n "$selected_key" ]; then
        start_game "$selected_key" "false" "false"
    else
        print_error "无效的选择"
        exit 1
    fi
}

# 主函数
main() {
    init_environment
    
    # 解析参数
    local game_name=""
    local debug_mode=false
    local force_wine=false
    local show_list=false
    local interactive=false
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --help|-h)
                show_help
                ;;
            --list|-l)
                show_list=true
                shift
                ;;
            --debug|-d)
                debug_mode=true
                shift
                ;;
            --wine|-w)
                force_wine=true
                shift
                ;;
            --native|-n)
                force_wine=false
                shift
                ;;
            --interactive|-i)
                interactive=true
                shift
                ;;
            manager|lkpy|land|sparrow|ox|zajinhua|fivestar|baccarat|28gang|bumper)
                game_name="$1"
                shift
                ;;
            *)
                # 尝试作为游戏名称
                game_name="$1"
                shift
                ;;
        esac
    done
    
    # 显示游戏列表
    if [ "$show_list" = true ]; then
        show_banner
        list_games
        exit 0
    fi
    
    # 交互模式
    if [ "$interactive" = true ] || [ -z "$game_name" ]; then
        interactive_menu
        exit 0
    fi
    
    # 启动指定游戏
    show_banner
    start_game "$game_name" "$debug_mode" "$force_wine"
}

# 执行主函数
main "$@"
