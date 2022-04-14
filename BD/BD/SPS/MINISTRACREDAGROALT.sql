-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MINISTRACREDAGROALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `MINISTRACREDAGROALT`;

DELIMITER $$
CREATE PROCEDURE `MINISTRACREDAGROALT`(
	/*SP para dar de alta las ministraciones de credito*/
	Par_TransaccionID			BIGINT(20),				# Numero de transaccion
	Par_Numero					INT(11),				# Numero de Ministracion
	Par_SolicitudCreditoID		BIGINT(12),				# Numero de Solicitud de Credito
	Par_CreditoID				BIGINT(20),				# Numero de Credito
	Par_ClienteID				INT(11),				# Numero de Cliente
	Par_ProspectoID				INT(11),				# Numero de Prospecto
	Par_FechaPagoMinis			DATE,					# Fecha de Pago de la Ministracion

	Par_Capital					DECIMAL(18,2),			# Monto de Capital de la ministracion

	Par_Salida					CHAR(1),				# Tipo de Salida S. Si N. No
	Par_NumAlta					TINYINT UNSIGNED,					# Numero de Tipo de Alta 1: Simulador 2:Alta Solicitud 3:Alta Credito
	INOUT	Par_NumErr			INT(11),				# Numero de Error
	INOUT	Par_ErrMen			VARCHAR(400),			# Mensaje de Error

	/*Parametros de Auditoria*/
	Aud_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore:BEGIN

	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(50);			# Variable con el ID del control de Pantalla
	DECLARE Var_FechaSistema		DATE;					# Fecha Actual del Sistema

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia			CHAR(1);				# Cadena Vacia
	DECLARE	Fecha_Vacia				DATE;					# Fecha Vacia
	DECLARE	Entero_Cero				INT;					# Entero Cero
	DECLARE	Entero_Uno				INT;					# Entero Uno
	DECLARE	Decimal_Cero			DECIMAL;				# Decimal Cero
	DECLARE	SalidaNo				CHAR(1);				# Constante SI
	DECLARE	SalidaSi				CHAR(1);				# Constante NO
	DECLARE	EstatusInactivo			CHAR(1);				# Estatus Inactivo
	DECLARE	Alta_Simulador			INT(1);					# Alta de Simulador
	DECLARE	Alta_Solicitud			INT(1);					# Alta de Solicitud
	DECLARE	Alta_Credito			INT(1);					# Alta de Credito
	DECLARE Var_FechaMinistraAnt	DATE;

	-- Asignacion de Constantes
	SET	Cadena_Vacia				:= '';
	SET	Fecha_Vacia					:= '1900-01-01';
	SET	Entero_Cero					:= 0;
	SET	Entero_Uno					:= 1;
	SET	EstatusInactivo				:= 'I';
	SET Var_FechaSistema 			:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
	SET SalidaSi					:= 'S';
	SET Alta_Simulador				:= 1;
	SET Alta_Solicitud				:= 2;
	SET Alta_Credito				:= 3;

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-MINISTRACREDAGROALT');
			SET Var_Control := 'sqlException';
		END;

		SET Par_SolicitudCreditoID		:= IFNULL(Par_SolicitudCreditoID, Entero_Cero);
		SET Par_CreditoID				:= IFNULL(Par_CreditoID, Entero_Cero);
		SET Par_ClienteID				:= IFNULL(Par_ClienteID, Entero_Cero);
		SET Par_ProspectoID				:= IFNULL(Par_ProspectoID, Entero_Cero);
		SET Par_FechaPagoMinis			:= IFNULL(Par_FechaPagoMinis, Fecha_Vacia);
		SET Par_Capital					:= IFNULL(Par_Capital, Decimal_Cero);

		IF(Par_NumAlta = Alta_Simulador) THEN
			/*NO PUEDE SER 0 EL NUMERO DE SOLICITUD O DEL CREDITO POR QUE SON FK.*/
			SET Par_SolicitudCreditoID	:= null;
			SET Par_CreditoID			:= null;
		END IF;

		IF(Par_NumAlta = Alta_Solicitud AND Par_NumAlta = Alta_Credito) THEN
			IF(Par_SolicitudCreditoID = Entero_Cero)THEN
				SET Par_NumErr					:= 001;
				SET Par_ErrMen					:= CONCAT('El Numero de Solicitud Esta Vacio.');
				SET Var_Control					:= 'agrega';
				LEAVE ManejoErrores;
			ELSEIF(Par_SolicitudCreditoID > Entero_Cero) THEN
				IF NOT EXISTS(SELECT SolicitudCreditoID FROM SOLICITUDCREDITO WHERE SolicitudCreditoID = Par_SolicitudCreditoID) THEN
					SET Par_NumErr			:= 003;
					SET Par_ErrMen			:= CONCAT('La Solicitud de Credito No Existe.');
					SET Var_Control			:= 'agrega';
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;

		IF(Par_NumAlta = Alta_Credito) THEN
			IF(Par_CreditoID > Entero_Cero) THEN
					IF NOT EXISTS(SELECT CreditoID FROM CREDITOS WHERE CreditoID = Par_CreditoID) THEN
						SET Par_NumErr			:= 004;
						SET Par_ErrMen			:= CONCAT('El Credito No Existe.');
						SET Var_Control			:= 'agrega';
						LEAVE ManejoErrores;
					END IF;
				ELSE
					SET Par_NumErr			:= 004;
					SET Par_ErrMen			:= CONCAT('El Credito esta Vacio.');
					SET Var_Control			:= 'agrega';
					LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_ClienteID = Entero_Cero AND Par_ProspectoID = Entero_Cero)THEN
			SET Par_NumErr					:= 005;
			SET Par_ErrMen					:= CONCAT('El Numero de Cliente/Prospecto esta Vacio.');
			SET Var_Control					:= 'agrega';
			LEAVE ManejoErrores;
		  ELSEIF(Par_ProspectoID > Entero_Cero) THEN
				IF NOT EXISTS(SELECT ProspectoID FROM PROSPECTOS WHERE ProspectoID = Par_ProspectoID) THEN
					SET Par_NumErr			:= 006;
					SET Par_ErrMen			:= CONCAT('El Prospecto No Existe.');
					SET Var_Control			:= 'agrega';
					LEAVE ManejoErrores;
				END IF;
		  ELSEIF(Par_ClienteID > Entero_Cero) THEN
			IF NOT EXISTS(SELECT ClienteID FROM CLIENTES WHERE ClienteID = Par_ClienteID) THEN
				SET Par_NumErr				:= 007;
				SET Par_ErrMen				:= CONCAT('El Cliente No Existe.');
				SET Var_Control				:= 'agrega';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_FechaPagoMinis = Fecha_Vacia)THEN
			SET Par_NumErr				:= 008;
			SET Par_ErrMen				:= CONCAT('La Fecha de la Ministracion esta Vacia.');
			SET Var_Control				:= 'agrega';
			LEAVE ManejoErrores;
			ELSE
			IF(Par_FechaPagoMinis< Var_FechaSistema) THEN
				SET Par_NumErr			:= 009;
				SET Par_ErrMen			:= CONCAT('La Fecha de la Ministracion es Menor a la Fecha del Sistema.');
				SET Var_Control			:= 'agrega';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_Capital = Decimal_Cero)THEN
			SET Par_NumErr				:= 010;
			SET Par_ErrMen				:= CONCAT('El Monto del Capital debe ser Mayor a 0.');
			SET Var_Control				:= 'agrega';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_Numero != Entero_Uno) THEN
			SET Var_FechaMinistraAnt := (SELECT FechaPagoMinis FROM MINISTRACREDAGRO WHERE SolicitudCreditoID = Par_SolicitudCreditoID AND Numero = (Par_Numero -1));
				IF(Par_FechaPagoMinis <= Var_FechaMinistraAnt) THEN
					SET Par_NumErr				:= 010;
					SET Par_ErrMen				:= CONCAT('La Fecha de Ministracion No Puede Ser Menor a la Fecha de la Ministracion Anterior.');
					SET Var_Control				:= 'agrega';
					LEAVE ManejoErrores;
				END IF;
		END IF;

		SET Aud_FechaActual = NOW();

		INSERT INTO MINISTRACREDAGRO(
			TransaccionID, Numero,
			SolicitudCreditoID,			CreditoID,				ClienteID,				ProspectoID,				FechaPagoMinis,
			Capital,					FechaMinistracion, 		Estatus, 				UsuarioAutoriza, 			FechaAutoriza,
			ComentariosAutoriza,		ForPagComGarantia,
			EmpresaID,					Usuario,				FechaActual,			DireccionIP,				ProgramaID,
			Sucursal,					NumTransaccion)
		VALUES(
			Par_TransaccionID,			Par_Numero,
			Par_SolicitudCreditoID,		Par_CreditoID,			Par_ClienteID,			Par_ProspectoID,			Par_FechaPagoMinis,
			Par_Capital,				Fecha_Vacia,			EstatusInactivo,		Aud_Usuario,				Fecha_Vacia,
			Cadena_Vacia,				Cadena_Vacia,
			Aud_EmpresaID,				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
			Aud_Sucursal,				Aud_NumTransaccion);

		SET Par_NumErr	:= 0;
		SET Par_ErrMen	:=CONCAT('La Ministracion Agregada Exitosamente.');

	END ManejoErrores;

	IF(Par_Salida=SalidaSi)THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				'' AS Consecutivo,
				'agrega' AS Control;
	END IF;
END TerminaStore$$