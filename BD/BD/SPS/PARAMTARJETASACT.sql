-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMTARJETASACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMTARJETASACT`;

DELIMITER $$
CREATE PROCEDURE `PARAMTARJETASACT`(
	-- Store Procedure de Actualizacion de los Parametros de Tarjetas
	Par_LlaveParametro		VARCHAR(50),		-- Llave de Tabla
	Par_ValorParametro		VARCHAR(200),		-- Valor del Parámentro

	Par_Salida				CHAR(1),			-- Parametro de Salida
	INOUT Par_NumErr		INT(11),			-- Parametro Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),		-- Parametro Mensaje de Error

	Aud_EmpresaID			INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_LlaveParametro				VARCHAR(50);	-- Variable Llave Parametro
	DECLARE Var_ValorParametro				VARCHAR(50);	-- Variable Valor Parametros
	DECLARE Var_Control						VARCHAR(100);	-- Variable de Control
	DECLARE Var_EsCierreDia					INT(11);		-- Es Cierre de Dia

	-- Declaracion de Constantes
	DECLARE	Entero_Cero						INT(11);		-- Entero Cero
	DECLARE Cadena_Vacia					CHAR(1);		-- Cadena Vacia
	DECLARE	SalidaSI						CHAR(1);		-- Salida SI
	DECLARE Con_SI							CHAR(1);		-- Constante SI
	DECLARE Con_NO 							CHAR(1);		-- Constante NO

	DECLARE Llave_NotificacionTarCierreDia 	VARCHAR(50);	-- Llave NotificacionCierreDia
	DECLARE Con_OperacionCierreDia			TINYINT UNSIGNED;	-- Tipo de Operacion Cierre de Día

	-- Asignacion de Constantes
	SET	Entero_Cero							:= 0;
	SET Cadena_Vacia						:= '';
	SET	SalidaSI							:= 'S';
	SET Con_SI								:= 'S';
	SET Con_NO 								:= 'N';

	SET Llave_NotificacionTarCierreDia		:= 'NotificacionTarCierreDia';
	SET Con_OperacionCierreDia				:= 20;
	SET Aud_FechaActual						:= NOW();

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-PARAMTARJETASACT');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		-- Validacion de la Llave de Parametro
		IF( IFNULL(Par_LlaveParametro, Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr  := 001;
			SET Par_ErrMen  := 'La Llave del Parametro no puede ser Vacia';
			SET Var_Control := 'llaveParametro';
			LEAVE ManejoErrores;
		END IF;

		SELECT LlaveParametro
		INTO Var_LlaveParametro
		FROM PARAMTARJETAS
		WHERE LLaveParametro = Par_LlaveParametro;

		IF( IFNULL(Var_LlaveParametro, Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr  := 002;
			SET Par_ErrMen  := 'La Llave del Parametro no Existe';
			SET Var_Control := 'llaveParametro';
			LEAVE ManejoErrores;
		END IF;

		-- Validacion del Valor del Parametro
		IF( IFNULL(Par_ValorParametro, Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr  := 003;
			SET Par_ErrMen  := 'El valor del Parametro no puede ser Vacio';
			SET Var_Control := 'valorParametro';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_LlaveParametro = Llave_NotificacionTarCierreDia ) THEN

			-- Se verifica que no existan registros por cierre de día-
			-- Si hay registros de cierre el valor cambia de "S", si no cambia a "N"
			-- Y si el valor del parametro de punto anterior es igual al actual realizo un leave debido a que no hay nada para actualizar

			SET Par_ValorParametro := Cadena_Vacia;

			SELECT IFNULL(COUNT(OperacionPeticionID), Entero_Cero)
			INTO Var_EsCierreDia
			FROM ISOTRXTARNOTIFICA
			WHERE OperacionPeticionID = Con_OperacionCierreDia;

			IF( Var_EsCierreDia > Entero_Cero ) THEN
				SET Par_ValorParametro := Con_SI;
			ELSE
				SET Par_ValorParametro := Con_NO;
			END IF;

			SELECT ValorParametro
			INTO Var_ValorParametro
			FROM PARAMTARJETAS
			WHERE LLaveParametro = Par_LlaveParametro;

			SET Var_ValorParametro := IFNULL(Var_ValorParametro ,Con_NO);

			IF( Par_ValorParametro = Var_ValorParametro ) THEN
				SET Par_NumErr  := Entero_Cero;
				SET Par_ErrMen  := 'Parametro Actualizado Correctamente.';
				SET Var_Control := 'llaveParametro';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		UPDATE PARAMTARJETAS SET
			ValorParametro 	= Par_ValorParametro,

			EmpresaID 		= Aud_EmpresaID,
			Usuario 		= Aud_Usuario,
			FechaActual 	= Aud_FechaActual,
			DireccionIP 	= Aud_DireccionIP,
			ProgramaID 		= Aud_ProgramaID,
			Sucursal 		= Aud_Sucursal,
			NumTransaccion 	= Aud_NumTransaccion
		WHERE LLaveParametro = Par_LlaveParametro;

		SET Par_NumErr  := Entero_Cero;
		SET Par_ErrMen  := 'Parametro Actualizado Correctamente.';
		SET Var_Control := 'llaveParametro';

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Entero_Cero AS consecutivo;
	END IF;

END TerminaStore$$