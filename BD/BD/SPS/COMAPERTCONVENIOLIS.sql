-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COMAPERTCONVENIOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `COMAPERTCONVENIOLIS`;
DELIMITER $$

CREATE PROCEDURE `COMAPERTCONVENIOLIS`(
/* CONSULTA EL ESQUEMA COBRO POR DISPOSICION DE CREDITO. */
	Par_EsqComApertID 			INT(11),
	Par_TipoLista				TINYINT UNSIGNED,
	Par_ConvenioNominaID		BIGINT UNSIGNED,
	Par_PlazoID					VARCHAR(11),
	Par_Monto					DECIMAL(12,2),
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

		IF(Par_TipoLista = Con_Principal) THEN
				SELECT	EsqConvComAperID,	EsqComApertID,	ConvenioNominaID,	FormCobroComAper,	TipoComApert,
						PlazoID,			MontoMin,		MontoMax,			Valor,				Fila
				FROM	COMAPERTCONVENIO
				WHERE	EsqComApertID = Par_EsqComApertID ORDER BY Fila;
		END IF;

END TerminaStore$$