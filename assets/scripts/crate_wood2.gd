extends StaticBody3D

func _ready() -> void:
	# Crate 2: additional crate variant
	
	# Crate top
	var top_mesh := BoxMesh.new()
	top_mesh.size := Vector3(1.5, 0.2, 1.0)
	top_instance := MeshInstance3D.new()
	top_instance.mesh := top_mesh
	top_instance.name := "CrateTop"
	top_instance.position := Vector3(0, 0.6, 0)
	top_instance.material_override := preload("res://assets/materials.palettes.wood_tres")
	add_child(top_instance)

# Crate sides (slats)
for i in range(4):
	var slat_mesh := BoxMesh.new()
	slat_mesh.size := Vector3(0.1, 0.6, 1.0)
	var slat_instance := MeshInstance3D.new()
	slat_instance.mesh := slat_mesh
	slat_instance.name := "Slat_%d" % i
	slat_instance.position := Vector3(
		(cos(i * 2 * PI / 4) * 0.55),
		0.3,
		(sin(i * 2 * PI / 4) * 0.55) + 0.5
	)
	slat_instance.material_override := preload("res://assets/materials.palettes.wood_tres")
	add_child(slat_instance)

# Crate bands (visual)
for i in range(2):
	var band_mesh := BoxMesh.new()
	band_mesh.size := Vector3(1.6, 0.05, 0.1)
	var band_instance := MeshInstance3D.new()
	band_instance.mesh := band_mesh
	band_instance.name := "Band_%d" % i
	band_instance.position := Vector3(0, 0.35 + i * 0.2, 0)
	band_instance.material_override := preload("res://assets/materials.palettes.metal_tres")
	add_child(band_instance)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(1.5, 0.7, 1.0)
collision.shape := shape
collision.position := Vector3(0, 0, 0)
add_child(collision)