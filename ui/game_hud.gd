extends CanvasLayer

const ItemCatalog = preload("res://systems/item_catalog.gd")
const UIStyle = preload("res://ui/ui_style.gd")
const GraphicsSettingsPanel = preload("res://ui/graphics_settings_panel.gd")
const WorldMapScript = preload("res://ui/world_map.gd")
const LootPickup = preload("res://entities/loot_pickup.gd")
const TraderNPC = preload("res://entities/trader_npc.gd")
const WorldDocument = preload("res://entities/world_document.gd")
const RestSpot = preload("res://entities/rest_spot.gd")
const DoorScript = preload("res://door.gd")

var session: Node

var _root: Control
var _health_fill: ProgressBar
var _hunger_fill: ProgressBar
var _thirst_fill: ProgressBar
var _stamina_indicator: PanelContainer
var _stamina_fill: ProgressBar
var _stamina_alpha := 0.0
var _stamina_idle_time := 0.0

var _interaction_prompt: PanelContainer
var _interaction_label: Label
var _interaction_update := 0.0

var _notice: Label
var _notice_time := 0.0
var _notice_priority := false
var _modal_scrim: ColorRect

var _interface_panel: PanelContainer
var _interface_title: Label
var _interface_content: Control
var _active_interface := ""
var _nav_buttons: Dictionary = {}

var _inventory_grid: GridContainer
var _inventory_detail: VBoxContainer
var _inventory_signature := ""
var _selected_item_id := ""
var _inventory_preview: SubViewport

var _document_panel: PanelContainer
var _document_title: Label
var _document_text: Label
var _quick_panel: PanelContainer

func configure(game_session: Node) -> void:
	session = game_session
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build_ui()
	_refresh_interface()

func _process(delta: float) -> void:
	_update_notices(delta)
	_update_conditional_hud(delta)
	_update_context_prompt(delta)

func _build_ui() -> void:
	_root = Control.new()
	_root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.theme = UIStyle.create_theme()
	add_child(_root)

	_build_conditional_indicators()
	_build_context_prompt()
	_build_notifications()
	_build_interface_shell()
	_build_document_panel()

	_modal_scrim = ColorRect.new()
	_modal_scrim.color = Color(0.008, 0.012, 0.012, 0.74)
	_modal_scrim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_modal_scrim.mouse_filter = Control.MOUSE_FILTER_STOP
	_modal_scrim.visible = false
	_root.add_child(_modal_scrim)
	_modal_scrim.move_to_front()
	_interface_panel.move_to_front()
	_document_panel.move_to_front()
	_quick_panel.move_to_front()

func _build_conditional_indicators() -> void:
	var vitals := PanelContainer.new()
	vitals.set_anchors_preset(Control.PRESET_TOP_LEFT)
	vitals.position = Vector2(18.0, 18.0)
	vitals.custom_minimum_size = Vector2(210.0, 112.0)
	vitals.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(vitals)
	var layout := VBoxContainer.new()
	layout.add_theme_constant_override("separation", 6)
	vitals.add_child(layout)
	var heading := Label.new()
	heading.text = "SUPERVIVENCIA"
	heading.add_theme_color_override("font_color", UIStyle.ACCENT)
	heading.add_theme_font_size_override("font_size", 8)
	layout.add_child(heading)
	_health_fill = _thin_condition(layout, "SALUD", UIStyle.DANGER)
	_hunger_fill = _thin_condition(layout, "HAMBRE", UIStyle.AMBER)
	_thirst_fill = _thin_condition(layout, "SED", Color(0.39, 0.62, 0.72))

	_stamina_indicator = PanelContainer.new()
	_stamina_indicator.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	_stamina_indicator.position = Vector2(18.0, -50.0)
	_stamina_indicator.custom_minimum_size = Vector2(210.0, 38.0)
	_stamina_indicator.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_stamina_indicator)
	_stamina_fill = _thin_condition(_stamina_indicator, "AGUANTE", UIStyle.ACCENT)
	_stamina_indicator.visible = false

func _thin_condition(parent: Control, title: String, color: Color) -> ProgressBar:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	row.custom_minimum_size.y = 14.0
	parent.add_child(row)
	var label := Label.new()
	label.text = title
	label.custom_minimum_size.x = 58.0
	label.add_theme_font_size_override("font_size", 7)
	label.add_theme_color_override("font_color", UIStyle.MUTED)
	row.add_child(label)
	var fill := ProgressBar.new()
	fill.min_value = 0.0
	fill.max_value = 100.0
	fill.show_percentage = false
	fill.custom_minimum_size = Vector2(96.0, 7.0)
	fill.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	fill.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	fill.add_theme_stylebox_override("fill", UIStyle.progress_style(color))
	row.add_child(fill)
	return fill

