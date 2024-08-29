class_name ActionBar extends Control

const ACTION_BUTTON = preload("res://scenes/ui/spell_icons/action_button.tscn")
@onready var action_button_container: HBoxContainer = $HBoxContainer/PanelContainer/ActionButtonContainer

@export var selected_unit: Unit

func _ready() -> void:
	selected_unit.connect("spell_added", _on_spell_added)

func _on_spell_added(spell: Spell) -> void:
	var action_button: ActionButton = ACTION_BUTTON.instantiate()
	action_button.init(spell)
	action_button_container.add_child(action_button)
	print("Added ", spell.name)
