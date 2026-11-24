extends StaticBody3D

func _ready() -> void:
	# Wall lamp: mounted on building wall
	var arm_length := 0.4
	var fixture_height := 0.3
	
	# Wall mounting bracket
	var bracket_mesh := BoxMesh.new()
	bracket_mesh.size := Vector3(0.1, 0.1, arm_length)
	
	var bracket_instance := MeshInstance3D.new()
	bracket_instance.mesh := bracket_instance
	bracket_instance.name := "WallLampBracket"
	bracket_instance.position := Vector3(0, fixture_height * 0.5, 0)
	bracket_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(bracket_instance)
	
	# Lamp arm
	var arm_mesh := BoxMesh.new()
	arm_mesh.size := Vector3(arm_length, 0.05, 0.05)
	
	var arm_instance := MeshInstance3D.new()
	arm_instance.mesh := arm_mesh
	arm_instance.name := "WallLampArm"
	arm_instance.position := Vector3(arm_length * 0.5, fixture_height, 0)
	arm_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(arm_instance)
	
	# Lamp fixture
	var fixture_mesh := BoxMesh.new()
	fixture_mesh.size := Vector3(0.1, 0.1, 0.1)
	
	var fixture_instance := MeshInstance3D.new()
	fixture_instance.mesh := fixture_mesh
	fixture_instance.name := "WallLampFixture"
	fixture_instance.position := Vector3(arm_length, fixture_height, 0)
	
	var mat := StandardMaterial3D.new()
	mat.emission_enabled := true
	mat.emission := Color(0.9, 0.8, 0.6)
	mat.emission_energy_multiplier := 1.0
	fixture_instance.material_override := mat
	
	add_child(fixture_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size := Vector3(arm_length + 0.1, fixture_height * 2, 0.1)
	collision.shape := shape
	collision.position := Vector3(arm_length * 0.5, fixture_height, 0)
	add_child(collision)