#  C++ Project Template - GNUMake Makefile for googletest
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


ifdef VENDOR_DIR
ifdef COMPILECPP
ifdef ROOT_DIR

###############################################################################
# Default variables                                                           #
###############################################################################

# >> Googletest variables
#######################################
GMOCK_REPO = https://github.com/google/googletest.git
GMOCK_REPO_DIR := $(VENDOR_DIR)/googletest
GMOCK_DIR := $(GMOCK_REPO_DIR)/googlemock
GTEST_DIR := $(GMOCK_DIR)/../googletest
export GTEST_CXX := $(COMPILECPP) -isystem $(GTEST_DIR)/include \
                    -isystem $(GMOCK_DIR)/include
GMOCK_OBJECTS := $(GTEST_DIR)/make/gtest-all.o $(GMOCK_DIR)/make/gmock-all.o $(GMOCK_DIR)/make/gmock_main.o
export GMOCK_LIB = $(ROOT_DIR)/lib/libgmock.a

# >> Template variables
#######################################
TESTS_BINARIES := $(subst $(TESTS_DIR),$(BIN_DIR),$(basename $(wildcard $(TESTS_DIR)/*Test.cpp)))

###############################################################################
# Targets                                                                     #
###############################################################################
# >> Standard build targets
#######################################
stest: $(TESTS_BINARIES)
	@for T in $(TEST_BINARIES); do ./$$T; done

$(BIN_DIR)/%Test: $(BUILD_DIR)/%Test.o $$(filter $(BUILD_DIR)/$$*.o, $(OBJS))
	@echo "Linking test binary: " $@
	@$(GTEST_CXX) -lpthread -o $@ $^ $(GMOCK_LIB)

$(BUILD_DIR)/%Test.o: $(TESTS_DIR)/%Test.cpp
	@echo ">> Compiling test binary " $<
	@$(GTEST_CXX) -c -o $@ $(DEPFLAGS) $<
	@$(POSTCOMPILE)

# >> Build googlemock
#######################################
gmocklib: init-submodules $(GMOCK_OBJECTS)
	@echo "Bundle to library..."
	@mkdir -p $(dir $(GMOCK_LIB))
	@ar -rv $(GMOCK_LIB) $(GMOCK_OBJECTS)
	@$(MAKE) -C $(GMOCK_DIR)/make clean
	@$(MAKE) -C $(GTEST_DIR)/make clean

$(GMOCK_OBJECTS):
	@echo "Compiling " $(notdir $@) "..."
	$(MAKE) -C $(dir $@)