extends StaticBody3D

func _ready() -> void:
	# Pharmacy: drugstore with prescription area
	
	# Foundation
	var foundation := Floor_Slab.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Pharmacy wings
var wall1 := Wall_2x1.Instance()
wall1.name = "Wall_FRONT"
wall1.position := Vector3(0, 1.5, 0)
add_child(wall1)

var wall2 := Wall_2x1.Instance()
wall2.name = "Wall_BACK"
wall2.position := Vector3(0, 1.5, -8)
add_child(wall2)

var wall3 := Wall_1x1.Instance()
wall3.name = "Wall_SIDE"
wall3.position := Vector3(4, 1.5, -3)
add_child(wall3)

# Pitched roof
var roof := Roof_Pitched.Instance()
roof.name = "Roof"
roof.position := Vector3(0, 3.0, 0)
add_child(roof)

# Pharmacy sign
var sign_mesh := BoxMesh.new()
sign_mesh.size := Vector3(0.5, 0.5, 0.02)
var sign_instance := MeshInstance3D.new()
sign_instance.mesh := sign_mesh
sign_instance.name := "PharmacySign"
sign_instance.position := Vector3(0, 0.5 + 0.25, -2.5)
sign_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
add_child(sign_instance)

# Entry door
var door := Door_Apartment.Instance()
door.name = "Door_ENTRANCE"
door.position := Vector3(0, 1.1, -4)
add_child(door)

# Display window
var win := Opening_Industrial_Window.Instance()
win.name = "Window_DISPLAY"
win.position := Vector3(2, 0.9, -2)
add_child(win)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(8, 6, 8)
collision.shape := shape
collision.position := Vector3(0, 3, 0)
add_child(collision)