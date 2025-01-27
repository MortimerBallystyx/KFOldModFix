//=============================================================================
// Dualies Fire
//=============================================================================
class KFMODDualiesFire extends KFFire;

var() Emitter Flash2Emitter;

var()           Emitter         ShellEject2Emitter;          // The shell eject emitter
var()           name            ShellEject2BoneName;         // name of the shell eject bone

var float ClickTime;
var name FireAnim2, FireAimedAnim2;
var name fa;
//var bool bFlashLeft;

simulated function InitEffects()
{
    // don't even spawn on server
    if ( (Level.NetMode == NM_DedicatedServer) || (AIController(Instigator.Controller) != none) )
        return;
    if ( (FlashEmitterClass != none) && ((FlashEmitter == none) || FlashEmitter.bDeleteMe) )
    {
        FlashEmitter = Weapon.Spawn(FlashEmitterClass);
        Weapon.AttachToBone(FlashEmitter, KFWeapon(Weapon).default.FlashBoneName);
    }
    if ( (FlashEmitterClass != none) && ((Flash2Emitter == none) || Flash2Emitter.bDeleteMe) )
    {
        Flash2Emitter = Weapon.Spawn(FlashEmitterClass);
        Weapon.AttachToBone(Flash2Emitter, Dualies(Weapon).default.altFlashBoneName);
    }

    if ( (SmokeEmitterClass != none) && ((SmokeEmitter == none) || SmokeEmitter.bDeleteMe) )
    {
        SmokeEmitter = Weapon.Spawn(SmokeEmitterClass);
    }

    if ( (ShellEjectClass != none) && ((ShellEjectEmitter == none) || ShellEjectEmitter.bDeleteMe) )
    {
        ShellEjectEmitter = Weapon.Spawn(ShellEjectClass);
        Weapon.AttachToBone(ShellEjectEmitter, ShellEjectBoneName);
    }

    if ( (ShellEjectClass != none) && ((ShellEject2Emitter == none) || ShellEject2Emitter.bDeleteMe) )
    {
        ShellEject2Emitter = Weapon.Spawn(ShellEjectClass);
        Weapon.AttachToBone(ShellEject2Emitter, ShellEject2BoneName);
    }
}

simulated function DestroyEffects()
{
    super.DestroyEffects();

    if (ShellEject2Emitter != none)
        ShellEject2Emitter.Destroy();

    if (Flash2Emitter != none)
        Flash2Emitter.Destroy();
}

function DrawMuzzleFlash(Canvas Canvas)
{
    super.DrawMuzzleFlash(Canvas);

    if (ShellEject2Emitter != none )
    {
        Canvas.DrawActor( ShellEject2Emitter, false, false, Weapon.DisplayFOV );
    }
}

function FlashMuzzleFlash()
{
    if (Flash2Emitter == none || FlashEmitter == none)
        return;

    if( KFWeap.bAimingRifle )
    {
        if( FireAimedAnim == 'FireLeft_Iron' )
        {
            Flash2Emitter.Trigger(Weapon, Instigator);
            if (ShellEjectEmitter != none)
            {
                ShellEjectEmitter.Trigger(Weapon, Instigator);
            }
           // bFlashLeft = true;
        }
        else
        {
            FlashEmitter.Trigger(Weapon, Instigator);
            if (ShellEject2Emitter != none)
            {
                ShellEject2Emitter.Trigger(Weapon, Instigator);
            }
          // bFlashLeft = false;
        }
    }
    else
    {
        if(FireAnim == 'FireLeft')
        {
            Flash2Emitter.Trigger(Weapon, Instigator);
            if (ShellEjectEmitter != none)
            {
                ShellEjectEmitter.Trigger(Weapon, Instigator);
            }
           // bFlashLeft = true;
        }
        else
        {
            FlashEmitter.Trigger(Weapon, Instigator);
            if (ShellEject2Emitter != none)
            {
                ShellEject2Emitter.Trigger(Weapon, Instigator);
            }
          // bFlashLeft = false;
        }
    }
}

event ModeDoFire()
{
    local name bn;

    bn = Dualies(Weapon).altFlashBoneName;
    Dualies(Weapon).altFlashBoneName = Dualies(Weapon).FlashBoneName;
    Dualies(Weapon).FlashBoneName = bn;

    super.ModeDoFire();

    if( KFWeap.bAimingRifle )
    {
        fa = FireAimedAnim2;
        FireAimedAnim2 = FireAimedAnim;
        FireAimedAnim = fa;
    }
    else
    {
        fa = FireAnim2;
        FireAnim2 = FireAnim;
        FireAnim = fa;
    }
    InitEffects();
}

