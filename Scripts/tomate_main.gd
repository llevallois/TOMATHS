extends CharacterBody2D

const MAX_PV = 10 #nombre de points de vie de la tomate
var vie = MAX_PV 

signal tomate_mort

func _ready():
	%BarreDeVie.max_value = MAX_PV
	%BarreDeVie.value = MAX_PV

func _physics_process(delta):
	var liste_entites_touche = %Hurtbox.get_overlapping_bodies()

func _on_hurtbox_body_entered(body):
	if body.has_method("die"):
		vie-=1

		if(vie == 0):
				#visible= false
				tomate_mort.emit()
		%BarreDeVie.value=vie # ne change la valeur de la barre de vie que si l'objet qui rentre est un ennemi (sinon la barre de vie met des degats a la tomate)
		body.die() # Replace with function body.
		Global.score-=100
		

func reset_vie():
	vie = MAX_PV
	%BarreDeVie.value= vie
