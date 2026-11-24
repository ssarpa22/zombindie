extends StaticBody3D

func _ready() -> void:
	# Graffiti board: tagged wall or board
	var board_width := 0.8
	var board_height := 1.0
	
	var mesh := BoxMesh.new()
	mesh.size := Vector3(board_width, board_height, 0.1)
	
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh := mesh
	mesh_instance.name := "GraffitiBoard"
	mesh_instance.position := Vector3(board_width * 0.5, board_height * 0.5, 0)
	
	# Simulated graffiti art (abstract shapes)
	for i in range(5):
		var shape_mesh := BoxMesh.new()
		shape_mesh.size := Vector3(0.15 + i * 0.05, 0.15 + i * 0.05, 0.05)
		var shape_instance := MeshInstance3D.new()
		shape_instance.mesh := shape_mesh
		shape_instance.name := "GraffitiShape%d" % i
		
		# Random-ish colors for graffiti
		var colors := [Color(1, 0, 0), Color(0, 1, 0), Color(0, 0, 1), Color(1, 1, 0), Color(1, 0, 1)]
		var mat := StandardMaterial3D.new()
		mat.albedo_color := colors[i % colors.size()]
		mat.roughness := 0.7
		shape_instance.material_override := mat
		
		# Random positions on the board
		shape_instance.position := Vector3(
			board_width * 0.5 + (i % 3 - 1) * 0.15,
			board_height * 0.5 + (i / 3 % 3 - 1) * 0.15,
			0.02
		)
		add_child(shape_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size := Vector3(board_width, board_height, 0.15)
	collision.shape := shape
	collision.position := Vector3(board_width * 0.5, board_height * 0.5, 0)
	add_child(collision)