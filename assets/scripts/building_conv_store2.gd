extends StaticBody3D

func _ready() -> void:
	# Convenience Store 2: additional variant
	
	# Foundation
	var foundation := Floor_Slab.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Store wings
var wall1 := Wall_1x1.Instance()
wall1.name = "Wall_FRONT"
wall1.position := Vector3(0, 1.5, 0)
add_child(wall1)

var wall2 := Wall_1x1.Instance()
wall2.name = "Wall_BACK"
wall2.position := Vector3(0, 1.5, -6)
add_child(wall2)

var wall3 := Wall_1x1.Instance()
wall3.name = "Wall_SIDE"
wall3.position := Vector3(3, 1.5, -3)
add_child(wall3)

# Roof
var roof := Roof_Flat.Instance()
roof.name = "Roof"
roof.position := Vector3(0, 3.0, 0)
add_child(roof)

# Display rack (visual)
for i in range(3):
	var rack_mesh := BoxMesh.new()
	rack_mesh.size := Vector3(0.5, 2.0, 0.5)
	var rack_instance := MeshInstance3D.new()
	rack_instance.mesh := rack_mesh
	rack_instance.name := "Rack_%d" % i
	rack_instance.position := Vector3(i * 0.5, 1.0, -1)
	rack_instance.material_override := preload("res://assets/materials/palettes.wood_tres")
	add_child(rack_instance)

# Entry
var door := Door_Apartment.Instance()
door.name = "Door_ENTRANCE"
door.position := Vector3(0, 1.1, -2)
add_child(door)

# Window
var win := Opening_Apartment_Window.Instance()
win.name = "Window"
win.position := Vector3(-0.5, 0.75, -1)
add_child(win)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(4, 5, 3)
collision.shape := shape
collision.position := Vector3(0, 3, 0)
add_child(collision)