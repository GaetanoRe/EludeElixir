#extends Node2D
#
#@onready var dash_time : Timer = $dash_time
#@onready var dash_antispam : Timer = $dash_antispam
#@export var dash_speed = 3600
#var dashing = false
#var can_dash = true
#
#
#func start_dash():
	#dashing = true
	#can_dash = false
	#dash_time.start()
	#dash_antispam.start()
#
##func is_dashing():
	##return !dash_time.is_stopped()
#
#
#func _on_dash_time_timeout():
	#dashing = false
#
#
#func _on_dash_antispam_timeout():
	#can_dash = true

