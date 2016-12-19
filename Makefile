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
# offers the following call schemes:
#
# 1. Call a target
# > make <target>
# Call a target of this Makefile
#
# 2. Call a target which runs on a project
# > make <target> <project>
# Calls a target of this Makefile which runs on a project folder.
#
# 3. Calls a target on a project specific Makefile.
# > make <project> <target>
# Calls a target on a project specific Makefile, if it exists. The distinction
# between calling scheme 2 and 3 is made by testing, if a folder with the name
# of the first argument to make exists (when yes, calling scheme 3 is assumed).
#

###############################################################################
# Variables                                                                   #
###############################################################################
# Info: ':=' means expand variables on definition
# >> General variables
#######################################
DEBUG = yes

# >> Folder variables
#######################################
# The following folder structure is assumed.
#
# ROOT_DIR
# ├── LICENSE
# ├── Makefile  # -> this is the main Makefile
# ├── README.md
# ├── Makefiles  # -> Makefiles to include in main Makefile.
# │   ├── Gtest.make    # -> Makefile with targets related to gtest
# │   └── Cpplint.make  # -> Makefile related to cpplint.py
# ├── project1  # -> one project
# └── project2  # -> another project
#
ROOT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
VENDOR_DIR := $(ROOT_DIR)/vendors
GLIB_DIR := $(ROOT_DIR)/lib
MAKFILES_DIR := $(ROOT_DIR)/Makefiles

# >> Internal config variables/targets
#######################################
# Set variable according to:
# https://www.gnu.org/software/make/manual/html_node/Makefile-Basics.html
SHELL = /bin/zsh
.SHELLFLAGS = -e

###############################################################################
# Calling scheme selector                                                     #
###############################################################################
ifeq ($(words $(MAKECMDGOALS)), 2)
# >> Calling scheme 2 or 3
#######################################
ARGZ = $(firstword $(MAKECMDGOALS))
ARGO = $(lastword $(MAKECMDGOALS))
IS_ARGZ_FOLDER = $(wildcard $(ARGZ))
IS_ARGO_FOLDER = $(wildcard $(ARGO))
endif

ifneq (,$(IS_ARGZ_FOLDER))
# >> Calling scheme 3
#######################################
-include $(wildcard $(MAKFILES_DIR)/*3.make)
else (,$(IS_ARGO_FOLDER))
# >> Calling scheme 2
#######################################
-include $(wildcard $(MAKFILES_DIR)/*2.make)
else
# >> Calling scheme 1
#######################################
-include $(wildcard $(MAKFILES_DIR)/*1.make)
endif
