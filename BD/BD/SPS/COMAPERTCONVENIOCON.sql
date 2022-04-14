-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COMAPERTCONVENIOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS COMAPERTCONVENIOCON;
DELIMITER $$

CREATE PROCEDURE COMAPERTCONVENIOCON(
-- SP PARA CONSULTAR ESQUEMA DE COBRO DE COMISION APERTURA POR CONVENIO DE NOMINA
	Par_EsqComApertID 			INT(11),
	Par_EsqConvComAperID		INT(11),
	Par_ConvenioNominaID		BIGINT UNSIGNED,
	Par_PlazoID					VARCHAR(20),
	Par_Monto					DECIMAL(12,4),
	Par_NumCon					TINYINT UNSIGNED,	-- Parametro que solicita el numero de consulta
	Aud_EmpresaID				INT(11),			-- Parametros de auditoria
	Aud_Usuario					INT(11),			-- Parametros de auditoria
	Aud_FechaActual				DATETIME,			-- Parametros de auditoria
	Aud_DireccionIP				VARCHAR(15),		-- Parametros de auditoria
	Aud_ProgramaID				VARCHAR(50),		-- Parametros de auditoria
	Aud_Sucursal				INT(11),			-- Parametros de auditoria
	Aud_NumTransaccion			BIGINT(20)			-- Parametros de auditoria
	)

TerminaStore: BEGIN

-- Declaracion de constantes
	DECLARE Cadena_Vacia	CHAR(1);
	DECLARE Entero_Cero		INT;
	DECLARE Decimal_Cero	DECIMAL(12,2);
	DECLARE SalidaSI		CHAR(1);
	DECLARE SalidaNO		CHAR(1);
	DECLARE Con_Principal	INT;
	DECLARE Con_Originacion		INT;

	-- Asignacion  de constantes
	SET	Cadena_Vacia		:= '';		-- CADENA VACIA
	SET	Entero_Cero			:= 0;		-- ENTERO CERO
	SET	Decimal_Cero		:= 0.0;		-- DECIMAL CERO
	SET	SalidaSI			:= 'S';		-- SALIDA SI
	SET	SalidaNO			:= 'N';		-- SALIDA NO
	SET	Con_Principal		:= 1;		-- CONSULTA PRINCIPAL NO 1
	SET	Con_Originacion		:= 2;		-- CONSULTA PARA VALIDAR DESDE ORIGINACION DE CREDITO

	SET Aud_FechaActual := NOW();

		IF(Par_NumCon = Con_Principal) THEN
				SELECT	EsqConvComAperID,	EsqComApertID,	ConvenioNominaID,	FormCobroComAper,	TipoComApert,
						PlazoID,			MontoMin,		MontoMax,			Valor,				Fila
				FROM COMAPERTCONVENIO
				WHERE EsqConvComAperID	=	Par_EsqConvComAperID;
		END IF;

		IF(Par_NumCon = Con_Originacion) THEN
				SELECT	EsqConvComAperID,	EsqComApertID,	ConvenioNominaID,	FormCobroComAper,	TipoComApert,
						PlazoID,			MontoMin,		MontoMax,			Valor,				Fila
				FROM COMAPERTCONVENIO
				WHERE  EsqComApertID = Par_EsqComApertID
				AND (ConvenioNominaID	=	Par_ConvenioNominaID OR ConvenioNominaID = Entero_Cero)
				AND PlazoID		=	Par_PlazoID
				AND Par_Monto	>=	MontoMin
				AND Par_Monto	<=	MontoMax;
		END IF;

END TerminaStore$$