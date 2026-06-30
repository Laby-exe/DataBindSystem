extends HBoxContainer


@export var characters_files : Array[CharacterData]


@onready var label_2: Label = $Label2
@onready var minus_btn: Button = $MinusBtn
@onready var plus_btn: Button = $PlusBtn


var current : int = 0


func _ready() -> void:
	minus_btn.pressed.connect(_on_minus_pressed)
	plus_btn.pressed.connect(_on_plus_pressed)
	
	await Game.node.ready
	Game.node.selected_character.DBS.source_data_changed.connect(special_update)
	
	update_character()


func _on_plus_pressed():
	if current < characters_files.size() - 1: current += 1
	else: current = 0
	update_character()

func _on_minus_pressed():
	if current > 0: current -= 1
	else: current = characters_files.size() - 1
	update_character()


func update_character():
	if Game.node.selected_character:
		Game.node.selected_character.character_data = characters_files[current]
	
	#label_2.text = characters_files[current].resource_path


func special_update():
	label_2.text = Game.node.selected_character.character_data.resource_path
