# DataBindSystem

A lightweight data binding system for Godot that automatically connects callbacks to `ReactiveData` properties.

The goal of this addon is to make UI and gameplay code react automatically to data changes while keeping the code simple and avoiding manual signal management.

To install the add-on, place **"data_binding_system"** folder into your add-on folder.

2 examples are included, one basic set-up on how to use the add-on, and one concrete use case example project.

---

# Features

- Property binding
- Automatic reconnection when data is replaced
- Automatic disconnection when data becomes `null`
- Built-in save/load helpers for `ReactiveData`
- Lightweight API
- No nodes required (RefCounted)

---

# Why?

Without DataBindSystem, replacing a data object usually requires reconnecting every signal manually.

```gdscript
player_data.disconnect(...)
player_data = new_player_data
player_data.connect(...)
update_ui()
```

With DataBindSystem:

```gdscript
player_data = new_player_data
DBS.notify_source_data_changed(&"player_data")
```

All bindings are automatically updated.

---

# Basic Usage

## 1. Create a DataBindSystem

```gdscript
var DBS := DataBindSystem.new(self)
```

---

## 2. Declare your ReactiveData

```gdscript
var player_data : PlayerData:
    set(value):
        player_data = value
        DBS.notify_source_data_changed(&"player_data")
```

---

## 3. Bind properties

```gdscript
func _ready():

    DBS.bind_source(
        &"player_data",
        [&"health", &"mana"],
        update_ui
    )
```

Whenever `health` or `mana` changes, or when player_data is replaced or set to null:

```gdscript
func update_ui():
	if player_data:
		health_label.text = "Health : %s. Mana : %s" % [player_data.health, player_data.mana]
	else:
		health_label.text = "null"
```

---

# Binding API

## Bind

```gdscript
DBS.bind_source(
    source_data_name,
    watched_properties,
    callback,
    call_immediately
)
```

### Parameters

| Parameter | Description |
|------------|-------------|
| source_data_name | Name of the ReactiveData property |
| watched_properties | List of properties to watch |
| callback | Function called when one of the properties changes |
| call_immediately | Calls the callback immediately after binding |

---

## Unbind

```gdscript
DBS.unbind(...)
```

Removes an existing binding.

---

## Notify data replacement

Whenever the ReactiveData object is replaced:

```gdscript
DBS.notify_source_data_changed(&"player_data")
```

This automatically:

- disconnects old signals
- reconnects new signals
- optionally refreshes the UI

---

# Saving & Loading

## Load

```gdscript
DBS.load_data(
    &"player_data",
    "res://resources/player_data.tres"
)
```

You can also specify a custom save location.

```gdscript
DBS.load_data(
    &"player_data",
    "res://resources/player_data.tres",
    "user://save/player_data.tres"
)
```

This is useful when loading a definition data, you can set a custom save path so the definition value won't be overwrited 

---

## Save

Save using the resource's path:

```gdscript
DBS.save_data(&"player_data")
```

Or save somewhere else:

```gdscript
DBS.save_data(
    &"player_data",
    "user://save/player_data.tres"
)
```

---

# How It Works

Each `DataBindSystem` belongs to one object.

```
Player
│
├── DataBindSystem
│
├── player_data
├── inventory_data
└── quest_data
```

Bindings are registered using the property name instead of directly referencing the resource.

When a resource is replaced, DataBindSystem automatically reconnects every binding associated with that property.

---

# Requirements

DataBindSystem works with `ReactiveData`.

Your ReactiveData implementation must notify property changes so DataBindSystem can react to them.


```gdscript
class_name PlayerData extends ReactiveData

@export var health : int = 50:
	set(value): health = value; notify(&"health")
```

---

# Roadmap

Planned features include:

- Visual debug tool
- Deferred bind or deferred unbind

---

# License
MIT License

Copyright (c) 2026 Laby-exe

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
