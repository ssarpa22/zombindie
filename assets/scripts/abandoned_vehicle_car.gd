extends StaticBody3D

func _ready() -> void:
	# Abandoned car: wrecked vehicle
	var car_length := 4.0
	var car_width := 1.8
	var car_height := 1.2
	
	# Car body
	var body_mesh := BoxMesh.new()
	body_mesh.size := Vector3(car_length, car_height, car_width)
	
	var body_instance := MeshInstance3D.new()
	body_instance.mesh := body_mesh
	body_instance.name := "CarBody"
	body_instance.position := Vector3(car_length * 0.5, car_height * 0.5, 0)
	
	# Dilapidated color (muddy, rusty)
	var material := StandardMaterial3D.new()
	material.albedo_color := Color(0.3, 0.3, 0.25)
	material.roughness := 0.9
	body_instance.material_override := material
	add_child(body_instance)
	
# Broken window (front left)
	var window_mesh := BoxMesh.new()
	window_mesh.size := Vector3(0.5, 0.3, 0.05)
	var window_instance := MeshInstance3D.new()
	window_instance.mesh := window_mesh
	window_instance.name := "CarWindow_FL"
	window_instance.position := Vector3(-0.8, car_height * 0.5 - 0.05, car_width * 0.45 + 0.025)
	window_instance.material_override := preload("res://assets/materials/palettes.glass_tres")
	add_child(window_instance)
	
# Missing bumper (visual gap)
var bumper_gap := BoxMesh.new()
bumper_gap.size := Vector3(0.5, 0.1, 0.1)
var bumper_gap_instance := MeshInstance3D.new()
bumper_gap_instance.mesh := bumper_gap
bumper_gap_instance.name := "CarBumperGap"
bumper_gap_instance.position := Vector3(car_length * 0.5 - 0.8, car_height * 0.1, 0)
bumper_gap_instance.material_override := preload("res://assets/materials/palettes.metal_tres")
add_child(bumper_gap_instance)

# Flat tire visualization (deflated)
var tire_mesh := CylinderMesh.new()
tire_mesh.top_radius := 0.4
tire_mesh.bottom_radius := 0.2 # deflated
tire_mesh.height := 0.2
tire_mesh.radial_segments := 8

for wheel_pos in [Vector3(-1.0, 0, -0.8), Vector3(1.0, 0, -0.8), Vector3(-1.0, 0, 0.8), Vector3(1.0, 0, 0.8)]:
	var tire_instance := MeshInstance3D.new()
	tire_instance.mesh := tire_mesh
	tire_instance.name := "CarTire_%d" % wheel_pos.hash()
	tire_instance.position := wheel_pos + Vector3(0, car_height * 0.1, 0)
	tire_instance.material_override := preload("res://assets/materials/palettes.metal_tres")
	add_child(tire_instance)

var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(car_length, car_height, car_width)
collision.shape := shape
collision.position := Vector3(car_length * 0.5, car_height * 0.5, 0)
add_child(collision)