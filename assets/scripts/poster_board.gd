extends StaticBody3D

func _ready() -> void:
	# Poster board: advertising board on a post
	var board_width := 0.8
	var board_height := 1.2
	var post_height := 2.5
	
	# Post
	var post_mesh := CylinderMesh.new()
	post_mesh.top_radius := 0.08
	post_mesh.bottom_radius := 0.08
	post_mesh.height := post_height
	post_mesh.radial_segments := 6
	
	var post_instance := MeshInstance3D.new()
	post_instance.mesh := post_mesh
	post_instance.name := "PosterPost"
	post_instance.position := Vector3(0, post_height * 0.5, 0)
	post_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(post_instance)
	
	# Board
	var board_mesh := BoxMesh.new()
	board_mesh.size := Vector3(board_width, board_height, 0.02)
	
	var board_instance := MeshInstance3D.new()
	board_instance.mesh := board_mesh
	board_instance.name := "PosterBoard"
	board_instance.position := Vector3(0, post_height * 0.5 - board_height * 0.5, board_width * 0.5 + 0.01)
	board_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(board_instance)
	
# Poster clips
for i in range(4):
	var clip_mesh := BoxMesh.new()
	clip_mesh.size := Vector3(0.05, 0.1, 0.02)
	
	var clip_instance := MeshInstance3D.new()
	clip_instance.mesh := clip_mesh
	clip_instance.name := "PosterClip%d" % i
	clip_instance.position := Vector3(-board_width * 0.35 + i * 0.15, post_height * 0.5 - board_height * 0.5 + 0.05, board_width * 0.5)
	clip_instance.material_override := preload("res://assets/materials/palettes.metal_tres")
	add_child(clip_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size := Vector3(board_width + 0.1, board_height + 0.1, 0.1)
	collision.shape := shape
	collision.position := Vector3(0, post_height * 0.5, board_width * 0.5)
	add_child(collision)