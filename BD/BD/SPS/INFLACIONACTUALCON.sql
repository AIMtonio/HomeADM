-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INFLACIONACTUALCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `INFLACIONACTUALCON`;DELIMITER $$

CREATE PROCEDURE `INFLACIONACTUALCON`(
	Par_TipoConsulta	int,

	Aud_EmpresaID		int,
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
DECLARE Con_Principal	int;


DECLARE Var_Registros		 int;
DECLARE Var_FechaAct		 datetime;


Set Con_Principal :=	1;


if(Par_TipoConsulta=Con_Principal) then
	select InflacionProy as ValorGatHis
				from INFLACIONACTUAL
					where FechaActualizacion = (select max(FechaActualizacion) from INFLACIONACTUAL);
end if;
END TerminaStore$$