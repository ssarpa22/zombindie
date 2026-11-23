extends Node

const SurvivalStatsScript = preload("res://systems/survival_stats.gd")
const InventoryServiceScript = preload("res://systems/inventory_service.gd")
const ProgressionServiceScript = preload("res://systems/progression_service.gd")
const QuestServiceScript = preload("res://systems/quest_service.gd")
const WorldDirectorScript = preload("res://systems/world_director.gd")
const SaveServiceScript = preload("res://systems/save_service.gd")
const WorldClockScript = preload("res://systems/world_clock.gd")
const ConstructionServiceScript = preload("res://systems/construction_service.gd")
const HudScript = preload("res://ui/game_hud.gd")
const ZombieScript = preload("res://entities/zombie_actor.gd")
const LootScript = preload("res://entities/loot_pickup.gd")
const TraderScript = preload("res://entities/trader_npc.gd")
const GuideScript = preload("res://ui/game_guide.gd")

var player: CharacterBody3D
var weather_system: Node
var environment_node: WorldEnvironment
var world_root: Node3D
var survival: Node
var inventory: Node
var progression: Node
var quests: Node
var world: Node
var save_service: Node
var world_clock: Node
var construction: Node
var hud: CanvasLayer
var _event_timer := 210.0
var _random := RandomNumberGenerator.new()
var _death_notified := false

func configure(player_node: CharacterBody3D, weather: Node, world_environment: WorldEnvironment, root: Node3D) -> void:
	player = player_node
	weather_system = weather
	environment_node = world_environment
	world_root = root
	_random.seed = 271828
	_build_services()
	player.set_game_session(self)
	_world_root_setup()
	if GameSettings.continue_requested:
		GameSettings.continue_requested = false
		if not save_service.load_session(self):
			notify("No se pudo cargar la partida guardada.")
			_spawn_initial_entities()
	else:
		_spawn_initial_entities()
	if GameSettings.mode == "challenge":
		survival.difficulty_multiplier = 1.65
		_event_timer = 150.0

func _build_services() -> void:
	survival = SurvivalStatsScript.new()
	survival.name = "SurvivalStats"
	add_child(survival)
	inventory = InventoryServiceScript.new()
	inventory.name = "InventoryService"
	add_child(inventory)
	progression = ProgressionServiceScript.new()
	progression.name = "ProgressionService"
	add_child(progression)
	quests = QuestServiceScript.new()
	quests.name = "QuestService"
	add_child(quests)
	world = WorldDirectorScript.new()
	world.name = "WorldDirector"
	add_child(world)
	world.configure(player, quests)
	world_clock = WorldClockScript.new()
	world_clock.name = "WorldClock"
	add_child(world_clock)
	world_clock.configure(environment_node, weather_system)
	save_service = SaveServiceScript.new()
	save_service.name = "SaveService"
	add_child(save_service)
	construction = ConstructionServiceScript.new()
	construction.name = "ConstructionService"
	add_child(construction)
	construction.configure(self, world_root)
	hud = HudScript.new()
	hud.name = "GameHUD"
	add_child(hud)
	hud.configure(self)
	var guide := GuideScript.new()
	guide.name = "GameGuide"
	hud.add_child(guide)
	inventory.item_added.connect(_on_item_added)
	inventory.changed.connect(hud.refresh)
	survival.changed.connect(hud.refresh)
	progression.changed.connect(hud.refresh)
	quests.changed.connect(hud.refresh)
	world_clock.hour_changed.connect(hud.refresh)
	quests.quest_completed.connect(_on_quest_completed)
	survival.died.connect(_on_player_died)

func _world_root_setup() -> void:
	world_root.add_to_group("game_world")

func _spawn_initial_entities() -> void:
	_spawn_loot("water", 1, Vector3(-4.1, 0.0, 5.5))
	_spawn_loot("canned_food", 2, Vector3(4.2, 0.0, -3.0))
	_spawn_loot("bandage", 1, Vector3(6.1, 0.0, -8.0))
	_spawn_loot("medical_kit", 1, Vector3(3.1, 0.0, -19.0))
	_spawn_loot("wood_plank", 3, Vector3(6.0, 0.0, 224.0))
	_spawn_loot("scrap_metal", 1, Vector3(-5.5, 0.0, 225.0))
	_spawn_zombie(Vector3(0.0, 0.0, -8.4), 0.9)
	_spawn_zombie(Vector3(8.0, 0.0, 42.0), 1.15, "runner")
	var trader := TraderScript.new()
	trader.name = "Survivor_Elena"
	world_root.add_child(trader)
	trader.configure(self, Vector3(7.0, 0.0, 215.0))
	hud.show_notice("Objetivo nuevo: encontrá el botiquín y alcanzá la comisaría.")

func _spawn_loot(item_id: String, amount: int, position: Vector3) -> void:
	var pickup := LootScript.new()
	pickup.configure(self, item_id, amount)
	pickup.position = position
	world_root.add_child(pickup)

