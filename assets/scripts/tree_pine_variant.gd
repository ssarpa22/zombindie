extends StaticBody3D

func _ready() -> void:
	# Pine tree variant: dense foliage
	
# Trunk
var trunk_mesh := CylinderMesh.new()
trunk_mesh.top_radius := 0.3
trunk_mesh.bottom_radius := 0.3
trunk_mesh.height := 12.0
trunk_mesh.radial_segments := 6

var trunk_instance := MeshInstance3D.new()
trunk_instance.mesh := trunk_mesh
trunk_instance.name := "Trunk"
trunk_instance.position := Vector3(0, 6.0, 0)
trunk_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
add_child(trunk_instance)

# Foliage (dense)
for i in range(20):
	var leaf_mesh := SphereMesh.new()
	leaf_mesh.radius := 0.3
	leaf_mesh.subdivisions_around := 8
	leaf_mesh.subdivisions_up := 6

	var leaf_instance := MeshInstance3D.new()
	leaf_instance.mesh := leaf_mesh
	leaf_instance.name := "Leaf_%d" % i
	
	# Distribute leaves around trunk
	angle := i * 2 * PI / 20
	distance := 3.0 + i * 0.2
	leaf_instance.position := Vector3(
		sin(angle) * distance,
		2.0 + i * 0.3,
		cos(angle) * distance
	)
	leaf_instance.rotation.z := angle
	leaf_instance.material_override := preload("res://assets/materials.palettes.foliage_tres")
	add_child(leaf_instance)

# Collision (trunk only)
var collision := CollisionShape3D.new()
var shape := CapsuleShape3D.new()
shape.radius := 0.3
shape.height := 12.0
collision.shape := shape
collision.position := Vector3(0, 6.0, 0)
add_child(collision)