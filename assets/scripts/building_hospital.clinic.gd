extends StaticBody3D

func _ready() -> void:
	# Clinic: smaller medical building
	
	# Raised foundation
	var foundation := Floor_RaisedFoundation.Instance()
	foundation.name = "Foundation"
	foundation.position = Vector3(0, 0, 0)
	add_child(foundation)
	
# Medical wings
var wall1 := Wall_2x1.Instance()
wall1.name = "Wall_LEFT"
wall1.position := Vector3(-4, 1.5, 0)
add_child(wall1)

var wall2 := Wall_2x1.Instance()
wall2.name = "Wall_RIGHT"
wall2.position := Vector3(4, 1.5, 0)
add_child(wall2)

var wall3 := Wall_1x1.Instance()
wall3.name = "Wall_BACK"
wall3.position := Vector3(0, 1.5, -6)
add_child(wall3)

# Pitched roof
var roof := Roof_Pitched.Instance()
roof.name = "Roof"
roof.position := Vector3(0, 3.0, 0)
add_child(roof)

# Entry door
var door := Door_Apartment.Instance()
door.name = "Door_ENTRANCE"
door.position := Vector3(0, 1.1, -6.1)
add_child(door)

# Windows
for i in range(3):
	var win := Opening_Apartment_Window.Instance()
	win.name := "Window_%d" % i
	win.position := Vector3(-2 + i * 2, 0.75, -3)
	add_child(win)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(9, 6, 8)
collision.shape := shape
collision.position := Vector3(0, 3, 0)
add_child(collision)