extends CanvasLayer

const ItemCatalog = preload("res://systems/item_catalog.gd")

var session: Node
var _vitals: Label
var _location: Label
var _objective: Label
var _inventory_panel: PanelContainer
var _inventory_text: Label
var _notice: Label
var _notice_time := 0.0
var _pause_panel: PanelContainer

func configure(game_session: Node) -> void:
	session = game_session
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build_ui()
	_refresh()

func _process(delta: float) -> void:
	if _notice_time > 0.0:
		_notice_time -= delta
		if _notice_time <= 0.0:
			_notice.text = ""

func _build_ui() -> void:
	var root := Control.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(root)
	var panel := PanelContainer.new()
	panel.position = Vector2(14.0, 14.0)
	panel.custom_minimum_size = Vector2(260.0, 0.0)
	root.add_child(panel)
	var stack := VBoxContainer.new()
	stack.add_theme_constant_override("separation", 4)
	panel.add_child(stack)
	_vitals = Label.new()
	stack.add_child(_vitals)
	_location = Label.new()
	stack.add_child(_location)
	_objective = Label.new()
	_objective.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_objective.custom_minimum_size = Vector2(245.0, 0.0)
	stack.add_child(_objective)
	var controls := Label.new()
	controls.text = "E interactuar · clic atacar · H curar · I mochila · B construir · F1 guía · Esc pausa · F5 guardar · F9 cargar"
	controls.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	controls.add_theme_font_size_override("font_size", 11)
	stack.add_child(controls)
	_inventory_panel = PanelContainer.new()
	_inventory_panel.set_anchors_preset(Control.PRESET_CENTER)
	_inventory_panel.position = Vector2(-180.0, -140.0)
	_inventory_panel.size = Vector2(360.0, 280.0)
	root.add_child(_inventory_panel)
	var inventory_box := VBoxContainer.new()
	_inventory_panel.add_child(inventory_box)
	var title := Label.new()
	title.text = "EQUIPO Y MOCHILA"
	title.add_theme_font_size_override("font_size", 18)
	inventory_box.add_child(title)
	_inventory_text = Label.new()
	_inventory_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	inventory_box.add_child(_inventory_text)
	var hint := Label.new()
	hint.text = "1 agua · 2 comida · H venda/botiquín · I cerrar"
	inventory_box.add_child(hint)
	_inventory_panel.visible = false
	_pause_panel = PanelContainer.new()
	_pause_panel.set_anchors_preset(Control.PRESET_CENTER)
	_pause_panel.position = Vector2(-170.0, -115.0)
	_pause_panel.size = Vector2(340.0, 230.0)
	root.add_child(_pause_panel)
	var pause_box := VBoxContainer.new()
	pause_box.add_theme_constant_override("separation", 10)
	_pause_panel.add_child(pause_box)
	var pause_title := Label.new()
	pause_title.text = "PAUSA"
	pause_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	pause_box.add_child(pause_title)
	var resume := Button.new()
	resume.text = "Reanudar · Esc"
	resume.pressed.connect(toggle_pause)
	pause_box.add_child(resume)
	var guide_button := Button.new()
	guide_button.text = "Consultar guía · F1"
	guide_button.pressed.connect(_open_guide)
	pause_box.add_child(guide_button)
	var menu_button := Button.new()
	menu_button.text = "Volver al menú"
	menu_button.pressed.connect(_return_to_menu)
	pause_box.add_child(menu_button)
	_pause_panel.visible = false
	_notice = Label.new()
	_notice.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	_notice.position = Vector2(-300.0, -80.0)
	_notice.size = Vector2(600.0, 42.0)
	_notice.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	root.add_child(_notice)

func refresh(_hour: int = -1, _daylight: float = -1.0) -> void:
	_refresh()

func show_notice(message: String) -> void:
	_notice.text = message
	_notice_time = 3.2

func toggle_inventory() -> void:
	_inventory_panel.visible = not _inventory_panel.visible
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if _inventory_panel.visible else Input.MOUSE_MODE_CAPTURED
	_refresh()

func _refresh() -> void:
	if session == null or not is_instance_valid(_vitals):
		return
	var stats: Node = session.survival
	_vitals.text = "HP %3.0f  Hambre %3.0f  Sed %3.0f  Aguante %3.0f\nTemp. %.1f°C  Infección %3.0f%%" % [stats.health, stats.hunger, stats.thirst, stats.stamina, stats.body_temperature, stats.infection]
	_location.text = "%02d:00 · %s  ·  X %.0f  Z %.0f\n%s" % [session.world_clock.current_hour(), session.world.region_name, session.world.coordinates.x, session.world.coordinates.y, session.world.get_map_summary()]
	_objective.text = "Objetivo: " + session.quests.get_objective_text() + "\nNivel %d · XP %d · Carga %.1f/%.0f kg" % [session.progression.level, session.progression.experience, session.inventory.get_weight(), session.inventory.carry_capacity]
	var lines: Array[String] = []
	for item_id in session.inventory.items:
		lines.append("%s × %d" % [ItemCatalog.display_name(str(item_id)), int(session.inventory.items[item_id])])
	if lines.is_empty():
		lines.append("Mochila vacía")
	_inventory_text.text = "\n".join(PackedStringArray(lines))

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if _inventory_panel.visible:
			toggle_inventory()
		else:
			toggle_pause()
		get_viewport().set_input_as_handled()
		return
	if event.is_action_pressed("inventory"):
		toggle_inventory()
		get_viewport().set_input_as_handled()

func toggle_pause() -> void:
	var pausing := not get_tree().paused
	get_tree().paused = pausing
	_pause_panel.visible = pausing
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if pausing else Input.MOUSE_MODE_CAPTURED

func _open_guide() -> void:
	var guide := get_node_or_null("GameGuide")
	if guide != null:
		guide.toggle()

func _return_to_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://MainMenu.tscn")
