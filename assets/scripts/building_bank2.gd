extends StaticBody3D

func _ready() -> void:
	# Bank 2: additional bank variant
	
	# Foundation
	var foundation := Floor_Slab.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Bank wings
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

# Vault door (visual)
var vault_mesh := BoxMesh.new()
vault_mesh.size := Vector3(2.0, 3.0, 0.5)
var vault_instance := MeshInstance3D.new()
vault_instance.mesh := vault_mesh
vault_instance.name := "VaultDoor"
vault_instance.position := Vector3(0, 1.5, -1)
vault_instance.material_override := preload("res://assets/materials.palettes.painted_metal_tres")
add_child(vault_instance)

# Entry
var door := Door_Security.Instance()
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