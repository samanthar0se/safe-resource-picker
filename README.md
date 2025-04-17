# Safe Resource Picker for Godot 4

If you've ever written `@export var scene: PackedScene` or `@export var item: CustomResource` in your resource or node to store data, then you're benefitting from the type safety of the Godot Inspector ensuring that only `PackedScene` or `CustomResource` values can be stored in your property. However, now your resource or node contains that entire resource, too, and whenever your resource or node loads, so does that resource!

It's much more performant to write `@export var scene_path: String` and then use `var scene: PackedScene = load(scene_path)` later, but now the Inspector just shows a text field for that property, and *anything* can go in there!

With the **Safe Resource Picker**, you can write `@export_custom(SRP_HINT.RESOURCE_PATH, "PackedScene") var scene_path: String` and get the performance benefits of only storing a string with the Inspector interface of selecting a resource!

# Usage

## Supported Versions

Tested on Godot v4.4.1, but it should work in Godot v4.0 and higher, as it doesn't use any newer GDScript features like typed arrays. If you use a version prior to v4.4, you can probably delete the `.gd.uid` files.

## Installation

Download from the Godot Asset Library or GitHub and put the `safe_resource_picker` directory in your project's `res://addons` directory. Go to your Project Settings and enable the **Safe Resource Picker** plugin.

## Usage

Anywhere you want to store a Resource path, use `@export_custom(SRP_HINT.RESOURCE_PATH, "ResourceType")`, like so:

```GDScript
@export_custom(SRP_HINT.RESOURCE_PATH, "PackedScene") var scene_path: String

func get_scene() -> PackedScene:
    return load(scene_path)
```

# Limitations

Arrays don't work yet.