class_name CharacterStatsData extends ReactiveData


@export var max_hp : int = 0:
	set(value):
		max_hp = value;
		current_hp = clamp(current_hp, 0, max_hp)
		notify(&"stats.max_hp")

@export var current_hp : int = 0:
	set(value):
		current_hp = clamp(value,0,max_hp);
		notify(&"stats.current_hp")

@export var damage : int = 0:
	set(value): damage = value; notify(&"stats.damage")
