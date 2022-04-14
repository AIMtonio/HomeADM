-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRECALCULOSALDOSCONTPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS CRECALCULOSALDOSCONTPRO;
DELIMITER $$


CREATE PROCEDURE CRECALCULOSALDOSCONTPRO(
# =======================================================================
# -- STORE DE GENERACION DE SALDOS PARA CREDITOSCONT CONTINGENTES-
# =======================================================================
  Par_Fecha             DATE,
  Par_EmpresaID         INT(11),

  Par_Salida            CHAR(1),        	-- indica una salida
  INOUT Par_NumErr      INT(11),     	 	-- parametro numero de error
  INOUT Par_ErrMen      VARCHAR(400),   	-- mensaje de error

  Aud_Usuario           INT(11),
  Aud_FechaActual       DATETIME,
  Aud_DireccionIP       VARCHAR(15),
  Aud_ProgramaID        VARCHAR(50),
  Aud_Sucursal          INT(11),
  Aud_NumTransaccion    BIGINT(20)
)

TerminaStore: BEGIN

  -- Declaracion de variables
  DECLARE Var_InicioMes   DATE;
  DECLARE Var_FinMes      DATE;
  DECLARE Var_CorteMesAnt DATE;
  DECLARE Var_FecAnioAnt  DATE;
  DECLARE Var_DiasMes     INT;
  DECLARE Var_EsHabil     CHAR(1);
  DECLARE Var_Control     VARCHAR(100);

  -- Declaracion de constantes
  DECLARE Ref_Desembolso      VARCHAR(50);
  DECLARE Decimal_Cero        DECIMAL(12,2);
  DECLARE Estatus_Vigente     CHAR(1);
  DECLARE Estatus_Vencido     CHAR(1);
  DECLARE Estatus_Castigado   CHAR(1);
  DECLARE Estatus_Pagado      CHAR(1);
  DECLARE Nat_Cargo           CHAR(1);
  DECLARE Entero_Cero         INT(11);
  DECLARE Entero_Uno          INT(11);
  DECLARE Nat_Abono           CHAR(1);
  DECLARE Salida_NO           CHAR(1);
  DECLARE Salida_SI           CHAR(1);
  DECLARE Tip_CapVigente      INT;
  DECLARE Tip_CapAtrasado     INT;
  DECLARE Tip_CapVencido      INT;
  DECLARE Tip_CapVenNoExi     INT;
  DECLARE Tip_IntVigente      INT;
  DECLARE Tip_IntAtrasado     INT;
  DECLARE Tip_IntVencido      INT;
  DECLARE Tip_IntNoConta      INT;
  DECLARE Tip_IntProvision    INT;
  DECLARE Tip_IntMorato       INT;
  DECLARE Tip_ComFalPago      INT;
  DECLARE Tip_ComAdmon        INT;
  DECLARE Tip_IVAIntOrd       INT;
  DECLARE Tip_IVAMorato       INT;
  DECLARE Tip_IVAFalPag       INT;
  DECLARE Fecha_Vacia         DATE;
  DECLARE Cadena_Vacia        CHAR(1);
  DECLARE Sig_DiaHab          DATE;
  DECLARE Ref_PasoAtraso  	  VARCHAR(50);
  DECLARE Ref_PasoVencido     VARCHAR(50);
  DECLARE Ref_Regulariza      VARCHAR(50);
  DECLARE Ref_DevInteres      VARCHAR(50);
  DECLARE Ref_PagoCredito     VARCHAR(50);
  DECLARE Ref_PagoAntici      VARCHAR(50);
  DECLARE Des_PagoAntici      VARCHAR(50);
  DECLARE Ref_Condonacion     VARCHAR(50);

  -- Asignacion de constantes
  SET Fecha_Vacia         := '1900-01-01';
  SET Cadena_Vacia        := '';
  SET Decimal_Cero        := 0.00;
  SET Entero_Cero         := 0;
  SET Entero_Uno          := 1;
  SET Estatus_Vigente     := 'V';
  SET Estatus_Vencido     := 'B';
  SET Estatus_Castigado   := 'K';
  SET Estatus_Pagado      := 'P';
  SET Nat_Cargo           := 'C';
  SET Nat_Abono           := 'A';
  SET Salida_NO           := 'N';
  SET Salida_SI           := 'S';
  SET Tip_CapVigente      := 1;
  SET Tip_CapAtrasado     := 2;
  SET Tip_CapVencido      := 3;
  SET Tip_CapVenNoExi     := 4;
  SET Tip_IntVigente      := 10;
  SET Tip_IntAtrasado     := 11;
  SET Tip_IntVencido      := 12;
  SET Tip_IntNoConta      := 13;
  SET Tip_IntProvision    := 14;
  SET Tip_IntMorato       := 15;
  SET Tip_ComFalPago      := 40;
  SET Tip_ComAdmon        := 42;
  SET Tip_IVAIntOrd       := 20;
  SET Tip_IVAMorato       := 21;
  SET Tip_IVAFalPag       := 22;
  SET Ref_PasoAtraso      := 'GENERACION INTERES MORATORIO CONTINGENTE';
  SET Ref_PasoVencido     := 'TRASPASO A CARTERA VENCIDA CONTINGENTE';
  SET Ref_Regulariza      := 'REGULARIZACION DE CREDITO';
  SET Ref_DevInteres      := 'GENERACION INTERES CONTINGENTES';
  SET Ref_PagoCredito     := 'PAGO DE CREDITO';
  SET Des_PagoAntici      := 'DEVENGO INT.PAGO ANTICI';
  SET Ref_PagoAntici      := 'PAGO ANTICIPADO';
  SET Ref_Condonacion     := 'CONDONACION CARTERA';
  SET Ref_Desembolso      := 'DESEMBOLSO DE CREDITO';

ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET Par_NumErr := 999;
        SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
            					 'esto le ocasiona. Ref: SP-CRECALCULOSALDOSCONTPRO');
    END;

		SET Var_InicioMes := DATE_ADD(Par_Fecha, interval -1*(day(Par_Fecha))+1 day);
		SET Var_FinMes    := LAST_DAY(Par_Fecha);
		SET Var_DiasMes   := (DATEDIFF(Var_FinMes, Var_InicioMes) + 1);
		SET Var_FecAnioAnt := DATE_SUB(Par_Fecha, INTERVAL 1 YEAR);


		SELECT  MAX(FechaCorte) INTO Var_CorteMesAnt
		  FROM SALDOSCREDITOSCONT
			WHERE FechaCorte < Var_InicioMes;

		SET Var_CorteMesAnt := IFNULL(Var_CorteMesAnt, Fecha_Vacia);

		CALL CRECLASIFCARTCONTPRO(
		  Par_Fecha,      Salida_NO,		Par_NumErr,      	 Par_ErrMen,		Par_EmpresaID,
		  Aud_Usuario,    Aud_FechaActual,  Aud_DireccionIP,  	 Aud_ProgramaID,   	Aud_Sucursal,
		  Aud_NumTransaccion );

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		INSERT INTO `SALDOSCREDITOSCONT`(
				`CreditoID`,					`FechaCorte`,					`SalCapVigente`,				`SalCapAtrasado`,				`SalCapVencido`,
				`SalCapVenNoExi`,				`SalIntOrdinario`,				`SalIntAtrasado`,				`SalIntVencido`,				`SalIntProvision`,
				`SalIntNoConta`,				`SalMoratorios`,				`SaldoMoraVencido`,				`SaldoMoraCarVen`,				`SalComFaltaPago`,
				`SalOtrasComisi`,				`SalIVAInteres`,				`SalIVAMoratorios`,				`SalIVAComFalPago`,				`SalIVAComisi`,
				`PasoCapAtraDia`,				`PasoCapVenDia`,				`PasoCapVNEDia`,				`PasoIntAtraDia`,				`PasoIntVenDia`,
				`CapRegularizado`,				`IntOrdDevengado`,				`IntMorDevengado`,				`ComisiDevengado`,				`PagoCapVigDia`,
				`PagoCapAtrDia`,				`PagoCapVenDia`,				`PagoCapVenNexDia`,				`PagoIntOrdDia`,				`PagoIntVenDia`,
				`PagoIntAtrDia`,				`PagoIntCalNoCon`,				`PagoComisiDia`,				`PagoMoratorios`,				`PagoIvaDia`,
				`IntCondonadoDia`,				`MorCondonadoDia`,				`DiasAtraso`,					`NoCuotasAtraso`,				`MaximoDiasAtraso`,
				`LineaCreditoID`,				`ClienteID`,					`MonedaID`,						`FechaInicio`,					`FechaVencimiento`,
				`FechaExigible`,				`FechaLiquida`,					`ProductoCreditoID`,			`EstatusCredito`,				`SaldoPromedio`,
				`MontoCredito`,					`FrecuenciaCap`,				`PeriodicidadCap`,				`FrecuenciaInt`,				`PeriodicidadInt`,
				`NumAmortizacion`,				`FechTraspasVenc`,				`FechAutoriza`,					`ClasifRegID`,					`DestinoCreID`,
				`Calificacion`,					`PorcReserva`,					`TipoFondeo`,					`InstitFondeoID`,				`IntDevCtaOrden`,
				`CapCondonadoDia`,				`ComAdmonPagDia`,				`ComCondonadoDia`,				`DesembolsosDia`,				`CapVigenteExi`,
				`MontoTotalExi`,				`SalCapitalOriginal`,			`SalInteresOriginal`,			`SalMoraOriginal`,				`SalComOriginal`,
				`SaldoComServGar`,				`SaldoIVAComSerGar`,
				`EmpresaID`,					`Usuario`,						`FechaActual`,					`DireccionIP`,					`ProgramaID`,
				`Sucursal`,						`NumTransaccion`)
		SELECT  Cre.CreditoID,      Par_Fecha,            MAX(SaldoCapVigent),  MAX(SaldoCapAtrasad),
			MAX(SaldoCapVencido),   MAX(SaldCapVenNoExi), MAX(SaldoInterOrdin), MAX(SaldoInterAtras),
			MAX(SaldoInterVenc),    MAX(SaldoInterProvi), MAX(SaldoIntNoConta), MAX(SaldoMoratorios),
			MAX(SaldoMoraVencido),  MAX(SaldoMoraCarVen),
			MAX(SaldComFaltPago),   MAX(SaldoOtrasComis), MAX(SaldoIVAInteres), MAX(SaldoIVAMorator),
			MAX(SalIVAComFalPag),   MAX(SaldoIVAComisi),

			IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Cargo AND
								 Mov.TipoMovCreID = Tip_CapAtrasado AND
								 Mov.Referencia = Ref_PasoAtraso THEN Mov.Cantidad
							 ELSE Decimal_Cero END),
						 Decimal_Cero) AS TrasCapAtraso,

			Decimal_Cero AS TrasCapVencido,

			IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Cargo AND
								 Mov.TipoMovCreID = Tip_CapVenNoExi AND
								 Mov.Referencia = Ref_PasoVencido THEN Mov.Cantidad
							 ELSE Decimal_Cero END),
						 Decimal_Cero) AS TrasCapVenNoExi,

			IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Cargo AND
								 Mov.TipoMovCreID = Tip_IntAtrasado AND
								 Mov.Referencia = Ref_PasoAtraso THEN Mov.Cantidad
							 ELSE Decimal_Cero END),
						 Decimal_Cero) AS TrasIntAtraso,

			IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Cargo AND
								Mov.TipoMovCreID = Tip_IntVencido AND
								Mov.Referencia = Ref_PasoVencido THEN Mov.Cantidad
					  ELSE Decimal_Cero END),
						  Decimal_Cero) AS TrasIntVencido,


			IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Cargo AND
							  Mov.TipoMovCreID = Tip_CapVigente AND
							  Mov.Referencia = Ref_Regulariza THEN Mov.Cantidad
					  ELSE Decimal_Cero END),
						Decimal_Cero) AS Regulariza,

			IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Cargo AND
					 Mov.TipoMovCreID = Tip_IntProvision AND
					 Mov.Referencia = Ref_DevInteres THEN Mov.Cantidad
				  ELSE Decimal_Cero END) +
					SUM(CASE WHEN Mov.NatMovimiento = Nat_Cargo AND
							 Mov.TipoMovCreID = Tip_IntProvision AND
							 Mov.Descripcion = Des_PagoAntici AND
							 Mov.Referencia = Ref_PagoAntici THEN Mov.Cantidad
						 ELSE Decimal_Cero END),
					 Decimal_Cero) AS IntOrdDevengado,

			IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Cargo AND
							Mov.TipoMovCreID = Tip_IntMorato AND
							Mov.Referencia = Ref_PasoAtraso THEN Mov.Cantidad
					  ELSE Decimal_Cero END),
						Decimal_Cero) AS IntMorato,

			IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Cargo AND
					Mov.TipoMovCreID = Tip_ComFalPago AND
					Mov.Referencia = Ref_PasoAtraso THEN Mov.Cantidad
				  ELSE Decimal_Cero END),
					Decimal_Cero) AS ComFalPago,

			IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND
					Mov.TipoMovCreID = Tip_CapVigente AND
					Mov.Descripcion = Ref_PagoCredito THEN Mov.Cantidad
				  ELSE Decimal_Cero END),
					Decimal_Cero) AS PagoCapVigente,

			IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND
				  Mov.TipoMovCreID = Tip_CapAtrasado AND
				  Mov.Descripcion = Ref_PagoCredito THEN Mov.Cantidad
				ELSE Decimal_Cero END),
				  Decimal_Cero) AS PagoCapAtraso,

			IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND
				   Mov.TipoMovCreID = Tip_CapVencido AND
				   Mov.Descripcion = Ref_PagoCredito THEN Mov.Cantidad
			   ELSE Decimal_Cero END),
				  Decimal_Cero) AS PagoCapVencido,

			IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND
				   Mov.TipoMovCreID = Tip_CapVenNoExi AND
				   Mov.Descripcion = Ref_PagoCredito THEN Mov.Cantidad
			   ELSE Decimal_Cero END),
				  Decimal_Cero) AS PagoCapVencidoNE,

			IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND
						   Mov.TipoMovCreID = Tip_IntProvision AND
						   Mov.Descripcion = Ref_PagoCredito THEN Mov.Cantidad
					   ELSE Decimal_Cero END),
				   Decimal_Cero) AS PagoIntProvisionado,

			IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND
						 Mov.TipoMovCreID = Tip_IntVencido AND
						 Mov.Descripcion = Ref_PagoCredito THEN Mov.Cantidad
					 ELSE Decimal_Cero END),
				  Decimal_Cero) AS PagoIntVencido,

			IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND
						  Mov.TipoMovCreID = Tip_IntAtrasado AND
						  Mov.Descripcion = Ref_PagoCredito THEN Mov.Cantidad
					   ELSE Decimal_Cero END),
					Decimal_Cero) AS PagoIntAtraso,

			IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND
						  Mov.TipoMovCreID = Tip_IntNoConta AND
						  Mov.Descripcion = Ref_PagoCredito THEN Mov.Cantidad
					   ELSE Decimal_Cero END),
				   Decimal_Cero) AS PagoIntNoConta,

			IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND
						   Mov.TipoMovCreID = Tip_ComFalPago AND
						   Mov.Descripcion = Ref_PagoCredito THEN Mov.Cantidad
					   ELSE Decimal_Cero END),
				   Decimal_Cero) AS PagoComisi,

			IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND
						 Mov.TipoMovCreID = Tip_IntMorato AND
						 Mov.Descripcion = Ref_PagoCredito THEN Mov.Cantidad
					 ELSE Decimal_Cero END),
				 Decimal_Cero) AS PagoMorato,

			IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND
						   Mov.TipoMovCreID = Tip_IVAIntOrd AND
						   Mov.Descripcion = Ref_PagoCredito THEN Mov.Cantidad
					   ELSE Decimal_Cero END) +

						  SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND
								 Mov.TipoMovCreID = Tip_IVAMorato AND
								 Mov.Descripcion = Ref_PagoCredito THEN Mov.Cantidad
							  ELSE Decimal_Cero END) +

								SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND
									   Mov.TipoMovCreID = Tip_IVAFalPag AND
									   Mov.Descripcion = Ref_PagoCredito THEN Mov.Cantidad
									ELSE Decimal_Cero END),
			Decimal_Cero) AS PagoIVAS,

			IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND
						  Mov.Descripcion = Ref_Condonacion AND
						  (Mov.TipoMovCreID = Tip_IntProvision OR
						   Mov.TipoMovCreID = Tip_IntVencido OR
						   Mov.TipoMovCreID = Tip_IntAtrasado OR
						   Mov.TipoMovCreID = Tip_IntNoConta) THEN Mov.Cantidad
					  ELSE Decimal_Cero END),
						  Decimal_Cero) AS CondIntere,

			IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND
								 Mov.TipoMovCreID = Tip_IntMorato AND
								 Mov.Descripcion = Ref_Condonacion THEN Mov.Cantidad
						   ELSE Decimal_Cero END),
					   Decimal_Cero) AS CondMorato,

			/*campo modificado para sumar dias de atraso de credito activo en contingente cuando la amortizacion es la numero 1*/
			(SELECT (CASE WHEN IFNULL(min(FechaExigible), Fecha_Vacia) = Fecha_Vacia THEN 0
						  WHEN min(Amo.AmortizacionID) = 1 THEN
								datediff(Par_Fecha,min(Bic.FechaAtraso))
					ELSE (datediff(Par_Fecha,min(FechaExigible)) + 1)  END)
			FROM AMORTICREDITOCONT Amo, BITACORAAPLIGAR Bic
				WHERE Amo.CreditoID = Cre.CreditoID
					AND Amo.CreditoID = Bic.CreditoID
					AND Amo.Estatus != Estatus_Pagado
					AND (Amo.FechaExigible <= Par_Fecha OR Amo.AmortizacionID = 1)),

			(SELECT  IFNULL(count(CreditoID), 0)
			  FROM AMORTICREDITOCONT Amo
				WHERE Amo.CreditoID = Cre.CreditoID
				  AND Amo.Estatus != Estatus_Pagado
				  AND Amo.FechaExigible <= Par_Fecha),

			(SELECT IFNULL(MAX(DATEDIFF(Case WHEN (IFNULL(Amo.FechaLiquida,Fecha_Vacia) = Fecha_Vacia) THEN Par_Fecha
										  ELSE Amo.FechaLiquida
										END, Amo.FechaExigible))+1, 0)
			  FROM AMORTICREDITOCONT Amo
				WHERE Amo.CreditoID = Cre.CreditoID
				  AND FechaExigible <= Par_Fecha
				  AND FechaExigible >= Var_FecAnioAnt),


			Cre.LineaCreditoID,     Cre.ClienteID,      Cre.MonedaID,           Cre.FechaInicio,
			Cre.FechaVencimien,      Fecha_Vacia,
			CASE WHEN  Cre.Estatus IN(Estatus_Pagado,Estatus_Castigado) THEN Cre.FechTerminacion
			ELSE Fecha_Vacia END,    Cre.ProductoCreditoID,
			Cre.Estatus,            Decimal_Cero,       Cre.MontoCredito,       Cre.FrecuenciaCap,
			Cre.PeriodicidadCap,    Cre.FrecuenciaInt,  Cre.PeriodicidadInt,    Cre.NumAmortizacion,
			Cre.FechTraspasVenc,    Cre.FechaAutoriza,  Cre.ClasifRegID,        Cre.DestinoCreID,
			Cadena_Vacia,           Decimal_Cero,       Cre.TipoFondeo,         Cre.InstitFondeoID,

			IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Cargo AND
						   Mov.TipoMovCreID = Tip_IntNoConta AND
						   Mov.Referencia = Ref_DevInteres THEN Mov.Cantidad
					   ELSE Decimal_Cero END), Decimal_Cero) AS IntDevCtaOrden,

			IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND
							Mov.Descripcion = Ref_Condonacion AND
							(Mov.TipoMovCreID = Tip_CapVigente OR
							 Mov.TipoMovCreID = Tip_CapAtrasado OR
							 Mov.TipoMovCreID = Tip_CapVencido OR
							 Mov.TipoMovCreID = Tip_CapVenNoExi) THEN Mov.Cantidad
						 ELSE Decimal_Cero END),
					 Decimal_Cero) AS CondCapita,

			IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND
								 Mov.TipoMovCreID = Tip_ComAdmon AND
								 Mov.Descripcion = Ref_PagoCredito THEN Mov.Cantidad
							ELSE Decimal_Cero END),
							Decimal_Cero) AS PagoComAdmon,

			IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND
								   Mov.TipoMovCreID = Tip_ComFalPago AND
								   Mov.Descripcion = Ref_Condonacion THEN Mov.Cantidad
							   ELSE Decimal_Cero END),
						   Decimal_Cero) AS CondComisi,

			IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Cargo AND
								  Mov.TipoMovCreID = Tip_CapVigente AND
								  Mov.Descripcion = Ref_Desembolso  THEN Mov.Cantidad
						ELSE Decimal_Cero END),
						  Decimal_Cero) AS Desembolso,
						  (SELECT  IFNULL(SUM(SaldoCapVigente), 0)
							FROM AMORTICREDITOCONT Amo
							  WHERE Amo.CreditoID = Cre.CreditoID
								AND Amo.Estatus != Estatus_Pagado
								AND Amo.FechaExigible <= Par_Fecha) AS CapVigenteExi,
								FUNCIONDEUCRECONTNOIVA(Cre.CreditoID) AS MontoTotalExi,
			MAX(Cre.SalCapitalOriginal),	MAX(Cre.SalInteresOriginal),	MAX(Cre.SalMoraOriginal), MAX(Cre.SalComOriginal),
			MAX(Cre.SaldoComServGar),		MAX(Cre.SaldoIVAComSerGar),
			Par_EmpresaID,          Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,         Aud_Sucursal,       Aud_NumTransaccion
		FROM CREDITOSCONT Cre
		LEFT OUTER JOIN CREDITOSCONTMOVS AS Mov ON (Cre.CreditoID = Mov.CreditoID AND Mov.FechaOperacion = Par_Fecha)
		WHERE ( Estatus = Estatus_Vigente
		   OR   Estatus = Estatus_Vencido
		   OR (   Estatus = Estatus_Castigado
		   AND    FechTerminacion = Par_Fecha )
		   OR   ( Estatus = Estatus_Pagado
		   AND    FechTerminacion = Par_Fecha ))
		GROUP BY Cre.CreditoID;


		  DROP TABLE IF EXISTS TMTPFECHAEXIGIBLE;
		  CREATE TEMPORARY TABLE TMTPFECHAEXIGIBLE
			SELECT Sal.CreditoID, min(Amo.FechaExigible) FechaExigible FROM
			  SALDOSCREDITOSCONT Sal
			LEFT OUTER JOIN AMORTICREDITOCONT AS Amo
			  ON Sal.CreditoID = Amo.CreditoID AND Sal.FechaCorte = Par_Fecha
				WHERE Amo.Estatus != Estatus_Pagado
				  AND Amo.FechaExigible <= Par_Fecha
				GROUP BY Amo.CreditoID,	Sal.CreditoID;

			ALTER TABLE TMTPFECHAEXIGIBLE
				ADD COLUMN RegistroID bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY FIRST;

		  UPDATE SALDOSCREDITOSCONT Sal,TMTPFECHAEXIGIBLE Tem SET
			Sal.FechaExigible = IFNULL(Tem.FechaExigible,Fecha_Vacia)
			WHERE Sal.CreditoID = Tem.CreditoID
			  AND Sal.FechaCorte = Par_Fecha;



		  TRUNCATE TABLE TMPCREDITOSMOVS;

		  INSERT INTO TMPCREDITOSMOVS (
                        Transaccion,                      CreditoID,                        Fecha,                        SaldoDia)
			  SELECT  Aud_NumTransaccion,
					  Mov.CreditoID, Mov.FechaOperacion,
					  (   SUM(LOCATE(Nat_Cargo, Mov.NatMovimiento) * Mov.Cantidad ) -
									   SUM(LOCATE(Nat_Abono, Mov.NatMovimiento) * Mov.Cantidad ) ) *
									  (DATEDIFF(Var_FinMes, Mov.FechaOperacion) + 1)
		  FROM CREDITOSCONTMOVS Mov,
			   SALDOSCREDITOSCONT Sal
		  WHERE  Sal.FechaCorte = Par_Fecha
			AND Sal.CreditoID = Mov.CreditoID
			AND FechaOperacion  >= Var_InicioMes
			AND FechaOperacion  <= Par_Fecha
			AND ( Mov.TipoMovCreID = Tip_CapVigente
			 OR   Mov.TipoMovCreID = Tip_CapAtrasado
			 OR   Mov.TipoMovCreID = Tip_CapVencido
			 OR   Mov.TipoMovCreID = Tip_CapVenNoExi)
		  GROUP BY Mov.CreditoID, Mov.FechaOperacion;


		  INSERT INTO TMPCREDITOSMOVS (
                        Transaccion,                      CreditoID,                        Fecha,                        SaldoDia)
			  SELECT  Aud_NumTransaccion,
					  Cre.CreditoID, Var_InicioMes,
					  (   IFNULL(SalCapVigente, Decimal_Cero) +
						  IFNULL(SalCapAtrasado, Decimal_Cero) +
						  IFNULL(SalCapVencido, Decimal_Cero) +
						  IFNULL(SalCapVenNoExi, Decimal_Cero)) * Var_DiasMes
			  FROM  SALDOSCREDITOSCONT Cre
			  WHERE Cre.FechaCorte  = Var_CorteMesAnt;


			UPDATE SALDOSCREDITOSCONT Sal SET
			SaldoPromedio = ( SELECT (IFNULL(SUM(SaldoDia),Decimal_Cero) / Var_DiasMes)
									 AS SaldoProm
								FROM TMPCREDITOSMOVS Mov
								WHERE Sal.CreditoID = Mov.CreditoID)
			WHERE Sal.FechaCorte  = Par_Fecha;

		TRUNCATE TABLE TMPCREDITOSMOVS;
		DROP TABLE IF EXISTS TMTPFECHAEXIGIBLE;

		CALL ELIMINARESCREDPRO(
			Par_Fecha,  Par_EmpresaID,    Aud_Usuario,    Aud_FechaActual,  Aud_DireccionIP,
			Aud_ProgramaID, Aud_Sucursal, Aud_NumTransaccion);

		CALL DIASFESTIVOSCAL(
			Par_Fecha,      Entero_Uno,         Sig_DiaHab,         Var_EsHabil,    Par_EmpresaID,
			Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
			Aud_NumTransaccion);

		SET Par_NumErr  := Entero_Cero;
		SET Par_ErrMen  := 'Informacion Procesada Exitosamente.';
		SET Var_Control := 'creditoID' ;

END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
    SELECT  Par_NumErr  AS NumErr,
            Par_ErrMen  AS ErrMen,
            Var_Control AS control,
            Entero_Cero AS consecutivo;
END IF;

END TerminaStore$$
