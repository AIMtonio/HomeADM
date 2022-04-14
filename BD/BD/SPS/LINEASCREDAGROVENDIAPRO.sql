-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LINEASCREDAGROVENDIAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `LINEASCREDAGROVENDIAPRO`;

DELIMITER $$
CREATE PROCEDURE `LINEASCREDAGROVENDIAPRO`(
	-- Store Procedure: Para cambiar el estatus vencido de las Lineas de Crédito Agro según su fecha de vecimiento
	-- Modulo Admon --> Procesos --> Cierre de Dia
	Par_Fecha				DATE,			-- Fecha a Procesar

	Par_Salida				CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr		INT(11),		-- Parametro Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Parametro Mensaje de Error

	Aud_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_Control		VARCHAR(100);	-- Control de errores

	-- Declaracion de constantes
	DECLARE Entero_Cero		INT(11);		-- Constante Entero cero
	DECLARE Cadena_Vacia	CHAR(1);		-- Constante Cadena Vacia
	DECLARE Salida_SI		CHAR(1);		-- Constante Salida SI
	DECLARE Salida_NO		CHAR(1);		-- Constante Salida NO
	DECLARE Est_Vencido		CHAR(1);		-- Constante estatus vencido

	DECLARE Es_Agro			CHAR(1);		-- Constante que si es Agro
	DECLARE Fecha_Vacia		DATE;			-- Constante Fecha Vacia

	-- Asignacion de constantes
	SET Entero_Cero			:= 0;
	SET Cadena_Vacia		:= '';
	SET Salida_SI			:= 'S';
	SET Salida_NO			:= 'N';
	SET Est_Vencido			:= 'E';

	SET Es_Agro				:= 'S';
	SET Fecha_Vacia			:= '1900-01-01';

	-- Bloquear para manejar los posibles errores
	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									 'esto le ocasiona. Ref: SP-LINEASCREDAGROVENDIAPRO');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		SET Par_Fecha := IFNULL(Par_Fecha, Fecha_Vacia) ;
		-- Validacion para la fecha
		IF( Par_Fecha = Fecha_Vacia ) THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:= 'La Fecha del Proceso esta Vacia.';
			SET Var_Control	:= 'fecha';
			LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual := NOW();
		UPDATE LINEASCREDITO SET
			Estatus			= Est_Vencido,

			Usuario			= Aud_Usuario,
			FechaActual		= Aud_FechaActual,
			DireccionIP		= Aud_DireccionIP,
			ProgramaID		= 'LINEASCREDAGROVENDIAPRO',
			Sucursal		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion
		WHERE FechaVencimiento <= Par_Fecha
		  AND EsAgropecuario = Es_Agro;

		SET Par_NumErr	:= 	Entero_Cero;
		SET Par_ErrMen	:= 'Lineas de Credito Modificados Correctamente.';
		SET Var_Control	:= 'lineaCreditoID';

	END ManejoErrores;
	-- Fin del manejador de errores.

	IF(Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control;
	END IF;

END TerminaStore$$