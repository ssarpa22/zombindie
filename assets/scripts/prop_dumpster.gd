extends StaticBody3D

func _ready() -> void:
	# Dumpster/waste container: large industrial trash container
	var height := 1.2
	var depth := 0.8
	var width := 1.5
	
	var mesh := BoxMesh.new()
	mesh.size := Vector3(width, height, depth)
	
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh := mesh
	mesh_instance.name := "DumpsterBody"
	mesh_instance.position := Vector3(width * 0.5, height * 0.5, 0)
	mesh_instance.material_override := preload("res://assets/materials/palettes.asphalt_tres")
	add_child(mesh_instance)
	
	# Dumpster lid
	var lid_mesh := BoxMesh.new()
	lid_mesh.size := Vector3(width * 1.1, 0.05, depth * 1.1)
	
	var lid_instance := MeshInstance3D.new()
	lid_instance.mesh := lid_mesh
	lid_instance.name := "DumpsterLid"
	lid_instance.position := Vector3(width * 0.5, height + 0.025, 0)
	lid_instance.material_override := preload("res://assets/materials/palettes.metal_tres")
	add_child(lid_instance)
	
	# Rolling wheels (two axles)
	for axle in [0, 1]:
		for side in [-1, 1]:
			var wheel_mesh := CylinderMesh.new()
			wheel_mesh.top_radius := 0.15
			wheel_mesh.bottom_radius := 0.15
			wheel_mesh.height := 0.2
			wheel_mesh.radial_segments := 8
			
			var wheel_instance := MeshInstance3D.new()
			wheel_instance.mesh := wheel_mesh
			wheel_instance.name := "DumpsterWheel_%d_%d" % (axle, side)
			wheel_instance.position := Vector3(
				side * width * 0.4,
				height * 0.1 - 0.1,
				axle * depth * 0.4 - depth * 0.2
			)
			wheel_instance.rotation.z := PI / 2.0
			wheel_instance.material_override := preload("res://assets/materials/palettes.metal_tres")
			add_child(wheel_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size := Vector3(width, height, depth)
	collision.shape := shape
	collision.position := Vector3(width * 0.5, height * 0.5, 0)
	add_child(collision)