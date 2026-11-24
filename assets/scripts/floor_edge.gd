extends StaticBody3D

func _ready() -> void:
	# Floor edge: transition piece between rooms or floor levels
	var mesh := BoxMesh.new()
	mesh.size = Vector3(2.0, 0.2, 0.3)
	
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = mesh
	mesh_instance.name = "FloorEdgeMesh"
	mesh_instance.position = Vector3(0, 0.1, 0)
	add_child(mesh_instance)
	
	# Transition ramp section
	var ramp_mesh := BoxMesh.new()
	ramp_mesh.size = Vector3(2.0, 0.1, 0.5)
	var ramp_instance = MeshInstance3D.new()
	ramp_instance.mesh = ramp_mesh
	ramp_instance.name = "FloorEdgeRamp"
	ramp_instance.position = Vector3(0, 0.05, 0)
	ramp_instance.rotation.z = PI / 4.0
	add_child(ramp_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(2.0, 0.2, 0.5)
	collision.shape = shape
	collision.position = Vector3(0, 0.1, 0)
	add_child(collision)