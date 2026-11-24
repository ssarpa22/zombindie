extends StaticBody3D

func _ready() -> void:
	# Office Building: commercial office tower
	
	# Foundation
	var foundation := Floor_RaisedFoundation.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Office wings
var wall1 := Wall_4x1.Instance()
wall1.name = "Wall_FRONT"
wall1.position := Vector3(0, 1.5, 0)
add_child(wall1)

var wall2 := Wall_4x1.Instance()
wall2.name = "Wall_BACK"
wall2.position := Vector3(0, 1.5, -20)
add_child(wall2)

var wall3 := Wall_2x1.Instance()
wall3.name = "Wall_WING1"
wall3.position := Vector3(-8, 1.5, -6)
add_child(wall3)

var wall4 := Wall_2x1.Instance()
wall4.name = "Wall_WING2"
wall4.position := Vector3(8, 1.5, -6)
add_child(wall4)

# Glass curtain wall effect with windows
for i in range(8):
	var win := Opening_Industrial_Window.Instance()
	win.name := "Window_%d" % i
	win.position := Vector3(-3 + i * 2.5, 0.9, -4)
	add_child(win)

# Flat roof
var roof := Roof_Flat.Instance()
roof.name = "Roof"
roof.position := Vector3(0, 4.5, 0)
add_child(roof)

# Main entrance
var door := Door_DoubleEntrance.Instance()
door.name = "Door_ENTRANCE"
door.position := Vector3(0, 1.1, -12)
add_child(door)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(24, 7, 22)
collision.shape := shape
collision.position := Vector3(0, 5, 0)
add_child(collision)