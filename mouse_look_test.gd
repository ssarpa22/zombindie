extends Node

const PlayerScript = preload("res://player.gd")

func _ready() -> void:
	var player: CharacterBody3D = PlayerScript.new()
	var camera_pivot := Node3D.new()
	player.add_child(camera_pivot)
	player.set("camera_pivot", camera_pivot)
	var motion := InputEventMouseMotion.new()
	motion.relative = Vector2(50, 25)
	player.call("_apply_mouse_motion", motion)
	assert(absf(player.rotation.y) > 0.01, "Horizontal mouse motion did not rotate the player.")
	assert(absf(camera_pivot.rotation.x) > 0.01, "Vertical mouse motion did not rotate the camera.")

	var yaw_after_motion: float = player.rotation.y
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	player.call("_input", motion)
	assert(is_equal_approx(player.rotation.y, yaw_after_motion), "Visible-cursor motion should not rotate the camera.")
	player.free()
	print("MOUSE_LOOK_TEST_OK")
	get_tree().quit()
