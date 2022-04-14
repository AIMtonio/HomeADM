

-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INSTRUCDISPERSIONCREALT
DELIMITER ;
DROP PROCEDURE IF EXISTS INSTRUCDISPERSIONCREALT;


DELIMITER $$

CREATE PROCEDURE INSTRUCDISPERSIONCREALT(
	Par_SolicitudCreditoID	BIGINT(20),		-- 'Número de Solicitud'
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
	DECLARE Var_SolicitudCre	INT;			-- Variable de conteo de solicitudes
	DECLARE Var_Control			VARCHAR(100);	-- Variable de control
	DECLARE Var_SalidaSI		CHAR(1);		-- Constante de SI

	-- Inicialización de constantes
	SET Entero_Cero		:= 0;		-- Constante entero cero
	SET Decimal_Cero	:= 0.0;		-- Constante DECIMAL cero
	SET Var_SalidaSI	:= 'S';		-- Constante de SI

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
			SET Par_ErrMen  := 'La Solicitud de Crédito no es válida.';
			SET Var_Control := 'solicitudCreditoID';
			LEAVE ManejoErrores;
		END IF;

		IF EXISTS (SELECT SolicitudCreditoID
					 FROM INSTRUCDISPERSIONCRE
					WHERE SolicitudCreditoID = Par_SolicitudCreditoID) THEN

			SET Par_NumErr  := 030;
			SET Par_ErrMen  := 'La Solicitud de Crédito ya existe, favor de validar.';
			SET Var_Control := 'solicitudCreditoID';
			LEAVE ManejoErrores;

		END IF;

		INSERT INTO INSTRUCDISPERSIONCRE(
						SolicitudCreditoID,		EmpresaID,		Usuario,	FechaActual,
						DireccionIP,			ProgramaID,		Sucursal,	NumTransaccion)
		VALUES	(
				Par_SolicitudCreditoID, 	Aud_EmpresaID,		Aud_Usuario,	Aud_FechaActual,
				Aud_DireccionIP,			Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion
				);

		SET	Par_NumErr	:= 0;
		SET	Par_ErrMen	:= CONCAT('Solicitud de Credito Agregada Exitosamente: ', CONVERT(Par_SolicitudCreditoID, CHAR));
		SET	Var_Control	:= 'solicitudCreditoID';

END ManejoErrores;

	IF(Par_Salida = Var_SalidaSI) THEN
		SELECT  Par_NumErr				AS NumErr,
				Par_ErrMen				AS ErrMen,
				Var_Control				AS control,
				Par_SolicitudCreditoID	AS consecutivo;/*Enviar siempre en exito el numero de Solicitud*/
	END IF;

END TerminaStore$$




