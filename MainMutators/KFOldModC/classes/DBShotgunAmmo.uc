//=============================================================================
// DB Shotgun Ammo.
//=============================================================================
class DBShotgunAmmo extends KFAmmunition;

#EXEC OBJ LOAD FILE=KillingFloorHUD.utx

defaultproperties
{
     AmmoPickupAmount=10
     MaxAmmo=46
     InitialAmount=46
     IconMaterial=Texture'KillingFloorHUD.Generic.HUD'
     IconCoords=(X1=451,Y1=445,X2=510,Y2=500)
     ItemName="Shotgun Ammo"
}
