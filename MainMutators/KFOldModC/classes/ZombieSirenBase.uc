// Zombie Monster for KF Invasion gametype
class ZombieSirenBase extends KFMonsterold;

var () int ScreamRadius; // AOE for scream attack.

var () class <DamageType> ScreamDamageType;
var () int ScreamForce;

var(Shake)  rotator RotMag;            // how far to rot view
var(Shake)  float   RotRate;           // how fast to rot view
var(Shake)  vector  OffsetMag;         // max view offset vertically
var(Shake)  float   OffsetRate;        // how fast to offset view vertically
var(Shake)  float   ShakeTime;         // how long to shake for per scream
var(Shake)  float   ShakeFadeTime;     // how long after starting to shake to start fading out
var(Shake)  float	ShakeEffectScalar; // Overall scale for shake/blur effect
var(Shake)  float	MinShakeEffectScale;// The minimum that the shake effect drops off over distance
var(Shake)  float	ScreamBlurScale;   // How much motion blur to give from screams

var bool bAboutToDie;
var float DeathTimer;

//-------------------------------------------------------------------------------
// NOTE: All Code resides in the child class(this class was only created to
//         eliminate hitching caused by loading default properties during play)
//-------------------------------------------------------------------------------

defaultproperties
{
     ScreamRadius=800
     ScreamDamageType=Class'KFMod.SirenScreamDamage'
     ScreamForce=-300000
     RotMag=(Pitch=200,Yaw=200,Roll=200)
     RotRate=500.000000
     OffsetMag=(X=45.000000,Y=45.000000,Z=45.000000)
     OffsetRate=500.000000
     ShakeTime=1.900000
     ShakeFadeTime=0.200000
     ShakeEffectScalar=1.100000
     MinShakeEffectScale=0.600000
     ScreamBlurScale=0.800000
     MeleeAnims(0)="Siren_Bite"
     MeleeAnims(1)="Siren_Bite2"
     MeleeAnims(2)="Siren_Bite"
     HitAnims(0)="HitReactionF"
     HitAnims(1)="HitReactionF"
     HitAnims(2)="HitReactionF"
     MoanVoice=SoundGroup'KF_EnemiesFinalSnd.siren.Siren_Talk'
     ZombieFlag=1
     MeleeDamage=8
     damageForce=5000
     KFRagdollName="Siren_Trip"
     ZombieDamType(0)=Class'KFMod.DamTypeSlashingAttack'
     ZombieDamType(1)=Class'KFMod.DamTypeSlashingAttack'
     ZombieDamType(2)=Class'KFMod.DamTypeSlashingAttack'
     JumpSound=SoundGroup'KF_EnemiesFinalSnd.siren.Siren_Jump'
     ScreamDamage=8
     CrispUpThreshhold=7
     bCanDistanceAttackDoors=True
     bUseExtendedCollision=True
     ColOffset=(Z=48.000000)
     ColRadius=25.000000
     ColHeight=5.000000
     ExtCollAttachBoneName="Collision_Attach"
     SeveredLegAttachScale=0.700000
     PlayerCountHealthScale=0.100000
     OnlineHeadshotOffset=(X=6.000000,Z=41.000000)
     OnlineHeadshotScale=1.200000
     HeadHealth=200.000000
     PlayerNumHeadHealthScale=0.050000
     MotionDetectorThreat=2.000000
     HitSound(0)=SoundGroup'KF_EnemiesFinalSnd.siren.Siren_Pain'
     DeathSound(0)=SoundGroup'KF_EnemiesFinalSnd.siren.Siren_Death'
     ChallengeSound(0)=SoundGroup'KF_EnemiesFinalSnd.siren.Siren_Challenge'
     ChallengeSound(1)=SoundGroup'KF_EnemiesFinalSnd.siren.Siren_Challenge'
     ChallengeSound(2)=SoundGroup'KF_EnemiesFinalSnd.siren.Siren_Challenge'
     ChallengeSound(3)=SoundGroup'KF_EnemiesFinalSnd.siren.Siren_Challenge'
     ScoringValue=4
     SoundGroupClass=Class'KFMod.KFFemaleZombieSounds'
     IdleHeavyAnim="Siren_Idle"
     IdleRifleAnim="Siren_Idle"
     MeleeRange=45.000000
     GroundSpeed=100.000000
     WaterSpeed=80.000000
     HealthMax=350.000000
     Health=350
     HeadHeight=1.000000
     HeadScale=1.000000
     MenuName="Siren"
     MovementAnims(0)="Siren_Walk"
     MovementAnims(1)="Siren_Walk"
     MovementAnims(2)="Siren_Walk"
     MovementAnims(3)="Siren_Walk"
     WalkAnims(0)="Siren_Walk"
     WalkAnims(1)="Siren_Walk"
     WalkAnims(2)="Siren_Walk"
     WalkAnims(3)="Siren_Walk"
     IdleCrouchAnim="Siren_Idle"
     IdleWeaponAnim="Siren_Idle"
     IdleRestAnim="Siren_Idle"
     AmbientSound=Sound'KF_BaseSiren.Siren_IdleLoop'
     Mesh=SkeletalMesh'KF_Freaks_Trip.Siren_Freak'
     DrawScale=1.050000
     Skins(0)=FinalBlend'KF_Specimens_Trip_T.siren_hair_fb'
     Skins(1)=Combiner'KF_Specimens_Trip_T.siren_cmb'
     RotationRate=(Yaw=45000,Roll=0)
}
