-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CTASMAYORACTIVOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CTASMAYORACTIVOSCON`;DELIMITER $$

CREATE PROCEDURE `CTASMAYORACTIVOSCON`(
# =====================================================================================
# ------- STORED PARA CONSULTA DE CUENTA MAYOR DE ACTIVOS ---------
# =====================================================================================
    Par_ConceptoActivoID	INT(11),		-- ID del concepto contable de activo
   	Par_NumCon			TINYINT UNSIGNED,	-- Numero de consulta

    Par_EmpresaID       	INT(11),		-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),		-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,		-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),		-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES

    -- DECLARACION DE CONSTANTES

	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- DECIMAL cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI

	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO
	DECLARE Entero_Uno      	INT(11);      		-- Entero Uno
    DECLARE Con_CtaMayor		INT(11);			-- Lista 1 : Conceptos contables activos

    -- ASIGNACION DE CONSTANTES

	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;
    SET Con_CtaMayor			:= 1;

	-- Lista 1: Concetos contables activos
	IF(Par_NumCon = Con_CtaMayor) THEN

		SELECT ConceptoActivoID,	Cuenta,		Nomenclatura,	NomenclaturaCC
        FROM CTASMAYORACTIVOS
        WHERE ConceptoActivoID = Par_ConceptoActivoID;

	END IF;

END TerminaStore$$