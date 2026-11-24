extends StaticBody3D

func _ready() -> void:
	# Flat roof: 4m x 4m, 0.2m thick
	var mesh := BoxMesh.new()
	mesh.size = Vector3(4.0, 0.2, 4.0)
	
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = mesh
	mesh_instance.name = "FlatRoofMesh"
	mesh_instance.position = Vector3(0, 0.1, 0) # Pivot at bottom center
	add_child(mesh_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(4.0, 0.2, 4.0)
	collision.shape = shape
	collision.position = Vector3(0, 0.1, 0)
	add_child(collision)