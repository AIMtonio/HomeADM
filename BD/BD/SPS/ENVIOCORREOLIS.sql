-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ENVIOCORREOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `ENVIOCORREOLIS`;DELIMITER $$

CREATE PROCEDURE `ENVIOCORREOLIS`(

	Par_NumLis			tinyint unsigned,

	Par_EmpresaID		int(11),
	Aud_Usuario			int(11),
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int(11),
	Aud_NumTransaccion	bigint(20)

	)
TerminaStore:BEGIN

DECLARE Con_LisNoEnviados			int;
DECLARE Con_StatusN		char;


set Con_LisNoEnviados	:= 1;
set Con_StatusN	:='N';



if(Par_NumLis = Con_LisNoEnviados) then
	select CorreoID, 		Remitente,			DestinatarioPLD, Asunto,	Mensaje, 		Fecha,
			Estatus,		ServidorCorreo,		Puerto, 			ContraseniaRe,	MailDebug,
			MailSMTPAuth,	MailTransport,		MailSMTPStarttl
	from ENVIOCORREO
		where Estatus=Con_StatusN;
end if;



END TerminaStore$$