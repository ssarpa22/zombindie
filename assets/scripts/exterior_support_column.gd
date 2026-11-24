extends StaticBody3D

func _ready() -> void:
	# Support column: structural column for porches, awnings, etc.
	var height := 3.0
	var diameter := 0.3
	
	var mesh := BoxMesh.new()
	mesh.size = Vector3(diameter, height, diameter)
	
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = mesh
	mesh_instance.name = "SupportColumnMesh"
	mesh_instance.position = Vector3(0, height * 0.5, 0)
	add_child(mesh_instance)
	
	# Capital/base at top
	var cap_mesh := BoxMesh.new()
	cap_mesh.size = Vector3(diameter * 1.5, 0.2, diameter * 1.5)
	var cap_instance = MeshInstance3D.new()
	cap_instance.mesh = cap_mesh
	cap_instance.name = "ColumnCapital"
	cap_instance.position = Vector3(0, height - 0.1, 0)
	cap_instance.material_override = preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(cap_instance)
	
	# Base at bottom
	var base_mesh := BoxMesh.new()
	base_mesh.size = Vector3(diameter * 1.5, 0.2, diameter * 1.5)
	var base_instance = MeshInstance3D.new()
	base_instance.mesh = base_mesh
	base_instance.name = "ColumnBase"
	base_instance.position = Vector3(0, 0.1, 0)
	base_instance.material_override = preload("res://assets/materials/palettes.concrete_tres")
	add_child(base_instance)
	
	# Vertical rib detail
	for i in range(4):
		var rib_mesh := BoxMesh.new()
		rib_mesh.size = Vector3(diameter * 0.1, height, diameter)
		var rib_instance = MeshInstance3D.new()
		rib_instance.mesh = rib_mesh
		rib_instance.name = "ColumnRib%d" % i
		rib_instance.position = Vector3(0, height * 0.5, 0)
		rib_instance.rotation.y = i * PI / 2.0
		rib_instance.material_override = preload("res://assets/materials/palettes.painted_metal_tres")
		add_child(rib_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(diameter, height, diameter)
	collision.shape = shape
	collision.position = Vector3(0, height * 0.5, 0)
	add_child(collision)