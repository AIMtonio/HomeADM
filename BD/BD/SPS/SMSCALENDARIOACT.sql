-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSCALENDARIOACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SMSCALENDARIOACT`;DELIMITER $$

CREATE PROCEDURE `SMSCALENDARIOACT`(
	VarCargaID			int,
	Par_NumTransac		int
	)
TerminaStore: BEGIN


DECLARE  Entero_Cero		int;
DECLARE  SalidaSI			char(1);
DECLARE  SalidaNO			char(1);
DECLARE  Cadena_Vacia		char(1);

Set	Entero_Cero		:= 0;
Set SalidaSI		:='S';
Set SalidaNO		:='N';
Set	Cadena_Vacia	:= '';

UPDATE SMSCALENDARIO set
	ArchivoCargaID = VarCargaID
	where NumTransaccion = Par_NumTransac;

END TerminaStore$$