-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CEDESSIMULADORPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CEDESSIMULADORPRO`;DELIMITER $$

CREATE PROCEDURE `CEDESSIMULADORPRO`(
# ================================================================
# ------ SP PARA GENERAR LA SIMULACION DE LAS AMORTIZACIONES------
# ================================================================
    Par_CedeID              INT(11),            -- ID de la CEDE
    Par_FechaInicio         DATE,               -- Fecha de Inicio del calendario a simular
    Par_FechaVencimiento    DATE,               -- Fecha de Vencimiento del calendario a simular
    Par_Monto               DECIMAL(18,2),      -- Monto con el que se simulara
    Par_ClienteID           INT(11),            -- Valor del Cliente

    Par_TipoCedeID          INT(11),            -- Valor de Tipo de Cede
    Par_TasaFija            DECIMAL(18,4),      -- Valor de Tasa Fija
	Par_TipoPagoInt         CHAR(1),            -- Indica si es a FIN DE MES (F) o al VENCIMIENTO (V) o por PERIODO(P)
	Par_DiasPeriodo			INT(11),			-- Especifica los dias por periodo cuando la forma de pago de interes es por periodo
	Par_PagoIntCal			CHAR(2),			-- Especifica el tipo de pago de interes D - Devengado, I - Iguales

    Par_Salida              CHAR(1),            -- Indica si espera un SELECT de salida
    INOUT   Par_NumErr      INT(11),
    INOUT   Par_ErrMen      VARCHAR(400),

    Aud_EmpresaID           INT(11),            -- Parametro de Auditoria
    Aud_Usuario             INT(11),            -- Parametro de Auditoria
    Aud_FechaActual         DATETIME,           -- Parametro de Auditoria
    Aud_DireccionIP         VARCHAR(15),        -- Parametro de Auditoria
    Aud_ProgramaID          VARCHAR(50),        -- Parametro de Auditoria
    Aud_Sucursal            INT(11),            -- Parametro de Auditoria
    Aud_NumTransaccion      BIGINT(20)          -- Parametro de Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE Cadena_Vacia    CHAR(1);
	DECLARE Fecha_Vacia     DATE;
	DECLARE Entero_Cero     INT(11);
	DECLARE Entero_Cien     INT(11);
	DECLARE Decimal_Cero    DECIMAL(18,2);
	DECLARE VarSi           CHAR(1);
	DECLARE VarTasaFija     CHAR(1);
	DECLARE VarTasaVariable CHAR(1);
	DECLARE Dia_SD          CHAR(2);
	DECLARE Dia_D           CHAR(2);
	DECLARE VarViernes      INT(11);
	DECLARE VarVencimiento  CHAR(1);
	DECLARE VarFinMes		CHAR(1);
    DECLARE VarPeriodo		CHAR(1);
	DECLARE Factor_Porcen   DECIMAL(12,2);
	DECLARE IntDevengado	CHAR(1);
    DECLARE IntIguales		CHAR(1);
    DECLARE ValorUMA		VARCHAR(15);

	-- Declaracion de variables
	DECLARE VarDiaGenerado  DATE;
	DECLARE VarFechaPago    DATE;
	DECLARE VarFechaInicio  DATE;
	DECLARE VarConsecutivo  INT(11);
	DECLARE VarDias         INT(11);
	DECLARE VarDiasInver    INT(11);
	DECLARE VarTipoTasa     CHAR(1);
	DECLARE Var_PagaISR     CHAR(1);
	DECLARE Var_TasaISR     DECIMAL(18,2);
	DECLARE VarInteres      DECIMAL(18,2);
	DECLARE VarInteresTotal DECIMAL(18,2);  -- INTERES TOTAL EL CUAL SE USARA PARA SACAR LA ULTIMA CUOTA
	DECLARE VarInteresAcum  DECIMAL(18,2);  -- INTERES ACUMULADO SIN LA ULTIMA CUOTA
	DECLARE VarISR          DECIMAL(18,2);
	DECLARE VarISRTotal     DECIMAL(18,2);  -- ISR TOTAL EL CUAL SE USARA PARA SACAR LA ULTIMA CUOTA
	DECLARE VarISRAcum      DECIMAL(18,2);  -- ISR ACUMULADO SIN LA ULTIMA CUOTA
	DECLARE VarTotal        DECIMAL(18,2);
	DECLARE VarCapital      DECIMAL(18,2);
	DECLARE VarTotalCapital DECIMAL(18,2);
	DECLARE VarTotalInteres DECIMAL(18,2);
	DECLARE VarTotalISR     DECIMAL(18,2);
	DECLARE VarTotalFinal   DECIMAL(18,2);
	DECLARE Var_SalMinDF    DECIMAL(12,2);  -- Salario minimo segun el df
	DECLARE Var_SalMinAn    DECIMAL(12,2);  -- Salario minimo anualizado segun el df
	DECLARE Var_DiaInhabil  CHAR(2);
	DECLARE Var_TipoPersona CHAR(1);
	DECLARE Var_Control	    VARCHAR(100);  	-- Variable de control
	DECLARE FechaVig        DATE;
	DECLARE FechaVenOri     DATE;
   	DECLARE Var_NumCuotas	INT(11);		-- Numero de cuotas del cede
    DECLARE Var_IntCuota	DECIMAL(18,2);	-- Interes por cuota
	DECLARE Var_ValorUMA	DECIMAL(12,4);
    DECLARE Per_Moral		CHAR(1);
	DECLARE Var_EstatusISR	CHAR(1);
	DECLARE EstatusActivo	CHAR(1);

	-- Asignacion de constantes
	SET Cadena_Vacia        := '';
	SET Fecha_Vacia         := '1900-01-01';
	SET Entero_Cero         := 0;
	SET Entero_Cien         := 100;
	SET Decimal_Cero        := 0.00;
	SET VarSi               := 'S';
	SET VarTasaFija         := 'F';
	SET VarTasaVariable     := 'V';
	SET Dia_SD              := 'SD';		-- Dia sabado y domingo
	SET Dia_D               := 'D';       	-- Dia domingo
	SET VarViernes          := 6;
	SET VarVencimiento      := 'V';			-- Indica que se trata de pagos al vencimiento
	SET VarFinMes     		:= 'F';			-- Indica que se trata de pagos al fin de mes
    SET VarPeriodo     		:= 'P';			-- Indica que se trata de pagos por periodo
	SET Factor_Porcen       := 100.00;
    SET IntDevengado		:= 'D';			-- Tipo de pago de interes DEVENGADO
    SET IntIguales			:= 'I';			-- Tipo de pago de interes IGUALES
    SET ValorUMA			:='ValorUMABase';
    SET Per_Moral			:= 'M';
	SET EstatusActivo		:= 'A';			-- ESTATUS ACTIVO

	ManejoErrores:BEGIN     #bloque para manejar los posibles errores

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	:= 999;
				SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CEDESSIMULADORPRO');
				SET Var_Control := 'SQLEXCEPTION';
			END;

		/* SE OBTIENEN LOS VALORES DE PARAMETROS DE SISTEMA*/
		SELECT  	DiasInversion,  SalMinDF
			INTO 	VarDiasInver ,  Var_SalMinDF
			FROM 	PARAMETROSSIS
			WHERE 	EmpresaID = 1;

        SELECT ValorParametro
			INTO Var_ValorUMA
			FROM PARAMGENERALES
		WHERE LlaveParametro=ValorUMA;
		/* Se consulta para saber si el cliente paga o no ISR y se obtiene el valor de TasaISR*/
		SELECT  Suc.TasaISR,  PagaISR,      TipoPersona
		   INTO Var_TasaISR , Var_PagaISR , Var_TipoPersona
			FROM    CLIENTES   Cli,
					SUCURSALES Suc
			WHERE   Cli.ClienteID	= Par_ClienteID
			AND 	Suc.SucursalID	= Cli.SucursalOrigen;

		/*se obtienen los valores de tipos de cedes*/
		SELECT  DiaInhabil,     TasaFV
			INTO   	Var_DiaInhabil, VarTipoTasa
			FROM 	TIPOSCEDES
			WHERE 	TipoCedeID = Par_TipoCedeID;

		-- Inicializacion de variables
		SET VarTipoTasa     := IFNULL(VarTipoTasa, Cadena_Vacia );
		SET VarDiasInver    := IFNULL(VarDiasInver , Entero_Cero);
		SET Var_SalMinDF    := IFNULL(Var_SalMinDF , Decimal_Cero);
		SET Var_TasaISR     := IFNULL(Var_TasaISR , Decimal_Cero);
		SET VarConsecutivo  := Entero_Cero;
		SET FechaVenOri     := Par_FechaVencimiento;
		SET VarDiaGenerado  := Par_FechaInicio;
		SET VarFechaInicio  := Par_FechaInicio;
		SET VarDias         := DATEDIFF(Par_FechaVencimiento, Par_FechaInicio);
		SET Var_SalMinAn    := Var_SalMinDF * 5 * Var_ValorUMA;/* Salario minimo General Anualizado*/

		/* se limpia la tabla de paso*/
		DELETE FROM TMPSIMULADORCEDE WHERE NumTransaccion = Aud_NumTransaccion;

		-- ***************************************************************************************************
		-- ********SE CALCULA INTERES E ISR ***********************************
		-- ***************************************************************************************************
		SET VarCapital      := Par_Monto;

		-- SE OBTIENE LA DIFERENCIA DE LA FECHA VENCIMIENTO CON LA FECHA DE INICIO EN DIAS
		SET VarDias:= (DATEDIFF(Par_FechaVencimiento,VarFechaInicio));

		/* valida de que tipo de tasa se trata */
		CASE VarTipoTasa
			WHEN VarTasaFija        THEN    SET VarInteresTotal := (Par_Monto * VarDias * Par_TasaFija) / (VarDiasInver*Entero_Cien);
			WHEN VarTasaVariable    THEN    SET VarInteresTotal := Decimal_Cero;
		END CASE;

		SET VarInteresTotal := IFNULL(VarInteresTotal, Decimal_Cero);

		/* PARA PERSONA FISICA/ FISICA ACT EMPRESARIAL:
			* SI EL MONTO DE CEDE es MAYOR O IGUAL A 5 Salario minimo General Anualizado Distrito Federal segun DF,(SMAGDF),
			* entonces se aplica el calculo de ISR PERO SOBRE EL EXCEDENTE DE CAPITAL NO SOBRE EL CAPITAL ORIGINAL,
			* si no es CERO
		   PARA PERSONA MORAL:
			* NO IMPORTA SI EL MONTO DE CEDE es MAYOR O IGUAL A 5 Salario minimo General Anualizado Distrito Federal segun DF,(SMAGDF),
			* si es persona moral el calculo del ISR se aplica PERO SOBRE TODO EL CAPITAL ORIGINAL,
			* si no es CERO
            */

		/* Si el cliente paga ISR entonces se calcula el interes a Retener , sino su valor sera cero*/
		IF (VarInteresTotal > Decimal_Cero) THEN
			IF (Var_PagaISR = VarSi) THEN
				IF( Par_Monto > Var_SalMinAn OR Var_TipoPersona = Per_Moral)THEN
					IF(Var_TipoPersona = Per_Moral)THEN
						SET VarISRTotal = ROUND((Par_Monto * VarDias * Var_TasaISR) / (Factor_Porcen * VarDiasInver), 2);
                    ELSE
						SET VarISRTotal = ROUND(((Par_Monto-Var_SalMinAn) * VarDias * Var_TasaISR) / (Factor_Porcen * VarDiasInver), 2);
                    END IF;
				ELSE
					SET VarISRTotal := Decimal_Cero;
				END IF;
			ELSE
				SET VarISRTotal := Decimal_Cero;
			END IF;
		ELSE
			SET VarISRTotal := Decimal_Cero;
		END IF;

		SET VarISRTotal     := IFNULL(VarISRTotal, Decimal_Cero);

		-- ***************************************************************************************************
		-- ***************************** Tipo de Pago: AL VENCIMIENTO *****************
		IF(Par_TipoPagoInt = VarVencimiento)THEN
			SET VarTotal        := Par_Monto + VarInteresTotal - VarISRTotal;
			SET VarConsecutivo  := VarConsecutivo + 1;

			-- SE INSERTA EN LA TABLA DE SIMULACION
			INSERT INTO TMPSIMULADORCEDE (
				NumTransaccion,     Consecutivo,    Fecha,                  FechaPago,              Capital,
				Interes,            ISR,            Total,                  Dias,                   FechaInicio)
			VALUES(
				Aud_NumTransaccion, VarConsecutivo, Par_FechaVencimiento,   Par_FechaVencimiento,   VarCapital,
				VarInteresTotal,    VarISRTotal,    VarTotal,               VarDias,                VarFechaInicio);

		ELSEIF(Par_TipoPagoInt = VarFinMes)THEN/* ************************************************************************************************* */
			--  SE CREA CICLO PARA GENERAR EL CALENDARIO DE FECHAS
			WHILE (VarDiaGenerado < Par_FechaVencimiento) DO
				/* PARA LA PRIMER CUOTA SI SE TIENE EL CASO DE QUE HOY ES 29 Y EL
					FIN DE MES CAE DOMINGO LA PRIMER CUOTA DEBE DE SER AL SIGUIENTE MES */
				IF(VarConsecutivo = Entero_Cero)THEN
					SET VarDiaGenerado:= last_day(VarFechaInicio);
					IF(DAYOFWEEK(VarDiaGenerado) = VarViernes)  THEN
						SET VarDiaGenerado := last_day(VarDiaGenerado);
					ELSE
						IF(VarDiaGenerado = Par_FechaInicio)THEN -- SI EL DIA GENERADO ES IGUAL AL MISMO DIA DE INICIO SE AUMENTA UN MES
							SET VarDiaGenerado := DATE_ADD(VarDiaGenerado, INTERVAL 1 MONTH);
							SET VarDiaGenerado := last_day(VarDiaGenerado);
						END IF;
					END IF;
				ELSE -- SI NO SE TRATA DE LA PRIMER CUOTA
					SET VarDiaGenerado := DATE_ADD(VarDiaGenerado, INTERVAL 1 MONTH);
					SET VarDiaGenerado := last_day(VarDiaGenerado);
				END IF;

				IF(VarDiaGenerado != Par_FechaVencimiento)THEN
					/* Obtener fecha de pago segun parametrizacion del producto y recorrer la fecha de pago al dia habil
						anterior si originalmente cae en dia inhabil o festivo. */
					IF (Var_DiaInhabil= Dia_SD)THEN
						CALL DIASHABILSDANTERCAL(
							VarDiaGenerado,     Entero_Cero,        FechaVig,       Aud_EmpresaID,  Aud_Usuario,
							Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);
					ELSE
						IF (Var_DiaInhabil= Dia_D)THEN
							CALL DIASHABILANTERCAL(
								VarDiaGenerado,     Entero_Cero,        FechaVig,       Aud_EmpresaID,  Aud_Usuario,
								Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);
						END IF;
					END IF;
					SET VarFechaPago:=FechaVig;
				ELSE
					SET VarFechaPago:=Par_FechaVencimiento;
				END IF;

				-- SI EL DIA CALCULADO DE VENCIMIENTO ES MAYOR A LA FECHA DE VENCIMIENTO
				IF(VarDiaGenerado >= Par_FechaVencimiento)THEN
					SET VarDiaGenerado  := Par_FechaVencimiento;
					SET VarFechaPago    := Par_FechaVencimiento;
					SET VarCapital      := Par_Monto;
				ELSE
					SET VarCapital      := Decimal_Cero;
				END IF;

				-- SE OBTIENE LA DIFERENCIA DE LA FECHA VENCIMIENTO CON LA FECHA DE INICIO EN DIAS
				SET VarDias:= (DATEDIFF(VarDiaGenerado,VarFechaInicio));

				IF(Par_PagoIntCal = IntIguales)THEN
					SET VarConsecutivo  := VarConsecutivo + 1;

					SELECT COUNT(Consecutivo) INTO	Var_NumCuotas
						FROM TMPSIMULADORCEDE
						WHERE NumTransaccion = Aud_NumTransaccion;

					SET Var_NumCuotas	:= IFNULL(Var_NumCuotas,Entero_Cero);
					SET Var_NumCuotas 	:= Var_NumCuotas+1;
					SET VarInteres		:= (VarInteresTotal/Var_NumCuotas);
                    SET VarISR			:= (VarISRTotal/Var_NumCuotas);
                    SET VarTotal        := VarInteres - VarISR;

                    /* Si el cliente paga ISR entonces se calcula el interes a Retener , sino su valor sera cero*/
					IF (VarInteres > Decimal_Cero) THEN
						IF (Var_PagaISR = VarSi) THEN
							IF( Par_Monto > Var_SalMinAn OR Var_TipoPersona = Per_Moral)THEN
								 SET VarISR := VarISR;
							ELSE
								SET VarISR := Decimal_Cero;
							END IF;
						ELSE
							SET VarISR := Decimal_Cero;
						END IF;
					ELSE
						SET VarISR := Decimal_Cero;
					END IF;

					SET VarISR      := IFNULL(VarISR, Decimal_Cero);

					UPDATE TMPSIMULADORCEDE SET
								Interes		= VarInteres,
								ISR       	= VarISR,
								Total		= VarTotal
					WHERE NumTransaccion 	= Aud_NumTransaccion;


                    IF( VarDiaGenerado >= Par_FechaVencimiento) THEN
						-- PARA LA ULTIMA  CUOTA SE OBTIENE LA DIFERENCIA ENTRE EL ACUMULADO Y LO QUE SE CALCULO ORIGINAL
						SET VarInteresAcum  := (SELECT SUM(Interes) FROM TMPSIMULADORCEDE WHERE NumTransaccion= Aud_NumTransaccion);
						SET VarInteresAcum  := IFNULL(VarInteresAcum,VarInteres);
						SET VarISRAcum      := (SELECT SUM(ISR)     FROM TMPSIMULADORCEDE WHERE NumTransaccion= Aud_NumTransaccion);
						SET VarISRAcum      := IFNULL(VarISRAcum,VarISR);

						IF((VarInteresTotal- VarInteresAcum) = Decimal_Cero) THEN
							SET VarInteres := VarInteres;
						ELSE
							SET VarInteres := VarInteresTotal-VarInteresAcum;
						END IF;

						IF((VarISRTotal- VarISRAcum) = Decimal_Cero) THEN
							SET VarISR := VarISR;
						ELSE
							SET VarISR := VarISRTotal-VarISRAcum;
						END IF;

						SET VarTotal        := Par_Monto + VarInteres - VarISR;
					ELSE
						SET VarTotal        := VarInteres - VarISR;
					END IF;

				ELSE
					IF(VarDias>Entero_Cero) THEN
						SET VarConsecutivo  := VarConsecutivo + 1;
						/*valida de que tipo de tasa se trata */
						CASE VarTipoTasa
							WHEN VarTasaFija        THEN    SET VarInteres  := (Par_Monto * VarDias * Par_TasaFija) / (VarDiasInver*Entero_Cien);
							WHEN VarTasaVariable    THEN    SET VarInteres  := Decimal_Cero;
						END CASE;

						SET VarInteres := IFNULL(VarInteres, Decimal_Cero);

						/*  PARA PERSONA FISICA/ FISICA ACT EMP:
							*SI EL MONTO DE INVERSION es MAYOR O IGUAL A 5 Salario minimo General Anualizado Distrito Federal segun DF,(SMAGDF),
							* entonces se aplica el calculo de ISR PERO SOBRE EL EXCEDENTE DE CAPITAL NO SOBRE EL CAPITAL ORIGINAL,
							* si no es CERO
						   PARA PERSONA MORAL:
							* NO IMPORTA SI EL MONTO DE CEDE es MAYOR O IGUAL A 5 Salario minimo General Anualizado Distrito Federal segun DF,(SMAGDF),
							* si es persona moral el calculo del ISR se aplica PERO SOBRE TODO EL CAPITAL ORIGINAL,
							* si no es CERO
							*/
						/* Si el cliente paga ISR entonces se calcula el interes a Retener , sino su valor sera cero*/
						IF (VarInteres > Decimal_Cero) THEN
							IF (Var_PagaISR = VarSi) THEN
								IF( Par_Monto > Var_SalMinAn OR Var_TipoPersona = Per_Moral )THEN
									IF(Var_TipoPersona = Per_Moral)THEN
										SET VarISR = ROUND((Par_Monto * VarDias * Var_TasaISR) / (Factor_Porcen * VarDiasInver), 2);
                                    ELSE
										SET VarISR = ROUND(((Par_Monto-Var_SalMinAn) * VarDias * Var_TasaISR) / (Factor_Porcen * VarDiasInver), 2);
									END IF;
								ELSE
									SET VarISR = Decimal_Cero;
								END IF;
							ELSE
								SET VarISR = Decimal_Cero;
							END IF;
						ELSE
							SET VarISR = Decimal_Cero;
						END IF;

						SET VarISR      := IFNULL(VarISR, Decimal_Cero);


						IF( VarDiaGenerado >= Par_FechaVencimiento) THEN
							-- PARA LA ULTIMA  CUOTA SE OBTIENE LA DIFERENCIA ENTRE EL ACUMULADO Y LO QUE SE CALCULO ORIGINAL
							SET VarInteresAcum  := (SELECT SUM(Interes) FROM TMPSIMULADORCEDE WHERE NumTransaccion= Aud_NumTransaccion);
							SET VarInteresAcum  := IFNULL(VarInteresAcum,VarInteres);
							SET VarISRAcum      := (SELECT SUM(ISR)     FROM TMPSIMULADORCEDE WHERE NumTransaccion= Aud_NumTransaccion);
							SET VarISRAcum      := IFNULL(VarISRAcum,VarISR);
							IF((VarInteresTotal- VarInteresAcum) = Decimal_Cero) THEN
								SET VarInteres := VarInteres;
							ELSE
								SET VarInteres      := VarInteresTotal- VarInteresAcum;
							END IF;
							IF((VarISRTotal- VarISRAcum) = Decimal_Cero) THEN
								SET VarISR := VarISR;
							ELSE
								SET VarISR          := VarISRTotal- VarISRAcum;
							END IF;
							SET VarTotal        := Par_Monto + VarInteres - VarISR;
						ELSE
							SET VarTotal        := VarInteres - VarISR;
						END IF;
					END IF;
				END IF;
                    										-- AQUI ESTABA
				-- SE INSERTA EN LA TABLA DE SIMULACION
				INSERT INTO TMPSIMULADORCEDE (
					NumTransaccion,     Consecutivo,    Fecha,          FechaPago,      Capital,
					Interes,            ISR,            Total,          Dias,           FechaInicio)
				VALUES(
					Aud_NumTransaccion, VarConsecutivo, VarDiaGenerado, VarFechaPago,   VarCapital,
					VarInteres,         VarISR,         VarTotal,       VarDias,        VarFechaInicio);

				SET VarFechaInicio  := VarDiaGenerado;
				SET FechaVenOri 	:= VarFechaInicio;
			END WHILE; -- FIN WHILE

		ELSEIF(Par_TipoPagoInt = VarPeriodo)THEN/* ************************************************************************************************* */
			--  SE CREA CICLO PARA GENERAR EL CALENDARIO DE FECHAS
			WHILE (VarDiaGenerado < Par_FechaVencimiento) DO

				SET VarDiaGenerado:= DATE_ADD(VarFechaInicio, INTERVAL Par_DiasPeriodo DAY);

			   IF(VarDiaGenerado != Par_FechaVencimiento)THEN
					/* Obtener fecha de pago segun parametrizacion del producto y recorrer la fecha de pago al dia habil
						anterior si originalmente cae en dia inhabil o festivo. */
					IF (Var_DiaInhabil= Dia_SD)THEN
						CALL DIASHABILSDANTERCAL(
							VarDiaGenerado,     Entero_Cero,        FechaVig,       Aud_EmpresaID,  Aud_Usuario,
							Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);
					ELSE
						IF (Var_DiaInhabil= Dia_D)THEN
							CALL DIASHABILANTERCAL(
								VarDiaGenerado,     Entero_Cero,        FechaVig,       Aud_EmpresaID,  Aud_Usuario,
								Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);
						END IF;
					END IF;
					SET VarFechaPago:=FechaVig;
				ELSE
					SET VarFechaPago:=Par_FechaVencimiento;
				END IF;

				-- SI EL DIA CALCULADO DE VENCIMIENTO ES MAYOR A LA FECHA DE VENCIMIENTO
				IF(VarDiaGenerado >= Par_FechaVencimiento)THEN
					SET VarDiaGenerado  := Par_FechaVencimiento;
					SET VarFechaPago    := Par_FechaVencimiento;
					SET VarCapital      := Par_Monto;
				ELSE
					SET VarCapital      := Decimal_Cero;
				END IF;

				-- SE OBTIENE LA DIFERENCIA DE LA FECHA VENCIMIENTO CON LA FECHA DE INICIO EN DIAS
                SET VarDias:= (DATEDIFF(VarDiaGenerado,VarFechaInicio));

				IF(VarDias>Entero_Cero) THEN
					SET VarConsecutivo  := VarConsecutivo + 1;
					/*valida de que tipo de tasa se trata */
					CASE VarTipoTasa
						WHEN VarTasaFija        THEN    SET VarInteres  := (Par_Monto * VarDias * Par_TasaFija) / (VarDiasInver*Entero_Cien);
						WHEN VarTasaVariable    THEN    SET VarInteres  := Decimal_Cero;
					END CASE;

					SET VarInteres := IFNULL(VarInteres, Decimal_Cero);

					/* PARA PERSONA FISICA/ FISICA ACT EMPRESARIAL:
					* SI EL MONTO DE CEDE es MAYOR O IGUAL A 5 Salario minimo General Anualizado Distrito Federal segun DF,(SMAGDF),
					* entonces se aplica el calculo de ISR PERO SOBRE EL EXCEDENTE DE CAPITAL NO SOBRE EL CAPITAL ORIGINAL,
					* si no es CERO
					PARA PERSONA MORAL:
					* NO IMPORTA SI EL MONTO DE CEDE es MAYOR O IGUAL A 5 Salario minimo General Anualizado Distrito Federal segun DF,(SMAGDF),
					* si es persona moral el calculo del ISR se aplica PERO SOBRE TODO EL CAPITAL ORIGINAL,
					* si no es CERO
					*/
					/* Si el cliente paga ISR entonces se calcula el interes a Retener , sino su valor sera cero*/
					IF (VarInteres > Decimal_Cero) THEN
						IF (Var_PagaISR = VarSi) THEN
							IF( Par_Monto > Var_SalMinAn OR Var_TipoPersona = Per_Moral )THEN
								IF(Var_TipoPersona = Per_Moral)THEN
									SET VarISR = ROUND((Par_Monto * VarDias * Var_TasaISR) / (Factor_Porcen * VarDiasInver), 2);
								ELSE
									SET VarISR = ROUND(((Par_Monto-Var_SalMinAn) * VarDias * Var_TasaISR) / (Factor_Porcen * VarDiasInver), 2);
								END IF;
							ELSE
								SET VarISR = Decimal_Cero;
							END IF;
						ELSE
							SET VarISR = Decimal_Cero;
						END IF;
					ELSE
						SET VarISR = Decimal_Cero;
					END IF;

					SET VarISR      := IFNULL(VarISR, Decimal_Cero);

					IF( VarDiaGenerado >= Par_FechaVencimiento) THEN
						-- PARA LA ULTIMA  CUOTA SE OBTIENE LA DIFERENCIA ENTRE EL ACUMULADO Y LO QUE SE CALCULO ORIGINAL
						SET VarInteresAcum  := (SELECT SUM(Interes) FROM TMPSIMULADORCEDE WHERE NumTransaccion= Aud_NumTransaccion);
						SET VarInteresAcum  := IFNULL(VarInteresAcum,VarInteres);
						SET VarISRAcum      := (SELECT SUM(ISR)     FROM TMPSIMULADORCEDE WHERE NumTransaccion= Aud_NumTransaccion);
						SET VarISRAcum      := IFNULL(VarISRAcum,VarISR);
						IF((VarInteresTotal- VarInteresAcum) = Decimal_Cero) THEN
							SET VarInteres := VarInteres;
						ELSE
							SET VarInteres      := VarInteresTotal- VarInteresAcum;
						END IF;
						IF((VarISRTotal- VarISRAcum) = Decimal_Cero) THEN
							SET VarISR := VarISR;
						ELSE
							SET VarISR          := VarISRTotal- VarISRAcum;
						END IF;
						SET VarTotal        := Par_Monto + VarInteres - VarISR;

					ELSE
						SET VarTotal        := VarInteres - VarISR;
					END IF;

					-- SE INSERTA EN LA TABLA DE SIMULACION
					INSERT INTO TMPSIMULADORCEDE (
						NumTransaccion,     Consecutivo,    Fecha,          FechaPago,      Capital,
						Interes,            ISR,            Total,          Dias,           FechaInicio)
					VALUES(
						Aud_NumTransaccion, VarConsecutivo, VarDiaGenerado, VarFechaPago,   VarCapital,
						VarInteres,         VarISR,         VarTotal,       VarDias,        VarFechaInicio);

				END IF;
				SET VarFechaInicio  := VarDiaGenerado;
				SET FechaVenOri := VarFechaInicio;
			END WHILE; -- FIN WHILE
		END IF;

		SET Par_NumErr  := 0;
		SET Par_ErrMen  := 'Simulacion Realizada Exitosamente.';

	END ManejoErrores; #fin del manejador de errores

	-- SE CALCULA EL ISR INFORMATIVO SÓLO SI ESTA ACTIVO
	SET Var_EstatusISR	:= (SELECT Estatus FROM ISRPARAM ORDER BY FechaActual DESC LIMIT 1);
	SET Var_EstatusISR	:= IFNULL(Var_EstatusISR, Cadena_Vacia);
	SET VarDias			:= (SELECT SUM(Dias) FROM TMPSIMULADORCEDE WHERE NumTransaccion = Aud_NumTransaccion);

	/*SE SUMARIZAN LAS COLUMNAS PARA LOS TOTALES */
	SELECT      SUM(Capital) AS Capital,    SUM(Interes) AS Interes,    SUM(ISR) AS ISR,    SUM(Total) AS Total
		INTO    VarTotalCapital,            VarTotalInteres,            VarTotalISR,        VarTotalFinal
		FROM    TMPSIMULADORCEDE
		WHERE   NumTransaccion = Aud_NumTransaccion;

	/* se realiza el SELECT para obtener el calendario */
	IF(Par_Salida=VarSi) THEN
		SELECT 		NumTransaccion,		Consecutivo,		Fecha,          FechaPago,      	Capital,
					Interes,
					IF(Var_EstatusISR = EstatusActivo, FNISRINFOCAL(Capital, VarDias, (Var_TasaISR*Factor_Porcen)), ISR) AS ISR,
					Total,				VarTotalCapital,	VarTotalInteres,
					IF(Var_EstatusISR = EstatusActivo, FNISRINFOCAL(Capital, VarDias, (Var_TasaISR*Factor_Porcen)), VarTotalISR) AS VarTotalISR,
					VarTotalFinal
			FROM 	TMPSIMULADORCEDE
			WHERE 	NumTransaccion = Aud_NumTransaccion;
	END IF;

END TerminaStore$$