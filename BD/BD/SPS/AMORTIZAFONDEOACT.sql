-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AMORTIZAFONDEOACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `AMORTIZAFONDEOACT`;DELIMITER $$

CREATE PROCEDURE `AMORTIZAFONDEOACT`(
/* SP QUE RECALCULA LOS INTERESES DE LOS CREDITOS AGRO EN PAGOS LIBRES */

    Par_CreditoID     	BIGINT(12),		# Numero de Credito
    Par_TipoAct			INT(11),		# Tipo de Actulizacion
	Par_TipoCalculoInteres	CHAR(1),		# Tipo de Calculo de interes P:FechaPactada: R:FechaReal
    Par_Salida        	CHAR(1),  		# Salida
	INOUT Par_NumErr	INT(11),		# Numero de error
	INOUT Par_ErrMen	VARCHAR(400),	# Mensaje de Error

    /*Parametros de Auditoria*/
    Par_EmpresaID     	INT(11),
	Aud_Usuario		    INT(11),
	Aud_FechaActual	    DATETIME,
	Aud_DireccionIP	    VARCHAR(15),
	Aud_ProgramaID	    VARCHAR(50),

	Aud_Sucursal		INT(11),
	Aud_NumTransaccion  BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_CreditoID      		BIGINT(12);
	DECLARE Var_AmortizacionID  	INT(11);
	DECLARE Var_SaldoCapVigente 	DECIMAL(14,4);
	DECLARE Var_SaldoCapVenNExi 	DECIMAL(14,4);
	DECLARE Var_FechaInicio     	DATE;
	DECLARE Var_FechaVencim     	DATE;
	DECLARE Var_FechaExigible   	DATE;
	DECLARE Var_AmoEstatus      	CHAR(1);
	DECLARE Var_SaldoInteresPro		DECIMAL(14,4);
	DECLARE	Var_SaldoIntNoConta		DECIMAL(14,4);
	DECLARE Var_ProvisionAcum   	DECIMAL(14,4);
	DECLARE Var_MonedaID        	INT(11);
	DECLARE Var_CalInteresID    	INT(11);
	DECLARE Var_Dias            	INT(11);
	DECLARE Var_TotCapital      	DECIMAL(14,4);
	DECLARE Var_Interes         	DECIMAL(14,4);
	DECLARE Var_IvaInt	        	DECIMAL(10,2);
	DECLARE Var_CreTasa         	DECIMAL(14,4);
	DECLARE Var_DiasCredito     	INT(11);
	DECLARE Var_ValIVAIntOr 		DECIMAL(14,4);
	DECLARE Var_SaldoCapital 		DECIMAL(14,4);
	DECLARE Insoluto		 		DECIMAL(14,4);
	DECLARE Var_FechaSistema    	DATE;
	DECLARE Var_IVAIntOrd   		CHAR(1);
	DECLARE Var_IVASucurs   		DECIMAL(8,4);
	DECLARE Var_TipoCalInteres		INT(11);
	DECLARE Var_Cuotas				INT(11);

	DECLARE Var_FechaCorte			DATE;
	DECLARE Var_FechaMinistrado		DATE;
	DECLARE Var_FechaFinMes			DATE;			# Indica el fin de mes de acuerdo a la fecha de inicio de la amortizacion
	DECLARE Var_FechaInicioMes		DATE;			# Indica la fecha de inicio de mes de acuerdo a la fecha de fin de mes
	DECLARE Var_InteresAcumulado 	DECIMAL(18,2);	# Interes Acumulado
    DECLARE Var_InteresInd			DECIMAL(14,2);	# Interes Individual
    DECLARE Var_PagaIVA				CHAR(1);		# Paga IVA
    DECLARE Var_Folio				VARCHAR(150); 	# Credito Activo Relacionado

    DECLARE Var_InteresRefinanciar	DECIMAL(18,2);	# Interes a Refinanciar(Meses anteriores)
    DECLARE Var_InteresAcumuladoR	DECIMAL(18,2);	# Interes Acumulado Real a la fecha actual
    DECLARE Var_AmortizacionVig		INT(11);		# Amortizacion vigente en curso
	DECLARE Var_FechMinisReal		DATE;			# Fecha real de la ministracion
    DECLARE Var_CredActivo			BIGINT(12);		# Numero del Credito Activo

	 -- Declaracion de Constantes
	DECLARE Cadena_Vacia    		CHAR(1);
	DECLARE Fecha_Vacia     		DATE;
	DECLARE Entero_Cero     		INT(11);
	DECLARE Decimal_Cero    		DECIMAL(14,4);
	DECLARE SiPagaIVA       		CHAR(1);
	DECLARE SalidaSI        		CHAR(1);
	DECLARE SalidaNO        		CHAR(1);
	DECLARE Esta_Pagado     		CHAR(1);
	DECLARE Esta_Activo     		CHAR(1);
	DECLARE Esta_Vencido    		CHAR(1);
	DECLARE Esta_Vigente    		CHAR(1);
	DECLARE Esta_Atrasado			CHAR(1);
	DECLARE TipoActInteres			INT(11);
	DECLARE CalculoSalInsol 		INT(11);
	DECLARE CalculoSalGlob  		INT(11);
	DECLARE Tasa_Fija       		INT(11);
	DECLARE Contador				INT(11);
	DECLARE FechaPactada			CHAR(1);
    DECLARE Est_Desembolsado		CHAR(1);

-- Declaracion del Cursor para actualizar los intereses de las amortizaciones
DECLARE CURSORAMOINTERES CURSOR FOR
    SELECT  Amo.CreditoFondeoID,    Amo.AmortizacionID,		Amo.SaldoCapVigente,    Cre.MonedaID,
			Amo.FechaInicio,    	Amo.FechaVencimiento,	Amo.FechaExigible,      (IFNULL(Amo.SaldoInteresPro, 0.00)) AS Provision
		 FROM AMORTIZAFONDEO Amo
		INNER JOIN CREDITOFONDEO Cre ON Cre.CreditoFondeoID =Amo.CreditoFondeoID
		  WHERE Cre.CreditoFondeoID   = Par_CreditoID
		  AND (Cre.Estatus    = Esta_Vigente)
		  AND Amo.Estatus	  = Esta_Vigente
        AND Amo.FechaExigible > Var_FechaSistema
		ORDER BY Amo.FechaExigible;

	-- Asignacion de Constantes
	SET Cadena_Vacia    := '';              	-- Cadena Vacia
	SET Fecha_Vacia     := '1900-01-01';    	-- Fecha Vacia
	SET Entero_Cero		:= 0;					-- Entero en Cero
	SET Decimal_Cero    := 0.00;            	-- Decimal en Cero
	SET SiPagaIVA       := 'S';             	-- El Cliente si Paga IVA
	SET SalidaSI        := 'S';             	-- El Store si Regresa una Salida
	SET SalidaNO        := 'N';             	-- El Store no Regresa una Salida
	SET Esta_Pagado     := 'P';             	-- Estatus del Credito: Pagado
	SET Esta_Activo     := 'A';             	-- Estatus: Activo
	SET Esta_Vencido    := 'B';             	-- Estatus del Credito: Vencido
	SET Esta_Vigente    := 'N';             	-- Estatus del Credito: Vigente
	SET TipoActInteres	:= 1;             		-- Tipo de Actualizacion: actualiza los intereses
	SET CalculoSalInsol	:= 1;					-- Calculo de Interes por Saldos Insolutos
	SET CalculoSalGlob	:= 2;					-- Calculo de Interes por Saldos Globales (Monto Original)
	SET Tasa_Fija       := 1;					-- CalInteresID para tasa fija
	SET FechaPactada	:= 'P';					-- Fecha pactada: P
	SET Est_Desembolsado	:= 'D';				-- Estatus Desembolsado:
ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-AMORTIZAFONDEOACT');
		END;

	SELECT 	FechaSistema, 		DiasCredito
	INTO 	Var_FechaSistema, 	Var_DiasCredito
		FROM PARAMETROSSIS;

	IF(IFNULL(Par_TipoAct,Entero_Cero)=TipoActInteres)THEN
		SELECT  Cre.TasaFija,		Cre.MonedaID,	Cre.CalcInteresID,	Cre.TipoCalInteres,	Cre.PagaIva,
				Cre.PorcentanjeIVA,	 Cre.Folio,			Cre.InteresAcumulado,		Cre.InteresRefinanciar
			INTO
				Var_CreTasa,	Var_MonedaID,	Var_CalInteresID,       Var_TipoCalInteres,	Var_PagaIVA,
                Var_ValIVAIntOr,	Var_Folio,			Var_InteresAcumuladoR,		Var_InteresRefinanciar
			FROM CREDITOFONDEO Cre
			WHERE Cre.CreditoFondeoID		= Par_CreditoID;

		IF (Var_PagaIVA = SiPagaIVA) THEN
			SET Var_ValIVAIntOr	:= IFNULL(Var_ValIVAIntOr/100,Decimal_Cero);
		ELSE
			SET Var_ValIVAIntOr	:= Decimal_Cero;
		END IF;

		SELECT  SUM(IFNULL(SaldoCapVigente, Entero_Cero)) INTO Var_SaldoCapital
		  FROM AMORTIZAFONDEO Amo
			WHERE CreditoFondeoID = Par_CreditoID
			  AND Amo.Estatus != Esta_Pagado;

		SET Var_SaldoCapital := IFNULL(Var_SaldoCapital,Decimal_Cero);
        # Se obtiene el numero del credito activo
		SET Var_CredActivo := (SELECT CreditoID FROM RELCREDPASIVOAGRO WHERE CreditoFondeoID = Par_CreditoID AND EstatusRelacion = Esta_Vigente);

        # Se obtiene la fecha en que se lleva acabo la ministración
		SET Var_FechMinisReal:= (SELECT  MAX(FechaMinistracion) FROM
									MINISTRACREDAGRO WHERE CreditoID = Var_CredActivo
									AND FechaMinistracion = Var_FechaSistema
                                    AND Numero != 1
                                    AND Estatus = Est_Desembolsado);

        SET Var_FechMinisReal := IFNULL(Var_FechMinisReal, Fecha_Vacia);

		SET Var_AmortizacionVig := (SELECT MIN(AmortizacionID) FROM AMORTIZAFONDEO WHERE Estatus = Esta_Vigente AND CreditoFondeoID  =  Par_CreditoID);
		SET Var_AmortizacionVig := IFNULL(Var_AmortizacionVig, Entero_Cero);

		IF(Var_SaldoCapital > Decimal_Cero AND Var_CalInteresID = Tasa_Fija AND Var_TipoCalInteres=CalculoSalInsol) THEN

			OPEN CURSORAMOINTERES;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				CICLOAMORTI:LOOP

				FETCH CURSORAMOINTERES INTO
					Var_CreditoID,      Var_AmortizacionID, 	Var_SaldoCapVigente,        Var_MonedaID,
					Var_FechaInicio,    Var_FechaVencim,    	Var_FechaExigible,      Var_ProvisionAcum;

				SET Var_ProvisionAcum		:= IFNULL(Var_ProvisionAcum, 	Decimal_Cero);
				SET Var_SaldoCapVigente 	:= IFNULL(Var_SaldoCapVigente, 	Decimal_Cero);
                SET Var_InteresInd			:= IFNULL(Var_InteresInd, 	Decimal_Cero);
                SET Var_InteresAcumulado 	:= Decimal_Cero;
				SET Var_Interes 			:= Decimal_Cero;
                SET Var_InteresRefinanciar 	:= IFNULL(Var_InteresRefinanciar, 	Decimal_Cero);
                SET Var_InteresAcumuladoR 	:= IFNULL(Var_InteresAcumuladoR, 	Decimal_Cero);


                IF(Var_AmortizacionID <> Var_AmortizacionVig OR Var_FechMinisReal = Var_FechaInicio OR Var_FechaInicio = Var_FechaSistema) THEN
					SET Var_InteresRefinanciar := Decimal_Cero;
					SET Var_InteresAcumuladoR := Decimal_Cero;
                END IF;

				SET Var_TotCapital  	:= Var_SaldoCapVigente;



                SET Var_FechaMinistrado	 := (SELECT FechaPagoMinis
												FROM MINISTRACREDAGRO
												WHERE FechaMinistracion = Var_FechaSistema
                                                AND FechaMinistracion >= Var_FechaInicio
                                                AND FechaMinistracion < Var_FechaVencim
                                                AND CreditoID = Var_Folio
                                                LIMIT 1);


                # Si la fecha de inicio de amortizacion es menor a la fecha del sistema
				IF(Var_FechaInicio  < Var_FechaSistema) THEN
					# Si el tipo de calculo de interes es a la Fecha pactada
                    IF(Par_TipoCalculoInteres = FechaPactada) THEN
						# La fecha de inicio sera la fecha pactada de la ministracion
						SET Var_FechaInicio := Var_FechaMinistrado;
                    ELSE
						# Si el tipo de calculo del interes es a la fecha real la fecha de inicio sera la fecha del sistema.
						SET Var_FechaInicio := Var_FechaSistema;
                    END IF;
				ELSE
					# Si la fecha de inicio no es menor a la fecha del sistema, entonces la fecha de inicio no cambia.
					SET Var_FechaInicio := Var_FechaInicio;
				END IF;

				SET Var_FechaCorte 	:= (SELECT LAST_DAY(Var_FechaInicio));
                # Se verifica si la fecha es Inicio de Mes para aumentar al monto base(Saldo de Capital) el interes acumulado)
				SET Var_FechaFinMes := (SELECT LAST_DAY(Var_FechaInicio));
				SET Var_FechaFinMes := IFNULL(Var_FechaFinMes, Fecha_Vacia);

                # Se obtiene la fecha de inicio del siguiente mes
				SET Var_FechaInicioMes := (SELECT DATE_ADD(Var_FechaFinMes, INTERVAL 1 DAY));
				SET Var_FechaInicioMes := IFNULL(Var_FechaInicioMes, Fecha_Vacia);


                WHILE (Var_FechaInicio<Var_FechaVencim) DO
					# Si la fecha de corte es menor a la fecha de vencimiento
					IF (Var_FechaCorte > Var_FechaVencim) THEN
						SET Var_FechaCorte := Var_FechaVencim;	# Fecha de corte es la fecha de vencimiento
					ELSE
						 SET Var_FechaCorte := Var_FechaCorte;	# Fecha de corte es la fecha de corte obtenida
					END IF;

                   # Si la fecha de corte es igual a la fecha de vencimiento
					IF(Var_FechaCorte = Var_FechaVencim) THEN
						# Se realiza el calculo para obtener el numero de dias
						SET Var_Dias := IFNULL((DATEDIFF(Var_FechaCorte,Var_FechaInicio)),Entero_Cero);
					ELSE
						# Se realiza el calculo para obtener el numero de dias y se le suma 1 para que el numero de  dias sea exacto
						SET Var_Dias := IFNULL((DATEDIFF(Var_FechaCorte,Var_FechaInicio)),Entero_Cero)+1;
					END IF;

                   # Si la fecha de inicio es mayor a la fecha del primer inicio de mes de la amortizacion
					IF(Var_FechaInicio >= Var_FechaInicioMes) THEN
						# El saldo capital es el Saldo del Capital + el interes acumulado del mes anterior

                        SET Var_InteresInd := ROUND((Var_InteresAcumulado + Var_SaldoCapital) * Var_Dias * Var_CreTasa / (Var_DiasCredito * 100.00),2);
                        SET Var_InteresAcumulado := Var_InteresAcumulado + Var_InteresInd;

					ELSE

                        SET Var_InteresInd := ROUND((Var_SaldoCapital + Var_InteresRefinanciar ) * Var_Dias * Var_CreTasa / (Var_DiasCredito * 100.00),2);
                        SET Var_InteresAcumulado := Var_InteresInd + Var_InteresAcumuladoR;

					END IF;

                    # Se obtiene el siguiente rango de fechas
                    SET Var_FechaInicio := (SELECT DATE_ADD(Var_FechaCorte,INTERVAL 1 DAY));
					SET Var_FechaCorte 	:= (SELECT LAST_DAY(Var_FechaInicio));

					IF (Var_FechaCorte > Var_FechaVencim) THEN
						SET Var_FechaCorte := Var_FechaVencim;
					ELSE
						 SET Var_FechaCorte := Var_FechaCorte;
					END IF;

                END WHILE;
              	# Si existe monto pendiente por desembolsar, el Interes sera el calculado anteriormente mas la provision acumulada
				SET Var_InteresAcumulado := ROUND(Var_InteresAcumulado + Var_ProvisionAcum,2);

                # Se actualizan los intereses en la tabla de AMORTIZAFONDEO
				UPDATE AMORTIZAFONDEO SET
					Interes = Var_InteresAcumulado,
					IVAInteres = ROUND(ROUND(Var_InteresAcumulado,2) * Var_ValIVAIntOr, 2)

					WHERE	CreditoFondeoID   = Var_CreditoID
					  AND	AmortizacionID  = Var_AmortizacionID;

				SET Var_SaldoCapital := Var_SaldoCapital - Var_TotCapital;

				END LOOP CICLOAMORTI;
			END;
			CLOSE CURSORAMOINTERES;

		END IF;
	END IF;

	SET Par_NumErr := Entero_Cero;
	SET Par_ErrMen := CONCAT('Los Intereses han sido Actualizados Correctamente. Credito: ',CONVERT(Par_CreditoID, CHAR(12)));

END ManejoErrores;

IF(Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
			Cadena_Vacia AS Control,
			Entero_Cero AS Consecutivo;
END IF;

END TerminaStore$$