#!/bin/bash
pushd godot-project

GODOT=${GODOT_PATH:-'/Applications/Godot.app/Contents/MacOS/Godot'}
DEFAULT_ARGUMENTS="-s addons/gut/gut_cmdln.gd --path $PWD -gexit $@"

echo "#=== Running Godot unit tests..."
$GODOT $DEFAULT_ARGUMENTS -gdir=res://test/unit || exit 1

echo "#=== Running Godot integration tests..."
$GODOT $DEFAULT_ARGUMENTS -gdir=res://test/integration || exit 1

echo "#=== All tests passed!"
exit 0