-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLASIFICACTIVOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLASIFICACTIVOSLIS`;DELIMITER $$

CREATE PROCEDURE `CLASIFICACTIVOSLIS`(
# =====================================================================================
# ------- STORED PARA LISTA DE CLASIFICACION DE TIPOS DE ACTIVOS ---------
# =====================================================================================
   	Par_NumLis			TINYINT UNSIGNED,	-- Numero de lista

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
    DECLARE Lis_ClasifTipAct	INT(11);			-- Lista 1: clasificacion tipos de activos
    DECLARE Est_A				VARCHAR(1);
    DECLARE Est_I				VARCHAR(1);

    DECLARE Est_Activo			VARCHAR(10);
    DECLARE Est_Inactivo		VARCHAR(10);

    -- ASIGNACION DE CONSTANTES

	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;
    SET Lis_ClasifTipAct		:= 1;
    SET Est_A					:= 'A';
    SET Est_I					:= 'B';

    SET Est_Activo				:= 'ACTIVO';
    SET Est_Inactivo			:= 'INACTIVO';

	-- Lista 1
	IF(Par_NumLis = Lis_ClasifTipAct) THEN

		SELECT ClasificaActivoID, Descripcion
		FROM CLASIFICACTIVOS
		WHERE  Estatus = Est_A
		ORDER BY ClasificaActivoID;

	END IF;

END TerminaStore$$