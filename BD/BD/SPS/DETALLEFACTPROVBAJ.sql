-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEFACTPROVBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `DETALLEFACTPROVBAJ`;

DELIMITER $$
CREATE PROCEDURE `DETALLEFACTPROVBAJ`(
	# =====================================================================================
	# SP PARA DAR DE BAJA EL DETALLE DE LA FACTURA
	# =====================================================================================
    Par_ProveedorID         INT(11),			-- PROVEDOR
    Par_NoFactura           VARCHAR(20),		-- NUMERO DE FACTURA

    Par_Salida              CHAR(1),			-- SALIDA
    INOUT Par_NumErr        INT(11),			-- NUMERO DE ERROR
    INOUT Par_ErrMen        VARCHAR(400),		-- MENSAJE DE ERROR

    Aud_EmpresaID           INT(11),			-- AUDITORIA
    Aud_Usuario             INT(11),			-- AUDITORIA
    Aud_FechaActual         DATETIME,			-- AUDITORIA
    Aud_DireccionIP         VARCHAR(15),		-- AUDITORIA
    Aud_ProgramaID          VARCHAR(50),		-- AUDITORIA
    Aud_Sucursal            INT(11),			-- AUDITORIA
    Aud_NumTransaccion      BIGINT(20)			-- AUDITORIA
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control         VARCHAR(100);

	-- Declaracion de constantes
	DECLARE Entero_Cero         INT(11);
	DECLARE Decimal_Cero        DECIMAL(12,2);
	DECLARE Cadena_Vacia        CHAR(1);
	DECLARE Fecha_Vacia         DATE;
	DECLARE SalidaNO            CHAR(1);
	DECLARE SalidaSI            CHAR(1);

	-- Asignacion de constantes
	SET Entero_Cero         := 0;
	SET Decimal_Cero        := 0.0;
	SET Cadena_Vacia        := '';
	SET Fecha_Vacia         := '1900-01-01';
	SET SalidaNO            := 'N';
	SET SalidaSI            := 'S';


ManejoErrores: BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-DETALLEFACTPROVBAJ');
					SET Var_Control = 'SQLEXCEPTION' ;

		END;
	
    -- DAMOS DE BAJA EL DETALLE DE LOS IMPUESTOS
    DELETE FROM DETALLEIMPFACT 
    WHERE ProveedorID = Par_ProveedorID
		AND   NoFactura = Par_NoFactura;

	-- DAMOS DE BAJA EL DETALLE DE LA FACTURA
	DELETE FROM DETALLEFACTPROV
		WHERE ProveedorID = Par_ProveedorID
		AND   NoFactura = Par_NoFactura;

	-- DAMOS DE BAJA LA FACTURA
	DELETE FROM FACTURAPROV
		WHERE ProveedorID = Par_ProveedorID
		AND   NoFactura = Par_NoFactura;

    SET Par_NumErr := 000;
    SET Par_ErrMen := "Registro eliminado correctamente";

END ManejoErrores;

IF(Par_Salida = SalidaSI) THEN
    SELECT Par_NumErr AS NumErr,
           Par_ErrMen AS ErrMen,
           "noFactura" AS control,
		   Entero_Cero AS consecutivo;
END IF;
END TerminaStore$$