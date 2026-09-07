# TurtleBot3 ROS 2 Humble — Navigation, Simulation & Manipulation

A reproducible **ROS 2 Humble** workspace setup for TurtleBot3 covering **mobile robot simulation, teleoperation, SLAM/navigation, and TurtleBot3 manipulation/MoveIt 2 packages**.

This repository was prepared from a working/development workspace that contained official ROBOTIS TurtleBot3 source repositories plus a saved occupancy-grid map. Instead of republishing thousands of unchanged upstream source files as personal code, this GitHub version keeps the **exact upstream repository revisions** in a `.repos` manifest and preserves the project-specific map and setup/troubleshooting documentation.

> **Important:** the TurtleBot3, DynamixelSDK, simulation, message, and manipulation packages are upstream ROBOTIS projects. They are dependencies, not claimed as original work in this repository.

## What Is Included

- ROS 2 Humble workspace setup
- TurtleBot3 core packages
- TurtleBot3 simulation packages
- TurtleBot3 Navigation2 / Cartographer packages
- TurtleBot3 Manipulation packages
- MoveIt 2 configuration for the manipulator
- DynamixelSDK
- TurtleBot3 message packages
- Saved occupancy-grid map
- Reproducible pinned dependency manifest
- Workspace diagnostic script
- Troubleshooting notes for common source/build/runtime problems

## Repository Structure

```text
TurtleBot3-ROS2-Humble-Navigation-Manipulation/
├── maps/
│   ├── map.pgm
│   └── map.yaml
├── scripts/
│   ├── setup_workspace.sh
│   └── check_workspace.sh
├── docs/
│   ├── TROUBLESHOOTING.md
│   └── UPSTREAM_COMPONENTS.md
├── turtlebot3_humble.repos
├── .gitignore
└── README.md
```

## Upstream Components

The uploaded workspace contained the following official ROBOTIS repositories on the `humble` branch:

| Repository | Purpose |
|---|---|
| `DynamixelSDK` | Dynamixel motor communication SDK |
| `turtlebot3` | TurtleBot3 bringup, navigation, Cartographer, teleop, description and core packages |
| `turtlebot3_msgs` | TurtleBot3 ROS interfaces/messages |
| `turtlebot3_simulations` | Gazebo and simulation packages |
| `turtlebot3_manipulation` | Manipulator bringup, description, MoveIt, navigation and teleop packages |

The exact commits from the uploaded workspace are pinned in `turtlebot3_humble.repos`, so the environment can be recreated without committing generated `build/`, `install/`, and `log/` folders.

## Saved Map

The workspace includes a map generated for navigation:

```yaml
resolution: 0.05
origin: [-4.5, -1.53, 0]
mode: trinary
occupied_thresh: 0.65
free_thresh: 0.25
```

Files:

```text
maps/map.pgm
maps/map.yaml
```

## Requirements

Recommended environment:

- Ubuntu 22.04
- ROS 2 Humble
- `colcon`
- `rosdep`
- `vcstool`
- Gazebo / TurtleBot3 simulation dependencies
- MoveIt 2 dependencies for manipulation

Install common development tools:

```bash
sudo apt update
sudo apt install -y \
  python3-colcon-common-extensions \
  python3-rosdep \
  python3-vcstool
```

If ROS 2 Humble is already installed, source it:

```bash
source /opt/ros/humble/setup.bash
```

## Recreate the Workspace

Clone this repository:

```bash
git clone https://github.com/YOUR-USERNAME/TurtleBot3-ROS2-Humble-Navigation-Manipulation.git
cd TurtleBot3-ROS2-Humble-Navigation-Manipulation
```

Create the workspace:

```bash
mkdir -p ~/turtlebot3_ws/src
cd ~/turtlebot3_ws
```

Copy the dependency manifest:

```bash
cp /path/to/TurtleBot3-ROS2-Humble-Navigation-Manipulation/turtlebot3_humble.repos .
```

Import the exact source dependencies:

