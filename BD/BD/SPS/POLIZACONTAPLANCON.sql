-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- POLIZACONTAPLANCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `POLIZACONTAPLANCON`;DELIMITER $$

CREATE PROCEDURE `POLIZACONTAPLANCON`(
    Par_PolizaID		int,
    Par_NumCon			tinyint unsigned,

	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
		)
BEGIN

DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Con_Principal	int;

Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Con_Principal	:= 2;


if(Par_NumCon = Con_Principal) then
   Select 	PolizaID,		EmpresaID,			Fecha, 			Tipo,		ConceptoID,
	      Concepto,        Descripcion
    from POLIZACONTAPLAN
	where PolizaID = Par_PolizaID;
end if;

END$$