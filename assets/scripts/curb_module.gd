extends StaticBody3D

func _ready() -> void:
	# Curb module: standard 1m curb segment for road edges
	var module_length := 1.0
	var curb_height := 0.15
	var curb_width := 0.3
	
	var mesh := BoxMesh.new()
	mesh.size := Vector3(module_length, curb_height, curb_width)
	
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh := mesh
	mesh_instance.name := "CurbModule"
	mesh_instance.position := Vector3(module_length * 0.5, curb_height * 0.5, 0)
	mesh_instance.material_override := preload("res://assets/materials/palettes.asphalt_tres")
	add_child(mesh_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size := Vector3(module_length, curb_height, curb_width)
	collision.shape := shape
	collision.position := Vector3(module_length * 0.5, curb_height * 0.5, 0)
	add_child(collision)