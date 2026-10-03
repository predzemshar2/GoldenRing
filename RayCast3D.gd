extends RayCast3D

#func _process(_delta):
#	# Преобразуем позицию мыши на экране в луч в мире
#	var from = get_viewport().get_camera_3d().project_ray_origin(get_viewport().get_mouse_position())
#	var to = from + get_viewport().get_camera_3d().project_ray_origin(get_viewport().get_mouse_position()) * 100.0
#
#	# Обновляем луч
##	$".".set_cast_to(to - from)
#	force_raycast_update()
#
#	# Получаем объект, в который попали
#	if is_colliding():
#		var collider = get_collider()
#		print("Навели на объект: ", collider.name)
#	else:
#		print("Ни на что не навели")
