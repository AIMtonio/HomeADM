-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MAESTROPOLIZACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `MAESTROPOLIZACON`;DELIMITER $$

CREATE PROCEDURE `MAESTROPOLIZACON`(
-- ----------------------------------------------------------------
-- 				SP PARA LA CONSULTA DE MAESTRO POLIZA
-- ----------------------------------------------------------------
	Par_PolizaID		INT(11),				-- Parametro dell ID de la Poliza
	Par_NumCon			TINYINT UNSIGNED,		-- Parametro de numero de Consulta

	Par_EmpresaID		INT(11),				-- Parametro de auditoria de Empresa
	Aud_Usuario			INT(11),				-- Parametro de auditoria de Usuario
	Aud_FechaActual		DATETIME,				-- Parametro de auditoria de Fecha actual
	Aud_DireccionIP		VARCHAR(15),			-- Parametro de auditoria de Direccion IP
	Aud_ProgramaID		VARCHAR(50),			-- Parametro de auditoria de ID de Programa
	Aud_Sucursal		INT(11),				-- Parametro de auditoria de Sucursal
	Aud_NumTransaccion	BIGINT(20)				-- Parametro de auditoria de Numero de Transaccion
		)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE	Con_Principal	INT(11);	-- Constante Con_Principal
	DECLARE	Con_Foranea		INT(11);	-- Constante Con_Foranea
	DECLARE	Con_PolizaID	INT(11);	-- Consulta el numero de poliza siguiente

	-- Asignacion de constantes
	SET	Con_Principal	:= 1;
	SET	Con_Foranea		:= 2;
	SET Con_PolizaID	:= 3;

	IF(Par_NumCon = Con_Principal) THEN
		(SELECT	PolizaID,		Fecha,		Tipo,	ConceptoID, 	Concepto
			FROM POLIZACONTABLE
			WHERE	PolizaID	= Par_PolizaID)
		UNION ALL
		(SELECT	PolizaID,		Fecha,		Tipo,	ConceptoID, 	Concepto
			FROM `HIS-POLIZACONTA`

		WHERE	PolizaID	= Par_PolizaID);
	END IF;

	IF Con_PolizaID =Par_NumCon THEN
		SELECT MAX(PolizaID)+1 AS PolizaID FROM POLIZACONTABLE;
	END IF;
END TerminaStore$$