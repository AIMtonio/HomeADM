DELIMITER ;

DROP PROCEDURE IF EXISTS `SPEIENVIOSDESEMBOLSOALT`;

DELIMITER $$

CREATE PROCEDURE `SPEIENVIOSDESEMBOLSOALT`(
	-- SP que realiza el alta a la tabla SPEIENVIOSDESEMBOLSO que ayuda a realizar movimientos de pagos por SPEI
	Par_FolioSPEI					BIGINT(20),					-- Folio de envio por SPEI
	Par_CreditoID					BIGINT(12),					-- ID cuenta credito ahorro del usuario
	Par_BloqueoID					INT(11),					-- ID de bloqueo de credito

	Par_Salida						CHAR(1),				-- Parametro para salida de datos
	INOUT Par_NumErr				INT(11),				-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen				VARCHAR(400),			-- Parametro de entrada/salida de mensaje de control de respuesta de acuerdo al desarrollador

	Aud_EmpresaID 					INT(11),				-- Parametros de auditoria
	Aud_Usuario						INT(11),				-- Parametros de auditoria
	Aud_FechaActual					DATETIME,				-- Parametros de auditoria
	Aud_DireccionIP					VARCHAR(15),			-- Parametros de auditoria
	Aud_ProgramaID					VARCHAR(50),			-- Parametros de auditoria
	Aud_Sucursal					INT(11), 				-- Parametros de auditoria
	Aud_NumTransaccion				BIGINT(20)				-- Parametros de auditoria
	)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Control						VARCHAR(200);
	DECLARE Var_Consecutivo					INT(11);					-- ID desembolso de un envio SPEI

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(1);
	DECLARE	Decimal_Cero		DECIMAL(14,2);
	DECLARE Salida_SI			CHAR(1);

	-- Asignacion de Constantes
	SET	Cadena_Vacia		:= ''; 				-- Cadena vacia
	SET	Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
	SET	Entero_Cero			:= 0; 				-- Entero Cero
	SET	Decimal_Cero		:= 0.0;				-- Decimal Cero
	SET Salida_SI			:= 'S';				-- Salida: SI

	SET Par_BloqueoID := IFNULL(Par_BloqueoID,Entero_Cero);

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-SPEIENVIOSDESEMBOLSOALT');
				SET Var_Control = 'SQLEXCEPTION' ;
			END;

		IF(IFNULL(Par_FolioSPEI,Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr 	:= 001;
			SET Par_ErrMen 	:= 'El folio de SPEI se encuentra vacio.';
			SET Var_Control := 'FolioSPEI' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_CreditoID,Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr 	:= 002;
			SET Par_ErrMen 	:= 'El ID de credito se encuentra vacio.';
			SET Var_Control := 'CreditoID' ;
			LEAVE ManejoErrores;
		END IF;

		CALL FOLIOSAPLICAACT('SPEIENVIOSDESEMBOLSO', Var_Consecutivo);

		INSERT INTO SPEIENVIOSDESEMBOLSO (
								SpeiEnviosDesembID,			FolioSPEI,				CreditoID, 			BloqueoID,				EmpresaID,
								Usuario,					FechaActual,			DireccionIP,		ProgramaID,				Sucursal,
								NumTransaccion)
		VALUES (
								Var_Consecutivo,			Par_FolioSPEI,			Par_CreditoID,		Par_BloqueoID,			Aud_EmpresaID,
								Aud_Usuario,				Aud_FechaActual,	   	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,
								Aud_NumTransaccion);

			SET Par_NumErr 	:= Entero_Cero;
			SET Par_ErrMen 	:= CONCAT(" El SPEI por Desembolso se ha dado de alta exitosamente: ", CONVERT(Var_Consecutivo, CHAR));
			SET Var_Control := 'SpeiEnviosDesembID' ;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$