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
# Targets                                                                     #
###############################################################################
# Create project folders according to standard build
ifeq ($(words $(MAKECMDGOALS)), 2)
PROJECT = $(ARGO)
create:
	@echo "Creating project" $(PROJECT)
	@mkdir -p $(DEPDIR)
	@mkdir -p $(BIN_DIR)
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(LIB_DIR)
	@mkdir -p $(SRC_DIR)
	@mkdir -p $(TESTS_DIR)
endif
