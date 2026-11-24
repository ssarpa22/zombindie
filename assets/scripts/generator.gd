extends StaticBody3D

func _ready() -> void:
	# Generator: portable electric generator
	var total_height := 1.0
	var housing_width := 0.5
	var housing_depth := 0.5
	
	# Base/pedestal
	var base_mesh := BoxMesh.new()
	base_mesh.size := Vector3(housing_width, 0.1, housing_depth)
	
	var base_instance := MeshInstance3D.new()
	base_instance.mesh := base_mesh
	base_instance.name := "GenBase"
	base_instance.position := Vector3(0, 0.05, 0)
	base_instance.material_override := preload("res://assets/materials/palettes.concrete_tres")
	add_child(base_instance)
	
	# Housing
	var housing_mesh := BoxMesh.new()
	housing_mesh.size := Vector3(housing_width, total_height - 0.1, housing_depth)
	
	var housing_instance := MeshInstance3D.new()
	housing_instance.mesh := housing_mesh
	housing_instance.name := "GenHousing"
	housing_instance.position := Vector3(0, 0.1, 0)
	housing_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(housing_instance)
	
# Control panel
var panel_mesh := BoxMesh.new()
panel_mesh.size := Vector3(0.3, 0.3, 0.1)

var panel_instance := MeshInstance3D.new()
panel_instance.mesh := panel_mesh
panel_instance.name := "GenPanel"
panel_instance.position := Vector3(0, 0.2, housing_depth * 0.45 - 0.02)
panel_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
add_child(panel_instance)

# Exhaust pipe
var exhaust_mesh := CylinderMesh.new()
exhaust_mesh.top_radius := 0.08
exhaust_mesh.bottom_radius := 0.08
exhaust_mesh.height := 0.3
exhaust_mesh.radial_segments := 6

var exhaust_instance := MeshInstance3D.new()
exhaust_instance.mesh := exhaust_mesh
exhaust_instance.name := "GenExhaust"
exhaust_instance.position := Vector3(0, total_height - 0.1, -housing_depth * 0.45 + 0.05)
exhaust_instance.rotation.z := PI / 2.0
exhaust_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
add_child(exhaust_instance)

var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(housing_width, total_height, housing_depth)
collision.shape := shape
collision.position := Vector3(0, total_height * 0.5, 0)
add_child(collision)