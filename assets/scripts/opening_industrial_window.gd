extends StaticBody3D

func _ready() -> void:
	# Industrial window opening - wider, multiple panes
	var mesh := BoxMesh.new()
	mesh.size = Vector3(1.5, 1.8, 0.05)
	
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = mesh
	mesh_instance.name = "IndustrialWindowMesh"
	mesh_instance.position = Vector3(0, 0.9, 0)
	add_child(mesh_instance)
	
	# Multiple window panes
	for i in range(3):
		var pane_mesh := BoxMesh.new()
		pane_mesh.size = Vector3(0.45, 1.6, 0.02)
		var pane_instance = MeshInstance3D.new()
		pane_instance.mesh = pane_mesh
		pane_instance.name = "IndustrialPane%d" % i
		pane_instance.position = Vector3(-0.35 + i * 0.5, 0.8, 0.425)
		pane_instance.material_override = preload("res://assets/materials/palettes/glass_tres")
		add_child(pane_instance)