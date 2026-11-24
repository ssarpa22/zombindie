extends StaticBody3D

func _ready() -> void:
	# Fire extinguisher: portable safety device
	var total_height := 0.55
	var cylinder_radius := 0.08
	
	# Cylinder body
	var body_mesh := CylinderMesh.new()
	body_mesh.top_radius := cylinder_radius
	body_mesh.bottom_radius := cylinder_radius
	body_mesh.height := total_height
	body_mesh.radial_segments := 8
	
	var body_instance := MeshInstance3D.new()
	body_instance.mesh := body_mesh
	body_instance.name := "ExtinguisherBody"
	body_instance.position := Vector3(0, total_height * 0.5, 0)
	
	# Red color with gauge
	var material := StandardMaterial3D.new()
	material.albedo_color := Color(0.9, 0.2, 0.1)
	material.roughness := 0.8
	body_instance.material_override := material
	add_child(body_instance)
	
# Gauge head
var gauge_mesh := BoxMesh.new()
gauge_mesh.size := Vector3(0.1, 0.05, 0.05)

var gauge_instance := MeshInstance3D.new()
gauge_instance.mesh := gauge_mesh
gauge_instance.name := "ExtinguisherGauge"
gauge_instance.position := Vector3(0, total_height - 0.05, 0)
gauge_instance.material_override := preload("res://assets/materials/palettes.metal_tres")
add_child(gauge_instance)

# Hose connection
var hose_mesh := BoxMesh.new()
hose_mesh.size := Vector3(0.04, 0.04, 0.15)

var hose_instance := MeshInstance3D.new()
hose_instance.mesh := hose_mesh
hose_instance.name := "ExtinguisherHose"
hose_instance.position := Vector3(0, 0.05, -0.1)
hose_instance.material_override := preload("res://assets/materials/palettes.metal_tres")
add_child(hose_instance)

var collision := CollisionShape3D.new()
var shape := CapsuleShape3D.new()
shape.radius := cylinder_radius
shape.height := total_height
collision.shape := shape
collision.position := Vector3(0, total_height * 0.5, 0)
add_child(collision)