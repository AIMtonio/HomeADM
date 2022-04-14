-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTATIPOACTIVOMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTATIPOACTIVOMOD`;DELIMITER $$

CREATE PROCEDURE `SUBCTATIPOACTIVOMOD`(
# =====================================================================================
# ------- STORED PARA MODIFICACION DE SUBCUENTAS DE TIPO DE ACTIVOS---------
# =====================================================================================
    Par_ConceptoActivoID	INT(11),		-- ID del concepto contable de activo
    Par_TipoActivoID		INT(11), 		-- Id del tipo de activo
    Par_SubCuenta			CHAR(15), 		-- Subcuenta por tipo de activo

    Par_Salida    			CHAR(1),		-- Parametro de salida S= si, N= no
    INOUT Par_NumErr 		INT(11),		-- Parametro de salida numero de error
    INOUT Par_ErrMen  		VARCHAR(400),	-- Parametro de salida mensaje de error

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

    -- ASIGNACION DE CONSTANTES

	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;


	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-SUBCTATIPOACTIVOMOD');
			SET Var_Control = 'SQLEXCEPTION';
		END;

        IF NOT EXISTS(SELECT ConceptoActivoID FROM CONCEPTOSACTIVOS WHERE ConceptoActivoID = Par_ConceptoActivoID)THEN

			SET Par_NumErr 		:= 1;
			SET Par_ErrMen 		:= 'El Concepto no Existe';
			SET Var_Control		:= 'conceptoActivoID';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;

        END IF;

        IF NOT EXISTS(SELECT TipoActivoID FROM TIPOSACTIVOS WHERE TipoActivoID = Par_TipoActivoID)THEN

			SET Par_NumErr 		:= 2;
			SET Par_ErrMen 		:= 'El Tipo de Activo no Existe';
			SET Var_Control		:= 'tipoActivoID';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;

        END IF;

		IF(IFNULL(Par_SubCuenta, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr 		:= 3;
			SET Par_ErrMen 		:= 'La SubCuenta esta Vacia';
			SET Var_Control		:= 'subCuenta';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

        IF NOT EXISTS(SELECT ConceptoActivoID FROM SUBCTATIPOACTIVO WHERE ConceptoActivoID = Par_ConceptoActivoID AND TipoActivoID = Par_TipoActivoID)THEN

			SET Par_NumErr 		:= 4;
			SET Par_ErrMen 		:= 'La SubCuenta no Existe';
			SET Var_Control		:= 'subCuenta';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;

        END IF;

        SET Aud_FechaActual := NOW();

		UPDATE SUBCTATIPOACTIVO SET
			SubCuenta			= Par_SubCuenta,

            EmpresaID			= Par_EmpresaID,
            Usuario				= Aud_Usuario,
            FechaActual			= Aud_FechaActual,
            DireccionIP			= Aud_DireccionIP,
            ProgramaID			= Aud_ProgramaID,
			Sucursal			= Aud_Sucursal,
            NumTransaccion		= Aud_NumTransaccion
		WHERE ConceptoActivoID = Par_ConceptoActivoID
			AND	TipoActivoID = Par_TipoActivoID;

		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= CONCAT('Registro Modificado Exitosamente: ',CAST(Par_TipoActivoID AS CHAR) );
		SET Var_Control		:= 'tipoActivoID';
		SET Var_Consecutivo	:= Par_TipoActivoID;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;

	END IF;

END TerminaStore$$