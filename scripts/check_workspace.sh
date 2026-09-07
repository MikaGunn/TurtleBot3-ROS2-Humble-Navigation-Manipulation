#!/usr/bin/env bash
set -u

echo "=== TurtleBot3 Workspace Check ==="

if [ -f /opt/ros/humble/setup.bash ]; then
  source /opt/ros/humble/setup.bash
  echo "[OK] ROS 2 Humble found"
else
  echo "[FAIL] /opt/ros/humble/setup.bash not found"
  exit 1
fi

if [ -f "${HOME}/turtlebot3_ws/install/setup.bash" ]; then
  source "${HOME}/turtlebot3_ws/install/setup.bash"
  echo "[OK] Workspace install/setup.bash found"
else
  echo "[WARN] Workspace has not been built/sourced from ~/turtlebot3_ws"
fi

echo
echo "Relevant packages visible to ROS:"
for pkg in \
  turtlebot3 \
  turtlebot3_gazebo \
  turtlebot3_navigation2 \
  turtlebot3_manipulation \
  turtlebot3_manipulation_moveit_config \
  turtlebot3_manipulation_teleop
do
  if ros2 pkg prefix "$pkg" >/dev/null 2>&1; then
    echo "[OK]   $pkg"
  else
    echo "[MISS] $pkg"
  fi
done

echo
echo "Checking geometric_shapes library:"
ldconfig -p 2>/dev/null | grep -i geometric_shapes || \
  echo "[WARN] geometric_shapes shared library was not found in ldconfig cache"

echo
echo "Environment:"
echo "TURTLEBOT3_MODEL=${TURTLEBOT3_MODEL:-<not set>}"
echo "ROS_DOMAIN_ID=${ROS_DOMAIN_ID:-<not set>}"
