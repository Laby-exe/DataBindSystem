extends VBoxContainer

var path : String = "res://example/demo/ressources/saved_charater.tres"

@onready var save_btn: Button = $HBoxContainer/SaveBtn
@onready var load_btn: Button = $HBoxContainer/LoadBtn
@onready var save_path_btn: Button = $HBoxContainer/SavePathBtn

func _ready() -> void:
	save_btn.pressed.connect(_on_save_pressed)
	load_btn.pressed.connect(_on_load_pressed)
	save_path_btn.pressed.connect(_on_save_at_path_pressed)

func _on_save_pressed():
	var character = Game.node.selected_character
	character.DBS.save_data(&"character_data")

func _on_save_at_path_pressed():
	var character = Game.node.selected_character
	character.DBS.save_data(&"character_data", path)

func _on_load_pressed():
	var character = Game.node.selected_character
	character.DBS.load_data(&"character_data", path)
