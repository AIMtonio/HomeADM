-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INSTITUCIONESSPEICON
DELIMITER ;
DROP PROCEDURE IF EXISTS `INSTITUCIONESSPEICON`;DELIMITER $$

CREATE PROCEDURE `INSTITUCIONESSPEICON`(
	Par_InstitucionID	int(5),
	Par_NumCon		    tinyint unsigned,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint

)
TerminaStore: BEGIN

DECLARE	Con_Principal	    int;
DECLARE	Con_Descripcion		int;

Set	Con_Principal	:= 1;
Set	Con_Descripcion	:= 2;

if(Par_NumCon = Con_Principal) then
	select	INS.InstitucionID,		INS.Descripcion,	 INS.NumCertificado,	INS.Estatus,
			INS.EstatusRecep,    	INS.EstatusBloque,	  INS.FechaUltAct
	from INSTITUCIONESSPEI INS
	where  INS.InstitucionID = Par_InstitucionID;
end if;

if(Par_NumCon = Con_Descripcion) then
	select	INS.InstitucionID,	INS.Descripcion
	from INSTITUCIONESSPEI INS
	where  INS.InstitucionID = Par_InstitucionID;
end if;

END TerminaStore$$