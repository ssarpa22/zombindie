extends StaticBody3D

func _ready() -> void:
	# Long stairs: multiple flights, 2m total height
	var total_height := 2.0
	var step_depth := 0.3
	var step_width := 1.0
	var num_steps := int(total_height / 0.2)
	
	# Main stair structure
	var mesh := BoxMesh.new()
	mesh.size = Vector3(step_width, total_height, num_steps * step_depth)
	mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = mesh
	mesh_instance.name = "LongStairsMesh"
	mesh_instance.position = Vector3(0, total_height * 0.5, 0)
	add_child(mesh_instance)
	
	# Collision
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(step_width, total_height, num_steps * step_depth)
	collision.shape = shape
	collision.position = Vector3(0, total_height * 0.5, 0)
	add_child(collision)