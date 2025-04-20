@tool
class_name ResourceArrayEditor extends VBoxContainer

var _type := "Resource"

@onready var _records: VBoxContainer = %Records
@onready var _add_element_button: Button = %AddElementButton
@onready var _prop_name: Label = $HBoxContainer/PropName
@onready var _prop_desc: Button = $HBoxContainer/PropDesc

func _ready() -> void:
	_add_element_button.pressed.connect(_add_row)

func initialize(prop: String, type: String) -> void:
	_type = type
	if !is_node_ready():
		await ready
	_prop_name.text = prop.capitalize()
	_prop_desc.text = "Array[%s] (size %d)" % [type, _records.get_child_count()]

func _add_row() -> void:
	var row := HBoxContainer.new()
	var reorder_button := Button.new()
	reorder_button.icon = get_theme_icon(&"TripleBar", &"EditorIcons")
	var label := Label.new()
	label.text = "%d" % _records.get_child_count()
	label.size_flags_horizontal = Control.SIZE_EXPAND
	var c := MarginContainer.new()
	c.size_flags_horizontal = Control.SIZE_EXPAND
	var editor_resource := EditorResourcePicker.new()
	editor_resource.base_type = _type
	editor_resource.size_flags_horizontal = Control.SIZE_EXPAND
	editor_resource.edited_resource = null
	var trash_button := Button.new()
	trash_button.icon = get_theme_icon(&"Remove", &"EditorIcons")
	row.add_child(reorder_button)
	row.add_child(label)
	c.add_child(editor_resource)
	row.add_child(c)
	row.add_child(trash_button)
	_records.add_child(row)
