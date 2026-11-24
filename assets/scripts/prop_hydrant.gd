extends StaticBody3D

func _ready() -> void:
	# Fire hydrant: municipal water access
	var total_height := 1.0
	var barrel_height := 0.7
	var barrel_width := 0.3
	
	# Barrel (main body)
	var barrel_mesh := CylinderMesh.new()
	barrel_mesh.top_radius := barrel_width
	barrel_mesh.bottom_radius := barrel_width
	barrel_mesh.height := barrel_height
	barrel_mesh.radial_segments := 8
	
	var barrel_instance := MeshInstance3D.new()
	barrel_instance.mesh := barrel_mesh
	barrel_instance.name := "HydrantBarrel"
	barrel_instance.position := Vector3(0, barrel_height * 0.5, 0)
	barrel_instance.material_override := preload("res://assets/materials/palettes.asphalt_tres")
	add_child(barrel_instance)
	
	# Barrel bands (visual)
	for i in range(3):
		var band_mesh := CylinderMesh.new()
		band_mesh.top_radius := barrel_width + 0.02
		band_mesh.bottom_radius := barrel_width + 0.02
		band_mesh.height := 0.02
		band_mesh.radial_segments := 8
		
		var band_instance := MeshInstance3D.new()
		band_instance.mesh := band_mesh
		band_instance.name := "HydrantBand%d" % i
		band_instance.position := Vector3(0, barrel_height * 0.33 * (i + 1), 0)
		band_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
		add_child(band_instance)
	
	# Post
	var post_mesh := CylinderMesh.new()
	post_mesh.top_radius := 0.1
	post_mesh.bottom_radius := 0.1
	post_mesh.height := total_height - barrel_height
	post_mesh.radial_segments := 6
	
	var post_instance := MeshInstance3D.new()
	post_instance.mesh := post_mesh
	post_instance.name := "HydrantPost"
	post_instance.position := Vector3(0, barrel_height + (total_height - barrel_height) * 0.5, 0)
	post_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(post_instance)
	
	# Valve mechanism at bottom
	var valve_mesh := BoxMesh.new()
	valve_mesh.size := Vector3(0.15, 0.1, 0.1)
	
	var valve_instance := MeshInstance3D.new()
	valve_instance.mesh := valve_mesh
	valve_instance.name := "HydrantValve"
	valve_instance.position := Vector3(0, 0.05, 0)
	valve_instance.material_override := preload("res://assets/materials/palettes.metal_tres")
	add_child(valve_instance)
	
	# Hose connection nub
	var hose_mesh := BoxMesh.new()
	hose_mesh.size := Vector3(0.08, 0.1, 0.08)
	
	var hose_instance := MeshInstance3D.new()
	hose_instance.mesh := hose_mesh
	hose_instance.name := "HydrantConnection"
	hose_instance.position := Vector3(0, barrel_height + 0.15, 0)
	hose_instance.material_override := preload("res://assets/materials/palettes.metal_tres")
	add_child(hose_instance)
	
	var collision := CollisionShape3D.new()
	var shape := CapsuleShape3D.new()
	shape.radius := barrel_width
	shape.height := total_height
	collision.shape := shape
	collision.position := Vector3(0, total_height * 0.5, 0)
	add_child(collision)