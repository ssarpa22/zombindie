extends StaticBody3D

func _ready() -> void:
	# Duplex: two-unit building
	
	# Foundation
	var foundation := Floor_Slab.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Mirror layout: two 1x1 wings with shared wall
var wall1 := Wall_1x1.Instance()
wall1.name = "Wall_LEFT"
wall1.position := Vector3(-3, 1.5, 0)
add_child(wall1)

var wall2 := Wall_1x1.Instance()
wall2.name = "Wall_RIGHT"
wall2.position := Vector3(3, 1.5, 0)
add_child(wall2)

var wall3 := Wall_1x1.Instance()
wall3.name = "Wall_BACK"
wall3.position := Vector3(0, 1.5, -6)
add_child(wall3)

# Shared wall in middle
var wall4 := Wall_1x1.Instance()
wall4.name = "Wall_SHARED"
wall4.position := Vector3(0, 1.5, -3)
add_child(wall4)

# Roof
var roof := Roof_Flat.Instance()
roof.name = "Roof"
roof.position := Vector3(0, 3.0, 0)
add_child(roof)

# Two entrances
var door1 := Door_Apartment.Instance()
door1.name = "Door_LEFT"
door1.position := Vector3(-3, 1.1, -6.1)
add_child(door1)

var door2 := Door_Apartment.Instance()
door2.name = "Door_RIGHT"
door2.position := Vector3(3, 1.1, -6.1)
add_child(door2)

# Windows
for i in range(3):
	var win := Opening_Apartment_Window.Instance()
	win.name := "Window_%d" % i
	win.position := Vector3(-2 + i * 2, 0.75, -3)
	add_child(win)

var win2 := Opening_Apartment_Window.Instance()
win2.name := "Window_%d" % (i + 3)
win2.position := Vector3(2 + i * 2 - 4, 0.75, -3)
add_child(win2)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(7, 6, 8)
collision.shape := shape
collision.position := Vector3(0, 3, 0)
add_child(collision)