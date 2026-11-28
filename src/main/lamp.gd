extends Node3D

@onready var omni_light_3d: OmniLight3D = $OmniLight3D
@onready var area_3d: Area3D = $Area3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_3d.activate.connect(lamp_switch)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func lamp_switch():
	omni_light_3d.visible = not omni_light_3d.visible