function StartBerserk()
{
    DamageMin = default.DamageMin * 1.33;
    DamageMax = default.DamageMax * 1.33;
}

function StopBerserk()
{
    DamageMin = default.DamageMin;
    DamageMax = default.DamageMax;
}

function StartSuperBerserk()
{
    FireRate = default.FireRate * 1.5/Level.GRI.WeaponBerserk;
    FireAnimRate = default.FireAnimRate * 0.667 * Level.GRI.WeaponBerserk;
    DamageMin = default.DamageMin * 1.5;
    DamageMax = default.DamageMax * 1.5;
    // KFTODO: Not sure how to replace this
    //if (AssaultRifle(Weapon) != none && AssaultRifle(Weapon).bDualMode)
    //    FireRate *= 0.55;
}


function DoFireEffect()
{
    local Vector StartTrace;
    local Rotator R, Aim;

    Instigator.MakeNoise(1.0);

    if( KFWeap.bAimingRifle )
    {
        if( FireAimedAnim == 'FireLeft_Iron')
        {
            StartTrace = Instigator.Location + Instigator.EyePosition();
            StartTrace.Y  += (rand(30)+ 5);
        }
        else
        {
            StartTrace = Instigator.Location + Instigator.EyePosition();
        }
    }
    else
    {
        if(FireAnim == 'FireLeft')
        {
            StartTrace = Instigator.Location + Instigator.EyePosition();
            StartTrace.Y  += (rand(30)+ 5);
        }
        else
        {
            StartTrace = Instigator.Location + Instigator.EyePosition();
        }
    }

    Aim = AdjustAim(StartTrace, AimError);
    R = rotator(vector(Aim) + VRand()*FRand()*Spread);
    DoTrace(StartTrace, R);
}

// do a fire effect on clients only, used for causing blood puffs, etc on ragdolls during slomo deaths
simulated function DoClientOnlyFireEffect()
{
    local Vector StartTrace;
    local Rotator R, Aim;

    if( KFWeap.bAimingRifle )
    {
        if( FireAimedAnim == 'FireLeft_Iron')
        {
            StartTrace = Instigator.Location + Instigator.EyePosition();
            StartTrace.Y  += (rand(30)+ 5);
        }
        else
        {
            StartTrace = Instigator.Location + Instigator.EyePosition();
        }
    }
    else
    {
        if(FireAnim == 'FireLeft')
        {
            StartTrace = Instigator.Location + Instigator.EyePosition();
            StartTrace.Y  += (rand(30)+ 5);
        }
        else
        {
            StartTrace = Instigator.Location + Instigator.EyePosition();
        }
    }

    Aim = AdjustAim(StartTrace, AimError);
    R = rotator(vector(Aim) + VRand()*FRand()*Spread);
    DoClientOnlyEffectTrace(StartTrace, R);
}

defaultproperties
{
     FireAnim2="FireLeft"
     FireAimedAnim2="FireLeft_Iron"
     FireAimedAnim="FireRight_Iron"
     RecoilRate=0.070000
     maxVerticalRecoilAngle=450
     maxHorizontalRecoilAngle=50
     StereoFireSound=Sound'KFOldModSnd.Weapon.9mmShot'
     DamageType=class'KFMODDamTypeDualies'
     DamageMin=35
     DamageMax=40
     Momentum=10500.000000
     bPawnRapidFireAnim=true
     bAttachSmokeEmitter=true
     TransientSoundVolume=75.800003
     FireAnim="FireRight"
     FireLoopAnim=
     FireEndAnim=
     TweenTime=0.025000
     FireSound=Sound'KFOldModSnd.Weapon.9mmShot'
     NoAmmoSound=Sound'KF_9MMSnd.9mm_DryFire'
     FireForce="AssaultRifleFire"
     FireRate=0.250000
     AmmoClass=class'KFMODSingleAmmo'
     AmmoPerFire=1
     ShakeRotMag=(X=90.000000,Y=90.000000,Z=90.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=15.000000,Y=15.000000,Z=15.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=2.000000
     BotRefireRate=0.250000
     FlashEmitterClass=class'ROEffects.MuzzleFlash1stMP'
     aimerror=30.000000
     Spread=0.015000
     SpreadStyle=SS_Random
}
