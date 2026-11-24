extends StaticBody3D

func _ready() -> void:
	# Tree fall roots: exposed root system from fallen tree
	var root_length := 1.5
	var root_width := 0.2
	
# Root system going outward
for i in range(6):
	var root_angle := i * PI / 3.0
	var root_end := root_length * 0.7
	
	var root_mesh := BoxMesh.new()
	root_mesh.size := Vector3(root_width * 0.5, root_length * 0.3, root_width * 0.5)
	
	var root_instance := MeshInstance3D.new()
	root_instance.mesh := root_mesh
	root_instance.name := "TreeRoot_%d" % i
	root_instance.position := Vector3(
		root_end * sin(root_angle),
		root_length * 0.15,
		root_end * cos(root_angle)
	)
	root_instance.rotation.z := root_angle
	root_instance.material_override := preload("res://assets/materials/palettes.dirt_tres")
	add_child(root_instance)

# Root collar at base
var collar_mesh := BoxMesh.new()
collar_mesh.size := Vector3(root_width * 3, root_width * 0.5, root_width * 3)

var collar_instance := MeshInstance3D.new()
collar_instance.mesh := collar_mesh
collar_instance.name := "TreeRootCollar"
collar_instance.position := Vector3(0, root_width * 0.25, 0)
collar_instance.material_override := preload("res://assets/materials/palettes.dirt_tres")
add_child(collar_instance)

var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(root_length, root_width * 0.5 + 0.2, root_length)
collision.shape := shape
collision.position := Vector3(root_length * 0.5, root_width * 0.25, 0)
add_child(collision)