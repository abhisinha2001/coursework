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

# Utility rule file for assign02_assign02_pio_h.

# Include any custom commands dependencies for this target.
include assignments/assign02/CMakeFiles/assign02_assign02_pio_h.dir/compiler_depend.make

# Include the progress variables for this target.
include assignments/assign02/CMakeFiles/assign02_assign02_pio_h.dir/progress.make

assignments/assign02/CMakeFiles/assign02_assign02_pio_h: assignments/assign02/assign02.pio.h

assignments/assign02/assign02.pio.h: ../assignments/assign02/assign02.pio
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --blue --bold --progress-dir=/Users/abhinavsinha/pico/pico-apps/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Generating assign02.pio.h"
	cd /Users/abhinavsinha/pico/pico-apps/build/assignments/assign02 && ../../pioasm/pioasm -o c-sdk /Users/abhinavsinha/pico/pico-apps/assignments/assign02/assign02.pio /Users/abhinavsinha/pico/pico-apps/build/assignments/assign02/assign02.pio.h

assign02_assign02_pio_h: assignments/assign02/CMakeFiles/assign02_assign02_pio_h
assign02_assign02_pio_h: assignments/assign02/assign02.pio.h
assign02_assign02_pio_h: assignments/assign02/CMakeFiles/assign02_assign02_pio_h.dir/build.make
.PHONY : assign02_assign02_pio_h

# Rule to build all files generated by this target.
assignments/assign02/CMakeFiles/assign02_assign02_pio_h.dir/build: assign02_assign02_pio_h
.PHONY : assignments/assign02/CMakeFiles/assign02_assign02_pio_h.dir/build

assignments/assign02/CMakeFiles/assign02_assign02_pio_h.dir/clean:
	cd /Users/abhinavsinha/pico/pico-apps/build/assignments/assign02 && $(CMAKE_COMMAND) -P CMakeFiles/assign02_assign02_pio_h.dir/cmake_clean.cmake
.PHONY : assignments/assign02/CMakeFiles/assign02_assign02_pio_h.dir/clean

assignments/assign02/CMakeFiles/assign02_assign02_pio_h.dir/depend:
	cd /Users/abhinavsinha/pico/pico-apps/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/abhinavsinha/pico/pico-apps /Users/abhinavsinha/pico/pico-apps/assignments/assign02 /Users/abhinavsinha/pico/pico-apps/build /Users/abhinavsinha/pico/pico-apps/build/assignments/assign02 /Users/abhinavsinha/pico/pico-apps/build/assignments/assign02/CMakeFiles/assign02_assign02_pio_h.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : assignments/assign02/CMakeFiles/assign02_assign02_pio_h.dir/depend

