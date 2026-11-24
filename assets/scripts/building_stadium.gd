extends StaticBody3D

func _ready() -> void:
	# Stadium: sports stadium
	
	# Foundation
	var foundation := Floor_RaisedFoundation.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Stadium wings
var wall1 := Wall_4x1.Instance()
wall1.name = "Wall_FRONT"
wall1.position := Vector3(0, 1.5, 0)
add_child(wall1)

var wall2 := Wall_4x1.Instance()
wall2.name = "Wall_BACK"
wall2.position := Vector3(0, 1.5, -25)
add_child(wall2)

var wall3 := Wall_2x1.Instance()
wall3.name = "Wall_WING"
wall3.position := Vector3(-10, 1.5, -8)
add_child(wall3)

# Stadium roof
var roof := Roof_Industrial.Instance()
roof.name = "Roof"
roof.position := Vector3(0, 8.0, 0)
add_child(roof)

# Field marker
var field_mesh := BoxMesh.new()
field_mesh.size := Vector3(50, 0.1, 30)
var field_instance := MeshInstance3D.new()
field_instance.mesh := field_mesh
field_instance.name := "Field"
field_instance.position := Vector3(0, 0.05, 0)
field_instance.material_override := preload("res://assets/materials/palettes.green_grass_tres")
add_child(field_instance)

# Entry gates
var door1 := Door_DoubleEntrance.Instance()
door1.name = "Door_GATE1"
door1.position := Vector3(-8, 1.1, -6)
add_child(door1)

var door2 := Door_DoubleEntrance.Instance()
door2.name = "Door_GATE2"
door2.position := Vector3(8, 1.1, -6)
add_child(door2)

# Windows
for i in range(8):
	var win := Opening_Industrial_Window.Instance()
	win.name := "Window_%d" % i
	win.position := Vector3(-3 + i * 3, 0.9, -5)
	add_child(win)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(55, 10, 35)
collision.shape := shape
collision.position := Vector3(0, 6, 0)
add_child(collision)