func _build_context_prompt() -> void:
	_interaction_prompt = PanelContainer.new()
	_interaction_prompt.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	_interaction_prompt.position = Vector2(-140.0, -82.0)
	_interaction_prompt.custom_minimum_size = Vector2(280.0, 34.0)
	_interaction_prompt.visible = false
	_root.add_child(_interaction_prompt)
	_interaction_label = Label.new()
	_interaction_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_interaction_label.add_theme_font_size_override("font_size", 9)
	_interaction_prompt.add_child(_interaction_label)

func _build_notifications() -> void:
	_notice = Label.new()
	_notice.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	_notice.position = Vector2(-242.0, 18.0)
	_notice.size = Vector2(224.0, 34.0)
	_notice.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_notice.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_notice.add_theme_color_override("font_color", UIStyle.TEXT)
	_notice.add_theme_font_size_override("font_size", 9)
	_root.add_child(_notice)

func _build_interface_shell() -> void:
	_interface_panel = PanelContainer.new()
	_interface_panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_interface_panel.offset_left = 18.0
	_interface_panel.offset_top = 16.0
	_interface_panel.offset_right = -18.0
	_interface_panel.offset_bottom = -16.0
	_interface_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	_interface_panel.visible = false
	_root.add_child(_interface_panel)
	var shell := HBoxContainer.new()
	shell.add_theme_constant_override("separation", 8)
	_interface_panel.add_child(shell)

	var nav := VBoxContainer.new()
	nav.custom_minimum_size.x = 112.0
	nav.add_theme_constant_override("separation", 4)
	shell.add_child(nav)
	_interface_title = Label.new()
	_interface_title.text = "ZOMBINDIE"
	_interface_title.add_theme_color_override("font_color", UIStyle.ACCENT)
	_interface_title.add_theme_font_size_override("font_size", 10)
	nav.add_child(_interface_title)
	_add_nav_button(nav, "INVENTARIO", "inventory", "I")
	_add_nav_button(nav, "PERSONAJE", "character", "C")
	_add_nav_button(nav, "PROGRESIÓN", "progression", "")
	_add_nav_button(nav, "MISIONES", "quests", "Q")
	_add_nav_button(nav, "MAPA", "map", "M")

	var close := Button.new()
	close.text = "CERRAR  ·  ESC"
	close.pressed.connect(_close_all_interfaces)
	nav.add_child(close)

	var content_wrapper := VBoxContainer.new()
	content_wrapper.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content_wrapper.add_theme_constant_override("separation", 6)
	shell.add_child(content_wrapper)
	var header := HBoxContainer.new()
	content_wrapper.add_child(header)
	var title := Label.new()
	title.name = "ContentTitle"
	title.text = ""
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.add_theme_color_override("font_color", UIStyle.ACCENT)
	title.add_theme_font_size_override("font_size", 12)
	header.add_child(title)
	_interface_content = Control.new()
	_interface_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_interface_content.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content_wrapper.add_child(_interface_content)

	_quick_panel = PanelContainer.new()
	_quick_panel.set_anchors_preset(Control.PRESET_CENTER)
	_quick_panel.position = Vector2(-145.0, -78.0)
	_quick_panel.custom_minimum_size = Vector2(290.0, 156.0)
	_quick_panel.visible = false
	_root.add_child(_quick_panel)
	var quick_layout := VBoxContainer.new()
	quick_layout.add_theme_constant_override("separation", 8)
	_quick_panel.add_child(quick_layout)
	var quick_title := Label.new()
	quick_title.text = "ACCESO RÁPIDO"
	quick_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	quick_title.add_theme_color_override("font_color", UIStyle.ACCENT)
	quick_layout.add_child(quick_title)
	var quick_row := HBoxContainer.new()
	quick_row.add_theme_constant_override("separation", 6)
	quick_layout.add_child(quick_row)
	_add_quick_button(quick_row, "1  Agua", "water")
	_add_quick_button(quick_row, "2  Comida", "canned_food")
	_add_quick_button(quick_row, "H  Curar", "heal")
	var quick_row_2 := HBoxContainer.new()
	quick_row_2.add_theme_constant_override("separation", 6)
	quick_layout.add_child(quick_row_2)
	_add_quick_command(quick_row_2, "I  Mochila", "inventory")
	_add_quick_command(quick_row_2, "C  Estado", "character")
	_add_quick_command(quick_row_2, "Q  Misiones", "quests")

