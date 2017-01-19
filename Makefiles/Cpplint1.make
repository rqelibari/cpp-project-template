#  C++ Project Template - GNUMake Makefile for google cpplint
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

# IMPORTANT: This file is meant to be included into the main file!

# Add prerequisit to init
INIT_PREQ += cpplint

###############################################################################
# Variables                                                                   #
###############################################################################
# >> Stylecheck variables
#######################################
# CPPLINT_REPO = "https://github.com/google/styleguide.git"
CPPLINT_REPO = "https://raw.githubusercontent.com/google/styleguide/gh-pages/cpplint/cpplint.py"
CPPLINT_DIR := $(VENDOR_DIR)/google-styleguides
CPPLINT := $(CPPLINT_DIR)/cpplint.py
CPPLINT_CONFIG := $(ROOT_DIR)/CPPLINT.cfg
LINT := $(CPPLINT)

###############################################################################
# Targets                                                                     #
###############################################################################
cpplint: cpplint.py
	@echo "Create config file..."
	@echo "filter=-build/header_guard,-build/include" > $(CPPLINT_CONFIG)

cpplint.py:
	@echo "Get cpplint.py"
	-@[ ! -d "$(CPPLINT_DIR)" ] && echo "...creating cpplint dir..."
	-@mkdir -p $(CPPLINT_DIR)
	@echo "Downloading cpplint.py"
	-@curl -o $(CPPLINT) $(CPPLINT_REPO)