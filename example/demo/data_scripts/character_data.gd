class_name CharacterData extends ReactiveData


@export var name : String = "":
	set(value): name = value; notify(&"name")

@export_enum("Warrior","Wizzard","Assassin") var character_class: int = 0:
	set(value): character_class = value; notify(&"character_class")

@export var stats : CharacterStatsData: # extends ReactiveData
	set(value): stats = value; stats.parent = self; notify(&"stats")

@export var inventory : Array:
	set(value): inventory = value; notify(&"inventory")
