extends TextureRect

func _get_drag_data(_at_position: Vector2) -> Texture:
	var preview_texture = TextureRect.new()
	
	preview_texture.texture = texture
	preview_texture.expand_mode = 1
	preview_texture.size = Vector2(Global.CELL_WIDTH, Global.CELL_WIDTH)
	preview_texture.position = -preview_texture.size / 2
	
	var preview = Control.new()
	preview.add_child(preview_texture)
	
	set_drag_preview(preview)
	return texture

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is Texture2D

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	texture = data
