-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTROLCLAVELIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTROLCLAVELIS`;DELIMITER $$

CREATE PROCEDURE `CONTROLCLAVELIS`(
	Par_ClienteID		varchar(40),
	Par_Anio			char(4),
	Par_NumLis			int,

	Aud_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore:BEGIN

	DECLARE Lis_Principal	int;
	DECLARE Lis_Foranea		int;

	Set Lis_Principal	:= 1;
	Set	Lis_Foranea		:= 2;

	if (Par_NumLis = Lis_Principal ) then

		SELECT ClienteID, Anio, Mes, ClaveKey,
			CASE Mes
				WHEN 1 THEN 'ENERO'	WHEN 2 THEN 'FEBRERO'	WHEN 3 THEN 'MARZO'
				WHEN 4 THEN 'ABRIL'	WHEN 5 THEN 'MAYO'		WHEN 6 THEN 'JUNIO'
				WHEN 7 THEN 'JULIO'	WHEN 8 THEN 'AGOSTO'	WHEN 9 THEN 'SEPTIEMBRE'
				WHEN 10 THEN 'OCTUBRE'	WHEN 11 THEN 'NOVIEMBRE' WHEN 12 THEN 'DICIEMBRE'
			END as DescMes
			FROM CONTROLCLAVE Ctrl
			INNER JOIN PARAMETROSSIS Par ON Par.NomCortoInstit = Ctrl.ClienteID
			WHERE Ctrl.ClienteID = Par_ClienteID AND Ctrl.Anio = Par_Anio
			ORDER BY convert(Mes, unsigned) ASC;
	end if;
END TerminaStore$$