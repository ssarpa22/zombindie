extends StaticBody3D

func _ready() -> void:
	# Hospital Bed: standard hospital bed with adjustable sections
	var bed_length := 2.0
	var bed_width := 0.9
	var bed_height := 0.5
	
	# Mattress
	var mattress_mesh := BoxMesh.new()
	mattress_mesh.size := Vector3(bed_length, bed_height, bed_width)
	
	var mattress_instance := MeshInstance3D.new()
	mattress_instance.mesh := mattress_mesh
	mattress_instance.name := "BedMattress"
	mattress_instance.position := Vector3(bed_length * 0.5, bed_height * 0.5, 0)
	
	# Mattress top (slightly different color for comfort)
	var mat_material := StandardMaterial3D.new()
	mat_material.albedo_color := Color(0.95, 0.92, 0.85)
	mat_material.roughness := 0.7
	mattress_instance.material_override := mat_material
	add_child(mattress_instance)
	
# Bed frame
var frame_mesh := BoxMesh.new()
frame_mesh.size := Vector3(bed_length, 0.1, bed_width)

var frame_instance := MeshInstance3D.new()
frame_instance.mesh := frame_mesh
frame_instance.name := "BedFrame"
frame_instance.position := Vector3(bed_length * 0.5, bed_height * 0.5 - 0.05, 0)
frame_instance.material_override := StandardMaterial3D.new()
frame_instance.material_override.albedo_color := Color(0.9, 0.85, 0.8)
frame_instance.material_override.roughness := 0.5
add_child(frame_instance)

# Side rails
for side in [-1, 1]:
	var rail_mesh := BoxMesh.new()
	rail_mesh.size := Vector3(0.1, bed_length * 0.4, 0.1)
	
	var rail_instance := MeshInstance3D.new()
	rail_instance.mesh := rail_mesh
	rail_instance.name := "BedRail_%d" % (side == -1 and 1 or 2)
	rail_instance.position := Vector3(side * bed_length * 0.5 - 0.05, bed_height * 0.5, bed_width * 0.5 + 0.02)
	rail_instance.material_override := StandardMaterial3D.new()
	rail_instance.material_override.albedo_color := Color(0.8, 0.75, 0.7)
	rail_instance.material_override.roughness := 0.5
	add_child(rail_instance)

# Wheels (4)
for pos in [Vector3(-0.4, 0, -0.3), Vector3(0.4, 0, -0.3), Vector3(-0.4, 0, 0.3), Vector3(0.4, 0, 0.3)]:
	var wheel_mesh := CylinderMesh.new()
	wheel_mesh.top_radius := 0.1
	wheel_mesh.bottom_radius := 0.1
	wheel_mesh.height := 0.15
	wheel_mesh.radial_segments := 6
	
	var wheel_instance := MeshInstance3D.new()
	wheel_instance.mesh := wheel_mesh
	wheel_instance.name := "BedWheel"
	wheel_instance.position := pos + Vector3(0, bed_height * 0.075, 0)
	wheel_instance.material_override := StandardMaterial3D.new()
	wheel_instance.material_override.albedo_color := Color(0.3, 0.3, 0.3)
	wheel_instance.material_override.roughness := 1.0
	add_child(wheel_instance)

var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(bed_length, bed_height, bed_width)
collision.shape := shape
collision.position := Vector3(bed_length * 0.5, bed_height * 0.5, 0)
add_child(collision)