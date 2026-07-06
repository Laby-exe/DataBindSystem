class_name Character extends CharacterBody2D


@export var character_data : CharacterData: # extends ReactiveData
	set(value): character_data = value; DBS.notify_source_data_changed(&"character_data")


var DBS := DataBindSystem.new(self)


func _ready() -> void:
	Game.node.selected_character = self
	DBS.bind_source(&"character_data", [&"name"], update_name)


func update_name():
	if character_data: %NameLabel.text = character_data.name
	else: %NameLabel.text = ""
