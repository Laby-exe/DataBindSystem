## This class manages [DataBind]. [br]
## You should only have 1 DataBindSystem per source_object
class_name DataBindSystem extends RefCounted


# Dictionary[source_data_name, [DataBind]]
var _source_binds : Dictionary[StringName, Array]

var _source_object : Object

## [param source_object] is used to define which object holds the source_data : [ReactiveData] [br]
## source_object : is the Object holding DataBindSystem and ReactiveData [br]
## [code]var DBS := DataBindSystem.new(self)[/code]
func _init(source_object: Object):
	_source_object = source_object
	assert(_source_object, "source_object is null")


## Create a bind that call the callback function when 1 of the watched_properties in the source_data is changed[br][br]
## [b]source_data_name[/b] : is the name of the source_data : [ReactiveData] [br]
## [b]force_update[/b] : if true, call the callback function when source_data is replaced by another [ReactiveData] [br]
## [b]force_null_update[/b] : if true, call the [param callback] function when [ReactiveData] is replaced by null [br][br][br]
## [b] Example Usage
## [codeblock]
## var DBS := DataBindSystem.new(self)
##
## var data : ReactiveData:
##     set(value): 
##         data = value
##         DBS.notify_source_data_changed(&"data")
##
## func _ready() -> void:
##     DBS.bind_source(&"data", [&"property1", &"property2"], update)
##
## func update():
##     print("property 1 or property 2 was updated")
## [/codeblock]
func bind_source(source_data_name: StringName, watched_properties: Array[StringName],
callback: Callable, call_immediately: bool = true) -> void:
	
	# Is source_data_name valid ?
	assert(has_property(_source_object, source_data_name), "Can't find source_data %s in source_object %s" % [source_data_name, _source_object])
	# If source_data is not null, is it ReactiveData ?
	var source_data = _source_object.get(source_data_name)
	if source_data : assert(source_data is ReactiveData, "source_data %s is not ReactiveData" % [source_data_name])
	# Check for already existing similar binds
	var err : DataBind = find_bind(source_data_name, watched_properties, callback)
	if err: push_warning("Aptenting to create a bind that already exist %s" % [err]); return
	
	
	watched_properties.sort()
	
	var new_bind := DataBind.new(
		_source_object,
		source_data_name,
		watched_properties,
		callback
	)
	
	if not _source_binds.has(source_data_name) : _source_binds[source_data_name] = []
	_source_binds[source_data_name].append(new_bind)
	
	if call_immediately: new_bind.callback.call()


## Find and unbind a Bind with the same properties as follow [br][br]
## [b]source_data_name[/b] : is the name of the source_data : [ReactiveData] [br]
## [b]force_update[/b] : if [code]true[/code], the [param callback] function is called when source_data is replaced by another [ReactiveData] [br]
## [b]force_null_update[/b] : if [code]true[/code], the [param callback] function is called when [ReactiveData] is replaced by null
func unbind(source_data_name: StringName,
watched_properties: Array[StringName], callback: Callable) -> void:
	
	watched_properties.sort()
	
	var bind : DataBind = find_bind(source_data_name, watched_properties, callback)
	assert(bind, "couldn't find a matching bind to unbind %s, %s, %s, %s" % [_source_object,source_data_name,watched_properties,callback])
	
	bind._disconnect()
	_source_binds[source_data_name].erase(bind)


## You can use this function to know when a source data has changed
signal source_data_changed()

