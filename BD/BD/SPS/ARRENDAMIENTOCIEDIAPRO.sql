-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARRENDAMIENTOCIEDIAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `ARRENDAMIENTOCIEDIAPRO`;DELIMITER $$

CREATE PROCEDURE `ARRENDAMIENTOCIEDIAPRO`(
# =====================================================================================
# -- STORED PROCEDURE PARA EL CIERRE DE DIA DE ARRENDAMIENTO
# =====================================================================================
	Par_Fecha				DATE,				-- Fecha del cierre de dia.

	Par_Salida				CHAR(1),			-- Parametro que indica si el procedimiento devuelve una salida
	INOUT Par_NumErr		INT(11),			-- Parametro que corresponde a un numero de exito o error
	INOUT Par_ErrMen		VARCHAR(400),		-- Parametro que corresponde a un mensaje de exito o error

	Par_EmpresaID			INT(11),			-- Parametros de Auditoria
	Aud_Usuario				INT(11),			-- Parametros de Auditoria
	Aud_FechaActual			DATETIME,			-- Parametros de Auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametros de Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametros de Auditoria
	Aud_Sucursal			INT(11),			-- Parametros de Auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametros de Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(100);	-- Variable de control
	DECLARE Var_FechaBatch			DATE;			-- Fecha del procedo batch
	DECLARE	Var_MinProBatch			INT;			-- Tiempo en minutos que duro el proceso

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia			CHAR(1);		-- Cadena Vacia
	DECLARE	Fecha_Vacia				DATE;			-- Fecha Vacia
	DECLARE	Entero_Cero				INT(11);		-- Entero cero
	DECLARE Salida_Si				CHAR(1);		-- Indica que si se devuelve un mensaje de salida
	DECLARE Salida_No				CHAR(1);		-- Indica que no se devuelve un mensaje de salida
	DECLARE Decimal_Cero    		DECIMAL(14,2);	-- Decimal 0

	DECLARE Var_DesCieDia			VARCHAR(50);	-- Descripcion del cierre de dia
	DECLARE	Var_CieDiaArrenda		INT(11);		-- ID del Proceso Batch para cierre diario de arrendamieno
	DECLARE	Var_MoraComCarArrend	INT(11);		-- ID del Proceso Batch para el sp: GENERAINTERMORACOMARRENDAPRO
	DECLARE	Var_PasoVenArrenda		INT(11);		-- ID del Proceso Batch para el sp: ARRENDAPASOVENCIDOPRO

	-- Asignacion de constantes
	SET	Cadena_Vacia			:= '';								-- Valor de cadena vacia
	SET	Fecha_Vacia				:= '1900-01-01';					-- Valor de fecha vacia.
	SET	Entero_Cero				:= 0;								-- Valor de entero cero.
	SET Salida_Si				:= 'S';      						-- Si se devuelve una salida Si
	SET Salida_No				:= 'N';      						-- NO se devuelve una salida No
	SET	Decimal_Cero			:= 0.0;								-- Valor de decimal cero.

	SET Var_DesCieDia			:= 'CIERRE DIARIO ARRENDAMIENTO';	-- Descripcion cierre
	SET	Var_CieDiaArrenda 		:= 9004;							-- ID de proceso para CIERRE DIARIO ARRENDAMIENTO, tabla: PROCESOSBATCH
	SET	Var_MoraComCarArrend	:= 9005;							-- ID de proceso para COMISIONES,INTERESES MORATORIOS Y TRASPASO A CARTERA DE ARRENDAMIENTO, tabla: PROCESOSBATCH
	SET	Var_PasoVenArrenda		:= 9006;							-- ID de proceso para TRASPASO A CARTERA VENCIDA DE ARRENDAMIENTO, tabla: PROCESOSBATCH

	-- Valores por default si son nulos
	SET Par_Fecha			:= IFNULL(Par_Fecha,Fecha_Vacia);
	SET Var_Control			:= IFNULL(Var_Control,Cadena_Vacia);

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									 'Disculpe las molestias que esto le ocasiona. REF: ARRENDAMIENTOCIEDIAPRO');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		-- Se verifica si el proceso ya se ejecuto para la fecha requerida.
		SELECT	Fecha
		  INTO	Var_FechaBatch
			FROM BITACORABATCH
			WHERE	Fecha 			= Par_Fecha
			  AND	ProcesoBatchID	= Var_CieDiaArrenda;

		SET Var_FechaBatch := IFNULL(Var_FechaBatch, Fecha_Vacia);

		IF Var_FechaBatch != Fecha_Vacia THEN
			LEAVE TerminaStore;
		END IF;

		SET Var_MinProBatch := Entero_Cero;

		-- Se registra el cierre de dia de arrendamiento en la bitacora.
		CALL BITACORABATCHALT(Var_CieDiaArrenda, 	Par_Fecha, 			Var_MinProBatch,	Par_EmpresaID,		Aud_Usuario,
							  Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		-- Llamado al sp para el calculo de Comisiones, Intereses moratorios devengados y traspaso a cartera y cambio de saldo capital e interes capital.
		CALL GENERAINTERMORACOMARRENDAPRO(Par_Fecha,	Salida_No,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
										  Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
										  Aud_NumTransaccion);

		-- Se registra en la bitacora batch
		CALL BITACORABATCHALT(Var_MoraComCarArrend, 	Par_Fecha, 			Var_MinProBatch,	Par_EmpresaID,		Aud_Usuario,
							  Aud_FechaActual,			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);


		-- Se llama al sp: ARRENDAPASOVENCIDOPRO, para el traspaso a cartera vencida de los arrendamientos
		CALL ARRENDAPASOVENCIDOPRO(Par_Fecha,		Salida_No,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
								   Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
								   Aud_NumTransaccion);

		-- Se registra en la bitacora batch
		CALL BITACORABATCHALT(Var_PasoVenArrenda, 	Par_Fecha, 			Var_MinProBatch,	Par_EmpresaID,		Aud_Usuario,
							  Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);


	END ManejoErrores;
	-- Si Par_Salida = S (SI)
	IF (Par_Salida = Salida_Si) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control;
	END IF;

	-- Fin del SP
END TerminaStore$$