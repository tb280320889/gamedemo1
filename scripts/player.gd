extends CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	velocity = Vector2(50,0)

@export var animator : AnimatedSprite2D
@export var move_speed : float = 60

var is_game_over : bool = false

@export var bullet_scene:PackedScene 

func _process(delta: float) -> void:
	if velocity == Vector2.ZERO or is_game_over:
		$RunningSound.stop()
	elif not $RunningSound.playing:
		$RunningSound.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not is_game_over:
		if not is_game_over:
			Input.get_vector("left","right","up","down")
			velocity=	Input.get_vector("left","right","up","down") * move_speed
		#	如果速度为0，播放待机动画
			if velocity == Vector2.ZERO: 
				animator.play("idle")
		#		否则播放跑步动画
			else:
				animator.play("run")
			move_and_slide()

func game_over():
	if not is_game_over:
		is_game_over = true
		animator.play("lose")
		get_tree().current_scene.show_game_over()
		$GameOVerSound.play()
		
		#等待3秒 重启游戏
		$RestartTimer.start()
	


func _on_fire() -> void:
	if velocity != Vector2.ZERO || is_game_over:
		return
		
	$FireSound.play()
	var bullet_node = bullet_scene.instantiate()
	var bullet_offset = Vector2(12,2)
	
	bullet_node.position = position +bullet_offset
	get_tree().current_scene.add_child(bullet_node)


func _reload_scene() -> void:
	get_tree().reload_current_scene()
