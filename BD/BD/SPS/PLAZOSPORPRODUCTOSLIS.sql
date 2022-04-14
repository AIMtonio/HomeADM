-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLAZOSPORPRODUCTOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLAZOSPORPRODUCTOSLIS`;DELIMITER $$

CREATE PROCEDURE `PLAZOSPORPRODUCTOSLIS`(
# ======================================================
# ------- SP PARA LISTAR LOS PLAZOS DE LOS CEDES--------
# ======================================================
	Par_InstrumentoID   INT(11),      -- Parametro Indica el Tipo de Instrumento, 28 para CEDES
    Par_ProductoID    	INT(11),      -- Parametro Indica el tipo de CEDES de la tabla TIPOSCEDES
	Par_NumLis      	INT(11),      -- Parametro para el Numero de Lista

	Par_EmpresaID   	INT(11),      -- Parametro de Auditoria: id de la empresa
	Aud_Usuario     	INT(11),      -- Parametro de Auditoria: id usuario
	Aud_FechaActual   	DATETIME,     -- Parametro de Auditoria: fecha
	Aud_DireccionIP   	VARCHAR(15),  -- Parametro de Auditoria: direccion ip
	Aud_ProgramaID    	VARCHAR(50),  -- Parametro de Auditoria: id del programa
	Aud_Sucursal    	INT(11),      -- Parametro de Auditoria: id se sucursal
	Aud_NumTransaccion  BIGINT(20)    -- Parametro de Auditoria: numero de transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE Lis_TiposPlazos INT(11);

	-- Asignacion de Constantes
	SET Lis_TiposPlazos 	:= 1;   -- Lista de los Plazos

	-- Lista de Plazos por tipo de Instrumento y tipo de Producto
	IF(Par_NumLis = Lis_TiposPlazos)THEN
	  SELECT Plazo
		FROM 	PLAZOSPORPRODUCTOS
		WHERE 	TipoInstrumentoID	= Par_InstrumentoID
        AND 	TipoProductoID		= Par_ProductoID;
	END IF;

END TerminaStore$$