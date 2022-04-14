-- BITACORADEPREFALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORADEPREFALT`;
DELIMITER $$

CREATE PROCEDURE `BITACORADEPREFALT`(
-- =====================================================================================
-- ------- STORED PARA BITACORA DE APLICACION DE DEPOSITOS REFERENCIADOS ---------
-- =====================================================================================
    Par_NumTransaccionCarga BIGINT(20), 	-- Numero de Transaccion de Carga.
    Par_FolioCargaID 		BIGINT(20), 	-- Folio unico de Carga de Archivo a Conciliar.
    Par_NumErrDepRef		INT(11), 		-- Numero de error
    Par_ErrMenDepRef		VARCHAR(400), 	-- Mensaje de error

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
)TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
    DECLARE Var_Consecutivo		VARCHAR(100);   	-- Variable consecutivo
	DECLARE Var_Control         VARCHAR(100);   	-- Variable de Control
    DECLARE Var_FechaSistema	DATE;				-- Fecha de sistema
	DECLARE Var_BitacoraID		BIGINT(20);			-- Identificador de la bitacora

    -- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- Decimal cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI

	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO
	DECLARE Entero_Uno      	INT(11);      		-- Entero Uno
	DECLARE Cons_SI       		CHAR(1);   			-- Constante  S, valor si
	DECLARE Cons_NO       		CHAR(1); 			-- Constante  N, valor no

    -- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;
	SET Cons_SI          		:= 'S';
	SET Cons_NO           		:= 'N';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-BITACORADEPREFALT');
			SET Var_Control = 'sqlException';
		END;

		SET Var_BitacoraID := (SELECT IFNULL(MAX(BitacoraID),Entero_Cero) + Entero_Uno FROM BITACORADEPREF);

        INSERT INTO BITACORADEPREF(
			BitacoraID, 	NumTransaccionCarga, 		FolioCargaID, 		NumErr, 			ErrMen,
            EmpresaID, 		Usuario, 					FechaActual, 		DireccionIP, 		ProgramaID,
            Sucursal, 		NumTransaccion
        )VALUES(
			Var_BitacoraID,	Par_NumTransaccionCarga,	Par_FolioCargaID,	Par_NumErrDepRef,	Par_ErrMenDepRef,
            Par_EmpresaID,	Aud_Usuario,				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,	Aud_NumTransaccion
        );

		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= CONCAT('Bitacora Agregada Exitosamente: ',CAST(Var_BitacoraID AS CHAR) );
		SET Var_Control		:= '';
		SET Var_Consecutivo	:= Var_BitacoraID;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) then
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;

	END IF;

END TerminaStore$$