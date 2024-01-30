class_name SpriteSet
extends Resource

enum Type {BUTTON}

## The desired object this should be applied to
@export var type: Type
## The sprites that will be applied to the object.
@export var sprites: TextureLayered

func apply_to(obj: Object):
	
	match obj.get_class():
		"TextureButton" when type == Type.BUTTON:
			obj.texture_normal = ImageTexture.create_from_image(sprites.get_layer_data(0))
			obj.texture_pressed = ImageTexture.create_from_image(sprites.get_layer_data(1))
			obj.texture_disabled = ImageTexture.create_from_image(sprites.get_layer_data(2))
