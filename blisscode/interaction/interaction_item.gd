class_name InteractionItem extends Node2D

@export var item: Item
@export var create_random_item: bool = false

var sprite: Sprite2D

func _ready():
	if create_random_item:
		item = ResourceStore.create_random_item()
	if item:
		set_item(item)

func set_item(new_item: Item):
	if not sprite:
		sprite = Sprite2D.new()
		add_child(sprite)
	item = new_item
	sprite.texture = item.texture
	sprite.hframes = item.hframes
	sprite.vframes = item.vframes
	sprite.frame = item.frame
	if sprite and sprite.material:
		sprite.material.set_shader_parameter("rarity", item.rarity)
