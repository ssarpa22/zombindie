extends StaticBody3D

func _ready() -> void:
	# Police Station: law enforcement building
	
	# Foundation
	var foundation := Floor_RaisedFoundation.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Police station wings
var wall1 := Wall_4x1.Instance()
wall1.name = "Wall_FRONT"
wall1.position := Vector3(0, 1.5, 0)
add_child(wall1)

var wall2 := Wall_4x1.Instance()
wall2.name = "Wall_BACK"
wall2.position := Vector3(0, 1.5, -12)
add_child(wall2)

var wall3 := Wall_2x1.Instance()
wall3.name = "Wall_WING"
wall3.position := Vector3(-6, 1.5, -4)
add_child(wall3)

# Pitched roof with parapet
var roof := Roof_Parapet.Instance()
roof.name = "Roof"
roof.position := Vector3(0, 3.5, 0)
add_child(roof)

# Entry door
var door := Door_Security.Instance()
door.name = "Door_ENTRANCE"
door.position := Vector3(0, 1.1, -10)
add_child(door)

# Police signage
var sign := Opening_Warning_Sign.Instance()
sign.name = "Sign_Police"
sign.position := Vector3(0, 0.75, -3)
add_child(sign)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(16, 8, 14)
collision.shape := shape
collision.position := Vector3(0, 4, 0)
add_child(collision)