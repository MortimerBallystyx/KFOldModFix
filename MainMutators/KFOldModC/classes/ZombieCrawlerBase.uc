// Zombie Monster for KF Invasion gametype
class ZombieCrawlerBase extends KFMonsterold;

#exec OBJ LOAD FILE=KFOldModSnd.uax

var() float PounceSpeed;
var bool bPouncing;

var(Anims)  name    MeleeAirAnims[3]; // Attack anims for when flying through the air

//-------------------------------------------------------------------------------
// NOTE: All Code resides in the child class(this class was only created to
//         eliminate hitching caused by loading default properties during play)
//-------------------------------------------------------------------------------

function bool DoPounce()
{
	if ( bIsCrouched || bWantsToCrouch || (Physics != PHYS_Walking) || VSize(Location - Controller.Target.Location) > (MeleeRange * 5) )
		return false;

	Velocity = Normal(Controller.Target.Location-Location)*PounceSpeed;
	Velocity.Z = JumpZ;
	SetPhysics(PHYS_Falling);
	ZombieSpringAnim();
	bPouncing=true;
	return true;
}

simulated function ZombieSpringAnim()
{
	SetAnimAction('ZombieSpring');
}

event Landed(vector HitNormal)
{
	bPouncing=false;
	super.Landed(HitNormal);
}

event Bump(actor Other)
{
	// TODO: is there a better way
	if(bPouncing && KFHumanPawn(Other)!=none )
	{
		KFHumanPawn(Other).TakeDamage(((MeleeDamage - (MeleeDamage * 0.05)) + (MeleeDamage * (FRand() * 0.1))), self ,self.Location,self.velocity, class 'KFmod.ZombieMeleeDamage');
		if (KFHumanPawn(Other).Health <=0)
		{
			//TODO - move this to humanpawn.takedamage? Also see KFMonster.MeleeDamageTarget
			KFHumanPawn(Other).SpawnGibs(self.rotation, 1);
		}
		//After impact, there'll be no momentum for further bumps
		bPouncing=false;
	}
}

// Blend his attacks so he can hit you in mid air.
simulated function int DoAnimAction( name AnimName )
{
	if( AnimName=='ZombieLeapAttack' || AnimName=='LeapAttack3' || AnimName=='ZombieLeapAttack' )
	{
		AnimBlendParams(1, 1.0, 0.0,, 'Bip01 Spine1');
		PlayAnim(AnimName,, 0.0, 1);
		return 1;
	}

    if( AnimName=='HitF' )
	{
		AnimBlendParams(1, 1.0, 0.0,, NeckBone);
		PlayAnim(AnimName,, 0.0, 1);
		return 1;
	}

	if( AnimName=='ZombieSpring' )
	{
        PlayAnim(AnimName,,0.02);
        return 0;
	}

	return Super.DoAnimAction(AnimName);
}

simulated event SetAnimAction(name NewAction)
{
	local int meleeAnimIndex;

	if( NewAction=='' )
		Return;
	if(NewAction == 'Claw')
	{
		meleeAnimIndex = Rand(2);
		if( Physics == PHYS_Falling )
		{
            NewAction = MeleeAirAnims[meleeAnimIndex];
		}
		else
		{
            NewAction = meleeAnims[meleeAnimIndex];
		}
		CurrentDamtype = ZombieDamType[meleeAnimIndex];
	}
	ExpectingChannel = DoAnimAction(NewAction);

    if( AnimNeedsWait(NewAction) )
    {
        bWaitForAnim = true;
    }

	if( Level.NetMode!=NM_Client )
	{
		AnimAction = NewAction;
		bResetAnimAct = True;
		ResetAnimActTime = Level.TimeSeconds+0.3;
	}
}

// The animation is full body and should set the bWaitForAnim flag
simulated function bool AnimNeedsWait(name TestAnim)
{
    if( TestAnim == 'ZombieSpring' || TestAnim == 'ZombieLeapAttack' )
    {
        return true;
    }

    return false;
}

function bool FlipOver()
{
	Return False;
}

