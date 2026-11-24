extends StaticBody3D

func _ready() -> void:
	# Security door - heavy duty
	var mesh := BoxMesh.new()
	mesh.size = Vector3(0.9, 2.2, 0.15)
	
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = mesh
	mesh_instance.name = "SecurityDoorMesh"
	mesh_instance.position = Vector3(0, 1.1, 0)
	add_child(mesh_instance)
	
	# Vertical ribs
	for i in range(4):
		var rib_mesh := BoxMesh.new()
		rib_mesh.size = Vector3(0.08, 2.0, 0.15)
		var rib_instance = MeshInstance3D.new()
		rib_instance.mesh = rib_mesh
		rib_instance.name = "SecurityRib%d" % i
		rib_instance.position = Vector3(-0.35 + i * 0.22, 1.1, 0.03)
		rib_instance.material_override = preload("res://assets/materials/palettes/painted_metal_tres")
		add_child(rib_instance)