extends VBoxContainer


@onready var maxhp_spin_box: SpinBox = $HBoxContainer/SpinBox
@onready var damage_spin_box: SpinBox = $HBoxContainer2/SpinBox
@onready var currenthp_spin_box: SpinBox = $HBoxContainer3/SpinBox
@onready var line_edit: LineEdit = $LineEdit


var _data : CharacterData :
	get(): return Game.node.selected_character.character_data


func _ready() -> void:
	Game.node.selected_character.DBS.bind_source(&"character_data", [&"stats.max_hp", &"stats.current_hp", &"stats.damage"], update_display)
	
	maxhp_spin_box.value_changed.connect(_on_max_hp_changed)
	damage_spin_box.value_changed.connect(_on_damage_changed)
	currenthp_spin_box.value_changed.connect(_on_currenthp_changed)
	line_edit.text_changed.connect(_on_name_changed)


func update_display() -> void:
	if _data and _data.stats:
		maxhp_spin_box.value = _data.stats.max_hp
		damage_spin_box.value = _data.stats.damage
		currenthp_spin_box.value = _data.stats.current_hp
		line_edit.text = _data.name
	else :
		maxhp_spin_box.value = 0
		damage_spin_box.value = 0
		currenthp_spin_box.value = 0
		line_edit.text = "null"


func _on_max_hp_changed(value: float):
	if _data and _data.stats:
		_data.stats.max_hp = int(value)

func _on_damage_changed(value: float):
	if _data and _data.stats:
		_data.stats.damage = int(value)

func _on_currenthp_changed(value: float):
	if _data and _data.stats:
		_data.stats.current_hp = int(value)

func _on_name_changed(value: String):
	if _data and _data.stats:
		_data.name = value
