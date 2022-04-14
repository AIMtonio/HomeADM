-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AMORTGENCREDFONPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `AMORTGENCREDFONPRO`;DELIMITER $$

CREATE PROCEDURE `AMORTGENCREDFONPRO`(
	/*SP que genera las amortizaciones de un credito pasivo de acuerdo al credito activo para creditos agropecuarios.*/
	Par_CreditoID			BIGINT(12),		# ID de Credito de CREDITOS
	Par_MontoMinistrado		DECIMAL(14,2),	# Monto de la ministracion
	Par_Tasa				DECIMAL(14,4),	# Tasa del Credito Pasivo
	Par_PagaIVA				CHAR(1),		# Indica si paga IVA valores :  S:Si N:No
	Par_IVA 				DECIMAL(12,4),	# Porcentaje de IVA que Paga
	Par_Salida				CHAR(1),		# Salida S:Si N:No
	INOUT Par_NumErr		INT(11),		# Numero de error
	INOUT Par_ErrMen		VARCHAR(400),	# Mensaje de Error
	/* Parametros de Auditoria */
	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),

	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(50);			# Variable con el ID del control de Pantalla
	DECLARE Var_FechaSistema		DATE;					# Fecha Actual del Sistema
	DECLARE Var_Consecutivo			VARCHAR(50);			# Variable campo de pantalla
	DECLARE Var_ConsecutivoSim		INT;					# Consecutivo (Variable Simulador)
	DECLARE Var_CapitalSim			DECIMAL(12,2);			# Monto de Capital del Simulador
	DECLARE Var_FechaInicioSim		DATE;					# Fecha de Inicio (Variable Simulador)
	DECLARE Var_FechaVencSim		DATE;					# Fecha de Vencimiento (Variable Simulador)
	DECLARE Var_DiaHabilSigSim		CHAR(1);				# Dia Habil Siguiente (Variable Simulador)

	-- Declaracion de constantes
	DECLARE Estatus_PendienteAmo	CHAR(1);				# Estatus de las amortizaciones Pendientes esto solo pasa cuando se crean por desembolso y aun no estan activas
	DECLARE Salida_SI				CHAR(1);				# Salida Si
	DECLARE Salida_NO				CHAR(1);				# Salida No
	DECLARE Entero_Cero				INT(11);				# Entero Cero
	DECLARE CURSORAMORTIAGRO CURSOR FOR
		SELECT AmortizacionID, FechaInicio, FechaVencim, Capital
			FROM AMORTICREDITO
				WHERE CreditoID = Par_CreditoID
				AND Estatus = Estatus_PendienteAmo;


	-- Asignacion de constantes
	SEt Estatus_PendienteAmo		:= 'E';					# Estatus Pendiente
	SET Salida_SI					:= '';
	SET Salida_NO					:= '';
	SET Entero_Cero					:= 0;

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-AMORTGENCREDFONPRO');
			SET Var_Control := 'sqlException';
		END;
		SET Var_DiaHabilSigSim := 'S';

		# Se dan de alta las amortizaciones de los creditos pasivos para realizar su simulación
		OPEN CURSORAMORTIAGRO;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				CICLO:LOOP
					FETCH CURSORAMORTIAGRO INTO
					Var_ConsecutivoSim,		Var_FechaInicioSim,			Var_FechaVencSim,		Var_CapitalSim;

					CALL CREPAGLIBAMORALT(
						Var_ConsecutivoSim,		Var_CapitalSim,			Var_FechaInicioSim,			Var_FechaVencSim,	Var_DiaHabilSigSim,
						'N',					Par_NumErr,				Par_ErrMen,					Aud_EmpresaID,		Aud_Usuario,
						Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,
						Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero) THEN
						LEAVE CICLO;
					END IF;

				END LOOP CICLO;
			END;
		CLOSE CURSORAMORTIAGRO;

		IF(Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;
		#FIN Se dan de alta las amortizaciones de los creditos pasivos para realizar su simulación

		CALL FONRECPAGLIBPRO(
			Par_MontoMinistrado,		Par_Tasa,				Par_PagaIVA,			Par_IVA,			Entero_Cero,
            Par_Salida,					Par_NumErr,				Par_ErrMen,				Aud_EmpresaID,		Aud_Usuario,
            Aud_FechaActual,			Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr			:= 000;
		SET Par_ErrMen			:= 'Amortizaciones Agregadas Exitosamente para Credito Pasivo.';
		SET Var_Control			:= 'graba';
		SET Var_Consecutivo 	:= Par_CreditoID;
	END ManejoErrores;  -- End del Handler de Errores

	IF (Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr 	AS NumErr,
			Par_ErrMen	AS ErrMen,
			Var_Control AS control,
			Var_Consecutivo AS consecutivo;
	END IF;
END TerminaStore$$