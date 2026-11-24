extends StaticBody3D

func _ready() -> void:
	# Generic container: reusable container entity
	
# Container top
var top_mesh := BoxMesh.new()
top_mesh.size := Vector3(1.5, 0.5, 1.0)
top_instance := MeshInstance3D.new()
top_instance.mesh := top_mesh
top_instance.name := "ContainerTop"
top_instance.position := Vector3(0, 0.25, 0)
top_instance.material_override := preload("res://assets/materials.palettes.metal_tres")
add_child(top_instance)

# Container sides (visual panels)
for i in range(4):
	var panel_mesh := BoxMesh.new()
	panel_mesh.size := Vector3(0.3, 0.4, 1.0)
	panel_instance := MeshInstance3D.new()
	panel_instance.mesh := panel_mesh
	panel_instance.name := "Panel_%d" % i
	panel_instance.position := Vector3(
		(cos(i * 2 * PI / 4) * 0.6),
		0.2,
		(sin(i * 2 * PI / 4) * 0.6) + 0.5
	)
	panel_instance.material_override := StandardMaterial3D.new()
	panel_instance.material_override.albedo_color := Color(0.8, 0.8, 0.8)
	add_child(panel_instance)

# Lock (visual)
var lock_mesh := BoxMesh.new()
lock_mesh.size := Vector3(0.2, 0.2, 0.2)
lock_instance := MeshInstance3D.new()
lock_instance.mesh := lock_mesh
lock_instance.name := "Lock"
lock_instance.position := Vector3(0.6, 0.2, 0)
lock_instance.material_override := preload("res://assets/materials.palettes.painted_metal_tres")
add_child(lock_instance)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(1.5, 0.5, 1.0)
collision.shape := shape
collision.position := Vector3(0, 0, 0)
add_child(collision)

# Interaction distance
func interact() -> void:
	print("Opening container...")