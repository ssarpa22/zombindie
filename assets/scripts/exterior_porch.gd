extends StaticBody3D

func _ready() -> void:
	# Porch: entrance area with roof and floor
	var floor_width := 3.0
	var floor_depth := 2.0
	var roof_height := 0.5
	
	# Porch floor
	var floor_mesh := BoxMesh.new()
	floor_mesh.size = Vector3(floor_width, 0.1, floor_depth)
	var floor_instance = MeshInstance3D.new()
	floor_instance.mesh = floor_mesh
	floor_instance.name = "PorchFloor"
	floor_instance.position = Vector3(0, 0.05, 0)
	floor_instance.material_override = preload("res://assets/materials/palettes.tile_tres")
	add_child(floor_instance)
	
	# Roof over porch
	var roof_mesh := BoxMesh.new()
	roof_mesh.size = Vector3(floor_width + 1.0, roof_height, floor_depth + 1.0)
	var roof_instance = MeshInstance3D.new()
	roof_instance.mesh = roof_mesh
	roof_instance.name = "PorchRoof"
	roof_instance.position = Vector3(0, roof_height * 0.5 + 0.2, 0)
	roof_instance.material_override = preload("res://assets/materials/palettes.asphalt_tres")
	add_child(roof_instance)
	
	# Support columns
	for side in [-1, 1]:
		var col_mesh := BoxMesh.new()
		col_mesh.size = Vector3(0.3, 1.5, 0.3)
		var col_instance = MeshInstance3D.new()
		col_instance.mesh = col_mesh
		col_instance.name = "PorchColumn%d" % (side == -1 and 1 or 2)
		col_instance.position = Vector3(side * 1.2, 0.75, -floor_depth * 0.5 + 0.2)
		col_instance.material_override = preload("res://assets/materials/palettes.painted_metal_tres")
		add_child(col_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(floor_width, 0.3, floor_depth)
	collision.shape = shape
	collision.position = Vector3(0, 0.15, 0)
	add_child(collision)