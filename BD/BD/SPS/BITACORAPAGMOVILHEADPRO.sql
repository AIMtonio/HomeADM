DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORAPAGMOVILHEADPRO`;
DELIMITER $$

CREATE PROCEDURE `BITACORAPAGMOVILHEADPRO`(
	-- STORED PARA EL ALTA GENERAL DE BITACORA DE PAGOS MOVIL
	INOUT Par_RegistroID      BIGINT(20),     	-- 'Numero del Registro'
	Par_DispositivoID         VARCHAR(32),    	-- 'Identificador del dispositivo'
	Par_ClaveProm             VARCHAR(45),    	-- 'Numero del promotor'

    Par_Salida    			  CHAR(1),			-- Parametro de salida S= si, N= no
    INOUT Par_NumErr 		  INT(11),			-- Parametro de salida numero de error
    INOUT Par_ErrMen  		  VARCHAR(400),		-- Parametro de salida mensaje de error

    Aud_EmpresaID       	  INT(11),			-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	  INT(11),			-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	  DATETIME,			-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	  VARCHAR(15),		-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	  VARCHAR(50),		-- Parametro de auditoria Programa
    Aud_Sucursal        	  INT(11),			-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	  BIGINT(20)  		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

    -- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- DECIMAL cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI
	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO

	-- DECLARACION DE VARIABLES
	DECLARE Var_Control         VARCHAR(100);   	-- Variable de Control
	DECLARE Var_Consecutivo		BIGINT(20);		   	-- Variable consecutivo
	DECLARE Fecha_Param     	DATE;		   		-- Constante Fecha de parametro de sistema

    -- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';
	SET Salida_NO           	:= 'N';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-BITACORAPAGMOVILHEADALT');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		/** Inicia validaciones **/
		SET Par_DispositivoID := IFNULL(Par_DispositivoID, Cadena_Vacia);

		IF(Par_DispositivoID = Cadena_Vacia ) THEN
			SET Par_NumErr  := 1;
			SET Par_ErrMen  := 'El DispositioID el Obligatorio';
			LEAVE ManejoErrores;
		END IF;

		SET Par_ClaveProm := IFNULL(Par_ClaveProm, Cadena_Vacia);

		IF(Par_ClaveProm = Cadena_Vacia ) THEN
			SET Par_NumErr  := 2;
			SET Par_ErrMen  := 'La Clave del promotor es obligatorio.';
			LEAVE ManejoErrores;
		END IF;

		SET Par_ClaveProm := (SELECT Clave FROM USUARIOS WHERE Clave = Par_ClaveProm LIMIT 1);
		SET Par_ClaveProm := IFNULL(Par_ClaveProm, Cadena_Vacia);

		IF(Par_ClaveProm = Cadena_Vacia ) THEN
			SET Par_NumErr  := 4;
			SET Par_ErrMen  := 'La clave del promotor no existe';
			LEAVE ManejoErrores;
		END IF;

		/** Finaliza apartado de validaciones **/

		SELECT FechaSistema INTO Fecha_Param FROM PARAMETROSSIS;

		SET Fecha_Param := IFNULL(Fecha_Param, Fecha_Vacia);

		SELECT RegistroID
		INTO Var_Consecutivo
		FROM BITACORAPAGMOVILHEAD
		WHERE 	DispositivoID = Par_DispositivoID
			AND ClaveProm = Par_ClaveProm
			AND Fecha = Fecha_Param;

		SET Var_Consecutivo := IFNULL(Var_Consecutivo, Entero_Cero);

		IF(Var_Consecutivo = Entero_Cero ) THEN
			CALL BITACORAPAGMOVILHEADALT(
				Var_Consecutivo, 		Par_DispositivoID, 		Fecha_Param, 		Par_ClaveProm, 			Salida_NO,
				Par_NumErr, 			Par_ErrMen, 			Aud_EmpresaID, 		Aud_Usuario, 			Aud_FechaActual,
				Aud_DireccionIP, 		Aud_ProgramaID, 		Aud_Sucursal, 		Aud_NumTransaccion
			);
		ELSE
			DELETE FROM BITACORAPAGOSMOVILDET WHERE BitacoraHeadID = Var_Consecutivo;
		END IF;	

		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= CONCAT('Bitacora Agregada Exitosamente');
		SET Var_Control		:= 'bitacoraID';
		SET Par_RegistroID  := Var_Consecutivo;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;

	END IF;

END TerminaStore$$
