-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORACREDCANCELALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORACREDCANCELALT`;
DELIMITER $$


CREATE PROCEDURE `BITACORACREDCANCELALT`(
	/*SP para dar de alta los Metodos de Pago */
    Par_CreditoID		BIGINT(12),			# Numero de Credito
    Par_ClienteID		INT(11),			# Numero de Cliente
    Par_CuentaAhoID		BIGINT(12),			# Cuenta de Ahorro
    Par_FechaCancela	DATE,				# Fecha de Cancelacion
    Par_MotivoCancela	VARCHAR(200),		# Motivo de Cancelacion

    Par_MontoCancela	DECIMAL(14,2),		# Monto Total a Cancelar
    Par_Capital			DECIMAL(14,2),		# Monto Capital a Cancelar
    Par_Interes			DECIMAL(14,2),		# Monto Interes a Cancelar
    Par_MontoGar		DECIMAL(14,2),		# Monto Garantia a Cancelar
    Par_Comisiones		DECIMAL(14,2),		# Monto Comisiones a Cancelar

    Par_UsuarioCancela	INT(11),			# Uusario que realiza la cancelacion
    Par_UsuarioAutCan	INT(11),			# Usuario que autoriza la cancelacion
    Par_PolizaID		BIGINT(20),			# Numero de Poliza
	Par_Salida			CHAR(1),			# Tipo de Salida S.- Si N.- No

	INOUT Par_NumErr	INT(11),			# Numero de Error
	INOUT Par_ErrMen	VARCHAR(400),		# Mensaje de Error

	/* Parametros de Auditoria */
	Aud_EmpresaID		INT(11) ,
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),

	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
	)

TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE Salida_SI 			CHAR(1);
    DECLARE Entero_Cero			INT(11);
    DECLARE Fecha_Vacia			DATE;
    DECLARE Decimal_Cero		DECIMAL(14,2);

	-- Declaracion de Variables
	DECLARE Var_Control			VARCHAR(20);
	DECLARE Var_Consecutivo		VARCHAR(50);

	-- Asignacion de constantes
	SET	Cadena_Vacia			:= '';
	SET Salida_SI				:= 'S';
    SET Entero_Cero 			:= 0;
    SET Fecha_Vacia				:= '1900-01-01';
    SET Decimal_Cero			:= 0.00;

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-BITACORACREDCANCELALT');
			SET Var_Control	:= 'sqlException';
		END;

		SET Par_CreditoID		:= IFNULL(Par_CreditoID, Entero_Cero);
		SET Par_ClienteID		:= IFNULL(Par_ClienteID, Entero_Cero);
        SET Par_CuentaAhoID		:= IFNULL(Par_CuentaAhoID, Entero_Cero);
		SET Par_FechaCancela	:= IFNULL(Par_FechaCancela, Fecha_Vacia);
        SET Par_MotivoCancela	:= IFNULL(Par_MotivoCancela, Cadena_Vacia);
        SET Par_MontoCancela	:= IFNULL(Par_MontoCancela, Decimal_Cero);
        SET Par_Capital			:= IFNULL(Par_Capital, Decimal_Cero);
        SET Par_Interes			:= IFNULL(Par_Interes, Decimal_Cero);
        SET Par_MontoGar		:= IFNULL(Par_MontoGar, Decimal_Cero);
        SET Par_Comisiones		:= IFNULL(Par_Comisiones, Decimal_Cero);
        SET Par_UsuarioCancela	:= IFNULL(Par_UsuarioCancela, Entero_Cero);
        SET Par_UsuarioAutCan	:= IFNULL(Par_UsuarioAutCan, Entero_Cero);
        SET Par_PolizaID		:= IFNULL(Par_PolizaID, Entero_Cero);

		IF(Par_CreditoID = Entero_Cero) THEN
			SET Par_NumErr		:= 001;
			SET Par_ErrMen		:= 'El Numero de Credito esta Vacio.';
			SET Var_Consecutivo	:= Cadena_Vacia;
			SET Var_Control		:= 'creditoID';
            LEAVE ManejoErrores;
		END IF;

		IF(Par_ClienteID = Entero_Cero) THEN
			SET Par_NumErr		:= 002;
			SET Par_ErrMen		:= 'La Cuenta de Ahorro esta Vacia.';
			SET Var_Consecutivo	:= Cadena_Vacia;
			SET Var_Control		:= 'creditoID';
            LEAVE ManejoErrores;
		END IF;

        IF(Par_CuentaAhoID = Entero_Cero) THEN
			SET Par_NumErr		:= 003;
			SET Par_ErrMen		:= 'El Numero de Cliente esta Vacio.';
			SET Var_Consecutivo	:= Cadena_Vacia;
			SET Var_Control		:= 'creditoID';
            LEAVE ManejoErrores;
		END IF;

        IF(Par_FechaCancela = Fecha_Vacia) THEN
			SET Par_NumErr		:= 004;
			SET Par_ErrMen		:= 'La Fecha de Cancelacion esta Vacia.';
			SET Var_Consecutivo	:= Cadena_Vacia;
			SET Var_Control		:= 'creditoID';
            LEAVE ManejoErrores;
		END IF;
        IF(Par_MotivoCancela = Cadena_Vacia) THEN
			SET Par_NumErr		:= 005;
			SET Par_ErrMen		:= 'El Motivo de Cancelacion esta Vacio';
			SET Var_Consecutivo	:= Cadena_Vacia;
			SET Var_Control		:= 'creditoID';
            LEAVE ManejoErrores;
		END IF;
        IF(Par_MontoCancela = Decimal_Cero) THEN
			SET Par_NumErr		:= 006;
			SET Par_ErrMen		:= 'El Monto a Cancelar esta Vacio.';
			SET Var_Consecutivo	:= Cadena_Vacia;
			SET Var_Control		:= 'creditoID';
            LEAVE ManejoErrores;
		END IF;
        IF(Par_Capital = Decimal_Cero) THEN
			SET Par_NumErr		:= 007;
			SET Par_ErrMen		:= 'El Capital a Cancelar esta Vacio.';
			SET Var_Consecutivo	:= Cadena_Vacia;
			SET Var_Control		:= 'creditoID';
            LEAVE ManejoErrores;
		END IF;


		SET Aud_FechaActual := NOW();


		INSERT IGNORE INTO BITACORACREDCANCEL(
			CreditoID,			ClienteID,			CuentaAhoID,		FechaCancel,		MotivoCancel,
            MontoCancel,        Capital,			Interes, 			PolizaID, 			MontoGarantia,
            Comisiones,         UsuarioCancelID,  	UsuarioAutID, 		EmpresaID,			Usuario,
            FechaActual,        DireccionIP,		ProgramaID,			Sucursal,  	 		NumTransaccion)
		VALUES (
			Par_CreditoID,		Par_ClienteID,		Par_CuentaAhoID,	Par_FechaCancela,	Par_MotivoCancela,
            Par_MontoCancela,	Par_Capital, 		Par_Interes,  		Par_PolizaID,		Par_MontoGar,
            Par_Comisiones,		Par_UsuarioCancela,	Par_UsuarioAutCan,	Aud_EmpresaID,		Aud_Usuario,
            Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);


		SET	Par_NumErr			:= 0;
		SET	Par_ErrMen			:= CONCAT('Credito Cancelado Exitosamente Exitosamente: ', CONVERT(Par_CreditoID,CHAR));
		SET Var_Control			:= 'creditoID';
		SET Var_Consecutivo		:= Par_CreditoID;



	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$
