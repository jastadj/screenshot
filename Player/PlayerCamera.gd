extends Camera2D

func ScreenToWorld(pos):
	
	pos = (pos - (get_viewport().size * zoom.x) )* zoom.x
	var trans = get_parent().get_transform().xform(pos)
	
	#print( trans)
	
	return trans
	
func WorldToScreen(pos):
	
	var trans = get_viewport_transform() * pos
	
	#print(trans)
	
	return trans
	