extends KinematicBody2D

var player = null
var speed = 70
var motion = Vector2.ZERO
var health = 100
var player_inattack_zone = false
var can_take_damage = true
var attack_ip = false
var flippet_sprite = false
var stop_motion = false

onready var animation = $AnimationPlayer

func _physics_process(delta):
	motion = Vector2.ZERO
	
	deal_with_damage()
	update_health()
	
	if player:
		if stop_motion == false:
			motion = position.direction_to(player.position) * speed
	
	motion = move_and_slide(motion)
	
	if player == null:
		animation.play("idle")
		pass
	
	if motion.x > 0:
		if attack_ip == false:
			animation.play("walking")
		$Soldier1.flip_h = false
		flippet_sprite = false
		
		
	
	if motion.x < 0:
		if attack_ip == false:
			animation.play("walking")
		$Soldier1.flip_h = true
		flippet_sprite = true
		
		
		
	if attack_ip == true:
		animation.play("attack")
		if flippet_sprite == true:
			$Soldier1.flip_h = true
		elif flippet_sprite == false:
			$Soldier1.flip_h = false

func _on_detection_area_body_entered(body):
	player = body


func _on_detection_area_body_exited(body):
	player = null

func enemy():
	pass

func _on_hitbox_body_entered(body):
	if body.has_method("player"):
		player_inattack_zone = true
		attack_ip = true
		stop_motion = true


func _on_hitbox_body_exited(body):
	if body.has_method("player"):
		player_inattack_zone = false
		attack_ip = false
		stop_motion = false

func deal_with_damage():
	if player_inattack_zone and global.player_current_attack == true:
		if can_take_damage == true:
			health = health - 25
			$take_damage_cooldown.start()
			can_take_damage = false
			if health <= 0:
				self.queue_free()

func _on_take_damage_cooldown_timeout():
	can_take_damage = true

func update_health():
	var healthbar = $lifebar
	healthbar.value = health
	
	if health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true
