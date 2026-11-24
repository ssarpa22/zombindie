extends StaticBody3D

func _ready() -> void:
	# Garage roller door
	var mesh := BoxMesh.new()
	mesh.size = Vector3(3.0, 3.0, 0.5)
	
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = mesh
	mesh_instance.name = "GarageDoorMesh"
	mesh_instance.position = Vector3(0, 1.5, 0)
	add_child(mesh_instance)
	
	# Roller door slats
	for i in range(6):
		var slat_mesh := BoxMesh.new()
		slat_mesh.size = Vector3(3.0, 0.4, 0.5)
		var slat_instance = MeshInstance3D.new()
		slat_instance.mesh = slat_mesh
		slat_instance.name = "DoorSlat%d" % i
		slat_instance.position = Vector3(0, 1.5 - i * 0.5, 0)
		slat_instance.material_override = preload("res://assets/materials/palettes/asphalt_tres")
		add_child(slat_instance)