class_name ActionButton extends Control

@onready var texture_rect: TextureRect = $MarginContainer/TextureRect
@onready var button: Button = $MarginContainer/Button

var _spell: Spell

func init(spell: Spell) -> void:
	_spell = spell

func _ready() -> void:
	button.connect("pressed", _activate_spell)
	_load()

func _load() -> void:
	texture_rect.texture = _spell.spell_icon.spell_icon
	button.disabled = _spell.spell_icon.is_passive

func _activate_spell() -> void:
	_spell.activate_targeting()
