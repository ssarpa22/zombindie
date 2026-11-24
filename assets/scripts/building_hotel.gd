extends StaticBody3D

func _ready() -> void:
	# Hotel: multi-story accommodation
	
	# Foundation
	var foundation := Floor_RaisedFoundation.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Hotel wings
var wall1 := Wall_2x1.Instance()
wall1.name = "Wall_FRONT"
wall1.position := Vector3(0, 1.5, 0)
add_child(wall1)

var wall2 := Wall_2x1.Instance()
wall2.name = "Wall_BACK"
wall2.position := Vector3(0, 1.5, -15)
add_child(wall2)

var wall3 := Wall_1x1.Instance()
wall3.name = "Wall_SIDE"
wall3.position := Vector3(5, 1.5, -5)
add_child(wall3)

# Pitched roof with balcony
var roof := Roof_Pitched.Instance()
roof.name = "Roof"
roof.position := Vector3(0, 4.0, 0)
add_child(roof)

# Balcony
var balcony := Exterior_Balcony.Instance()
balcony.name = "Balcony"
balcony.position := Vector3(0, 2.5, -4)
add_child(balcony)

# Entrance
var door := Door_DoubleEntrance.Instance()
door.name = "Door_ENTRANCE"
door.position := Vector3(0, 1.1, -8)
add_child(door)

# Windows
for i in range(5):
	var win := Opening_Industrial_Window.Instance()
	win.name := "Window_%d" % i
	win.position := Vector3(-2 + i * 2, 0.9, -3)
	add_child(win)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(15, 7, 12)
collision.shape := shape
collision.position := Vector3(0, 4, 0)
add_child(collision)