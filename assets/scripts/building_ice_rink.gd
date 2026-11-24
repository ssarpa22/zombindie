extends StaticBody3D

func _ready() -> void:
	# Ice Rink: indoor skating facility
	
	# Foundation
	var foundation := Floor_Slab.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Ice rink wings
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
wall3.position := Vector4(5, 1.5, -5)
add_child(wall3)

# Ice surface (visual)
var ice_mesh := BoxMesh.new()
ice_mesh.size := Vector3(20.0, 0.05, 10.0)
var ice_instance := MeshInstance3D.new()
ice_instance.mesh := ice_mesh
ice_instance.name := "IceSurface"
ice_instance.position := Vector3(0, 0.025, 0)
ice_instance.material_override := preload("res://assets/materials/palettes.cyan_ice_tres")
add_child(ice_instance)

# Boards around rink
for i in range(4):
	var board_mesh := BoxMesh.new()
	board_mesh.size := Vector3(20.0, 0.2, 0.1)
	var board_instance := MeshInstance3D.new()
	board_instance.mesh := board_mesh
	board_instance.name := "Rail_%d" % i
	board_instance.position := Vector3(0, 0.2 + i * 0.2, 5.1)
	board_instance.material_override := preload("res://assets/materials/palettes.wood_tres")
	add_child(board_instance)

# Entry
var door := Door_Apartment.Instance()
door.name = "Door_ENTRANCE"
door.position := Vector3(0, 1.1, -4)
add_child(door)

# Windows
for i in range(3):
	var win := Opening_Apartment_Window.Instance()
	win.name := "Window_%d" % i
	win.position := Vector3(-1 + i * 2, 0.75, -3)
	add_child(win)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(20.0, 3.0, 10.5)
collision.shape := shape
collision.position := Vector3(0, 1.5, 0)
add_child(collision)