#!/usr/bin/env bash
# ============================================================
# tderp 离线安装入口
#
# 用法：
#   1. 在可联网电脑 clone 本项目
#   2. 将整个项目目录上传到 VPS
#   3. 在 VPS 项目目录内执行：
#        sudo ./install-offline.sh
#
# 本脚本只读取当前目录内的文件，不访问 GitHub。执行安装前会检查
# 必需的安装资源文件名和数量是否齐全。
# ============================================================

set -euo pipefail

die() {
  echo "[错误] $*" >&2
  exit 1
}

SCRIPT_PATH="${BASH_SOURCE[0]:-}"
[ -n "${SCRIPT_PATH}" ] || die "无法确定 install-offline.sh 的路径"
[ -f "${SCRIPT_PATH}" ] || die "请直接运行上传到 VPS 的 install-offline.sh，不要通过管道执行"

PROJECT_DIR="$(cd "$(dirname "${SCRIPT_PATH}")" && pwd -P)"
REQUIRED_FILES=(
  "install-offline.sh"
  "install.sh"
  "docker-compose.yml"
  "vendor/get-docker.sh"
)
INSTALL_SCRIPT="${PROJECT_DIR}/install.sh"
DOCKER_INSTALL_SCRIPT="${PROJECT_DIR}/vendor/get-docker.sh"

check_required_file() {
  local file="$1" label="$2"
  [ -f "${file}" ] || die "缺少${label}: ${file}"
}

echo "[信息] 检查离线安装包文件..."
verified=0
for rel_path in "${REQUIRED_FILES[@]}"; do
  check_required_file "${PROJECT_DIR}/${rel_path}" "${rel_path}"
  verified=$((verified + 1))
done

if [ "${verified}" -ne "${#REQUIRED_FILES[@]}" ]; then
  die "离线安装包文件数量不正确"
fi

bash -n "${INSTALL_SCRIPT}" || die "install.sh 语法检查失败"
sh -n "${DOCKER_INSTALL_SCRIPT}" || die "vendor/get-docker.sh 语法检查失败"

echo "[OK] 已确认 ${verified} 个安装资源文件齐全，GitHub 资源不会被访问。"

if [ "${1:-}" = "--verify-only" ]; then
  exit 0
fi

export TDERP_OFFLINE_DIR="${PROJECT_DIR}"
export TDERP_DOCKER_INSTALL_SCRIPT="${DOCKER_INSTALL_SCRIPT}"
exec bash "${INSTALL_SCRIPT}" "$@"
