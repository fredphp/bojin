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
    echo "  --status     显示游戏运行状态"
    echo "  --stop       停止指定游戏"
    echo "  --stop-all   停止所有游戏"
    echo "  --help       显示此帮助信息"
    echo ""
    echo "示例:"
    echo "  bash start.sh              # 启动游戏平台"
    echo "  bash start.sh lkpy         # 启动李逵捕鱼"
    echo "  bash start.sh --list       # 列出所有游戏"
    echo "  bash start.sh lkpy --debug # 调试模式启动捕鱼"
    echo "  bash start.sh --status     # 查看运行状态"
    echo "  bash start.sh --stop land  # 停止斗地主"
    echo "  bash start.sh --stop-all   # 停止所有游戏"
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
        # 检查是否是 WSL
        if grep -qi microsoft /proc/version 2>/dev/null; then
            echo "wsl"
        else
            echo "linux"
        fi
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
    
    # 保存原始目录
    local original_dir="$SCRIPT_DIR"
    
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
    local cmd=""
    local win_path=""
    
    case $os in
        windows)
            # Windows环境直接启动
            cmd="$original_dir/$exe"
            print_info "启动方式: 原生Windows"
            ;;
        wsl)
            # WSL环境，转换路径并直接调用Windows程序
            win_path=$(wslpath -w "$original_dir/$exe" 2>/dev/null)
            if [ -n "$win_path" ]; then
                cmd="cmd.exe /c start \"\" \"$win_path\""
                print_info "启动方式: WSL (原生Windows)"
            else
                print_error "无法转换Windows路径"
                exit 1
            fi
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
            cmd="wine $original_dir/$exe"
            print_info "启动方式: Wine模拟器"
            ;;
        macos)
            # macOS环境尝试使用Wine
            if command -v wine &> /dev/null; then
                cmd="wine $original_dir/$exe"
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
    
    # 记录启动日志
    local log_file="$LOG_DIR/start_$(date '+%Y%m%d_%H%M%S').log"
    print_info "日志文件: $log_file"
    
    echo "=== 启动日志 $(date '+%Y-%m-%d %H:%M:%S') ===" > "$log_file"
    echo "游戏: $name ($exe)" >> "$log_file"
    echo "系统: $os" >> "$log_file"
    echo "命令: $cmd" >> "$log_file"
    echo "---" >> "$log_file"
    
    # 启动游戏
    print_success "正在启动..."
    echo ""
    
    if [ "$os" = "wsl" ]; then
        # WSL模式：使用cmd.exe启动
        eval "$cmd"
        print_success "$name 已启动！"
    elif [ "$debug_mode" = true ]; then
        # 调试模式，显示详细输出
        cd "$original_dir"
        $cmd 2>&1 | tee -a "$log_file"
    else
        # 正常模式，后台启动
        cd "$original_dir"
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

# 停止游戏
stop_game() {
    local game_key="$1"

    # 默认停止主程序
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

    print_header "停止 $name"
    print_info "可执行文件: $exe"

    # 检测操作系统
    local os=$(detect_os)
    local process_name="$exe"

    if [ "$os" = "wsl" ]; then
        # WSL环境，停止Windows进程
        print_info "系统: WSL"
        local win_exe=$(basename "$exe" .exe)
        cmd.exe /c "taskkill /F /IM $exe" 2>/dev/null
        if [ $? -eq 0 ]; then
            print_success "$name 已停止！"
        else
            print_warning "$name 可能未运行或已停止"
        fi
    elif [ "$os" = "linux" ]; then
        # Linux环境，停止Wine进程
        print_info "系统: Linux (Wine)"
        if command -v wineserver &> /dev/null; then
            wineserver -k 2>/dev/null
            print_success "Wine进程已停止"
        else
            pkill -f "$exe" 2>/dev/null
            print_success "$name 已停止！"
        fi
    else
        # Windows环境
        taskkill //F //IM "$exe" 2>/dev/null
        if [ $? -eq 0 ]; then
            print_success "$name 已停止！"
        else
            print_warning "$name 可能未运行或已停止"
        fi
    fi
}

# 停止所有游戏
stop_all() {
    print_header "停止所有游戏"

    local os=$(detect_os)

    if [ "$os" = "wsl" ]; then
        # WSL环境
        for key in "${!GAMES[@]}"; do
            IFS='|' read -r exe name <<< "${GAMES[$key]}"
            cmd.exe /c "taskkill /F /IM $exe" 2>/dev/null
            print_info "已停止: $name"
        done
    else
        # Linux/Windows环境
        for key in "${!GAMES[@]}"; do
            IFS='|' read -r exe name <<< "${GAMES[$key]}"
            pkill -f "$exe" 2>/dev/null || true
            print_info "已停止: $name"
        done
    fi

    print_success "所有游戏已停止"
}

# 显示运行状态
show_status() {
    print_header "游戏运行状态"

    local os=$(detect_os)
    local running_count=0

    for key in "${!GAMES[@]}"; do
        IFS='|' read -r exe name <<< "${GAMES[$key]}"

        local is_running=false

        if [ "$os" = "wsl" ]; then
            # WSL环境检查Windows进程
            cmd.exe /c "tasklist /FI \"IMAGENAME eq $exe\" 2>NUL" | grep -q "$exe" && is_running=true
        else
            # Linux/Windows环境
            pgrep -f "$exe" &> /dev/null && is_running=true
        fi

        if [ "$is_running" = true ]; then
            echo -e "  ${GREEN}●${NC} $name ($exe) - ${GREEN}运行中${NC}"
            ((running_count++))
        else
            echo -e "  ${RED}○${NC} $name ($exe) - ${RED}未运行${NC}"
        fi
    done

    echo ""
    if [ $running_count -eq 0 ]; then
        print_info "当前没有游戏在运行"
    else
        print_success "$running_count 个游戏正在运行"
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
    local stop_mode=false
    local stop_all_mode=false
    local show_status_mode=false

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
            --stop|-s)
                stop_mode=true
                shift
                ;;
            --stop-all)
                stop_all_mode=true
                shift
                ;;
            --status)
                show_status_mode=true
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

    # 显示运行状态
    if [ "$show_status_mode" = true ]; then
        show_banner
        show_status
        exit 0
    fi

    # 停止所有游戏
    if [ "$stop_all_mode" = true ]; then
        show_banner
        stop_all
        exit 0
    fi

    # 停止指定游戏
    if [ "$stop_mode" = true ]; then
        show_banner
        stop_game "$game_name"
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
