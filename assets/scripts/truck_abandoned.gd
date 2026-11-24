extends StaticBody3D

func _ready() -> void:
	# Abandoned truck: delivery or utility truck
	var truck_length := 6.0
	var truck_width := 2.5
	var truck_height := 2.5
	
	# Truck body
	var body_mesh := BoxMesh.new()
	body_mesh.size := Vector3(truck_length, truck_height, truck_width)
	
	var body_instance := MeshInstance3D.new()
	body_instance.mesh := body_mesh
	body_instance.name := "TruckBody"
	body_instance.position := Vector3(truck_length * 0.5, truck_height * 0.5, 0)
	
	# Dilapidated color
	var material := StandardMaterial3D.new()
	material.albedo_color := Color(0.4, 0.35, 0.3)
	material.roughness := 0.9
	body_instance.material_override := material
	add_child(body_instance)
	
# Rear cargo area back open
var open_mesh := BoxMesh.new()
open_mesh.size := Vector3(1.0, truck_height * 0.8, truck_width)
var open_instance := MeshInstance3D.new()
open_instance.mesh := open_mesh
open_instance.name := "TruckRearOpen"
open_instance.position := Vector3(truck_length - 0.5, truck_height * 0.4, 0)
open_instance.material_override := preload("res://assets/materials/palettes.metal_tres")
add_child(open_instance)

# Missing windshield
var no_glass := BoxMesh.new()
no_glass.size := Vector3(0.5, 0.5, 0.05)
var no_glass_instance := MeshInstance3D.new()
no_glass_instance.mesh := no_glass
no_glass_instance.name := "CarNoWindshield"
no_glass_instance.position := Vector3(truck_length * 0.1, truck_height * 0.5, truck_width * 0.45 + 0.025)
no_glass_instance.material_override := preload("res://assets/materials/palettes.glass_tres")
add_child(no_glass_instance)

# Flat tires
for wheel_pos in [Vector3(-1.2, 0, -1.0), Vector3(1.2, 0, -1.0), Vector3(-1.2, 0, 1.0), Vector3(1.2, 0, 1.0)]:
	var tire_mesh := CylinderMesh.new()
	tire_mesh.top_radius := 0.5
	tire_mesh.bottom_radius := 0.15
	tire_mesh.height := 0.3
	tire_mesh.radial_segments := 8
	
	var tire_instance := MeshInstance3D.new()
	tire_instance.mesh := tire_mesh
	tire_instance.name := "TruckTire_%d" % wheel_pos.hash()
	tire_instance.position := wheel_pos + Vector3(0, truck_height * 0.1, 0)
	tire_instance.material_override := preload("res://assets/materials/palettes.metal_tres")
	add_child(tire_instance)

var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(truck_length, truck_height, truck_width)
collision.shape := shape
collision.position := Vector3(truck_length * 0.5, truck_height * 0.5, 0)
add_child(collision)