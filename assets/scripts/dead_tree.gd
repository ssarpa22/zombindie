extends StaticBody3D

func _ready() -> void:
	# Dead Tree: leafless tree for forest variety
	var trunk_height := 4.0
	var trunk_radius := 0.25
	
# Trunk
var trunk_mesh := CylinderMesh.new()
trunk_mesh.top_radius := trunk_radius
trunk_mesh.bottom_radius := trunk_radius
trunk_mesh.height := trunk_height
trunk_mesh.radial_segments := 6

var trunk_instance := MeshInstance3D.new()
trunk_instance.mesh := trunk_mesh
trunk_instance.name := "DeadTrunk"
trunk_instance.position := Vector3(0, trunk_height * 0.5, 0)
trunk_instance.material_override := preload("res://assets/materials/palettes.wood_tres")
add_child(trunk_instance)

# Dead branches (horizontal)
for side in [-1, 1]:
	for i in range(3):
		var branch_mesh := BoxMesh.new()
		branch_mesh.size := Vector3(trunk_radius * 1.5, 0.1, trunk_radius * 0.5)
		
		var branch_instance := MeshInstance3D.new()
		branch_instance.mesh := branch_mesh
		branch_instance.name := "DeadBranch_%d_%d" % (side == -1 and 1 or 2, i)
		branch_instance.position := Vector3(
			0,
			trunk_height * 0.5 + 0.5 + i * 0.5,
			side * (trunk_radius * 1.0)
		)
		branch_instance.rotation.z := PI / 2.0
		branch_instance.material_override := preload("res://assets/materials/palettes.wood_tres")
		add_child(branch_instance)

var collision := CollisionShape3D.new()
var shape := CapsuleShape3D.new()
shape.radius := trunk_radius
shape.height := trunk_height
collision.shape := shape
collision.position := Vector3(0, trunk_height * 0.5, 0)
add_child(collision)