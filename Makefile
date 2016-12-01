#  Fuzzy Search - Main GNUMake file
#  ====
#  Copyright 2016 Rezart Qelibari <qelibarr@informatik.uni-freiburg.de>
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

###############################################################################
# Idea                                                                        #
###############################################################################
# This makefile is the entry point for all sub projects makefile. It
# provides the tasks which are required by all subprojects (e.g. building)
# googlemock. It further has a target which offers a build of the sub
# projects, but depends on naming conventions.

###############################################################################
# Variables                                                                   #
###############################################################################
# Info: ':=' means expand variables on definition
# >> General variables
#######################################
# Get the directory, where this makefile is located
ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
DEBUG := yes

# >> Compiler variables
#######################################
CXX = /usr/bin/g++
CXXFLAGS = -std=c++14
ifeq ($(CXX), yes)
	CXXFLAGS += -g -Wall -DDEBUG
else
	CXXFLAGS += -O3
endif

# >> Dependency variables
#######################################
# Taken from: http://make.mad-scientist.net/papers/advanced-auto-dependency-generation/#combine
DEPDIR := .d
$(shell mkdir -p $(DEPDIR) > /dev/null)
DEPFLAGS = -MT $@ -MMD -MP -MF $(DEPDIR)/$*.Td
CXXFLAGS += $(DEPFLAGS)
POSTCOMPILE = mv -f $(DEPDIR)/$*.Td $(DEPDIR)/$*.d

# >> Template variables
#######################################
# This makefile offers a standard build target for projects located in
# subfolders. To achieve this it assumes the following project structure.
#
# .
# ├── LICENSE
# ├── Makefile  # this is the current makefile
# ├── README.md
# └── project1  # a project
#     ├── build
#     ├── lib  # for third party libraries
#     ├── src
#     │   ├── FuzzyFileSearch.cpp
#     │   ├── FuzzyFileSearch.h
#     │   └── FuzzyFileSearchMain.cpp  # files ending with Main.cpp will later
#     │                                # produce an executable
#     └── tests
#         └── FuzzyFileSearch.cpp      # This file contains a googlemock test
#                                      # suite. It will be linked with
#                                      # src/FuzzySearch.cpp
#
# Define template variables for using as prerequisites to targets:
# 1. Get main files and tests, as those will produce a binary later
MAIN_BINARIES_TMP = $(basename $(wildcard $(1)/*Main.cpp))
TEST_BINARIES_TMP = $(basename $(wildcard $(1)/tests/*.cpp))
# Get header files to recompile, when those change.
HEADERS_TMP = $(wildcard $(1)/*.h)
OBJECTS_TMP = $(addsuffix .o, $(basename $(filter-out %Main.cpp, $(wildcard $(1)/*.cpp))))
# Link every test with its right corresponding object and make it dependfile
HEADERS_TMP = $(1)/$(2).h
OBJECTS_TESTS_TMP = $(addsuffix .o, $(1)/$(2))

###############################################################################
# Configuration                                                               #
###############################################################################
.PRECIOUS: $(DEPDIR)/%.d
