extends Area2D

signal pickup
signal hurt
signal coin
signal powerup

export (int) var speed
var velocity = Vector2()
var screensize = Vector2(480, 720)

onready var joystick = get_parent().get_node("joystick/TouchScreenButton")

func start(pos):
	set_process(true)
	position = pos
	$AnimatedSprite.animation = "idle"

func die():
	$AnimatedSprite.animation = "hurt"
	set_process(false)

func _ready():
	pass

func _process(delta):
	position += joystick.get_value() * speed * delta
	
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)
	
	if joystick.get_value().length() > 0:
		$AnimatedSprite.animation = "run"
		$AnimatedSprite.flip_h = joystick.get_value().x < 0
	else:
		$AnimatedSprite.animation = "idle"

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("ui_left"):
		velocity	.x -= 1
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

func _on_Player_area_entered(area):
	if area.is_in_group("coins"):
		area.pickup()
		emit_signal("pickup", "coin")
	if area.is_in_group("powerups"):
		area.pickup()
		emit_signal("pickup", "powerup")
	if area.is_in_group("obstacles"):
		emit_signal("hurt")
		die()

func _on_Lifetime_timeout():
	queue_free()
