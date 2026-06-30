class_name Game extends Node2D


static var node : Game
func _init() -> void: node = self


signal selected_character_changed()
var selected_character: Character:
	set(v): selected_character = v; selected_character_changed.emit()
