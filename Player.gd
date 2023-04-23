extends Area2D

# 速度
export var speed = 400
# 視窗大小
var screen_size

# 信號 - 被擊中
signal hit

# 自定義函式 - 開始時調用 ( 玩家邏輯 )
func start(pos):
	# 設置玩家位置
	position = pos
	# 顯示玩家
	show()
	# 啟用碰撞檢測
	$CollisionShape2D.disabled = false

# 節點建立時調用
func _ready():
	# 獲取視窗大小
	screen_size = get_viewport_rect().size

# 運行調用
func _process(delta):
	# 設置速度
	var velocity = Vector2.ZERO 
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1 
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		
	# 角色在移動
	if velocity.length() > 0:
		# 將速度大小統一 ( 向量大小 )
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play();
	else:
		$AnimatedSprite.stop();
		
	# 修改位置
	position += velocity * delta
	# 不超出視窗範圍
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

	# 配置動畫
	# 左右移動
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	# 上下移動
	if velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0
		$AnimatedSprite.flip_h = false

# 有物體進入玩家節點 (Player / Area2D)
func _on_Player_body_entered(body):
	# 隱藏玩家
	hide()
	# 發射信號 - 被擊中
	emit_signal("hit")
	# 取消碰撞檢測 (避免重複偵測) (延遲設置避免非預期錯誤)
	$CollisionShape2D.set_deferred("disabled", true)
