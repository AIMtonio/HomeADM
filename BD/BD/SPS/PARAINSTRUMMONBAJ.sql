-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAINSTRUMMONBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAINSTRUMMONBAJ`;DELIMITER $$

CREATE PROCEDURE `PARAINSTRUMMONBAJ`(

	Par_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE Cadena_Vacia		char(1);
DECLARE Entero_Cero		int;
DECLARE SalidaNO			char(1);
DECLARE SalidaSI			char(1);


Set Cadena_Vacia			:= '';
Set Entero_Cero			:= 0;
Set SalidaNO				:='N';
Set SalidaSI				:='S';

DELETE FROM PARAINSTRUMMON;

END TerminaStore$$