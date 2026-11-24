extends StaticBody3D

func _ready() -> void:
	# Lighthouse 2: additional lighthouse variant
	
	# Foundation
	var foundation := Floor_Slab.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Lighthouse tower
var tower_mesh := CylinderMesh.new()
tower_mesh.top_radius := 0.3
tower_mesh.bottom_radius := 0.3
tower_mesh.height := 12.0
tower_mesh.radial_segments := 6

var tower_instance := MeshInstance3D.new()
tower_instance.mesh := tower_mesh
tower_instance.name := "LighthouseTower2"
tower_instance.position := Vector3(0, 6.0, 0)
tower_instance.material_override := preload("res://assets/materials.palettes.painted_metal_tres")
add_child(tower_instance)

# Lantern room
var lantern_mesh := BoxMesh.new()
lantern_mesh.size := Vector3(3, 1, 3)
var lantern_instance := MeshInstance3D.new()
lantern_instance.mesh := lantern_mesh
lantern_instance.name := "LanternRoom2"
lantern_instance.position := Vector3(0, 6.5, 0)
lantern_instance.material_override := preload("res://assets/materials.palettes.glass_tres")
add_child(lantern_instance)

# Light beam (emissive)
var beam_mesh := CylinderMesh.new()
beam_mesh.top_radius := 0.1
beam_mesh.bottom_radius := 0.1
beam_mesh.height := 6.0
beam_mesh.radial_segments := 6

var beam_instance := MeshInstance3D.new()
beam_instance.mesh := beam_mesh
beam_instance.name := "LightBeam2"
beam_instance.position := Vector3(0, 7.0, 0)
beam_instance.rotation.z := PI / 2.0
var mat := StandardMaterial3D.new()
mat.emission_enabled := true
mat.emission := Color(0.8, 0.8, 1.0)
mat.emission_energy_multiplier := 2.0
beam_instance.material_override := mat
add_child(beam_instance)

# Entry
var door := Door_Security.Instance()
door.name = "Door_ENTRANCE"
door.position := Vector3(0, 1.1, -1)
add_child(door)

# Windows (small, near base)
for i in range(2):
	var win_mesh := BoxMesh.new()
	win_mesh.size := Vector3(0.5, 0.8, 0.2)
	var win_instance := MeshInstance3D.new()
	win_instance.mesh := win_mesh
	win_instance.name := "LighthouseWindow2_%d" % i
	win_instance.position := Vector3(0, 1.0, -0.5 + i * 0.3)
	win_instance.material_override := preload("res://assets/materials.palettes.painted_metal_tres")
	add_child(win_instance)

# Collision
var collision := CollisionShape3D.new()
var shape := CapsuleShape3D.new()
shape.radius := 0.3
shape.height := 6.0
collision.shape := shape
collision.position := Vector3(0, 3.0, 0)
add_child(collision)