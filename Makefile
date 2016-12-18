#  C++ Project Template - Main GNUMake file
#  ====
#  Copyright 2016 Rezart Qelibari <rezart.q-github@gmail.com>
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
# provides the tasks which are required by all subprojects.
# It further has a target which offers a "standard way" to build the sub
# projects, if they obey the naming convention.
#
# #How to call?
# This Makefile offers two schemes of calling:
# 1. $ make target
# 

###############################################################################
# Variables                                                                   #
###############################################################################
# Info: ':=' means expand variables on definition
# >> General variables
#######################################
# Set variable according to:
# https://www.gnu.org/software/make/manual/html_node/Makefile-Basics.html
SHELL = /bin/zsh
.SHELLFLAGS = -e
# Get root directory.
ROOT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
VENDOR_DIR := $(ROOT_DIR)/vendors
MAKFILES_DIR := $(ROOT_DIR)/Makefiles
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

###############################################################################
# Default configuration                                                       #
###############################################################################
MAKEFLAGS += --no-builtin-rules
.SUFFIXES:
.SUFFIXES: .o .cpp
.ONESHELL:

# Define those variables only when invocation on command line looks like:
# > make <project> <target>
ifeq ($(words $(MAKECMDGOALS)), 2)
PROJECT := $(firstword $(MAKECMDGOALS))
PROJECT_MAKEFILE := $(wildcard $(PROJECT)/Makefile)
CMD = $(lastword $(MAKECMDGOALS))

# >> Project folder structure
#######################################
# This makefile offers a standard build target for projects located in
# subfolders. To achieve this it assumes the following project structure.
#
# .
# ├── LICENSE
# ├── Makefile  # -> this is the main Makefile
# ├── README.md
# ├── Makefiles  # -> Makefiles to include in main Makefile.
#     ├── Gtest.make    # -> Makefile with targets related to gtest
#     └── Cpplint.make  # -> Makefile related to cpplint.py
# └── project1  # -> a project
#     ├── Makefile    # -> this is a project specific Makefile
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
#         └── FuzzyFileSearch.cpp      #  -> This file contains a test suite.
#									   # It will be linked with
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

DEPFLAGS = -MT $@ -MMD -MP -MF $(DEPDIR)/$(@F).Td
POSTCOMPILE = mv -f $(DEPDIR)/$(@F).Td $(DEPDIR)/$(@F).d

# >> Template variables
#######################################
# Define template variables for using as prerequisites to targets:
# 1. Get main files as those will produce a binary later
MAIN_BINARIES := $(subst $(SRC_DIR),$(BIN_DIR),$(basename $(wildcard $(SRC_DIR)/*Main.cpp)))
SRCS := $(basename $(filter-out %Main.cpp, $(wildcard $(SRC_DIR)/*.cpp)))
OBJS := $(addsuffix .o,$(subst $(SRC_DIR),$(BUILD_DIR),$(SRCS)))
DEPFILES := $(wildcard $(DEPDIR)/*.d)

###############################################################################
# Configuration                                                               #
###############################################################################
.PRECIOUS: $(DEPDIR)/%.d $(BUILD_DIR)/%.o $(BUILD_DIR)/%Test.o
PHONY_TARGETS := screate sbuild sclean scheckstyle stest sclean-all
.PHONY: $(PROJECT) $(PHONY_TARGETS)
.SECONDEXPANSION:

###############################################################################
# Targets                                                                     #
###############################################################################
# Add phony targets
ifeq ($(filter $(PHONY_TARGETS), $(CMD)),)
ifneq ($(PROJECT_MAKEFILE),)
$(PROJECT):
	@echo "Delegating to project Makefile."

.DEFAULT: $(MAKE) -C $(PROJECT) $(CMD)
else
    $(error "Error: Project does not have a Makefile.")
endif
else
$(PROJECT):
	@echo "Calling standard targets."
endif

# >> Standard targets
#######################################
# Create project folders according to standard build
screate:
	@echo "Creating project" $(PROJECT)
	@mkdir -p $(BIN_DIR)
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(LIB_DIR)
	@mkdir -p $(SRC_DIR)
	@mkdir -p $(TESTS_DIR)

sbuild: $(MAIN_BINARIES)


# >> Standard clean target
#######################################
sclean:
	@echo "Cleaning project..."
	@rm -f $(BIN_DIR)/*
	@rm -f $(BUILD_DIR)/*.o

sclean-all: sclean
	@echo "Additionally cleaning dependency files..."
	@rm -f $(DEPDIR)/*

# >> Standard build targets
#######################################
$(BIN_DIR)/%Main: $(BUILD_DIR)/%Main.o $(OBJS)
	@echo "Linking binary: " $@
	@$(COMPILECPP) -o $@ $^

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp $(DEPDIR)/$$(@F)).d
	@echo ">> Compiling " $<
	@$(COMPILECPP) -c -o $@ $(DEPFLAGS) $<
	@$(POSTCOMPILE)

$(DEPDIR)/%.d: ;

-include $(DEPFILES)
endif

###############################################################################
# Configuration                                                               #
###############################################################################
.PHONY: init cpplint add-submodule init-submodules gmocklib

###############################################################################
# Targets                                                                     #
###############################################################################
init: gmocklib cpplint

cpplint: init-submodules
	@echo "Link cpplint.py"
	@ln -s "$(subst $(ROOT_DIR)/,,$(CPPLINT_REPO_DIR))/cpplint/cpplint.py" "$(CPPLINT)"

add-submodule:
	@[ ! -d ".git" ] && git init || true
	@echo "Add vendor dir if not exists"
	@mkdir -p $(VENDOR_DIR)
	@echo "Add google styleguides as submodule if not already done"
	@[ ! -d "$(CPPLINT_REPO_DIR)" ] && git submodule add $(CPPLINT_REPO) "$(subst $(ROOT_DIR)/,,$(CPPLINT_REPO_DIR))" || true
	@echo "Add goolge/googletest as submodule if not already done"
	@[ ! -d "$(GMOCK_REPO_DIR)" ] && git submodule add $(GMOCK_REPO) "$(subst $(ROOT_DIR)/,,$(GMOCK_REPO_DIR))" || true

init-submodules: add-submodule
	@echo "Init submodules.."
	@git submodule update --init --recursive
