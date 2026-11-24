extends StaticBody3D

func _ready() -> void:
	# Sewer access hatch: smaller than manhole, for maintenance access
	var hatch_width := 0.4
	var hatch_depth := 0.5
	var hatch_height := 0.03
	
	# Hatch frame
	var frame_mesh := BoxMesh.new()
	frame_mesh.size := Vector3(hatch_width, hatch_height, hatch_depth)
	
	var frame_instance := MeshInstance3D.new()
	frame_instance.mesh := frame_mesh
	frame_instance.name := "SewerHatchFrame"
	frame_instance.position := Vector3(0, hatch_height * 0.5, 0)
	frame_instance.material_override := preload("res://assets/materials/palettes.metal_tres")
	add_child(frame_instance)
	
	# Hatch cover (grille pattern)
	var grille_mesh := BoxMesh.new()
	grille_mesh.size := Vector3(hatch_width, hatch_height, hatch_depth)
	
	var grille_instance := MeshInstance3D.new()
	grille_instance.mesh := grille_mesh
	grille_instance.name := "SewerHatchGrille"
	grille_instance.position := Vector3(0, hatch_height * 0.5, 0)
	
	var material := StandardMaterial3D.new()
	material.albedo_color := Color(0.05, 0.05, 0.05)
	material.roughness := 1.0
	grille_instance.material_override := material
	add_child(grille_instance)
	
	# Rim
	var rim_mesh := BoxMesh.new()
	rim_mesh.size := Vector3(hatch_width + 0.1, 0.03, hatch_depth + 0.1)
	
	var rim_instance := MeshInstance3D.new()
	rim_instance.mesh := rim_mesh
	rim_instance.name := "SewerHatchRim"
	rim_instance.position := Vector3(0, hatch_height * 0.5 + 0.015, 0)
	rim_instance.material_override := preload("res://assets/materials/palettes.metal_tres")
	add_child(rim_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size := Vector3(hatch_width, hatch_height + 0.02, hatch_depth)
	collision.shape := shape
	collision.position := Vector3(0, hatch_height * 0.5, 0)
	add_child(collision)