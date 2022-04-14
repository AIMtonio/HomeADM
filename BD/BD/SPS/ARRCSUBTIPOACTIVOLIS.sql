-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARRCSUBTIPOACTIVOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `ARRCSUBTIPOACTIVOLIS`;DELIMITER $$

CREATE PROCEDURE `ARRCSUBTIPOACTIVOLIS`(
# =====================================================================================
# -- STORED PROCEDURE PARA LISTAR LOS SUBTIPOS REGISTRADOS EN EL SISTEMA
# =====================================================================================
	Par_Descripcion			VARCHAR(150), 		-- Descripcion del subtipo de categorias
    Par_NumLis				TINYINT UNSIGNED,	-- Numero de lista

    Par_EmpresaID			INT(11),			-- Parametros de Auditoria
	Aud_Usuario				INT(11),			-- Parametros de Auditoria
	Aud_FechaActual			DATETIME,			-- Parametros de Auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametros de Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametros de Auditoria
	Aud_Sucursal			INT(11),			-- Parametros de Auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametros de Auditoria
	)
TerminaStore: BEGIN
	-- Declaracion de Variables
    DECLARE Var_Descripcion 	VARCHAR(150);		-- Variable que almacena la descripcion del subtipo como variable

    -- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);		-- Cadena Vacia
	DECLARE	Fecha_Vacia			DATE;			-- Fecha Vacia
	DECLARE	Entero_Cero			INT(11);		-- Entero cero
	DECLARE	Decimal_Cero		DECIMAL(14,2);	-- Decimal cero

    DECLARE Lis_ActivoInactivo	INT(11);		-- Lista de Activos e Inactivos
    DECLARE Est_Activo			CHAR(1);		-- Indica el estatus activo A=activo
    DECLARE Est_Inactivo		CHAR(1);		-- Indica el estatus inactivo I=inactivo

    -- Asignacion de Constantes
	SET	Cadena_Vacia			:= '';				-- Valor de cadena vacia
	SET	Fecha_Vacia				:= '1900-01-01';	-- Valor de fecha vacia.
	SET	Entero_Cero				:= 0;				-- Valor de entero cero.
	SET	Decimal_Cero			:= 0.0;				-- Valor de decimal cero.

    SET Lis_ActivoInactivo		:= 1;				-- Valor lista 1
    SET Est_Activo			    := 'A';      		-- Estatus Activo=A
	SET Est_Inactivo			:= 'I';      		-- Estatus Inactivo=I

    -- Valores por Default
	SET Par_Descripcion			:= IFNULL(Par_Descripcion,Cadena_Vacia);
	SET Par_NumLis				:= IFNULL(Par_NumLis,Entero_Cero);

    -- Lista: 1
	IF (Par_NumLis = Lis_ActivoInactivo) THEN
        SET Var_Descripcion	:= CONCAT("%", Par_Descripcion, "%");
        SELECT SubTipoActivoID, 	Descripcion
            FROM ARRCSUBTIPOACTIVO
            WHERE   Descripcion  LIKE Var_Descripcion
              AND   Estatus IN (Est_Activo,Est_Inactivo)
			ORDER BY SubTipoActivoID
			LIMIT 0, 15;
	END IF;

END TerminaStore$$