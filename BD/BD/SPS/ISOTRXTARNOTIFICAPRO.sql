-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ISOTRXTARNOTIFICAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS ISOTRXTARNOTIFICAPRO;

DELIMITER $$
CREATE PROCEDURE `ISOTRXTARNOTIFICAPRO`(
	-- Store Procedure: Alta de Cierre de Dia para el proceso de Notificacion de Saldos de Cuenta a ISOTRX
	-- Modulo Tarjetas de Debito - WS ISOTRX
	Par_FechaOperacion		DATE,			-- Es la fecha del sistema con la que se realizó el cierre de dia

	Par_Salida				CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr		INT(11),		-- Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Mensaje de Error

	Aud_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Paramentros
	DECLARE Par_RegistroID					INT(11);		-- Numero de Registro

	-- Declaracion de Variables
	DECLARE Var_Control						VARCHAR(100);	-- Variable de Retorno en Pantalla
	DECLARE Var_AutorizaTerceroTranTD		VARCHAR(200);	-- Variable para almacenar el valor del campo AutorizaTerceroTranTD
	DECLARE Var_FechaBitacora				DATETIME;		-- Fecha de Bitacora
	DECLARE Var_MinutosBitacora 			INT(11);		-- Minutos de Bitacora

	-- Declaracion de Constantes
	DECLARE Entero_Cero						INT(11);		-- Constante de Entero Cero
	DECLARE Entero_Uno						INT(11);		-- Constante Entero Uno
	DECLARE Con_TarjetaDebito				INT(11);		-- Tipo Tarjeta Debito
	DECLARE Est_Activada					INT(11);		-- Constante Estatus Activada
	DECLARE Pro_Isotrx						INT(11);		-- Constante Proceso ISOTRX
	DECLARE Decimal_Cero					DECIMAL(14,2);	-- Constante de Decimal Cero

	DECLARE Fecha_Vacia						DATE;			-- Constante de Fecha Vacia
	DECLARE	Cadena_Vacia					CHAR(1);		-- Constante de Cadena Vacia
	DECLARE Salida_SI						CHAR(1);		-- Constante Salida SI
	DECLARE Con_SI							CHAR(1);		-- Constante SI
	DECLARE Con_NO 							CHAR(1);		-- Constante NO

	DECLARE Est_Pendiente					CHAR(1);		-- Estatus Registrado
	DECLARE Llave_AutorizaTerceroTranTD		VARCHAR(50);	-- Llave AutorizaTerceroTranTD
	DECLARE Llave_NotificacionTarCierreDia 	VARCHAR(50);	-- Llave NotificacionCierreDia
	DECLARE Con_ProcesoCierreDia			TINYINT UNSIGNED;-- Proceso de Cierre

	-- Asignacion de Constantes
	SET Entero_Cero 						:= 0;
	SET Entero_Uno							:= 1;
	SET Con_TarjetaDebito					:= 1;
	SET Est_Activada						:= 7;
	SET Pro_Isotrx							:= 9015;
	SET Decimal_Cero						:= 0.00;

	SET Fecha_Vacia 						:= '1900-01-01';
	SET Cadena_Vacia						:= '';
	SET Salida_SI							:= 'S';
	SET Con_SI								:= 'S';
	SET Con_NO 								:= 'N';

	SET Est_Pendiente						:= 'P';
	SET Llave_AutorizaTerceroTranTD			:= 'AutorizaTerceroTranTD';
	SET Llave_NotificacionTarCierreDia		:= 'NotificacionTarCierreDia';
	SET Con_ProcesoCierreDia				:= 20;
	SET Var_Control							:= Cadena_Vacia;
	SET Var_FechaBitacora					:= NOW();

	-- Bloque para manejar los posibles errores
	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que  ',
									 'esto le ocasiona. Ref: SP-ISOTRXTARNOTIFICAPRO');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

		SET Var_AutorizaTerceroTranTD	:= IFNULL( FNPARAMTARJETAS(Llave_AutorizaTerceroTranTD), Con_NO);

		IF( Var_AutorizaTerceroTranTD = Con_SI ) THEN

			-- Validacion para la Fecha de Operacion
			IF( IFNULL(Par_FechaOperacion, Fecha_Vacia) = Fecha_Vacia ) THEN
				SET Par_NumErr	:= 001;
				SET Par_ErrMen	:= 'La Fecha de Operacion esta Vacia';
				LEAVE ManejoErrores;
			END IF;

			SELECT IFNULL(MAX(RegistroID), Entero_Cero)
			INTO Par_RegistroID
			FROM ISOTRXTARNOTIFICA
			WHERE FechaOperacion = Par_FechaOperacion;

			SET @Consecutivo := Par_RegistroID;

			INSERT INTO ISOTRXTARNOTIFICA (
				FechaOperacion,			RegistroID,
				HoraOperacion,			TipoTarjeta,			TarjetaID,
				CuentaAhoID,			OperacionPeticionID,	Transaccion,			MontoOperacion,
				Estatus,				PIDTarea,				NumeroIntentos,
				EmpresaID,				Usuario,				FechaActual,			DireccionIP,
				ProgramaID,				Sucursal,				NumTransaccion)
			SELECT
				Par_FechaOperacion,	(@Consecutivo:=@Consecutivo+Entero_Uno),
				TIME(NOW()),			Con_TarjetaDebito,		Tar.TarjetaDebID,
				Tar.CuentaAhoID,		Con_ProcesoCierreDia,	Aud_NumTransaccion,		IFNULL(Cue.SaldoDispon, Decimal_Cero),
				Est_Pendiente,			Cadena_Vacia,			Entero_Cero,
				Aud_EmpresaID,			Aud_Usuario,			NOW(),					Aud_DireccionIP,
				Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion
			FROM TARJETADEBITO Tar
			INNER JOIN CUENTASAHO Cue ON Tar.CuentaAhoID = Cue.CuentaAhoID
			WHERE Tar.Estatus = Est_Activada;

			-- actualizar parametro que indica que se estan notificando los saldos al cierre de día
			UPDATE PARAMTARJETAS SET
				ValorParametro = Con_SI
			WHERE LlaveParametro = Llave_NotificacionTarCierreDia;

		END IF;

		SET Var_MinutosBitacora := TIMESTAMPDIFF(MINUTE, Var_FechaBitacora, NOW());

		CALL BITACORABATCHALT(
			Pro_Isotrx,			Par_FechaOperacion,	Var_MinutosBitacora,	Aud_EmpresaID,	Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,	Aud_NumTransaccion);

		SET Par_NumErr	:= 	Entero_Cero;
		SET Par_ErrMen	:= 'Registro de Cierre de Dia realizado Correctamente.';
		SET Var_Control	:= Cadena_Vacia;

	END ManejoErrores;
	-- Fin del manejador de errores.

	IF(Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control;
	END IF;

END TerminaStore$$