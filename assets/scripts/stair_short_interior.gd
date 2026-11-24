extends StaticBody3D

func _ready() -> void:
	# Short interior stairs: 2 steps, each 0.2m high, 0.3m deep
	var total_height := 0.6  # 3 steps * 0.2m
	var step_depth := 0.3
	var step_width := 1.0
	
	# Stringers and steps
	var mesh := BoxMesh.new()
	mesh.size = Vector3(step_width, total_height, step_depth * 3)
	mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = mesh
	mesh_instance.name = "ShortStairsMesh"
	mesh_instance.position = Vector3(0, total_height * 0.5, 0)
	add_child(mesh_instance)
	
	# Collision
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(step_width, total_height, step_depth * 3)
	collision.shape = shape
	collision.position = Vector3(0, total_height * 0.5, 0)
	add_child(collision)