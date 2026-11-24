extends StaticBody3D

func _ready() -> void:
	# Light fixture: reusable light entity
	
# Fixture base
var fixture_mesh := BoxMesh.new()
fixture_mesh.size := Vector3(0.5, 0.5, 0.5)
var fixture_instance := MeshInstance3D.new()
fixture_instance.mesh := fixture_mesh
fixture_instance.name := "Fixture"
fixture_instance.position := Vector3(0, 0.25, 0)
fixture_instance.material_override := preload("res://assets/materials.palettes.painted_metal_tres")
add_child(fixture_instance)

# Light bulb
var bulb_mesh := SphereMesh.new()
bulb_mesh.radius := 0.2
bulb_mesh.subdivisions_around := 12
bulb_mesh.subdivisions_up := 12

var bulb_instance := MeshInstance3D.new()
bulb_instance.mesh := bulb_mesh
bulb_instance.name := "Bulb"
bulb_instance.position := Vector3(0, 0.5, 0)
bulb_instance.material_override := StandardMaterial3D.new()
bulb_instance.material_override.emission_enabled := true
bulb_instance.material_override.emission := Color(1.0, 0.9, 0.8)
bulb_instance.material_override.emission_energy_multiplier := 2.0
add_child(bulb_instance)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(0.6, 0.6, 0.6)
collision.shape := shape
collision.position := Vector3(0, 0, 0)
add_child(collision)

# Interaction distance
func interact() -> void:
	print("Light toggled...")