-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMETROSSPEIIECON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMETROSSPEIIECON`;DELIMITER $$

CREATE PROCEDURE `PARAMETROSSPEIIECON`(
	Par_EmpresaID		int(11),
	Par_NumCon			tinyint unsigned,

	Aud_Usuario			int(11),
	Aud_FechaActual		datetime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int(11),
	Aud_NumTransaccion	bigint(20)

)
TerminaStore: BEGIN


DECLARE	 Cadena_Vacia		char(1);
DECLARE	 Fecha_Vacia		date;
DECLARE	 Hora_Vacia 		time;
DECLARE	 Entero_Cero		int;
DECLARE	 Decimal_Cero		decimal(12,2);
DECLARE  Par_NumErr      	int;
DECLARE  Par_ErrMen      	varchar(400);
DECLARE  SalidaNO        	char(1);
DECLARE  SalidaSI        	char(1);
DECLARE	 Con_Principal	    int;


Set	Cadena_Vacia		    := '';
Set	Fecha_Vacia			    := '1900-01-01';
Set	Hora_Vacia			    := '00:00:00';
Set	Entero_Cero			    := 0;
Set	Decimal_Cero		    := 0.0;
Set SalidaSI        	    := 'S';
Set SalidaNO        	    := 'N';
Set Par_NumErr  		    := 0;
Set Par_ErrMen  		    := '';
Set	Con_Principal		    := 1;


if(Par_NumCon = Con_Principal) then
   Select PIE.EmpresaID,     PIE.CtaDDIESpei,  PIE.CtaDDIETrans
	from  PARAMETROSSPEIIE PIE
	where PIE.EmpresaID = Par_EmpresaID;

end if;


END TerminaStore$$