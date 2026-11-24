extends StaticBody3D

func _ready() -> void:
	# Raised foundation with stumps/piers
	var base_mesh := BoxMesh.new()
	base_mesh.size = Vector3(4.0, 0.3, 4.0)
	
	var base_instance = MeshInstance3D.new()
	base_instance.mesh = base_mesh
	base_instance.name = "FoundationBase"
	base_instance.position = Vector3(0, 0.15, 0)
	add_child(base_instance)
	
	# Four corner piers
	for x in [-1, 1]:
		for z in [-1, 1]:
			var pier_mesh := BoxMesh.new()
			pier_mesh.size = Vector3(0.4, 1.5, 0.4)
			var pier_instance = MeshInstance3D.new()
			pier_instance.mesh = pier_mesh
			pier_instance.name = "FoundationPier%x_%z" % (x, z)
			pier_instance.position = Vector3(x * 1.8, 0.75, z * 1.8)
			pier_instance.material_override = preload("res://assets/materials/palettes/concrete_tres")
			add_child(pier_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(4.0, 0.3, 4.0)
	collision.shape = shape
	collision.position = Vector3(0, 0.15, 0)
	add_child(collision)