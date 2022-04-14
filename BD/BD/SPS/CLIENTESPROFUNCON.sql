-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTESPROFUNCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIENTESPROFUNCON`;DELIMITER $$

CREATE PROCEDURE `CLIENTESPROFUNCON`(

    Par_ClienteID		int(11),
    Par_NumCon			tinyint unsigned,

    Par_EmpresaID		int,
    Aud_Usuario			int,
    Aud_FechaActual		DateTime,
    Aud_DireccionIP		varchar(15),
    Aud_ProgramaID		varchar(50),
    Aud_Sucursal		int,
    Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE	Con_Principal		int;
DECLARE Con_MontoAdeudo		int;
DECLARE NumClientesProfun	int;
DECLARE Cadena_Vacia		char;
DECLARE Entero_Cero			int;


Set	Con_Principal	:= 1;
set Con_MontoAdeudo			:=2;
set Cadena_Vacia	:='';
set Entero_Cero		:=0;


if(Par_NumCon = Con_Principal) then
	select	ClienteID,		FechaRegistro,	SucursalReg,	SucursalCan,	UsuarioReg,
			UsuarioCan,		FechaCancela,	Estatus
		from 	CLIENTESPROFUN
		where	ClienteID = Par_ClienteID ;
end if;


if (Con_MontoAdeudo = Par_NumCon)then
set NumClientesProfun := ifnull((select count(ClienteID) from CLIENTESPROFUN),Entero_Cero);

	select 	ClienteID,		FORMAT(MontoPendiente,2) AS MontoPendiente, NumClientesProfun
		from CLICOBROSPROFUN
		where ClienteID =Par_ClienteID;

end if;

END TerminaStore$$