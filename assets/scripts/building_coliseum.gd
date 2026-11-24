extends StaticBody3D

func _ready() -> void:
	# Colosseum: ancient arena
	
	# Foundation
	var foundation := Floor_Slab.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Colosseum wings
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

# Arena floor
var floor_mesh := BoxMesh.new()
floor_mesh.size := Vector3(40, 0.1, 30)
var floor_instance := MeshInstance3D.new()
floor_instance.mesh := floor_mesh
floor_instance.name := "ArenaFloor"
floor_instance.position := Vector3(0, 0.05, 0)
floor_instance.material_override := preload("res://assets/materials/palettes.sand_tres")
add_child(floor_instance)

# Entry gates
var door1 := Door_DoubleEntrance.Instance()
door1.name = "Door_GATE1"
door1.position := Vector3(-8, 1.1, -6)
add_child(door1)

var door2 := Door_DoubleEntrance.Instance()
door2.name = "Door_GATE2"
door2.position := Vector3(8, 1.1, -6)
add_child(door2)

# Windows (archway style)
for i in range(8):
	var win := Opening_Industrial_Window.Instance()
	win.name := "Window_%d" % i
	win.position := Vector3(-3 + i * 2, 0.9, -4)
	add_child(win)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(50, 8, 35)
collision.shape := shape
collision.position := Vector3(0, 5, 0)
add_child(collision)