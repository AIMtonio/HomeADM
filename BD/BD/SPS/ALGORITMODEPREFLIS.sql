-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ALGORITMODEPREFLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `ALGORITMODEPREFLIS`;
DELIMITER $$


CREATE PROCEDURE `ALGORITMODEPREFLIS`(
# =====================================================================================
# ------- STORED PARA LISTA DE ALGORITMOS  ---------
# =====================================================================================
    Par_InstitucionID 		INT(11),		-- ID de la institucion
	Par_NumList				TINYINT UNSIGNED,-- Numero  de lista

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

    DECLARE Var_Consecutivo		VARCHAR(100);   	-- Variable consecutivo
	DECLARE Var_Control         VARCHAR(100);   	-- Variable de Control

    -- DECLARACION DE CONSTANTES

	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- DECIMAL cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI

	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO
	DECLARE Entero_Uno      	INT(11);      		-- Entero Uno
	DECLARE Lis_ComboAlg		INT(11);			-- Lista de algoritmos
	DECLARE Institucion_BBVA	INT(11);			-- Institución de Bancomer

    -- ASIGNACIŃ DE CONSTANTES

	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;
	SET Lis_ComboAlg			:= 1;
	SET Institucion_BBVA		:= 37;

	-- Lista 1 de algoritmos
	IF(Par_NumList = Lis_ComboAlg) THEN

		-- Lista cuando se selecciona BBVA
		IF (Par_InstitucionID = Institucion_BBVA) THEN

			SELECT 	AlgoritmoID,	NombreAlgoritmo
			FROM ALGORITMODEPREF
				WHERE InstitucionID = Par_InstitucionID;

		ELSE
			-- Lista original
			SELECT 	AlgoritmoID,	NombreAlgoritmo
			FROM ALGORITMODEPREF;

		END IF;

    END IF;

END TerminaStore$$
