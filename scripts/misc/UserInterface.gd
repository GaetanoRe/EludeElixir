extends CanvasLayer


#@onready var doses = %Player.doses
@onready var potion_prog : TextureProgressBar = get_node("UIController/InGameUI/Potion")
@onready var animation = %Enveloped_UI/AnimationPlayer
@onready var screen = %Enveloped_UI
@onready var instance = %FadeIn_UI/AnimationPlayer
var timer : Timer

signal countdown_start
signal countdown_end

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# See dungeon.gd
#func fade_in_anim():
	#instance.current_animation("Fade_In")



	
	 ##2nd option - see player.gd
##func enveloped_anim():
	##screen.is_visible_in_tree(true)
	##screen.animation.play("Enveloped")
	##countdown_start.emit()
	##timer.start()
	##await timer.timeout
	##countdown_end.emit()
	##screen.is_visible_in_tree(false)
#
#

#func _on_enveloped_ui_visibility_changed():
	#screen.animation.play("Enveloped")
	#countdown_start.emit()
	#timer.start()
	#await timer.timeout
	#countdown_end.emit()
	#screen.is_visible_in_tree(false)





