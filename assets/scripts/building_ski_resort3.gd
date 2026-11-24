extends StaticBody3D

func _ready() -> void:
	# Ski Resort 3: additional ski resort variant
	
	# Foundation
	var foundation := Floor_RaisedFoundation.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Resort wings
var wall1 := Wall_2x1.Instance()
wall1.name = "Wall_FRONT"
wall1.position := Vector3(0, 1.5, 0)
add_child(wall1)

var wall2 := Wall_2x1.Instance()
wall2.name = "Wall_BACK"
wall2.position := Vector3(0, 1.5, -25)
add_child(wall2)

var wall3 := Wall_1x1.Instance()
wall3.name = "Wall_SIDE"
wall3.position := Vector4(8, 1.5, -8)
add_child(wall3)

# Roof
var roof := Roof_Industrial.Instance()
roof.name = "Roof"
roof.position := Vector3(0, 6.0, 0)
add_child(roof)

# Additional lodge units
for i in range(7):
	var unit_mesh := BoxMesh.new()
	unit_mesh.size := Vector3(3.0, 2.5, 3.0)
	var unit_instance := MeshInstance3D.new()
	unit_instance.mesh := unit_mesh
	unit_instance.name := "ResortUnit_%d" % i
	unit_instance.position := Vector3(i * 3, 1.25, -2)
	unit_instance.material_override := preload("res://assets/materials.palettes.painted_metal_tres")
	add_child(unit_instance)

# Ski lift visual (simplified)
var lift_mesh := BoxMesh.new()
lift_mesh.size := Vector2(2.0, 8.0)
var lift_instance := MeshInstance3D.new()
lift_instance.mesh := lift_mesh
lift_instance.name := "SkiLift3"
lift_instance.position := Vector3(0, 4.0, -5)
lift_instance.material_override := preload("res://assets/materials.palettes.painted_metal_tres")
add_child(lift_instance)

# Entry
var door := Door_Apartment.Instance()
door.name = "Door_ENTRANCE"
door.position := Vector3(0, 1.1, -5)
add_child(door)

# Windows
for i in range(5):
	var win := Opening_Apartment_Window.Instance()
	win.name := "Window_%d" % i
	win.position := Vector3(-1 + i * 2, 0.75, -3)
	add_child(win)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(25, 8, 18)
collision.shape := shape
collision.position := Vector3(0, 5, 0)
add_child(collision)