//=============================================================================
// Dualies Ammo.
//=============================================================================
class KFMODDualiesAmmo extends KFAmmunition;

#EXEC OBJ LOAD FILE=InterfaceContent.utx

defaultproperties
{
     AmmoPickupAmount=30
     MaxAmmo=480
     InitialAmount=240
     PickupClass=class'KFMODDualiesAmmoPickup'
     IconMaterial=Texture'KillingFloorHUD.Generic.HUD'
     IconCoords=(X1=413,Y1=82,X2=457,Y2=125)
     ItemName="Dualies bullets"
}
