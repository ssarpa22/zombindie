extends Node3D

func _ready() -> void:
	# No Entry sign
	
	post_mesh := CylinderMesh.new()
	post_mesh.top_radius := 0.1
	post_mesh.bottom_radius := 0.1
	post_mesh.height := 2.0
	post_mesh.radial_segments := 6

	post_instance := MeshInstance3D.new()
	post_instance.mesh := post_mesh
	post_instance.name := "SignPost"
	post_instance.position := Vector3(0, 1.0, 0)
	post_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(post_instance)

	board_mesh := BoxMesh.new()
	board_mesh.size := Vector3(1.5, 1.0, 0.2)
	board_instance := MeshInstance3D.new()
	board_instance.mesh := board_mesh
	board_instance.name := "SignBoard"
	board_instance.position := Vector3(0, 1.0, 0.1)
	board_instance.rotation.z := PI / 2.0
	board_instance.material_override := StandardMaterial3D.new()
	board_instance.material_override.albedo_color := Color(1.0, 0.0, 0.0)
	board_instance.material_override.roughness := 0.8
	add_child(board_instance)

	# Cross mark
	cross1 := BoxMesh.new()
	cross1.size := Vector3(0.3, 0.1, 0.1)
	cross1_instance := MeshInstance3D.new()
	cross1_instance.mesh := cross1
	cross1_instance.name := "Cross1"
	cross1_instance.position := Vector3(0.2, 0.5, 0.1)
	cross1_instance.material_override := StandardMaterial3D.new()
	cross1_instance.material_override.albedo_color := Color(1.0, 0.0, 0.0)
	add_child(cross1_instance)

	cross2 := BoxMesh.new()
	cross2.size := Vector3(0.3, 0.1, 0.1)
	cross2_instance := MeshInstance3D.new()
	cross2_instance.mesh := cross2
	cross2_instance.position := Vector3(-0.2, 0.5, 0.1)
	cross2_instance.material_override := StandardMaterial3D.new()
	cross2_instance.material_override.albedo_color := Color(1.0, 0.0, 0.0)
	add_child(cross2_instance)