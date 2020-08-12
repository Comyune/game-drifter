extends Node

const ROOT_PATH = "/root/Main"

func on():
	var current_scene = get_tree().get_current_scene()
	if !current_scene: return false
	var current_scene_path = current_scene.get_path()
	return ROOT_PATH == current_scene_path
