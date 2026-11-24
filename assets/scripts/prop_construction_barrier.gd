extends StaticBody3D

func _ready() -> void:
	# Construction barrier: A-frame or barricade tape
	var height := 1.0
	var length := 3.0
	
	# A-frame barrier
	var A_mesh := BoxMesh.new()
	A_mesh.size := Vector3(0.3, height, 0.3)
	
	for i in range(3):
		var A_instance := MeshInstance3D.new()
		A_instance.mesh := A_mesh
		A_instance.name := "ConstructionAFrame%d" % i
		A_instance.position := Vector3(-length * 0.5 + i * length * 0.5, height * 0.5, 0)
		A_instance.material_override := preload("res://assets/materials/palettes.concrete_tres")
		add_child(A_instance)
	
	# Top beam
	var beam_mesh := BoxMesh.new()
	beam_mesh.size := Vector3(length, 0.1, 0.2)
	
	var beam_instance := MeshInstance3D.new()
	beam_instance.mesh := beam_mesh
	beam_instance.name := "ConstructionBeamTop"
	beam_instance.position := Vector3(length * 0.5, height - 0.05, 0)
	beam_instance.material_override := preload("res://assets/materials/palettes.concrete_tres")
	add_child(beam_instance)
	
	# X-bracing
	for i in range(4):
		var brace_mesh := BoxMesh.new()
		brace_mesh.size := Vector3(0.2, height * 0.8, 0.05)
		var brace_instance := MeshInstance3D.new()
		brace_instance.mesh := brace_mesh
		brace_instance.name := "ConstructionBrace%d" % i
		angle := i * PI / 2.0
		brace_instance.position := Vector3(
			cos(angle) * length * 0.4,
			height * 0.4,
			sin(angle) * length * 0.4
		)
		brace_instance.material_override := preload("res://assets/materials/palettes.concrete_tres")
		add_child(brace_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size := Vector3(length, height, 0.5)
	collision.shape := shape
	collision.position := Vector3(length * 0.5, height * 0.5, 0)
	add_child(collision)