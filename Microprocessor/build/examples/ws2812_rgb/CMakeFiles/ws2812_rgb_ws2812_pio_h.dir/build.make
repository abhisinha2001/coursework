# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.22

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/local/Cellar/cmake/3.22.3/bin/cmake

# The command to remove a file.
RM = /usr/local/Cellar/cmake/3.22.3/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /Users/abhinavsinha/pico/pico-apps

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /Users/abhinavsinha/pico/pico-apps/build

# Utility rule file for ws2812_rgb_ws2812_pio_h.

# Include any custom commands dependencies for this target.
include examples/ws2812_rgb/CMakeFiles/ws2812_rgb_ws2812_pio_h.dir/compiler_depend.make

# Include the progress variables for this target.
include examples/ws2812_rgb/CMakeFiles/ws2812_rgb_ws2812_pio_h.dir/progress.make

examples/ws2812_rgb/CMakeFiles/ws2812_rgb_ws2812_pio_h: examples/ws2812_rgb/ws2812.pio.h

examples/ws2812_rgb/ws2812.pio.h: ../examples/ws2812_rgb/ws2812.pio
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --blue --bold --progress-dir=/Users/abhinavsinha/pico/pico-apps/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Generating ws2812.pio.h"
	cd /Users/abhinavsinha/pico/pico-apps/build/examples/ws2812_rgb && ../../pioasm/pioasm -o c-sdk /Users/abhinavsinha/pico/pico-apps/examples/ws2812_rgb/ws2812.pio /Users/abhinavsinha/pico/pico-apps/build/examples/ws2812_rgb/ws2812.pio.h

ws2812_rgb_ws2812_pio_h: examples/ws2812_rgb/CMakeFiles/ws2812_rgb_ws2812_pio_h
ws2812_rgb_ws2812_pio_h: examples/ws2812_rgb/ws2812.pio.h
ws2812_rgb_ws2812_pio_h: examples/ws2812_rgb/CMakeFiles/ws2812_rgb_ws2812_pio_h.dir/build.make
.PHONY : ws2812_rgb_ws2812_pio_h

# Rule to build all files generated by this target.
examples/ws2812_rgb/CMakeFiles/ws2812_rgb_ws2812_pio_h.dir/build: ws2812_rgb_ws2812_pio_h
.PHONY : examples/ws2812_rgb/CMakeFiles/ws2812_rgb_ws2812_pio_h.dir/build

examples/ws2812_rgb/CMakeFiles/ws2812_rgb_ws2812_pio_h.dir/clean:
	cd /Users/abhinavsinha/pico/pico-apps/build/examples/ws2812_rgb && $(CMAKE_COMMAND) -P CMakeFiles/ws2812_rgb_ws2812_pio_h.dir/cmake_clean.cmake
.PHONY : examples/ws2812_rgb/CMakeFiles/ws2812_rgb_ws2812_pio_h.dir/clean

examples/ws2812_rgb/CMakeFiles/ws2812_rgb_ws2812_pio_h.dir/depend:
	cd /Users/abhinavsinha/pico/pico-apps/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/abhinavsinha/pico/pico-apps /Users/abhinavsinha/pico/pico-apps/examples/ws2812_rgb /Users/abhinavsinha/pico/pico-apps/build /Users/abhinavsinha/pico/pico-apps/build/examples/ws2812_rgb /Users/abhinavsinha/pico/pico-apps/build/examples/ws2812_rgb/CMakeFiles/ws2812_rgb_ws2812_pio_h.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : examples/ws2812_rgb/CMakeFiles/ws2812_rgb_ws2812_pio_h.dir/depend

