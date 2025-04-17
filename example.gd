extends Node3D

var _s: PackedScene
var _nr: NormalResource
var _sr: SafeResource
var _loaded_node: Node3D

func _on_load_scene_button_pressed() -> void:
	var s := Time.get_ticks_msec()
	_s = load("res://orb.glb")
	print("loaded in %dms" % (Time.get_ticks_msec() - s))

func _on_add_scene_button_pressed() -> void:
	if _s:
		var s := Time.get_ticks_msec()
		_loaded_node = _s.instantiate()
		add_child(_loaded_node)
		print("added in %dms" % (Time.get_ticks_msec() - s))
	else:
		printerr("Click the Load Scene button first.")


func _on_load_normal_button_pressed() -> void:
	var s := Time.get_ticks_msec()
	_nr = load("res://res_norm.tres")
	print("loaded in %dms" % (Time.get_ticks_msec() - s))

func _on_add_normal_button_pressed() -> void:
	if _nr:
		var s := Time.get_ticks_msec()
		_loaded_node = _nr.scene.instantiate()
		add_child(_loaded_node)
		print("added in %dms" % (Time.get_ticks_msec() - s))
	else:
		printerr("Click the Load Normal Resource button first.")

func _on_load_safe_button_pressed() -> void:
	var s := Time.get_ticks_msec()
	_sr = load("res://res_safe.tres")
	print("loaded in %dms" % (Time.get_ticks_msec() - s))

func _on_add_safe_button_pressed() -> void:
	if _sr:
		var s := Time.get_ticks_msec()
		_loaded_node = load(_sr.scene_path).instantiate()
		add_child(_loaded_node)
		print("added in %dms" % (Time.get_ticks_msec() - s))
	else:
		printerr("Click the Load Safe Resource button first.")

func _on_button_pressed() -> void:
	_loaded_node.queue_free()
	_loaded_node = null
	_s = null
	_nr = null
	_sr = null
