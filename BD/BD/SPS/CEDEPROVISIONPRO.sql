-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CEDEPROVISIONPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CEDEPROVISIONPRO`;DELIMITER $$

CREATE PROCEDURE `CEDEPROVISIONPRO`(
# ==================================================================
# -------- SP QUE GENERA EL DEVENGAMIENTO DIARIO EN LAS CEDES-------
# ==================================================================
    Par_Fecha           DATE,				-- Fecha
    Par_EmpresaID       INT(11),			-- Numero de empresa
    Par_Salida          CHAR(1),			-- Indica si espera un SELECT de salida
    INOUT Par_NumErr    INT(11),			-- Numero de error
    INOUT Par_ErrMen    VARCHAR(400),		-- Descripcion de error

    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
			)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_CedeID              BIGINT(12);
	DECLARE Var_Monto               DECIMAL(12,2);
	DECLARE Var_TasaNeta            DECIMAL(8,4);
	DECLARE Var_Tasa                DECIMAL(8,4);
	DECLARE Var_FechaInicio         DATE;
	DECLARE Var_FechaVencimiento    DATE;
	DECLARE Var_MonedaID            INT(11);
	DECLARE Var_MonedaBase          INT(11);
	DECLARE Var_TipoCambio          DECIMAL(14,6);
	DECLARE Var_Empresa             INT(11);
	DECLARE Var_SaldoProvision      DECIMAL(12,2);
	DECLARE Var_InteresGenerado		DECIMAL(12,2);
	DECLARE Var_TasaISR             DECIMAL(8,4);
	DECLARE Var_Dias                INT(11);
	DECLARE Var_DiasBase            INT(11);
	DECLARE Var_Provision           DECIMAL(12,2);
	DECLARE Var_Instrumento         VARCHAR(20);
	DECLARE Var_Poliza              BIGINT(12);
	DECLARE Var_ProvMN              DECIMAL(12,2);
	DECLARE Con_Egreso              INT(11);
	DECLARE Error_Key               INT DEFAULT 0;
	DECLARE Var_InverStr            VARCHAR(15);
	DECLARE Var_ContadorInv         INT(11);
	DECLARE Var_SucCliente          INT(11);
	DECLARE Var_ClienteID           INT(11);
	DECLARE Var_CalculoInteres      INT(1);
	DECLARE Var_TasaBase            INT(2);
	DECLARE Var_SobreTasa           DECIMAL(12,4);
	DECLARE Var_PisoTasa            DECIMAL(12,4);
	DECLARE Var_TechoTasa           DECIMAL(12,4);
	DECLARE VarFecPago              DATE;
	DECLARE VarFecPagoAmo           DATE;
	DECLARE Var_FechaInicioAmo		DATE;
	DECLARE Var_FechaVencimAmo      DATE;
	DECLARE Var_SigFecha            DATE;
	DECLARE Var_InteresAmo          DECIMAL(18,2);
	DECLARE Var_UltimoDia           CHAR(1);
	DECLARE Var_SaldoProvAmo        DECIMAL(12,2);
	DECLARE Var_SaldoISR            DECIMAL(12,2);
	DECLARE Var_AmortizacionID      INT(11);
	DECLARE Var_TasaFV      		CHAR(1);
	DECLARE Fre_DiasAnio    		INT(3);
	DECLARE Var_SalMinDF    		DECIMAL(18,2);
	DECLARE Var_SalMinAn    		DECIMAL(18,2);
	DECLARE Var_ISR_pSocio			CHAR(1);				-- variable que guarda el valor si se
    DECLARE Var_FechaISR			DATE;					-- variable fecha de inicio cobro isr por socio
	DECLARE Var_TipoPagoInt 		CHAR(1); 				-- Indica si es a FIN DE MES (F) o al VENCIMIENTO (V) o por PERIODO(P)
	DECLARE Var_PagoIntCal			CHAR(2);				-- Especifica el tipo de pago de interes D - Devengado, I - Iguales
    DECLARE Var_IntRetenerAmo		DECIMAL(18,2);			-- Variable que guarda el interes a retener por amortizacion

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia    		CHAR(1);
	DECLARE Est_Vigente     		CHAR(1);
	DECLARE Salida_NO       		CHAR(1);
	DECLARE Salida_SI       		CHAR(1);
	DECLARE Fecha_Vacia     		DATE;
	DECLARE Tipo_Provision  		CHAR(4);
	DECLARE Decimal_Cero   			DECIMAL(12,2);
	DECLARE DECIMAL_Cien    		DECIMAL(12,2);
	DECLARE Nat_Cargo       		CHAR(1);
	DECLARE Nat_Abono       		CHAR(1);
	DECLARE Tip_Venta       		CHAR(1);
	DECLARE Ref_Provision   		VARCHAR(50);
	DECLARE Ope_Interna     		CHAR(1);
	DECLARE Pol_Automatica  		CHAR(1);
	DECLARE AltaPoliza_NO   		CHAR(1);
	DECLARE Mov_AhorroNO    		CHAR(1);
	DECLARE Con_ProCed      		INT(3);
	DECLARE Pro_Interes     		INT(3);
	DECLARE Con_EgresoGra   		INT(3);
	DECLARE Con_EgresoExe   		INT(3);
	DECLARE Var_Descripcion 		VARCHAR(50);
	DECLARE Var_Referencia  		VARCHAR(50);
	DECLARE Pro_CieDiaInv   		INT(11);
	DECLARE InicioMes       		DATE;
	DECLARE DiaOperacion    		INT(11);
	DECLARE TasaFija        		CHAR(1);
	DECLARE TasaVariable    		CHAR(1);
	DECLARE IniPs           		INT(1);
	DECLARE IniPsPiTe       		INT(1);
	DECLARE AperPs          		INT(1);
	DECLARE AperPsPiTe      		INT(1);
	DECLARE PromPs          		INT(1);
	DECLARE PromPsPiTe      		INT(1);
	DECLARE NO_UltimoDia    		CHAR(1);
	DECLARE SI_UltimoDia    		CHAR(1);
	DECLARE ErrorSQL        		VARCHAR(100);
	DECLARE ErrorAlta       		VARCHAR(100);
	DECLARE ErrorLlamada    		VARCHAR(100);
	DECLARE ErrorValorNulo  		VARCHAR(100);
	DECLARE Entero_Cero     		INT(3);
	DECLARE DecimalCero     		DECIMAL(1,1);
	DECLARE ConsCien        		INT(3);
	DECLARE Cons360         		INT(3);
	DECLARE Const_NO        		CHAR(1);
	DECLARE ISRpSocio				VARCHAR(10);
    DECLARE SI_Isr_Socio  			CHAR(1);
    DECLARE ValorUMA				VARCHAR(15);
	DECLARE FinMes					CHAR(1);
	DECLARE IntDevengado			CHAR(1);
	DECLARE IntIguales				CHAR(1);

	DECLARE CURSORINVER CURSOR FOR
		SELECT  CedeID,         Monto,                  tasaFV,         Tasa,           TasaNeta,
				TipoPagoInt,	PagoIntCal,				CalculoInteres, TasaBase,		SobreTasa,
                PisoTasa,       TechoTasa,				FechaInicio,    FechaVencimiento,MonedaID,
                SaldoProvision, InteresGenerado,		TasaISR,        EmpresaID,		SucursalOrigen,
                ClienteID,      FechaPago,				FechaPagoAmo,   FechaInicioAmo,	FechaVencimAmo,
                InteresAmo,     IntRetenerAmo,			SaldoProvAmo,   ISRDiario,		AmortizacionID
			FROM	TMPRENDIMIENTOCEDES
			WHERE 	FechaCalculo	= Par_Fecha;

	-- Asignacion de Constantes
	SET Cadena_Vacia    			:= '';                  			-- Constante Cadena Vacia
	SET Est_Vigente    				:= 'N';                 			-- Estatus Vigente
	SET Salida_NO       			:= 'N';                				-- Constante Salida No
	SET Salida_SI       			:= 'S';                 			-- Constante Salida No
	SET Fecha_Vacia     			:= '1900-01-01';       				-- Constante Fecha Vacia
	SET Tipo_Provision  			:= '100';              				-- Tipo de Provision
	SET Decimal_Cero   				:= 0.00;               				-- Constante DECIMAL Cero
	SET DECIMAL_Cien   				:= 100.00;              			-- Constante DECIMAL Cien
	SET Nat_Cargo       			:= 'C';                 			-- Constante Cargo
	SET Nat_Abono       			:= 'A';                 			-- Constante Abono
	SET Tip_Venta       			:= 'V';                 			-- Tipo de Venta
	SET Ref_Provision   			:= 'PROVISION DE CEDES';			-- Descripcion Provision de Cedes
	SET Ope_Interna     			:= 'I';                				-- Operacion Interna
	SET Pol_Automatica  			:= 'A';                 			-- Constante Poliza Automatica
	SET AltaPoliza_NO   			:= Est_Vigente;         			-- Constante Alta Poliza No
	SET Mov_AhorroNO    			:= Est_Vigente;         			-- Movimiento de Ahorro No
	SET Con_ProCed      			:= 901;                 			-- Provision TABLA CONCEPTOSCONTA
	SET Pro_Interes     			:= 5;                  				-- Movimiento Provision de Interes
	SET Con_EgresoGra   			:= 2;                   			-- Constante Gravado
	SET Con_EgresoExe   			:= 3;                   			-- Constante Excento
	SET Var_Descripcion 			:= 'PROVISION CEDE. VENTA DIVISA';  -- descripcion Provision
	SET Var_Referencia  			:= 'PROVISION CEDE. CIERRE DIA';    -- Descripcion Cierre Dia
	SET Pro_CieDiaInv   			:= 1300;                            -- Proceso Batch
	SET InicioMes       			:=  CONVERT(CONCAT(EXTRACT(YEAR_MONTH FROM Par_Fecha),'01'),DATE);
	SET DiaOperacion    			:= DAY(Par_Fecha);                  -- Dia de la Opeacion.
	SET TasaFija        			:= 'F';                             -- Tasa Fija.
	SET TasaVariable    			:= 'V';                             -- Tasa Variable.
	SET IniPs           			:= 2;                               -- Tasa Inicio de Mes + Puntos.
	SET IniPsPiTe       			:= 5;                               -- Tasa Inicio de Mes + Puntos con Piso y Techo.
	SET AperPs          			:= 3;                               -- Tasa Apertura + Puntos.
	SET AperPsPiTe      			:= 6;                               -- Tasa Apertura + Puntos con Piso y Techo.
	SET PromPs          			:= 4;                               -- Tasa Promedio del Mes + Puntos.
	SET PromPsPiTe      			:= 7;                               -- Tasa Promedio del Mes + Puntos con Piso y Techo.
	SET NO_UltimoDia    			:= 'N';
	SET SI_UltimoDia    			:= 'S';                             -- Un Dia Habil.
	SET ErrorSQL        			:= 'ERROR DE SQL GENERAL';          -- Manejo de errores
	SET ErrorAlta       			:= 'ERROR EN ALTA, LLAVE DUPLICADA';-- Manejo de errores
	SET ErrorLlamada    			:= 'ERROR AL LLAMAR A STORE PROCEDURE'; -- Manejo de errores
	SET ErrorValorNulo  			:= 'ERROR VALORES NULOS';           -- Manejo de errores
	SET Entero_Cero     			:= 0;                               -- Entero en Cero
	SET DecimalCero     			:= 0.0;
	SET ConsCien        			:= 100;
	SET Cons360         			:= 360;
	SET Const_NO        			:= 'N';
    SET Var_SigFecha    			:= DATE_ADD(Par_Fecha, INTERVAL 1 DAY);
	SET ISRpSocio					:= 'ISR_pSocio';					-- constante para isr por socio de PARAMGENERALES
	SET SI_Isr_Socio				:= 'S';								-- constante para saber si se calcula el isr por socio
	SET ValorUMA					:='ValorUMABase';
	SET FinMes 						:= 'F';								-- Indica que se trata de pagos al fin de mes
	SET IntDevengado				:= 'D';								-- Tipo de pago de interes DEVENGADO
	SET IntIguales	 				:= 'I';
	ManejoErrores:BEGIN
	   DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion.Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-CEDEPROVISIONPRO');
			END;

		TRUNCATE TABLE TMPTASASPROMEDIO;
		TRUNCATE TABLE TMPRENDIMIENTOCEDES;
        TRUNCATE TABLE TMPRENDICEDESISR;
		DELETE FROM RENDIMIENTOCEDES WHERE FechaCalculo = Par_Fecha;

		SELECT        SalMinDF,		FechaISR
			INTO       Var_SalMinDF,	Var_FechaISR
				FROM    PARAMETROSSIS;


		SELECT ValorParametro INTO Var_ISR_pSocio
			FROM 	PARAMGENERALES
			WHERE 	LlaveParametro	= ISRpSocio;

        SELECT ValorParametro
			INTO Fre_DiasAnio
			FROM PARAMGENERALES
		WHERE LlaveParametro=ValorUMA;

		SET Var_SalMinAn    := Var_SalMinDF * 5 * Fre_DiasAnio;  /* Salario minimo General Anualizado*/
		SET Var_ISR_pSocio	:= IFNULL(Var_ISR_pSocio , Const_NO);
		SET Var_FechaISR	:= IFNULL(Var_FechaISR , Par_Fecha);

		INSERT INTO TMPTASASPROMEDIO (TasaBaseID, ValorProm)
		SELECT TasaBaseID,(SUM(Valor)/DiaOperacion)
			FROM CALHISTASASBASE
			WHERE Fecha>=InicioMes AND Fecha <=Par_Fecha
			GROUP BY TasaBaseID;

		UPDATE TMPTASASPROMEDIO
			SET EmpresaID       =   Par_EmpresaID,
				Usuario         =   Aud_Usuario,
				FechaActual     =   Aud_FechaActual,
				DireccionIP     =   Aud_DireccionIP,
				ProgramaID      =   Aud_ProgramaID,
				Sucursal        =   Aud_Sucursal,
				NumTransaccion  =   Aud_NumTransaccion;


		INSERT INTO TMPRENDIMIENTOCEDES
		SELECT      cede.CedeID,            Par_Fecha,              cede.Monto,             cede.TipoCedeID,		cede.TipoPagoInt,
					cede.DiasPeriodo,		cede.PagoIntCal,		tipo.tasaFV,        	cede.TasaFija,          cede.TasaNeta,
                    cede.CalculoInteres,    cede.TasaBase,          cede.SobreTasa,			cede.PisoTasa,          cede.TechoTasa,
                    cede.FechaInicio,       cede.FechaVencimiento,  cede.MonedaID,      	cede.SaldoProvision,    cede.InteresGenerado,
                    DecimalCero,            Suc.TasaISR,            cte.PagaISR,        	cede.EmpresaID,         cte.SucursalOrigen,
                    cte.ClienteID,          cede.FechaPago,         amo.FechaPago,          amo.FechaInicio,		amo.FechaVencimiento,
                    amo.Interes,            amo.InteresRetener,		amo.SaldoProvision,     amo.AmortizacionID,		cte.TipoPersona
			FROM 	CEDES cede INNER JOIN AMORTIZACEDES amo ON cede.CedeID = amo.CedeID
					INNER JOIN TIPOSCEDES tipo ON cede.TipoCedeID=tipo.TipoCedeID
					INNER JOIN CLIENTES cte ON cede.ClienteID=cte.ClienteID
					INNER JOIN SUCURSALES   Suc ON  Suc.SucursalID =cte.SucursalOrigen
			WHERE 	cede.Estatus      		= Est_Vigente
            AND 	amo.Estatus				= Est_Vigente
			AND 	cede.ClienteID    		= cede.ClienteID
			AND 	cede.FechaInicio  		<= Par_Fecha
			AND 	cede.FechaVencimiento	> Par_Fecha
			AND 	amo.FechaInicio       	<= Par_Fecha
			AND 	amo.FechaVencimiento  	> Par_Fecha;

		-- -------------------------------------------------------------------------------------------
		-- Se Actualiza el Valor de la la Tasa para el Tipo de Calculo
		-- Tasa Inicio de Mes + Puntos y Tasa Inicio de Mes + Puntos con Piso y Techo
		-- -------------------------------------------------------------------------------------------
		UPDATE TMPRENDIMIENTOCEDES inver
			INNER JOIN CALHISTASASBASE tasa ON inver.TasaBase=tasa.TasaBaseID
			SET inver.Tasa		= tasa.Valor
		WHERE 	inver.TasaFV	= TasaVariable
        AND 	(inver.CalculoInteres=IniPs OR inver.CalculoInteres = IniPsPiTe)
		AND 	tasa.Fecha		= InicioMes
        AND 	FechaCalculo	= Par_Fecha;
		-- -------------------------------------------------------------------------------------------
		-- Se Actualiza el Valor de la Tasa para el el Tipo de Calculo
		-- Tasa de Apertuta + Puntos y Tasa de Apertura + Puntos con Piso y Techo
		-- -------------------------------------------------------------------------------------------
		UPDATE TMPRENDIMIENTOCEDES inver
			INNER JOIN CALHISTASASBASE tasa ON inver.TasaBase=tasa.TasaBaseID
				SET inver.Tasa		= tasa.Valor
			WHERE 	inver.TasaFV	= TasaVariable
            AND 	(inver.CalculoInteres = AperPs OR inver.CalculoInteres = AperPsPiTe)
			AND 	tasa.Fecha		= inver.FechaInicio
            AND 	FechaCalculo	= Par_Fecha;
		-- -------------------------------------------------------------------------------------------
		-- Se Actualiza el Valor de la Tasa para el Tipo de Calculo
		-- Tasa Promedio  del Mes + Puntos y Tasa Promedio del Mes + Puntos con Piso y Techo
		-- -------------------------------------------------------------------------------------------
		UPDATE TMPRENDIMIENTOCEDES inver
			INNER JOIN TMPTASASPROMEDIO prom ON inver.TasaBase=prom.TasaBaseID
				SET inver.Tasa		= prom.ValorProm
			WHERE 	inver.TasaFV	= TasaVariable
            AND 	(inver.CalculoInteres = PromPs OR inver.CalculoInteres = PromPsPiTe)
			AND 	FechaCalculo	= Par_Fecha;

		TRUNCATE TABLE TMPTASASPROMEDIO;
		SELECT DiasInversion, MonedaBaseID INTO Var_DiasBase, Var_MonedaBase
			FROM PARAMETROSSIS;


		SELECT COUNT(CedeID) INTO Var_ContadorInv
			FROM 	TMPRENDIMIENTOCEDES
			WHERE 	FechaCalculo	= Par_Fecha;

		SET Var_ContadorInv := IFNULL(Var_ContadorInv, Entero_Cero);

    -- -------------------------------------------------------------------------------------------------------------------------------------------------------------------
    -- -------------Calculo del ISR Diario--------------------------------------------------------------------------------------------------------------------------------
    -- -------------------------------------------------------------------------------------------------------------------------------------------------------------------
	            -- Cuando sea persona moral siempre se le debe retener ISR sobre el monto total sin contemplar exencion alguna.


				IF(Var_ISR_pSocio=SI_Isr_Socio) THEN

                -- Personas diferentes de morales
                UPDATE  TMPRENDIMIENTOCEDES rendi
					INNER JOIN AMORTIZACEDES Amo
						ON rendi.AmortizacionID=Amo.AmortizacionID
							AND rendi.CedeID=Amo.CedeID  SET
					rendi.ISRDiario =   CASE WHEN PagaISR=Const_NO THEN
													 DecimalCero
												ELSE
														CASE WHEN  rendi.Monto > Var_SalMinAn
															THEN ROUND(
																IF(((Amo.FechaPago > Amo.FechaVencimiento AND (DATEDIFF(Amo.FechaVencimiento, Var_SigFecha) = 0)) OR (Amo.FechaVencimiento >= Amo.FechaPago AND (DATEDIFF(Amo.FechaPago, Var_SigFecha) = 0))),
																(((rendi.Monto-Var_SalMinAn) * (DATEDIFF(Amo.FechaVencimiento,Par_Fecha)) * rendi.TasaISR) / (ConsCien * Fre_DiasAnio)),
																(((rendi.Monto-Var_SalMinAn) * 1 * rendi.TasaISR) / (ConsCien * Fre_DiasAnio)))
																- IF(((Amo.FechaPago > Amo.FechaVencimiento AND (DATEDIFF(Amo.FechaVencimiento, Var_SigFecha) = 0)) OR (Amo.FechaVencimiento >= Amo.FechaPago AND (DATEDIFF(Amo.FechaPago, Var_SigFecha) = 0))),
														FNCALCULAISRREST(Amo.FechaVencimiento, Par_Fecha, (rendi.Monto-Var_SalMinAn)),0.0), 2)
													ELSE DecimalCero END
												 END
					WHERE rendi.InteresGenerado>DecimalCero
						AND rendi.FechaCalculo=Par_Fecha
                        AND rendi.TipoPersona <> 'M';

				-- Personasa morales
                UPDATE  TMPRENDIMIENTOCEDES rendi
					INNER JOIN AMORTIZACEDES Amo
						ON rendi.AmortizacionID=Amo.AmortizacionID
							AND rendi.CedeID=Amo.CedeID  SET
					rendi.ISRDiario =   CASE WHEN PagaISR=Const_NO THEN
													 DecimalCero
												ELSE
													ROUND(
														IF(((Amo.FechaPago > Amo.FechaVencimiento AND (DATEDIFF(Amo.FechaVencimiento, Var_SigFecha) = 0)) OR (Amo.FechaVencimiento >= Amo.FechaPago AND (DATEDIFF(Amo.FechaPago, Var_SigFecha) = 0))),
														((rendi.Monto * (DATEDIFF(Amo.FechaVencimiento,Par_Fecha)) * rendi.TasaISR) / (ConsCien * Fre_DiasAnio)),
														((rendi.Monto * 1 * rendi.TasaISR) / (ConsCien * Fre_DiasAnio)))
														- IF(((Amo.FechaPago > Amo.FechaVencimiento AND (DATEDIFF(Amo.FechaVencimiento, Var_SigFecha) = 0)) OR (Amo.FechaVencimiento >= Amo.FechaPago AND (DATEDIFF(Amo.FechaPago, Var_SigFecha) = 0))),
													FNCALCULAISRREST(Amo.FechaVencimiento, Par_Fecha, rendi.Monto),0.0), 2)

												 END
					WHERE rendi.InteresGenerado>DecimalCero
						AND rendi.FechaCalculo=Par_Fecha
                        AND rendi.TipoPersona = 'M';

				ELSE

					UPDATE  TMPRENDIMIENTOCEDES rendi
						INNER JOIN AMORTIZACEDES Amo ON rendi.AmortizacionID=Amo.AmortizacionID AND rendi.CedeID=Amo.CedeID SET
							rendi.ISRDiario = CASE WHEN PagaISR=Const_NO THEN
													DecimalCero
												ELSE
													CASE WHEN  rendi.Monto > Entero_Uno THEN

													ROUND(
														IF(((Amo.FechaPago > Amo.FechaVencimiento AND (DATEDIFF(Amo.FechaVencimiento, Var_SigFecha) = 0))
															OR (Amo.FechaVencimiento >= Amo.FechaPago AND (DATEDIFF(Amo.FechaPago, Var_SigFecha) = 0))),
															(((rendi.Monto) * (DATEDIFF(Amo.FechaVencimiento,Par_Fecha)) * rendi.TasaISR) / (ConsCien * Fre_DiasAnio)),
															(((rendi.Monto) * 1 * rendi.TasaISR) / (ConsCien * Fre_DiasAnio)))
														-
														IF(((Amo.FechaPago > Amo.FechaVencimiento AND (DATEDIFF(Amo.FechaVencimiento, Var_SigFecha) = 0))
															OR (Amo.FechaVencimiento >= Amo.FechaPago AND (DATEDIFF(Amo.FechaPago, Var_SigFecha) = 0))),
															FNCALCULAISRREST(Amo.FechaVencimiento, Par_Fecha, rendi.Monto),0.0), 2)
													ELSE DecimalCero END
												   END
					WHERE rendi.InteresGenerado>DecimalCero AND rendi.FechaCalculo=Par_Fecha;
				END IF;

		-- -------------------------------------------------------------------------------------------
		-- Se registra la poliza contable
		-- -------------------------------------------------------------------------------------------

		IF (Var_ContadorInv > Entero_Cero) THEN
			CALL MAESTROPOLIZASALT(
				Var_Poliza,         Par_EmpresaID,      Par_Fecha,          Pol_Automatica,     Con_ProCed,
				Var_Referencia,     Salida_NO,       	Par_NumErr,         Par_ErrMen,			Aud_Usuario,
				Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;

		OPEN CURSORINVER;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				CICLOCURSORINVER:LOOP

					FETCH CURSORINVER INTO
						Var_CedeID,             Var_Monto,              Var_TasaFV,         Var_Tasa,           Var_TasaNeta,
						Var_TipoPagoInt,		Var_PagoIntCal,			Var_CalculoInteres, Var_TasaBase,		Var_SobreTasa,
                        Var_PisoTasa,       	Var_TechoTasa,			Var_FechaInicio,	Var_FechaVencimiento,Var_MonedaID,
                        Var_SaldoProvision, 	Var_InteresGenerado,	Var_TasaISR,		Var_Empresa,		Var_SucCliente,
                        Var_ClienteID,      	VarFecPago,				VarFecPagoAmo,		Var_FechaInicioAmo,	Var_FechaVencimAmo,
                        Var_InteresAmo,     	Var_IntRetenerAmo,		Var_SaldoProvAmo,   Var_SaldoISR,		Var_AmortizacionID;
					START TRANSACTION;
					Transaccion:BEGIN
						DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1;
						DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Error_Key = 2;
						DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Error_Key = 3;
						DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Error_Key = 4;
						DECLARE EXIT HANDLER FOR NOT FOUND SET Error_Key = 1;

						SET Error_Key       := Entero_Cero;
						SET Var_Provision   := Entero_Cero;
						SET Var_Dias        := Entero_Cero;
						SET Var_ProvMN      := Entero_Cero;
						SET Var_TipoCambio  := Entero_Cero;
						SET Var_InverStr    := Cadena_Vacia;
						SET Con_Egreso      := Entero_Cero;
						SET Var_UltimoDia   := NO_UltimoDia;

						-- -------------------------------------------------------------------------------------------
						-- valida si es la ultima fecha de pago de la amorticacion
						-- -------------------------------------------------------------------------------------------

						IF ((VarFecPagoAmo > Var_FechaVencimAmo AND (DATEDIFF(Var_FechaVencimAmo, Var_SigFecha) = 0)) OR
							 (Var_FechaVencimAmo >= VarFecPagoAmo AND (DATEDIFF(VarFecPagoAmo, Var_SigFecha) = 0)) ) THEN
								SET Var_UltimoDia := SI_UltimoDia;

						END IF;

						-- -------------------------------------------------------------------------------------------
						-- si no es el ultimo dia de pagode la amortizacion
						-- el saldo provision de calcula por un dia
						-- -------------------------------------------------------------------------------------------
						IF(Var_UltimoDia = NO_UltimoDia) THEN
							IF(Var_TipoPagoInt = FinMes AND	Var_PagoIntCal = IntIguales)THEN

								SET Var_Dias		:= DATEDIFF(Var_FechaVencimAmo, Var_FechaInicioAmo);
								SET Var_Provision	:= ROUND((Var_InteresAmo/Var_Dias),2);
							ELSE
								SET Var_Dias 		:= 1;
								SET Var_Provision   := ROUND(Var_Monto * Var_Tasa * Var_Dias / (Var_DiasBase * DECIMAL_Cien), 2);

                            END IF;
						ELSE
						-- -------------------------------------------------------------------------------------------
						-- si es tasa fija y es el ultimo dia de pago
						-- ajusta la ultima la provision
						-- -------------------------------------------------------------------------------------------
                            IF(Var_TasaFV = TasaFija) THEN
								SET Var_Provision := ROUND(Var_InteresAmo - IFNULL(Var_SaldoProvAmo, Entero_Cero),2);
							ELSE
								SET Var_Dias := DATEDIFF(VarFecPagoAmo, Par_Fecha);
							END IF;

						END IF;

						IF(Var_TasaFV = TasaVariable) THEN

							SET Var_Provision := FNRENINVERSION(Var_CalculoInteres, Var_Monto,
																Var_Dias,           Var_DiasBase,
																Var_Tasa,           Var_SobreTasa,
																Var_PisoTasa,       Var_TechoTasa);
						END IF;


						IF (Var_Provision > Entero_Cero) THEN
				-- -------------------------------------------------------------------------------------------
				-- Proceso para dar de alta el movimiento de la cede
				-- -------------------------------------------------------------------------------------------
							CALL CEDESMOVALT(
								Var_CedeID,         Par_Fecha,      Tipo_Provision,     Var_Provision,      Nat_Cargo,
								Ref_Provision,      Var_MonedaID,   Salida_NO,          Par_NumErr,         Par_ErrMen,
								Var_Empresa,        Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
								Aud_Sucursal,       Aud_NumTransaccion);

							IF (Par_NumErr <> Entero_Cero)THEN
								SET Error_Key := 99;
								LEAVE Transaccion;
							END IF;
				-- -------------------------------------------------------------------------------------------
				-- Se realiza la contabilidad de la cede
				-- -------------------------------------------------------------------------------------------
							CALL CONTACEDESPRO (
								Var_CedeID,         Var_Empresa,    Par_Fecha,          Var_Provision,      Cadena_Vacia,
								Con_ProCed,         Pro_Interes,    Entero_Cero,        Nat_Abono,          AltaPoliza_NO,
								Mov_AhorroNO,       Salida_NO,      Var_Poliza,         Par_NumErr,         Par_ErrMen,
								Entero_Cero,        Var_ClienteID,  Var_MonedaID,       Aud_Usuario,        Aud_FechaActual,
								Aud_DireccionIP,    Aud_ProgramaID, Var_SucCliente,     Aud_NumTransaccion);

							IF (Par_NumErr <> Entero_Cero)THEN
								SET Error_Key := 99;
								LEAVE Transaccion;
							END IF;

							IF (Var_MonedaID != Var_MonedaBase) THEN
								SELECT  TipCamVenInt INTO Var_TipoCambio
									FROM MONEDAS
									WHERE MonedaId = Var_MonedaID;

								SET Var_ProvMN := ROUND((Var_Provision * Var_TipoCambio), 2);

							ELSE
								SET Var_ProvMN := Var_Provision;

							END IF;
							IF (Var_TasaISR = Decimal_Cero) THEN
								SET Con_Egreso := Con_EgresoExe;
							ELSE
								SET Con_Egreso := Con_EgresoGra;
							END IF;
				-- -------------------------------------------------------------------------------------------
				-- Se realiza la contabilidad de la cede
				-- -------------------------------------------------------------------------------------------
							CALL CONTACEDESPRO (
								Var_CedeID,         Var_Empresa,    Par_Fecha,          Var_ProvMN,         Cadena_Vacia,
								Con_ProCed,         Con_Egreso,     Entero_Cero,        Nat_Cargo,          AltaPoliza_NO,
								Mov_AhorroNO,       Salida_NO,      Var_Poliza,         Par_NumErr,         Par_ErrMen,
								Entero_Cero,        Var_ClienteID,  Var_MonedaBase,     Aud_Usuario,        Aud_FechaActual,
								Aud_DireccionIP,    Aud_ProgramaID, Var_SucCliente,     Aud_NumTransaccion);

						   IF (Par_NumErr <> Entero_Cero)THEN
								SET Error_Key := 99;
								LEAVE Transaccion;
							END IF;

							IF (Var_MonedaID != Var_MonedaBase) THEN
								SELECT  TipCamVenInt INTO Var_TipoCambio
									FROM MONEDAS
									WHERE MonedaId = Var_MonedaID;

								SET Var_Instrumento := CONVERT(Var_CedeID, CHAR);

								CALL COMVENDIVISAALT(
									Var_MonedaID,       Aud_NumTransaccion, Par_Fecha,          Var_Provision,      ROUND(Var_TipoCambio,2),
									Ope_Interna,        Tip_Venta,          Var_Instrumento,    Var_Referencia,     Var_Descripcion,
									Var_Poliza,        	Var_Empresa,       	Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
                                    Aud_ProgramaID,     Var_SucCliente,    	Aud_NumTransaccion);

							END IF;

				-- -------------------------------------------------------------------------------------------
				-- Se actualiza el saldo provision
				-- -------------------------------------------------------------------------------------------
							UPDATE CEDES SET
									SaldoProvision	= SaldoProvision + Var_Provision
							WHERE   CedeID			= Var_CedeID;

							UPDATE AMORTIZACEDES SET
									SaldoProvision	= SaldoProvision + Var_Provision
							WHERE   CedeID 			= Var_CedeID
							AND     AmortizacionID 	= Var_AmortizacionID;

							UPDATE TMPRENDIMIENTOCEDES
								SET SaldoProvision  = Var_Provision
							WHERE 	CedeID 			= Var_CedeID
							AND 	FechaCalculo	= Par_Fecha;

						END IF;
					END Transaccion;

					SET Var_InverStr := CONVERT(Var_CedeID, CHAR);
					IF Error_Key = 0 THEN
						COMMIT;
					END IF;
					IF Error_Key = 1 THEN
						ROLLBACK;
						START TRANSACTION;

							CALL EXCEPCIONBATCHALT(
								Pro_CieDiaInv,  Par_Fecha,          Var_InverStr,       ErrorSQL,
								Var_Empresa,    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
								Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion);
						COMMIT;
					END IF;
					IF Error_Key = 2 THEN
						ROLLBACK;
						START TRANSACTION;
							CALL EXCEPCIONBATCHALT(
								Pro_CieDiaInv,  Par_Fecha,          Var_InverStr,       ErrorAlta,
								Var_Empresa,    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
								Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion);
						COMMIT;
					END IF;
					IF Error_Key = 3 THEN
						ROLLBACK;
						START TRANSACTION;
							CALL EXCEPCIONBATCHALT(
								Pro_CieDiaInv,      Par_Fecha,          Var_InverStr,       ErrorLlamada,
								Var_Empresa,        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
								Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);
						COMMIT;
					END IF;
					IF Error_Key = 4 THEN
						ROLLBACK;
						START TRANSACTION;
							CALL EXCEPCIONBATCHALT(
								Pro_CieDiaInv,  Par_Fecha,          Var_InverStr,       ErrorValorNulo,
								Var_Empresa,    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
								Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion);
						COMMIT;
					END IF;

					IF Error_Key = 99 THEN
						ROLLBACK;
						START TRANSACTION;
							CALL EXCEPCIONBATCHALT(
								Pro_CieDiaInv,  Par_Fecha,          Var_InverStr,       CONCAT(Par_NumErr,' - ',Par_ErrMen),
								Var_Empresa,    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
								Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion);
						COMMIT;
					END IF;
				END LOOP;
			END;
		CLOSE CURSORINVER;

		INSERT INTO RENDIMIENTOCEDES
		SELECT
			CedeID, 			FechaCalculo, 		Monto, 			TipoCedeID, 	TipoPagoInt,
            DiasPeriodo, 		PagoIntCal, 		TasaFV, 		Tasa, 			TasaNeta,
            CalculoInteres, 	TasaBase, 			SobreTasa, 		PisoTasa, 		TechoTasa,
            FechaInicio, 		FechaVencimiento, 	MonedaID, 		SaldoProvision, InteresGenerado,
            ISRDiario, 			TasaISR, 			PagaISR, 		EmpresaID, 		SucursalOrigen,
            ClienteID, 			FechaPago, 			FechaPagoAmo, 	FechaInicioAmo, FechaVencimAmo,
            InteresAmo, 		IntRetenerAmo, 		SaldoProvAmo, 	AmortizacionID
        FROM TMPRENDIMIENTOCEDES;

		SET Par_NumErr  := Entero_Cero;
		SET Par_ErrMen  := 'Proceso Realizado Exitosamente: CEDEPROVISIONPRO';

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen;
	END IF;


END TerminaStore$$