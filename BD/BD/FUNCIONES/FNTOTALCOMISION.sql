-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNTOTALCOMISION
DELIMITER ;
DROP FUNCTION IF EXISTS `FNTOTALCOMISION`;
DELIMITER $$


CREATE FUNCTION `FNTOTALCOMISION`(
-- --------------------------------------------------------------------------------
-- FUNCION PARA CALCULAR EL MONTO TOTAL DE LA COMISION POR LIQUIDACION ANTICIPADA
-- --------------------------------------------------------------------------------

    Par_CreditoID   BIGINT(12)


) RETURNS decimal(16,2)
    DETERMINISTIC
BEGIN
-- Declaracion de variables
DECLARE Var_PermiteLiqAnt   CHAR(1);
DECLARE Var_CobraComLiqAnt  CHAR(1);
DECLARE Var_TipComLiqAnt    CHAR(1);
DECLARE Var_ComLiqAnt       DECIMAL(14,4);
DECLARE Var_PrductoCreID    INT(11);
DECLARE Cadena_Vacia      	CHAR(1);
DECLARE Var_DiasGraciaLiq   INT(11);
DECLARE Entero_Cero     	  INT(11);
DECLARE Var_SaldoIVAInteres	DECIMAL(12,4);
DECLARE Var_FecVenCred      DATE;
DECLARE Var_FecActual       DATE;
DECLARE Var_DiasAntici      INT(11);
DECLARE SI_PermiteLiqAnt    CHAR(1);
DECLARE SI_CobraLiqAnt    	CHAR(1);
DECLARE Proyeccion_Int  	  CHAR(1);
DECLARE Var_ComAntici       DECIMAL(14,4);
DECLARE EstatusPagado   	  CHAR(1);
DECLARE Var_FecProxPago     DATE;
DECLARE Var_IntActual       DECIMAL(14,2);
DECLARE Por_Porcentaje  	  CHAR(1);
DECLARE Var_SaldoInsoluto   DECIMAL(14,2);
DECLARE Decimal_Cien       	DECIMAL(12,4);
DECLARE Fecha_Vacia       	DATE;
DECLARE Var_ValIVAGen     	DECIMAL(12,2);
DECLARE Var_SaldoCapita     DECIMAL(14,2);
DECLARE Var_SaldoCapAtra    DECIMAL(14,2);
DECLARE Con_Finiquito2      INT(11);
DECLARE Var_TotAdeudo       DECIMAL(16,2);
DECLARE Decimal_Cero 		    DECIMAL (16,2);
DECLARE Var_CliPagIVA     	CHAR(1);
DECLARE SiPagaIVA         	CHAR(1);
DECLARE Var_IVASucurs     	DECIMAL(12,2);
DECLARE Var_SucCredito      INT(11);

