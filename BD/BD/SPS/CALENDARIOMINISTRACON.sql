-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALENDARIOMINISTRACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CALENDARIOMINISTRACON`;DELIMITER $$

CREATE PROCEDURE `CALENDARIOMINISTRACON`(
/* CONSULTA EL CALENDARIO DE MINISTRACIONES DE PROD DE CRED AGROPECUARIOS (FIRA) */
	Par_ProductoCreditoID	INT(11),
	Par_NumCon				TINYINT UNSIGNED,
    /* Parametros de Auditoria */
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,

	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(60),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de constantes
DECLARE Cadena_Vacia	CHAR(1);
DECLARE Entero_Cero		INT;
DECLARE Decimal_Cero	DECIMAL(12,2);
DECLARE SalidaSI		CHAR(1);
DECLARE SalidaNO		CHAR(1);
DECLARE Con_Principal	INT;

-- Asignacion  de constantes
SET	Cadena_Vacia	:= '';		-- CADENA VACIA
SET	Entero_Cero		:= 0;		-- ENTERO CERO
SET	Decimal_Cero	:= 0.0;		-- DECIMAL CERO
SET	SalidaSI		:= 'S';		-- SALIDA SI
SET	SalidaNO		:= 'N';		-- SALIDA NO
SET	Con_Principal	:= 1;		-- CONSULTA PRINCIPAL NO 1

SET Aud_FechaActual := NOW();

IF(Par_NumCon = Con_Principal) THEN
	SELECT ProductoCreditoID, 	TomaFechaInhabil, 	PermiteCalIrregular, DiasCancelacion, DiasMaxMinistraPosterior,
		Frecuencias,			Plazos, 			TipoCancelacion
	FROM CALENDARIOMINISTRA
	WHERE ProductoCreditoID = Par_ProductoCreditoID;

END IF;

END TerminaStore$$