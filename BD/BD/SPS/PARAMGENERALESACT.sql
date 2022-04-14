-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMGENERALESACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMGENERALESACT`;DELIMITER $$

CREATE PROCEDURE `PARAMGENERALESACT`(
# =========================================================================
# ------- STORE PARA ACTUALIZAR VALORES EN LA TABLA PARAMGENERALES---------
# =========================================================================
	Par_NumActualiza		INT(11),

	Par_Salida				CHAR(1),
    INOUT Par_NumErr		INT(11),
    INOUT Par_ErrMen		VARCHAR(400),

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
	)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_ValorParametro   CHAR(1);
	DECLARE Var_Control          VARCHAR(100);
	DECLARE Var_PagoRefere		CHAR(1);
	DECLARE Var_ValorParametroRef	CHAR(1);

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE	Entero_Cero			INT(11);
	DECLARE	SalidaSI			CHAR(1);
	DECLARE	ActCobAutomaticaSI	INT(11);
	DECLARE	ActCobAutomaticaNO	INT(11);
	DECLARE	ActCobAutRefeSI		INT(11);
	DECLARE	ActCobAutRefeNO		INT(11);
	DECLARE	ActProcesoCedeSI	INT(11);
	DECLARE	ActProcesoCedeNO	INT(11);
	DECLARE LlaveEjecucion		VARCHAR(50);
	DECLARE LlaveEjeCedes		VARCHAR(50);
	DECLARE LlavePagosRefere	VARCHAR(50);
	DECLARE ValorEjecNO			CHAR(1);
	DECLARE ValorEjecSI			CHAR(1);
	DECLARE	Act_InicioCierreDia	INT(11);
	DECLARE	Act_FinCierreDia	INT(11);

	-- Asignacion de Constantes
	SET Cadena_Vacia        	:= '';					-- Cadena Vacia
	SET	Entero_Cero				:= 0;					-- Entero Cero
	SET	SalidaSI				:= 'S';					-- Salida SI
	SET ActCobAutomaticaSI 		:= 1;					-- Actualizacion de Cobranza Automatica: SI
	SET ActCobAutomaticaNO		:= 2;					-- Actualizacion de Cobranza Automatica: NO
	SET ActProcesoCedeSI	 	:= 3;					-- Actualizacion de Vencimiento Masivo CEDES: SI
	SET ActProcesoCedeNO		:= 4;					-- Actualizacion de Vencimiento Masivo CEDES: NO

	SET LlaveEjecucion      	:= 'EjecucionCobAut';  	-- Llave Parametro: Ejecucion Cobranza Automatica
	SET LlaveEjeCedes      		:= 'ProVencMasivoCedes';-- Llave Parametro: Ejecucion Vencimiento Masivo CEDES
	SET LlavePagosRefere		:= 'PagosXReferencia';-- Llave Parametro: Ejecucion Pagos Referenciados
	SET ValorEjecNO				:= 'N';					-- Valor de Parametro en Ejecucion:NO
	SET ValorEjecSI				:= 'S';					-- Valor de Parametro en Ejecucion:NO
	SET Act_InicioCierreDia		:= 5;
    SET Act_FinCierreDia		:= 6;
   	SET ActCobAutRefeSI			:= 7;					-- Actualiza Cobranza Referencia SI
	SET ActCobAutRefeNO			:= 8;					-- Actualiza Cobranza Referencia NO


	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PARAMGENERALESACT');
				SET Var_Control = 'SQLEXCEPTION';
			END;

		-- Obtener el valor del proceso de cobranza automatica
		SELECT ValorParametro INTO Var_ValorParametro
			FROM 	PARAMGENERALES
			WHERE 	LLaveParametro	= LlaveEjecucion;

		SELECT ValorParametro INTO Var_ValorParametroRef
			FROM 	PARAMGENERALES
			WHERE 	LLaveParametro	= 'EjecucionCobAutRef';

		SET Var_PagoRefere := (SELECT ValorParametro FROM PARAMGENERALES WHERE LLaveParametro = LlavePagosRefere);

		IF(IFNULL(Var_PagoRefere,Cadena_Vacia) = ValorEjecSI AND Par_NumActualiza = ActCobAutomaticaSI
			AND IFNULL(Var_ValorParametroRef,Cadena_Vacia) = ValorEjecSI) THEN
			SET Par_NumErr  := 001;
			SET Par_ErrMen  := 'No es posible realizar la Cobranza Automatica debido a que se esta Ejecutando el Proceso de Cobranza Automatica por Referencia.';
			SET Var_Control := 'procesar';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Var_ValorParametroRef,Cadena_Vacia) = ValorEjecSI AND Par_NumActualiza = ActCobAutRefeSI) THEN
			SET Par_NumErr  := 001;
			SET Par_ErrMen  := 'El Proceso de Cobranza Automatica por Referencia esta en Ejecucion..';
			SET Var_Control := 'procesar';
			LEAVE ManejoErrores;
		END IF;

		-- Validamos si el proceso se encuentra en ejecucion
		IF(IFNULL(Var_ValorParametro,Cadena_Vacia)) = ValorEjecSI AND Par_NumActualiza = ActCobAutomaticaSI THEN
			SET Par_NumErr  := 001;
			SET Par_ErrMen  := 'Proceso de Cobranza Automatica Esta en Ejecucion.';
			SET Var_Control := 'procesar';
			LEAVE ManejoErrores;
		END IF;

		-- 1.- Actualizacion de Cobranza Automatica: SI
		IF(Par_NumActualiza = ActCobAutomaticaSI) THEN
			UPDATE PARAMGENERALES SET
					ValorParametro	= ValorEjecSI
			WHERE 	LLaveParametro 	= LlaveEjecucion;

			SET Par_NumErr  := 000;
			SET Par_ErrMen  := 'Ejecucion Actualizado.';
			SET Var_Control := 'procesar';
			LEAVE ManejoErrores;
		END IF;


		-- 2.- Actualizacion de Cobranza Automatica: NO
		IF(Par_NumActualiza = ActCobAutomaticaNO) THEN
			UPDATE PARAMGENERALES SET
					ValorParametro	= ValorEjecNO
			WHERE 	LLaveParametro 	= LlaveEjecucion;

			SET Par_NumErr  := 000;
			SET Par_ErrMen  := 'Ejecucion Actualizado.';
			SET Var_Control := 'procesar';
		   LEAVE ManejoErrores;
		END IF;


		IF(Par_NumActualiza = ActProcesoCedeSI || Par_NumActualiza = ActProcesoCedeNO)THEN

			-- Obtener el valor del proceso del vencimiento masivo de CEDES
			SELECT ValorParametro INTO Var_ValorParametro
				FROM PARAMGENERALES
				WHERE	LLaveParametro	= LlaveEjeCedes;

			-- Validamos si el proceso se encuentra en ejecucion
			IF((IFNULL(Var_ValorParametro,Cadena_Vacia)) = ValorEjecSI AND Par_NumActualiza = ActProcesoCedeSI)THEN
				SET Par_NumErr  := 001;
				SET Par_ErrMen  := 'Proceso de Vencimiento Masivo Esta en Ejecucion.';
				SET Var_Control := 'procesar';
				LEAVE ManejoErrores;
			END IF;

			-- 1.- Actualizacion de vencimiento masivo de CEDES: SI
			IF(Par_NumActualiza = ActProcesoCedeSI) THEN
				UPDATE	PARAMGENERALES SET
					ValorParametro		= ValorEjecSI
				WHERE	LLaveParametro 	= LlaveEjeCedes;

				SET Par_NumErr  := 000;
				SET Par_ErrMen  := 'Ejecucion Actualizado.';
				SET Var_Control := 'procesar';
			END IF;

			-- 2.- Actualizacion de vencimiento masivo de CEDES: NO
			IF(Par_NumActualiza = ActProcesoCedeNO) THEN
				UPDATE	PARAMGENERALES SET
					ValorParametro		= ValorEjecNO
				WHERE	LLaveParametro 	= LlaveEjeCedes;

				SET Par_NumErr  := 000;
				SET Par_ErrMen  := 'Ejecucion Actualizado.';
				SET Var_Control := 'procesar';
			END IF;
		END IF;

		-- 5.- Inicio del cierre de dia: SI
		IF(Par_NumActualiza = Act_InicioCierreDia) THEN
			UPDATE	PARAMGENERALES SET
				ValorParametro		= ValorEjecSI
			WHERE	LLaveParametro 	= 'EjecucionCierreDia';

			SET Par_NumErr  := 000;
			SET Par_ErrMen  := 'Ejecucion Actualizado.';
			SET Var_Control := 'procesar';
		END IF;

		-- 6.- Fin del cierre de dia: NO
		IF(Par_NumActualiza = Act_FinCierreDia) THEN
			UPDATE	PARAMGENERALES SET
				ValorParametro		= ValorEjecNO
			WHERE	LLaveParametro 	= 'EjecucionCierreDia';

			SET Par_NumErr  := 000;
			SET Par_ErrMen  := 'Ejecucion Actualizado.';
			SET Var_Control := 'procesar';
		END IF;

		-- 7.- Actualizacion de Cobranza Automatica: SI
		IF(Par_NumActualiza = ActCobAutRefeSI) THEN
			UPDATE PARAMGENERALES SET
					ValorParametro	= ValorEjecSI
			WHERE 	LLaveParametro 	= 'EjecucionCobAutRef';

			SET Par_NumErr  := 000;
			SET Par_ErrMen  := 'Ejecucion Actualizado.';
			SET Var_Control := 'procesar';
			LEAVE ManejoErrores;
		END IF;

		-- 8.- Actualizacion de Cobranza Automatica: NO
		IF(Par_NumActualiza = ActCobAutRefeNO) THEN
			UPDATE	PARAMGENERALES SET
				ValorParametro		= ValorEjecNO
			WHERE	LLaveParametro 	= 'EjecucionCobAutRef';

			SET Par_NumErr  := 000;
			SET Par_ErrMen  := 'Ejecucion Actualizado.';
			SET Var_Control := 'procesar';
		END IF;

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Entero_Cero AS consecutivo;
	END IF;

END TerminaStore$$