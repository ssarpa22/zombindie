extends StaticBody3D

func _ready() -> void:
	# Barrel: 200L drum
	var barrel_height := 0.9
	var barrel_diameter := 0.45
	
	var mesh := CylinderMesh.new()
	mesh.top_radius := barrel_diameter
	mesh.bottom_radius := barrel_diameter
	mesh.height := barrel_height
	mesh.radial_segments := 8
	
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh := mesh
	mesh_instance.name := "BarrelBody"
	mesh_instance.position := Vector3(0, barrel_height * 0.5, 0)
	
	# Rusty metal color
	var material := StandardMaterial3D.new()
	material.albedo_color := Color(0.4, 0.35, 0.3)
	material.roughness := 0.8
	mesh_instance.material_override := material
	add_child(mesh_instance)
	
# Metal rings
for i in range(5):
	var ring_mesh := CylinderMesh.new()
	ring_mesh.top_radius := barrel_diameter * 1.1
	ring_mesh.bottom_radius := barrel_diameter * 1.1
	ring_mesh.height := 0.05
	ring_mesh.radial_segments := 8
	
	var ring_instance := MeshInstance3D.new()
	ring_instance.mesh := ring_mesh
	ring_instance.name := "BarrelRing%d" % i
	ring_instance.position := Vector3(0, barrel_height * 0.2 * (i + 1), 0)
	ring_instance.material_override := material
	add_child(ring_instance)

var collision := CollisionShape3D.new()
var shape := CapsuleShape3D.new()
shape.radius := barrel_diameter
shape.height := barrel_height
collision.shape := shape
collision.position := Vector3(0, barrel_height * 0.5, 0)
add_child(collision)