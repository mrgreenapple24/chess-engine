extends Node

const CELL_WIDTH = 45

enum piece { NONE, KING, QUEEN, ROOK, BISHOP, KNIGHT, PAWN, WHITE = 8, BLACK = 16 }

const BLACK_BISHOP = preload("res://Assets/black_bishop.svg")
const BLACK_KING = preload("res://Assets/black_king.svg")
const BLACK_KNIGHT = preload("res://Assets/black_knight.svg")
const BLACK_PAWN = preload("res://Assets/black_pawn.svg")
const BLACK_QUEEN = preload("res://Assets/black_queen.svg")
const BLACK_ROOK = preload("res://Assets/black_rook.svg")
const WHITE_BISHOP = preload("res://Assets/white_bishop.svg")
const WHITE_KING = preload("res://Assets/white_king.svg")
const WHITE_KNIGHT = preload("res://Assets/white_knight.svg")
const WHITE_PAWN = preload("res://Assets/white_pawn.svg")
const WHITE_QUEEN = preload("res://Assets/white_queen.svg")
const WHITE_ROOK = preload("res://Assets/white_rook.svg")

var pos1 : Vector2i
var pos2 : Vector2i

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func pieceSprite(pieceType: int) -> Texture:
	var sprite : Texture
	match pieceType:
		piece.KING | piece.WHITE: sprite = WHITE_KING
		piece.QUEEN | piece.WHITE: sprite = WHITE_QUEEN
		piece.ROOK | piece.WHITE: sprite = WHITE_ROOK
		piece.BISHOP | piece.WHITE: sprite = WHITE_BISHOP
		piece.KNIGHT | piece.WHITE: sprite = WHITE_KNIGHT
		piece.PAWN | piece.WHITE: sprite = WHITE_PAWN
		piece.KING | piece.BLACK: sprite = BLACK_KING
		piece.QUEEN | piece.BLACK: sprite = BLACK_QUEEN
		piece.ROOK | piece.BLACK: sprite = BLACK_ROOK
		piece.BISHOP | piece.BLACK: sprite = BLACK_BISHOP
		piece.KNIGHT | piece.BLACK: sprite = BLACK_KNIGHT
		piece.PAWN | piece.BLACK: sprite = BLACK_PAWN
	return sprite
