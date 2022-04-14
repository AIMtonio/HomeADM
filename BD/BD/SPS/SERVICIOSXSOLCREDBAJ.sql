DELIMITER ;
DROP PROCEDURE IF EXISTS `SERVICIOSXSOLCREDBAJ`;
DELIMITER $$

CREATE PROCEDURE `SERVICIOSXSOLCREDBAJ`(
	-- Stored procedure para la baja de servicios adicionales por solicitud y/o crédito
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
	DECLARE Var_Control				VARCHAR(30);		--	Parametro para la columna de salida

	-- Constantes
	DECLARE	Entero_Cero				INT(11);			--	Entero Cero
	DECLARE	Cadena_Vacia			CHAR(1);			--	Cadena vacía
	DECLARE	Fecha_Vacia				DATE;				--	Fecha vacía '1900-01-01'
	DECLARE Var_SalidaSi			CHAR(1);			--	Valor si no se desea una salida
	DECLARE Var_CadenaNo			CHAR(1);			--	Valor No

	-- Asignacion de constantes
	SET	Entero_Cero					:=	0;				--	Se establece el cero (0)
	SET	Cadena_Vacia				:=	'';				--	Se establece la cadena vacía ('')
	SET	Fecha_Vacia					:=	'1900-01-01';	--	Se establece el valor a '1900-01-01'
	SET	Var_SalidaSi				:=	'S';			--	Se establece el valor S ('Si')
	SET Var_CadenaNo				:=	'N';			--	Se establece el valor N ('No')

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := concat('El SAFI ha tenido un problema al concretar la operación. Disculpe las molestias que ',
			'esto le ocasiona. Ref: SP-SERVICIOSXSOLCREDBAJ');
			SET Var_Control := 'sqlException';
		END;

		IF Par_ServicioID != Entero_Cero THEN
			DELETE FROM SERVICIOSXSOLCRED WHERE ServicioID = Par_ServicioID;
			SET Var_Control := 'ServicioID';
		END IF;

		IF Par_SolicitudCreditoID != Entero_Cero THEN
			DELETE FROM SERVICIOSXSOLCRED WHERE SolicitudCreditoID = Par_SolicitudCreditoID;
			UPDATE SOLICITUDCREDITO SET AplicaDescServicio = Var_CadenaNo WHERE SolicitudCreditoID = Par_SolicitudCreditoID;
			SET Var_Control := 'SolicitudCreditoID';
		END IF;

		IF Par_CreditoID != Entero_Cero THEN
			DELETE FROM SERVICIOSXSOLCRED WHERE CreditoID = Par_CreditoID;
			UPDATE CREDITOS SET AplicaDescServicio = Var_CadenaNo WHERE CreditoID = Par_CreditoID;
			SET Var_Control := 'CreditoID';
		END IF;

		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := 'Servicios Adicionales eliminados';
	END ManejoErrores;

	IF Par_Salida = Var_SalidaSi THEN
		SELECT Par_NumErr AS NumErr,	Par_ErrMen AS ErrMen,	Var_Control AS Control,	Entero_Cero AS Consecutivo;
	END IF;
END TerminaStore$$