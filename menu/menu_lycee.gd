extends Control

signal play

@onready var sprite1: AnimatedSprite2D = $AnimatedSprite2D4
@onready var sprite2: AnimatedSprite2D = $AnimatedSprite2D5
@onready var sprite3: AnimatedSprite2D = $AnimatedSprite2D6

@onready var area_derivee = $Area2DDerivee
@onready var area_secdeg = $Area2DSecDeg
@onready var area_discriminant = $Area2DDiscriminant

# Précharge toutes les scènes ciblées
var scene_derivee = preload("res://test.tscn")
var scene_secdeg = preload("res://test.tscn")
var scene_discriminant = preload("res://test.tscn")

# Suivi de l'état
var player_in_derivee = false
var player_in_secdeg = false
var player_in_discriminant = false

var target_scene = null
var target_sprite: AnimatedSprite2D = null
var animation_played = false

func _ready():

	area_derivee.body_entered.connect(_on_entered_derivee)
	area_derivee.body_exited.connect(_on_exited_derivee)

	area_secdeg.body_entered.connect(_on_entered_secdeg)
	area_secdeg.body_exited.connect(_on_exited_secdeg)

	area_discriminant.body_entered.connect(_on_entered_discriminant)
	area_discriminant.body_exited.connect(_on_exited_discriminant)

# Fonctions pour détecter la présence du joueur dans chaque zone
func _on_entered_derivee(body):
	if body.name == "Player":
		player_in_derivee = true

func _on_exited_derivee(body):
	if body.name == "Player":
		player_in_derivee = false

func _on_entered_secdeg(body):
	if body.name == "Player":
		player_in_secdeg = true

func _on_exited_secdeg(body):
	if body.name == "Player":
		player_in_secdeg = false

func _on_entered_discriminant(body):
	if body.name == "Player":
		player_in_discriminant = true

func _on_exited_discriminant(body):
	if body.name == "Player":
		player_in_discriminant = false

# Vérifie à chaque frame si le joueur appuie sur Entrée dans une zone
func _process(delta):
	if Input.is_action_just_pressed("enter") and not animation_played:
		if player_in_derivee:
			_start_transition(scene_derivee, sprite1)
		elif player_in_secdeg:
			_start_transition(scene_secdeg, sprite2)
		elif player_in_discriminant:
			_start_transition(scene_discriminant, sprite3)

# Démarre la transition (animation + changement de scène)
func _start_transition(scene, sprite):
	animation_played = true
	target_scene = scene
	target_sprite = sprite
	target_sprite.play("splash")
	play.emit()

	# Connecte l'événement de fin d'animation s’il n’est pas déjà connecté
	if not target_sprite.is_connected("animation_finished", Callable(self, "_on_animation_finished")):
		target_sprite.connect("animation_finished", Callable(self, "_on_animation_finished"))

# Quand l'animation est finie, on change de scène
func _on_animation_finished():
	get_tree().change_scene_to_packed(target_scene)
