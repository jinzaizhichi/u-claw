#!/bin/bash
# U-Claw - Extract and Launch (macOS)

GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

clear
echo ""
echo -e "${CYAN}"
echo "  ╔══════════════════════════════════════╗"
echo "  ║     U-Claw 虾盘 v1.1                ║"
echo "  ║     一键解压并启动 (macOS)           ║"
echo "  ╚══════════════════════════════════════╝"
echo -e "${NC}"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ARCHIVE="$SCRIPT_DIR/U-Claw.tar.gz"
INSTALL_DIR="$SCRIPT_DIR/U-Claw"

# 移除 macOS 隔离标记
xattr -rd com.apple.quarantine "$SCRIPT_DIR" 2>/dev/null || true

# 检查压缩包
if [ ! -f "$ARCHIVE" ]; then
    echo -e "  ${RED}错误: 找不到 U-Claw.tar.gz${NC}"
    echo "  请确保此脚本和压缩包在同一目录"
    read -p "  按回车键退出..."
    exit 1
fi

# 检查是否已解压
if [ -d "$INSTALL_DIR/app/core/node_modules" ]; then
    echo -e "  ${GREEN}检测到已解压的 U-Claw${NC}"
    echo "  位置: $INSTALL_DIR"
    echo ""
    echo -e "  ${YELLOW}[1] 直接启动（跳过解压）${NC}"
    echo "  [2] 重新解压（覆盖现有）"
    echo ""
    read -p "  请选择 [1/2，默认1]: " choice
    choice="${choice:-1}"
    if [ "$choice" = "2" ]; then
        echo ""
        echo -e "  ${YELLOW}正在重新解压...${NC}"
        rm -rf "$INSTALL_DIR"
    else
        echo ""
        echo -e "  ${CYAN}跳过解压，直接启动...${NC}"
    fi
fi

# 解压（如果需要）
if [ ! -d "$INSTALL_DIR/app/core/node_modules" ]; then
    echo ""
    echo -e "  ${CYAN}正在解压 U-Claw ...${NC}"
    echo "  解压到: $INSTALL_DIR"
    echo ""

    # 检测是否在 U 盘上（挂载点判断）
    if echo "$SCRIPT_DIR" | grep -q "/Volumes/"; then
        echo -e "  ${YELLOW}检测到 U 盘，解压可能需要 3-5 分钟，请耐心等待...${NC}"
    else
        echo "  大约需要 1-2 分钟..."
    fi
    echo ""

    cd "$SCRIPT_DIR"
    tar xzf "$ARCHIVE"

    if [ $? -ne 0 ]; then
        echo -e "  ${RED}解压失败！${NC}"
        read -p "  按回车键退出..."
        exit 1
    fi

    # 解压后移除隔离标记
    xattr -rd com.apple.quarantine "$INSTALL_DIR" 2>/dev/null || true

    echo -e "  ${GREEN}解压完成！${NC}"
    echo ""
fi

# 启动
echo -e "  ${CYAN}正在启动 OpenClaw...${NC}"
echo ""

cd "$INSTALL_DIR"
exec bash "$INSTALL_DIR/Mac-Start.command"
