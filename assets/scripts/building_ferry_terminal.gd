extends StaticBody3D

func _ready() -> void:
	# Ferry Terminal: water transportation hub
	
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
wall2.position := Vector3(0, 1.5, -15)
add_child(wall2)

var wall3 := Wall_2x1.Instance()
wall3.name = "Wall_WING"
wall3.position := Vector3(-6, 1.5, -5)
add_child(wall3)

# Roof with lookout
var roof := Roof_Parapet.Instance()
roof.name = "Roof"
roof.position := Vector3(0, 4.0, 0)
add_child(roof)

# Dock area (visual)
for i in range(3):
	var dock_mesh := BoxMesh.new()
	dock_mesh.size := Vector3(3.0, 0.1, 2.0)
	var dock_instance := MeshInstance3D.new()
	dock_instance.mesh := dock_mesh
	dock_instance.name := "Dock_%d" % i
	dock_instance.position := Vector3(i * 4, 0.05, -2)
	dock_instance.material_override := preload("res://assets/materials/palettes.asphalt_tres")
	add_child(dock_instance)

# Entry
var door := Door_DoubleEntrance.Instance()
door.name = "Door_ENTRANCE"
door.position := Vector3(0, 1.1, -5)
add_child(door)

# Large windows
for i in range(3):
	var win := Opening_Industrial_Window.Instance()
	win.name := "Window_%d" % i
	win.position := Vector3(-1 + i * 2, 0.9, -3)
	add_child(win)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(18, 6, 12)
collision.shape := shape
collision.position := Vector3(0, 4, 0)
add_child(collision)