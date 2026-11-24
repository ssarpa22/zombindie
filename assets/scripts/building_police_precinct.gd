extends StaticBody3D

func _ready() -> void:
	# Police Precinct: local police department
	
	# Foundation
	var foundation := Floor_Slab.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Precinct wings
var wall1 := Wall_2x1.Instance()
wall1.name = "Wall_FRONT"
wall1.position := Vector3(0, 1.5, 0)
add_child(wall1)

var wall2 := Wall_2x1.Instance()
wall2.name = "Wall_BACK"
wall2.position := Vector3(0, 1.5, -12)
add_child(wall2)

var wall3 := Wall_1x1.Instance()
wall3.name = "Wall_SIDE"
wall3.position := Vector4(4, 1.5, -4)
add_child(wall3)

# Roof
var roof := Roof_Parapet.Instance()
roof.name = "Roof"
roof.position := Vector3(0, 3.5, 0)
add_child(roof)

# Entry
var door := Door_Security.Instance()
door.name = "Door_ENTRANCE"
door.position := Vector3(0, 1.1, -8)
add_child(door)

# Holding cell window (special)
var win := Opening_Boarded_Window.Instance()
win.name = "Window_BOARDED"
win.position := Vector3(2, 0.75, -3)
add_child(win)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(10, 6, 8)
collision.shape := shape
collision.position := Vector3(0, 3, 0)
add_child(collision)