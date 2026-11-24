extends StaticBody3D

func _ready() -> void:
	# City Hall: municipal government building
	
	# Foundation
	var foundation := Floor_RaisedFoundation.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# City hall wings
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

# Roof with tower
var roof := Roof_Industrial.Instance()
roof.name = "Roof"
roof.position := Vector3(0, 5.0, 0)
add_child(roof)

# Clock tower visual
var tower_mesh := CylinderMesh.new()
tower_mesh.top_radius := 0.3
tower_mesh.bottom_radius := 0.3
tower_mesh.height := 8.0
tower_mesh.radial_segments := 6

var tower_instance := MeshInstance3D.new()
tower_instance.mesh := tower_mesh
tower_instance.name := "ClockTower"
tower_instance.position := Vector3(0, 4.0, 0)
tower_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
add_child(tower_instance)

# Entry
var door := Door_Security.Instance()
door.name = "Door_ENTRANCE"
door.position := Vector3(0, 1.1, -8)
add_child(door)

# Windows
for i in range(4):
	var win := Opening_Industrial_Window.Instance()
	win.name := "Window_%d" % i
	win.position := Vector3(-2 + i * 2, 0.9, -3)
	add_child(win)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(20, 8, 12)
collision.shape := shape
collision.position := Vector3(0, 5, 0)
add_child(collision)