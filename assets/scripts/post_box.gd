extends StaticBody3D

func _ready() -> void:
	# Post box: street mail collection box
	var box_width := 0.3
	var box_height := 0.8
	var box_depth := 0.2
	
# Box body
var body_mesh := BoxMesh.new()
body_mesh.size := Vector3(box_width, box_height, box_depth)

var body_instance := MeshInstance3D.new()
body_instance.mesh := body_mesh
body_instance.name := "PostBoxBody"
body_instance.position := Vector3(box_width * 0.5, box_height * 0.5, 0)
body_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
add_child(body_instance)

# Slot opening
var slot_mesh := BoxMesh.new()
slot_mesh.size := Vector3(box_width * 0.2, 0.1, box_depth)

var slot_instance := MeshInstance3D.new()
slot_instance.mesh := slot_mesh
slot_instance.name := "PostBoxSlot"
slot_instance.position := Vector3(box_width * 0.5 - box_width * 0.05, box_height * 0.5 - 0.05, box_depth * 0.5 - 0.02)
slot_instance.material_override := preload("res://assets/materials/palettes.metal_tres")
add_child(slot_instance)

# Mail flag
var flag_mesh := BoxMesh.new()
flag_mesh.size := Vector3(0.05, 0.1, 0.02)

var flag_instance := MeshInstance3D.new()
flag_instance.mesh := flag_mesh
flag_instance.name := "PostBoxFlag"
flag_instance.position := Vector3(-box_width * 0.12, box_height * 0.5 - 0.02, box_depth * 0.5)
flag_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
add_child(flag_instance)

var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(box_width, box_height + 0.1, box_depth)
collision.shape := shape
collision.position := Vector3(box_width * 0.5, box_height * 0.5, 0)
add_child(collision)