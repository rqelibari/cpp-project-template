#  Fuzzy Search - Main GNUMake file
#  ====
#  Copyright 2016 Rezart Qelibari <qelibarr@informatik.uni-freiburg.de>
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

# This makefile is the entry point for all sub projects makefile. It
# provides the tasks which are required by all subprojects (e.g. building)
# googlemock. It further has a target which offers a build of the sub
# projects, but depends on naming conventions.