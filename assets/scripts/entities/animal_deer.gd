extends StaticBody3D

func _ready() -> void:
	# Deer animal entity
	
# Body
var body_mesh := CylinderMesh.new()
body_mesh.top_radius := 0.8
body_mesh.bottom_radius := 0.8
body_mesh.height := 1.2
body_mesh.radial_segments := 8

var body_instance := MeshInstance3D.new()
body_instance.mesh := body_mesh
body_instance.name := "Body"
body_instance.position := Vector3(0, 0.6, 0)
body_instance.material_override := preload("res://assets/materials.palettes.foliage_tres")
add_child(body_instance)

# Antlers (visual)
for side in [-1, 1]:
	var antler_mesh := CylinderMesh.new()
	antler_mesh.top_radius := 0.2
	antler_mesh.bottom_radius := 0.05
	antler_mesh.height := 1.0
	antler_mesh.radial_segments := 6

	var antler_instance := MeshInstance3D.new()
	antler_instance.mesh := antler_mesh
	antler_instance.name := "Antler_%d" % side
	antler_instance.position := Vector3(side * 0.6, 1.2, -0.3)
	antler_instance.rotation.z := PI / 2
	antler_instance.material_override := preload("res://assets/materials.palettes.foliage_tres")
	add_child(antler_instance)

# Legs (visual)
for leg in [(-1, -0.5), (1, -0.5), (-1, 0.5), (1, 0.5)]:
	var leg_mesh := CylinderMesh.new()
	leg_mesh.top_radius := 0.15
	leg_mesh.bottom_radius := 0.15
	leg_mesh.height := 0.8
	leg_mesh.radial_segments := 6

	var leg_instance := MeshInstance3D.new()
	leg_instance.mesh := leg_mesh
	leg_instance.name := "Leg"
	leg_instance.position := Vector3(leg[0], 0.2, leg[1])
	leg_instance.material_override := preload("res://assets/materials.palettes.foliage_tres")
	add_child(leg_instance)

# Collision
var collision := CollisionShape3D.new()
var shape := CapsuleShape3D.new()
shape.radius := 0.8
shape.height := 1.2
collision.shape := shape
collision.position := Vector3(0, 0, 0)
add_child(collision)