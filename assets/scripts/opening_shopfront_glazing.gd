extends StaticBody3D

func _ready() -> void:
	# Shopfront glazing - large glass area for a storefront
	var mesh := BoxMesh.new()
	mesh.size = Vector3(2.0, 2.5, 0.05)
	
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = mesh
	mesh_instance.name = "ShopfrontGlazingMesh"
	mesh_instance.position = Vector3(0, 1.25, 0)
	add_child(mesh_instance)
	
	# Glass panes
	for i in range(4):
		for j in range(2):
			var pane_mesh := BoxMesh.new()
			pane_mesh.size = Vector3(0.45, 0.55, 0.02)
			var pane_instance = MeshInstance3D.new()
			pane_instance.mesh = pane_mesh
			pane_instance.name = "ShopPane%d_%d" % (i, j)
			pane_instance.position = Vector3(-0.9 + i * 0.9, -0.3 + j * 0.6, 0.275)
			pane_instance.material_override = preload("res://assets/materials/palettes/glass_tres")
			add_child(pane_instance)