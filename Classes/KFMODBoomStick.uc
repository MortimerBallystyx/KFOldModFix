//=============================================================================
// BoomStick Inventory class
//=============================================================================
class KFMODBoomStick extends KFWeaponShotgun;

#EXEC OBJ LOAD FILE=KillingFloorHUD.utx

var     bool        bWaitingToLoadShotty;
var     float       CurrentReloadCountDown;
var()   float       ReloadCountDown;
var     int         SingleShotCount;

replication
{
    reliable if(Role == ROLE_Authority)
        ClientSetSingleShotCount;
}

simulated function WeaponTick(float dt)
{
    super.WeaponTick(dt);

    if( bWaitingToLoadShotty )
    {
        CurrentReloadCountDown -= dt;

        if( CurrentReloadCountDown <= 0 )
        {
            bWaitingToLoadShotty = false;

            if( AmmoAmount(0) > 0 )
            {
                MagAmmoRemaining = Min(AmmoAmount(0), 2);
                SingleShotCount = MagAmmoRemaining;
                ClientSetSingleShotCount(SingleShotCount);
                NetUpdateTime = Level.TimeSeconds - 1;
            }
        }
    }
}

// copy pasted from KFMod.Boomstick just to shut up that weird compiler error
// FIXME later
function AmmoPickedUp()
{
    if( SingleShotCount == 0 )
    {
        MagAmmoRemaining = Min(AmmoAmount(0), 2);
        SingleShotCount = MagAmmoRemaining;
        ClientSetSingleShotCount(SingleShotCount);
        NetUpdateTime = Level.TimeSeconds - 1;
    }
}

simulated function SetPendingReload()
{
    bWaitingToLoadShotty = true;
    CurrentReloadCountDown = ReloadCountDown;
}

simulated function ClientSetSingleShotCount(float NewSingleShotCount)
{
    SingleShotCount = NewSingleShotCount;
}

// Overriden to support the special single firing or dual firing of the shotty
simulated function bool ConsumeAmmo( int Mode, float Load, optional bool bAmountNeededIsMax )
{
    if( super(Weapon).ConsumeAmmo(0, Load, bAmountNeededIsMax) )
    {
        MagAmmoRemaining -= Load;

        NetUpdateTime = Level.TimeSeconds - 1;
        return true;
    }
    return false;
}

//// client only ////
// Overriden to force a single shot if we only have 1 in the pipe
simulated event ClientStartFire(int Mode)
{
    if ( Pawn(Owner).Controller.IsInState('GameEnded') || Pawn(Owner).Controller.IsInState('RoundEnded') )
        return;
    if (Role < ROLE_Authority)
    {
        if( Mode == 1 && MagAmmoRemaining == 1 )
        {
            Mode = 0;
        }

        if (StartFire(Mode))
        {
            ServerStartFire(Mode);
        }
    }
    else
    {
        if( Mode == 1 && MagAmmoRemaining == 1 )
        {
            Mode = 0;
        }

        StartFire(Mode);
    }
}

// Overriden to allow switching between single/dual firing mode on the fly
simulated event ClientStopFire(int Mode)
{
    if( Mode == 0 && Instigator != none && Instigator.Controller != none )
    {
        if( Instigator.Controller.bAltFire == 1 )
            return;
    }

    if (Role < ROLE_Authority)
    {
        StopFire(Mode);
    }

    ServerStopFire(Mode);
}

simulated function bool StartFire(int Mode)
{
    if ( super.StartFire(Mode) )
    {
        if ( Instigator != none && PlayerController(Instigator.Controller) != none &&
             KFSteamStatsAndAchievements(PlayerController(Instigator.Controller).SteamStatsAndAchievements) != none )
        {
            KFSteamStatsAndAchievements(PlayerController(Instigator.Controller).SteamStatsAndAchievements).OnShotHuntingShotgun();
        }

        return true;
    }

    return false;
}

simulated function int AmmoAmount(int mode)
{
    if ( bNoAmmoInstances )
    {
        if ( AmmoClass[0] == AmmoClass[mode] )
            return AmmoCharge[0];
        return AmmoCharge[mode];
    }
    if ( Ammo[0] != none )
        return Ammo[0].AmmoAmount;

    return 0;
}

function bool AllowReload()
{
    if ( MagAmmoRemaining == 1 )
    {
        return false;
    }

    return super.AllowReload();
}

defaultproperties
{
     ReloadCountDown=2.500000
     SingleShotCount=2
     MagCapacity=2
     ReloadRate=0.010000
     ReloadAnim="Reload"
     ReloadAnimRate=0.900000
     WeaponReloadAnim="Reload_HuntingShotgun"
     HudImage=Texture'KillingFloorHUD.WeaponSelect.boomstic_unselected'
     SelectedHudImage=Texture'KillingFloorHUD.WeaponSelect.BoomStick'
     IdleAimAnim="Idle_Iron"
     StandardDisplayFOV=55.000000
     SleeveNum=4
     TraderInfoTexture=Texture'KillingFloorHUD.Trader_Weapon_Images.Trader_Hunting_Shotgun'
     PlayerIronSightFOV=70.000000
     ZoomedDisplayFOV=40.000000
     FireModeClass(0)=class'KFMODBoomStickFire'
     FireModeClass(1)=class'KFMod.NoFire'
     PutDownAnim="PutDown"
     SelectSound=Sound'KF_DoubleSGSnd.2Barrel_Select'
     AIRating=0.900000
     CurrentRating=0.900000
     bSniping=false
     Description="A double barreled shotgun used by big game hunters. It fires two slugs simultaneously and can bring down even the largest targets, quickly."
     DisplayFOV=55.000000
     Priority=20
     InventoryGroup=4
     GroupOffset=1
     PickupClass=class'KFMODBoomStickPickup'
     PlayerViewOffset=(X=8.000000,Y=18.000000,Z=-4.000000)
     BobDamping=6.000000
     AttachmentClass=class'KFMODBoomStickAttachment'
     ItemName="Hunting Shotgun"
     bUseDynamicLights=true
     Mesh=SkeletalMesh'KFWeaponModelsOldMod.BoomStick'
     Skins(0)=Texture'KillingFloorWeapons.Deagle.HandSkinNew'
     Skins(1)=Texture'KillingFloorWeapons.Deagle.ArmSkinNew'
     Skins(2)=Shader'KillingFloorWeapons.BoomStick.BoomStickShader'
     TransientSoundVolume=1.000000
}