func _add_nav_button(parent: Control, text_value: String, interface_name: String, hint: String) -> void:
	var button := Button.new()
	button.text = text_value if hint.is_empty() else "%s  [%s]" % [text_value, hint]
	button.toggle_mode = true
	button.pressed.connect(_open_interface.bind(interface_name))
	_nav_buttons[interface_name] = button
	parent.add_child(button)

func _add_quick_button(parent: Control, text_value: String, item_id: String) -> void:
	var button := Button.new()
	button.text = text_value
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.pressed.connect(_quick_use.bind(item_id))
	parent.add_child(button)

func _add_quick_command(parent: Control, text_value: String, interface_name: String) -> void:
	var button := Button.new()
	button.text = text_value
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.pressed.connect(_open_interface.bind(interface_name))
	parent.add_child(button)

func _quick_use(item_id: String) -> void:
	if item_id == "heal":
		_quick_heal()
	elif is_instance_valid(session):
		session.use_item(item_id)

func _quick_heal() -> void:
	if not is_instance_valid(session):
		return
	if session.inventory.has_item("bandage"):
		session.use_item("bandage")
	else:
		session.use_item("medical_kit")

func _build_document_panel() -> void:
	_document_panel = PanelContainer.new()
	_document_panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_document_panel.offset_left = 42.0
	_document_panel.offset_top = 30.0
	_document_panel.offset_right = -42.0
	_document_panel.offset_bottom = -30.0
	_document_panel.visible = false
	_root.add_child(_document_panel)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 10)
	_document_panel.add_child(box)
	_document_title = Label.new()
	_document_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_document_title.add_theme_color_override("font_color", UIStyle.ACCENT)
	box.add_child(_document_title)
	_document_text = Label.new()
	_document_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_document_text.size_flags_vertical = Control.SIZE_EXPAND_FILL
	box.add_child(_document_text)
	var close := Button.new()
	close.text = "Cerrar · E / Esc"
	close.pressed.connect(close_document_panel)
	box.add_child(close)

func _open_interface(interface_name: String) -> void:
	if get_tree().paused:
		get_tree().paused = false
	_quick_panel.visible = false
	_active_interface = interface_name
	_interface_panel.visible = true
	_modal_scrim.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	for name: Variant in _nav_buttons:
		var button: Button = _nav_buttons[name]
		button.button_pressed = str(name) == interface_name
	var title: Label = _interface_panel.find_child("ContentTitle", true, false)
	match interface_name:
		"inventory":
			title.text = "INVENTARIO"
			_build_inventory_interface()
		"character":
			title.text = "ESTADO"
			_build_character_interface()
		"progression":
			title.text = "PROGRESIÓN"
			_build_progression_interface()
		"quests":
			title.text = "DIARIO DE MISIONES"
			_build_quest_interface()
		"map":
			title.text = "MAPA"
			_build_map_interface()
	_refresh_interface()

func _close_all_interfaces() -> void:
	_interface_panel.visible = false
	_quick_panel.visible = false
	_active_interface = ""
	_modal_scrim.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func has_pointer_interface() -> bool:
	return _interface_panel.visible or _document_panel.visible or _quick_panel.visible

func toggle_inventory() -> void:
	if _interface_panel.visible and _active_interface == "inventory":
		_close_all_interfaces()
	else:
		_open_interface("inventory")

func toggle_pause() -> void:
	if _interface_panel.visible:
		_close_all_interfaces()
		get_tree().paused = false
		return
	get_tree().paused = true
	_build_pause_interface()

func _build_pause_interface() -> void:
	_interface_panel.visible = true
	_modal_scrim.visible = true
	_active_interface = "pause"
	var title: Label = _interface_panel.find_child("ContentTitle", true, false)
	title.text = "PAUSA"
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_clear_interface_content()
	var box := VBoxContainer.new()
	box.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	box.add_theme_constant_override("separation", 7)
	_interface_content.add_child(box)
	var resume := Button.new()
	resume.text = "Reanudar"
	resume.pressed.connect(toggle_pause)
	box.add_child(resume)
	var inventory := Button.new()
	inventory.text = "Abrir inventario"
	inventory.pressed.connect(_open_interface.bind("inventory"))
	box.add_child(inventory)
	var character := Button.new()
	character.text = "Estado del personaje"
	character.pressed.connect(_open_interface.bind("character"))
	box.add_child(character)
	var quests := Button.new()
	quests.text = "Diario de misiones"
	quests.pressed.connect(_open_interface.bind("quests"))
	box.add_child(quests)
	var map_button := Button.new()
	map_button.text = "Mapa"
	map_button.pressed.connect(_open_interface.bind("map"))
	box.add_child(map_button)
	var save := Button.new()
	save.text = "Guardar partida"
	save.pressed.connect(_save_game)
	box.add_child(save)
	var load := Button.new()
	load.text = "Cargar partida"
	load.pressed.connect(_load_game)
	box.add_child(load)
	var settings := Button.new()
	settings.text = "Configuración"
	settings.pressed.connect(_build_pause_settings)
	box.add_child(settings)
	var menu := Button.new()
	menu.text = "Volver al menú"
	menu.pressed.connect(_return_to_menu)
	box.add_child(menu)

