class_name Spell extends Node2D

@export var spell_icon: SpellIcon
@export var target_action: TargetAction
@export var action_effect: SpellEffect

func _ready() -> void:
	target_action.connect("target_selected", activate_effect)

func activate_targeting() -> void:
	target_action.start_target_selection()

func activate_effect(target: Target) -> void:
	print("Effect activated!")
	action_effect.start_effect(target)
