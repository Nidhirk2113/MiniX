class_name Player extends CharacterBody2D

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var invulnerable : bool = false
var hp : int = 6
var max_hp : int = 6

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var state_machine : PlayerStateMachine  = $StateMachine
@onready var hit_box : HitBox = $HitBox

signal DirectionChanged( new_direction: Vector2 )
signal player_damaged(hurt_box : HurtBox)

func _ready() -> void:
	PlayerManager.player = self
	state_machine.Initialize(self)
	hit_box.Damaged.connect(take_damage)
	update_hp(99)
	pass

func _process(delta):
	direction.x=Input.get_action_strength("right")-Input.get_action_strength("left")
	direction.y=Input.get_action_strength("down")-Input.get_action_strength("up")
	pass

func _physics_process(delta: float) -> void:
	move_and_slide()

func SetDirection() -> bool:
	var new_dir:Vector2=cardinal_direction
	if direction == Vector2.ZERO:
		return false
	if abs(direction.x) > abs(direction.y):  # Horizontal movement dominates
		new_dir = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	else:  # Vertical movement dominates
		new_dir = Vector2.UP if direction.y < 0 else Vector2.DOWN

	# If the direction hasn't changed, don't update
	if new_dir == cardinal_direction:
		return false
	
	
	# Update cardinal direction
	cardinal_direction = new_dir
	DirectionChanged.emit(new_dir)
	return true  # Direction has changed

func UpdateAnimation(state: String) -> void:
	animated_sprite.play(state + "_" + AnimDirection())

func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "front"
	elif cardinal_direction == Vector2.UP:
		return "back"
	elif cardinal_direction == Vector2.LEFT:
		return "left"
	elif cardinal_direction == Vector2.RIGHT:
		return "right"
	return "front"

func take_damage( hurt_box : HurtBox )-> void:
	if invulnerable == true:
		return
	update_hp( -hurt_box.damage )
	if hp > 0:
		player_damaged.emit( hurt_box )
	else:
		player_damaged.emit( hurt_box )
		update_hp(99)
	pass

func update_hp(delta : int) -> void:
	hp = clampi( hp + delta ,0 , max_hp)
	PlayerHud.update_hp(hp, max_hp)
	pass

func make_invulnerable( _duration : float = 1.0 ) -> void:
	invulnerable = true
	hit_box.monitoring = false
	
	await  get_tree().create_timer(_duration).timeout
	invulnerable = false
	hit_box.monitoring = true
	pass
