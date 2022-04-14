-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ISOTRXTARNOTIFICAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS ISOTRXTARNOTIFICAALT;

DELIMITER $$
CREATE PROCEDURE `ISOTRXTARNOTIFICAALT`(
	-- Store Procedure: Alta de Notificaciones para la tarea de Notificacion de Saldos a ISOTRX
	-- Modulo Tarjetas de Debito - WS ISOTRX
	Par_TipoInstrumento			INT(11),			-- Tipo de Instrumento (Cuenta de Ahorro, Inversion, Cede, Credito)
	Par_NumeroInstrumento		BIGINT(20),			-- Numero de Instrumento (CuentaAhoID, InversionID, CedeID, CreditoID)
	Par_Transaccion				BIGINT(20),			-- Numero de Transaccion
	Par_OperacionPeticionID		TINYINT UNSIGNED,	-- ID de Proceso(JAVA)
	Par_MontoOperacion			DECIMAL(14,2),		-- Monto de Operacion

	Par_Salida					CHAR(1),			-- Parametro de Salida
	INOUT Par_NumErr			INT(11),			-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),		-- Mensaje de Error

	Aud_EmpresaID				INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,			-- Parametro de auditoria Feha actual
	Aud_DireccionIP				VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Paramentros
	DECLARE Par_RegistroID					INT(11);		-- Numero de Registro
	DECLARE Par_HoraOperacion				TIME;			-- Horario de Operacion
	DECLARE Par_FechaOperacion				DATE;			-- Fecha de Sistema
	DECLARE Par_TipoTarjeta					INT(11);		-- Tipo de Tarjeta
	DECLARE Par_TarjetaID					CHAR(16);		-- Tarjeta de Debito

	DECLARE Par_CuentaAhoID					BIGINT(12);		-- Variable Cuenta de Ahorro

	-- Declaracion de Variables
	DECLARE Var_Control						VARCHAR(100);	-- Variable de Retorno en Pantalla
	DECLARE Var_AutorizaTerceroTranTD		VARCHAR(200);	-- Variable para almacenar el valor del campo AutorizaTerceroTranTD
	DECLARE Var_EjecucionCierreDia			VARCHAR(200);	-- Variable para almacenar el valor del campo EjecucionCierreDia
	DECLARE Var_OperacionPeticionID			INT(11);		-- Variable de Validacion de Operacion Peticion

	-- Declaracion de Constantes
	DECLARE Entero_Cero						INT(11);		-- Constante de Entero Cero
	DECLARE Entero_Uno						INT(11);		-- Constante Entero Uno
	DECLARE Con_TarjetaDebito				INT(11);		-- Tipo Tarjeta Debito
	DECLARE Est_Activada					INT(11);		-- Constante Estatus Activada
	DECLARE Decimal_Cero					DECIMAL(14,2);	-- Constante de Decimal Cero

	DECLARE Fecha_Vacia						DATE;			-- Constante de Fecha Vacia
	DECLARE	Cadena_Vacia					CHAR(1);		-- Constante de Cadena Vacia
	DECLARE Salida_SI						CHAR(1);		-- Constante Salida SI
	DECLARE Con_SI							CHAR(1);		-- Constante SI
	DECLARE Con_NO 							CHAR(1);		-- Constante NO

	DECLARE Tipo_Titular					CHAR(1);		-- Tipo Tarjeta Titular
	DECLARE Tipo_Adicional					CHAR(1);		-- Tipo Tarjeta Adicional
	DECLARE Est_Pendiente					CHAR(1);		-- Estatus Pendiente
	DECLARE Llave_EjecucionCierreDia		VARCHAR(50);	-- Llave EjecucionCierreDia
	DECLARE Llave_AutorizaTerceroTranTD		VARCHAR(50);	-- Llave AutorizaTerceroTranTD

	-- Asignacion de Instrumentos
	DECLARE Inst_CuentaAhorro				TINYINT UNSIGNED;	-- Proceso de Cuenta Ahorro
	DECLARE Inst_Inversion					TINYINT UNSIGNED;	-- Proceso de Inversion
	DECLARE Inst_Cede						TINYINT UNSIGNED;	-- Proceso de Cede
	DECLARE Inst_Credito					TINYINT UNSIGNED;	-- Proceso de Credito

	-- Asignacion de Constantes
	SET Entero_Cero 						:= 0;
	SET Entero_Uno							:= 1;
	SET Con_TarjetaDebito					:= 1;
	SET Est_Activada						:= 7;
	SET Decimal_Cero						:= 0.00;

	SET Fecha_Vacia 						:= '1900-01-01';
	SET Cadena_Vacia						:= '';
	SET Salida_SI							:= 'S';
	SET Con_SI								:= 'S';
	SET Con_NO 								:= 'N';

	SET Tipo_Titular						:= 'T';
	SET Tipo_Adicional						:= 'A';
	SET Est_Pendiente						:= 'P';
	SET Llave_EjecucionCierreDia			:= 'EjecucionCierreDia';
	SET Llave_AutorizaTerceroTranTD			:= 'AutorizaTerceroTranTD';
	SET Var_Control							:= Cadena_Vacia;

	-- Asignacion de Instrumentos
	SET Inst_CuentaAhorro					:= 1;
	SET Inst_Inversion						:= 2;
	SET Inst_Cede							:= 3;
	SET Inst_Credito						:= 4;

	-- Bloque para manejar los posibles errores
	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que  ',
									 'esto le ocasiona. Ref: SP-ISOTRXTARNOTIFICAALT');
			SET Var_Control	= 'SQLEXCEPTION';
		END;


		SET Var_AutorizaTerceroTranTD	:= IFNULL( FNPARAMTARJETAS(Llave_AutorizaTerceroTranTD), Con_NO);
		SET Var_EjecucionCierreDia		:= IFNULL(FNPARAMGENERALES(Llave_EjecucionCierreDia), Con_NO);
		SET Par_TipoInstrumento			:= IFNULL(Par_TipoInstrumento, Entero_Cero);
		SET Par_NumeroInstrumento		:= IFNULL(Par_NumeroInstrumento, Entero_Cero);
		SET Par_Transaccion				:= IFNULL(Par_Transaccion, Entero_Cero);

		IF( Var_AutorizaTerceroTranTD = Con_SI AND Var_EjecucionCierreDia = Con_NO ) THEN

			IF( Par_TipoInstrumento = Inst_CuentaAhorro ) THEN
				SET Par_CuentaAhoID := Par_NumeroInstrumento;
			END IF;

			IF( Par_TipoInstrumento = Inst_Credito ) THEN
				SELECT 	CuentaID
				INTO 	Par_CuentaAhoID
				FROM CREDITOS
				WHERE CreditoID = Par_NumeroInstrumento;

				SET Par_CuentaAhoID := IFNULL(Par_CuentaAhoID, Entero_Cero);

				SELECT IFNULL(SaldoDispon, Decimal_Cero)
				INTO Par_MontoOperacion
				FROM CUENTASAHO
				WHERE CuentaAhoID = Par_CuentaAhoID;
			END IF;

			SET Par_CuentaAhoID	:= IFNULL(Par_CuentaAhoID, Entero_Cero);

			SELECT  TarjetaDebID
			INTO Par_TarjetaID
			FROM TARJETADEBITO
			WHERE CuentaAhoID = Par_CuentaAhoID
			  AND Estatus = Est_Activada
			ORDER BY FIELD(Relacion ,Tipo_Titular, Tipo_Adicional)
			LIMIT 1;

			IF( IFNULL(Par_TarjetaID, Cadena_Vacia) = Cadena_Vacia) THEN
				SET Par_NumErr	:= 	Entero_Cero;
				SET Par_ErrMen	:= 'Validacion de Tarjeta de Debito realizada Correctamente.';
				LEAVE ManejoErrores;
			END IF;

			SET Par_MontoOperacion		:= IFNULL(Par_MontoOperacion, Decimal_Cero);
			SET Par_OperacionPeticionID	:= IFNULL(Par_OperacionPeticionID, Entero_Cero);

			-- Valido la Peticion de Operacion
			IF( Par_OperacionPeticionID = Entero_Cero ) THEN
				SET Par_NumErr	:= 001;
				SET Par_ErrMen	:= 'El Operador de Peticion esta Vacio.';
				LEAVE ManejoErrores;
			END IF;

			SELECT	OperacionPeticionID
			INTO	Var_OperacionPeticionID
			FROM RELOPERAPETICIONISOTRX
			WHERE OperacionPeticionID = Par_OperacionPeticionID;

			-- Valido la Peticion de Operacion exista
			IF( IFNULL(Var_OperacionPeticionID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr	:= 002;
				SET Par_ErrMen	:= 'El Operador de Peticion no es Valido.';
				LEAVE ManejoErrores;
			END IF;

			-- Valido el Monto no sea Cero
			IF( Par_TipoInstrumento = Inst_CuentaAhorro AND  Par_MontoOperacion <= Decimal_Cero ) THEN
				SET Par_NumErr	:= 003;
				SET Par_ErrMen	:= 'La Monto de la Operacion no es Valido.';
				LEAVE ManejoErrores;
			END IF;

			IF( Par_Transaccion = Entero_Cero ) THEN
				SET Par_NumErr	:= 004;
				SET Par_ErrMen	:= 'La Monto de la Operacion no es Valido.';
				LEAVE ManejoErrores;
			END IF;

			SET Par_FechaOperacion	:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
			SELECT IFNULL(MAX(RegistroID), Entero_Cero) + Entero_Uno
			INTO Par_RegistroID
			FROM ISOTRXTARNOTIFICA
			WHERE FechaOperacion = Par_FechaOperacion
			FOR UPDATE;

			SET Par_HoraOperacion	:= TIME(NOW());
			SET Aud_FechaActual		:= NOW();
			SET Par_TipoTarjeta		:= Con_TarjetaDebito;

			INSERT INTO ISOTRXTARNOTIFICA (
				FechaOperacion,		RegistroID,					HoraOperacion,			TipoTarjeta,		TarjetaID,
				CuentaAhoID,		OperacionPeticionID,		Transaccion,			MontoOperacion,		Estatus,
				PIDTarea,			NumeroIntentos,
				EmpresaID,			Usuario,					FechaActual,			DireccionIP,		ProgramaID,
				Sucursal,			NumTransaccion)
			VALUES(
				Par_FechaOperacion,	Par_RegistroID,				Par_HoraOperacion,		Par_TipoTarjeta,	Par_TarjetaID,
				Par_CuentaAhoID,	Par_OperacionPeticionID,	Par_Transaccion,		Par_MontoOperacion,	Est_Pendiente,
				Cadena_Vacia,		Entero_Cero,
				Aud_EmpresaID,		Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,		Aud_NumTransaccion);

		END IF;

		SET Par_NumErr	:= 	Entero_Cero;
		SET Par_ErrMen	:= 'Registro de Operacion realizado Correctamente.';
		SET Var_Control	:= Cadena_Vacia;

	END ManejoErrores;
	-- Fin del manejador de errores.

	IF(Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control;
	END IF;

END TerminaStore$$