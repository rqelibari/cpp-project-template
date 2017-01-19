#  C++ Project Template - GNUMake Makefile (1) for googletest
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
INIT_PREQ += gmocklib

###############################################################################
# Variables                                                                   #
###############################################################################
GMOCK_REPO := https://github.com/google/googletest.git
GMOCK_OBJECTS := $(GTEST_DIR)/make/gtest-all.o \
                 $(GMOCK_DIR)/make/gmock-all.o \
                 $(GMOCK_DIR)/make/gmock_main.o

###############################################################################
# Targets                                                                     #
###############################################################################
PHONY_TARGETS += gmocklib add-gmock-submodule $(GMOCK_OBJECTS)
# >> Build googlemock
#######################################
gmocklib: add-gmock-submodule $(GMOCK_OBJECTS)
	@echo "Bundle to library..."
	@mkdir -p $(dir $(GMOCK_LIB))
	@ar -rv $(GMOCK_LIB) $(GMOCK_OBJECTS)

add-gmock-submodule:
	@echo "Add goolge/googletest as submodule if not already done..."
	@[ ! -d "$(GMOCK_REPO_DIR)" ] && git submodule add $(GMOCK_REPO) "$(subst $(ROOT_DIR)/,,$(GMOCK_REPO_DIR))" || true
	@echo "...done."
	@echo "Init gmock submodule..."
	@git submodule update --init --recursive
	@echo "...done."

$(GMOCK_OBJECTS):
	@echo "Compiling " $(notdir $@) "..."
	$(MAKE) -C $(dir $@)