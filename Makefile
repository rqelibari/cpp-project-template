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

# >> Internal config variables/targets
#######################################
SUFFIXES = .o .cpp
PRECIOUS = %.d %.o
PHONY = create build clean checkstyle test clean-all

