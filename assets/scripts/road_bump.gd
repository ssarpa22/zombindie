extends StaticBody3D

func _ready() -> void:
	# Road bump/speed hump: traffic calming measure
	var bump_length := 1.5
	var bump_height := 0.1
	var bump_width := 0.4
	
	var mesh := BoxMesh.new()
	mesh.size := Vector3(bump_length, bump_height, bump_width)
	
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh := mesh
	mesh_instance.name := "RoadBump"
	mesh_instance.position := Vector3(bump_length * 0.5, bump_height * 0.5, 0)
	mesh_instance.material_override := preload("res://assets/materials/palettes.asphalt_tres")
	add_child(mesh_instance)
	
	# Reflective strips
	for side in [-1, 1]:
		var strip_mesh := BoxMesh.new()
		strip_mesh.size := Vector3(0.05, bump_height, bump_width)
		
		var strip_instance := MeshInstance3D.new()
		strip_instance.mesh := strip_mesh
		strip_instance.name := "BumpStrip_%d" % (side == -1 and 1 or 2)
		strip_instance.position := Vector3(side * bump_length * 0.45, bump_height * 0.5 + 0.02, 0)
		strip_instance.material_override := preload("res://assets/materials/palettes.metal_tres")
		add_child(strip_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size := Vector3(bump_length, bump_height * 2, bump_width)
	collision.shape := shape
	collision.position := Vector3(bump_length * 0.5, bump_height * 0.5, 0)
	add_child(collision)