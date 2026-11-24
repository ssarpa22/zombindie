extends StaticBody3D

func _ready() -> void:
	# Distribution Center: logistics and warehousing
	
	# Foundation
	var foundation := Floor_Slab.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Distribution wings
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

# Loading dock
var door1 := Door_Garage_Roller.Instance()
door1.name = "Door_DOCK"
door1.position := Vector3(0, 1.1, -5)
add_child(door1)

# Small office wing
var wall5 := Wall_2x1.Instance()
wall5.name = "Wall_OFFICE"
wall5.position := Vector3(-4, 1.5, -3)
add_child(wall5)

# Roof
var roof := Roof_Industrial.Instance()
roof.name = "Roof"
roof.position := Vector3(0, 5.0, 0)
add_child(roof)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(22, 8, 22)
collision.shape := shape
collision.position := Vector3(0, 5, 0)
add_child(collision)