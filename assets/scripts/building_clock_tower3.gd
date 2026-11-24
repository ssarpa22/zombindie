extends StaticBody3D

func _ready() -> void:
	# Clock Tower 3: additional clock tower variant
	
	# Foundation
	var foundation := Floor_Slab.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Tower structure
var tower_mesh := CylinderMesh.new()
tower_mesh.top_radius := 0.5
tower_mesh.bottom_radius := 0.5
tower_mesh.height := 35.0
tower_mesh.radial_segments := 6

var tower_instance := MeshInstance3D.new()
tower_instance.mesh := tower_mesh
tower_instance.name := "ClockTower3"
tower_instance.position := Vector3(0, 17.5, 0)
tower_instance.material_override := preload("res://assets/materials.palettes.painted_metal_tres")
add_child(tower_instance)

# Clock face (visual)
var clock_face := BoxMesh.new()
clock_face.size := Vector3(6.0, 0.5, 6.0)
var clock_face_instance := MeshInstance3D.new()
clock_face_instance.mesh := clock_face
clock_face_instance.name := "ClockFace3"
clock_face_instance.position := Vector3(0, 16.0, 0)
clock_face_instance.material_override := preload("res://assets.materials.palettes.painted_metal_tres")
add_child(clock_face_instance)

# Clock hands (visual)
var hour_hand := CylinderMesh.new()
hour_hand.top_radius := 0.1
hour_hand.bottom_radius := 0.1
hour_hand.height := 10.0
hour_hand.radial_segments := 6

var hour_hand_instance := MeshInstance3D.new()
hour_hand_instance.mesh := hour_hand
hour_hand_instance.name := "HourHand3"
hour_hand_instance.position := Vector3(0, 8.0, 0)
hour_hand_instance.material_override := preload("res://assets.materials.palettes.painted_metal_tres")
add_child(hour_hand_instance)

var minute_hand := CylinderMesh.new()
minute_hand.top_radius := 0.1
minute_hand.bottom_radius := 0.1
minute_hand.height := 12.0
minute_hand.radial_segments := 6

var minute_hand_instance := MeshInstance3D.new()
minute_hand_instance.mesh := minute_hand
minute_hand_instance.name := "MinuteHand3"
minute_hand_instance.position := Vector3(0, 9.0, 0)
minute_hand_instance.material_override := preload("res://assets.materials.palettes.painted_metal_tres")
add_child(minute_hand_instance)

# Entry
var door := Door_Apartment.Instance()
door.name = "Door_ENTRANCE"
door.position := Vector3(0, 1.1, -1)
add_child(door)

# Windows (small, near base)
for i in range(2):
	var win_mesh := BoxMesh.new()
	win_mesh.size := Vector3(0.5, 0.8, 0.2)
	var win_instance := MeshInstance3D.new()
	win_instance.mesh := win_mesh
	win_instance.name := "ClockWindow3_%d" % i
	win_instance.position := Vector3(0, 1.0, -0.5 + i * 0.3)
	win_instance.material_override := preload("res://assets.materials.palettes.painted_metal_tres")
	add_child(win_instance)

# Collision
var collision := CollisionShape3D.new()
var shape := CapsuleShape3D.new()
shape.radius := 0.5
shape.height := 35.0
collision.shape := shape
collision.position := Vector3(0, 17.5, 0)
add_child(collision)