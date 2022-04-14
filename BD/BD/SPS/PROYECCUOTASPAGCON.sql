-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROYECCUOTASPAGCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PROYECCUOTASPAGCON`;
DELIMITER $$

CREATE PROCEDURE `PROYECCUOTASPAGCON`(
-- --------------------------------------------------------------------
-- SP DE PROYECCION DE CUOTAS COMPLETAS PARA TIPO DE PRE PAGO
-- --------------------------------------------------------------------
    Par_CreditoID       BIGINT(12),         -- Numero de Credito
    Par_NumCuotas       INT(11),            -- Numero de Cuotas para realizar la proyeccion
    Par_NumCon          INT(11),            -- Numero de Consulta

    /* Parametros de Auditoria */
    Par_EmpresaID       INT(11),            -- Parametro de Auditoria
    Aud_Usuario         INT(11),            -- Parametro de Auditoria
    Aud_FechaActual     DATETIME,           -- Parametro de Auditoria
    Aud_DireccionIP     VARCHAR(15),        -- Parametro de Auditoria
    Aud_ProgramaID      VARCHAR(50),        -- Parametro de Auditoria
    Aud_Sucursal        INT(11),            -- Parametro de Auditoria
    Aud_NumTransaccion  BIGINT(20)          -- Parametro de Auditoria
)
TerminaStore: BEGIN
    -- Declaracion de variables
    DECLARE Var_Control         VARCHAR(100);       -- Variable Control
    DECLARE Var_CreditoID       BIGINT(11);            -- Variable de Credito ID
    DECLARE Var_AmortInicial    INT(11);            -- ID Amortizacion Inicial
    DECLARE Var_AmortFinal      int(11);            -- ID Amortizacion Final
    DECLARE Var_IVAIntOrd       CHAR(1);            -- Variable Cobra IVA Interes Ordinario
    DECLARE Var_CliPagIVA       CHAR(1);            -- Variable Cliente Paga IVA
    DECLARE Var_IVAIntMor       CHAR(1);            -- Variable Cobra Interes Moratorio
    DECLARE Var_IVASucurs       DECIMAL(12,2);      -- Variable IVA de la Sucursal
    DECLARE Var_SucCredito      INT(11);            -- Variable Sucursal del Cliente
    DECLARE Var_ValIVAIntOr     DECIMAL(12,2);      -- Variable Valor IVA de Interes Ord
    DECLARE Var_ValIVAGen       DECIMAL(12,2);      -- Variable Valor de IVA
    DECLARE Var_ValIVAIntMo     DECIMAL(12,2);      -- Variable Valor de IVA Interes Moratorios
    DECLARE Var_SaldoAccesorio     DECIMAL(14,2);   -- Variable Saldo de Accesorios
    DECLARE Var_SaldoIVAAccesorio  DECIMAL(14,2);   -- Variable Saldo Iva de Accesorios
	DECLARE Var_NumCliProEsp	INT(11);			-- Variable Numero identificador de cliente especifico
	DECLARE Var_FechaSistema	DATE;				-- Variable Fecha del sistema
	DECLARE Var_SalIntAcces		DECIMAL(14,2);		-- Variable para almacenar el saldo de interes de Accesorios
	DECLARE Var_SalIvaIntAcc	DECIMAL(14,2);		-- Variable para almacenar el saldo de iva de interes de Accesorios

    -- Declaracion de constantes
    DECLARE Cadena_Vacia        CHAR(1);            -- Constante Cadena Vacia ''
    DECLARE Fecha_Vacia         DATE;               -- Constante Fecha Vacia  '1900-01-01'
    DECLARE Entero_Cero         INT(11);            -- Constante Entero Cero 0
    DECLARE Decimal_Cero        DECIMAL(12,4);      -- Constante Deciaml Cero 0.0
    DECLARE Decimal_Cien        DECIMAL(12,4);      -- Deciaml Cien 100.00
    DECLARE Con_Principal       INT(11);
    DECLARE EstatusVigente      CHAR(1);            -- Estatus Vigente
    DECLARE EstatusPagado       CHAR(1);            -- Estatus Pagado
    DECLARE SiPagaIVA           CHAR(1);            -- Cobra IVA 'S'
    DECLARE SalidaSI            CHAR(1);            -- Salida SI
    DECLARE Cons_Si             CHAR(1);            -- Constante SI
    DECLARE Proces_Monto        CHAR(1);            -- Constante 'M' Proceso para sacar el Monto de los Accesorios
    DECLARE Proces_IVA          CHAR(1);            -- Constante 'I' Proceso para sacar el IVA de los Accesorios
	DECLARE Proces_Int			CHAR(1);			-- Constante 'R' Proceso para sacar el Interes de los Accesorios
	DECLARE Proces_IvaInt		CHAR(1);			-- Constante 'M' Proceso para sacar el IVA de Interes de los Accesorios
	DECLARE Var_LlaveCliProEsp	VARCHAR(20);		-- Llave para consulta del numero de cliente especifico
	DECLARE Var_NumCliProATE	INT(11);			-- Numero de cliente especifico de Apoyo a Tu Economia (ATE)

    SET Cadena_Vacia        := '';
    SET Fecha_Vacia         := '1900-01-01';
    SET Entero_Cero         := 0;
    SET Decimal_Cero        := 0.0;
    SET Decimal_Cien        := 100.0;
    SET Con_Principal       := 1;
    SET EstatusVigente      := 'V';
    SET EstatusPagado       := 'P';
    SET SiPagaIVA           := 'S';
    SET SalidaSI            := 'S';
    SET Cons_Si             := 'S';
    SET Proces_Monto        := 'M';
    SET Proces_IVA          := 'I';
	SET Proces_Int			:= 'R';
	SET Proces_IvaInt		:= 'G';
	SET Var_LlaveCliProEsp	:= 'CliProcEspecifico';	-- Llave para consulta del numero de cliente especifico
	SET Var_NumCliProATE	:= 49;					-- Numero de cliente especifico de Apoyo a Tu Economia (ATE)

    IF(Par_NumCon = Con_Principal )THEN
        SELECT  Cli.PagaIVA,    Cre.SucursalID,     Pro.CobraIVAInteres,        Pro.CobraIVAMora
                INTO
                Var_CliPagIVA,  Var_SucCredito,     Var_IVAIntOrd,              Var_IVAIntMor
                FROM CREDITOS Cre,
                    PRODUCTOSCREDITO Pro,
                    CLIENTES Cli
                WHERE Cre.CreditoID     = Par_CreditoID
                AND Cre.ProductoCreditoID = Pro.ProducCreditoID
                AND Cre.ClienteID     = Cli.ClienteID;

        SET Var_CliPagIVA       := IFNULL(Var_CliPagIVA, SiPagaIVA);
        SET Var_IVAIntOrd       := IFNULL(Var_IVAIntOrd, SiPagaIVA);
        SET Var_IVAIntMor       := IFNULL(Var_IVAIntMor, SiPagaIVA);

        SET Var_ValIVAIntOr := Entero_Cero;
        SET Var_ValIVAIntMo := Entero_Cero;
        SET Var_ValIVAGen   := Entero_Cero;

        IF (Var_CliPagIVA = SiPagaIVA) THEN
            SET Var_IVASucurs   := (SELECT IVA
                                        FROM SUCURSALES
                                            WHERE  SucursalID = Var_SucCredito);
            SET Var_IVASucurs := IFNULL(Var_IVASucurs, Entero_Cero);

                -- IVA General (Comisiones y Otro Cargos)
                SET Var_ValIVAGen  := Var_IVASucurs;
                -- Verificamos si Paga IVA de Interes Ordinario
                IF (Var_IVAIntOrd = SiPagaIVA) THEN
                    SET Var_ValIVAIntOr  := Var_IVASucurs;
                END IF;

                IF (Var_IVAIntMor = SiPagaIVA) THEN
                    SET Var_ValIVAIntMo  := Var_IVASucurs;
                END IF;
        END IF;

        SELECT		FechaSistema
			INTO	Var_FechaSistema
			FROM	PARAMETROSSIS;

		SET Var_FechaSistema	:= IFNULL(Var_FechaSistema, Fecha_Vacia);

		SELECT		CAST(ValorParametro AS UNSIGNED)
			INTO	Var_NumCliProEsp
			FROM	PARAMGENERALES
			WHERE	LlaveParametro = Var_LlaveCliProEsp;

		SET Var_NumCliProEsp	:= IFNULL(Var_NumCliProEsp, Entero_Cero);

        SET Var_AmortInicial := (SELECT AmortizacionID
                                    FROM AMORTICREDITO
                                    WHERE Estatus = EstatusVigente
                                        AND CreditoID = Par_CreditoID
                                    ORDER BY AmortizacionID ASC LIMIT 1);

        SET  Var_AmortFinal := Var_AmortInicial + (Par_NumCuotas - 1);

		IF (Var_NumCliProEsp = Var_NumCliProATE) THEN

			SET Var_SaldoAccesorio		:= FNMONTOCUOPROYACCESEXIGIBLE(Par_CreditoID, Var_AmortInicial, Var_AmortFinal, Proces_Monto);
			SET Var_SaldoIVAAccesorio	:= FNMONTOCUOPROYACCESEXIGIBLE(Par_CreditoID, Var_AmortInicial, Var_AmortFinal, Proces_IVA);
			SET Var_SalIntAcces			:= FNMONTOCUOPROYACCESEXIGIBLE(Par_CreditoID, Var_AmortInicial, Var_AmortFinal, Proces_Int);
			SET Var_SalIvaIntAcc		:= FNMONTOCUOPROYACCESEXIGIBLE(Par_CreditoID, Var_AmortInicial, Var_AmortFinal, Proces_IvaInt);

		ELSE

			SET Var_SaldoAccesorio		:= ROUND(IFNULL(FNMONTOCUOPROYACCES(Par_CreditoID, Var_AmortInicial, Var_AmortFinal, Proces_Monto),0),2);
			SET Var_SaldoIVAAccesorio	:= ROUND(IFNULL(FNMONTOCUOPROYACCES(Par_CreditoID, Var_AmortInicial, Var_AmortFinal, Proces_IVA),0),2);
			SET Var_SalIntAcces			:= ROUND(IFNULL(FNMONTOCUOPROYACCES(Par_CreditoID, Var_AmortInicial, Var_AmortFinal, Proces_Int),0),2);
			SET Var_SalIvaIntAcc		:= ROUND(IFNULL(FNMONTOCUOPROYACCES(Par_CreditoID, Var_AmortInicial, Var_AmortFinal, Proces_IvaInt),0),2);

		END IF;

        SELECT  FORMAT(IFNULL(SUM(SaldoCapVigente),Entero_Cero),2) AS SaldoCapVigent,
                    FORMAT(IFNULL(SUM(SaldoCapAtrasa),Entero_Cero),2) AS SaldoCapAtrasad,
                    FORMAT(IFNULL(SUM(SaldoCapVencido),Entero_Cero),2) AS SaldoCapVencido,
                    FORMAT(IFNULL(SUM(SaldoCapVenNExi),Entero_Cero),2) AS SaldCapVenNoExi,
                    FORMAT(IFNULL(SUM(ROUND(SaldoInteresOrd,2)),Entero_Cero),2) AS SaldoInterOrdin,
                    FORMAT(IFNULL(SUM(ROUND(SaldoInteresAtr,2)),Entero_Cero),2) AS SaldoInterAtras,
                    FORMAT(IFNULL(SUM(ROUND(SaldoInteresVen,2)),Entero_Cero),2) AS SaldoInterVenc,





                    FORMAT(IFNULL(SUM(ROUND(CASE WHEN IFNULL(NumProyInteres,Entero_Cero) = Entero_Cero AND Estatus = EstatusVigente AND (Var_NumCliProEsp <> Var_NumCliProATE OR (Var_NumCliProEsp = Var_NumCliProATE AND Amo.FechaExigible <= Var_FechaSistema)) THEN Interes
                                                ELSE IF (Var_NumCliProEsp = Var_NumCliProATE AND Amo.FechaExigible > Var_FechaSistema, Entero_Cero, SaldoInteresPro) END,2)),Entero_Cero),2) AS SaldoInterProvi,




                    FORMAT(IFNULL(SUM(ROUND(SaldoIntNoConta,2)),Entero_Cero),2) AS SaldoIntNoConta,




                    FORMAT(IFNULL(SUM(ROUND(CASE WHEN IFNULL(NumProyInteres,Entero_Cero) = Entero_Cero AND Estatus = EstatusVigente AND (Var_NumCliProEsp <> Var_NumCliProATE OR (Var_NumCliProEsp = Var_NumCliProATE AND Amo.FechaExigible <= Var_FechaSistema)) THEN Interes * Var_ValIVAIntOr
                                                ELSE IF (Var_NumCliProEsp = Var_NumCliProATE AND Amo.FechaExigible > Var_FechaSistema, Entero_Cero, SaldoInteresPro) * Var_ValIVAIntOr END,2)), Entero_Cero),2) AS SaldoIVAIntProv,




                    FORMAT(IFNULL(SUM(
                                ROUND(
                                    ROUND(SaldoInteresOrd * Var_ValIVAIntOr,2) +
                                    ROUND(SaldoInteresAtr * Var_ValIVAIntOr,2) +
                                    ROUND(SaldoInteresVen * Var_ValIVAIntOr,2) +
                                    ROUND(CASE WHEN IFNULL(NumProyInteres,Entero_Cero) = Entero_Cero AND Estatus = EstatusVigente AND (Var_NumCliProEsp <> Var_NumCliProATE OR (Var_NumCliProEsp = Var_NumCliProATE AND Amo.FechaExigible <= Var_FechaSistema)) THEN Interes * Var_ValIVAIntOr
                                            ELSE IF (Var_NumCliProEsp = Var_NumCliProATE AND Amo.FechaExigible > Var_FechaSistema, Entero_Cero, SaldoInteresPro) * Var_ValIVAIntOr END,2) +
                                    ROUND(SaldoIntNoConta * Var_ValIVAIntOr,2), 2)), Entero_Cero), 2)AS SaldoIVAInteres,
                    FORMAT(IFNULL(SUM(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen),Entero_Cero),2) AS SaldoMoratorios,
                    FORMAT(IFNULL(SUM(ROUND(
                                            ROUND(SaldoMoratorios * Var_ValIVAIntMo,2) +
                                            ROUND(SaldoMoraVencido * Var_ValIVAIntMo,2) +
                                            ROUND(SaldoMoraCarVen * Var_ValIVAIntMo,2),2)), Entero_Cero),2) AS SaldoIVAMorator,

                    FORMAT(IFNULL(SUM(SaldoComFaltaPa),Entero_Cero),2) AS SaldComFaltPago,
                    FORMAT(IFNULL(SUM(ROUND(ROUND(SaldoComFaltaPa,2) * Var_ValIVAGen,2)),Entero_Cero),2) AS SalIVAComFalPag,
                    FORMAT(IFNULL(Var_SaldoAccesorio,0),2) AS SaldoOtrasComis,
                    FORMAT(IFNULL(Var_SaldoIVAAccesorio,0),2) AS SaldoIVAComisi,
                    FORMAT(IFNULL(SUM(SaldoSeguroCuota),Entero_Cero),2) AS SaldoSeguroCuota,
                    FORMAT(IFNULL(SUM(ROUND(SaldoIVASeguroCuota,2)),Entero_Cero),2) AS SaldoIVASeguroCuota,
                    FORMAT(IFNULL(SUM(ROUND(SaldoCapVigente,2)  +
                                    ROUND(SaldoCapAtrasa,2) +
                                    ROUND(SaldoCapVencido,2)    +
                                    ROUND(SaldoCapVenNExi,2)),Entero_Cero),2) AS totalCapital,
                    FORMAT(ROUND(IFNULL(SUM(ROUND(CASE WHEN IFNULL(NumProyInteres,Entero_Cero) = Entero_Cero AND Estatus = EstatusVigente AND (Var_NumCliProEsp <> Var_NumCliProATE OR (Var_NumCliProEsp = Var_NumCliProATE AND Amo.FechaExigible <= Var_FechaSistema)) THEN Interes
                                                    ELSE  IF (Var_NumCliProEsp = Var_NumCliProATE AND Amo.FechaExigible > Var_FechaSistema, Entero_Cero, SaldoInteresOrd) +
                                                            SaldoInteresAtr +
                                                            SaldoInteresVen +
															IF (Var_NumCliProEsp = Var_NumCliProATE AND Amo.FechaExigible > Var_FechaSistema, Entero_Cero, SaldoInteresPro) +
                                                            SaldoIntNoConta END
                                                ,2)),Entero_Cero), 2), 2) AS totalInteres,
                    FORMAT(ROUND(IFNULL(SUM(ROUND(SaldoComFaltaPa,2)  +
                                                ROUND(SaldoSeguroCuota,2)) + IFNULL(Var_SaldoAccesorio,0),Entero_Cero),2), 2) AS totalComisi,
                    FORMAT(ROUND((IFNULL(SUM(ROUND(SaldoComFaltaPa,2)),Entero_Cero) * Var_ValIVAGen)+SUM(ROUND(SaldoIVASeguroCuota,2)) + IFNULL(Var_SaldoIVAAccesorio,0),2),2) AS totalIVACom,




                    FORMAT(IFNULL(
                                SUM(ROUND(SaldoCapVigente,2) + ROUND(SaldoCapAtrasa,2) +
                                    ROUND(SaldoCapVencido,2) + ROUND(SaldoCapVenNExi,2) +
                                    ROUND(CASE WHEN IFNULL(NumProyInteres,Entero_Cero) = Entero_Cero AND Estatus = EstatusVigente AND (Var_NumCliProEsp <> Var_NumCliProATE OR (Var_NumCliProEsp = Var_NumCliProATE AND Amo.FechaExigible <= Var_FechaSistema)) THEN Interes
                                            ELSE IF (Var_NumCliProEsp = Var_NumCliProATE AND Amo.FechaExigible > Var_FechaSistema, Entero_Cero, SaldoInteresOrd) +
													SaldoInteresAtr +
                                                    SaldoInteresVen +
													IF (Var_NumCliProEsp = Var_NumCliProATE AND Amo.FechaExigible > Var_FechaSistema, Entero_Cero, SaldoInteresPro) +
                                                    SaldoIntNoConta + SaldoSeguroCuota +
                                                    SaldoComisionAnual END ,2) +
                                    CASE WHEN IFNULL(NumProyInteres,Entero_Cero) = Entero_Cero AND Estatus = EstatusVigente AND (Var_NumCliProEsp <> Var_NumCliProATE OR (Var_NumCliProEsp = Var_NumCliProATE AND Amo.FechaExigible <= Var_FechaSistema)) THEN ROUND(Interes * Var_ValIVAIntOr,2)
                                        ELSE
                                        ROUND(ROUND(IF (Var_NumCliProEsp = Var_NumCliProATE AND Amo.FechaExigible > Var_FechaSistema, Entero_Cero, SaldoInteresOrd) * Var_ValIVAIntOr, 2) +
                                                ROUND(SaldoInteresAtr * Var_ValIVAIntOr, 2) +
                                                ROUND(SaldoInteresVen * Var_ValIVAIntOr, 2) +
                                                ROUND(IF (Var_NumCliProEsp = Var_NumCliProATE AND Amo.FechaExigible > Var_FechaSistema, Entero_Cero, SaldoInteresPro) * Var_ValIVAIntOr, 2) +
                                                ROUND(SaldoIntNoConta * Var_ValIVAIntOr, 2), 2) END +
                                    ROUND(SaldoComFaltaPa,2) + ROUND(ROUND(SaldoComFaltaPa,2) * Var_ValIVAGen,2) +
                                    ROUND(SaldoSeguroCuota,2) + ROUND(SaldoIVASeguroCuota,2) +
                                    ROUND(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen,2) +
                                    ROUND(ROUND(SaldoMoratorios * Var_ValIVAIntMo,2) +
                                            ROUND(SaldoMoraVencido * Var_ValIVAIntMo,2)+
                                            ROUND(SaldoMoraCarVen * Var_ValIVAIntMo,2)+
                                            ROUND(SaldoComisionAnual * Var_ValIVAGen,2), 2)
                                    ) + ROUND(IFNULL(Var_SaldoAccesorio,0),2) +
                                        ROUND(IFNULL(Var_SaldoIVAAccesorio,0),2) +
										ROUND(IFNULL(Var_SalIntAcces, Entero_Cero), 2) +
										ROUND(IFNULL(Var_SalIvaIntAcc, Entero_Cero), 2),
                                Entero_Cero), 2) AS adeudoTotal,
                        /*COMISION ANUAL*/
                        Decimal_Cero AS SaldoComAnual,
                        Decimal_Cero AS SaldoComAnualIVA
                        /*FIN COMISION ANUAL*/
                FROM AMORTICREDITO Amo
                WHERE Amo.CreditoID = Par_CreditoID
                AND Amo.Estatus <> EstatusPagado
                AND Amo.AmortizacionID BETWEEN Var_AmortInicial AND Var_AmortFinal;

    END IF;

END TerminaStore$$