extends StaticBody3D

func _ready() -> void:
	# Storm drain grate: larger version of street drain
	var grate_width := 1.2
	var grate_depth := 0.6
	var bar_spacing := 0.15
	
	# Main grate frame
	var frame_mesh := BoxMesh.new()
	frame_mesh.size := Vector3(grate_width, 0.08, grate_depth)
	
	var frame_instance := MeshInstance3D.new()
	frame_instance.mesh := frame_mesh
	frame_instance.name := "StormGrateFrame"
	frame_instance.position := Vector3(grate_width * 0.5, 0.04, 0)
	
	var material := StandardMaterial3D.new()
	material.albedo_color := Color(0.1, 0.1, 0.1)
	material.roughness := 1.0
	frame_instance.material_override := material
	add_child(frame_instance)
	
# Grate bars (parallel bars)
bar_count := int(grate_width / bar_spacing) + 1
for i in range(bar_count):
	var bar_mesh := BoxMesh.new()
	bar_mesh.size := Vector3(0.1, 0.08, grate_depth)
	
	var bar_instance := MeshInstance3D.new()
	bar_instance.mesh := bar_mesh
	bar_instance.name := "StormGrateBar_%d" % i
	bar_instance.position := Vector3(-grate_width * 0.5 + i * bar_spacing, 0.04, grate_depth * 0.5 - 0.02)
	bar_instance.material_override := preload("res://assets/materials/palettes.metal_tres")
	add_child(bar_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size := Vector3(grate_width, 0.1, grate_depth)
	collision.shape := shape
	collision.position := Vector3(grate_width * 0.5, 0.05, 0)
	add_child(collision)