-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSCTATARDEBCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSCTATARDEBCON`;DELIMITER $$

CREATE PROCEDURE `TIPOSCTATARDEBCON`(
	 Par_TipoTarjetaID	   char(16),

	Par_NumCon		tinyint unsigned,

	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
		)
TerminaStore: BEGIN

    DECLARE		Con_Principal	int;
    DECLARE		Con_Foranea		int;

    Set	Con_Principal	:= 1;
    Set	Con_Foranea		:= 2;

    if(Par_NumCon = Con_Principal) then

    select TipoTarjetaDebID,TipoCuentaID from TIPOSCUENTATARDEB
         where TipoTarjetaDebID = Par_TipoTarjetaID;
    end if;

END TerminaStore$$