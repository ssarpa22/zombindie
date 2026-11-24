extends StaticBody3D

func _ready() -> void:
	# Generic switch: reusable switch entity
	
# Switch base
var switch_mesh := BoxMesh.new()
switch_mesh.size := Vector3(0.5, 0.5, 0.5)
var switch_instance := MeshInstance3D.new()
switch_instance.mesh := switch_mesh
switch_instance.name := "Switch"
switch_instance.position := Vector3(0, 0.25, 0)
switch_instance.material_override := preload("res://assets/materials.palettes.painted_metal_tres")
add_child(switch_instance)

# Switch lever
var lever_mesh := CylinderMesh.new()
lever_mesh.top_radius := 0.1
lever_mesh.bottom_radius := 0.1
lever_mesh.height := 0.5
lever_mesh.radial_segments := 6

var lever_instance := MeshInstance3D.new()
lever_instance.mesh := lever_mesh
lever_instance.name := "Lever"
lever_instance.position := Vector3(0.3, 0.25, 0)
lever_instance.material_override := preload("res://assets/materials.palettes.painted_metal_tres")
add_child(lever_instance)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(0.6, 0.6, 0.6)
collision.shape := shape
collision.position := Vector3(0, 0, 0)
add_child(collision)

# Interaction distance
func interact() -> void:
	print("Switch activated...")