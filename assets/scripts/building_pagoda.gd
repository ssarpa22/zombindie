extends StaticBody3D

func _ready() -> void:
	# Pagoda: Asian-style temple
	
	# Foundation
	var foundation := Floor_Slab.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Pagoda tiers
for i in range(5):
	var tier_mesh := BoxMesh.new()
	tier_mesh.size := Vector3(3.0, 1.0, 3.0)
	var tier_instance := MeshInstance3D.new()
	tier_instance.mesh := tier_mesh
	tier_instance.name := "Tier_%d" % i
	tier_instance.position := Vector3(0, 1.0 + i * 1.2, -i * 2)
	tier_instance.material_override := preload("res://assets/materials.palettes.painted_metal_tres")
	add_child(tier_instance)

# Entry
var door := Door_Apartment.Instance()
door.name = "Door_ENTRANCE"
door.position := Vector3(0, 1.1, -3)
add_child(door)

# Windows
for i in range(2):
	var win := Opening_Apartment_Window.Instance()
	win.name := "Window_%d" % i
	win.position := Vector3(-1 + i * 2, 0.75, -1)
	add_child(win)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(3, 5, 3)
collision.shape := shape
collision.position := Vector3(0, 3, 0)
add_child(collision)