class DamTypeCrossbow extends KFProjectileWeaponDamageType;

static function AwardKill(KFSteamStatsAndAchievements KFStatsAndAchievements, KFPlayerController Killer, KFMonster Killed )
{
	if( KFStatsAndAchievements!=None && Killed.BurnDown>0 )
		KFStatsAndAchievements.AddBurningCrossbowKill();
}

defaultproperties
{
     HeadShotDamageMult=1.300000
     bSniperWeapon=True
     bThrowRagdoll=True
     bRagdollBullet=True
     DamageThreshold=1
     KDamageImpulse=2000.000000
     KDeathVel=110.000000
     KDeathUpKick=10.000000
}
