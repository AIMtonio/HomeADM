-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIAPLICAPROTECCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIAPLICAPROTECCON`;DELIMITER $$

CREATE PROCEDURE `CLIAPLICAPROTECCON`(
	Par_ClienteID			int(11),
	Par_NumCon				tinyint unsigned,
	Par_EmpresaID			int,
	Aud_Usuario         	int,
	Aud_FechaActual     	DateTime,

	Aud_DireccionIP     	varchar(15),
	Aud_ProgramaID      	varchar(50),
	Aud_Sucursal        	int(11),
	Aud_NumTransaccion  	bigint(20)
	)
TerminaStore:BEGIN

DECLARE Con_Principal		int;


set Con_Principal		:=1;

if (Con_Principal = Par_NumCon)then

	select	ClienteID,				FechaRegistro,	UsuarioReg,		UsuarioAut,	FechaAutoriza,
			UsuarioRechaza,			FechaRechaza,	Estatus,		Comentario,	format(MonAplicaCuenta,2) as MonAplicaCuenta ,
			format(MonAplicaCredito,2) as MonAplicaCredito,	ActaDefuncion,	FechaDefuncion
	from	CLIAPLICAPROTEC
		where ClienteID = Par_ClienteID;

end if;

END TerminaStore$$