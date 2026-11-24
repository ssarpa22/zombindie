extends StaticBody3D

func _ready() -> void:
	# Bus Terminal: intercity bus station
	
	# Foundation
	var foundation := Floor_Slab.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Terminal wings
var wall1 := Wall_4x1.Instance()
wall1.name = "Wall_FRONT"
wall1.position := Vector3(0, 1.5, 0)
add_child(wall1)

var wall2 := Wall_4x1.Instance()
wall2.name = "Wall_BACK"
wall2.position := Vector3(0, 1.5, -20)
add_child(wall2)

var wall3 := Wall_2x1.Instance()
wall3.name = "Wall_WING"
wall3.position := Vector3(-8, 1.5, -6)
add_child(wall3)

# Roof
var roof := Roof_Industrial.Instance()
roof.name = "Roof"
roof.position := Vector3(0, 5.0, 0)
add_child(roof)

# Bus berths (visual)
for i in range(5):
	var berth_mesh := BoxMesh.new()
	berth_mesh.size := Vector3(3.0, 0.1, 5.0)
	var berth_instance := MeshInstance3D.new()
	berth_instance.mesh := berth_mesh
	berth_instance.name := "BusBerth_%d" % i
	berth_instance.position := Vector3(i * 3.5, 0.05, -3)
	berth_instance.material_override := preload("res://assets/materials/palettes.asphalt_tres")
	add_child(berth_instance)

# Entry
var door := Door_DoubleEntrance.Instance()
door.name = "Door_ENTRANCE"
door.position := Vector3(0, 1.1, -8)
add_child(door)

# Information desk
var desk_mesh := BoxMesh.new()
desk_mesh.size := Vector3(2.0, 0.8, 1.0)
var desk_instance := MeshInstance3D.new()
desk_instance.mesh := desk_mesh
desk_instance.name := "InformationDesk"
desk_instance.position := Vector3(0, 0.5, -3)
desk_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
add_child(desk_instance)

# Windows
for i in range(6):
	var win := Opening_Industrial_Window.Instance()
	win.name := "Window_%d" % i
	win.position := Vector3(-3 + i * 2, 0.9, -4)
	add_child(win)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(22, 8, 22)
collision.shape := shape
collision.position := Vector3(0, 5, 0)
add_child(collision)