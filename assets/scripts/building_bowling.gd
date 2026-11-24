extends StaticBody3D

func _ready() -> void:
	# Bowling Alley: entertainment venue
	
	# Foundation
	var foundation := Floor_Slab.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Bowling alley wings
var wall1 := Wall_2x1.Instance()
wall1.name = "Wall_FRONT"
wall1.position := Vector3(0, 1.5, 0)
add_child(wall1)

var wall2 := Wall_2x1.Instance()
wall2.name = "Wall_BACK"
wall2.position := Vector3(0, 1.5, -12)
add_child(wall2)

var wall3 := Wall_1x1.Instance()
wall3.name = "Wall_SIDE"
wall3.position := Vector3(5, 1.5, -4)
add_child(wall3)

# Roof
var roof := Roof_Flat.Instance()
roof.name = "Roof"
roof.position := Vector3(0, 3.5, 0)
add_child(roof)

# Bowling lanes (visual)
for i in range(4):
	var lane_mesh := BoxMesh.new()
	lane_mesh.size := Vector3(1.0, 0.02, 15.0)
	var lane_instance := MeshInstance3D.new()
	lane_instance.mesh := lane_mesh
	lane_instance.name := "BowlingLane_%d" % i
	lane_instance.position := Vector3(0, 0.01, -3 - i * 3)
	lane_instance.material_override := preload("res://assets/materials/palettes.wood_tres")
	add_child(lane_instance)

# Entry
var door := Door_Apartment.Instance()
door.name = "Door_ENTRANCE"
door.position := Vector3(0, 1.1, -5)
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
shape.size := Vector3(10, 5, 20)
collision.shape := shape
collision.position := Vector3(0, 3, 0)
add_child(collision)