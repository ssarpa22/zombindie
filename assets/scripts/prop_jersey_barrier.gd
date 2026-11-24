extends StaticBody3D

func _ready() -> void:
	# Jersey barrier: concrete traffic barrier
	var length := 3.0
	var height := 0.7
	var width := 0.4
	
	var mesh := BoxMesh.new()
	mesh.size := Vector3(length, height, width)
	
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh := mesh
	mesh_instance.name := "JerseyBarrier"
	mesh_instance.position := Vector3(length * 0.5, height * 0.5, 0)
	mesh_instance.material_override := preload("res://assets/materials/palettes.concrete_tres")
	add_child(mesh_instance)
	
	# Texture bands (simulated by color variation)
	for i in range(2):
		var band_mesh := BoxMesh.new()
		band_mesh.size := Vector3(length, 0.05, width)
		var band_instance := MeshInstance3D.new()
		band_instance.mesh := band_mesh
		band_instance.name := "BarrierBand%d" % i
		band_instance.position := Vector3(length * 0.5, height - 0.1 - i * 0.1, 0)
		band_instance.material_override := preload("res://assets/materials/palettes.concrete_tres")
		add_child(band_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size := Vector3(length, height, width)
	collision.shape := shape
	collision.position := Vector3(length * 0.5, height * 0.5, 0)
	add_child(collision)