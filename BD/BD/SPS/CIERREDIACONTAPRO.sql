-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CIERREDIACONTAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CIERREDIACONTAPRO`;

DELIMITER $$
CREATE PROCEDURE `CIERREDIACONTAPRO`(

	-- SP de Cierre de dia de contabilidad
	Par_NumProceso		INT(11),		-- Numero de proceso.

	Par_Salida			CHAR(1),		-- Salida Si: S No:N
	INOUT Par_NumErr	INT(11),		-- Numero de error
	INOUT Par_ErrMen	varCHAR(400),	-- Mensaje de error

	Par_EmpresaID		INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario			INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual		DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP		VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID		VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal		INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion	BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
BEGIN

	-- Declaracion de variables
	DECLARE Var_FecActual		DATETIME;		-- Fecha Actual
	DECLARE Var_FecBitaco		DATETIME;		-- Fecha actual para los minutos de bitacora
	DECLARE Var_MinutosBit		INT(11);		-- Minutos

	-- Declaracion de constantes
	DECLARE ProcesoCierreDiaConta	INT(11);
	DECLARE SalidaSI				CHAR(1);
	DECLARE SalidaNO				CHAR(1);
	DECLARE Con_SI					CHAR(1);
	DECLARE Con_NO					CHAR(1);
	DECLARE Fecha_Vacia				DATE;
	DECLARE Entero_Cero				INT(11);
	DECLARE Cadena_Vacia			CHAR(1);

	-- Asignacion de constantes
	SET ProcesoCierreDiaConta	:= Par_NumProceso;	-- Proceso de cierre de dia contabilidad
	SET Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
	SET SalidaSI				:= 'S';				-- Salida SI
	SET SalidaNO				:= 'N';				-- Salida NO
	SET Con_SI					:= 'S';				-- Constante SI
	SET Con_NO					:= 'N';				-- Constante NO
	SET Entero_Cero				:= 0;				-- Entero Cero
	SET Cadena_Vacia			:= '';				-- Cadena Vacia

	ManejoErrores:BEGIN

		-- Asignacion de variables
		SET Var_FecBitaco := NOW();

		SELECT FechaSistema
		INTO Var_FecActual
		FROM PARAMETROSSIS;

		SET Var_FecActual := IFNULL(Var_FecActual,Fecha_Vacia);

		-- Eliminacion de registros en las tablas temporales
		DELETE FROM TMPCUENTACONTABLE;
		DELETE FROM TMPBALANZACONTA;
		DELETE FROM TMPSALCONTACENCOS;
		DELETE FROM TMPBALANZACENCOS;
		DELETE FROM TMPDETPOLCENCOS;
		DELETE FROM TMPEDOVARIACIONES;

		-- Se reinicia los valores para la balanza contable
		UPDATE PARAMGENERALES SET ValorParametro = Con_NO WHERE LlaveParametro = 'EjecucionBalanzaContable';
		UPDATE PARAMGENERALES SET ValorParametro = Cadena_Vacia WHERE LlaveParametro = 'UserEjecucionBalanzaContable';

		-- Se eliminan tablas temporales para los reportes de Circulo de Credito
		DELETE FROM TMPREPCIRCULO;
		DELETE FROM TMPREPCIRCULOPM;

		-- Se eliminan tabla temporal de la carga masiva de activos.
		DELETE FROM TMPACTIVOS;
		DELETE FROM TMPPREVIODEPREAMORTI;
		DELETE FROM TMPCATALOGOSACTIVOS;
		-- Se eliminan los Registros Temporales de los Creditos Consolidados Agro
		DELETE FROM CREDCONSOLIDAAGROGRID;

		-- Se eliminan los Registros Temporales del Proceso de Validacion de Activos
		DELETE FROM VALIDAOPEACTIVOS;

		-- Se eliminan los Registros de reversa en caso de que CS o Fabrica ajuste el proceso por fuera
		DELETE FROM TMPREVERSAPAGOCREDITO;

		SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());
		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := 'Cierre Dia Contabilidad Realizado';

		-- Bitacora Batch
		SET Aud_FechaActual := NOW();
		CALL BITACORABATCHALT(
			ProcesoCierreDiaConta, 	Var_FecActual,		Var_MinutosBit,		Par_EmpresaID,	Aud_Usuario,
			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN

		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Cadena_Vacia AS control,
				Entero_Cero AS consecutivo;

	END IF;

END$$