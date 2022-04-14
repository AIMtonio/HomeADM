-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAMBIOTASAISRPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CAMBIOTASAISRPRO`;DELIMITER $$

CREATE PROCEDURE `CAMBIOTASAISRPRO`(
/** ====== PROCESO QUE ACTUALIZA LA TASA ISR EN APORTACIONES CON EL ======
 ** ==================== NUEVO VALOR VIGENTE DEL ISR. ==================== */
	Par_Fecha			DATE,			-- FECHA DE CIERRE.
	Par_Salida			CHAR(1),		-- TIPO DE SALIDA.
	INOUT Par_NumErr	INT(11),		-- NÚMERO DE VALIDACIÓN.
	INOUT Par_ErrMen	VARCHAR(400),	-- MENSAJE DE VALIDACIÓN.
	/* Parámetros de Auditoría */
	Par_EmpresaID		INT(11),

	Aud_Usuario			INT(11),
	Aud_FechaActual		DATE,
	Aud_DireccionIP		VARCHAR(20),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),

	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore:BEGIN

	# DECLARACIÓN VARIABLES.
	DECLARE Var_TasaISRActual		DECIMAL(12,2);	-- VALOR ACTUAL DE LA TASA ISR.
	DECLARE Var_NuevaTasaISR		DECIMAL(12,2);	-- NUEVO VALOR DE LA TASA ISR
	DECLARE Var_FechaSig			DATE;			-- FECHA SIGUIENTE HABIL.
	DECLARE Var_FechaCalcula		DATE;			-- FECHA DE CIERRE.
	DECLARE Var_PaisIDBase			INT(11);		-- Pais ID de Base.

	# DECLARACIÓN CONSTANTES.
	DECLARE Entero_Cero 			INT;
	DECLARE Entero_Uno 				INT;
	DECLARE Entero_Dos	 			INT;
	DECLARE Entero_Cinco 			INT;
	DECLARE Entero_Cien 			INT;
	DECLARE ConstSI 				CHAR(1);
	DECLARE ConstNO 				CHAR(1);
	DECLARE ConstV	 				CHAR(1);
	DECLARE EstaVigente 			CHAR(1);
	DECLARE PagoAlVenc 				CHAR(1);
	DECLARE PagoFinMes 				CHAR(1);
	DECLARE Es_DiaHabil				CHAR(1);
	DECLARE Var_FecApli				DATE;
	DECLARE Salida_SI    			CHAR(1);
    DECLARE CalculoISR				INT(11);

	# ASIGNACIÓN CONSTANTES.
	SET Entero_Cero					:= 0;		-- CONSTANTE ENTERO CERO.
	SET Entero_Uno					:= 1;		-- CONSTANTE ENTERO UNO.
	SET Entero_Dos					:= 2;		-- CONSTANTE ENTERO DOS.
	SET Entero_Cinco				:= 5;		-- CONSTANTE ENTERO CINCO.
	SET Entero_Cien					:= 100;		-- CONSTANTE ENTERO CIEN.
	SET ConstSI						:= 'S';		-- CONSTANTE SI.
	SET ConstNO						:= 'N';		-- CONSTANTE NO.
	SET EstaVigente					:= 'N';		-- ESTATUS VIGENTE.
	SET PagoAlVenc					:= 'V';		-- TIPO DE PAGO AL VENCIMIENTO.
	SET PagoFinMes					:= 'F';		-- TIPO DE PAGO A FIN DE MES.
	SET Salida_SI   				:= 'S';		-- SALIDA SI.

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
					'Disculpe las molestias que esto le ocasiona. Ref: SP- CAMBIOTASAISRPRO.');
			END;

		SET Var_PaisIDBase := FNPARAMGENERALES('PaisIDBase');
		SET Var_FechaCalcula := Par_Fecha;

		# SE OBTIENE LA TASA ACTUAL DE ISR PARA RESIDENTES NACIONALES
		SET Var_TasaISRActual := (SELECT TasaISR FROM PARAMETROSSIS LIMIT 1);
		SET Var_TasaISRActual := IFNULL(Var_TasaISRActual,Entero_Cero);

		CALL DIASFESTIVOSCAL(
			Var_FechaCalcula,	Entero_Uno,			Var_FechaSig,		Es_DiaHabil,	Par_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
			Aud_NumTransaccion);

		WHILE (Var_FechaCalcula <= Var_FechaSig) DO
			# SE OBTIENE LA TASA ACTUAL DE ISR.
			SET Var_TasaISRActual := (SELECT TasaISR FROM PARAMETROSSIS LIMIT 1);
			SET Var_TasaISRActual :=IFNULL(Var_TasaISRActual,Entero_Cero);

			# SI EXISTE CAMBIO, SE ACTUALIZAN LAS TASAS CON EL NUEVO VALOR DE ISR.
			IF EXISTS(SELECT * FROM `HIS-TASASIMPUESTOS` WHERE Fecha=Var_FechaCalcula)THEN
			#IF(Var_CambTasa != Entero_Cero)THEN
				SET Var_NuevaTasaISR := CALCULATASAISR(Var_FechaCalcula,Var_TasaISRActual);

				# ACTUALIZACIÓN DE LAS TASAS EN APORTACIONES VIGENTES.
				UPDATE APORTACIONES AP
					INNER JOIN CLIENTES Cli ON Cli.ClienteID=AP.ClienteID
				SET
					AP.TasaISR	= Var_NuevaTasaISR,
					AP.TasaNeta = (AP.TasaFija - Var_NuevaTasaISR)
				WHERE AP.Estatus = EstaVigente
					AND Cli.PagaISR = ConstSI
					AND Cli.PaisResidencia = Var_PaisIDBase;

				# ACTUALIZACIÓN DE LAS TASAS EN RENDIMIENTO DE APORTACIONES VIGENTES.
				UPDATE RENDIMIENTOAPORT R
					INNER JOIN APORTACIONES AP ON R.AportacionID = AP.AportacionID
					INNER JOIN CLIENTES Cli ON Cli.ClienteID = AP.ClienteID
				SET
					R.TasaISR = Var_NuevaTasaISR
				WHERE R.FechaCalculo >= Var_FechaCalcula
					AND AP.Estatus = EstaVigente
					AND Cli.PagaISR = ConstSI
					AND Cli.PaisResidencia = Var_PaisIDBase;

				# ACTUALIZACIÓN DEL NUEVO VALOR DE LA TASA ISR
				UPDATE SUCURSALES
				SET
					TasaISR = Var_NuevaTasaISR;

				UPDATE PARAMETROSSIS
				SET
					TasaISR = Var_NuevaTasaISR;
			END IF;
			SET	Var_FechaCalcula := ADDDATE(Var_FechaCalcula, 1);
		END WHILE;

		# ACTUALIZACIÓN DE TASA ISR PARA RESIDENTES EN EL EXTRANJERO.
		SET Var_FechaCalcula := Par_Fecha;

		WHILE (Var_FechaCalcula <= Var_FechaSig) DO
			# SI EXISTE CAMBIO, SE ACTUALIZAN LAS TASAS CON EL NUEVO VALOR DE ISR.
			IF EXISTS(SELECT * FROM HISTASASISREXTRAJERO WHERE Fecha=Var_FechaCalcula)THEN
				# ACTUALIZACIÓN DE LAS TASAS EN APORTACIONES VIGENTES.
				UPDATE APORTACIONES AP
					INNER JOIN CLIENTES Cli ON Cli.ClienteID=AP.ClienteID
				SET
					AP.TasaISR	= FNTASAISREXT(Cli.PaisResidencia,2,Var_FechaCalcula,AP.TasaISR),
					AP.TasaNeta = (AP.TasaFija - FNTASAISREXT(Cli.PaisResidencia,2,Var_FechaCalcula,AP.TasaISR))
				WHERE AP.Estatus = EstaVigente
					AND Cli.PagaISR = ConstSI
					AND Cli.PaisResidencia != Var_PaisIDBase;

				# ACTUALIZACIÓN DE LAS TASAS EN RENDIMIENTO DE APORTACIONES VIGENTES.
				UPDATE RENDIMIENTOAPORT R
					INNER JOIN APORTACIONES AP ON R.AportacionID = AP.AportacionID
					INNER JOIN CLIENTES Cli ON Cli.ClienteID = AP.ClienteID
				SET
					R.TasaISR = FNTASAISREXT(Cli.PaisResidencia,2,Var_FechaCalcula,R.TasaISR)
				WHERE R.FechaCalculo >= Var_FechaCalcula
					AND AP.Estatus = EstaVigente
					AND Cli.PagaISR = ConstSI
					AND Cli.PaisResidencia != Var_PaisIDBase;

				# ACTUALIZACIÓN DEL NUEVO VALOR DE LA TASA ISR
				UPDATE TASASISREXTRAJERO
				SET
					TasaISR			= FNTASAISREXT(PaisID,2,Var_FechaCalcula,TasaISR),
					EmpresaID		= Par_EmpresaID,
					Usuario			= Aud_Usuario,

					FechaActual		= Aud_FechaActual,
					DireccionIP		= Aud_DireccionIP,
					ProgramaID		= Aud_ProgramaID,
					Sucursal		= Aud_Sucursal,
					NumTransaccion	= Aud_NumTransaccion;
			END IF;
			SET	Var_FechaCalcula := ADDDATE(Var_FechaCalcula, 1);
		END WHILE;

		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := 'Cambio Tasa ISR Realizado Exitosamente.';

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen;
	END IF;

END TerminaStore$$