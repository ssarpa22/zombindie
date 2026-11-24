extends StaticBody3D

func _ready() -> void:
	# Vending machine: snack/ drink machine
	var machine_width := 0.5
	var machine_height := 1.8
	var machine_depth := 0.5
	
	var mesh := BoxMesh.new()
	mesh.size := Vector3(machine_width, machine_height, machine_depth)
	
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh := mesh
	mesh_instance.name := "VendingMachine"
	mesh_instance.position := Vector3(machine_width * 0.5, machine_height * 0.5, 0)
	mesh_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(mesh_instance)
	
# Coin slot
var coin_slot_mesh := BoxMesh.new()
coin_slot_mesh.size := Vector3(0.05, 0.1, 0.05)

var coin_slot_instance := MeshInstance3D.new()
coin_slot_instance.mesh := coin_slot_mesh
coin_slot_instance.name := "CoinSlot"
coin_slot_instance.position := Vector3(0, machine_height * 0.25 - 0.025, machine_depth * 0.45 - 0.025)
coin_slot_instance.material_override := preload("res://assets/materials/palettes.metal_tres")
add_child(coin_slot_instance)

# Product selection buttons
for i in range(4):
	var button_mesh := BoxMesh.new()
	button_mesh.size := Vector3(0.08, 0.03, 0.02)
	
	var button_instance := MeshInstance3D.new()
	button_instance.mesh := button_mesh
	button_instance.name := "SelectButton%d" % i
	button_instance.position := Vector3(0, machine_height * 0.4 + i * 0.15 - 0.3, machine_depth * 0.45 - 0.03)
	button_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(button_instance)

# Money return hatch
var return_mesh := BoxMesh.new()
return_mesh.size := Vector3(0.2, 0.05, 0.1)

var return_instance := MeshInstance3D.new()
return_instance.mesh := return_mesh
return_instance.name := "MoneyReturn"
return_instance.position := Vector3(0, machine_height * 0.1, machine_depth * 0.45 - 0.025)
return_instance.material_override := preload("res://assets/materials/palettes.metal_tres")
add_child(return_instance)

var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(machine_width, machine_height, machine_depth)
collision.shape := shape
collision.position := Vector3(machine_width * 0.5, machine_height * 0.5, 0)
add_child(collision)