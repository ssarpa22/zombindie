extends StaticBody3D

func _ready() -> void:
	# Low pitched roof: 6m x 4m with slope
	var mesh := BoxMesh.new()
	mesh.size = Vector3(6.0, 0.3, 4.0)
	
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = mesh
	mesh_instance.name = "PitchedRoofMesh"
	mesh_instance.position = Vector3(0, 0.15, 0)
	add_child(mesh_instance)
	
	# Simple slope indication with two triangles (visual only)
	var left_section := BoxMesh.new()
	left_section.size = Vector3(3.0, 0.6, 4.0)
	var left_instance = MeshInstance3D.new()
	left_instance.mesh = left_section
	left_instance.name = "RoofLeftSection"
	left_instance.position = Vector3(-3.0, 0.45, 0)
	left_instance.rotation.z = PI / 8.0 # Tilt to suggest slope
	add_child(left_instance)
	
	var right_section := BoxMesh.new()
	right_section.size = Vector3(3.0, 0.6, 4.0)
	var right_instance = MeshInstance3D.new()
	right_instance.mesh = right_section
	right_instance.name = "RoofRightSection"
	right_instance.position = Vector3(3.0, 0.45, 0)
	right_instance.rotation.z = -PI / 8.0 # Tilt opposite direction
	add_child(right_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(6.0, 0.3, 4.0)
	collision.shape = shape
	collision.position = Vector3(0, 0.15, 0)
	add_child(collision)