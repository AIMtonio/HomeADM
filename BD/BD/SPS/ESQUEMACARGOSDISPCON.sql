-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMACARGOSDISPCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMACARGOSDISPCON`;DELIMITER $$

CREATE PROCEDURE `ESQUEMACARGOSDISPCON`(
/* CONSULTA EL ESQUEMA COBRO POR DISPOSICION DE CREDITO. */
	Par_ProductoCreditoID		INT(11), 		-- ID del producto de Crédito.
	Par_InstitucionID			INT(11), 		-- ID de INSTITUCIONES.
	Par_TipoDispersion			CHAR(1),		-- Corresponde a lo parámetrizado en el  Esquema de Calendario por producto.
	Par_TipoCargo				CHAR(1),		-- Indica si el tipo de cargo es por monto o por porcentaje. M.- Monto P.- Porcentaje
	Par_Nivel					INT(11),		-- Nivel, corresponde al catálogo NIVELCREDITO.

	Par_NumCon					TINYINT UNSIGNED,
    /* Parametros de Auditoria */
	Aud_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),

	Aud_ProgramaID				VARCHAR(60),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
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
	SELECT
		ProductoCreditoID,	InstitucionID,		NombInstitucion,	MontoCargo,		TipoDispersion,
		TipoCargo,			Nivel,				MontoCargo
		FROM ESQUEMACARGOSDISP
			WHERE ProductoCreditoID = Par_ProductoCreditoID
				AND InstitucionID = Par_InstitucionID
				AND TipoDispersion = Par_TipoDispersion
				AND TipoCargo = Par_TipoCargo
				AND Nivel = Par_Nivel;
END IF;

END TerminaStore$$