-- Asignacion de constantes
SET Cadena_Vacia        := '';
SET Entero_Cero         := 0;
SET SI_PermiteLiqAnt    := 'S';
SET SI_CobraLiqAnt      := 'S';
SET Proyeccion_Int      := 'P';
SET EstatusPagado      	:= 'P';
SET Por_Porcentaje      := 'S';
SET Decimal_Cien        := 100.0;
SET Var_TotAdeudo     	:= 0.0;
SET Fecha_Vacia         := '1900-01-01';
SET Decimal_Cero	    	:= 0.0;
SET SiPagaIVA         	:= 'S';


      -- Consulta para obtener datos de la sucursal, pago de iva y el producto de credito
      SELECT Cli.PagaIVA, Cre.SucursalID, (SaldoCapVigent + SaldCapVenNoExi),(SaldoCapAtrasad + SaldoCapVencido),Cre.FechaVencimien, Pro.ProducCreditoID
        INTO Var_CliPagIVA, Var_SucCredito, Var_SaldoCapita, Var_SaldoCapAtra, Var_FecVenCred, Var_PrductoCreID
	      FROM CREDITOS Cre
        INNER JOIN  PRODUCTOSCREDITO Pro
        INNER JOIN CLIENTES Cli
	      WHERE Cre.CreditoID  = Par_CreditoID
        AND Cre.ProductoCreditoID = Pro.ProducCreditoID
	      AND Cre.ClienteID     = Cli.ClienteID;

      SET Var_SaldoInsoluto   := IFNULL(Var_SaldoCapita, Entero_Cero) + IFNULL(Var_SaldoCapAtra, Entero_Cero);

    -- Consulta para obtener datos relacionados a la garantia liquida
      SELECT PermiteLiqAntici,		CobraComLiqAntici,		TipComLiqAntici,	ComisionLiqAntici,		DiasGraciaLiqAntici
	      INTO Var_PermiteLiqAnt,		Var_CobraComLiqAnt,		Var_TipComLiqAnt,	Var_ComLiqAnt,			Var_DiasGraciaLiq
	      FROM ESQUEMACOMPRECRE
	      WHERE ProductoCreditoID = Var_PrductoCreID;

      SET Var_CliPagIVA   	:= IFNULL(Var_CliPagIVA, SiPagaIVA);

      IF (Var_CliPagIVA = SiPagaIVA) THEN
		    SET	Var_IVASucurs	:= IFNULL((SELECT IVA
	      FROM SUCURSALES
  	    WHERE  SucursalID = Var_SucCredito),  Entero_Cero);
      END IF;

      SET Var_ValIVAGen  := Var_IVASucurs;


      SELECT FechaSistema INTO Var_FecActual FROM PARAMETROSSIS;


			SET Var_PermiteLiqAnt   := IFNULL(Var_PermiteLiqAnt, Cadena_Vacia);
			SET Var_CobraComLiqAnt  := IFNULL(Var_CobraComLiqAnt, Cadena_Vacia);
			SET Var_TipComLiqAnt    := IFNULL(Var_TipComLiqAnt, Cadena_Vacia);
			SET Var_ComLiqAnt       := IFNULL(Var_ComLiqAnt, Entero_Cero);
			SET Var_DiasGraciaLiq   := IFNULL(Var_DiasGraciaLiq, Entero_Cero);
			SET Var_SaldoIVAInteres	:= IFNULL(Var_SaldoIVAInteres, Entero_Cero);

			IF(Var_FecVenCred != Fecha_Vacia AND Var_FecVenCred >= Var_FecActual) THEN
				SET Var_DiasAntici := DATEDIFF(Var_FecVenCred, Var_FecActual);
			ELSE
				SET Var_DiasAntici := Entero_Cero;
			END IF;

			IF(Var_DiasAntici > Var_DiasGraciaLiq AND Var_PermiteLiqAnt = SI_PermiteLiqAnt AND Var_CobraComLiqAnt = SI_CobraLiqAnt) THEN
                IF(Var_TipComLiqAnt = Proyeccion_Int) THEN
          -- Consulta para obtener la comision anticipada
					SELECT SUM(Interes) INTO Var_ComAntici
					FROM AMORTICREDITO
					WHERE CreditoID   = Par_CreditoID
					AND FechaVencim > Var_FecActual
					AND Estatus     != EstatusPagado;

					SET Var_FecProxPago		:= IFNULL(Var_FecProxPago, Fecha_Vacia);
					SET Var_ComAntici		:= IFNULL(Var_ComAntici, Entero_Cero);
          -- Consulta para obtener el interes actual
					SELECT (Amo.SaldoInteresPro + Amo.SaldoIntNoConta) INTO Var_IntActual
						FROM AMORTICREDITO Amo
						WHERE Amo.CreditoID   = Par_CreditoID
							AND Amo.FechaVencim > Var_FecActual
							AND Amo.FechaInicio <= Var_FecActual
							AND Amo.Estatus     != EstatusPagado;
					SET Var_IntActual   := IFNULL(Var_IntActual, Entero_Cero);
					SET Var_ComAntici   := ROUND(Var_ComAntici - Var_IntActual,2);

				  ELSEIF (Var_TipComLiqAnt = Por_Porcentaje) THEN
					SET Var_ComAntici   := ROUND(Var_SaldoInsoluto * Var_ComLiqAnt / Decimal_Cien,2);
				  ELSE
					SET Var_ComAntici   := Var_ComLiqAnt;
				END IF;
			  ELSE
				SET Var_ComAntici   := Entero_Cero;
			END IF;


			IF(Var_ComAntici < Entero_Cero) THEN
				SET Var_ComAntici   := Entero_Cero;
			END IF;

		-- Consulta para obtener el total del adeudo
			SELECT
			ROUND(IFNULL(SUM(ROUND(SaldoComFaltaPa,2) + ROUND(SaldoComServGar,2)+ ROUND(SaldoOtrasComis,2) + ROUND(SaldoComisionAnual,2) + ROUND(SaldoSeguroCuota,2))+ ROUND(Var_ComAntici,2),Entero_Cero),2)  +
      		IFNULL(SUM(ROUND(SaldoComFaltaPa * Var_ValIVAGen, 2) + ROUND(SaldoComServGar * Var_ValIVAGen, 2) +ROUND(SaldoOtrasComis * Var_ValIVAGen, 2) +ROUND(SaldoComisionAnual * Var_ValIVAGen, 2) +ROUND(SaldoIVASeguroCuota,2)) +ROUND(Var_ComAntici * Var_ValIVAGen, 2),Entero_Cero)
			INTO Var_TotAdeudo
			FROM AMORTICREDITO
			WHERE CreditoID = Par_CreditoID
			AND Estatus <> EstatusPagado;

			SET Var_TotAdeudo = IFNULL(Var_TotAdeudo, Decimal_Cero);

			RETURN Var_TotAdeudo;

END$$