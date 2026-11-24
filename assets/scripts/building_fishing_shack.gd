extends StaticBody3D

func _ready() -> void:
	# Fishing Shack: lakeside fishing hut
	
	# Foundation
	var foundation := Floor_Slab.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Fishing shack
var wall1 := Wall_1x1.Instance()
wall1.name = "Wall_FRONT"
wall1.position := Vector3(0, 1.5, 0)
add_child(wall1)

var wall2 := Wall_1x1.Instance()
wall2.name = "Wall_BACK"
wall2.position := Vector3(0, 1.5, -4)
add_child(wall2)

var wall3 := Wall_1x1.Instance()
wall3.name = "Wall_SIDE"
wall3.position := Vector3(2, 1.5, -2)
add_child(wall3)

# Roof
var roof := Roof_Flat.Instance()
roof.name = "Roof"
roof.position := Vector3(0, 3.0, 0)
add_child(roof)

# Fishing equipment (visual)
var rod_mesh := BoxMesh.new()
rod_mesh.size := Vector3(0.1, 2.0, 0.1)
var rod_instance := MeshInstance3D.new()
rod_instance.mesh := rod_mesh
rod_instance.name := "FishingRod"
rod_instance.position := Vector3(0, 1.5, -0.5)
rod_instance.material_override := preload("res://assets/materials/palettes.wood_tres")
add_child(rod_instance)

# Creel (basket)
var creel_mesh := BoxMesh.new()
creel_mesh.size := Vector3(0.5, 0.5, 0.5)
var creel_instance := MeshInstance3D.new()
creel_instance.mesh := creel_mesh
creel_instance.name := "Creel"
creel_instance.position := Vector3(-0.5, 0.5, -1)
creel_instance.material_override := preload("res://assets/materials/palettes.wood_tres")
add_child(creel_instance)

# Entry
var door := Door_Apartment.Instance()
door.name = "Door_ENTRANCE"
door.position := Vector3(0, 1.1, -1)
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