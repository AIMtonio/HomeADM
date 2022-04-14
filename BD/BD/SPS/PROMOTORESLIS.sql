-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROMOTORESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PROMOTORESLIS`;
DELIMITER $$

CREATE PROCEDURE `PROMOTORESLIS`(
	Par_NombPromot		varchar(50),
	Par_SucursalID		int,
	Par_NumLis			tinyint unsigned,

	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint

)
TerminaStore: BEGIN




DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Lis_Principal	int;
DECLARE	Lis_Activos		int;
DECLARE Lis_Promotores  int;
DECLARE Lis_PromSucur	INT;
DECLARE Lis_PromGestor  int;
DECLARE Est_Activo 		char(1);
DECLARE Lis_PromCaptacion int;
DECLARE Captacion       char(2);
DECLARE EjecAmbos		char(1);
DECLARE Lis_ClienteMenor INT;
DECLARE Lis_PromSucurWS  INT;
DECLARE Lis_PromActivo	 INT;



Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia			:= '1900-01-01';
Set	Entero_Cero			:= 0;
Set	Lis_Principal		:= 1;
Set	Lis_Activos			:= 2;
Set Lis_Promotores	 	:= 3;
SET Lis_PromSucur		:= 4;
Set Lis_PromGestor		:= 5;
SET Lis_PromCaptacion	:= 8;
Set Lis_PromSucurWS     := 9;
Set Lis_PromActivo		:= 10;

Set Est_Activo			:='A';
set Captacion           :='CA';
Set EjecAmbos			:='A';

if(Par_NumLis = Lis_Principal) then
	select	`PromotorID`,		`NombrePromotor`
	from PROMOTORES
	where  NombrePromotor like concat("%", Par_NombPromot, "%")
	limit 0, 15;
end if;


if(Par_NumLis = Lis_Activos) then
	select	`PromotorID`,		`NombrePromotor`, NombreSucurs
	from PROMOTORES pro,
			SUCURSALES su
	where pro.Estatus = Est_Activo
	and pro.SucursalID = su.SucursalID
	and pro.SucursalID = Par_SucursalID
    and  NombrePromotor like concat("%", Par_NombPromot, "%")
	limit 0, 15;
end if;

if(Par_NumLis = Lis_Promotores) then
	select	`PromotorID`,		`NombrePromotor`
	from PROMOTORES
	limit 0, 15;
end if;

IF(Par_NumLis = Lis_PromSucur) THEN
	 select	Pro.PromotorID,		Pro.NombrePromotor , Suc.NombreSucurs
	  from PROMOTORES Pro, SUCURSALES Suc
	  where Pro.Estatus = Est_Activo
	  and Pro.SucursalID = Suc.SucursalID
	  and Pro.SucursalID = Par_SucursalID
	  and Pro.NombrePromotor LIKE CONCAT("%", Par_NombPromot, "%")
	  limit 0, 15;
end if;




if (Par_NumLis = Lis_PromCaptacion) then
	select PromotorID, NombrePromotor
		from PROMOTORES
		where Estatus = Est_Activo AND (AplicaPromotor = Captacion OR AplicaPromotor = EjecAmbos)

		limit 0, 15;

end if;



IF(Par_NumLis = Lis_PromSucurWS) THEN
 select	Pro.PromotorID as Id_Segmento,
        Pro.NombrePromotor as DescSegmento
	  from PROMOTORES Pro, SUCURSALES Suc
	  where Pro.Estatus = Est_Activo
	  and Pro.SucursalID = Suc.SucursalID
	  and Pro.SucursalID = Par_SucursalID;
end if;


if(Par_NumLis = Lis_PromActivo) then
	select	`PromotorID`,		`NombrePromotor`
	from PROMOTORES
	where  NombrePromotor like concat("%", Par_NombPromot, "%")
	and Estatus = Est_Activo
	limit 0, 15;
end if;

END TerminaStore$$