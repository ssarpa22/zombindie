extends StaticBody3D

func _ready() -> void:
	# Bed/rest spot: reusable bed entity
	
# Bed frame
var frame_mesh := BoxMesh.new()
frame_mesh.size := Vector3(2.0, 0.5, 1.0)
var frame_instance := MeshInstance3D.new()
frame_instance.mesh := frame_mesh
frame_instance.name := "BedFrame"
frame_instance.position := Vector3(0, 0.25, 0)
frame_instance.material_override := preload("res://assets/materials.palettes.wood_tres")
add_child(frame_instance)

# Mattress
var mattress_mesh := BoxMesh.new()
mattress_mesh.size := Vector3(2.0, 0.2, 1.0)
var mattress_instance := MeshInstance3D.new()
mattress_instance.mesh := mattress_mesh
mattress_instance.name := "Mattress"
mattress_instance.position := Vector3(0, 0.1, 0)
mattress_instance.material_override := StandardMaterial3D.new()
mattress_instance.material_override.albedo_color := Color(0.8, 0.8, 0.8)
add_child(mattress_instance)

# Pillow
var pillow_mesh := BoxMesh.new()
pillow_mesh.size := Vector3(0.5, 0.2, 0.3)
var pillow_instance := MeshInstance3D.new()
pillow_instance.mesh := pillow_mesh
pillow_instance.name := "Pillow"
pillow_instance.position := Vector3(0.5, 0.4, 0.2)
pillow_instance.material_override := StandardMaterial3D.new()
pillow_instance.material_override.albedo_color := Color(1.0, 1.0, 1.0)
add_child(pillow_instance)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(2.0, 1.0, 1.0)
collision.shape := shape
collision.position := Vector3(0, 0.5, 0)
add_child(collision)

# Interaction distance
func interact() -> void:
	print("Resting in bed...")