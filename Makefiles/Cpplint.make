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


###############################################################################
# Variables                                                                   #
###############################################################################
# >> Stylecheck variables
#######################################
CPPLINT_REPO = "https://github.com/google/styleguide.git"
CPPLINT_REPO_DIR := $(VENDOR_DIR)/google-styleguides
CPPLINT = $(ROOT_DIR)/cpplint.py

# >> Template variables
#######################################
# File to run checkstlye on. (N) to allow nullglobing.
CHECKSTYLE_FILES = $(SRC_DIR)/*.h(N) $(SRC_DIR)/*.cpp(N) $(TESTS_DIR)/*.cpp(N)

###############################################################################
# Targets                                                                     #
###############################################################################
scheckstyle:
	@echo "Run checkstyle..."$$'\n'
	@python $(CPPLINT) --filter='-build/header_guard,-build/include' $(CHECKSTYLE_FILES)