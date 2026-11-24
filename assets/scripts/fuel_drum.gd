extends StaticBody3D

func _ready() -> void:
	# Fuel Drum: 45gal drum, taller and thinner than barrel
	var drum_height := 1.1
	var drum_diameter := 0.35
	
	var mesh := CylinderMesh.new()
	mesh.top_radius := drum_diameter
	mesh.bottom_radius := drum_diameter
	mesh.height := drum_height
	mesh.radial_segments := 8
	
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh := mesh
	mesh_instance.name := "DrumBody"
	mesh_instance.position := Vector3(0, drum_height * 0.5, 0)
	
	# Fuel color (red/orange)
	var material := StandardMaterial3D.new()
	material.albedo_color := Color(0.6, 0.2, 0.1)
	material.roughness := 0.7
	mesh_instance.material_override := material
	add_child(mesh_instance)
	
# Chime/visual rings
for i in range(4):
	var ring_mesh := CylinderMesh.new()
	ring_mesh.top_radius := drum_diameter * 1.15
	ring_mesh.bottom_radius := drum_diameter * 1.15
	ring_mesh.height := 0.05
	ring_mesh.radial_segments := 8
	
	var ring_instance := MeshInstance3D.new()
	ring_instance.mesh := ring_mesh
	ring_instance.name := "DrumRing%d" % i
	ring_instance.position := Vector3(0, drum_height * 0.25 * (i + 1), 0)
	ring_instance.material_override := material
	add_child(ring_instance)

var collision := CollisionShape3D.new()
var shape := CapsuleShape3D.new()
shape.radius := drum_diameter
shape.height := drum_height
collision.shape := shape
collision.position := Vector3(0, drum_height * 0.5, 0)
add_child(collision)