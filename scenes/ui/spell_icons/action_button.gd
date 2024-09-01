class_name ActionButton extends Control

@onready var texture_rect: TextureRect = $MarginContainer/TextureRect
@onready var button: Button = $MarginContainer/Button

var _spell: Spell
var _keybind: String
var keybind_label: Label

func init(spell: Spell, keybind: String) -> void:
	_spell = spell
	_keybind = keybind

func _ready() -> void:
	button.connect("pressed", _activate_spell)
	keybind_label = $Control/PanelContainer/KeybindLabel
	_load()

func _load() -> void:
	texture_rect.texture = _spell.spell_icon.spell_icon
	button.disabled = _spell.spell_icon.is_passive
	keybind_label.text = _get_input_buttons_text(InputMap.action_get_events(_keybind))

func _activate_spell() -> void:
	_spell.activate_targeting()

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed(_keybind)):
		_activate_spell()

func _get_input_buttons_text(inputs: Array[InputEvent]) -> String:
	var out_string: String = ""
	for i: InputEvent in inputs:
		if out_string != "":
			out_string += ", "
		out_string += i.as_text().replace(" (Physical)", "")
	return out_string
