extends Area2D

#Можно улучшить рейкастами, чтобы игнорить то, что за стенами

var interactive_objects = []
@onready var lines = $Lines

func _process(delta):
	if Input.is_action_just_pressed("interact"):
		interact()
	
	
	#отсебятина
	update_lines()

#при входе тела, добавляем его в массив
func _on_body_entered(body):
	if body.is_in_group("Interactive"):
		if not body in interactive_objects:
			interactive_objects.append(body)
			
			
			#отсебятина
			body.clue.visible = true
			add_lines(to_local(body.global_position))

#при выходе тела, удаляем из массива
func _on_body_exited(body):
	delete_body(body)

#удаляем тело из массива и скрываем подсказку
func delete_body(body):
	if body and body.is_in_group("Interactive"):
		if body in interactive_objects:
			var idx = interactive_objects.find(body)
			interactive_objects.remove_at(idx)
			
			
			#отсебятина
			body.clue.visible = false
			remove_lines(idx) #<-- можно убрать

#поиск и возвращение ближайшего тела
func get_nearest():
	var near_dist = 100000
	var near_body: Object
	
	#перебираем все необходимые тела
	for i in interactive_objects:
		#получаем длину вектора от игрока до тела
		#этим вектором выступает локальная к игроку позиция ближайшего тела
		#ведь лок. поз. какбы содержит кончик вектора, начало которого всегда в (0,0)
		var dist = to_local(i.global_position).length()
		if near_dist > dist:
			near_dist = dist
			near_body = i
	return near_body

#взаимодействие с телом, если оно есть
func interact():
	var near_body = get_nearest()
	if near_body:
		#передаем игрока, чтобы на него как-то влиять, если надо
		near_body.interaction(get_parent())

#===========отсебятина===========
func add_lines(pos):
	var new_line = Line2D.new()
	new_line.add_point(Vector2.ZERO)
	new_line.add_point(pos)
	new_line.default_color = Color.RED
	new_line.width = 4
	lines.add_child(new_line)

func remove_lines(idx):
	var rem_line = lines.get_child(idx)
	lines.remove_child(rem_line)
	rem_line.queue_free()

func update_lines():
	for i in range(interactive_objects.size()):
		lines.get_child(i).points[1] = to_local(interactive_objects[i].global_position)
