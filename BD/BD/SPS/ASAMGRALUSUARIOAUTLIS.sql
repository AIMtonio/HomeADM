-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ASAMGRALUSUARIOAUTLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `ASAMGRALUSUARIOAUTLIS`;DELIMITER $$

CREATE PROCEDURE `ASAMGRALUSUARIOAUTLIS`(
	Par_UsuarioID       int(11),
	Par_NumLis			tinyint unsigned,

	Par_EmpresaID		int(11),
    Aud_Usuario			int(11),
	Aud_FechaActual		datetime,
	Aud_DireccionIP		varchar(20),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int(11),
	Aud_NumTransaccion	bigint(20)
)
TerminaStore: BEGIN


DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int(11);
DECLARE	Decimal_Cero	decimal(12,2);
DECLARE Lis_Principal	int(11);
DECLARE Estatus_Act     char(1);



Set Cadena_Vacia		:= '';
Set	Fecha_Vacia			:= '1900-01-01';
Set	Entero_Cero			:= 0;
Set	Decimal_Cero		:= 0.0;
Set Lis_Principal		:= 1;
Set Estatus_Act			:= 'A';




if(Par_NumLis = Lis_Principal) then
		select U.UsuarioID, U.NombreCompleto, R.NombreRol, U.RolID
		from ASAMGRALUSUARIOAUT U inner join ROLES R on U.RolID = R.RolID;
end if;


END TerminaStore$$