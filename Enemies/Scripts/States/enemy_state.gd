class_name EnemyState extends Node

var enemy : Enemy
var state_machine : EnemyStateMachine

func init() -> void:
	pass

#What happens when player enters the state
func Enter() -> void:
	pass

#What happens when player exits the state
func Exit() -> void:
	pass

func Process(_delta:float) -> EnemyState:
	return null

func Physics(_delta:float) -> EnemyState:
	return null
