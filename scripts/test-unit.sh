#!/bin/bash
pushd godot-project

GODOT=${GODOT_PATH:-'/Applications/Godot.app/Contents/MacOS/Godot'}
DEFAULT_ARGUMENTS="-s addons/gut/gut_cmdln.gd -ghide_orphans --path $PWD -gexit $@"

echo "#=== Running Godot unit tests..."
$GODOT $DEFAULT_ARGUMENTS -gdir=res://test/unit || exit 1
exit 0