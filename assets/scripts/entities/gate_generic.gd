extends StaticBody3D

func _ready() -> void:
	# Generic gate: reusable gate entity
	
# Gate structure
var gate_mesh := BoxMesh.new()
gate_mesh.size := Vector3(3.0, 6.0, 0.3)
var gate_instance := MeshInstance3D.new()
gate_instance.mesh := gate_mesh
gate_instance.name := "Gate"
gate_instance.position := Vector3(0, 3.0, 0)
gate_instance.material_override := preload("res://assets/materials.palettes.painted_metal_tres")
add_child(gate_instance)

# Gate posts
for side in [-1, 1]:
	var post_mesh := CylinderMesh.new()
	post_mesh.top_radius := 0.2
	post_mesh.bottom_radius := 0.2
	post_mesh.height := 6.5
	post_mesh.radial_segments := 6

	var post_instance := MeshInstance3D.new()
	post_instance.mesh := post_mesh
	post_instance.name := "Post_%d" % side
	post_instance.position := Vector3(side * 1.5, 3.0, 0)
	post_instance.material_override := preload("res://assets/materials.palettes.painted_metal_tres")
	add_child(post_instance)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(3.4, 6.2, 0.5)
collision.shape := shape
collision.position := Vector3(0, 3.0, 0)
add_child(collision)

# Interaction distance
func interact() -> void:
	print("Opening gate...")