func _build_pause_settings() -> void:
	_clear_interface_content()
	var scroll := ScrollContainer.new()
	scroll.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	_interface_content.add_child(scroll)
	var box := VBoxContainer.new()
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.add_theme_constant_override("separation", 7)
	scroll.add_child(box)

	var title := Label.new()
	title.text = "CONFIGURACIÓN"
	title.add_theme_color_override("font_color", UIStyle.ACCENT)
	box.add_child(title)
	box.add_child(GraphicsSettingsPanel.new())

	var master := HSlider.new()
	master.min_value = 0.0
	master.max_value = 1.0
	master.step = 0.05
	master.value = GameSettings.master_volume
	master.value_changed.connect(_set_master_volume)
	box.add_child(_labeled_pause_control("Volumen", master))

	var sensitivity := HSlider.new()
	sensitivity.min_value = 0.0005
	sensitivity.max_value = 0.006
	sensitivity.step = 0.0001
	sensitivity.value = GameSettings.mouse_sensitivity
	sensitivity.value_changed.connect(_set_mouse_sensitivity)
	box.add_child(_labeled_pause_control("Sensibilidad", sensitivity))

	var invert := CheckButton.new()
	invert.text = "Invertir eje vertical"
	invert.button_pressed = GameSettings.invert_y
	invert.toggled.connect(_set_invert_y)
	box.add_child(invert)

	var back := Button.new()
	back.text = "Volver a pausa"
	back.pressed.connect(_build_pause_interface)
	box.add_child(back)

func _labeled_pause_control(label_text: String, control: Control) -> VBoxContainer:
	var row := VBoxContainer.new()
	row.add_theme_constant_override("separation", 2)
	var label := Label.new()
	label.text = label_text
	label.add_theme_color_override("font_color", UIStyle.MUTED)
	label.add_theme_font_size_override("font_size", 8)
	row.add_child(label)
	row.add_child(control)
	return row

func _set_master_volume(value: float) -> void:
	GameSettings.master_volume = value
	var bus := AudioServer.get_bus_index("Master")
	if bus >= 0:
		AudioServer.set_bus_volume_linear(bus, value)
	GameSettings.save_settings()

func _set_mouse_sensitivity(value: float) -> void:
	GameSettings.mouse_sensitivity = value
	GameSettings.save_settings()

func _set_invert_y(value: bool) -> void:
	GameSettings.invert_y = value
	GameSettings.save_settings()

func _clear_interface_content() -> void:
	for child in _interface_content.get_children():
		child.queue_free()

func _build_inventory_interface() -> void:
	_clear_interface_content()
	var layout := HBoxContainer.new()
	layout.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	layout.add_theme_constant_override("separation", 8)
	_interface_content.add_child(layout)

	var left := VBoxContainer.new()
	left.custom_minimum_size.x = 130.0
	left.add_theme_constant_override("separation", 6)
	layout.add_child(left)
	_create_preview(left)

	var grid_scroll := ScrollContainer.new()
	grid_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	layout.add_child(grid_scroll)
	_inventory_grid = GridContainer.new()
	_inventory_grid.columns = 2
	_inventory_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_inventory_grid.add_theme_constant_override("h_separation", 5)
	_inventory_grid.add_theme_constant_override("v_separation", 5)
	grid_scroll.add_child(_inventory_grid)

	_inventory_detail = VBoxContainer.new()
	_inventory_detail.custom_minimum_size.x = 150.0
	_inventory_detail.add_theme_constant_override("separation", 5)
	layout.add_child(_inventory_detail)
	_inventory_signature = ""
	_refresh_inventory()

