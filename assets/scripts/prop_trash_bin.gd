extends StaticBody3D

func _ready() -> void:
	# Trash/bin: waste container
	var body_height := 0.8
	var body_width := 0.5
	var body_depth := 0.5
	
	# Bin body
	var body_mesh := BoxMesh.new()
	body_mesh.size := Vector3(body_width, body_height, body_depth)
	
	var body_instance := MeshInstance3D.new()
	body_instance.mesh := body_mesh
	body_instance.name := "BinBody"
	body_instance.position := Vector3(0, body_height * 0.5, 0)
	body_instance.material_override := preload("res://assets/materials/palettes.asphalt_tres")
	add_child(body_instance)
	
	# Bin rim
	var rim_mesh := BoxMesh.new()
	rim_mesh.size := Vector3(body_width * 1.1, 0.05, body_depth * 1.1)
	
	var rim_instance := MeshInstance3D.new()
	rim_instance.mesh := rim_mesh
	rim_instance.name := "BinRim"
	rim_instance.position := Vector3(0, body_height + 0.025, 0)
	rim_instance.material_override := preload("res://assets/materials/palettes.metal_tres")
	add_child(rim_instance)
	
	# Foot pedal
	var pedal_mesh := BoxMesh.new()
	pedal_mesh.size := Vector3(body_width * 0.6, 0.05, body_depth * 0.3)
	
	var pedal_instance := MeshInstance3D.new()
	pedal_instance.mesh := pedal_mesh
	pedal_instance.name := "BinPedal"
	pedal_instance.position := Vector3(0, 0.025, body_depth * 0.15)
	pedal_instance.material_override := preload("res://assets/materials/palettes.asphalt_tres")
	add_child(pedal_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size := Vector3(body_width, body_height, body_depth)
	collision.shape := shape
	collision.position := Vector3(0, body_height * 0.5, 0)
	add_child(collision)