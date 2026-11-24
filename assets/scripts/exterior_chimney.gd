extends StaticBody3D

func _ready() -> void:
	# Chimney: tall, thin structure
	var height := 6.0
	var width := 0.5
	
	var mesh := BoxMesh.new()
	mesh.size = Vector3(width, height, width)
	
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = mesh
	mesh_instance.name = "ChimneyMesh"
	mesh_instance.position = Vector3(0, height * 0.5, 0)
	add_child(mesh_instance)
	
	# Chimney caps/bricks at top
	var cap_mesh := BoxMesh.new()
	cap_mesh.size = Vector3(width * 1.2, 0.3, width * 1.2)
	var cap_instance = MeshInstance3D.new()
	cap_instance.mesh = cap_mesh
	cap_instance.name = "ChimneyCap"
	cap_instance.position = Vector3(0, height - 0.15, 0)
	cap_instance.material_override = preload("res://assets/materials/palettes.concrete_tres")
	add_child(cap_instance)
	
	# Brick pattern visual
	for i in range(6):
		var brick_mesh := BoxMesh.new()
		brick_mesh.size = Vector3(0.4, 0.4, 0.2)
		var brick_instance = MeshInstance3D.new()
		brick_instance.mesh = brick_mesh
		brick_instance.name = "ChimneyBrick%d" % i
		brick_instance.position = Vector3(0, 0.4 * i + 0.2, -width * 0.6)
		brick_instance.material_override = preload("res://assets/materials/palettes.brick_tres")
		add_child(brick_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(width, height, width)
	collision.shape = shape
	collision.position = Vector3(0, height * 0.5, 0)
	add_child(collision)