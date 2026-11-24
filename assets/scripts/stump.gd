extends StaticBody3D

func _ready() -> void:
	# Stump: tree stump remaining after logging
	var stump_height := 0.5
	var stump_diameter := 0.6
	
	var mesh := CylinderMesh.new()
	mesh.top_radius := stump_diameter
	mesh.bottom_radius := stump_diameter
	mesh.height := stump_height
	mesh.radial_segments := 6
	
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh := mesh
	mesh_instance.name := "Stump"
	mesh_instance.position := Vector3(0, stump_height * 0.5, 0)
	mesh_instance.material_override := preload("res://assets/materials/palettes.wood_tres")
	add_child(mesh_instance)
	
# Moss/ground cover
for i in range(5):
	var moss_mesh := BoxMesh.new()
	moss_mesh.size := Vector3(stump_diameter * 0.4, 0.02, stump_diameter * 0.4)
	
	var moss_instance := MeshInstance3D.new()
	moss_instance.mesh := moss_mesh
	moss_instance.name := "Moss_%d" % i
	moss_instance.position := Vector3(
		(stump_diameter * 0.3) * sin(i * PI / 3),
		stump_height * 0.01,
		(stump_diameter * 0.3) * cos(i * PI / 3)
	)
	moss_instance.material_override := preload("res://assets/materials/palettes.dirt_tres")
	add_child(moss_instance)

var collision := CollisionShape3D.new()
var shape := CapsuleShape3D.new()
shape.radius := stump_diameter
shape.height := stump_height
collision.shape := shape
collision.position := Vector3(0, stump_height * 0.5, 0)
add_child(collision)