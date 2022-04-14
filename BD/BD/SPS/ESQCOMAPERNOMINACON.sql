-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQCOMAPERNOMINACON
DELIMITER ;
DROP PROCEDURE IF EXISTS ESQCOMAPERNOMINACON;
DELIMITER $$


CREATE PROCEDURE ESQCOMAPERNOMINACON(
	-- SP PARA CONSULTAR ESQUEMA DE COMISION POR APERTURA
	Par_InstitNominaID			INT(11),			-- Numero de Institucion Nomina
	Par_ProducCreditoID			INT(11),			-- Numero de Producto de Credito;
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

	-- Asignacion  de constantes
	SET	Cadena_Vacia	:= '';		-- CADENA VACIA
	SET	Entero_Cero		:= 0;		-- ENTERO CERO
	SET	Decimal_Cero	:= 0.0;		-- DECIMAL CERO
	SET	SalidaSI		:= 'S';		-- SALIDA SI
	SET	SalidaNO		:= 'N';		-- SALIDA NO
	SET	Con_Principal	:= 1;		-- CONSULTA PRINCIPAL NO 1

	IF(Par_NumCon = Con_Principal) THEN
			SELECT	EsqComApertID,		InstitNominaID,		ProducCreditoID,	ManejaEsqConvenio
			FROM	ESQCOMAPERNOMINA
			WHERE	InstitNominaID	=	Par_InstitNominaID
			AND		ProducCreditoID	=	Par_ProducCreditoID;
	END IF;

END TerminaStore$$