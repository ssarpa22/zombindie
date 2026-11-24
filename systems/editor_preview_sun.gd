@tool
extends DirectionalLight3D

func _enter_tree() -> void:
	visible = Engine.is_editor_hint()
