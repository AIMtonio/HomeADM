-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSACTIVOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSACTIVOSLIS`;DELIMITER $$

CREATE PROCEDURE `TIPOSACTIVOSLIS`(
# =====================================================================================
# ------- STORED PARA LISTA DE TIPOS DE ACTIVOS ---------
# =====================================================================================
	Par_Descripcion			VARCHAR(300), 	-- Descripcion larga del tipo de activo
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
    DECLARE Lis_TiposActivos	INT(11);			-- Lista 1: los tipos de activos
    DECLARE Lis_ComboTiposAct	INT(11);			-- Lista 2: lista combo tipos de activos
    DECLARE Est_A				VARCHAR(1);

    DECLARE Est_I				VARCHAR(1);
    DECLARE Est_Activo			VARCHAR(10);
    DECLARE Est_Inactivo		VARCHAR(10);
	DECLARE Lis_TiposActivosGastos	INT(11);

    -- ASIGNACION DE CONSTANTES

	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;
    SET Lis_TiposActivos		:= 1;
    SET Lis_ComboTiposAct		:= 2;
    SET Est_A					:= 'A';

    SET Est_I					:= 'I';
    SET Est_Activo				:= 'ACTIVO';
    SET Est_Inactivo			:= 'INACTIVO';
    SET Lis_TiposActivosGastos	:= 3;


	-- Lista 1
	IF(Par_NumLis = Lis_TiposActivos) THEN

		SELECT TipoActivoID, DescripcionCorta, CASE Estatus WHEN Est_A THEN Est_Activo
															WHEN Est_I THEN Est_Inactivo END AS Estatus
		FROM TIPOSACTIVOS
		WHERE  Descripcion LIKE CONCAT("%", Par_Descripcion, "%")
			OR DescripcionCorta LIKE CONCAT("%", Par_Descripcion, "%")
		ORDER BY TipoActivoID
		LIMIT 0,15;

	END IF;

    -- Lista 2
	IF(Par_NumLis = Lis_ComboTiposAct) THEN

		SELECT TipoActivoID, DescripcionCorta
		FROM TIPOSACTIVOS
		WHERE  Estatus = Est_A;

	END IF;

	-- Lista 3 para pantalla de tipos de gastos
	IF(Par_NumLis = Lis_TiposActivosGastos) THEN

		SELECT TipoActivoID, DescripcionCorta, Estatus
		FROM TIPOSACTIVOS
		WHERE  Descripcion LIKE CONCAT("%", Par_Descripcion, "%")
			OR DescripcionCorta LIKE CONCAT("%", Par_Descripcion, "%")
		ORDER BY TipoActivoID
		LIMIT 0,15;

	END IF;

END TerminaStore$$