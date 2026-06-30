extends VBoxContainer

var path : String = "res://example/demo/ressources/saved_charater.tres"

@onready var save_btn: Button = $HBoxContainer/SaveBtn
@onready var load_btn: Button = $HBoxContainer/LoadBtn

func _ready() -> void:
	save_btn.pressed.connect(_on_save_pressed)
	load_btn.pressed.connect(_on_load_pressed)

func _on_save_pressed():
	var data = Game.node.selected_character.character_data
	DataBindSystem.save_data(data, path)

func _on_load_pressed():
	#var data = Game.node.selected_character.character_data
	Game.node.selected_character.character_data = DataBindSystem.load_data(path)
