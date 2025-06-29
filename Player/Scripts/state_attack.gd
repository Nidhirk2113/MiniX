class_name State_Attack extends State

var attacking : bool = false
@onready var animated_sprite : AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var walk : State = $"../Walk"
@onready var idle : State = $"../Idle"
@onready var hurt_box: HurtBox =$"../../Interactions/HurtBox"

func Enter() -> void:
	player.UpdateAnimation("Attack")
	animated_sprite.animation_finished.connect(EndAttack)
	attacking = true
	await get_tree().create_timer(0.075).timeout
	hurt_box.monitoring = true
	pass

func Exit() -> void:
	animated_sprite.animation_finished.disconnect(EndAttack)
	attacking = false
	hurt_box.monitoring = false
	pass

func Process(_delta:float) -> State:
	player.velocity=Vector2.ZERO
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	return null

func Physics(_delta:float) -> State:
	return null

func HandleInput(_event: InputEvent) -> State:
	return null

func EndAttack( ) -> void:
	attacking = false
