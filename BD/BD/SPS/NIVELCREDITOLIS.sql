-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- NIVELCREDITOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `NIVELCREDITOLIS`;
DELIMITER $$

CREATE PROCEDURE `NIVELCREDITOLIS`(
# =====================================================================================
# ------- STORED PARA LISTAS DEL NIVEL DE CREDITO ---------
# =====================================================================================
	Par_NivelID				INT(11),		-- ID  de nivel de credito
	Par_Descripcion			VARCHAR(20),	-- Descripcion del nivel de credito
	Par_NumList				TINYINT UNSIGNED,	-- Numero de lista

	Par_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Fecha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
	DECLARE Var_Consecutivo		VARCHAR(100);		-- Variable consecutivo
	DECLARE Var_Control			VARCHAR(100);		-- Variable de Control

	-- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);			-- Constante cadena vacia ''
	DECLARE Fecha_Vacia			DATE;				-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero			INT(1);				-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- Decimal cero
	DECLARE Salida_SI			CHAR(1);			-- Parametro de salida SI

	DECLARE Salida_NO			CHAR(1);			-- Parametro de salida NO
	DECLARE Entero_Uno			INT(11);			-- Entero Uno

	DECLARE Lis_NivelesGrid		INT(11);			-- Lista los niveles para el grid
	DECLARE Lis_ComboNiveles	INT(11);			-- Lista los niveles para el combo

	-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia			:= '';				-- Constante cadena vacia ''
	SET Fecha_Vacia				:= '1900-01-01';	-- Constante Fecha vacia 1900-01-01
	SET Entero_Cero				:= 0;				-- Constante Entero cero 0
	SET Decimal_Cero			:= 0.0;				-- Decimal cero
	SET Salida_SI				:= 'S';				-- Parametro de salida SI

	SET Salida_NO				:= 'N';				-- Parametro de salida NO
	SET Entero_Uno				:= 1;				-- Entero Uno

	SET Lis_NivelesGrid			:= 1;				-- Lista los niveles para el grid
	SET Lis_ComboNiveles		:= 2;				-- Lista los niveles para el combo

	-- 1.- lista grid
	IF(Par_NumList = Lis_NivelesGrid)THEN
		SELECT NIV.NivelID, NIV.Descripcion, COUNT(ESQ.NivelID) AS NumVecesAsignado
			FROM NIVELCREDITO NIV
			LEFT JOIN ESQUEMATASAS ESQ
				ON NIV.NivelID = ESQ.NivelID
		GROUP BY NIV.NivelID, NIV.Descripcion;
	END IF;

	-- 2.- lista combo
	IF(Par_NumList = Lis_ComboNiveles)THEN
		SELECT NivelID, Descripcion
		FROM NIVELCREDITO;
	END IF;

END TerminaStore$$