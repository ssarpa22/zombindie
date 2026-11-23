extends CanvasLayer

const GUIDE_PATH := "user://zombindie_guide.cfg"
var _panel: PanelContainer
var _body: Label
var _muted := false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build()
	_panel.visible = false
	var config := ConfigFile.new()
	var loaded := config.load(GUIDE_PATH) == OK
	if loaded:
		_muted = bool(config.get_value("guide", "muted", false))
	if not loaded or not bool(config.get_value("guide", "seen", false)):
		show_tip("Hola. Soy la Operadora. Usá %s para moverte, el mouse para mirar y %s para interactuar. Si te perdés, abrí esta guía con F1." % [GameSettings.get_key_binding("move_forward"), GameSettings.get_key_binding("interact")])

func _build() -> void:
	var root := Control.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(root)
	_panel = PanelContainer.new()
	_panel.set_anchors_preset(Control.PRESET_CENTER)
	_panel.position = Vector2(-250, -190)
	_panel.size = Vector2(500, 380)
	_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	root.add_child(_panel)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 12)
	_panel.add_child(box)
	var title := Label.new()
	title.text = "LA OPERADORA · GUÍA DE SUPERVIVENCIA"
	title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(title)
	_body = Label.new()
	_body.text = "Moverte: %s %s %s %s · mirar: mouse · correr: %s.\n\nBuscá suministros e interactuá con %s. Revisá la mochila con %s. Agua y comida son limitadas; %s usa curación.\n\nLa lluvia y la nieve enfrían el cuerpo. La niebla reduce mucho la visibilidad. Correr genera ruido y puede atraer infectados.\n\nF5 guarda y F9 carga. F1 abre o cierra esta guía." % [GameSettings.get_key_binding("move_forward"), GameSettings.get_key_binding("move_left"), GameSettings.get_key_binding("move_back"), GameSettings.get_key_binding("move_right"), GameSettings.get_key_binding("sprint"), GameSettings.get_key_binding("interact"), GameSettings.get_key_binding("inventory"), GameSettings.get_key_binding("heal")]
	_body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(_body)
	var buttons := HBoxContainer.new()
	box.add_child(buttons)
	var mute := CheckButton.new()
	mute.text = "Silenciar consejos"
	mute.toggled.connect(_set_muted)
	buttons.add_child(mute)
	var close := Button.new()
	close.text = "Cerrar · F1"
	close.pressed.connect(toggle)
	buttons.add_child(close)

func toggle() -> void:
	_panel.visible = not _panel.visible
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if _panel.visible or get_tree().paused else Input.MOUSE_MODE_CAPTURED
	if _panel.visible:
		_mark_seen()

func show_tip(message: String) -> void:
	if _muted or _panel.visible:
		return
	_body.text = message + "\n\nF1: ver guía completa"
	_panel.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_mark_seen()

func _set_muted(value: bool) -> void:
	_muted = value
	var config := ConfigFile.new()
	config.load(GUIDE_PATH)
	config.set_value("guide", "muted", value)
	config.save(GUIDE_PATH)

func _mark_seen() -> void:
	var config := ConfigFile.new()
	config.load(GUIDE_PATH)
	config.set_value("guide", "seen", true)
	config.save(GUIDE_PATH)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("guide"):
		toggle()
		get_viewport().set_input_as_handled()
