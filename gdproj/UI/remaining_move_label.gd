extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_label(value: float):
	text = "%2.1fm" % value
