extends StaticBody3D

func _ready() -> void:
	# Street lamp: pole with light
	var pole_height := 4.0
	var pole_radius := 0.1
	
	# Pole
	var pole_mesh := CylinderMesh.new()
	pole_mesh.top_radius := pole_radius
	pole_mesh.bottom_radius := pole_radius
	pole_mesh.height := pole_height
	pole_mesh.radial_segments := 8
	
	var pole_instance := MeshInstance3D.new()
	pole_instance.mesh := pole_mesh
	pole_instance.name := "LampPole"
	pole_instance.position := Vector3(0, pole_height * 0.5, 0)
	pole_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(pole_instance)
	
	# Lamp arm
	var arm_mesh := BoxMesh.new()
	arm_mesh.size := Vector3(0.15, 0.5, 0.15)
	var arm_instance := MeshInstance3D.new()
	arm_instance.mesh := arm_mesh
	arm_instance.name := "LampArm"
	arm_instance.position := Vector3(0, pole_height, 0.1)
	arm_instance.rotation.z := PI / 2.0
	arm_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(arm_instance)
	
	# Lamp shade/bulb
	var shade_mesh := SphereMesh.new()
	shade_mesh.radius := 0.3
	var shade_instance := MeshInstance3D.new()
	shade_instance.mesh := shade_mesh
	shade_instance.name := "LampShade"
	shade_instance.position := Vector3(0, pole_height + 0.3, 0)
	shade_instance.material_override := preload("res://assets/materials/palettes.glass_tres")
	add_child(shade_instance)
	
	# Emission for light
	var material := StandardMaterial3D.new()
	material.emission_enabled := true
	material.emission := Color(0.8, 0.8, 0.9)
	material.emission_energy_multiplier := 1.5
	shade_instance.material_override := material
	
	var collision := CollisionShape3D.new()
	var shape := CapsuleShape3D.new()
	shape.radius := pole_radius
	shape.height := pole_height
	collision.shape := shape
	collision.position := Vector3(0, pole_height * 0.5, 0)
	add_child(collision)