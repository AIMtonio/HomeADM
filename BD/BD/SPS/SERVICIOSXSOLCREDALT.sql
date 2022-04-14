DELIMITER ;
DROP PROCEDURE IF EXISTS `SERVICIOSXSOLCREDALT`;
DELIMITER $$

CREATE PROCEDURE `SERVICIOSXSOLCREDALT`(
	-- Stored procedure para la alta de servicios adicionales por solicitud y/o crédito
	Par_ServicioID			INT(11),					--	ID del servicio adicional
	Par_SolicitudCreditoID	INT(11),					--	ID de la solicitud de crédito
	Par_CreditoID			BIGINT(12),					--	ID del crédito

	Par_Salida				CHAR(1),					--	Parámetro que indica si hay salida o no
	INOUT Par_NumErr		INT(11),					--	Parámetro para retornar el número de error
	INOUT Par_ErrMen		VARCHAR(400),				--	Parámetro para retornar el mensaje de error

	Aud_EmpresaID			INT(11),					--	Parámetro de auditoría
	Aud_Usuario				INT(11),					--	Parámetro de auditoría
	Aud_FechaActual			DATETIME,					--	Parámetro de auditoría
	Aud_DireccionIP			VARCHAR(15),				--	Parámetro de auditoría
	Aud_ProgramaID			VARCHAR(50),				--	Parámetro de auditoría
	Aud_Sucursal			INT(11),					--	Parámetro de auditoría
	Aud_NumTransaccion		BIGINT(20)					--	Parámetro de auditoría
)
TerminaStore: BEGIN
	-- Variables
	DECLARE Var_Control				VARCHAR(50);		--	Parametro para la columna de salida

	-- Constantes
	DECLARE	Entero_Cero				INT(11);			--	Entero Cero
	DECLARE Var_SalidaSi			CHAR(1);			--	Valor si no se desea una salida
	DECLARE Var_CadenaSi			CHAR(1);			--	Valor Si

	-- Asignacion de constantes
	SET	Entero_Cero					:=	0;				--	Se establece el cero (0)
	SET	Var_SalidaSi				:=	'S';			--	Se establece el valor S ('Si')
	SET Var_CadenaSi				:=	'S';			--	Se establece el valor S ('Si')

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := concat('El SAFI ha tenido un problema al concretar la operación. Disculpe las molestias que ',
			'esto le ocasiona. Ref: SP-SERVICIOSXSOLCREDALT');
			SET Var_Control := 'sqlException';
		END;

		INSERT INTO SERVICIOSXSOLCRED (ServicioID,	SolicitudCreditoID,	CreditoID,	EmpresaID,		Usuario,
			FechaActual,	DireccionIP,	ProgramaID,	Sucursal,	NumTransaccion) VALUES
			(Par_ServicioID,	Par_SolicitudCreditoID,	Par_CreditoID,	Aud_EmpresaID,	Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

		IF Par_SolicitudCreditoID != Entero_Cero THEN
			UPDATE SOLICITUDCREDITO SET AplicaDescServicio = Var_CadenaSi WHERE SolicitudCreditoID = Par_SolicitudCreditoID;
		END IF;

		IF Par_CreditoID != Entero_Cero THEN
			UPDATE CREDITOS SET AplicaDescServicio = Var_CadenaSi WHERE CreditoID = Par_CreditoID;
		END IF;

		SET Var_Control := 'ServicioID';
		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := 'Servicio Adicional registrado';
	END ManejoErrores;

	IF Par_Salida = Var_SalidaSi THEN
		SELECT Par_NumErr AS NumErr,	Par_ErrMen AS ErrMen,	Var_Control AS Control,	Entero_Cero AS Consecutivo;
	END IF;
END TerminaStore$$