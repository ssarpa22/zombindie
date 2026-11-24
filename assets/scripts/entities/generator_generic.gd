extends StaticBody3D

func _ready() -> void:
	# Generic generator: reusable generator entity
	
# Generator body
var body_mesh := BoxMesh.new()
body_mesh.size := Vector3(2.0, 2.5, 1.5)
body_instance := MeshInstance3D.new()
body_instance.mesh := body_mesh
body_instance.name := "GeneratorBody"
body_instance.position := Vector3(0, 1.25, 0)
body_instance.material_override := preload("res://assets/materials.palettes.metal_tres")
add_child(body_instance)

# Control panel
var panel_mesh := BoxMesh.new()
panel_mesh.size := Vector3(1.0, 1.0, 0.3)
panel_instance := MeshInstance3D.new()
panel_instance.mesh := panel_mesh
panel_instance.name := "ControlPanel"
panel_instance.position := Vector3(0.5, 1.5, 0)
panel_instance.material_override := preload("res://assets/materials.palettes.painted_metal_tres")
add_child(panel_instance)

# Fuel gauge (visual)
var gauge_mesh := BoxMesh.new()
gauge_mesh.size := Vector3(0.3, 0.3, 0.1)
var gauge_instance := MeshInstance3D.new()
gauge_instance.mesh := gauge_mesh
gauge_instance.name := "FuelGauge"
gauge_instance.position := Vector3(-0.8, 1.5, 0)
gauge_instance.material_override := preload("res://assets/materials.palettes.painted_metal_tres")
add_child(gauge_instance)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(2.5, 3.0, 2.0)
collision.shape := shape
collision.position := Vector3(0, 0, 0)
add_child(collision)

# Interaction distance
func interact() -> void:
	print("Interacting with generator...")