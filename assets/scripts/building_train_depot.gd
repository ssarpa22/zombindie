extends StaticBody3D

func _ready() -> void:
	# Train Depot: railway maintenance and storage
	
	# Foundation
	var foundation := Floor_Slab.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Depot wings
var wall1 := Wall_4x1.Instance()
wall1.name = "Wall_FRONT"
wall1.position := Vector3(0, 1.5, 0)
add_child(wall1)

var wall2 := Wall_4x1.Instance()
wall2.name = "Wall_BACK"
wall2.position := Vector3(0, 1.5, -20)
add_child(wall2)

var wall3 := Wall_2x1.Instance()
wall3.name = "Wall_WING"
wall3.position := Vector3(-8, 1.5, -6)
add_child(wall3)

# Rail yard (visual)
for i in range(3):
	var track_mesh := BoxMesh.new()
	track_mesh.size := Vector3(1.0, 0.1, 20.0)
	var track_instance := MeshInstance3D.new()
	track_instance.mesh := track_mesh
	track_instance.name := "Rail_%d" % i
	track_instance.position := Vector3(i * 7, 0.05, -5)
	track_instance.material_override := preload("res://assets/materials/palettes.metal_tres")
	add_child(track_instance)

# Maintenance building
var wall4 := Wall_2x1.Instance()
wall4.name = "Wall_MAINT"
wall4.position := Vector3(-6, 1.5, -3)
add_child(wall4)

# Roof
var roof := Roof_Industrial.Instance()
roof.name = "Roof"
roof.position := Vector3(0, 5.0, 0)
add_child(roof)

# Entry
var door := Door_Garage_Roller.Instance()
door.name = "Door_ENTRANCE"
door.position := Vector3(0, 1.1, -5)
add_child(door)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(20, 8, 22)
collision.shape := shape
collision.position := Vector3(0, 5, 0)
add_child(collision)