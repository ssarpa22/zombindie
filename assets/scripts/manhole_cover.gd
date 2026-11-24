extends StaticBody3D

func _ready() -> void:
	# Manhole cover: street access cover
	var cover_diameter := 0.6
	var cover_thickness := 0.05
	
	# Manhole cover
	var cover_mesh := CylinderMesh.new()
	cover_mesh.top_radius := cover_diameter * 0.5
	cover_mesh.bottom_radius := cover_diameter * 0.5
	cover_mesh.height := cover_thickness
	cover_mesh.radial_segments := 8
	
	var cover_instance := MeshInstance3D.new()
	cover_instance.mesh := cover_mesh
	cover_instance.name := "ManholeCover"
	cover_instance.position := Vector3(0, cover_thickness * 0.5, 0)
	
	# Checkerboard pattern
	var material := StandardMaterial3D.new()
	material.albedo_color := Color(0.1, 0.1, 0.1)
	material.roughness := 1.0
	cover_instance.material_override := material
	add_child(cover_instance)
	
	# Lifting keys (4 corners)
	for corner in ["NW", "NE", "SW", "SE"]:
		var key_mesh := BoxMesh.new()
		key_mesh.size := Vector3(0.08, 0.04, 0.08)
		
		var key_instance := MeshInstance3D.new()
		key_instance.mesh := key_mesh
		key_instance.name := "ManholeKey_%s" % corner
		
		positions := {
			"NW": Vector3(-cover_diameter * 0.4, 0, -cover_diameter * 0.4),
			"NE": Vector3(cover_diameter * 0.4, 0, -cover_diameter * 0.4),
			"SW": Vector3(-cover_diameter * 0.4, 0, cover_diameter * 0.4),
			"SE": Vector3(cover_diameter * 0.4, 0, cover_diameter * 0.4)
		}
		
		key_instance.position := positions[corner]
		key_instance.material_override := preload("res://assets/materials/palettes.metal_tres")
		add_child(key_instance)
	
	var collision := CollisionShape3D.new()
	var shape := CapsuleShape3D.new()
	shape.radius := cover_diameter * 0.5
	shape.height := cover_thickness
	collision.shape := shape
	collision.position := Vector3(0, cover_thickness * 0.5, 0)
	add_child(collision)