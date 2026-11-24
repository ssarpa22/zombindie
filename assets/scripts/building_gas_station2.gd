extends StaticBody3D

func _ready() -> void:
	# Gas Station 2: additional variant
	
	# Foundation
	var foundation := Floor_Slab.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Gas station wings
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
wall3.position := Vector3(3, 1.5, -3)
add_child(wall3)

# Roof
var roof := Roof_Industrial.Instance()
roof.name = "Roof"
roof.position := Vector3(0, 4.0, 0)
add_child(roof)

# Pump islands (visual)
for i in range(3):
	var island_mesh := BoxMesh.new()
	island_mesh.size := Vector3(3.0, 0.1, 3.0)
	island_instance := MeshInstance3D.new()
	island_instance.mesh := island_mesh
	island_instance.name := "Island_%d" % i
	island_instance.position := Vector3(i * 3.5, 0.05, -2)
	island_instance.material_override := preload("res://assets/materials.palettes.asphalt_tres")
	add_child(island_instance)

# Fuel pumps (visual)
for i in range(3):
	var pump_mesh := BoxMesh.new()
	pump_mesh.size := Vector3(0.5, 1.5, 0.5)
	pump_instance := MeshInstance3D.new()
	pump_instance.mesh := pump_mesh
	pump_instance.name := "Pump_%d" % i
	pump_instance.position := Vector3(i * 1.5, 0.75, -1)
	pump_instance.material_override := preload("res://assets/materials.palettes.metal_tres")
	add_child(pump_instance)

# Entry
var door := Door_Garage_Roller.Instance()
door.name = "Door_ENTRANCE"
door.position := Vector3(0, 1.1, -3)
add_child(door)

# Window
var win := Opening_Industrial_Window.Instance()
win.name = "Window"
win.position := Vector3(-0.5, 0.9, -1)
add_child(win)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(6, 5, 5)
collision.shape := shape
collision.position := Vector3(0, 3, 0)
add_child(collision)