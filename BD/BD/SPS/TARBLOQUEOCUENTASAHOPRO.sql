-- TARBLOQUEOCUENTASAHOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS TARBLOQUEOCUENTASAHOPRO;
DELIMITER $$

CREATE PROCEDURE TARBLOQUEOCUENTASAHOPRO(
	-- SP para el proceso de bloqueo masivo de cuentas de ahorro
	Par_PIDTarea			VARCHAR(50),		-- Identificador de la tarea en ejecucion

	Par_Salida				CHAR(1),			-- Salida S:Si No:No
	INOUT Par_NumErr		INT(11),			-- Numero de error
	INOUT Par_ErrMen		VARCHAR(400),		-- Mensaje de error

	Par_EmpresaID			INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria Fecha actual
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)  		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_LlaveParametro		VARCHAR(50);		-- Llave del parametro generales
	DECLARE Var_ValorParametro		INT(11);			-- Valor del parametro que se obtiene de parametros generales
	DECLARE Var_FechaSistema		DATE;				-- Almacena la fecha actual del sistema
	DECLARE Var_Contador 			INT(11);			-- Contador para el ciclo
	DECLARE Var_NumRegistro			INT(11);			-- Numero de registros
	DECLARE Var_CuentaAhoID			BIGINT(12);			-- Identificador de la cuenta de ahorro
	DECLARE	Var_FechaMovs			DATE;				-- Almacena la fecha maxima historica
	DECLARE Var_Fecha				DATE;				-- Almacena la fecha final del cual se convierte con los parametros en dias
	DECLARE Var_Motivo				VARCHAR(50);		-- Variable para almacenar el motivo del bloqueo
	DECLARE Var_Control				VARCHAR(100);		-- Variable de control
	DECLARE Var_LlaveParamTarUsu	VARCHAR(50);		-- Llave del parametro del usuario que realiza el bloqueo de cuentas
	DECLARE Var_TarUsuarioBloq		INT(11);			-- Usuario que realiza el bloqueo de cuentas

	-- Declaracion de constantes
	DECLARE Entero_Uno				INT(11);			-- Lista principal todas las cuentas
	DECLARE	Estatus_Activa			CHAR(1);			-- Estatus activo de cuentas de ahorro
	DECLARE Entero_Cero				INT(11);			-- Constante Entero Cero
	DECLARE Fecha_Vacia				DATE;				-- Constante de fecha vacia
	DECLARE Con_No					CHAR(1);			-- Constante no
	DECLARE	SalidaNO				CHAR(1);			-- Salida si
	DECLARE	SalidaSI				CHAR(1);			-- Constante de Salida no
	DECLARE Con_MovComison			INT(11);			-- Movimiento de Comisión
	DECLARE Con_MovISR				INT(11);			-- Movimiento de ISR
	DECLARE Con_MovIntereses		INT(11);			-- Movimiento de Intereses
	DECLARE Con_Inversiones			INT(11);			-- Cuentas de inversiones
	DECLARE Con_Credito				INT(11);			-- Cuentas de credito
	DECLARE Con_Cedes				INT(11);			-- Cuentas de cedes
	DECLARE Con_Aportaciones		INT(11);			-- Cuentas de aportaciones
	DECLARE	Est_VigenteCred			CHAR(1);			-- Estatus vigente
	DECLARE Est_Vencido				CHAR(1);			-- Estatus vencido
	DECLARE Est_Castigado			CHAR(1);			-- Estatus castigado
	DECLARE Esta_Vigente			CHAR(1);			-- Estatus vigente (CEDES, INVERSIONES, APORTACIONES)
	DECLARE Esta_VencidoInver		CHAR(1);			-- Estatus vencido inversiones

	-- Asignacion de constantes
	SET Entero_Uno					:= 1;
	SET Var_LlaveParametro			:= 'TarDiasBloqueoCuentas';
	SET Var_LlaveParamTarUsu		:= 'TarUsuarioBloqueoCtaID';
	SET Estatus_Activa				:= 'A';
	SET Entero_Cero					:= 0;
	SET	Fecha_Vacia					:= '1900-01-01';
	SET Var_Motivo					:= 'Bloqueo por inactividad';
	SET Con_No						:= 'N';
	SET	SalidaSI					:= 'S';
	SET	SalidaNO					:= 'N';
	SET Est_VigenteCred				:= 'V';
	SET Est_Vencido					:= 'B';
	SET Est_Castigado				:= 'K';
	SET Esta_Vigente				:= 'N';
	SET Esta_VencidoInver			:= 'V';
	SET Con_MovComison				:= 2;
	SET Con_MovISR					:= 4;
	SET Con_MovIntereses			:= 7;
	SET Con_Inversiones				:= 2;
	SET Con_Credito					:= 4;
	SET Con_Cedes					:= 3;
	SET Con_Aportaciones			:= 6;
	SET Aud_NumTransaccion			:= IFNULL(Aud_NumTransaccion, Entero_Cero);
	SET Var_FechaSistema			:= (SELECT FechaSistema FROM PARAMETROSSIS);
	SET Aud_FechaActual				:= NOW();

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-TARBLOQUEOCUENTASAHOPRO');
			SET Var_Control := 'SQLEXCEPTION' ;
		END;

		SELECT CAST(ValorParametro AS UNSIGNED)
		INTO Var_ValorParametro
		FROM PARAMGENERALES
		WHERE LlaveParametro = Var_LlaveParametro;

		SELECT CAST(ValorParametro AS UNSIGNED)
		INTO Var_TarUsuarioBloq
		FROM PARAMGENERALES
		WHERE LlaveParametro = Var_LlaveParamTarUsu;

		-- Se resta la fecha del sistema menos los dias parametrizado
		SET Var_Fecha := (Var_FechaSistema -INTERVAL Var_ValorParametro DAY);

		-- Se excluyen todas aquellas cuentas que tengan algún producto activo ligado (Inversion, Credito, Certificado, Aportacion)
		-- Los movimientos de Pago de Rendimientos, Retenciones y comisiones no se deberán tomar en cuenta
		SET @ConsecutivoID := 0;
		INSERT TMPBLOQUEOCUENTASAHO (BloqueoCuentasAhoID,	CuentaAhoID,		Fecha,										PIDTarea,
									UsuarioBloID,			FechaBloqueo,		FechaActual,								ProgramaID,
									NumTransaccion)
		SELECT	(@ConsecutivoID := @ConsecutivoID +1),		Aho.CuentaAhoID,	IFNULL(MAX(Movs.Fecha),Aho.FechaApertura),	Par_PIDTarea,
				Var_TarUsuarioBloq,							Var_FechaSistema,	Aud_FechaActual,							Aud_ProgramaID,
				Aud_NumTransaccion
		FROM CUENTASAHO Aho
		LEFT JOIN CUENTASAHOMOV Movs ON Aho.CuentaAhoID = Movs.CuentaAhoID
		LEFT OUTER JOIN TIPOSMOVSAHO Tipos ON Movs.TipoMovAhoID = Tipos.TipoMovAhoID AND (Tipos.ClasificacionMov) NOT IN(Con_MovComison, Con_MovISR, Con_MovIntereses)
		WHERE Aho.Estatus = Estatus_Activa
			AND Aho.Saldo = 0
		GROUP BY CuentaAhoID;

		-- Se borran registros de la tabla con fecha mayor a la de parametro
		DELETE FROM TMPBLOQUEOCUENTASAHO WHERE Fecha > Var_Fecha;

		-- SE BORRAN CUENTAS QUE TENGAN PRODUCTOS ACTIVOS
		-- CREDITOS VIGENTES Y VENCIDOS
		DELETE Tmp
		FROM TMPBLOQUEOCUENTASAHO Tmp
			INNER JOIN CREDITOS Cre ON Tmp.CuentaAhoID = Cre.CuentaID
		WHERE Cre.Estatus IN(Est_VigenteCred, Est_Vencido)
			AND Tmp.NumTransaccion = Aud_NumTransaccion;

		-- SE BORRAN CUENTAS QUE TENGAN PRODUCTOS ACTIVOS
		-- CEDES VIGENTES
		DELETE Tmp
		FROM TMPBLOQUEOCUENTASAHO Tmp
			INNER JOIN CEDES Ced ON Tmp.CuentaAhoID = Ced.CuentaAhoID
		WHERE Ced.Estatus IN(Esta_Vigente)
			AND Tmp.NumTransaccion = Aud_NumTransaccion;

		-- SE BORRAN CUENTAS QUE TENGAN PRODUCTOS ACTIVOS
		-- INVERSIONES VIGENTES Y VENCIDOS
		DELETE Tmp
		FROM TMPBLOQUEOCUENTASAHO Tmp
			INNER JOIN INVERSIONES Inver ON Tmp.CuentaAhoID = Inver.CuentaAhoID
		WHERE Inver.Estatus IN(Esta_Vigente, Esta_VencidoInver)
			AND Tmp.NumTransaccion = Aud_NumTransaccion;

		-- SE BORRAN CUENTAS QUE TENGAN PRODUCTOS ACTIVOS
		-- APORTACIONES VIGENTES
		DELETE Tmp
		FROM TMPBLOQUEOCUENTASAHO Tmp
		INNER JOIN APORTACIONES Apor ON Tmp.CuentaAhoID = Apor.CuentaAhoID
		WHERE Apor.Estatus IN(Esta_Vigente)
			AND Tmp.NumTransaccion = Aud_NumTransaccion;

		INSERT INTO TMPMAXIMAFECHAAHOMOVS (CuentaAhoID,	FechaMaxima,	NumTransaccion)
		SELECT His.CuentaAhoID, MAX(His.Fecha), Aud_NumTransaccion
		FROM `HIS-CUENAHOMOV` His
		INNER JOIN TMPBLOQUEOCUENTASAHO Tmp ON His.CuentaAhoID = Tmp.CuentaAhoID
		LEFT OUTER JOIN TIPOSMOVSAHO Tipos ON His.TipoMovAhoID = Tipos.TipoMovAhoID AND (Tipos.ClasificacionMov) NOT IN(Con_MovComison, Con_MovISR, Con_MovIntereses)
		GROUP BY CuentaAhoID;

		UPDATE TMPBLOQUEOCUENTASAHO TmpBloqueo
		INNER JOIN TMPMAXIMAFECHAAHOMOVS TempFecha ON TmpBloqueo.CuentaAhoID = TempFecha.CuentaAhoID
			SET
				TmpBloqueo.Fecha = TempFecha.FechaMaxima
		WHERE TmpBloqueo.Fecha < TempFecha.FechaMaxima;

		-- Se borran registros de la tabla con fecha mayor a la de parametro
		DELETE FROM TMPBLOQUEOCUENTASAHO WHERE Fecha > Var_Fecha;

		-- SP PARA ACTUALIZACION DE BLOQUEOS MASIVOS DE CUENTAS DE AHORRO
		CALL TARBLOQUEOCUENTASAHOACT(	Entero_Cero,		Var_TarUsuarioBloq,	Var_FechaSistema,	Var_Motivo,		Entero_Uno,
										Con_No,				Par_NumErr,			Par_ErrMen,			Par_EmpresaID,	Aud_Usuario,
										Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion
									);
		IF(Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr	:= 000;
		SET Par_ErrMen	:= 'Proceso de Bloqueo de Cuentas Realizado Exitosamente';
		SET Var_Control	:= 'cuentaAhoID' ;

	END ManejoErrores;

	-- Se borran la tabla temporal
	DELETE FROM TMPBLOQUEOCUENTASAHO WHERE NumTransaccion = Aud_NumTransaccion;
	DELETE FROM TMPMAXIMAFECHAAHOMOVS WHERE NumTransaccion = Aud_NumTransaccion;

	IF (Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr 		AS NumErr,
				Par_ErrMen 		AS ErrMen,
				Var_Control 	AS control;
	END IF;

END TerminaStore$$