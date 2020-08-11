#!/bin/bash
pushd godot-project

GODOT=${GODOT_PATH:-'/Applications/Godot.app/Contents/MacOS/Godot'}
DEFAULT_ARGUMENTS="-s addons/gut/gut_cmdln.gd --path $PWD -gexit -ginclude_subdirs $@"
TEST_GLOB="res://test/unit"

echo "#=== Running Godot unit tests..."
$GODOT $DEFAULT_ARGUMENTS -gdir=$TEST_GLOB || exit 1
exit 0
