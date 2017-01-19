#  C++ Project Template - GNUMake Makefile (0) for googletest
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

###############################################################################
# Variables                                                                   #
###############################################################################

# >> Googletest variables
#######################################
GMOCK_REPO_DIR := $(VENDOR_DIR)/googletest
GMOCK_DIR := $(GMOCK_REPO_DIR)/googlemock
GTEST_DIR := $(GMOCK_DIR)/../googletest
GMOCK_LIB := $(GLOBAL_LIB_DIR)/libgmock.a
LDLIBS_TEST += -lpthread -lgmock

# >> Compiler variables
#######################################
CXXFLAGS += -isystem $(GTEST_DIR)/include \
            -isystem $(GMOCK_DIR)/include