extends SceneTree

func _initialize() -> void:
	print("SMOKE_RUNNER_STARTED")
	var packed: PackedScene = load("res://weather_smoke_test.tscn")
	var scene: Node = packed.instantiate()
	root.add_child(scene)
