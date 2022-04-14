-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALSALDOSCONTABLESPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CALSALDOSCONTABLESPRO`;

DELIMITER $$
CREATE PROCEDURE `CALSALDOSCONTABLESPRO`(
	-- Store Procedure: De Proceso para calcular el saldo final de cada una de las cuentas contables por dia
	-- Modulo Contabilidad Financiera

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
	DECLARE Var_Control			VARCHAR(100);	-- Control de errores

	-- Declaracion de constantes
	DECLARE Cadena_Vacia	CHAR(1);		-- Constante Cadena Vacia
	DECLARE Entero_Cero		INT(11);		-- Constante Entero cero
	DECLARE Entero_Uno		INT(11);		-- Constante Entero Uno
	DECLARE Decimal_Cero	DECIMAL(12,2);	-- Constante Decimal cero
	DECLARE Salida_SI		CHAR(1);		-- Constante Salida SI
	DECLARE Salida_NO		CHAR(1);		-- Constante Salida NO

	DECLARE Fecha_Vacia		DATE;			-- Constante Fecha Vacia
	DECLARE Consecutivo		INT(11);		-- Numero de Consecutivo

	-- Asignacion de constantes
	SET Cadena_Vacia		:= '';
	SET Entero_Cero			:= 0;
	SET Entero_Uno			:= 1;
	SET Decimal_Cero		:= 0.0;
	SET Salida_SI			:= 'S';
	SET Salida_NO			:= 'N';

	SET Fecha_Vacia 		:= '1900-01-01';
	SET Consecutivo 		:= Entero_Cero;

	-- Bloque para manejar los posibles errores
	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									 'esto le ocasiona. Ref: SP-CALSALDOSCONTABLESPRO');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		DELETE FROM HISSALDOSDETPOLIZA;
		SET Aud_FechaActual := NOW();

		-- Insertando los saldos finales de las cuentas saldos en la tabla
		INSERT INTO HISSALDOSDETPOLIZA (
			Fecha,			CentroCostoID,		CuentaCompleta,		Cargos,				Abonos,
			EmpresaID,		Usuario,			FechaActual,		DireccionIP,		ProgramaID,
			Sucursal,		NumTransaccion)
		SELECT
			Fecha,			CentroCostoID,		CuentaCompleta,		SUM(IFNULL(Cargos, Entero_Cero)), SUM(IFNULL(Abonos, Entero_Cero)),
			Aud_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,	Aud_NumTransaccion
		FROM `HIS-DETALLEPOL`
		GROUP BY Fecha, CentroCostoID, CuentaCompleta;

		DELETE FROM SALDOSDETALLEPOLIZA;
		SET Aud_FechaActual := NOW();

		-- Insertando los saldos finales de las cuentas saldos en la tabla
		INSERT INTO SALDOSDETALLEPOLIZA(
			Fecha,			CentroCostoID,		CuentaCompleta,		Cargos,				Abonos,
			EmpresaID,		Usuario,			FechaActual,		DireccionIP,		ProgramaID,
			Sucursal,		NumTransaccion)
		SELECT
			Fecha,			CentroCostoID,		CuentaCompleta,		SUM(IFNULL(Cargos, Entero_Cero)), SUM(IFNULL(Abonos, Entero_Cero)),
			Aud_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,	Aud_NumTransaccion
		FROM DETALLEPOLIZA
		GROUP BY Fecha, CentroCostoID, CuentaCompleta;

		DELETE FROM SALDOSDETALLEPOLIZA WHERE Fecha = (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

		SET Par_NumErr	:= 	Entero_Cero;
		SET Par_ErrMen	:= 'Saldo de Detalle Poliza Agregada Correctamente.';
		SET Var_Control	:= '';

	END ManejoErrores;
	-- Fin del manejador de errores.

	IF(Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$