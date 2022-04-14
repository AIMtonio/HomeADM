-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BENEFICDISPERSIONCREALT
DELIMITER ;
DROP PROCEDURE IF EXISTS BENEFICDISPERSIONCREALT;


DELIMITER $$

CREATE PROCEDURE BENEFICDISPERSIONCREALT(
	Par_SolicitudCreditoID	BIGINT(20),		-- Número de Solicitud
	Par_TipoDispersionID	CHAR(1),		-- Tipo de Dispersión ID
	Par_Beneficiario		VARCHAR(200),	-- Nombre del Beneficiario
	Par_Cuenta				VARCHAR(20),	-- Nro de cuenta para dispersiñon
	Par_MontoDispersion		DECIMAL(12,2),	-- Monto de dispersión
	Par_PermiteModificar	INT(11),		-- Indica el nivel de datos que se pueden modicar 1.- Permiter todo en Nuevos, 2.- Permite Monto en externas, 3.- No permite modificar nada para internas

	Par_Salida				CHAR(1),		-- Tipo de Salida S.- Si N.- No
	INOUT Par_NumErr		INT(11),		-- Control de Errores: Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Control de Errores: Descripcion del Error

	Aud_EmpresaID			INT(11),		-- Parametro de Auditoria
	Aud_Usuario				INT(11),		-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,		-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de Auditoria
	Aud_Sucursal			INT(11),		-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de Auditoria
					)

TerminaStore: BEGIN
	-- Declaraciòn de variables y constantes
	DECLARE Entero_Cero			INT;			-- Constante Entero cero
	DECLARE Decimal_Cero		DECIMAL(12,2);	-- Constante Decimal cero
	DECLARE Var_SolicitudCre 	INT;			-- Variable de conteo de solicitudes
	DECLARE Var_Control			VARCHAR(100);	-- Variable de control
	DECLARE Var_SalidaSI		CHAR(1);		-- Constante de SI
	DECLARE Var_SalidaNO		CHAR(1);		-- Constante de NO
	DECLARE Var_Vacio			CHAR(1);		-- Constante de vacío
	DECLARE Var_Cuenta			INT;			-- Variable para contar registros
	DECLARE Var_TipoDispersion	VARCHAR(100);	-- Tipo de Dispersión S .- SPEI, C .- Cheque O .- Orden de Pago , E.- Efectivo, T.- TRAN. SANTANDER, N.- No Aplica
	DECLARE Var_BenefiDisperID	INT;				-- variable para consecutivo de beneficiario de dispresión
	DECLARE ErrNum				INT;
	DECLARE ErrNumRetorno		INT;
	DECLARE ErrMsg				VARCHAR(250);

	-- Inicialización de constantes
	SET Entero_Cero			:= 0;				-- Constante entero cero
	SET Decimal_Cero		:= 0.0;				-- Constante DECIMAL cero
	SET Var_SalidaSI		:= 'S';				-- Constante de SI
	SET Var_SalidaNO		:= 'N';				-- Constante de NO
	SET Var_Vacio			:= '';				-- Constante de vacío
	SET Var_TipoDispersion	:= 'S,C,O,E,T,N'; 	-- Tipo de Dispersión S .- SPEI, C .- Cheque O .- Orden de Pago , E.- Efectivo, T.- TRAN. SANTANDER, N.- No Aplica.
	SET ErrNumRetorno		:= 999;

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-BENEFICDISPERSIONCREALT');

			SET Var_Control:= 'sqlException';
		END;

 		IF(Par_SolicitudCreditoID = Entero_Cero) THEN
			SET Par_NumErr  := 010;
			SET Par_ErrMen  := 'La Solicitud de Crédito no es válida.' ;
			SET Var_Control := 'solicitudCreditoID';
			LEAVE ManejoErrores;
		END IF;

		SELECT FIND_IN_SET(Par_TipoDispersionID,Var_TipoDispersion) INTO Var_Cuenta;

		IF(Var_Cuenta = Entero_Cero) THEN
			SET Par_NumErr  := 020;
			SET Par_ErrMen  := 'El Tipo de Dispersión no es válido.' ;
			SET Var_Control := 'tipoDispersionID';
			LEAVE ManejoErrores;
		END IF;

		IF(TRIM(Par_Beneficiario) = Var_Vacio) THEN
			SET Par_NumErr  := 030;
			SET Par_ErrMen  := 'El Beneficiario no puede estar vacío.' ;
			SET Var_Control := 'beneficiario';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_MontoDispersion <= Decimal_Cero) THEN
			SET Par_NumErr  := 050;
			SET Par_ErrMen  := 'El monto de la dispersión del beneficiario no puede ser menor o igual a cero.' ;
			SET Var_Control := 'cuenta';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_PermiteModificar = Decimal_Cero) THEN
			SET Par_NumErr  := 060;
			SET Par_ErrMen  := 'El nivel de modificación no puede ser igual a cero.' ;
			SET Var_Control := 'permiteModificar';
			LEAVE ManejoErrores;
		END IF;



		IF NOT EXISTS (SELECT SolicitudCreditoID
						 FROM INSTRUCDISPERSIONCRE
						WHERE SolicitudCreditoID = Par_SolicitudCreditoID) THEN

			CALL INSTRUCDISPERSIONCREALT(
										Par_SolicitudCreditoID,		Var_SalidaNO,		ErrNum,				ErrMsg,				Aud_EmpresaID,
										Aud_Usuario,				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
										Aud_NumTransaccion);

			IF(ErrNum > Entero_Cero) THEN

				SET Par_NumErr		:= ErrNum;
				SET Par_ErrMen		:= ErrMsg;
				SET Var_Control		:= 'solicitudCreditoID';
				LEAVE ManejoErrores;

			END IF;


		END IF;

			SELECT IFNULL( MAX(BenefiDisperID)+1,1) INTO  Var_BenefiDisperID
			  FROM BENEFICDISPERSIONCRE
			 WHERE SolicitudCreditoID	= Par_SolicitudCreditoID;

			SET	Aud_FechaActual	:= CURRENT_TIMESTAMP();

			-- Inserta beneficiarios de con dispersiónA
			INSERT INTO BENEFICDISPERSIONCRE(
							SolicitudCreditoID,	BenefiDisperID,		TipoDispersionID,	Beneficiario, 	Cuenta,
							MontoDispersion,	PermiteModificar,	EmpresaID,			Usuario,		FechaActual,
							DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)
			VALUES	(
					Par_SolicitudCreditoID,	Var_BenefiDisperID,		Par_TipoDispersionID,	Par_Beneficiario,	Par_Cuenta,
					Par_MontoDispersion,	Par_PermiteModificar,	Aud_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
					Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion
					);

			-- Actualiza el monto de dispersión
			UPDATE INSTRUCDISPERSIONCRE
			   SET MontoDispersion		= MontoDispersion + Par_MontoDispersion
			 WHERE SolicitudCreditoID	= Par_SolicitudCreditoID;

				SET		Par_NumErr	:= 0;
				SET		Par_ErrMen	:= CONCAT('Beneficiario Agregado Exitosamente: ', CONVERT(Par_SolicitudCreditoID, CHAR));
				SET		Var_Control	:= 'solicitudCreditoID';

END ManejoErrores;

	IF(Par_Salida = Var_SalidaSI) THEN
		SELECT  Par_NumErr				AS NumErr,
				Par_ErrMen				AS ErrMen,
				Var_Control				AS control,
				Par_SolicitudCreditoID	AS consecutivo;/*Enviar siempre en exito el numero de Solicitud*/
	END IF;

END TerminaStore$$