## Update all binds that were linked to the source_data [br][br]
## [b]source_data_name[/b] : is the name of the source_data : [ReactiveData] [br]
## [b]force_update[/b] : if true, call the callback function when source_data is replaced by another [ReactiveData] [br]
## [b]force_null_update[/b] : if true, call the callback function when [ReactiveData] is replaced by null [br][br]
## When source_data is null, the bind automatically disconnect, 
## but when the source_data is not null, the bind automatically reconnects [br][br][br]
## [b] Example Usage
## [codeblock]
## var DBS := DataBindSystem.new(self)
##
## var data : ReactiveData:
##     set(value): 
##         data = value
##         DBS.notify_source_data_changed(&"data")
## [/codeblock]
func notify_source_data_changed(source_data_name,
force_update: bool = true, force_null_update: bool = true) -> void:
	
	source_data_changed.emit()
	
	# If source_data is not null, is it ReactiveData ?
	var source_data = _source_object.get(source_data_name)
	if source_data : assert(source_data is ReactiveData, "source_data %s is not ReactiveData" % [source_data_name])
	
	if not _source_binds.has(source_data_name): return
	if _source_binds[source_data_name].is_empty(): return
	
	
	if _source_object.get(source_data_name):
		for bind in _source_binds[source_data_name]:
			bind.reconnect()
			if force_update: bind.callback.call()
	else:
		for bind in _source_binds[source_data_name]:
			bind._disconnect()
			if force_null_update: bind.callback.call()


## SAVE SYSTEM

## Load a source_data from a path, [param resouce_path_override] can be set to change the default
## save path of the [ReactiveData][br][br][br]
## [b] Example Usage
## [codeblock]
## DBS.load_data(&"my_data", "res://resources/my_data")
##
## DBS.load_data(&"definition_data", "res://resources/my_definition_data", "user://saved_data")
##
## DBS.save_data(&"definition_data") # resource will be saved to "user://saved_data" instead of "res://resources/my_definition_data"
## [/codeblock]
func load_data(source_data_name: StringName, load_from_path: String, resouce_path_override: String = "") -> void :
	
	# Is source_data_name valid ?
	assert(has_property(_source_object, source_data_name), "Can't find source_data %s in source_object %s" % [source_data_name, _source_object])
	# Is data at path ?
	assert(ResourceLoader.exists(load_from_path), "No ressource found at path %s" % [load_from_path])
	
	var data = ResourceLoader.load(load_from_path)
	assert(data, "Data at path load_from_path %s is invalid" % [load_from_path])
	assert(data is ReactiveData, "source_data is not ReactiveData")
	 
	if not resouce_path_override.is_empty(): data.resource_path_override = resouce_path_override
	
	_source_object.set(source_data_name, data)


## Save a source_data either to Resource.resource_path or to [param save_to_path] [br][br][br]
## [b] Example Usage
## [codeblock]
## DBS.save_data(&"my_data") # Save to my_data.resource_path
## DBS.save_data(&"definition_data", "res://resources/my_data") # Save to custom_path, will not overwrite original data
## [/codeblock]
func save_data(source_data_name: StringName, save_to_path: String = "") -> void :
	
	# Is source_data_name valid ?
	assert(has_property(_source_object, source_data_name), "Can't find source_data %s in source_object %s" % [source_data_name, _source_object])
	# Is source_data valid ?
	var source_data = _source_object.get(source_data_name)
	if not source_data: push_error("Can't save source_data %s, source_data is null" % [source_data_name]); return
	assert(source_data is ReactiveData, "source_data %s is not ReactiveData" % [source_data_name])
	
	
	var path : String
	if save_to_path.is_empty():
		if source_data.resource_path_override.is_empty(): path = source_data.resource_path
		else: path = source_data.resource_path_override
		
	else: path = save_to_path
	# Is path valid ?
	assert(not path.is_empty(), "Aptenting to save %s but saving path is empty : %s" % [source_data_name, path])
	
	var err := ResourceSaver.save(source_data, path)
	if err != OK: push_warning("Save failed (%s)" % error_string(err))


## HELPER

func find_bind(source_data_name: StringName, watched_properties: Array[StringName],
callback: Callable ) -> DataBind:
	
	if not _source_binds.has(source_data_name): return null
	
	for bind in _source_binds[source_data_name]:
		if not bind.watched_properties == watched_properties: continue
		if not bind.callback == callback: continue
		return bind
		
	return null


func has_property(obj: Object, property_name: StringName) -> bool:
	for property_info in obj.get_property_list():
		if property_info.name == property_name:
			return true
	return false
