class_name ActionButton extends Control

@onready var texture_rect: TextureRect = $MarginContainer/TextureRect
@onready var button: Button = $MarginContainer/Button

var _spell: Spell
var _keybind: String

func init(spell: Spell, keybind: String) -> void:
	_spell = spell
	_keybind = keybind

func _ready() -> void:
	button.connect("pressed", _activate_spell)
	_load()

func _load() -> void:
	texture_rect.texture = _spell.spell_icon.spell_icon
	button.disabled = _spell.spell_icon.is_passive

func _activate_spell() -> void:
	_spell.activate_targeting()

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed(_keybind)):
		_activate_spell()
