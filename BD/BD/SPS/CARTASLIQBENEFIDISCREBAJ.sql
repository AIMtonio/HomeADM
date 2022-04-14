-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CARTASLIQBENEFIDISCREBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS CARTASLIQBENEFIDISCREBAJ;

DELIMITER $$
CREATE PROCEDURE CARTASLIQBENEFIDISCREBAJ(
    -- SP de Baja de Informacion de las Intrucciones de Dispersion de un Credito cuando hay una modificacion de Cartas de Liquidacion
	Par_SolicitudCreditoID	BIGINT(20),		-- Número de Solicitud

	Par_Salida					CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr			INT(11),		-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),	-- Mensaje de Error

	Aud_EmpresaID				INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP				VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control					VARCHAR(100);	-- Variable de Retorno en Pantalla
    DECLARE Var_ExisteSolici INT(11);			-- Variable de Contador de Solicitud Credito
    DECLARE Var_Monto		DECIMAL(12,2);		-- Variable Monto de Dispersion INSTRUCDISPERSIONCRE
	DECLARE Var_EstSolicitud	CHAR(1);

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia		CHAR(1);		-- Constante de Cadena Vacia
	DECLARE	Salida_SI			CHAR(1);		-- Constante de Salida SI
	DECLARE	Salida_NO			CHAR(1);		-- Constante de Salida NO
	DECLARE	Entero_Cero			INT(11);		-- Constante de Entero Cero
	DECLARE	Entero_Uno			INT(11);		-- Constante de Entero Uno
	DECLARE	Decimal_Cero		DECIMAL(12,2);	-- Constante de Decimal Cero
	DECLARE Est_Inactiva	CHAR(1);
	DECLARE Est_Liberada	CHAR(1);
	-- Asignacion  de constantes
	SET	Cadena_Vacia	:= '';
	SET	Salida_SI		:= 'S';
	SET	Salida_NO		:= 'N';
	SET	Entero_Cero		:= 0;
	SET	Entero_Uno		:= 1;
	SET	Decimal_Cero	:= 0.0;
	SET Var_Control		:= Cadena_Vacia;
	SET Est_Inactiva		:= 'I';
	SET Est_Liberada		:= 'L';

	-- Bloque para manejar los posibles errores
	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CARTASLIQBENEFIDISCREBAJ');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

		-- Validacion para el numero de Empleado de Administracion esta Vacio
		IF( Par_SolicitudCreditoID = Entero_Cero ) THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:= 'La Solicitud de Credito esta vacia.';
			SET Var_Control	:= 'solicitudCreditoID';
			LEAVE ManejoErrores;
		END IF;

		SELECT Estatus
		INTO Var_EstSolicitud
		FROM SOLICITUDCREDITO
		WHERE SolicitudCreditoID = Par_SolicitudCreditoID;

		IF(Var_EstSolicitud NOT IN (Est_Inactiva, Est_Liberada ))THEN
			SET Par_NumErr	:= 002;
			SET Par_ErrMen	:= 'El Estatus de la Solicitud de Credito es Incorrecto para  Agregar Cartas de Liquidacion.';
			SET Var_Control	:= 'solicitudCreditoID';
			LEAVE ManejoErrores;
		END IF;

        -- Se valida si hay Instrucciones de Dispersion ligadas a la Solicitud
		SELECT COUNT(SolicitudCreditoID)
		INTO Var_ExisteSolici
		FROM BENEFICDISPERSIONCRE
		WHERE SolicitudCreditoID = Par_SolicitudCreditoID;

		IF(Var_ExisteSolici > Entero_Cero)THEN
			-- Elimina todos los beneficiarios asociados a la dispersión de la solicitud de crédito
			-- Se eliminan solo las Internas y Externas
			DELETE
			FROM BENEFICDISPERSIONCRE
			WHERE SolicitudCreditoID = Par_SolicitudCreditoID
				AND PermiteModificar != 1;

			-- Actualiza el monto de la dispersión de la instrucción de dispersión
			SELECT SUM(MontoDispersion)
			INTO Var_Monto
			FROM BENEFICDISPERSIONCRE
			WHERE SolicitudCreditoID = Par_SolicitudCreditoID
				AND PermiteModificar = 1;

			SET Var_Monto := IFNULL(Var_Monto, Decimal_Cero);

			UPDATE INSTRUCDISPERSIONCRE
				SET MontoDispersion = Var_Monto
			WHERE SolicitudCreditoID = Par_SolicitudCreditoID;
		END IF;

		SET Par_NumErr	:= 	Entero_Cero;
		SET Par_ErrMen	:= 'La dispersion se elimino correctamente.';
		SET Var_Control	:= 'solicitudCreditoID';

	END ManejoErrores;
	-- Fin del manejador de errores.

	IF(Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_SolicitudCreditoID AS Consecutivo;
	END IF;

END TerminaStore$$