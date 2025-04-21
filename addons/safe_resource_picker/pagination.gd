@tool
class_name Pagination extends HBoxContainer

var current_page := 1
var last_page := 1
var num_items := 0
var items_per_page := 5:
	set(value):
		items_per_page = value
		# TODO: update everything

@onready var _first_page: Button = %FirstPage
@onready var _previous_page: Button = %PreviousPage
@onready var _page_number: LineEdit = %PageNumber
@onready var _max_page_label: Label = %MaxPageLabel
@onready var _next_page: Button = %NextPage
@onready var _last_page: Button = %LastPage

func _ready() -> void:
	_first_page.icon = get_theme_icon(&"PageFirst", &"EditorIcons")
	_previous_page.icon = get_theme_icon(&"PagePrevious", &"EditorIcons")
	_next_page.icon = get_theme_icon(&"PageNext", &"EditorIcons")
	_last_page.icon = get_theme_icon(&"PageLast", &"EditorIcons")
	_update_pagination()

func _update_pagination() -> void:
	if !is_node_ready():
		return
	_page_number.text = str(current_page)
	_max_page_label.text = "/%d" % last_page
	_first_page.disabled = current_page == 1
	_previous_page.disabled = current_page == 1
	_next_page.disabled = current_page == last_page
	_last_page.disabled = current_page == last_page
	visible = last_page > 1
