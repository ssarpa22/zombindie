extends StaticBody3D

func _ready() -> void:
	# Pedestrian crossing signal: walk/don't walk signal
	var total_height := 2.5
	
# Pole
var pole_mesh := CylinderMesh.new()
pole_mesh.top_radius := 0.1
pole_mesh.bottom_radius := 0.1
pole_mesh.height := total_height
pole_mesh.radial_segments := 8

var pole_instance := MeshInstance3D.new()
pole_instance.mesh := pole_mesh
pole_instance.name := "PedSignalPole"
pole_instance.position := Vector3(0, total_height * 0.5, 0)
pole_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
add_child(pole_instance)

# Signal housing
var housing_mesh := BoxMesh.new()
housing_mesh.size := Vector3(0.3, 0.4, 0.3)

var housing_instance := MeshInstance3D.new()
housing_instance.mesh := housing_mesh
housing_instance.name := "PedSignalHousing"
housing_instance.position := Vector3(0, total_height - 0.2, 0)
housing_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
add_child(housing_instance)

# Walk signal (green person silhouette - simplified as green box)
var walk_mesh := BoxMesh.new()
walk_mesh.size := Vector3(0.15, 0.25, 0.05)

var walk_instance := MeshInstance3D.new()
walk_instance.mesh := walk_mesh
walk_instance.name := "PedSignalWalk"
walk_instance.position := Vector3(0, total_height * 0.5 - 0.1, 0.15)
walk_instance.material_override := StandardMaterial3D.new()
walk_instance.material_override.emission_enabled := true
walk_instance.material_override.emission := Color(0.1, 0.8, 0.1)
walk_instance.material_override.emission_energy_multiplier := 2.0
add_child(walk_instance)

# Don't walk signal (red hand - simplified as red box)
var dont_mesh := BoxMesh.new()
dont_mesh.size := Vector3(0.15, 0.25, 0.05)

var dont_instance := MeshInstance3D.new()
dont_instance.mesh := dont_mesh
dont_instance.name := "PedSignalDontWalk"
dont_instance.position := Vector3(0, total_height * 0.5 + 0.1, 0.15)
dont_instance.material_override := StandardMaterial3D.new()
dont_instance.material_override.emission_enabled := true
dont_instance.material_override.emission := Color(0.8, 0.1, 0.1)
dont_instance.material_override.emission_energy_multiplier := 2.0
add_child(dont_instance)

var collision := CollisionShape3D.new()
var shape := CapsuleShape3D.new()
shape.radius := 0.1
shape.height := total_height
collision.shape := shape
collision.position := Vector3(0, total_height * 0.5, 0)
add_child(collision)