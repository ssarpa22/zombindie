extends Node

const SAVE_PATH := "user://zombindie_save.cfg"

func save_session(session: Node, save_path: String = SAVE_PATH) -> bool:
	var config := ConfigFile.new()
	config.set_value("player", "position", session.player.global_position)
	config.set_value("player", "rotation_y", session.player.rotation.y)
	config.set_value("survival", "state", session.survival.snapshot())
	config.set_value("inventory", "items", session.inventory.snapshot())
	config.set_value("progression", "state", session.progression.snapshot())
	config.set_value("quest", "state", session.quests.snapshot())
	config.set_value("world", "state", session.world.snapshot())
	config.set_value("clock", "state", session.world_clock.snapshot())
	config.set_value("session", "mode", GameSettings.mode)
	var error := config.save(save_path)
	if error != OK:
		push_error("No se pudo guardar la partida: %s" % error_string(error))
	return error == OK

func load_session(session: Node, save_path: String = SAVE_PATH) -> bool:
	var config := ConfigFile.new()
	if config.load(save_path) != OK:
		return false
	session.player.global_position = config.get_value("player", "position", session.player.global_position)
	session.player.rotation.y = float(config.get_value("player", "rotation_y", session.player.rotation.y))
	session.survival.restore(config.get_value("survival", "state", {}))
	session.inventory.restore(config.get_value("inventory", "items", {}))
	session.progression.restore(config.get_value("progression", "state", {}))
	session.quests.restore(config.get_value("quest", "state", {}))
	session.world.restore(config.get_value("world", "state", {}))
	session.world_clock.restore(config.get_value("clock", "state", {}))
	GameSettings.mode = str(config.get_value("session", "mode", GameSettings.mode))
	session.on_loaded()
	return true
