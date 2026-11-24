extends StaticBody3D

func _ready() -> void:
	# Pool Facility: aquatic center
	
	# Foundation
	var foundation := Floor_Slab.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Pool facility wings
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
wall3.position := Vector3(5, 1.5, -5)
add_child(wall3)

# Roof
var roof := Roof_Flat.Instance()
roof.name = "Roof"
roof.position := Vector3(0, 3.5, 0)
add_child(roof)

# Pool area (visual - just the deck area)
for i in range(4):
	var deck_mesh := BoxMesh.new()
	deck_mesh.size := Vector3(5.0, 0.1, 3.0)
	var deck_instance := MeshInstance3D.new()
	deck_instance.mesh := deck_mesh
	deck_instance.name := "PoolDeck_%d" % i
	deck_instance.position := Vector3(i * 5.5, 0.05, -2)
	deck_instance.material_override := preload("res://assets/materials/palettes.asphalt_tres")
	add_child(deck_instance)

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
shape.size := Vector3(15, 5, 12)
collision.shape := shape
collision.position := Vector3(0, 3, 0)
add_child(collision)