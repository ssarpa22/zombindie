extends StaticBody3D

func _ready() -> void:
	# Bank: financial building
	
	# Foundation
	var foundation := Floor_Slab.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Bank wings
var wall1 := Wall_2x1.Instance()
wall1.name = "Wall_FRONT"
wall1.position := Vector3(0, 1.5, 0)
add_child(wall1)

var wall2 := Wall_2x1.Instance()
wall2.name = "Wall_BACK"
wall2.position := Vector3(0, 1.5, -10)
add_child(wall2)

var wall3 := Wall_1x1.Instance()
wall3.name = "Wall_SIDE"
wall3.position := Vector3(4, 1.5, -4)
add_child(wall3)

# Pitched roof
var roof := Roof_Pitched.Instance()
roof.name = "Roof"
roof.position := Vector3(0, 3.0, 0)
add_child(roof)

# Bank entrance
var door := Door_DoubleEntrance.Instance()
door.name = "Door_ENTRANCE"
door.position := Vector3(0, 1.1, -6)
add_child(door)

# Bank windows
for i in range(3):
	var win := Opening_Industrial_Window.Instance()
	win.name := "Window_%d" % i
	win.position := Vector3(-2 + i * 2, 0.9, -3)
	add_child(win)

# Vault room (visual)
var vault_mesh := BoxMesh.new()
vault_mesh.size := Vector3(3.0, 2.5, 0.5)
var vault_instance := MeshInstance3D.new()
vault_instance.mesh := vault_mesh
vault_instance.name := "Vault"
vault_instance.position := Vector3(0, 1.25, -2)
vault_instance.material_override := preload("res://assets/materials/palettes.concrete_tres")
add_child(vault_instance)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(10, 6, 8)
collision.shape := shape
collision.position := Vector3(0, 3, 0)
add_child(collision)