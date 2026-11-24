extends StaticBody3D

func _ready() -> void:
	# Phone booth: retro street phone
	var booth_height := 2.0
	var booth_width := 0.6
	var booth_depth := 0.6
	
	# Booth walls
	var wall_mesh := BoxMesh.new()
	wall_mesh.size := Vector3(booth_width, booth_height, booth_depth)
	
	var wall_instance := MeshInstance3D.new()
	wall_instance.mesh := wall_mesh
	wall_instance.name := "PhoneBoothWalls"
	wall_instance.position := Vector3(0, booth_height * 0.5, 0)
	wall_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(wall_instance)
	
	# Glass window area
	var glass_mesh := BoxMesh.new()
	glass_mesh.size := Vector3(booth_width - 0.2, booth_height * 0.6, booth_depth - 0.2)
	
	var glass_instance := MeshInstance3D.new()
	glass_instance.mesh := glass_mesh
	glass_instance.name := "PhoneBoothGlass"
	glass_instance.position := Vector3(0, booth_height * 0.3, 0)
	glass_instance.material_override := preload("res://assets/materials/palettes.glass_tres")
	add_child(glass_instance)
	
	# Phone handset
	var handset_mesh := SphereMesh.new()
	handset_mesh.radius := 0.1
	
	var handset_instance := MeshInstance3D.new()
	handset_instance.mesh := handset_mesh
	handset_instance.name := "PhoneHandset"
	handset_instance.position := Vector3(0, booth_height * 0.2, -booth_depth * 0.25)
	handset_instance.material_override := preload("res://assets/materials/palettes.medical_plastics_tres")
	add_child(handset_instance)
	
	# Phone cradle
	var cradle_mesh := BoxMesh.new()
	cradle_mesh.size := Vector3(0.15, 0.1, 0.1)
	
	var cradle_instance := MeshInstance3D.new()
	cradle_instance.mesh := cradle_mesh
	cradle_instance.name := "PhoneCradle"
	cradle_instance.position := Vector3(0, booth_height * 0.55, booth_depth * 0.2)
	cradle_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(cradle_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size := Vector3(booth_width, booth_height, booth_depth)
	collision.shape := shape
	collision.position := Vector3(0, booth_height * 0.5, 0)
	add_child(collision)