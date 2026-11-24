extends StaticBody3D

func _ready() -> void:
	# Aquarium: marine life display
	
	# Foundation
	var foundation := Floor_Slab.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Aquarium wings
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
wall3.position := Vector4(4, 1.5, -4)
add_child(wall3)

# Aquarium tank (visual)
var tank_mesh := BoxMesh.new()
tank_mesh.size := Vector3(5.0, 3.0, 3.0)
var tank_instance := MeshInstance3D.new()
tank_instance.mesh := tank_mesh
tank_instance.name := "AquariumTank"
tank_instance.position := Vector3(0, 1.5, 0)
tank_instance.material_override := StandardMaterial3D.new()
tank_instance.material_override.albedo_color := Color(0.1, 0.2, 0.5)
tank_instance.material_override.roughness := 0.8
add_child(tank_instance)

# Fish (visual - simplified)
for i in range(3):
	var fish_mesh := BoxMesh.new()
	fish_mesh.size := Vector3(0.3, 0.1, 0.5)
	var fish_instance := MeshInstance3D.new()
	fish_instance.mesh := fish_mesh
	fish_instance.name := "Fish_%d" % i
	fish_instance.position := Vector3(
		(cos(i * 2 * PI / 3) * 1.5),
		1.8,
		(sin(i * 2 * PI / 3) * 1.5)
	)
	fish_instance.material_override := StandardMaterial3D.new()
	fish_instance.material_override.albedo_color := Color(1.0, 0.5, 0.0)
	fish_instance.material_override.roughness := 0.8
	add_child(fish_instance)

# Entry
var door := Door_Apartment.Instance()
door.name = "Door_ENTRANCE"
door.position := Vector3(0, 1.1, -3)
add_child(door)

# Large viewing windows
for i in range(2):
	var win := Opening_Industrial_Window.Instance()
	win.name := "Window_%d" % i
	win.position := Vector3(-1 + i * 2, 0.9, -2)
	add_child(win)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(8, 5, 6)
collision.shape := shape
collision.position := Vector3(0, 3, 0)
add_child(collision)