extends StaticBody3D

func _ready() -> void:
	# Air Compressor: industrial air compressor unit
	var total_height := 1.2
	var body_width := 0.6
	var body_depth := 0.6
	
	# Base
	var base_mesh := BoxMesh.new()
	base_mesh.size := Vector3(body_width, 0.1, body_depth)
	
	var base_instance := MeshInstance3D.new()
	base_instance.mesh := base_mesh
	base_instance.name := "CompBase"
	base_instance.position := Vector3(0, 0.05, 0)
	base_instance.material_override := preload("res://assets/materials/palettes.concrete_tres")
	add_child(base_instance)
	
	# Main housing
	var housing_mesh := BoxMesh.new()
	housing_mesh.size := Vector3(body_width, total_height - 0.1, body_depth)
	
	var housing_instance := MeshInstance3D.new()
	housing_instance.mesh := housing_mesh
	housing_instance.name := "CompHousing"
	housing_instance.position := Vector3(0, 0.1, 0)
	housing_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(housing_instance)
	
# Cooling fins
for i in range(2):
	for j in range(2):
		var fin_mesh := BoxMesh.new()
		fin_mesh.size := Vector3(0.1, total_height * 0.3, 0.05)
		
		var fin_instance := MeshInstance3D.new()
		fin_instance.mesh := fin_mesh
		fin_instance.name := "CompFin_%d_%d" % (i, j)
		fin_instance.position := Vector3(
			body_width * 0.25 * (1 if i == 0 else -1),
			0.1 + total_height * 0.3 * 0.5,
			body_depth * 0.25 * (1 if j == 0 else -1)
		)
		fin_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
		add_child(fin_instance)
	
# Pressure gauge
var gauge_mesh := BoxMesh.new()
gauge_mesh.size := Vector3(0.1, 0.1, 0.1)

var gauge_instance := MeshInstance3D.new()
gauge_instance.mesh := gauge_mesh
gauge_instance.name := "CompGauge"
gauge_instance.position := Vector3(0, total_height - 0.05, 0)
gauge_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
add_child(gauge_instance)

var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(body_width, total_height, body_depth)
collision.shape := shape
collision.position := Vector3(0, total_height * 0.5, 0)
add_child(collision)