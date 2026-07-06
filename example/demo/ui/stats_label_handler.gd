extends VBoxContainer


@onready var name_label: Label = $NameLabel
@onready var max_hp_label: Label = $MaxHPLabel
@onready var damage_label: Label = $DamageLabel


var _data : CharacterData :
	get(): return Game.node.selected_character.character_data


func _ready() -> void:
	Game.node.selected_character.DBS.bind_source(&"character_data", [&"name", &"stats.max_hp", &"stats.damage"], update_text)


func update_text() -> void:
	if _data and _data.stats:
		name_label.text = _data.name
		max_hp_label.text = "Max HP : %s" % [_data.stats.max_hp]
		damage_label.text = "Damage : %s" % [_data.stats.damage]
	else :
		name_label.text = "No Character Selected"
		max_hp_label.text = ""
		damage_label.text = ""
