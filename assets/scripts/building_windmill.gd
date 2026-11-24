extends StaticBody3D

func _ready() -> void:
	# Windmill: agricultural power generation
	
	# Foundation
	var foundation := Floor_Slab.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Windmill structure
var tower_mesh := CylinderMesh.new()
tower_mesh.top_radius := 0.5
tower_mesh.bottom_radius := 0.5
tower_mesh.height := 10.0
tower_mesh.radial_segments := 6

var tower_instance := MeshInstance3D.new()
tower_instance.mesh := tower_mesh
tower_instance.name := "WindmillTower"
tower_instance.position := Vector3(0, 5.0, 0)
tower_instance.material_override := preload("res://assets/materials.palettes.painted_metal_tres")
add_child(tower_instance)

# Sails (visual)
for i in range(4):
	var sail_mesh := BoxMesh.new()
	sail_mesh.size := Vector3(0.5, 3.0, 0.2)
	var sail_instance := MeshInstance3D.new()
	sail_instance.mesh := sail_mesh
	sail_instance.name := "Sail_%d" % i
	sail_instance.position := Vector3(
		sin(i * PI / 2) * 2.5,
		1.5,
		cos(i * PI / 2) * 2.5
	)
	sail_instance.material_override := preload("res://assets/materials.palettes.painted_metal_tres")
	add_child(sail_instance)

# Central post
var post_mesh := CylinderMesh.new()
post_mesh.top_radius := 0.2
post_mesh.bottom_radius := 0.2
post_mesh.height := 1.0
post_mesh.radial_segments := 6

var post_instance := MeshInstance3D.new()
post_instance.mesh := post_mesh
post_instance.name := "WindmillPost"
post_instance.position := Vector3(0, 0.5, 0)
post_instance.material_override := preload("res://assets/materials.palettes.painted_metal_tres")
add_child(post_instance)

# Entry
var door := Door_Apartment.Instance()
door.name = "Door_ENTRANCE"
door.position := Vector3(0, 1.1, -1)
add_child(door)

# Windows (small, near base)
for i in range(2):
	var win_mesh := BoxMesh.new()
	win_mesh.size := Vector3(0.5, 0.8, 0.2)
	var win_instance := MeshInstance3D.new()
	win_instance.mesh := win_mesh
	win_instance.name := "WindmillWindow_%d" % i
	win_instance.position := Vector3(0, 1.0, -0.5 + i * 0.3)
	win_instance.material_override := preload("res://assets/materials.palettes.painted_metal_tres")
	add_child(win_instance)

# Collision
var collision := CollisionShape3D.new()
var shape := CapsuleShape3D.new()
shape.radius := 0.5
shape.height := 5.0
collision.shape := shape
collision.position := Vector3(0, 2.5, 0)
add_child(collision)