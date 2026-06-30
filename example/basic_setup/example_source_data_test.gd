class_name MyExampleData extends ReactiveData


@export var property1 : String = "Hello world":
	set(value): property1 = value; notify(&"property1")

## WARNING For ReactiveData to function, you need to use a setter with :
# notify(&"property_name")


@export var property2 : int = 0:
	set(value): property2 = value; notify(&"property2")


@export var nested_data : MyExampleNestedData:
	set(value): nested_data = value; nested_data.parent = self; notify(&"nested_data")

## WARNING For propagation to work you need to have this line in the setter :
# property.parent = self


@export var array : Array :
	set(value): array = value; notify(&"array")

## WARNING ReactiveData DOESN'T support array.append() or any changes made from -
## - built-in Array functions yet ! Use instead :
# data.inventory.append(value); data.notify(&"inventory");
## Or :
# data = data.append(value)


## Example of a nested ReactiveData
class MyExampleNestedData extends ReactiveData:
	
	@export var property3 : float = 1.5:
		set(value): property3 = value; notify(&"property3")
	
	# Since we used "property.parent = self", notify will propagate up
	
	@export var property4 : int = 2:
		set(value): property3 = value; notify(&"property3", self, false)
	
	# This will not propagate up
