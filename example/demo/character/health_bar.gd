class_name HealthBar extends ColorRect


@onready var character: Character = $".."


func _ready() -> void:
	character.DBS.bind_source(&"character_data", [&"stats.current_hp",&"stats.max_hp"], update_hp)
	update_hp()


func update_hp():
	if character.character_data:
		var stats = character.character_data.stats
		var ratio : float = float(stats.current_hp) / stats.max_hp
		%GreenBar.scale.x = ratio
	else: %GreenBar.scale.x = 0
