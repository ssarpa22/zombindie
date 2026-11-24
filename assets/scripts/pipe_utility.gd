extends StaticBody3D

func _ready() -> void:
	# Utility pipe joint: pipe connection segment
	var pipe_length := 1.0
	var pipe_radius := 0.1
	
# Main pipe segment
var pipe_mesh := CylinderMesh.new()
pipe_mesh.top_radius := pipe_radius
pipe_mesh.bottom_radius := pipe_radius
pipe_mesh.height := pipe_length
pipe_mesh.radial_segments := 6

var pipe_instance := MeshInstance3D.new()
pipe_instance.mesh := pipe_mesh
pipe_instance.name := "UtilityPipe"
pipe_instance.position := Vector3(pipe_length * 0.5, pipe_radius, 0)
pipe_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
add_child(pipe_instance)

# Connection joint (extra mesh at end)
var joint_mesh := CylinderMesh.new()
joint_mesh.top_radius := pipe_radius * 1.5
joint_mesh.bottom_radius := pipe_radius * 1.5
joint_mesh.height := 0.3
joint_mesh.radial_segments := 6

var joint_instance := MeshInstance3D.new()
joint_instance.mesh := joint_mesh
joint_instance.name := "PipeJoint"
joint_instance.position := Vector3(pipe_length + 0.15, pipe_radius + 0.15, 0)
joint_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
add_child(joint_instance)

# Flange bolts (visual)
for i in range(4):
	var bolt_mesh := SphereMesh.new()
	bolt_mesh.radius := 0.03
	
	var bolt_instance := MeshInstance3D.new()
	bolt_instance.mesh := bolt_mesh
	bolt_instance.name := "PipeBolt_%d" % i
	bolt_instance.position := Vector3(
		pipe_length * 0.5 + 0.1,
		pipe_radius + 0.05 + i * 0.1,
		0
	)
	bolt_instance.material_override := preload("res://assets/materials/palettes.metal_tres")
	add_child(bolt_instance)

var collision := CollisionShape3D.new()
var shape := CapsuleShape3D.new()
shape.radius := pipe_radius
shape.height := pipe_length + 0.3
collision.shape := shape
collision.position := Vector3(pipe_length * 0.5, pipe_radius + 0.15, 0)
add_child(collision)