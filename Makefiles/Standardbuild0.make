#  C++ Project Template - GNUMake Makefile (0) for standard build
#  ====
#  Copyright 2017 Rezart Qelibari <rezart.q-github@gmail.com>
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

# IMPORTANT: This file is meant to be included into the main file!

###############################################################################
# Variables                                                                   #
###############################################################################
# >> Folder variables
#######################################
# A project is assumed to have the following layout:
# 
# project1  # -> a project
# ├── Makefile    # -> this is a project specific Makefile
# ├── .d    # -> automatic generated dependency files
# ├── bin   # -> this is where the final binary will be places
# ├── build # -> this is where the build will happen
# ├── lib   # -> this directory is for third party libraries
# ├── src   # -> this is where your source is located
# │   ├── FuzzyFileSearch.cpp
# │   ├── FuzzyFileSearch.h
# │   └── FuzzyFileSearchMain.cpp  # -> files ending with Main.cpp will
# │                                # later produce an executable
# └── tests # -> here you can your tests
#     └── FuzzyFileSearch.cpp  #  -> This file contains a test suite.
#                              # It will be linked with
#                              # src/FuzzySearch.cpp
PROJECT_DIR = $(PROJECTS_DIR)/$(PROJECT)
DEPDIR = $(PROJECT_DIR)/.d
BIN_DIR = $(PROJECT_DIR)/bin
BUILD_DIR = $(PROJECT_DIR)/build
LIB_DIR = $(PROJECT_DIR)/lib
SRC_DIR = $(PROJECT_DIR)/src
TESTS_DIR = $(PROJECT_DIR)/tests