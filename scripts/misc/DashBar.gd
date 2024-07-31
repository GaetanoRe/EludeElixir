extends TextureProgressBar

var player : Player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_parent().get_parent()
	self.hide()
	value = 0
	player.countdown_start.connect(show_time)
	player.countdown_end.connect(hide_time)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	value = 2 - player.dash_antispam.time_left

func show_time():
	self.show()

func hide_time():
	self.hide()
