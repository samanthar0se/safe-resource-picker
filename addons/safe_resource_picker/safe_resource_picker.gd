@tool
class_name SafeResourcePickerInspectorPlugin extends EditorInspectorPlugin

const _ARRAY_SCENE := preload("uid://cnhv2yvr3dka0")

func _can_handle(_object: Object) -> bool:
	return true

func _parse_property(object: Object, type: Variant.Type, name: String, hint_type: PropertyHint, hint_string: String, usage_flags: int, wide: bool) -> bool:
	if hint_type != SRP_HINT.RESOURCE_PATH:
		return false
	if type == TYPE_STRING:
		var prop := SafeResourcePickerEditorProperty.new(hint_string)
		add_property_editor(name, prop)
		return true
	elif type == TYPE_ARRAY || type == TYPE_PACKED_STRING_ARRAY:
		var prop: ResourceArrayEditor = _ARRAY_SCENE.instantiate()
		prop.initialize(name, hint_string)
		add_property_editor(name, prop)
		#add_custom_control(prop)
		return true
	elif type == TYPE_DICTIONARY:
		printerr("SafeResourcePicker - %s: Dictionaries of resources aren't supported yet :(" % name)
		return false
	else:
		printerr("SafeResourcePicker - %s: Unrecognized type %s" % [name, type])
		return false
