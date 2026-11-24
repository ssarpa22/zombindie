extends StaticBody3D

func _ready() -> void:
	# Tiled interior floor: 4m x 4m with tile pattern
	var mesh := BoxMesh.new()
	mesh.size = Vector3(4.0, 0.1, 4.0)
	
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = mesh
	mesh_instance.name = "TiledFloorMesh"
	mesh_instance.position = Vector3(0, 0.05, 0)
	add_child(mesh_instance)
	
	# Tile grid lines (visual)
	for i in range(5):
		var line_mesh := BoxMesh.new()
		line_mesh.size = Vector3(0.1, 0.1, 4.0)
		var line_instance = MeshInstance3D.new()
		line_instance.mesh = line_mesh
		line_instance.name = "TileLine%d" % i
		line_instance.position = Vector3(-1.95 + i * 0.5, 0.05, 0)
		line_instance.material_override = preload("res://assets/materials/palettes/tile_tres")
		add_child(line_instance)
	
	for i in range(5):
		var line_mesh := BoxMesh.new()
		line_mesh.size = Vector3(4.0, 0.1, 0.1)
		var line_instance = MeshInstance3D.new()
		line_instance.mesh = line_mesh
		line_instance.name = "TileLine%d" % (i + 10)
		line_instance.position = Vector3(0, 0.05, -1.95 + i * 0.5)
		line_instance.material_override = preload("res://assets/materials/palettes/tile_tres")
		add_child(line_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(4.0, 0.1, 4.0)
	collision.shape = shape
	collision.position = Vector3(0, 0.05, 0)
	add_child(collision)