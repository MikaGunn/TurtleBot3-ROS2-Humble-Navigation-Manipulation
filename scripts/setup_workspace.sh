#!/usr/bin/env bash
set -e

WS="${HOME}/turtlebot3_ws"

echo "[1/6] Creating workspace..."
mkdir -p "${WS}/src"
cd "${WS}"

echo "[2/6] Importing pinned ROBOTIS source repositories..."
if ! command -v vcs >/dev/null 2>&1; then
  echo "vcs is not installed. Install it with:"
  echo "  sudo apt install python3-vcstool"
  exit 1
fi

vcs import src < turtlebot3_humble.repos

echo "[3/6] Installing ROS dependencies..."
rosdep update
rosdep install --from-paths src --ignore-src -r -y

echo "[4/6] Building workspace..."
colcon build --symlink-install

echo "[5/6] Sourcing workspace..."
source /opt/ros/humble/setup.bash
source "${WS}/install/setup.bash"

echo "[6/6] TurtleBot3 environment..."
echo 'Add these to ~/.bashrc if Burger is your platform:'
echo '  export TURTLEBOT3_MODEL=burger'
echo '  export ROS_DOMAIN_ID=30'
echo
echo "Setup complete."
