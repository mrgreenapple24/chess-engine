extends ColorRect

var SLOT_ID : int = -1
@onready var filter: ColorRect = $Filter
var moveColor : Color = Color8(186 ,202, 68 , 150)

func _ready() -> void:
	filter.color = Color(0, 0, 0, 0)

func change_colour() -> void:
	if filter.color == moveColor:
		filter.color = Color(0, 0, 0, 0)
	else:
		filter.color = moveColor
