-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- jairCreaCta
DELIMITER ;
DROP PROCEDURE IF EXISTS `jairCreaCta`;DELIMITER $$

CREATE PROCEDURE `jairCreaCta`(
	Par_ClienteID			int(11),

	Aud_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint


	)
TerminaStore: BEGIN

DECLARE DIRECCION int;
DECLARE  Entero_Cero       int;
DECLARE  Decimal_Cero      decimal(12,2);
DECLARE	Cadena_Vacia		char(1);

set Entero_Cero 			:=0;
Set Cadena_Vacia			:= '';
set Decimal_Cero 			:=0.00;

Set Aud_FechaActual := CURRENT_TIMESTAMP();


if(not exists(select ClienteID
			from CLIENTES
			where ClienteID = Par_ClienteID)) then
	select '001' as NumErr,
			'El Numero de Cliente no existe.' as ErrMen,
			'numero' as control,
			Entero_Cero as consecutivo;
	LEAVE TerminaStore;
end if;

if not exists (select * from DIRECCLIENTE WHERE ClienteID=Par_ClienteID) then
insert into DIRECCLIENTE VALUES (	Par_ClienteID, 1, 1, 1,20,
								67,42860,86714,'COLONIA CUAUHTÉMOC',
								'2DA. PONIENTE','118','','','','',
								'68030','2DA. PONIENTE, No. 118, COL. COLONIA CUAUHTÉMOC, C.P 68030, OAXACA DE JUAREZ, OAXACA','','','','S',
								'','',1,now(),'127.0.0.1','manual',
								1,1);
end if;

call CUENTASAHOALT(	1,	Par_ClienteID,	'',
	1,	1,	now(),	'Cuenta Credito',	'D',
	1,	'S',
	Aud_EmpresaID		,
	Aud_Usuario			,
	Aud_FechaActual		,
	Aud_DireccionIP		,
	Aud_ProgramaID		,
	Aud_Sucursal			,
	Aud_NumTransaccion
	);





select '000' as NumErr ,
		  'cuenta agregada.' as ErrMen,
		  'areaID' as control;

END TerminaStore$$