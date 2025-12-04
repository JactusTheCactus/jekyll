say Welcome to Project: Jekyll!
scoreboard objectives add DamageDealt minecraft.custom:minecraft.damage_dealt
scoreboard objectives add Dhampir dummy
# execute as @a run scoreboard players set @s Dhampir 0
execute as @p run function jekyll:dhampir/give