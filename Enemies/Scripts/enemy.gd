class_name Enemy extends CharacterBody2D

signal direction_changed(new_direction: Vector2)
signal enemy_damaged( hurt_box : HurtBox )
signal enemy_destroyed( hurt_box : HurtBox )

const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

@export var hp : int =3

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var player : Player
var invulnerable : bool = false

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var audio = $AudioFiles
@onready var state_machine : EnemyStateMachine  = $EnemyStateMachine
@onready var hit_box : HitBox = $HitBox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_machine.initialize(self)
	player = PlayerManager.player
	hit_box.Damaged.connect(_take_damage)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	move_and_slide()

func SetDirection(_new_direction : Vector2) -> bool:
	direction=_new_direction
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
	direction_changed.emit(new_dir)
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

func _take_damage(hurt_box : HurtBox) -> void:
	if invulnerable == true:
		return
	hp -= hurt_box.damage
	if hp > 0:
		enemy_damaged.emit( hurt_box )
	else:
		enemy_destroyed.emit( hurt_box )
