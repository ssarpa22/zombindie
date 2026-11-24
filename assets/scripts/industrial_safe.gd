extends StaticBody3D

func _ready() -> void:
	# Safe: combination safe for valuables
	var total_height := 0.8
	var door_width := 0.3
	var door_height := 0.5
	
# Body
var body_mesh := BoxMesh.new()
body_mesh.size := Vector3(0.5, total_height, 0.4)

var body_instance := MeshInstance3D.new()
body_instance.mesh := body_mesh
body_instance.name := "SafeBody"
body_instance.position := Vector3(0, total_height * 0.5, 0)
body_instance.material_override := preload("res://assets/materials/palettes.concrete_tres")
add_child(body_instance)

# Door with combination dial
var door_mesh := BoxMesh.new()
door_mesh.size := Vector3(door_width, door_height, 0.05)

var door_instance := MeshInstance3D.new()
door_instance.mesh := door_mesh
door_instance.name := "SafeDoor"
door_instance.position := Vector3(0, total_height * 0.5 - door_height * 0.5, 0.22)
door_instance.material_override := preload("res://assets/materials/palettes.metal_tres")
add_child(door_instance)

# Dial
var dial_mesh := CylinderMesh.new()
dial_mesh.top_radius := 0.1
dial_mesh.bottom_radius := 0.1
dial_mesh.height := 0.15
dial_mesh.radial_segments := 6

var dial_instance := MeshInstance3D.new()
dial_instance.mesh := dial_mesh
dial_instance.name := "SafeDial"
dial_instance.position := Vector3(0, total_height * 0.5, 0.23)
dial_instance.material_override := preload("res://assets/materials/palettes.metal_tres")
add_child(dial_instance)

var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(0.5, total_height, 0.4)
collision.shape := shape
collision.position := Vector3(0, total_height * 0.5, 0)
add_child(collision)