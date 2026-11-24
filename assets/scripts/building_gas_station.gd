extends StaticBody3D

func _ready() -> void:
	# Gas Station: fuel station with shop
	
	# Foundation slab
	var foundation := Floor_Slab.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Pump islands (visual)
for i in range(3):
	var island_mesh := BoxMesh.new()
	island_mesh.size := Vector3(2.0, 0.1, 2.0)
	var island_instance := MeshInstance3D.new()
	island_instance.mesh := island_mesh
	island_instance.name := "Island_%d" % i
	island_instance.position := Vector3(i * 3.0, 0.05, 0)
	island_instance.material_override := preload("res://assets/materials/palettes.asphalt_tres")
	add_child(island_instance)

# Fuel pumps
for i in range(3):
	var pump_mesh := BoxMesh.new()
	pump_mesh.size := Vector3(0.3, 2.0, 0.3)
	var pump_instance := MeshInstance3D.new()
	pump_instance.mesh := pump_mesh
	pump_instance.name := "Pump_%d" % i
	pump_instance.position := Vector3(i * 3.0 + 1.5, 1.0, 0)
	pump_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(pump_instance)

# canopy roof
var roof := Roof_Awning.Instance()
roof.name = "Roof"
roof.position := Vector3(0, 3.0, 0)
add_child(roof)

# Shop front
var wall1 := Wall_Corner.Instance()
wall1.name = "Wall_FRONT"
wall1.position := Vector3(0, 1.5, 0)
add_child(wall1)

var wall2 := Wall_1x1.Instance()
wall2.name = "Wall_SIDE"
wall2.position := Vector3(0, 1.5, -5)
add_child(wall2)

# Shop door
var door := Door_Apartment.Instance()
door.name = "Door_SHOP"
door.position := Vector3(-1, 1.1, -3)
add_child(door)

# Shop window
var win := Opening_Shopfront_Glazing.Instance()
win.name = "Window_SHOP"
win.position := Vector3(0, 0, -3)
add_child(win)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(6, 6, 6)
collision.shape := shape
collision.position := Vector3(0, 3, 0)
add_child(collision)