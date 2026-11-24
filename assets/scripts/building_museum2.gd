extends StaticBody3D

func _ready() -> void:
	# Museum 2: additional museum variant
	
	# Foundation
	var foundation := Floor_Slab.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Museum wings
var wall1 := Wall_1x1.Instance()
wall1.name = "Wall_FRONT"
wall1.position := Vector3(0, 1.5, 0)
add_child(wall1)

var wall2 := Wall_1x1.Instance()
wall2.name = "Wall_BACK"
wall2.position := Vector3(0, 1.5, -8)
add_child(wall2)

var wall3 := Wall_1x1.Instance()
wall3.name = "Wall_SIDE"
wall3.position := Vector3(3, 1.5, -3)
add_child(wall3)

# Roof
var roof := Roof_Parapet.Instance()
roof.name = "Roof"
roof.position := Vector3(0, 3.5, 0)
add_child(roof)

# Exhibit areas (visual)
for i in range(3):
	var exhibit_mesh := BoxMesh.new()
	exhibit_mesh.size := Vector3(3.0, 2.0, 1.0)
	var exhibit_instance := MeshInstance3D.new()
	exhibit_instance.mesh := exhibit_mesh
	exhibit_instance.name := "Exhibit_%d" % i
	exhibit_instance.position := Vector3(i * 3.5, 1.0, -2)
	exhibit_instance.material_override := preload("res://assets/materials.palettes.painted_metal_tres")
	add_child(exhibit_instance)

# Entry
var door := Door_DoubleEntrance.Instance()
door.name = "Door_ENTRANCE"
door.position := Vector3(0, 1.1, -4)
add_child(door)

# Windows
for i in range(3):
	var win := Opening_Industrial_Window.Instance()
	win.name := "Window_%d" % i
	win.position := Vector3(-1 + i * 2, 0.9, -2)
	add_child(win)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(6, 6, 8)
collision.shape := shape
collision.position := Vector3(0, 3, 0)
add_child(collision)