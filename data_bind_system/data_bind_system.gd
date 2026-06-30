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
func bind_source(source_data_name: StringName,
watched_properties: Array[StringName], callback: Callable) -> void:
	
	assert(_source_object, "source_object is null")
	
	assert(has_property(_source_object, source_data_name), "Can't find %s in %s" % [source_data_name, _source_object])
	
	var source_data = _source_object.get(source_data_name)
	assert(source_data is ReactiveData, "source_data is not ReactiveData")
	
	#for property in watched_properties:
		#assert(ReactiveData.notified_properties.has(property), "The property '%s' in source_data %s is not used by any notify functions" % [property, source_data])
	
	var err : DataBind = find_bind(source_data_name, watched_properties, callback)
	if err: push_warning("Aptenting to create a bind that already exist %s" % [err]); return
	
	
	var new_bind := DataBind.new(
		_source_object,
		source_data_name,
		watched_properties,
		callback
	)
	
	if not _source_binds.has(source_data_name) : _source_binds[source_data_name] = []
	
	_source_binds[source_data_name].append(new_bind)


## Find and unbind a Bind with the same properties as follow [br][br]
## [b]source_data_name[/b] : is the name of the source_data : [ReactiveData] [br]
## [b]force_update[/b] : if [code]true[/code], the [param callback] function is called when source_data is replaced by another [ReactiveData] [br]
## [b]force_null_update[/b] : if [code]true[/code], the [param callback] function is called when [ReactiveData] is replaced by null
func unbind(source_data_name: StringName,
watched_properties: Array[StringName], callback: Callable) -> void:
	
	var bind = find_bind(source_data_name, watched_properties, callback)
	#assert(bind, "couldn't find a matching bind to unbind %s, %s, %s, %s" % [_source_object,source_data_name,watched_properties,callback])
	
	if bind: 
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

static func load_data(path : String) -> ReactiveData :
	
	assert(ResourceLoader.exists(path), "No ressource found at path %s" % [path])
	#if not ResourceLoader.exists(path) : 
		#ResourceSaver.save(ReactiveData.new(),path)
	
	return ResourceLoader.load(path)


static func save_data(new_data : ReactiveData, path : String) -> void :
	
	ResourceSaver.save(new_data, path)


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
