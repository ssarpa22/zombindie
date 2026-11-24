extends StaticBody3D

func _ready() -> void:
	# Sewer hatch: reusable sewer entity
	
# Hatch cover
var hatch_mesh := CylinderMesh.new()
hatch_mesh.top_radius := 0.6
hatch_mesh.bottom_radius := 0.6
hatch_mesh.height := 0.2
hatch_mesh.radial_segments := 8

var hatch_instance := MeshInstance3D.new()
hatch_instance.mesh := hatch_mesh
hatch_instance.name := "HatchCover"
hatch_instance.position := Vector3(0, 0.1, 0)
hatch_instance.material_override := preload("res://assets/materials.palettes.concrete_tres")
add_child(hatch_instance)

# Rungs (visual)
for i in range(4):
	var rung_mesh := BoxMesh.new()
	rung_mesh.size := Vector3(0.1, 0.5, 0.5)
	var rung_instance := MeshInstance3D.new()
	rung_instance.mesh := rung_mesh
	rung_instance.name := "Rung_%d" % i
	rung_instance.position := Vector3(
		(cos(i * 2 * PI / 4) * 0.55),
		0.15,
		(sin(i * 2 * PI / 4) * 0.55)
	)
	rung_instance.material_override := preload("res://assets/materials.palettes.metal_tres")
	add_child(rung_instance)

# Collision
var collision := CollisionShape3D.new()
var shape := CylinderShape3D.new()
shape.radius := 0.65
shape.height := 0.3
collision.shape := shape
collision.position := Vector3(0, 0, 0)
add_child(collision)

# Interaction distance
func interact() -> void:
	print("Opening sewer hatch...")