func _spawn_zombie(position: Vector3, scale_factor: float, infected_type: String = "walker") -> void:
	var zombie := ZombieScript.new()
	zombie.name = "InfectadoErrante"
	zombie.position = position
	zombie.scale = Vector3.ONE * scale_factor
	world_root.add_child(zombie)
	zombie.configure(self, player, infected_type)

func _process(delta: float) -> void:
	if not is_instance_valid(player) or not is_instance_valid(survival):
		return
	var weather_index := int(weather_system.get("weather_index")) if is_instance_valid(weather_system) else 0
	survival.tick(delta, player.is_sprinting(), weather_index, world.is_outdoors())
	world_clock.tick(delta)
	_event_timer -= delta
	if _event_timer <= 0.0:
		_event_timer = _random.randf_range(240.0, 360.0)
		_trigger_world_event()

func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey and event.pressed and not event.echo):
		return
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	if event.is_action_pressed("save_game"):
			if save_service.save_session(self):
				notify("Partida guardada.")
			get_viewport().set_input_as_handled()
	elif event.is_action_pressed("load_game"):
			if save_service.load_session(self):
				notify("Partida cargada.")
			else:
				notify("Todavía no hay una partida guardada.")
			get_viewport().set_input_as_handled()
	elif event.is_action_pressed("build"):
			construction.build_barricade()
			get_viewport().set_input_as_handled()
	elif event.is_action_pressed("use_water"):
			use_item("water")
	elif event.is_action_pressed("use_food"):
			use_item("canned_food")
	elif event.is_action_pressed("heal"):
			if inventory.has_item("bandage"):
				use_item("bandage")
			else:
				use_item("medical_kit")

func use_item(item_id: String) -> bool:
	if not inventory.has_item(item_id):
		notify("No tenés %s." % item_id.replace("_", " "))
		return false
	if not survival.consume(item_id):
		notify("Ese objeto no se puede usar ahora.")
		return false
	inventory.remove_item(item_id)
	notify("Usaste %s." % item_id.replace("_", " "))
	return true

func notify(message: String) -> void:
	if is_instance_valid(hud):
		hud.show_notice(message)

func try_spend_stamina(amount: float) -> bool:
	return survival.spend_stamina(amount)

func on_loaded() -> void:
	_death_notified = survival.is_dead
	player.set_physics_process(not survival.is_dead)

func emit_noise(position: Vector3, radius: float, noise_kind: String) -> void:
	for zombie in get_tree().get_nodes_in_group("zombies"):
		if is_instance_valid(zombie) and zombie.global_position.distance_to(position) <= radius:
			zombie.hear_noise(position, noise_kind)

func on_zombie_killed(zombie: Node) -> void:
	quests.on_zombie_killed()
	progression.add_experience(25, "combat")
	if _random.randf() < 0.35:
		_spawn_loot("scrap_metal", 1, zombie.global_position + Vector3(0.0, 0.0, 0.5))
	notify("Infectado abatido · +25 XP de combate")

func trade_with_survivor() -> bool:
	if not inventory.has_item("canned_food", 2):
		notify("Elena ofrece una venda a cambio de 2 latas.")
		return false
	if inventory.get_weight() - 0.9 + 0.15 > inventory.carry_capacity:
		notify("No te queda espacio para el intercambio.")
		return false
	inventory.remove_item("canned_food", 2)
	inventory.add_item("bandage", 1)
	progression.reputation += 3
	progression.add_experience(8, "scavenging")
	progression.changed.emit()
	notify("Intercambio hecho · reputación +3")
	return true

func _on_item_added(item_id: String, amount: int) -> void:
	quests.on_item_collected(item_id)
	progression.add_experience(3 * amount, "scavenging")
	var item_name := item_id.replace("_", " ")
	if is_instance_valid(hud):
		hud.show_notice("Recogiste %s × %d" % [item_name, amount])

func _on_quest_completed(_title: String) -> void:
	progression.add_experience(100, "survival")
	notify("Misión completada · +100 XP")

func _on_player_died() -> void:
	if _death_notified:
		return
	_death_notified = true
	notify("Has muerto. Cargá la última partida con F9 o reiniciá la escena.")
	player.set_physics_process(false)

func _trigger_world_event() -> void:
	var active_zombies := get_tree().get_nodes_in_group("zombies").size()
	if active_zombies >= 8:
		return
	var angle := _random.randf_range(0.0, TAU)
	var radius := _random.randf_range(48.0, 72.0)
	var event_position := player.global_position + Vector3(cos(angle) * radius, 0.0, sin(angle) * radius)
	if Vector2(event_position.x, event_position.z).length() > 290.0:
		return
	var night: bool = world_clock.daylight_factor < 0.22
	var infected_type := "brute" if night and _random.randf() < 0.12 else ("runner" if _random.randf() < 0.38 else "walker")
	_spawn_zombie(event_position, _random.randf_range(0.85, 1.2), infected_type)
	notify("Evento ambiental: escuchás pasos y gemidos entre los árboles.")
