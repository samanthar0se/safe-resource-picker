@tool
class_name ResourceArrayEditor extends VBoxContainer

var _type := "Resource"
var _count := 0:
	set(value):
		_count = value
		_prop_desc.text = "Array[%s] (%s %d)" % [_type, tr("Size"), _count]
		_array_size.value = _count

@onready var _records: VBoxContainer = %Records
@onready var _add_element_button: Button = %AddElementButton
@onready var _prop_name: Label = $HBoxContainer/PropName
@onready var _prop_desc: Button = $HBoxContainer/PropDesc
@onready var _array_size: SpinBox = %ArraySize
@onready var _pagination: Pagination = %Pagination

func _ready() -> void:
	_add_element_button.icon = get_theme_icon(&"Add", &"EditorIcons")
	_add_element_button.pressed.connect(_add_row)
	_array_size.value_changed.connect(_on_row_count_changed)

func initialize(prop: String, type: String) -> void:
	_type = type
	if !is_node_ready():
		await ready
	_prop_name.text = prop.capitalize()
	_count = _records.get_child_count()

func _on_row_count_changed(new_amount: float) -> void:
	var curr_count := _records.get_child_count()
	if curr_count < new_amount:
		for i in (new_amount - curr_count):
			_add_row()
	elif curr_count > new_amount:
		for i in (curr_count - new_amount):
			var child := _records.get_child(new_amount - 1)
			_records.remove_child(child)
			child.queue_free()
			_redraw_row_counts()
	_count = _records.get_child_count()
	_pagination.num_items = _count

func _add_row() -> void:
	var row := ResourceRow.new()
	row.idx = _records.get_child_count()
	row.type = _type
	row.removed.connect(_on_row_removed)
	_records.add_child(row)
	_count += 1

func _on_row_removed(row: ResourceRow) -> void:
	_records.remove_child(row)
	_count -= 1
	_redraw_row_counts()

func _redraw_row_counts() -> void:
	var idx := 0
	for row: ResourceRow in _records.get_children():
		row.idx = idx
		idx += 1

class ResourceRow extends HBoxContainer:
	signal removed(row: ResourceRow)

	var idx := 0:
		set(value):
			idx = value
			if !is_node_ready():
				await ready
			_label.text = str(idx)

	var type: String

	@onready var _label := Label.new()

	func _ready() -> void:
		var reorder_button := Button.new()
		reorder_button.icon = get_theme_icon(&"TripleBar", &"EditorIcons")
		add_child(reorder_button)

		_label.size_flags_horizontal = Control.SIZE_EXPAND
		add_child(_label)

		var editor_resource := EditorResourcePicker.new()
		editor_resource.base_type = type
		editor_resource.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		editor_resource.edited_resource = null
		editor_resource.custom_minimum_size.x = 100.0
		add_child(editor_resource)

		var trash_button := Button.new()
		trash_button.icon = get_theme_icon(&"Remove", &"EditorIcons")
		trash_button.pressed.connect(_remove_row)
		add_child(trash_button)

	func _remove_row() -> void:
		removed.emit(self)
		queue_free()
