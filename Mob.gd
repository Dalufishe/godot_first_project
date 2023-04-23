extends RigidBody2D

func _ready():
	# 動畫
	$AnimatedSprite.playing = true
	# 取得動畫列表 - 動畫名
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	# 隨機設置動畫
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()



