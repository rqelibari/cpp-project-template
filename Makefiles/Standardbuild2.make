#  C++ Project Template - GNUMake Makefile (2) for standard build
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
# >> File variables
#######################################
MAIN_BINARIES := $(subst $(SRC_DIR),$(BIN_DIR),$(basename $(wildcard $(SRC_DIR)/*Main.cpp)))
TESTS_BINARIES := $(subst $(TESTS_DIR),$(BIN_DIR),$(basename $(wildcard $(TESTS_DIR)/*Test.cpp)))
SRCS := $(basename $(filter-out %Main.cpp, $(wildcard $(SRC_DIR)/*.cpp)))
OBJS := $(addsuffix .o,$(subst $(SRC_DIR),$(BUILD_DIR),$(SRCS)))

# File to run checkstlye on. (N) to allow nullglobing.
# Old way: CHECKSTYLE_FILES = $(SRC_DIR)/*.h(N) $(SRC_DIR)/*.cpp(N) $(TESTS_DIR)/*.cpp(N)
CHECKSTYLE_FILES = $(shell find -E . -regex '.*\.(jpg|png)')

PRECIOUS_PREQ += $(DEPDIR)/%.d $(BUILD_DIR)/%.o

# >> Compiler variables
#######################################
CXXFLAGS += -std=c++14
ifeq ($(DEBUG), yes)
	CXXFLAGS += -g -Wall -DDEBUG
else
	CXXFLAGS += -O3
endif

# >> Dependency variables
#######################################
DEPFLAGS = -MT $@ -MMD -MP -MF $(DEPDIR)/$(@F).Td
POSTCOMPILE = mv -f $(DEPDIR)/$(@F).Td $(DEPDIR)/$(@F).d

###############################################################################
# Targets                                                                     #
###############################################################################
# >> Standard targets
#######################################
build: $(MAIN_BINARIES)
test: $(TESTS_BINARIES)
	@for T in $(TEST_BINARIES); do ./$$T; done


checkstyle: $(CHECKSTYLE_FILES)
	@echo "Run checkstyle on all modified files..."$$'\n'
	@$(CPPLINT) $?

# >> Standard clean target
#######################################
clean:
	@echo "Cleaning project..."
	@rm -f $(BIN_DIR)/*
	@rm -f $(BUILD_DIR)/*.o

clean-all: clean
	@echo "Additionally cleaning dependency files..."
	@rm -f $(DEPDIR)/*

# >> Standard build targets
#######################################
$(BIN_DIR)/%Main: $(BUILD_DIR)/%Main.o $(OBJS)
	@echo "Linking binary: " $@
	@$(COMPILECPP) -o $@ $^

$(BIN_DIR)/%Test: $(BUILD_DIR)/%Test.o $$(filter $(BUILD_DIR)/$$*.o, $(OBJS))
	@echo "Linking test binary: " $@
	@$(COMPILECPP) $(LDLIBS_TEST) -o $@ $^ $(GMOCK_LIB)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp $(DEPDIR)/$$(@F)).d
	@echo ">> Compiling " $<
	@$(COMPILECPP) -c -o $@ $(DEPFLAGS) $<
	@$(POSTCOMPILE)

$(BUILD_DIR)/%Test.o: $(TESTS_DIR)/%Test.cpp
	@echo ">> Compiling test binary " $<
	@$(TEST_CXX) -c -o $@ $(DEPFLAGS) $<
	@$(POSTCOMPILE)

$(DEPDIR)/%.d: ;

-include $(DEPFILES)
