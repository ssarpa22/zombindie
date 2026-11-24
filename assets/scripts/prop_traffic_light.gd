extends StaticBody3D

func _ready() -> void:
	# Traffic light: standard traffic signal
	var pole_height := 5.0
	var aspect_ratio := 3.0
	
	# Pole
	var pole_mesh := CylinderMesh.new()
	pole_mesh.top_radius := 0.15
	pole_mesh.bottom_radius := 0.15
	pole_mesh.height := pole_height
	pole_mesh.radial_segments := 8
	
	var pole_instance := MeshInstance3D.new()
	pole_instance.mesh := pole_mesh
	pole_instance.name := "TrafficLightPole"
	pole_instance.position := Vector3(0, pole_height * 0.5, 0)
	pole_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(pole_instance)
	
	# Traffic light housing
	var housing_mesh := BoxMesh.new()
	housing_mesh.size := Vector3(0.3, 0.4, 0.3)
	
	var housing_instance := MeshInstance3D.new()
	housing_instance.mesh := housing_mesh
	housing_instance.name := "TrafficLightHousing"
	housing_instance.position := Vector3(0, pole_height - 0.2, 0)
	housing_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(housing_instance)
	
	# Traffic lights (red, yellow, green)
	var light_colors := [Color(0.8, 0.1, 0.1), Color(0.8, 0.7, 0.1), Color(0.1, 0.5, 0.1)]
	for i in range(3):
		var light_mesh := SphereMesh.new()
		light_mesh.radius := 0.12
		
		var light_instance := MeshInstance3D.new()
		light_instance.mesh := light_mesh
		light_instance.name := "TrafficLight_%s" % light_colors[i].to_string()
		light_instance.position := Vector3(0, pole_height - 0.5 + i * 0.25, 0.15)
		light_instance.material_override := StandardMaterial3D.new()
		light_instance.material_override.emission_enabled := true
		light_instance.material_override.emission := light_colors[i]
		light_instance.material_override.emission_energy_multiplier := 2.0
		add_child(light_instance)
	
	var collision := CollisionShape3D.new()
	var shape := CapsuleShape3D.new()
	shape.radius := 0.15
	shape.height := pole_height
	collision.shape := shape
	collision.position := Vector3(0, pole_height * 0.5, 0)
	add_child(collision)