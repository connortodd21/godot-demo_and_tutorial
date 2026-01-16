extends Node

@export var mob_scene: PackedScene
var score


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass

func new_game() -> void:
	get_tree().call_group("mobs", "queue_free")
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("Get Ready!")
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$Music.play()

func game_over() -> void:
	$DeathSound.play()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.game_over()


func _on_mob_timer_timeout() -> void:
	# instantiate mob
	var mob = mob_scene.instantiate()
	# set spawn location
	var mobSpawnLocation = $MobPath/MobSpawnLocation
	# set random point on the MobPath to be the spawn
	mobSpawnLocation.progress_ratio = randf()
	mob.position = mobSpawnLocation.position
	# Set the mob's direction perpendicular to the path direction and add some randomness
	var direction = mobSpawnLocation.rotation + PI/2
	direction += randf_range(-PI / 4, PI / 4)
	# Choose velocity for mob
	var velocity = Vector2(randf_range(150.0,250.0),0.0)
	mob.linear_velocity = velocity.rotated(direction)
	add_child(mob)

func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
