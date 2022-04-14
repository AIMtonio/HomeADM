-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ISOTRXREVTARNOTIFICAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS ISOTRXREVTARNOTIFICAPRO;

DELIMITER $$
CREATE PROCEDURE `ISOTRXREVTARNOTIFICAPRO`(
	-- Store Procedure: Proceso de Reversa en caso de fallo en la tarea de Notificacion de Saldos de Cuenta a ISOTRX
	-- Modulo Tarjetas de Debito - WS ISOTRX
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

	-- Declaracion de Variables
	DECLARE Var_Control						VARCHAR(100);	-- Variable de Retorno en Pantalla
	DECLARE Var_FechaOperacion				DATE;			-- Fecha de Operacion
	DECLARE Var_NumeroRegistros 			INT(11);		-- Numero de Registros
	DECLARE Var_RegistroID 					INT(11);		-- Numero de Registro
	DECLARE Var_Contador 					INT(11);		-- Numero de Contador

	DECLARE Var_PIDTarea					VARCHAR(50);	-- Numero de PID

	-- Declaracion de Constantes
	DECLARE Fecha_Vacia						DATE;			-- Constante de Fecha Vacia
	DECLARE Entero_Cero						INT(11);		-- Constante de Entero Cero
	DECLARE Entero_Uno						INT(11);		-- Constante Entero Uno
	DECLARE Con_TarjetaDebito				INT(11);		-- Tipo Tarjeta Debito
	DECLARE Con_NumErr						INT(11);		-- Constante Numero de Error

	DECLARE	Cadena_Vacia					CHAR(1);		-- Constante de Cadena Vacia
	DECLARE Salida_SI						CHAR(1);		-- Constante Salida SI
	DECLARE Salida_NO						CHAR(1);		-- Constante Salida NO
	DECLARE Est_Pendiente					CHAR(1);		-- Estatus Pendiente
	DECLARE Con_ErrMen						VARCHAR(400);	-- Constante Mensaje de Error

	-- Declaracion de Actualizaciones
	DECLARE Act_NumeroIntentos				TINYINT UNSIGNED;	-- Numero de Actualizacion 2

	-- Asignacion de Constantes
	SET Fecha_Vacia 						:= '1900-01-01';
	SET Entero_Cero 						:= 0;
	SET Entero_Uno							:= 1;
	SET Con_TarjetaDebito					:= 1;
	SET Con_NumErr 							:= 999;

	SET Cadena_Vacia						:= '';
	SET Salida_SI							:= 'S';
	SET Salida_NO							:= 'N';
	SET Est_Pendiente						:= 'P';
	SET Con_ErrMen 							:= "FALLO DE OPERACIONES, REVERSA MANUAL VIA BASE DE DATOS.";

	-- Asignacion de Actualizaciones
	SET Act_NumeroIntentos					:= 2;

	-- Bloque para manejar los posibles errores
	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que  ',
									 'esto le ocasiona. Ref: SP-ISOTRXREVTARNOTIFICAPRO');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

		CALL TRANSACCIONESPRO(Aud_NumTransaccion);
		SET Aud_EmpresaID 	:= IFNULL(Aud_EmpresaID, Entero_Uno);
		SET Aud_Usuario 	:= IFNULL(Aud_Usuario, Entero_Uno);
		SET Aud_FechaActual := IFNULL(Aud_FechaActual, NOW());
		SET Aud_DireccionIP := IFNULL(Aud_DireccionIP, '127.0.0.1');
		SET Aud_ProgramaID 	:= IFNULL(Aud_ProgramaID, 'SP-ISOTRXREVTARNOTIFICAPRO');
		SET Aud_Sucursal 	:= IFNULL(Aud_Sucursal, Entero_Uno);

		SELECT IFNULL(COUNT(PIDTarea), Entero_Cero)
		INTO Var_NumeroRegistros
		FROM ISOTRXTARNOTIFICA
		WHERE TipoTarjeta = Con_TarjetaDebito
		  AND Estatus = Est_Pendiente
		  AND PIDTarea <> Cadena_Vacia;

		IF( Var_NumeroRegistros > Entero_Cero) THEN

			DELETE FROM TMPISOTRXTARNOTIFICA WHERE NumTransaccion = Aud_NumTransaccion;

			SET @Consecutivo := Entero_Cero;
			INSERT INTO TMPISOTRXTARNOTIFICA (
				Consecutivo,
				FechaOperacion,		RegistroID,			PIDTarea,		EmpresaID,		Usuario,
				FechaActual,		DireccionIP,		ProgramaID,		Sucursal,		NumTransaccion)
			SELECT
				@Consecutivo := @Consecutivo +Entero_Uno,
				FechaOperacion,		RegistroID,			PIDTarea,		Aud_EmpresaID,	Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion
			FROM ISOTRXTARNOTIFICA
			WHERE TipoTarjeta = Con_TarjetaDebito
			  AND Estatus = Est_Pendiente
			  AND PIDTarea <> Cadena_Vacia;

			SET Var_NumeroRegistros := Entero_Cero;

			SELECT	IFNULL(MAX(Consecutivo), Entero_Cero)
			INTO 	Var_NumeroRegistros
			FROM TMPISOTRXTARNOTIFICA
			WHERE NumTransaccion = Aud_NumTransaccion;

			SET Var_FechaOperacion	:= Fecha_Vacia;
			SET Var_RegistroID		:= Entero_Cero;
			SET Var_PIDTarea		:= Cadena_Vacia;
			SET Var_Contador 		:= Entero_Uno;

			WHILE ( Var_Contador <= Var_NumeroRegistros ) DO

				SELECT FechaOperacion,		RegistroID,			PIDTarea
				INTO Var_FechaOperacion,	Var_RegistroID,		Var_PIDTarea
				FROM TMPISOTRXTARNOTIFICA
				WHERE Consecutivo = Var_Contador
				  AND NumTransaccion = Aud_NumTransaccion;

				SET Aud_FechaActual	:= NOW();

				-- Actualizo el Registro
				CALL ISOTRXTARNOTIFICAACT (
					Var_FechaOperacion,		Var_RegistroID,			Var_PIDTarea,		Con_NumErr,			Con_ErrMen,
					Aud_NumTransaccion,		Act_NumeroIntentos,		Salida_NO,			Par_NumErr,			Par_ErrMen,
					Aud_EmpresaID,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
					Aud_Sucursal,			Aud_NumTransaccion);

				IF( Par_NumErr <> Entero_Cero ) THEN
					LEAVE ManejoErrores;
				END IF;

				SET Var_FechaOperacion	:= Fecha_Vacia;
				SET Var_RegistroID		:= Entero_Cero;
				SET Var_PIDTarea		:= Cadena_Vacia;
				SET Var_Contador 		:= Var_Contador + Entero_Uno;

			END WHILE;
		END IF;

		DELETE FROM TMPISOTRXTARNOTIFICA WHERE NumTransaccion = Aud_NumTransaccion;

		SET Par_NumErr	:= 	Entero_Cero;
		SET Par_ErrMen	:= CONCAT('Reversa de Operaciones realizada Correctamente\nNumero de Registros Procesados : ',Var_NumeroRegistros , '.');
		SET Var_Control	:= Cadena_Vacia;

	END ManejoErrores;
	-- Fin del manejador de errores.

	IF(Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control;
	END IF;

END TerminaStore$$