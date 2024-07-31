extends Area2D
class_name Alembic


@onready var animation = $AnimatedSprite2D

@export var alembic_id = 1
@export var interact_type = "none"
@export var interact_label = "none"


# Called when the node enters the scene tree for the first time.
func _ready():
	animation.play("Alembic_Anim")
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