func _create_preview(parent: Control) -> void:
	var viewport_container := SubViewportContainer.new()
	viewport_container.custom_minimum_size = Vector2(130.0, 175.0)
	viewport_container.stretch = true
	parent.add_child(viewport_container)
	_inventory_preview = SubViewport.new()
	_inventory_preview.transparent_bg = true
	_inventory_preview.size = Vector2i(260, 350)
	_inventory_preview.world_3d = World3D.new()
	viewport_container.add_child(_inventory_preview)
	var camera := Camera3D.new()
	camera.current = true
	camera.position = Vector3(0.0, 1.15, 3.0)
	camera.look_at(Vector3(0.0, 0.95, 0.0))
	_inventory_preview.add_child(camera)
	var light := DirectionalLight3D.new()
	light.rotation_degrees = Vector3(-35.0, -25.0, 0.0)
	light.light_energy = 1.4
	_inventory_preview.add_child(light)
	var body := MeshInstance3D.new()
	var body_mesh := CapsuleMesh.new()
	body_mesh.radius = 0.28
	body_mesh.height = 1.18
	body.mesh = body_mesh
	body.position = Vector3(0.0, 0.93, 0.0)
	var material := StandardMaterial3D.new()
	material.albedo_color = UIStyle.SURFACE
	material.roughness = 0.9
	body.material_override = material
	_inventory_preview.add_child(body)
	var weight_label := Label.new()
	var inventory: Node = session.inventory
	weight_label.text = "CARGA  %.1f / %.0f kg" % [inventory.get_weight(), inventory.carry_capacity]
	weight_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	weight_label.add_theme_font_size_override("font_size", 7)
	parent.add_child(weight_label)

func _refresh_inventory() -> void:
	if not is_instance_valid(session) or not is_instance_valid(_inventory_grid):
		return
	var inventory: Node = session.inventory
	var item_ids: Array = inventory.items.keys()
	item_ids.sort()
	var signature := ""
	for item_variant: Variant in item_ids:
		var item_id := str(item_variant)
		signature += "|%s:%d" % [item_id, int(inventory.items[item_id])]
	if signature == _inventory_signature:
		return
	_inventory_signature = signature
	for child in _inventory_grid.get_children():
		child.queue_free()
	if item_ids.is_empty():
		var empty := Label.new()
		empty.text = "Mochila vacía"
		empty.add_theme_color_override("font_color", UIStyle.MUTED)
		_inventory_grid.add_child(empty)
		return
	for item_variant: Variant in item_ids:
		var item_id := str(item_variant)
		var amount := int(inventory.items[item_id])
		var button := Button.new()
		button.text = "%s  ×%d" % [ItemCatalog.display_name(item_id), amount]
		button.custom_minimum_size = Vector2(145.0, 34.0)
		button.toggle_mode = true
		button.button_pressed = _selected_item_id == item_id
		button.pressed.connect(_select_inventory_item.bind(item_id))
		_inventory_grid.add_child(button)
	if _selected_item_id.is_empty():
		_selected_item_id = str(item_ids[0])
	_refresh_inventory_detail()

func _select_inventory_item(item_id: String) -> void:
	_selected_item_id = item_id
	for child in _inventory_grid.get_children():
		if child is Button:
			(child as Button).button_pressed = str(child.text).is_empty() == false and str(child.text).begins_with(ItemCatalog.display_name(item_id))
	_refresh_inventory_detail()

func _refresh_inventory_detail() -> void:
	if not is_instance_valid(_inventory_detail) or _selected_item_id.is_empty():
		return
	for child in _inventory_detail.get_children():
		child.queue_free()
	var inventory: Node = session.inventory
	if not inventory.has_item(_selected_item_id):
		_selected_item_id = ""
		return
	var definition: Dictionary = ItemCatalog.get_definition(_selected_item_id)
	var title := Label.new()
	title.text = ItemCatalog.display_name(_selected_item_id)
	title.add_theme_color_override("font_color", UIStyle.ACCENT)
	_inventory_detail.add_child(title)
	var detail := Label.new()
	detail.text = "%s\nPeso: %.2f kg" % [str(definition.get("description", "")), float(definition.get("weight", 0.0))]
	detail.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail.add_theme_font_size_override("font_size", 8)
	detail.add_theme_color_override("font_color", UIStyle.MUTED)
	_inventory_detail.add_child(detail)
	var category := str(definition.get("category", ""))
	if category in ["consumable", "medical"]:
		var use := Button.new()
		use.text = "Usar"
		use.pressed.connect(_use_inventory_item.bind(_selected_item_id))
		_inventory_detail.add_child(use)
	var drop := Button.new()
	drop.text = "Soltar"
	drop.pressed.connect(_drop_inventory_item.bind(_selected_item_id))
	_inventory_detail.add_child(drop)

