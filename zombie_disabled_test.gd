extends Node

const GameSessionScript = preload("res://systems/game_session.gd")

func _ready() -> void:
	var session: Node = GameSessionScript.new()
	session.call("_spawn_zombie", Vector3.ZERO, 1.0)
	session.call("_trigger_world_event")
	assert(session.get_child_count() == 0)
	session.free()
	print("ZOMBIE_DISABLED_TEST_OK")
	get_tree().quit()
