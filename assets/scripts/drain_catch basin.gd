extends StaticBody3D

func _ready() -> void:
	# Drain catch basin: storm drain collection area
	var basin_diameter := 1.0
	var basin_depth := 0.3
	
# Basin ring
var ring_mesh := CylinderMesh.new()
ring_mesh.top_radius := basin_diameter * 0.5
ring_mesh.bottom_radius := basin_diameter * 0.5
ring_mesh.height := basin_depth
ring_mesh.radial_segments := 8

var ring_instance := MeshInstance3D.new()
ring_instance.mesh := ring_mesh
ring_instance.name := "DrainBasinRing"
ring_instance.position := Vector3(0, basin_depth * 0.5, 0)
ring_instance.material_override := preload("res://assets/materials/palettes.asphalt_tres")
add_child(ring_instance)

# Grate pattern inside
for i in range(4):
	var bar_mesh := BoxMesh.new()
	bar_mesh.size := Vector3(0.15, basin_depth * 0.2, 0.02)
	
	var bar_instance := MeshInstance3D.new()
	bar_instance.mesh := bar_mesh
	bar_instance.name := "DrainBar_%d" % i
	bar_instance.position := Vector3(
		(basin_diameter * 0.5 - 0.05) * (1 if i == 0 else -1 if i == 1 else 0),
		basin_depth * 0.15,
		(basin_diameter * 0.5 - 0.05) * (1 if i == 2 else -1)
	)
	bar_instance.material_override := preload("res://assets/materials/palettes.metal_tres")
	add_child(bar_instance)

# Central drainage hole
var hole_mesh := BoxMesh.new()
hole_mesh.size := Vector3(0.2, basin_depth, 0.02)

var hole_instance := MeshInstance3D.new()
hole_instance.mesh := hole_mesh
hole_instance.name := "DrainHole"
hole_instance.position := Vector3(0, 0.02, 0)
hole_instance.material_override := preload("res://assets/materials/palettes.metal_tres")
add_child(hole_instance)

var collision := CollisionShape3D.new()
var shape := CapsuleShape3D.new()
shape.radius := basin_diameter * 0.5
shape.height := basin_depth
collision.shape := shape
collision.position := Vector3(0, basin_depth * 0.5, 0)
add_child(collision)