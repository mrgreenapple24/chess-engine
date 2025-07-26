extends Node2D

func load_texture(PieceType: int) -> void:
	$Icon.texture = Global.pieceSprite(PieceType)
	$Icon.size = Vector2(Global.CELL_WIDTH, Global.CELL_WIDTH)
