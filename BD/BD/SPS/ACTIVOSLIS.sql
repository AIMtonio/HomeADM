-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ACTIVOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `ACTIVOSLIS`;DELIMITER $$

CREATE PROCEDURE `ACTIVOSLIS`(
# =====================================================================================
# ------- STORED PARA LISTA DE ACTIVOS ---------
# =====================================================================================
	Par_Descripcion			VARCHAR(300), 	-- Descripcion del activo
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

    -- DECLARACION DE CONSTANTES

	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- DECIMAL cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI

	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO
	DECLARE Entero_Uno      	INT(11);      		-- Entero Uno
    DECLARE Lis_Activos			INT(11);			-- Lista 1: de activos
    DECLARE Est_VI				VARCHAR(2);
    DECLARE Est_BA				VARCHAR(2);

    DECLARE Est_VE				VARCHAR(2);
    DECLARE Est_VIGENTE			VARCHAR(10);
    DECLARE Est_BAJA			VARCHAR(10);
    DECLARE Est_VENDIDO			VARCHAR(10);

    -- ASIGNACION DE CONSTANTES

	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;
    SET Lis_Activos				:= 1;
    SET Est_VI					:= 'VI';
    SET Est_BA					:= 'BA';

    SET Est_VE					:= 'VE';
    SET Est_VIGENTE				:= 'VIGENTE';
    SET Est_BAJA				:= 'BAJA';
    SET Est_VENDIDO				:= 'VENDIDO';

	-- Lista 1
	IF(Par_NumLis = Lis_Activos) THEN

		SELECT ActivoID, Descripcion, CASE Estatus WHEN Est_VI THEN Est_VIGENTE
													WHEN Est_BA THEN Est_BAJA
													WHEN Est_VE THEN Est_VENDIDO END AS Estatus
		FROM ACTIVOS
		WHERE  Descripcion LIKE CONCAT("%", Par_Descripcion, "%")
		ORDER BY ActivoID
		LIMIT 0,15;

	END IF;

END TerminaStore$$