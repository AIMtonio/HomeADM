-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASMAYORINVBANCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASMAYORINVBANCON`;DELIMITER $$

CREATE PROCEDURE `CUENTASMAYORINVBANCON`(



	Par_ConceptoInvBanID	int(11),
	Par_NumCon				int,
	Aud_EmpresaID			int,
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,

	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint


)
TerminaStore: BEGIN

	DECLARE		Con_Principal	int;


	Set	Con_Principal	:= 1;

	if(Par_NumCon = Con_Principal) THEN
			SELECT ConceptoInvBanID,		Cuenta,				Nomenclatura
			FROM CUENTASMAYORINVBAN WHERE ConceptoInvBanID=Par_ConceptoInvBanID;
	END IF;
END TerminaStore$$