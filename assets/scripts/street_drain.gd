extends StaticBody3D

func _ready() -> void:
	# Street drain: road drainage grate
	var drain_width := 0.8
	var drain_depth := 0.4
	
	# Grate frame
	var grate_mesh := BoxMesh.new()
	grate_mesh.size := Vector3(drain_width, 0.05, drain_depth)
	
	var grate_instance := MeshInstance3D.new()
	grate_instance.mesh := grate_mesh
	grate_instance.name := "StreetDrainGrate"
	grate_instance.position := Vector3(drain_width * 0.5, 0.025, 0)
	
	var material := StandardMaterial3D.new()
	material.albedo_color := Color(0.1, 0.1, 0.1)
	material.roughness := 1.0
	grate_instance.material_override := material
	add_child(grate_instance)
	
# Bars across the grate
for i in range(4):
	var bar_mesh := BoxMesh.new()
	bar_mesh.size := Vector3(0.1, 0.05, drain_depth)
	var bar_instance := MeshInstance3D.new()
	bar_instance.mesh := bar_mesh
	bar_instance.name := "DrainBar%d" % i
	bar_instance.position := Vector3(-drain_width * 0.4 + i * drain_width * 0.2, 0.025, drain_depth * 0.5 - 0.02)
	bar_instance.material_override := preload("res://assets/materials/palettes.metal_tres")
	add_child(bar_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size := Vector3(drain_width, 0.1, drain_depth)
	collision.shape := shape
	collision.position := Vector3(drain_width * 0.5, 0.05, 0)
	add_child(collision)