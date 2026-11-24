extends StaticBody3D

func _ready() -> void:
	# Bed 2: additional bed variant
	
	# Bed frame
	var frame_mesh := BoxMesh.new()
	frame_mesh.size := Vector3(2.0, 0.5, 1.0)
	frame_instance := MeshInstance3D.new()
	frame_instance.mesh := frame_mesh
	frame_instance.name := "BedFrame"
	frame_instance.position := Vector3(0, 0.25, 0)
	frame_instance.material_override := preload("res://assets/materials.palettes.wood_tres")
	add_child(frame_instance)

# Mattress (visual)
var mattress_mesh := BoxMesh.new()
mattress_mesh.size := Vector3(2.0, 0.2, 1.0)
mattress_instance := MeshInstance3D.new()
mattress_instance.mesh := mattress_mesh
mattress_instance.name := "Mattress"
mattress_instance.position := Vector3(0, 0.1, 0)
mattress_instance.material_override := StandardMaterial3D.new()
mattress_instance.material_override.albedo_color := Color(0.8, 0.8, 0.8)
mattress_instance.material_override.roughness := 0.8
add_child(mattress_instance)

# Pillow (visual)
var pillow_mesh := BoxMesh.new()
pillow_mesh.size := Vector3(0.5, 0.2, 0.3)
pillow_instance := MeshInstance3D.new()
pillow_instance.mesh := pillow_mesh
pillow_instance.name := "Pillow"
pillow_instance.position := Vector3(0.5, 0.4, 0.2)
pillow_instance.material_override := StandardMaterial3D.new()
pillow_instance.material_override.albedo_color := Color(1.0, 1.0, 1.0)
add_child(pillow_instance)

# Nightstand (visual)
var nightstand_mesh := BoxMesh.new()
nightstand_mesh.size := Vector3(1.0, 1.5, 0.5)
nightstand_instance := MeshInstance3D.new()
nightstand_instance.mesh := nightstand_mesh
nightstand_instance.name := "Nightstand"
nightstand_instance.position := Vector3(-0.8, 0.75, 0.5)
nightstand_instance.material_override := preload("res://assets/materials.palettes.painted_metal_tres")
add_child(nightstand_instance)

# Lamp (visual)
var lamp_mesh := BoxMesh.new()
lamp_mesh.size := Vector3(0.3, 2.0, 0.3)
lamp_instance := MeshInstance3D.new()
lamp_instance.mesh := lamp_mesh
lamp_instance.name := "BedLamp"
lamp_instance.position := Vector3(0.8, 2.0, 0.5)
lamp_instance.material_override := StandardMaterial3D.new()
lamp_instance.material_override.emission_enabled := true
lamp_instance.material_override.emission := Color(1.0, 0.8, 0.5)
add_child(lamp_instance)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(2.0, 1.0, 1.0)
collision.shape := shape
collision.position := Vector3(0, 0.5, 0)
add_child(collision)