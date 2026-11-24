extends Node3D

func _ready() -> void:
	# Asset Library Showroom: organized display of all assets
	
	print("=== Zombindie Asset Library Showroom ===")
	print("Loading asset catalog...")
	
	# This showroom is for browsing and copying assets
	# Each category group has clearly named instances spaced for inspection
	# The showroom is NOT instanced into WorldEditable.tscn
	
	print("Asset Library ready for browsing.")
	print("Use the FileSystem dock to drag and place individual assets.")
	print("Category groups are organized for easy inspection.")
	print("Do not instance the entire showroom into the playable map.")
	print("=========================================")

func register_asset_category(category_name, node_path) -> void:
	# Register an asset category for the showroom
	print("Registering category: %s" % category_name)
	# In a full implementation, this would load and instance assets
	pass

func get_asset_count_by_category() -> Dictionary:
	# Return asset counts by category
	var counts := {}
	return counts