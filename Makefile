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
# Set variable according to:
# https://www.gnu.org/software/make/manual/html_node/Makefile-Basics.html
SHELL = /bin/sh
# Get the directory, where this makefile is located
ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
DEBUG := yes

# >> Compiler variables
#######################################
CXXFLAGS = -std=c++14
ifeq ($(DEBUG), yes)
	CXXFLAGS += -g -Wall -DDEBUG
else
	CXXFLAGS += -O3
endif

COMPILECPP = $(CXX) $(CXXFLAGS) $(CPPFLAGS) $(TARGET_ARCH)

# Define those variables only when invocation on command line looks like:
# > make project sb
ifeq ($(words $(MAKECMDGOALS)), 2)
PROJECT := $(firstword $(MAKECMDGOALS))
CMD = $(lastword $(MAKECMDGOALS))

# >> Project folder structure
#######################################
# This makefile offers a standard build target for projects located in
# subfolders. To achieve this it assumes the following project structure.
#
# .
# ├── LICENSE
# ├── Makefile  # -> this is the current makefile
# ├── README.md
# └── project1  # -> a project
#     ├── .d    # -> automatic generated dependency files
#     ├── bin   # -> this is where the final binary will be places
#     ├── build # -> this is where the build will happen
#     ├── lib   # -> this directory is for third party libraries
#     ├── src   # -> this is where your source is located
#     │   ├── FuzzyFileSearch.cpp
#     │   ├── FuzzyFileSearch.h
#     │   └── FuzzyFileSearchMain.cpp  # -> files ending with Main.cpp will
#     │                                # later produce an executable
#     └── tests # -> here you can your tests
#         └── FuzzyFileSearch.cpp      #  -> This file contains a googlemock
#									   # test suite. It will be linked with
#                                      # src/FuzzySearch.cpp
#
BIN_DIR = $(PROJECT)/bin
BUILD_DIR = $(PROJECT)/build
LIB_DIR = $(PROJECT)/lib
SRC_DIR = $(PROJECT)/src
TESTS_DIR = $(PROJECT)/tests

# >> Dependency variables
#######################################
# Taken from: http://make.mad-scientist.net/papers/advanced-auto-dependency-generation/#combine
DEPDIR := $(PROJECT)/.d
# Make dep dir
$(shell mkdir -p $(DEPDIR) >/dev/null)

DEPFLAGS = -MT $@ -MMD -MP -MF $(DEPDIR)/$(subst /,_,$*).Td
POSTCOMPILE = mv -f $(DEPDIR)/$(subst /,_,$*).Td $(DEPDIR)/$(subst /,_,$*).d

# >> Template variables
#######################################
# Define template variables for using as prerequisites to targets:
# 1. Get main files as those will produce a binary later
MAIN_BINARIES := $(subst $(SRC_DIR),$(BIN_DIR),$(basename $(wildcard $(SRC_DIR)/*Main.cpp)))
SRCS := $(basename $(filter-out %Main.cpp, $(wildcard $(SRC_DIR)/*.cpp)))
OBJS := $(addsuffix .o,$(subst $(SRC_DIR),$(BUILD_DIR),$(SRCS)))

###############################################################################
# Configuration                                                               #
###############################################################################
MAKEFLAGS += --no-builtin-rules
.SUFFIXES: .o .cpp
.PRECIOUS: $(DEPDIR)/%.d %.o
.PHONY: $(PROJECT) sbuild sclean
.SECONDEXPANSION:

###############################################################################
# Targets                                                                     #
###############################################################################
$(PROJECT):
	@echo "Calling standard targets."

sbuild: $(MAIN_BINARIES)

# >> Standard clean target
#######################################
sclean:
	@echo "Cleaning project..."
	@rm -f $(SRC_DIR)/*.o
	@rm -f $(BUILD_DIR)/*

# >> Standard build targets
#######################################
$(BIN_DIR)/%Main: $(BUILD_DIR)/%Main.o $(OBJS)
	@echo "Linking binary: " $@
	@$(COMPILECPP) -o $@ $^

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp $(DEPDIR)/$$(subst /,_,$$*).d
	@echo ">> Compiling " $<
	@$(COMPILECPP) -c -o $@ $(DEPFLAGS) $<
	@$(POSTCOMPILE)

$(DEPDIR)/%.d: ;

-include $(patsubst %,$(DEPDIR)/$(subst /,_,$*).d,$(SRCS))
endif
