extends StaticBody3D

func _ready() -> void:
	# Dead tree variant: simplified
	
# Trunk
var trunk_mesh := CylinderMesh.new()
trunk_mesh.top_radius := 0.2
trunk_mesh.bottom_radius := 0.2
trunk_mesh.height := 8.0
trunk_mesh.radial_segments := 6

var trunk_instance := MeshInstance3D.new()
trunk_instance.mesh := trunk_mesh
trunk_instance.name := "Trunk"
trunk_instance.position := Vector3(0, 4.0, 0)
trunk_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
add_child(trunk_instance)

# Dead branches (visual)
for i in range(6):
	var branch_mesh := CylinderMesh.new()
	branch_mesh.top_radius := 0.15
	branch_mesh.bottom_radius := 0.05
	branch_mesh.height := 3.0
	branch_mesh.radial_segments := 6

	var branch_instance := MeshInstance3D.new()
	branch_instance.mesh := branch_mesh
	branch_instance.name := "Branch_%d" % i
	branch_instance.position := Vector3(
		sin(i * PI / 3) * 2.0,
		2.0 + i * 0.3,
		cos(i * PI / 3) * 2.0
	)
	branch_instance.rotation.z := i * PI / 3
	branch_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(branch_instance)

# Collision (trunk only)
var collision := CollisionShape3D.new()
var shape := CapsuleShape3D.new()
shape.radius := 0.2
shape.height := 8.0
collision.shape := shape
collision.position := Vector3(0, 4.0, 0)
add_child(collision)