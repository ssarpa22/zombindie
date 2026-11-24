extends StaticBody3D

func _ready() -> void:
	# Skywalk: elevated pedestrian walkway
	
	# Foundation pads
	var pad1 := Floor_Slab.Instance()
	pad1.name = "Pad1"
	pad1.position := Vector3(-5, 0, 0)
	add_child(pad1)
	
var pad2 := Floor_Slab.Instance()
pad2.name = "Pad2"
pad2.position := Vector3(5, 0, 0)
add_child(pad2)
	
# Walkway structure
var walkway_mesh := BoxMesh.new()
walkway_mesh.size := Vector3(10.0, 0.1, 2.0)
var walkway_instance := MeshInstance3D.new()
walkway_instance.mesh := walkway_mesh
walkway_instance.name := "Skywalk"
walkway_instance.position := Vector3(0, 0.05, 0)
walkway_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
add_child(walkway_instance)

# Railings
for side in [-1, 1]:
	var railing_mesh := BoxMesh.new()
	railing_mesh.size := Vector3(0.1, 1.0, 10.0)
	var railing_instance := MeshInstance3D.new()
	railing_instance.mesh := railing_mesh
	railing_instance.name := "Railing_%d" % (side == -1 and 1 or 2)
	railing_instance.position := Vector3(side * 5, 0.6, 5)
	railing_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(railing_instance)

# Entry points
for pos in [Vector3(-5, 0, 0), Vector3(5, 0, 0)]:
	var door := Door_Apartment.Instance()
	door.name = "Door_ENTRANCE"
	door.position := pos
	add_child(door)

# Windows (between pads)
for i in range(2):
	var win := Opening_Apartment_Window.Instance()
	win.name := "Window_%d" % i
	win.position := Vector3(0, 0.75, -1)
	add_child(win)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(10.0, 1.5, 2.5)
collision.shape := shape
collision.position := Vector3(0, 0.75, 0)
add_child(collision)