func _use_inventory_item(item_id: String) -> void:
	if is_instance_valid(session):
		session.use_item(item_id)
	_refresh_interface()

func _drop_inventory_item(item_id: String) -> void:
	if is_instance_valid(session) and session.inventory.remove_item(item_id):
		show_notice("Soltaste %s." % ItemCatalog.display_name(item_id))
	_selected_item_id = ""
	_inventory_signature = ""
	_refresh_inventory()

func _build_character_interface() -> void:
	_clear_interface_content()
	var scroll := ScrollContainer.new()
	scroll.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	_interface_content.add_child(scroll)
	var box := VBoxContainer.new()
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.add_theme_constant_override("separation", 6)
	scroll.add_child(box)
	var stats: Node = session.survival
	_add_expandable_stat(box, "GENERAL", {
		"Salud": "%.0f / 100" % stats.health,
		"Estado": "Estable" if stats.health > 60.0 else ("Crítico" if stats.health <= 25.0 else "Herido")
	})
	_add_expandable_stat(box, "NECESIDADES", {
		"Hambre": "%.0f / 100" % stats.hunger,
		"Sed": "%.0f / 100" % stats.thirst,
		"Aguante": "%.0f / 100" % stats.stamina
	})
	_add_expandable_stat(box, "CUERPO", {
		"Temperatura": "%.1f °C" % stats.body_temperature,
		"Infección": "%.0f / 100" % stats.infection,
		"Heridas": "%.0f / 100" % stats.wound_level
	})

func _add_expandable_stat(parent: Control, title: String, values: Dictionary) -> void:
	var section := PanelContainer.new()
	parent.add_child(section)
	var box := VBoxContainer.new()
	section.add_child(box)
	var heading := Button.new()
	heading.text = "−  " + title
	heading.toggle_mode = true
	heading.button_pressed = true
	box.add_child(heading)
	var details := VBoxContainer.new()
	details.add_theme_constant_override("separation", 3)
	box.add_child(details)
	heading.toggled.connect(details.set_visible)
	for key: Variant in values:
		var row := HBoxContainer.new()
		details.add_child(row)
		var key_label := Label.new()
		key_label.text = str(key)
		key_label.custom_minimum_size.x = 110.0
		key_label.add_theme_color_override("font_color", UIStyle.MUTED)
		row.add_child(key_label)
		var value_label := Label.new()
		value_label.text = str(values[key])
		value_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(value_label)

func _build_progression_interface() -> void:
	_clear_interface_content()
	var box := VBoxContainer.new()
	box.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	box.add_theme_constant_override("separation", 8)
	_interface_content.add_child(box)
	var progression: Node = session.progression
	var next_xp: int = 100 + (progression.level - 1) * 60
	var level_row := HBoxContainer.new()
	box.add_child(level_row)
	var level := Label.new()
	level.text = "NIVEL %d" % progression.level
	level.add_theme_color_override("font_color", UIStyle.ACCENT)
	level.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	level_row.add_child(level)
	var xp := Label.new()
	xp.text = "%d / %d XP" % [progression.experience, next_xp]
	level_row.add_child(xp)
	var bar := ProgressBar.new()
	bar.min_value = 0.0
	bar.max_value = float(next_xp)
	bar.value = float(progression.experience)
	bar.show_percentage = false
	box.add_child(bar)
	var reputation := Label.new()
	reputation.text = "REPUTACIÓN  %d" % progression.reputation
	reputation.add_theme_color_override("font_color", UIStyle.MUTED)
	box.add_child(reputation)
	for skill: Variant in progression.skills:
		var rank := int(progression.skills[skill])
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 8)
		box.add_child(row)
		var label := Label.new()
		label.text = str(skill).capitalize()
		label.custom_minimum_size.x = 110.0
		row.add_child(label)
		var skill_bar := ProgressBar.new()
		skill_bar.min_value = 0.0
		skill_bar.max_value = 10.0
		skill_bar.value = float(rank)
		skill_bar.show_percentage = false
		skill_bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(skill_bar)

