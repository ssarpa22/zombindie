extends StaticBody3D

func _ready() -> void:
	# Lintel: horizontal structural element over openings (doors, windows)
	var length := 1.0
	var height := 0.2
	var depth := 0.2
	
	var mesh := BoxMesh.new()
	mesh.size = Vector3(length, height, depth)
	
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = mesh
	mesh_instance.name = "LintelMesh"
	mesh_instance.position = Vector3(length * 0.5, height * 0.5, 0)
	add_child(mesh_instance)
	
	# Decorative brackets under lintel
	for side in [-1, 1]:
		var bracket_mesh := BoxMesh.new()
		bracket_mesh.size = Vector3(0.2, 0.1, 0.1)
		var bracket_instance = MeshInstance3D.new()
		bracket_instance.mesh = bracket_mesh
		bracket_instance.name = "LintelBracket%d" % (side == -1 and 1 or 2)
		bracket_instance.position = Vector3(side * length * 0.5 + 0.1, height * 0.25, depth * 0.51)
		bracket_instance.material_override = preload("res://assets/materials/palettes.painted_metal_tres")
		add_child(bracket_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(length, height, depth)
	collision.shape = shape
	collision.position = Vector3(length * 0.5, height * 0.5, 0)
	add_child(collision)