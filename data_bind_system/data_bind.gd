class_name DataBind extends RefCounted


var source_object: Object
var watched_properties: Array[StringName] # Is sorted by [DataBindSystem]
var callback: Callable
var source_data_name: StringName
var _data: ReactiveData


func _init(object: Object, data_name: StringName,
properties: Array[StringName], function: Callable):
	
	source_object = object
	watched_properties = properties
	callback = function
	source_data_name = data_name
	
	_connect()
	active_count += 1


func _connect() -> void:
	_data = source_object.get(source_data_name)
	if _data: _data.property_changed.connect(_on_data_changed)


func _disconnect() -> void: 
	if _data and _data.property_changed.is_connected(_on_data_changed):
		_data.property_changed.disconnect(_on_data_changed)


func reconnect() -> void:
	_disconnect()
	_connect()


func _on_data_changed(from_data: ReactiveData, property: StringName) -> void:
	if not is_instance_valid(source_object):
		push_warning("source_object instance is invalid, disconnecting DataBind",
		"source_object : ", source_object, ". source_data_name : ", source_data_name,
		". watched_properties : ", watched_properties, ". callback : ", callback)
		
		_disconnect()
		return
	
	if from_data != _data: return
	
	if watched_properties.has(property): callback.call()




static var active_count := 0:
	set(value): active_count = value; #print("Binds : %s" % [active_count])

func _notification(what) -> void:
	if what == NOTIFICATION_PREDELETE: active_count -= 1
