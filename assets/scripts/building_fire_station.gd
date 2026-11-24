extends StaticBody3D

func _ready() -> void:
	# Fire Station: emergency services building
	
	# Foundation
	var foundation := Floor_RaisedFoundation.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Fire station wings
var wall1 := Wall_4x1.Instance()
wall1.name = "Wall_FRONT"
wall1.position := Vector3(0, 1.5, 0)
add_child(wall1)

var wall2 := Wall_4x1.Instance()
wall2.name = "Wall_BACK"
wall2.position := Vector3(0, 1.5, -12)
add_child(wall2)

var wall3 := Wall_2x1.Instance()
wall3.name = "Wall_WING"
wall3.position := Vector3(-6, 1.5, -4)
add_child(wall3)

# Monitor roof with tower
var roof := Roof_Industrial.Instance()
roof.name = "Roof"
roof.position := Vector3(0, 4.0, 0)
add_child(roof)

# Fire equipment garage doors
var door1 := Door_Garage_Roller.Instance()
door1.name = "Door_GARAGE1"
door1.position := Vector3(-3, 1.1, -4)
add_child(door1)

var door2 := Door_Garage_Roller.Instance()
door2.name = "Door_GARAGE2"
door2.position := Vector3(3, 1.1, -4)
add_child(door2)

# Fire pole visual (simplified)
var pole_mesh := CylinderMesh.new()
pole_mesh.top_radius := 0.1
pole_mesh.bottom_radius := 0.1
pole_mesh.height := 3.0
pole_mesh.radial_segments := 6

var pole_instance := MeshInstance3D.new()
pole_instance.mesh := pole_mesh
pole_instance.name := "FirePole"
pole_instance.position := Vector3(0, 1.5, 0)
pole_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
add_child(pole_instance)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(16, 8, 14)
collision.shape := shape
collision.position := Vector3(0, 4, 0)
add_child(collision)