func _build_quest_interface() -> void:
	_clear_interface_content()
	var scroll := ScrollContainer.new()
	scroll.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_interface_content.add_child(scroll)
	var box := VBoxContainer.new()
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.add_theme_constant_override("separation", 6)
	scroll.add_child(box)
	var quests: Node = session.quests
	var title_text := "EVACUACIÓN"
	var section := PanelContainer.new()
	box.add_child(section)
	var section_box := VBoxContainer.new()
	section.add_child(section_box)
	var heading := Button.new()
	heading.text = ("[COMPLETA] " if quests.completed else "[ACTIVA] ") + title_text
	heading.toggle_mode = true
	heading.button_pressed = true
	section_box.add_child(heading)
	var details := VBoxContainer.new()
	section_box.add_child(details)
	heading.toggled.connect(details.set_visible)
	var objective := Label.new()
	objective.text = quests.get_objective_text()
	objective.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	details.add_child(objective)
	var steps := VBoxContainer.new()
	details.add_child(steps)
	_add_quest_step(steps, "Botiquín recuperado", quests.kit_recovered)
	_add_quest_step(steps, "Comisaría alcanzada", quests.station_reached)
	var location := Button.new()
	location.text = "Abrir ubicación en el mapa"
	location.pressed.connect(_open_interface.bind("map"))
	details.add_child(location)

func _add_quest_step(parent: Control, text_value: String, complete: bool) -> void:
	var label := Label.new()
	label.text = ("✓ " if complete else "○ ") + text_value
	label.add_theme_color_override("font_color", UIStyle.ACCENT if complete else UIStyle.MUTED)
	parent.add_child(label)

func _build_map_interface() -> void:
	_clear_interface_content()
	var layout := HBoxContainer.new()
	layout.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	layout.add_theme_constant_override("separation", 8)
	_interface_content.add_child(layout)
	var map := WorldMapScript.new()
	map.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	map.size_flags_vertical = Control.SIZE_EXPAND_FILL
	layout.add_child(map)
	var position: Vector2 = session.world.coordinates
	var active_marker: bool = not session.quests.completed
	map.configure(position, session.world.discovered, Vector2(1.4, 228.0), active_marker)
	map.set_player_node(session.player)
	var side := VBoxContainer.new()
	side.custom_minimum_size.x = 150.0
	side.add_theme_constant_override("separation", 5)
	layout.add_child(side)
	var region := Label.new()
	region.text = "ZONA\n" + session.world.region_name
	region.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	region.add_theme_color_override("font_color", UIStyle.ACCENT)
	side.add_child(region)
	var coordinates := Label.new()
	coordinates.text = "X  %.0f\nZ  %.0f" % [position.x, position.y]
	coordinates.add_theme_color_override("font_color", UIStyle.MUTED)
	side.add_child(coordinates)
	if session.world.discovered.has("clinic"):
		var clinic := Label.new()
		clinic.text = "● Clínica San Gabriel"
		side.add_child(clinic)
	if session.world.discovered.has("police_station"):
		var station := Label.new()
		station.text = "● Comisaría del Bosque"
		side.add_child(station)

func _update_conditional_hud(delta: float) -> void:
	if not is_instance_valid(session):
		return
	var stats: Node = session.survival
	_health_fill.value = stats.health
	_hunger_fill.value = stats.hunger
	_thirst_fill.value = stats.thirst
	_health_fill.modulate = UIStyle.DANGER if stats.health < 25.0 else Color.WHITE
	_hunger_fill.modulate = UIStyle.DANGER if stats.hunger < 25.0 else Color.WHITE
	_thirst_fill.modulate = UIStyle.DANGER if stats.thirst < 25.0 else Color.WHITE

	var player = session.player
	var sprinting: bool = is_instance_valid(player) and player.is_sprinting()
	if sprinting:
		_stamina_idle_time = 1.5
	else:
		_stamina_idle_time = maxf(0.0, _stamina_idle_time - delta)
	var stamina_needed: bool = sprinting or _stamina_idle_time > 0.0
	_stamina_alpha = lerpf(_stamina_alpha, 1.0 if stamina_needed else 0.0, clampf(delta * 6.0, 0.0, 1.0))
	_stamina_fill.value = stats.stamina
	_stamina_indicator.visible = _stamina_alpha > 0.015
	_stamina_indicator.modulate.a = _stamina_alpha

