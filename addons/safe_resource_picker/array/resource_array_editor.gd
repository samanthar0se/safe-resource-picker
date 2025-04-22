@tool
class_name ResourceArrayEditor extends PanelContainer

signal on_data_changed(data: Array)

var data: Array = []:
	set(value):
		data = value
		if !is_node_ready():
			await ready
		_pagination.data = data
		_array_size.set_value_no_signal(data.size())

var _type := "Resource"
var _current_page: Array

@onready var _records: VBoxContainer = %Records
@onready var _add_element_button: Button = %AddElementButton
@onready var _array_size: SpinBox = %ArraySize
@onready var _pagination: Pagination = %Pagination
@onready var _uid_loader := ResourceUidLoader.new()

func _ready() -> void:
	add_child(_uid_loader)
	_add_element_button.icon = get_theme_icon(&"Add", &"EditorIcons")
	_add_element_button.pressed.connect(_add_row)
	_array_size.value_changed.connect(_on_array_size_manually_changed)
	_uid_loader.resource_loaded.connect(_on_resource_loaded)
	_pagination.page_changed.connect(_on_page_changed)

func initialize(type: String) -> void:
	_type = type

func _on_page_changed(start_idx: int, is_last_page: bool, current_page: Array) -> void:
	_current_page = current_page
	for r in _records.get_children():
		_records.remove_child(r)
		r.queue_free()
	for uid: String in current_page:
		_create_initial_row(start_idx)
		_uid_loader.load_resource(uid)
	_add_element_button.visible = is_last_page

func _on_resource_loaded(uid: String, resource: Resource) -> void:
	var idx := _current_page.find(uid)
	var row: ResourceRow = _records.get_child(idx)
	row.set_resource(resource)

func _on_array_size_manually_changed(new_amount: float) -> void:
	var curr_count := data.size()
	if curr_count < new_amount:
		for i in (new_amount - curr_count):
			data.append("")
	elif curr_count > new_amount:
		for i in (curr_count - new_amount):
			data.pop_back()
	on_data_changed.emit(data)
	_array_size.set_value_no_signal(curr_count)

func _add_row() -> void:
	var row := ResourceRow.new(data.size(), _type)
	_bind_row_and_add(row)
	data.append("")
	_on_row_changed(row.idx, null)

func _create_initial_row(start_idx: int) -> void:
	var row := ResourceRow.new(start_idx + _records.get_child_count(), _type)
	_bind_row_and_add(row)

func _bind_row_and_add(row: ResourceRow) -> void:
	row.resource_changed.connect(_on_row_changed)
	row.removed.connect(_on_row_removed)
	row.dragged.connect(_on_row_reordered)
	_records.add_child(row)

func _on_row_reordered(from: int, to: int) -> void:
	var temp: String = data[from]
	data[from] = data[to]
	data[to] = temp
	on_data_changed.emit(data)

func _on_row_changed(idx: int, resource: Resource) -> void:
	if resource == null:
		data[idx] = ""
	elif resource.resource_path == "":
		printerr(SRP_HINT.LOCAL_RESOURCE_ERROR_STRING)
		return
	else:
		data[idx] = ResourceUID.id_to_text(
			ResourceLoader.get_resource_uid(resource.resource_path)
		)
	on_data_changed.emit(data)
	_array_size.set_value_no_signal(data.size())

func _on_row_removed(idx: int, row: ResourceRow) -> void:
	data.remove_at(idx)
	_records.remove_child(row)
	_redraw_row_counts()

func _redraw_row_counts() -> void:
	var idx := 0
	for row: ResourceRow in _records.get_children():
		row.idx = idx
		idx += 1

class ResourceRow extends HBoxContainer:
	signal dragged(from: int, to: int)
	signal resource_changed(idx: int, resource: Resource)
	signal removed(idx: int, row: ResourceRow)

	var idx := 0:
		set(value):
			idx = value
			if !is_node_ready():
				await ready
			_label.text = str(idx)
			_reorder_button.idx = idx


	var _type: String
	var _reorder_button: ReorderButton
	@onready var _label := Label.new()
	@onready var _editor := EditorResourcePicker.new()

	func _init(index: int, t: String) -> void:
		idx = index
		_type = t

	func _ready() -> void:
		_reorder_button = ReorderButton.new()
		_reorder_button.idx = idx
		_reorder_button.dragged.connect(_on_dragged)
		add_child(_reorder_button)

		_label.size_flags_horizontal = Control.SIZE_EXPAND
		add_child(_label)

		_editor.base_type = _type
		_editor.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		_editor.edited_resource = null
		_editor.custom_minimum_size.x = 100.0
		_editor.resource_changed.connect(func(new_resource: Resource) -> void:
			resource_changed.emit(idx, new_resource)
		)
		add_child(_editor)

		var trash_button := Button.new()
		trash_button.icon = get_theme_icon(&"Remove", &"EditorIcons")
		trash_button.pressed.connect(_remove_row)
		add_child(trash_button)

	func set_resource(r: Resource) -> void:
		_editor.edited_resource = r

	func _on_dragged(from: int, to: int) -> void:
		dragged.emit(from, to)

	func _remove_row() -> void:
		removed.emit(idx, self)
		queue_free()

class ReorderButton extends Button:
	signal dragged(from: int, to: int)

	var idx: int

	func _ready() -> void:
		icon = get_theme_icon(&"TripleBar", &"EditorIcons")
		mouse_default_cursor_shape = Control.CURSOR_DRAG

	func _get_drag_data(_at_position: Vector2) -> Variant:
		return idx

	func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
		return typeof(data) == TYPE_INT

	func _drop_data(_at_position: Vector2, data: Variant) -> void:
		dragged.emit(data, idx)
