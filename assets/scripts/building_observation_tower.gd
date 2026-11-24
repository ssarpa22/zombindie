extends StaticBody3D

func _ready() -> void:
	# Observation Tower: panoramic view tower
	
	# Foundation
	var foundation := Floor_Slab.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Tower structure
var tower_mesh := CylinderMesh.new()
tower_mesh.top_radius := 0.5
tower_mesh.bottom_radius := 0.5
tower_mesh.height := 20.0
tower_mesh.radial_segments := 6

var tower_instance := MeshInstance3D.new()
tower_instance.mesh := tower_mesh
tower_instance.name := "ObservationTower"
tower_instance.position := Vector3(0, 10.0, 0)
tower_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
add_child(tower_instance)

# Observation deck
var deck_mesh := BoxMesh.new()
deck_mesh.size := Vector3(5.0, 0.5, 5.0)
var deck_instance := MeshInstance3D.new()
deck_instance.mesh := deck_mesh
deck_instance.name := "ObservationDeck"
deck_instance.position := Vector3(0, 5.0, 0)
deck_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
add_child(deck_instance)

# Telescope (visual)
var telescope_mesh := CylinderMesh.new()
telescope_mesh.top_radius := 0.2
telescope_mesh.bottom_radius := 0.2
telescope_mesh.height := 3.0
telescope_mesh.radial_segments := 6

var telescope_instance := MeshInstance3D.new()
telescope_instance.mesh := telescope_mesh
telescope_instance.name := "ObservationTelescope"
telescope_instance.position := Vector3(0, 8.0, 0)
telescope_instance.material_override := preload("res://assets/materials.palettes.metal_tres")
add_child(telescope_instance)

# Entry
var door := Door_Apartment.Instance()
door.name = "Door_ENTRANCE"
door.position := Vector3(0, 1.1, -1)
add_child(door)

# Windows (small, near base)
for i in range(2):
	var win_mesh := BoxMesh.new()
	win_mesh.size := Vector3(0.5, 0.8, 0.2)
	var win_instance := MeshInstance3D.new()
	win_instance.mesh := win_mesh
	win_instance.name := "ObservationWindow_%d" % i
	win_instance.position := Vector3(0, 1.0, -0.5 + i * 0.3)
	win_instance.material_override := preload("res://assets/materials.palettes.painted_metal_tres")
	add_child(win_instance)

# Collision
var collision := CollisionShape3D.new()
var shape := CapsuleShape3D.new()
shape.radius := 0.5
shape.height := 20.0
collision.shape := shape
collision.position := Vector3(0, 10.0, 0)
add_child(collision)