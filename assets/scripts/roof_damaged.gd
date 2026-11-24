extends StaticBody3D

func _ready() -> void:
	# Damaged roof section - partially collapsed
	var mesh := BoxMesh.new()
	mesh.size = Vector3(4.0, 0.3, 4.0)
	
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = mesh
	mesh_instance.name = "DamagedRoofMesh"
	mesh_instance.position = Vector3(0, 0.15, 0)
	add_child(mesh_instance)
	
	# Visual damage - missing section, debris
	var debris_mesh := BoxMesh.new()
	debris_mesh.size = Vector3(1.0, 0.3, 1.0)
	debris_mesh.position = Vector3(-1.0, 0.15, -1.0)
	var debris_instance = MeshInstance3D.new()
	debris_instance.mesh = debris_mesh
	debris_instance.name = "RoofDebris1"
	debris_instance.material_override = preload("res://assets/materials/palettes/concrete_tres")
	add_child(debris_instance)
	
	var debris2_mesh := BoxMesh.new()
	debris2_mesh.size = Vector3(1.0, 0.3, 1.0)
	debris2_mesh.position = Vector3(1.0, 0.15, 1.0)
	var debris2_instance = MeshInstance3D.new()
	debris2_instance.mesh = debris2_mesh
	debris2_instance.name = "RoofDebris2"
	debris2_instance.material_override = preload("res://assets/materials/palettes/concrete_tres")
	add_child(debris2_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(4.0, 0.3, 4.0)
	collision.shape = shape
	collision.position = Vector3(0, 0.15, 0)
	add_child(collision)