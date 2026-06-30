extends Node


@export var data : ReactiveData:
	set(value): data = value; DBS.notify_source_data_changed(&"data")

## WARNING for DataBindSystem to function, you need to add a setter to your ReactiveData -
## - With the following line :
# DataBindSystem.notify_source_data_changed(&"reactive_data_name")

## WARNING DataBindSystem.notify_source_data_changed is
## notify_source_data_changed(source_data_name, force_update: bool = true, force_null_update: bool = true) -> void:
# source_data_name : is the name of the ReactiveData
# force_update : if true, call the callback function when ReactiveData is replaced by another ReactiveData
# force_null_update : if true, call the callback function when ReactiveData is replaced by null

var data2 : ReactiveData:
	set(value): data = value; DBS.notify_source_data_changed(&"data2")


var DBS := DataBindSystem.new(self)

## WARNING DataBindSystem needs who is the source_objecy
# source_object : The Object that is holding the ReactiveData


func _ready():
	DBS.bind_source(&"data", [&"propery1", &"property2"], update)
	DBS.bind_source(&"data2", [&"propery1"], update2)
	
	data2 = MyExampleData.new()

## WARNING DataBindSystem.bind_source is :
## bind_source(source_data_name: StringName, watched_properties: Array[StringName], callback: Callable) -> void
# source_data_name : is the name of the ReactiveData
# watched_properties : is the name of the properties in ReactiveData to react to
# callback : when a property from watched_properties is changed, the callback function is called


func update():
	print("data changed")

func update2():
	print("data2 changed")
