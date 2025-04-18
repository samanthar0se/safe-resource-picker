# Safe Resource Picker for Godot 4.4+

If you've ever written `@export var scene: PackedScene` or `@export var item: CustomResource` in your resource or node to store data, then you're benefitting from the type safety of the Godot Inspector ensuring that only `PackedScene` or `CustomResource` values can be stored in your property. However, now your resource or node contains that entire resource, too, and whenever your resource or node loads, so does that resource!

It's much more performant to write `@export var scene_path: String` and then use `var scene: PackedScene = load(scene_path)` later, but now the Inspector just shows a text field for that property, and *anything* can go in there!

With the **Safe Resource Picker**, you can write `@export_custom(SRP_HINT.RESOURCE_PATH, "PackedScene") var scene_path: String` and get the performance benefits of only storing a string with the Inspector interface of selecting a resource!

# Usage

## Supported Versions

To ensure that data isn't corrupted when moving files, Resource UIDs are stored and used by this plugin. As full UID support wasn't available until 4.4, this plugin may not work with some resource types in earlier versions of Godot. As UIDs did not exist at all in Godot 3, this plugin will not work at all with Godot 3.

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

Arrays don't work yet. You may need to manually save resources when making changes to safe resource properties.