defaultproperties
{
     PounceSpeed=330.000000
     MeleeAirAnims(0)="LeapAttack3"
     MeleeAirAnims(1)="LeapAttack3"
     MeleeAnims(0)="ZombieLeapAttack"
     MeleeAnims(1)="ZombieLeapAttack2"
     HitAnims(1)="HitF"
     HitAnims(2)="HitF"
     MoanVoice=SoundGroup'KFOldModSnd.ZedVoice.CrawlerMoan'
     KFHitFront="HitF"
     KFHitBack="HitF"
     KFHitLeft="HitF"
     KFHitRight="HitF"
     bStunImmune=True
     bCannibal=True
     ZombieFlag=2
     MeleeDamage=7
     damageForce=5000
     KFRagdollName="Crawler_Trip"
     MeleeAttackHitSound=SoundGroup'KFOldModSnd.Damage.HurtSurvivor'
     JumpSound=Sound'KFOldModSnd.ZED.CrawlerHiss'
     CrispUpThreshhold=10
     Intelligence=BRAINS_Mammal
     SeveredArmAttachScale=0.800000
     SeveredLegAttachScale=0.850000
     SeveredHeadAttachScale=1.100000
     OnlineHeadshotOffset=(X=28.000000,Z=7.000000)
     OnlineHeadshotScale=1.200000
     MotionDetectorThreat=0.340000
     HitSound(0)=SoundGroup'KFOldModSnd.ZED.ZomPain'
     DeathSound(0)=SoundGroup'KFOldModSnd.ZED.ZombieDeath'
     ChallengeSound(0)=SoundGroup'KFOldModSnd.ZedVoice.CrawlerMoan'
     ChallengeSound(1)=SoundGroup'KFOldModSnd.ZedVoice.CrawlerMoan'
     ChallengeSound(2)=SoundGroup'KFOldModSnd.ZedVoice.CrawlerMoan'
     ChallengeSound(3)=SoundGroup'KFOldModSnd.ZedVoice.CrawlerMoan'
     ScoringValue=1
     IdleHeavyAnim="ZombieLeapIdle"
     IdleRifleAnim="ZombieLeapIdle"
     bCrawler=True
     GroundSpeed=140.000000
     WaterSpeed=130.000000
     JumpZ=350.000000
     Health=100
     HeadHeight=2.500000
     HeadScale=1.050000
     MenuName="Crawler"
     ControllerClass=Class'KFOldModC.CrawlerController'
     bDoTorsoTwist=False
     MovementAnims(0)="ZombieScuttle"
     MovementAnims(1)="ZombieScuttleB"
     MovementAnims(2)="ZombieScuttleL"
     MovementAnims(3)="ZombieScuttleR"
     WalkAnims(0)="ZombieScuttle"
     WalkAnims(1)="ZombieScuttleB"
     WalkAnims(2)="ZombieScuttleL"
     WalkAnims(3)="ZombieScuttleR"
     AirAnims(0)="ZombieSpring"
     AirAnims(1)="ZombieSpring"
     AirAnims(2)="ZombieSpring"
     AirAnims(3)="ZombieSpring"
     TakeoffAnims(0)="ZombieSpring"
     TakeoffAnims(1)="ZombieSpring"
     TakeoffAnims(2)="ZombieSpring"
     TakeoffAnims(3)="ZombieSpring"
     AirStillAnim="ZombieSpring"
     TakeoffStillAnim="ZombieLeapIdle"
     IdleCrouchAnim="ZombieLeapIdle"
     IdleWeaponAnim="ZombieLeapIdle"
     IdleRestAnim="ZombieLeapIdle"
     bOrientOnSlope=True
     AmbientSound=Sound'KF_BaseCrawler.Crawler_Idle'
     Mesh=SkeletalMesh'KF_Freaks_Trip.Crawler_Freak'
     DrawScale=1.100000
     PrePivot=(Z=0.000000)
     Skins(0)=Combiner'KF_Specimens_Trip_T.crawler_cmb'
     SoundVolume=0
     SoundRadius=0.000000
     CollisionHeight=25.000000
}
