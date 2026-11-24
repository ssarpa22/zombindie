extends StaticBody3D

func _ready() -> void:
	# Observation Deck: high-up platform with views
	
	# Foundation
	var foundation := Floor_Slab.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Observation deck
var deck_mesh := BoxMesh.new()
deck_mesh.size := Vector3(8.0, 0.5, 8.0)
var deck_instance := MeshInstance3D.new()
deck_instance.mesh := deck_mesh
deck_instance.name := "ObservationDeck"
deck_instance.position := Vector3(0, 4.0, 0)
deck_instance.material_override := preload("res://assets/materials.palettes.painted_metal_tres")
add_child(deck_instance)

# Railing
for side in [-1, 1]:
	var railing_mesh := BoxMesh.new()
	railing_mesh.size := Vector3(0.5, 3.0, 8.0)
	var railing_instance := MeshInstance3D.new()
	railing_instance.mesh := railing_mesh
	railing_instance.name := "Railing_%d" % (side == -1 and 1 or 2)
	railing_instance.position := Vector3(side * 4, 3.5, 0)
	railing_instance.material_override := preload("res://assets/materials.palettes.painted_metal_tres")
	add_child(railing_instance)

# Telescope (visual)
var telescope_mesh := CylinderMesh.new()
telescope_mesh.top_radius := 0.2
telescope_mesh.bottom_radius := 0.2
telescope_mesh.height := 2.0
telescope_mesh.radial_segments := 6

var telescope_instance := MeshInstance3D.new()
telescope_instance.mesh := telescope_mesh
telescope_instance.name := "Telescope"
telescope_instance.position := Vector3(0, 4.5, 0)
telescope_instance.material_override := preload("res://assets/materials.palettes.metal_tres")
add_child(telescope_instance)

# Entry
var door := Door_Apartment.Instance()
door.name = "Door_ENTRANCE"
door.position := Vector3(0, 1.1, -1)
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
shape.size := Vector3(8, 5, 8)
collision.shape := shape
collision.position := Vector3(0, 3, 0)
add_child(collision)