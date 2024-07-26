extends TextureProgressBar

@onready var max_doses : int = 5
@onready var player : Player
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("Player")
	player.doses_changed.connect(update_doses)
	value = 100


func update_doses():
	value -= (100 / player.max_doses)
#
#

func update_max_doses(num):
	max_doses = num
