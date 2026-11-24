extends StaticBody3D

func _ready() -> void:
	# Castle: medieval fortress
	
	# Foundation
	var foundation := Floor_RaisedFoundation.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Castle walls
var wall1 := Wall_4x1.Instance()
wall1.name = "Wall_FRONT"
wall1.position := Vector3(0, 1.5, 0)
add_child(wall1)

var wall2 := Wall_4x1.Instance()
wall2.name = "Wall_BACK"
wall2.position := Vector3(0, 1.5, -30)
add_child(wall2)

var wall3 := Wall_2x1.Instance()
wall3.name = "Wall_WING"
wall3.position := Vector3(-10, 1.5, -8)
add_child(wall3)

# Towers at corners
for corner in ["NE", "NW", "SE", "SW"]:
	var tower_mesh := CylinderMesh.new()
	tower_mesh.top_radius := 0.5
	tower_mesh.bottom_radius := 0.5
	tower_mesh.height := 15.0
	tower_mesh.radial_segments := 6

	var tower_instance := MeshInstance3D.new()
	tower_instance.mesh := tower_mesh
	tower_instance.name := "Tower_%s" % corner
	if corner == "NE":
		tower_instance.position := Vector3(10, 7.5, -10)
	elif corner == "NW":
		tower_instance.position := Vector3(-10, 7.5, -10)
	elif corner == "SE":
		tower_instance.position := Vector3(10, 7.5, 10)
	elif corner == "SW":
		tower_instance.position := Vector3(-10, 7.5, 10)
	tower_instance.material_override := preload("res://assets/materials.palettes.painted_metal_tres")
	add_child(tower_instance)

# Gatehouse
var gate_mesh := BoxMesh.new()
gate_mesh.size := Vector3(5.0, 6.0, 0.5)
var gate_instance := MeshInstance3D.new()
gate_instance.mesh := gate_mesh
gate_instance.name := "Gatehouse"
gate_instance.position := Vector3(0, 3.0, 0)
gate_instance.material_override := preload("res://assets/materials.palettes.painted_metal_tres")
add_child(gatehouse_instance)

# Entry
var door := Door_Security.Instance()
door.name = "Door_ENTRANCE"
door.position := Vector3(0, 1.1, -10)
add_child(door)

# Windows (small, near base)
for i in range(4):
	var win_mesh := BoxMesh.new()
	win_mesh.size := Vector3(0.5, 0.8, 0.2)
	var win_instance := MeshInstance3D.new()
	win_instance.mesh := win_mesh
	win_instance.name := "Window_%d" % i
	win_instance.position := Vector3(-2 + i * 2, 1.0, -5)
	win_instance.material_override := preload("res://assets/materials.palettes.painted_metal_tres")
	add_child(win_instance)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(30, 8, 35)
collision.shape := shape
collision.position := Vector3(0, 5, 0)
add_child(collision)