extends StaticBody3D

func _ready() -> void:
	# Traffic cone: orange conical marker
	var height := 0.7
	var top_radius := 0.1
	var bottom_radius := 0.2
	
	var mesh := CylinderMesh.new()
	mesh.top_radius := top_radius
	mesh.bottom_radius := bottom_radius
	mesh.height := height
	mesh.radial_segments := 6
	
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh := mesh
	mesh_instance.name := "TrafficCone"
	mesh_instance.position := Vector3(0, height * 0.5, 0)
	
	# Orange color
	var material := StandardMaterial3D.new()
	material.albedo_color := Color(0.9, 0.4, 0.1)
	material.roughness := 0.8
	mesh_instance.material_override := material
	
	add_child(mesh_instance)
	
	var collision := CollisionShape3D.new()
	var shape := CapsuleShape3D.new()
	shape.radius := bottom_radius
	shape.height := height
	collision.shape := shape
	collision.position := Vector3(0, height * 0.5, 0)
	add_child(collision)