# Troubleshooting

## 1. `Package 'turtlebot3_manipulation_teleop' not found`

The uploaded source workspace **does contain** the package `turtlebot3_manipulation_teleop`.

If ROS cannot find it, the usual causes are:

```bash
cd ~/turtlebot3_ws
source /opt/ros/humble/setup.bash
colcon build --symlink-install
source install/setup.bash
```

Then check:

```bash
ros2 pkg prefix turtlebot3_manipulation_teleop
```

If it is still missing, inspect the build output for the manipulation repository:

```bash
colcon list | grep turtlebot3_manipulation
```

A package being present in `src/` does not mean ROS can use it until the workspace builds successfully and the resulting `install/setup.bash` is sourced.

---

## 2. MoveIt Servo error: `libgeometric_shapes.so...` not found

A runtime error such as:

```text
error while loading shared libraries: libgeometric_shapes.so...
```

means the executable was found, but a required shared library was not available to the dynamic linker.

First check:

```bash
ldconfig -p | grep geometric_shapes
```

Then inspect installed ROS packages:

```bash
apt list --installed 2>/dev/null | grep geometric
```

For a ROS 2 Humble system, reinstall the matching ROS package if necessary:

```bash
sudo apt update
sudo apt install --reinstall ros-humble-geometric-shapes
```

Then refresh the linker cache:

```bash
sudo ldconfig
```

Open a new terminal and source:

```bash
source /opt/ros/humble/setup.bash
source ~/turtlebot3_ws/install/setup.bash
```

Avoid mixing ROS distributions or binaries built against different library versions.

---

## 3. `turtlebot3_gazebo` not found

The package comes from the upstream `turtlebot3_simulations` repository.

Check:

```bash
colcon list | grep turtlebot3_gazebo
```

If it appears there, rebuild and source:

```bash
cd ~/turtlebot3_ws
colcon build --symlink-install
source install/setup.bash
```

---

## 4. Workspace source order

Use:

```bash
source /opt/ros/humble/setup.bash
source ~/turtlebot3_ws/install/setup.bash
```

The ROS installation should be sourced before the overlay workspace.

---

## 5. Clean rebuild

If generated files are stale:

```bash
cd ~/turtlebot3_ws
rm -rf build install log
source /opt/ros/humble/setup.bash
rosdep install --from-paths src --ignore-src -r -y
colcon build --symlink-install
source install/setup.bash
```

Do not delete `src/`.

---

## 6. Confirm TurtleBot3 model

For Burger:

```bash
export TURTLEBOT3_MODEL=burger
```

Verify:

```bash
echo $TURTLEBOT3_MODEL
```

---

## 7. ROS domain

If multiple ROS 2 machines or processes must communicate, they must use compatible domain settings.

The uploaded development environment used:

```bash
export ROS_DOMAIN_ID=30
```
