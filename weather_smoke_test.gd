extends Node

func _ready() -> void:
	call_deferred("_run_smoke_test")

func _run_smoke_test() -> void:
	for action in ["move_forward", "move_back", "move_left", "move_right", "sprint", "interact", "flashlight", "inventory", "melee", "guide", "pause"]:
		assert(InputMap.has_action(action), "Falta acción de entrada: %s" % action)
	var menu_scene: PackedScene = load("res://MainMenu.tscn")
	assert(menu_scene != null)
	var menu_instance := menu_scene.instantiate()
	add_child(menu_instance)
	await get_tree().process_frame
	assert(menu_instance.find_children("*", "Button", true, false).size() >= 5)
	menu_instance.queue_free()
	var scene: Node = load("res://Main.tscn").instantiate()
	add_child(scene)
	await get_tree().process_frame
	var weather: Node = scene.find_child("WeatherSystem", true, false)
	if weather == null:
		push_error("No se encontró WeatherSystem en Main.tscn")
		get_tree().quit(1)
		return
	var clouds: Node3D = weather.get("_clouds")
	var stars: Node3D = weather.get("_stars")
	var milky_way: Node3D = weather.get("_milky_way")
	var rain: CPUParticles3D = weather.get("_rain")
	var snow: CPUParticles3D = weather.get("_snow")
	var wind: CPUParticles3D = weather.get("_wind")
	var environment_node: WorldEnvironment = weather.get("world_environment")
	var moon: MeshInstance3D = weather.get("moon_mesh")
	var detail_pack: Node = scene.find_child("ForestAmbientDetailPack", true, false)
	assert(detail_pack != null)
	var detail_count := 0
	for detail_name in ["Ferns", "Rocks", "FallenBranches", "ForestRubble", "Stumps", "Mushrooms"]:
		var batch: MultiMeshInstance3D = detail_pack.get_node(detail_name)
		detail_count += batch.multimesh.instance_count
	assert(detail_count == 2000)
	for mode in range(6):
		weather.call("_set_weather", mode)
		await get_tree().process_frame
		assert(environment_node.environment.fog_enabled == (mode in [1, 3, 4]))
		assert(clouds.visible == (mode >= 2))
		assert(stars.visible == (mode == 0))
		assert(milky_way.visible == (mode == 0))
		assert(moon.visible == (mode != 1))
		assert(rain.emitting == (mode == 3))
		assert(snow.emitting == (mode == 4))
		assert(wind.emitting == (mode == 5))
		if mode == 1:
			assert(is_equal_approx(environment_node.environment.fog_depth_end, 15.0))
	var session: Node = scene.find_child("GameSession", true, false)
	assert(session != null)
	assert(session.hud.get_node_or_null("GameGuide") != null)
	assert(is_equal_approx(session.survival.difficulty_multiplier, 1.0))
	session.world_clock.tick(600.0)
	assert(session.world_clock.daylight_factor > 0.9)
	weather.call("_set_weather", 0)
	assert(not stars.visible)
	assert(session.world_clock.get_node("Daylight").visible)
	session.world_clock.restore({"phase": 0.82})
	weather.call("_set_weather", 0)
	assert(session.player != null and session.survival != null and session.inventory != null)
	assert(session.world != null and session.world_clock != null and session.quests != null)
	var water_pickup: Node
	for pickup in get_tree().get_nodes_in_group("interactables"):
		if pickup.get("item_id") == "water":
			water_pickup = pickup
			break
	assert(water_pickup != null)
	var thirst_before: float = session.survival.thirst
	water_pickup.interact(session.player)
	assert(session.inventory.has_item("water"))
	assert(session.use_item("water"))
	assert(session.survival.thirst > thirst_before)
	var kit_pickup: Node
	var food_pickup: Node
	for pickup in get_tree().get_nodes_in_group("interactables"):
		if pickup.get("item_id") == "medical_kit":
			kit_pickup = pickup
		elif pickup.get("item_id") == "canned_food":
			food_pickup = pickup
	assert(kit_pickup != null and food_pickup != null)
	kit_pickup.interact(session.player)
	food_pickup.interact(session.player)
	assert(session.quests.kit_recovered)
	var trader: Node = scene.find_child("Survivor_Elena", true, false)
	assert(trader != null)
	trader.interact(session.player)
	assert(session.progression.reputation == 3)
	session.world.discover_location("police_station")
	assert(session.quests.completed)
	var infected: Array = get_tree().get_nodes_in_group("zombies")
	assert(not infected.is_empty())
	var xp_before: int = session.progression.experience
	infected[0].take_damage(1000.0, session.player)
	assert(session.quests.zombies_killed == 1)
	assert(session.progression.experience > xp_before)
	session.inventory.add_item("wood_plank", 3)
	session.inventory.add_item("scrap_metal", 1)
	session.player.camera_pivot.rotation.x = deg_to_rad(-45.0)
	assert(session.construction.build_barricade())
	assert(scene.find_child("PlayerBarricade_1", true, false) != null)
	var health_before: float = session.survival.health
	var temp_save_path := "user://zombindie_smoke_save.cfg"
	assert(session.save_service.save_session(session, temp_save_path))
	session.survival.take_damage(25.0)
	assert(session.save_service.load_session(session, temp_save_path))
	assert(is_equal_approx(session.survival.health, health_before))
	var save_dir := DirAccess.open("user://")
	save_dir.remove("zombindie_smoke_save.cfg")
	session.hud.toggle_pause()
	assert(get_tree().paused)
	session.hud.toggle_pause()
	assert(not get_tree().paused)
	print("GAMEPLAY_SMOKE_OK")
	print("WEATHER_SMOKE_OK")
	print("UI_SMOKE_OK")
	get_tree().quit()
