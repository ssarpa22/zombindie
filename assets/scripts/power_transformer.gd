extends StaticBody3D

func _ready() -> void:
	# Power transformer: electrical equipment on street
	var total_height := 1.5
	var body_width := 0.6
	var body_depth := 0.6
	
	# Transformer base/pedestal
	var base_mesh := BoxMesh.new()
	base_mesh.size := Vector3(body_width, 0.2, body_depth)
	
	var base_instance := MeshInstance3D.new()
	base_instance.mesh := base_mesh
	base_instance.name := "XfmrBase"
	base_instance.position := Vector3(0, 0.1, 0)
	base_instance.material_override := preload("res://assets/materials/palettes.concrete_tres")
	add_child(base_instance)
	
	# Transformer housing
	var xfrm_mesh := BoxMesh.new()
	xfrm_mesh.size := Vector3(body_width, total_height - 0.2, body_depth)
	
	var xfrm_instance := MeshInstance3D.new()
	xfrm_instance.mesh := xfrm_mesh
	xfrm_instance.name := "XfrmHousing"
	xfrm_instance.position := Vector3(0, 0.1 + 0.2, 0)
	xfrm_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(xfrm_instance)
	
	# Cooling fins/grilles (visual)
	for i in range(2):
		for j in range(2):
			var fin_mesh := BoxMesh.new()
			fin_mesh.size := Vector3(0.15, total_height * 0.4, 0.05)
			var fin_instance := MeshInstance3D.new()
			fin_instance.mesh := fin_mesh
			fin_instance.name := "XfrmFin_%d_%d" % (i, j)
			fin_instance.position := Vector3(
				body_width * 0.25 * (1 if i == 0 else -1),
				0.1 + 0.2 + total_height * 0.4 * 0.5,
				body_depth * 0.25 * (1 if j == 0 else -1)
			)
			fin_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
			add_child(fin_instance)
	
	# Terminal bushing
	var terminal_mesh := BoxMesh.new()
	terminal_mesh.size := Vector3(0.1, 0.1, 0.1)
	
	var terminal_instance := MeshInstance3D.new()
	terminal_instance.mesh := terminal_mesh
	terminal_instance.name := "XfrmTerminal"
	terminal_instance.position := Vector3(0, total_height - 0.1, 0)
	terminal_instance.material_override := preload("res://assets/materials/palettes.metal_tres")
	add_child(terminal_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size := Vector3(body_width, total_height, body_depth)
	collision.shape := shape
	collision.position := Vector3(0, total_height * 0.5, 0)
	add_child(collision)