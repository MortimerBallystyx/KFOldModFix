//=============================================================================
// Deagle Fire
//=============================================================================
class KFMODDeagleFire extends KFFire;

function DoTrace(Vector Start, Rotator Dir)
{
    local Vector X,Y,Z, End, HitLocation, HitNormal, ArcEnd;
    local Actor Other;
    local byte HitCount,HCounter;
    local float HitDamage;
    local array<int>    HitPoints;
    local KFPawn HitPawn;
    local array<Actor>    IgnoreActors;
    local Actor DamageActor;
    local int i;

    MaxRange();

    Weapon.GetViewAxes(X, Y, Z);
    if ( Weapon.WeaponCentered() )
    {
        ArcEnd = (Instigator.Location + Weapon.EffectOffset.X * X + 1.5 * Weapon.EffectOffset.Z * Z);
    }
    else
    {
        ArcEnd = (Instigator.Location + Instigator.CalcDrawOffset(Weapon) + Weapon.EffectOffset.X * X +
         Weapon.Hand * Weapon.EffectOffset.Y * Y + Weapon.EffectOffset.Z * Z);
    }

    X = Vector(Dir);
    End = Start + TraceRange * X;
    HitDamage = DamageMax;
    While( (HitCount++)<10 )
    {
        DamageActor = none;

        Other = Instigator.HitPointTrace(HitLocation, HitNormal, End, HitPoints, Start,, 1);
        if( Other==none )
        {
            Break;
        }
        else if( Other==Instigator || Other.Base == Instigator )
        {
            IgnoreActors[IgnoreActors.Length] = Other;
            Other.SetCollision(false);
            Start = HitLocation;
            Continue;
        }

        if( ExtendedZCollision(Other)!=none && Other.Owner!=none )
        {
            IgnoreActors[IgnoreActors.Length] = Other;
            IgnoreActors[IgnoreActors.Length] = Other.Owner;
            Other.SetCollision(false);
            Other.Owner.SetCollision(false);
            DamageActor = Pawn(Other.Owner);
        }

        if ( !Other.bWorldGeometry && Other!=Level )
        {
            HitPawn = KFPawn(Other);

            if ( HitPawn != none )
            {
                 // Hit detection debugging
                 /*log("PreLaunchTrace hit "$HitPawn.PlayerReplicationInfo.PlayerName);
                 HitPawn.HitStart = Start;
                 HitPawn.HitEnd = End;*/
                 if(!HitPawn.bDeleteMe)
                     HitPawn.ProcessLocationalDamage(int(HitDamage), Instigator, HitLocation, Momentum*X,DamageType,HitPoints);

                 // Hit detection debugging
                 /*if( Level.NetMode == NM_Standalone)
                       HitPawn.DrawBoneLocation();*/

                IgnoreActors[IgnoreActors.Length] = Other;
                IgnoreActors[IgnoreActors.Length] = HitPawn.AuxCollisionCylinder;
                Other.SetCollision(false);
                HitPawn.AuxCollisionCylinder.SetCollision(false);
                DamageActor = Other;
            }
            else
            {
                if( KFMonster(Other)!=none )
                {
                    IgnoreActors[IgnoreActors.Length] = Other;
                    Other.SetCollision(false);
                    DamageActor = Other;
                }
                else if( DamageActor == none )
                {
                    DamageActor = Other;
                }
                Other.TakeDamage(int(HitDamage), Instigator, HitLocation, Momentum*X, DamageType);
            }
            if( (HCounter++)>=4 || Pawn(DamageActor)==none )
            {
                Break;
            }
            HitDamage/=2;
            Start = HitLocation;
        }
        else if ( HitScanBlockingVolume(Other)==none )
        {
            if( KFWeaponAttachment(Weapon.ThirdPersonActor)!=none )
              KFWeaponAttachment(Weapon.ThirdPersonActor).UpdateHit(Other,HitLocation,HitNormal);
            Break;
        }
    }

    // Turn the collision back on for any actors we turned it off
    if ( IgnoreActors.Length > 0 )
    {
        for (i=0; i<IgnoreActors.Length; i++)
        {
            IgnoreActors[i].SetCollision(true);
        }
    }
}

defaultproperties
{
     FireAimedAnim="Fire"
     RecoilRate=0.070000
     maxVerticalRecoilAngle=1200
     maxHorizontalRecoilAngle=200
     ShellEjectBoneName="Shell_eject"
     StereoFireSound=Sound'KFOldModSnd.Weapon.50CalFire'
     DamageType=class'KFMODDamTypeDeagle'
     DamageMin=115
     DamageMax=136
     Momentum=20000.000000
     bPawnRapidFireAnim=true
     bWaitForRelease=true
     bAttachSmokeEmitter=true
     TransientSoundVolume=100.000000
     FireLoopAnim=
     FireEndAnim=
     TweenTime=0.025000
     FireSound=Sound'KFOldModSnd.Weapon.50CalFire'
     NoAmmoSound=Sound'KF_HandcannonSnd.50AE_DryFire'
     FireRate=0.520000
     AmmoClass=class'KFMODDeagleAmmo'
     AmmoPerFire=1
     ShakeRotMag=(X=75.000000,Y=75.000000,Z=400.000000)
     ShakeRotRate=(X=12500.000000,Y=12500.000000,Z=10000.000000)
     ShakeRotTime=3.500000
     ShakeOffsetMag=(X=6.000000,Y=1.000000,Z=8.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=2.500000
     BotRefireRate=0.650000
     FlashEmitterClass=class'ROEffects.MuzzleFlash1stKar'
     aimerror=40.000000
     Spread=0.010000
     SpreadStyle=SS_Random
}
