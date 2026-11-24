extends StaticBody3D

func _ready() -> void:
	# Theater: performance building
	
	# Foundation
	var foundation := Floor_Slab.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Theater wings
var wall1 := Wall_4x1.Instance()
wall1.name = "Wall_FRONT"
wall1.position := Vector3(0, 1.5, 0)
add_child(wall1)

var wall2 := Wall_4x1.Instance()
wall2.name = "Wall_BACK"
wall2.position := Vector3(0, 1.5, -15)
add_child(wall2)

var wall3 := Wall_2x1.Instance()
wall3.name = "Wall_SIDE"
wall3.position := Vector3(-6, 1.5, -5)
add_child(wall3)

# Theater roof with marquee
var roof := Roof_Parapet.Instance()
roof.name = "Roof"
roof.position := Vector3(0, 4.0, 0)
add_child(roof)

# Theater sign
var sign_mesh := BoxMesh.new()
sign_mesh.size := Vector3(1.0, 0.3, 0.1)
var sign_instance := MeshInstance3D.new()
sign_instance.mesh := sign_mesh
sign_instance.name := "TheaterSign"
sign_instance.position := Vector3(0, 3.5, -1)
sign_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
add_child(sign_instance)

# Entry door
var door := Door_DoubleEntrance.Instance()
door.name = "Door_ENTRANCE"
door.position := Vector3(0, 1.1, -7)
add_child(door)

# Windows
for i in range(5):
	var win := Opening_Industrial_Window.Instance()
	win.name := "Window_%d" % i
	win.position := Vector3(-2 + i * 2, 0.9, -3)
	add_child(win)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(20, 6, 12)
collision.shape := shape
collision.position := Vector3(0, 3, 0)
add_child(collision)