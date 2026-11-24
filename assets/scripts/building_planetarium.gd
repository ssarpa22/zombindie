extends StaticBody3D

func _ready() -> void:
	# Planetarium: astronomy education
	
	# Foundation
	var foundation := Floor_Slab.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Planetarium wings
var wall1 := Wall_1x1.Instance()
wall1.name = "Wall_FRONT"
wall1.position := Vector3(0, 1.5, 0)
add_child(wall1)

var wall2 := Wall_1x1.Instance()
wall2.name = "Wall_BACK"
wall2.position := Vector3(0, 1.5, -8)
add_child(wall2)

var wall3 := Wall_1x1.Instance()
wall3.name = "Wall_SIDE"
wall3.position := Vector4(3, 1.5, -3)
add_child(wall3)

# Dome (simplified as half-sphere using boxes)
for i in range(6):
	var dome_section := BoxMesh.new()
	dome_section.size := Vector3(3.0, 2.0, 3.0)
	var dome_instance := MeshInstance3D.new()
	dome_instance.mesh := dome_section
	dome_instance.name := "DomeSection_%d" % i
	angle := i * PI / 3
	dome_instance.position := Vector3(
		sin(angle) * 4,
		2.0,
		cos(angle) * 4
	)
	dome_instance.rotation.z := angle
	dome_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(dome_instance)

# Entry
var door := Door_Apartment.Instance()
door.name = "Door_ENTRANCE"
door.position := Vector3(0, 1.1, -3)
add_child(door)

# Window (planetarium projection window)
var win := Opening_Apartment_Window.Instance()
win.name = "Window_Projection"
win.position := Vector3(0, 0.75, -2)
add_child(win)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(6, 5, 6)
collision.shape := shape
collision.position := Vector3(0, 2.5, 0)
add_child(collision)