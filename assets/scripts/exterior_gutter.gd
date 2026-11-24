extends StaticBody3D

func _ready() -> void:
	# Gutter: horizontal rain collection along roof edge
	var length := 5.0
	var gutter_depth := 0.2
	var gutter_height := 0.15
	
	var mesh := BoxMesh.new()
	mesh.size = Vector3(length, gutter_height, gutter_depth)
	
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = mesh
	mesh_instance.name = "GutterMesh"
	mesh_instance.position = Vector3(length * 0.5, gutter_height * 0.5, 0)
	add_child(mesh_instance)
	
	# Gutter brackets (every 1m)
	for i in range(5):
		var bracket_mesh := BoxMesh.new()
		bracket_mesh.size = Vector3(0.3, 0.1, 0.1)
		var bracket_instance = MeshInstance3D.new()
		bracket_instance.mesh = bracket_mesh
		bracket_instance.name = "GutterBracket%d" % i
		bracket_instance.position = Vector3(i * 1.0 - length * 0.5 + 0.5, 0.075, gutter_depth * 0.51)
		bracket_instance.material_override = preload("res://assets/materials/palettes.painted_metal_tres")
		add_child(bracket_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(length, gutter_height, gutter_depth)
	collision.shape = shape
	collision.position = Vector3(length * 0.5, gutter_height * 0.5, 0)
	add_child(collision)