extends StaticBody3D

func _ready() -> void:
	# Generic door: reusable door entity
	
	# Door setup
	var door_mesh := BoxMesh.new()
	door_mesh.size := Vector3(2.0, 6.0, 0.2)
	var door_instance := MeshInstance3D.new()
	door_instance.mesh := door_mesh
	door_instance.name := "Door"
	door_instance.position := Vector3(0, 3.0, 0)
	door_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(door_instance)

# Handle
var handle_mesh := CylinderMesh.new()
handle_mesh.top_radius := 0.1
handle_mesh.bottom_radius := 0.1
handle_mesh.height := 1.0
handle_mesh.radial_segments := 6

var handle_instance := MeshInstance3D.new()
handle_instance.mesh := handle_mesh
handle_instance.name := "Handle"
handle_instance.position := Vector3(0.9, 3.0, 0)
handle_instance.material_override := preload("res://assets/materials.palettes.painted_metal_tres")
add_child(handle_instance)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(2.2, 6.2, 0.5)
collision.shape := shape
collision.position := Vector3(0, 3.0, 0)
add_child(collision)

# Interaction distance
func interact() -> void:
	print("Opening door...")