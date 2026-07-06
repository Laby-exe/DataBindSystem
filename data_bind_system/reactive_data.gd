class_name ReactiveData extends Resource


## Parent is needed for notify propagation, for nested [ReactiveData] it needs to be set manually, Use : [br]
## [code]set(value): variant = value; parent = self, notify(property)[/code]
var parent : ReactiveData = null

## Can be used for saving outside of the original resource_path[br][br][br]
## [b] Example Usage
## [codeblock]
## DBS.load_data(&"definition_data", "res://resources/my_definition_data", "user://saved_data")
##
## DBS.save_data(&"definition_data") # resource will be saved to "user://saved_data" instead of "res://resources/my_definition_data"
## [/codeblock]
var resource_path_override : String = ""


signal property_changed(data: ReactiveData, property: StringName)
## Can be called by Resources extending [ReactiveData] to emit [signal property_changed].
## Will also propagate up if the Resource is nested and [constant parent] is defined. [br][br]
## [b]property[/b]: it is the name of the variant being changed [br]
## [b]source[/b]: is the ReactiveData emiting the change, is used for propagation [br]
## [b]propagate[/b]: if set to [code]true[/code] notify will propagate up[br]
func notify(property: StringName, source: ReactiveData = self, propagate: bool = true) -> void:
	
	property_changed.emit(self, property)
	
	if not propagate: return
	if not parent: return
	parent.notify(property, source)
