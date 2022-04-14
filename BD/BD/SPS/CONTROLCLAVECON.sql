-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTROLCLAVECON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTROLCLAVECON`;DELIMITER $$

CREATE PROCEDURE `CONTROLCLAVECON`(

	Par_NumCon				int,

	Aud_EmpresaID			int,
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint

	)
TerminaStore:BEGIN

	DECLARE Cadena_Vacia	char(1);
	DECLARE Entero_Cero		int;

	DECLARE Con_Fecha		int;
	DECLARE Con_Validacion	int;
	DECLARE Con_Clave		int;

	Set Cadena_Vacia	:= '';
	Set Entero_Cero		:= 0;
	Set Con_Fecha		:= 3;
	Set Con_Clave		:= 4;
	Set Con_Validacion	:= 5;

	if (Par_NumCon = Con_Fecha) then
		SELECT DATE_FORMAT(NOW(), '%Y') as Anio,
		DATE_FORMAT(NOW(), '%m') as Mes;
	end if;

	if (Par_NumCon = Con_Clave) then
		SELECT
			Ctrl.ClienteID, CONCAT(YEAR(NOW()), LPAD(MONTH(NOW()), 2, '0')) as AnioMes, Ctrl.ClaveKey
			FROM CONTROLCLAVE Ctrl
			INNER JOIN PARAMETROSSIS Par ON Ctrl.ClienteID = Par.NomCortoInstit
			WHERE Ctrl.ClienteID = Par.NomCortoInstit AND Ctrl.Anio = YEAR(NOW())  AND Ctrl.Mes = MONTH(NOW());
	end if;

	if (Par_NumCon = Con_Validacion) then
		SELECT
			ValidaClaveKey, NomCortoInstit
			FROM PARAMETROSSIS;
	end if;


END TerminaStore$$