```bash
vcs import src < turtlebot3_humble.repos
```

Install dependencies:

```bash
source /opt/ros/humble/setup.bash
rosdep update
rosdep install --from-paths src --ignore-src -r -y
```

Build:

```bash
colcon build --symlink-install
```

Source:

```bash
source install/setup.bash
```

Or use:

```bash
./scripts/setup_workspace.sh
```

## Environment Variables

For TurtleBot3 Burger:

```bash
export TURTLEBOT3_MODEL=burger
```

The development workspace also used:

```bash
export ROS_DOMAIN_ID=30
```

To keep them between terminals:

```bash
echo 'export TURTLEBOT3_MODEL=burger' >> ~/.bashrc
echo 'export ROS_DOMAIN_ID=30' >> ~/.bashrc
source ~/.bashrc
```

## Teleoperation

After sourcing ROS and the workspace:

```bash
ros2 run turtlebot3_teleop teleop_keyboard
```

## Gazebo Simulation

Example:

```bash
ros2 launch turtlebot3_gazebo turtlebot3_world.launch.py
```

If the package is not visible:

```bash
ros2 pkg prefix turtlebot3_gazebo
```

Then confirm that `turtlebot3_simulations` was imported, built, and the workspace was sourced.

## SLAM / Cartographer

A typical TurtleBot3 Cartographer workflow is:

```bash
ros2 launch turtlebot3_cartographer cartographer.launch.py
```

Drive the robot using teleoperation while the map is generated.

Save a map with the Nav2 map saver when required.

This repository preserves one previously generated map under `maps/`.

## Navigation2

Use your map with the TurtleBot3 Navigation2 setup after ensuring the correct model and ROS environment are sourced.

For example:

```bash
ros2 launch turtlebot3_navigation2 navigation2.launch.py \
  map:=$PWD/maps/map.yaml
```

Exact launch arguments can depend on the upstream TurtleBot3 revision and robot configuration.

## Manipulation / MoveIt 2

The imported `turtlebot3_manipulation` repository contains packages for:

- manipulator description;
- bringup;
- MoveIt 2 configuration;
- Cartographer;
- Navigation2;
- teleoperation;
- manipulation hardware.

The uploaded workspace specifically contains:

```text
turtlebot3_manipulation_moveit_config
turtlebot3_manipulation_teleop
```

After building and sourcing, verify them with:

```bash
ros2 pkg prefix turtlebot3_manipulation_moveit_config
ros2 pkg prefix turtlebot3_manipulation_teleop
```

## Workspace Diagnostics

Run:

```bash
./scripts/check_workspace.sh
```

This checks whether ROS 2 Humble is installed, whether the workspace is sourced, whether important TurtleBot3 packages are visible, and whether the `geometric_shapes` shared library is discoverable.

## Why `build/`, `install/`, and `log/` Are Not Included

The original uploaded workspace contained generated ROS 2 build artefacts:

```text
build/
install/
log/
```

These should normally **not** be stored in Git because:

- they are machine/environment specific;
- they can be regenerated with `colcon build`;
- they make repositories unnecessarily large;
- stale binaries can cause confusing runtime errors.

The `.gitignore` in this repository excludes them.

## Portfolio Scope

A precise way to describe this repository is:

> Configured and tested a ROS 2 Humble TurtleBot3 development environment for simulation, teleoperation, mapping/navigation, and manipulator integration using official ROBOTIS packages, Gazebo, Nav2, Cartographer, MoveIt 2, and Dynamixel tooling.

Do **not** describe the upstream TurtleBot3 packages themselves as code written from scratch.

## Suggested GitHub Topics

`ros2` `turtlebot3` `robotics` `gazebo` `navigation2` `nav2` `slam` `cartographer` `moveit2` `robot-manipulation` `dynamixel` `ubuntu`

## License and Attribution

The imported dependencies are maintained by ROBOTIS and retain their own upstream licenses. See `docs/UPSTREAM_COMPONENTS.md`.

This repository does not replace or relicense those projects.
