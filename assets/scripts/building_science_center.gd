extends StaticBody3D

func _ready() -> void:
	# Science Center: educational and research facility
	
	# Foundation
	var foundation := Floor_Slab.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Science center wings
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

# Roof
var roof := Roof_Pitched.Instance()
roof.name = "Roof"
roof.position := Vector3(0, 3.5, 0)
add_child(roof)

# Exhibition areas
for i in range(3):
	var area_mesh := BoxMesh.new()
	area_mesh.size := Vector3(4.0, 2.0, 3.0)
	var area_instance := MeshInstance3D.new()
	area_instance.mesh := area_mesh
	area_instance.name := "Exhibit_%d" % i
	area_instance.position := Vector3(i * 5, 1.0, -3)
	area_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(area_instance)

# Entry
var door := Door_DoubleEntrance.Instance()
door.name = "Door_ENTRANCE"
door.position := Vector3(0, 1.1, -5)
add_child(door)

# Large windows
for i in range(4):
	var win := Opening_Industrial_Window.Instance()
	win.name := "Window_%d" % i
	win.position := Vector3(-2 + i * 2, 0.9, -3)
	add_child(win)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(16, 6, 12)
collision.shape := shape
collision.position := Vector3(0, 3, 0)
add_child(collision)