func _update_context_prompt(delta: float) -> void:
	_interaction_update -= delta
	if _interaction_update > 0.0:
		return
	_interaction_update = 0.12
	if not is_instance_valid(session) or not is_instance_valid(session.player):
		_interaction_prompt.visible = false
		return
	if _interface_panel.visible or _document_panel.visible or get_tree().paused:
		_interaction_prompt.visible = false
		return
	var camera: Camera3D = session.player.camera
	var ray_origin := camera.global_position
	var ray_end := ray_origin - camera.global_transform.basis.z * 2.8
	var query := PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	query.exclude = [session.player.get_rid()]
	query.collide_with_areas = true
	var hit := camera.get_world_3d().direct_space_state.intersect_ray(query)
	if hit.is_empty():
		_interaction_prompt.visible = false
		return
	var target: Object = hit.get("collider")
	var interactable: Object = target
	if target != null and not target.has_method("interact") and target is CollisionObject3D:
		var parent := (target as CollisionObject3D).get_parent()
		if is_instance_valid(parent) and parent.has_method("interact"):
			interactable = parent
	if interactable == null or not interactable.has_method("interact"):
		_interaction_prompt.visible = false
		return
	var prompt := _prompt_for_interactable(interactable)
	if prompt.is_empty():
		_interaction_prompt.visible = false
		return
	_interaction_label.text = "%s  ·  %s" % [prompt, GameSettings.get_key_binding("interact")]
	_interaction_prompt.visible = true

func _prompt_for_interactable(target: Object) -> String:
	if target is LootPickup:
		return "Recoger " + ItemCatalog.display_name(target.item_id)
	if target is TraderNPC:
		return "Hablar con Elena"
	if target is WorldDocument:
		return "Leer " + target.document_title
	if target is RestSpot:
		return str(target.prompt)
	if target is DoorScript:
		return "Cerrar puerta" if target._is_open else "Abrir puerta"
	if target.has_method("interact"):
		return "Interactuar"
	return ""

func _update_notices(delta: float) -> void:
	if _notice_time > 0.0:
		_notice_time -= delta
		if _notice_time <= 0.0:
			_notice.text = ""

func refresh(_hour: int = -1, _daylight: float = -1.0) -> void:
	_refresh_interface()

func show_notice(message: String) -> void:
	_notice.text = message
	_notice_priority = "crít" in message.to_lower() or "muerto" in message.to_lower()
	_notice.add_theme_color_override("font_color", UIStyle.DANGER if _notice_priority else UIStyle.AMBER)
	_notice_time = 4.0

func show_document(document_id: String, title: String, text: String) -> void:
	_document_panel.set_meta("document_id", document_id)
	_document_title.text = title
	_document_text.text = text
	_interface_panel.visible = false
	_quick_panel.visible = false
	_modal_scrim.visible = true
	_document_panel.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func close_document_panel() -> void:
	_document_panel.visible = false
	_modal_scrim.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _refresh_interface() -> void:
	if session == null or not is_instance_valid(_interface_panel):
		return
	match _active_interface:
		"inventory":
			_inventory_signature = ""
			_refresh_inventory()
		"character":
			if _interface_panel.visible:
				_build_character_interface()
		"progression":
			if _interface_panel.visible:
				_build_progression_interface()
		"quests":
			if _interface_panel.visible:
				_build_quest_interface()

func _save_game() -> void:
	if is_instance_valid(session) and session.save_service.save_session(session):
		show_notice("Partida guardada.")
	else:
		show_notice("No se pudo guardar la partida.")

func _load_game() -> void:
	if not is_instance_valid(session):
		return
	if session.save_service.load_session(session):
		show_notice("Partida cargada.")
	else:
		show_notice("Todavía no hay una partida guardada.")

func _return_to_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://MainMenu.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") or event.is_action_pressed("ui_cancel"):
		if _document_panel.visible:
			close_document_panel()
		elif _quick_panel.visible:
			_quick_panel.visible = false
			_modal_scrim.visible = false
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		elif _interface_panel.visible:
			if get_tree().paused:
				toggle_pause()
			else:
				_close_all_interfaces()
		else:
			toggle_pause()
		get_viewport().set_input_as_handled()
		return
	if event.is_action_pressed("inventory"):
		toggle_inventory()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("quest_journal"):
		if _interface_panel.visible and _active_interface == "quests":
			_close_all_interfaces()
		else:
			_open_interface("quests")
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("world_map"):
		if _interface_panel.visible and _active_interface == "map":
			_close_all_interfaces()
		else:
			_open_interface("map")
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("character_status"):
		if _interface_panel.visible and _active_interface == "character":
			_close_all_interfaces()
		else:
			_open_interface("character")
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("quick_menu"):
		_quick_panel.visible = not _quick_panel.visible
		_modal_scrim.visible = _quick_panel.visible
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if _quick_panel.visible else Input.MOUSE_MODE_CAPTURED
		get_viewport().set_input_as_handled()
