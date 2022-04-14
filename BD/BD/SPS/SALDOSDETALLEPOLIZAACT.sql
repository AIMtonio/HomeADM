-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SALDOSDETALLEPOLIZAACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SALDOSDETALLEPOLIZAACT`;

DELIMITER $$
CREATE PROCEDURE `SALDOSDETALLEPOLIZAACT`(
	-- Store Procedure: De Actualizacion de saldos de detalle poliza para los cosos deonde se agrege de
	-- manera maual de una poliza contable
	-- Modulo Contabilidad Financiera

	Par_Fecha				DATE,			-- Fecha Actualizacion
	Par_CentroCostoID		INT(11),		-- ID del centro de costos
	Par_CuentaCompleta		VARCHAR(50),	-- Cuenta completa
	Par_Cargos				DECIMAL(18,4),	-- Cargo aplicado
	Par_Abonos				DECIMAL(18,4),	-- Abono aplicado

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

	-- Declaracion de Constantes
	DECLARE Var_SaldoDetPolizaID	BIGINT(20) UNSIGNED;		-- Validador
	DECLARE Var_Control			VARCHAR(100);	-- Control de errores

	-- Declaracion de constantes
	DECLARE Cadena_Vacia	CHAR(1);		-- Constante Cadena Vacia
	DECLARE Entero_Cero		INT(11);		-- Constante Entero cero
	DECLARE Decimal_Cero	DECIMAL(12,2);	-- Constante Decimal cero
	DECLARE Salida_SI		CHAR(1);		-- Constante Salida SI
	DECLARE Salida_NO		CHAR(1);		-- Constante Salida NO

	DECLARE Fecha_Vacia		DATE;			-- Constante Fecha Vacia
	DECLARE Consecutivo		INT(11);		-- Numero de Consecutivo

	-- Asignacion de constantes
	SET Cadena_Vacia		:= '';
	SET Entero_Cero			:= 0;
	SET Decimal_Cero		:= 0.0;
	SET Salida_SI			:= 'S';
	SET Salida_NO			:= 'N';

	SET Fecha_Vacia 		:= '1900-01-01';
	SET Consecutivo 		:= Entero_Cero;

	-- Seteo de Parametros
	SET Par_Cargos			:= IFNULL(Par_Cargos, Entero_Cero);
	SET Par_Abonos			:= IFNULL(Par_Abonos, Entero_Cero);

	-- Bloque para manejar los posibles errores
	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									 'esto le ocasiona. Ref: SP-SALDOSDETALLEPOLIZAACT');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		SET Var_SaldoDetPolizaID	:= (SELECT SaldoDetallePolizaID
										FROM SALDOSDETALLEPOLIZA
										WHERE Fecha = Par_Fecha
										  AND CentroCostoID  = Par_CentroCostoID
										  AND CuentaCompleta = Par_CuentaCompleta LIMIT 1);

		SET Var_SaldoDetPolizaID	:= IFNULL(Var_SaldoDetPolizaID, Entero_Cero);

		-- Si existe el ID se actualiza el Monto
		IF( Var_SaldoDetPolizaID <> Entero_Cero ) THEN

			SET Aud_FechaActual 	:= NOW();

			UPDATE SALDOSDETALLEPOLIZA SET
				Cargos			= Cargos + Par_Cargos,
				Abonos			= Abonos + Par_Abonos,

				EmpresaID		= Aud_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE SaldoDetallePolizaID = Var_SaldoDetPolizaID;

		END IF;

		-- NO existe el ID se Registra el Monto en la cuenta Contable
		IF( Var_SaldoDetPolizaID = Entero_Cero ) THEN

			CALL SALDOSDETPOLIZAALT(
				Par_Fecha,			Par_CentroCostoID,	Par_CuentaCompleta,	Par_Cargos,		Par_Abonos,
				Par_Salida,			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,	Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

			IF( Par_NumErr <> Entero_Cero ) THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SET Par_NumErr	:= 	Entero_Cero;
		SET Par_ErrMen	:= 'Saldo de Detalle Poliza Actualizado Correctamente.';
		SET Var_Control	:= 'saldosDetPolID';

	END ManejoErrores;
	-- Fin del manejador de errores.

	IF(Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$