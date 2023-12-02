-- Instantiate the sound table for the collistion sounds 
----------------------------------------
local soundTable = {
		bulletToEnemy = audio.loadSound("bulletToEnemy.wav"), 
		bulletToBoss = audio.loadSound("bulletToBoss.wav"),
		enemyBullet = audio.loadSound("enemyBulletToPlayer.wav"),
		bossBullet = audio.loadSound("bossBulletToPlayer.wav")
	}
	
return soundTable