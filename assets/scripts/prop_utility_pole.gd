extends StaticBody3D

func _ready() -> void:
	# Utility pole: tall pole with crossarm and utilities
	var pole_height := 8.0
	var pole_radius := 0.15
	
	# Pole
	var pole_mesh := CylinderMesh.new()
	pole_mesh.top_radius := pole_radius
	pole_mesh.bottom_radius := pole_radius
	pole_mesh.height := pole_height
	pole_mesh.radial_segments := 8
	
	var pole_instance := MeshInstance3D.new()
	pole_instance.mesh := pole_mesh
	pole_instance.name := "PoleShaft"
	pole_instance.position := Vector3(0, pole_height * 0.5, 0)
	pole_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(pole_instance)
	
	# Crossarm
	var crossarm_mesh := BoxMesh.new()
	crossarm_mesh.size := Vector3(2.0, 0.1, 0.1)
	
	var crossarm_instance := MeshInstance3D.new()
	crossarm_instance.mesh := crossarm_mesh
	crossarm_instance.name := "PoleCrossarm"
	crossarm_instance.position := Vector3(0, pole_height * 0.7, 0)
	crossarm_instance.rotation.z := PI / 4.0
	crossarm_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(crossarm_instance)
	
	# Utility insulators (simplified)
	for i in range(4):
		var insul_mesh := BoxMesh.new()
		insul_mesh.size := Vector3(0.15, 0.2, 0.15)
		var insul_instance := MeshInstance3D.new()
		insul_instance.mesh := insul_mesh
		insul_instance.name := "UtilityInsulator%d" % i
		angle := i * PI / 2.0
		insul_instance.position := Vector3(
			sin(angle) * (pole_height * 0.45),
			pole_height * 0.55,
			cos(angle) * (pole_height * 0.45)
		)
		insul_instance.material_override := preload("res://assets/materials/palettes.glass_tres")
		add_child(insul_instance)
	
	var collision := CollisionShape3D.new()
	var shape := CapsuleShape3D.new()
	shape.radius := pole_radius
	shape.height := pole_height
	collision.shape := shape
	collision.position := Vector3(0, pole_height * 0.5, 0)
	add_child(collision)