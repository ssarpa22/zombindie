extends StaticBody3D

func _ready() -> void:
	# Fallen Log: fallen tree log on the forest floor
	var log_length := 2.5
	var log_diameter := 0.3
	
	var mesh := CylinderMesh.new()
	mesh.top_radius := log_diameter
	mesh.bottom_radius := log_diameter
	mesh.height := log_length
	mesh.radial_segments := 6
	
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh := mesh
	mesh_instance.name := "FallenLog"
	mesh_instance.position := Vector3(log_length * 0.5, log_diameter * 0.5, 0)
	mesh_instance.material_override := preload("res://assets/materials/palettes.wood_tres")
	add_child(mesh_instance)
	
# Root end roots (visible)
for i in range(3):
	var root_mesh := BoxMesh.new()
	root_mesh.size := Vector3(log_diameter * 0.3, log_diameter * 0.3, log_length * 0.3)
	
	var root_instance := MeshInstance3D.new()
	root_instance.mesh := root_mesh
	root_instance.name := "LogRoot_%d" % i
	root_instance.position := Vector3(
		-log_length * 0.4,
		log_diameter * 0.2,
		-log_length * 0.3 + i * 0.4
	)
	root_instance.material_override := preload("res://assets/materials/palettes.dirt_tres")
	add_child(root_instance)

var collision := CollisionShape3D.new()
var shape := CapsuleShape3D.new()
shape.radius := log_diameter
shape.height := log_length
collision.shape := shape
collision.position := Vector3(log_length * 0.5, log_diameter * 0.5, 0)
add_child(collision)