//=============================================================================
// Winchester Inventory class
//=============================================================================
class KFMODWinchester extends KFWeaponShotgun;

// KFTODO - Slomo compensation R&D, finish later if I have time - Ramm
//exec function ToggleComp()
//{
//    WinchesterFire(FireMode[0]).bDoSlomoCompensation = !WinchesterFire(FireMode[0]).bDoSlomoCompensation;
//}

//I'll just copy and paste the damn things if you want them
//so badly.
// AI Interface
function float GetAIRating()
{
    local Bot B;
    local float EnemyDist;
    local vector EnemyDir;

    B = Bot(Instigator.Controller);
    if ( B == none )
        return AIRating;

    if ( (B.Target != none) && (Pawn(B.Target) == none) && (VSize(B.Target.Location - Instigator.Location) < 1250) )
        return 0.9;

    if ( B.Enemy == none )
    {
        if ( (B.Target != none) && VSize(B.Target.Location - B.Pawn.Location) > 3500 )
            return 0.2;
        return AIRating;
    }

    EnemyDir = B.Enemy.Location - Instigator.Location;
    EnemyDist = VSize(EnemyDir);
    if ( EnemyDist > 750 )
    {
        if ( EnemyDist > 2000 )
        {
            if ( EnemyDist > 3500 )
                return 0.2;
            return (AIRating - 0.3);
        }
        if ( EnemyDir.Z < -0.5 * EnemyDist )
            return (AIRating - 0.3);
    }
    else if ( (B.Enemy.Weapon != none) && B.Enemy.Weapon.bMeleeWeapon )
        return (AIRating + 0.35);
    else if ( EnemyDist < 400 )
        return (AIRating + 0.2);
    return FMax(AIRating + 0.2 - (EnemyDist - 400) * 0.0008, 0.2);
}

function float SuggestAttackStyle()
{
    if ( (AIController(Instigator.Controller) != none)
        && (AIController(Instigator.Controller).Skill < 3) )
        return 0.4;
    return 0.8;
}

simulated function bool CanZoomNow()
{
    return (!FireMode[0].bIsFiring && Instigator!=none && Instigator.Physics!=PHYS_Falling);
}

simulated function SetZoomBlendColor(Canvas c)
{
    local Byte    val;
    local Color   clr;
    local Color   fog;

    clr.R = 255;
    clr.G = 255;
    clr.B = 255;
    clr.A = 255;

    if( Instigator.Region.Zone.bDistanceFog )
    {
        fog = Instigator.Region.Zone.DistanceFogColor;
        val = 0;
        val = Max( val, fog.R);
        val = Max( val, fog.G);
        val = Max( val, fog.B);

        if( val > 128 )
        {
            val -= 128;
            clr.R -= val;
            clr.G -= val;
            clr.B -= val;
        }
    }
    c.DrawColor = clr;
}

// Overridden to take out some UT stuff
simulated event RenderOverlays( Canvas Canvas )
{
    super.RenderOverlays( Canvas );
    if ( bAimingRifle )
    {
       SetZoomBlendColor(Canvas);
    }
}

defaultproperties
{
     MagCapacity=10
     ReloadRate=0.666667
     ReloadAnim="Reload"
     ReloadAnimRate=1.000000
     WeaponReloadAnim="Reload_Winchester"
     HudImage=Texture'KillingFloorHUD.WeaponSelect.winchester_unselected'
     SelectedHudImage=Texture'KillingFloorHUD.WeaponSelect.Winchester'
     Weight=6.000000
     bHasAimingMode=true
     IdleAimAnim="Idle"
     StandardDisplayFOV=70.000000
     bModeZeroCanDryFire=true
     SleeveNum=5
     TraderInfoTexture=Texture'KillingFloorHUD.Trader_Weapon_Images.Trader_Winchester'
     PlayerIronSightFOV=70.000000
     ZoomedDisplayFOV=50.000000
     FireModeClass(0)=class'KFMODWinchesterFire'
     FireModeClass(1)=class'KFMod.NoFire'
     PutDownAnim="PutDown"
     SelectSound=Sound'KF_RifleSnd.Rifle_Select'
     AIRating=0.560000
     CurrentRating=0.560000
     bShowChargingBar=true
     OldCenteredOffsetY=0.000000
     OldPlayerViewOffset=(X=-8.000000,Y=5.000000,Z=-6.000000)
     OldSmallViewOffset=(X=4.000000,Y=11.000000,Z=-12.000000)
     OldPlayerViewPivot=(Pitch=800)
     OldCenteredRoll=3000
     Description="A rugged and reliable single-shot rifle.  "
     EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
     DisplayFOV=70.000000
     Priority=9
     CenteredOffsetY=-5.000000
     CenteredRoll=3000
     CenteredYaw=-1500
     InventoryGroup=3
     GroupOffset=3
     PickupClass=class'KFMODWinchesterPickup'
     PlayerViewOffset=(X=8.000000,Y=18.000000,Z=-4.000000)
     BobDamping=6.000000
     AttachmentClass=class'KFMODWinchesterAttachment'
     ItemName="Winchester"
     bUseDynamicLights=true
     Mesh=SkeletalMesh'KFWeaponModelsOldMod.Winchester'
     DrawScale=0.900000
     Skins(0)=Texture'KillingFloorWeapons.Deagle.HandSkinNew'
     Skins(1)=Texture'KillingFloorWeapons.Deagle.ArmSkinNew'
     Skins(2)=Shader'KillingFloorWeapons.Winchester.LawShineShader'
     Skins(3)=Shader'KillingFloorWeapons.Winchester.LawShineShader'
     TransientSoundVolume=50.000000
}
