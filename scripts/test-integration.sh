#!/bin/bash
pushd godot-project

GODOT=${GODOT_PATH:-'/Applications/Godot.app/Contents/MacOS/Godot'}
DEFAULT_ARGUMENTS="-s addons/gut/gut_cmdln.gd --path $PWD -gexit -ginclude_subdirs $@"

echo "#=== Running Godot unit tests..."
$GODOT $DEFAULT_ARGUMENTS -gdir=res://test/integration || exit 1
exit 0
