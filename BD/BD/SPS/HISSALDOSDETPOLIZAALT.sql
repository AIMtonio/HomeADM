-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISSALDOSDETPOLIZAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `HISSALDOSDETPOLIZAALT`;

DELIMITER $$
CREATE PROCEDURE `HISSALDOSDETPOLIZAALT`(
	-- Store Procedure: De Alta para los Detalles Historicos de las Polizas
	-- Modulo Contabilidad Financiera

	Par_EjercicioID			INT(11),		-- Numero de Ejercicio
	Par_PeriodoID			INT(11),		-- Numero de Periodo

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

	-- Declaracion de Variables
	DECLARE	Var_FechaInicio		DATE;			-- Fecha de Inicio del Periodo
	DECLARE	Var_FechaFin		DATE;			-- Fecha de Fin del Periodo
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

	-- Bloque para manejar los posibles errores
	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									 'esto le ocasiona. Ref: SP-HISSALDOSDETPOLIZAALT');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		-- Obtengo la Fecha Inicial y Final del Periodo
		SELECT	Inicio,				Fin
		INTO	Var_FechaInicio,	Var_FechaFin
		FROM PERIODOCONTABLE
		WHERE EjercicioID = Par_EjercicioID
		  AND PeriodoID = Par_PeriodoID;

		SET Var_FechaInicio	:= IFNULL(Var_FechaInicio, Fecha_Vacia);
		SET Var_FechaFin	:= IFNULL(Var_FechaFin, Fecha_Vacia);

		DELETE FROM HISSALDOSDETPOLIZA WHERE Fecha BETWEEN Var_FechaInicio AND Var_FechaFin;

		INSERT INTO HISSALDOSDETPOLIZA(
			Fecha,		CentroCostoID,	CuentaCompleta,	Cargos,			Abonos,
			EmpresaID,	Usuario,		FechaActual,	DireccionIP,	ProgramaID,
			Sucursal,	NumTransaccion)
		SELECT
			Fecha,		CentroCostoID,	CuentaCompleta,	Cargos,			Abonos,
			EmpresaID,	Usuario,		FechaActual,	DireccionIP,	ProgramaID,
			Sucursal,	NumTransaccion
		FROM SALDOSDETALLEPOLIZA
		WHERE Fecha BETWEEN Var_FechaInicio AND Var_FechaFin;

		DELETE FROM SALDOSDETALLEPOLIZA WHERE Fecha BETWEEN Var_FechaInicio AND Var_FechaFin;

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= 'Historico Detalle Polizas Agregado Exitosamente';
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