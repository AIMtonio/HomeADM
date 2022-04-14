-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREGARPRENHIPOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREGARPRENHIPOALT`;DELIMITER $$

CREATE PROCEDURE `CREGARPRENHIPOALT`(
# ====================================================================================================
# ----- SP QUE INSERTA LAS GARANTIAS QUE SON HIPOTECARIAS CONSIDERADAS PARA EL CALCULO DE LA EPRC ----
# ====================================================================================================
	Par_NombreCliente		VARCHAR(200),		# Nombre del Cliente
	Par_MontoOriginal		DECIMAL(14,2),		# Monto Original de la Garantia
	Par_MontoGarPren		DECIMAL(14,2),		# Monto de la Garantia Prendaria
	Par_MontoGarHipo		DECIMAL(14,2),		# Monto de la Garantia Hipotecaria
	Par_FechaAvaluo			DATE,				# Fecha de Avaluo de la Garantia

	Par_ClienteID			INT(11),			# Numero de Cliente
	Par_SolicitudCreditoID	BIGINT(20),			# Numero de Solicitud de Credito
	Par_MontoAvaluo			DECIMAL(14,2),		# Monto de Avaluo
	Par_NumeroAvaluo		VARCHAR(10),		# Numero de Avaluo
	Par_MontoLibreGrava		DECIMAL(14,2),		# Indica si la garantia esta libre de gravamen

	Par_Salida				CHAR(1),			# Tipo de Salida S.- Si N.- No
	INOUT Par_NumErr		INT(11),			# Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),		# Mensaje de Error

	/* Parametros de Auditoria */
	Aud_EmpresaID			INT(11) ,
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
	)
TerminaStore: BEGIN

	-- DECLARACION DE CONSTANTES
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE Salida_SI 			CHAR(1);
    DECLARE Entero_Cero			INT(11);
    DECLARE Decimal_Cero		DECIMAL(12,2);

	-- DECLARACION DE VARIABLES
	DECLARE Var_Control			VARCHAR(20);
	DECLARE Var_Consecutivo		VARCHAR(50);

	-- ASIGNACION DE CONSTANTES
	SET	Cadena_Vacia			:= '';
	SET Salida_SI				:= 'S';
    SET Entero_Cero 			:= 0;
	SET Decimal_Cero			:= 0.00;


	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
				SET Par_NumErr	:= 999;
				SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CREGARPRENHIPOALT');
				SET Var_Control	:= 'sqlException';
		END;

		SET Par_ClienteID			:= IFNULL(Par_ClienteID, Entero_Cero);
		SET Par_SolicitudCreditoID	:= IFNULL(Par_SolicitudCreditoID, Entero_Cero);

		-- VALIDACIONES
		IF(IFNULL(Par_ClienteID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr		:= 001;
			SET Par_ErrMen		:= 'El Numero de Cliente esta Vacio.';
			SET Var_Consecutivo	:= Cadena_Vacia;
			SET Var_Control		:= 'clienteID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_SolicitudCreditoID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr		:= 001;
			SET Par_ErrMen		:= 'El Numero de Solicitud de Credito esta Vacio.';
			SET Var_Consecutivo	:= Cadena_Vacia;
			SET Var_Control		:= 'solicitudCreditoID';
			LEAVE ManejoErrores;
		END IF;


		SET Aud_FechaActual := NOW();

		# SE INSERTA EL REGISTRO A LA TABLA
		INSERT INTO CREGARPRENHIPO(
			CreditoID, 			NombreSocio, 		Monto_Original, 		SalCapVigente, 		SalCapVencido,
            GarPrendaria, 		GarHipotecaria, 	FechaAvaluo, 			ClienteID, 			SolicitudCreditoID,
            MontoAvaluo,		NumeroAvaluo,		MontoGarHipo,			EmpresaID,  		Usuario,
            FechaActual,        DireccionIP,		ProgramaID,    			Sucursal,   		NumTransaccion)
			VALUES (
			Entero_Cero, 		Par_NombreCliente,	Par_MontoOriginal,		Decimal_Cero,		Decimal_Cero,
            Par_MontoGarPren,	Par_MontoGarHipo, 	Par_FechaAvaluo,		Par_ClienteID,		Par_SolicitudCreditoID,
            Par_MontoAvaluo,	Par_NumeroAvaluo,	Par_MontoLibreGrava,	Aud_EmpresaID,  	Aud_Usuario,
            Aud_FechaActual,   	Aud_DireccionIP,	Aud_ProgramaID, 		Aud_Sucursal,   	Aud_NumTransaccion);

		SET	Par_NumErr			:= 0;
		SET	Par_ErrMen			:= CONCAT('Garantia Asignada Exitosamente');
		SET Var_Control			:= 'solicitudCreditoID';
		SET Var_Consecutivo		:= Par_SolicitudCreditoID;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$