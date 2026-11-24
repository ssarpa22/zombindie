extends StaticBody3D

func _ready() -> void:
	# Newsstand: newspaper and magazine sales
	
	# Foundation
	var foundation := Floor_Slab.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Newsstand
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
wall3.position := Vector2(2, 1.5, -2)
add_child(wall3)

# Roof
var roof := Roof_Flat.Instance()
roof.name = "Roof"
roof.position := Vector3(0, 3.0, 0)
add_child(roof)

# Magazine display rack
var rack_mesh := BoxMesh.new()
rack_mesh.size := Vector3(1.0, 2.0, 0.5)
var rack_instance := MeshInstance3D.new()
rack_instance.mesh := rack_mesh
rack_instance.name := "Rack"
rack_instance.position := Vector3(0, 1.0, -0.5)
rack_instance.material_override := preload("res://assets/materials/palettes.wood_tres")
add_child(rack_instance)

# Newspile visual
for i in range(3):
	var pile_mesh := BoxMesh.new()
	pile_mesh.size := Vector3(0.2, 0.1 * (i + 1), 0.1)
	var pile_instance := MeshInstance3D.new()
	pile_instance.mesh := pile_mesh
	pile_instance.name := "Newspile_%d" % i
	pile_instance.position := Vector3(0.5, 0.1 + i * 0.15, -0.55)
	pile_instance.material_override := StandardMaterial3D.new()
	pile_instance.material_override.albedo_color := Color(0.8, 0.8, 0.8)
	pile_instance.material_override.roughness := 0.8
	add_child(pile_instance)

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
shape.size := Vector3(2, 5, 2)
collision.shape := shape
collision.position := Vector3(0, 3, 0)
add_child(collision)