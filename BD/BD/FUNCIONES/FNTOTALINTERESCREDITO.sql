-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNTOTALINTERESCREDITO
DELIMITER ;
DROP FUNCTION IF EXISTS `FNTOTALINTERESCREDITO`;
DELIMITER $$

CREATE FUNCTION `FNTOTALINTERESCREDITO`(
# ----------------------------------------------------------------------------------------------------------
#		================ FUNCION PARA CONSULTAR EL TOTAL DE INTERES ADEUDADO DE UN CREDITO ================
#-----------------------------------------------------------------------------------------------------------
    Par_CreditoID   BIGINT(12)
) RETURNS decimal(12,2)
    DETERMINISTIC
BEGIN

	# Declareacion de Variables
    DECLARE Var_DiasPermPagAnt  	INT(11);			# Dias permitidos para pago anticipado
    DECLARE Var_IntAnticipado   	DECIMAL(14,4);		# Indica si permite proyeccion de interes en pago anticipado
    DECLARE Var_NumProyInteres  	INT(11);
	DECLARE Var_Interes    			DECIMAL(14,4);		#
    DECLARE Var_IntProvisionActual  DECIMAL(14,4);		# Saldo de interes provisionado actualmente
    DECLARE Var_CapitaAdelanta  	DECIMAL(14,2);
    DECLARE Var_TotalPagoAdelanta  	DECIMAL(14,2);		# Total de pago adelatado + proyectado
	DECLARE Var_ProducCreditoID 	INT(11);			# Producto de credito
	DECLARE Var_Frecuencia			CHAR(1);			# Frecuencia de pago de capital
	DECLARE Var_FechaExigible   	DATE;				# Fecha exigible del proximo pago
	DECLARE Var_FechaVencim   		DATE;				# Fecha de vencimiento del proximo pago
	DECLARE Var_AmortizacionID		INT(5);				# ID de la amortizacion proxima a pagar
	DECLARE Var_FechaSistema		DATE;				# Fecha actual del sistema
	DECLARE Var_DiasAnticipa    	INT(11);			# Dias anticipado
	DECLARE Var_ProyInteresPagAde 	CHAR(1);			# Indica di el producto de credito proyecta interes
	DECLARE Var_IVA			 		DECIMAL(12,2);		# Porcentaje de iva aplicado al interes ordinario
	DECLARE Var_PagaIVA				CHAR(1); 			# Indica si el cliente paga iva
	DECLARE Var_CobraIVAInteres		CHAR(1);			# Indica si cobra iva por interes ordinario
	DECLARE Var_CobraIVAMora		CHAR(1);		# Indica si cobra iva por interes moratorio
	DECLARE Var_EstatusCredito		CHAR(1);			# Estatus del credito
	DECLARE Var_SucursalID			INT(11);			# ID de la sucursal origen del cliente
	DECLARE Var_IVAInteresOrdi		DECIMAL(12,2);		# Porcentaje de iva aplicado a interes ordinario
	DECLARE Var_IVAInteresMora		DECIMAL(12,2);		# Porcentaje de iva aplicado a interes moratorio
	DECLARE Var_TotalInteres		DECIMAL(12,2);		# Total de interes adeudado por el credito


	# Declaracion de Constantes
	DECLARE Entero_Cero			INT(4);				# Constante cero
	DECLARE Estatus_Pagado		CHAR(1);			# Estatus pagado
	DECLARE Fecha_Vacia			DATE;				# Fecha vacia
	DECLARE ProyectaInteres_SI	CHAR(1);			# Si proyecta interes
	DECLARE SiPagaIVA       	CHAR(1);       		# Si paga IVA
	DECLARE Estatus_Vigente		CHAR(1);			# Estatus vigente
    DECLARE Estatus_Vencido		CHAR(1);			# Estatus vencido


	# Asignacion de Constantes
	SET Entero_Cero			:= 0;
	SET Estatus_Pagado		:= 'P';
	SET Fecha_Vacia			:= '1900-01-01';
	SET ProyectaInteres_SI	:= 'S';
	SET SiPagaIVA			:= 'S';
	SET Estatus_Vigente		:= 'V';
	SET Estatus_Vencido		:= 'B';


	# Inicializacion de variables
    SET Var_DiasPermPagAnt  	:= Entero_Cero;
    SET Var_IntAnticipado   	:= Entero_Cero;
    SET Var_NumProyInteres  	:= Entero_Cero;
	SET Var_Interes				:= Entero_Cero;
    SET Var_IntProvisionActual	:= Entero_Cero;
    SET Var_CapitaAdelanta  	:= Entero_Cero;
    SET Var_TotalPagoAdelanta  	:= Entero_Cero;

	SET Var_FechaSistema	:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

	SELECT Pro.ProducCreditoID,			Cre.FrecuenciaCap,		Cre.Estatus,			Pro.ProyInteresPagAde,		Cli.PagaIVA,
		   Cli.SucursalOrigen,			Pro.CobraIVAInteres,	Pro.CobraIVAMora
	INTO 	Var_ProducCreditoID,		Var_Frecuencia,			Var_EstatusCredito,		Var_ProyInteresPagAde,		Var_PagaIVA,
			Var_SucursalID,				Var_CobraIVAInteres,	Var_CobraIVAMora
	FROM CREDITOS Cre
			INNER JOIN PRODUCTOSCREDITO Pro ON (Cre.ProductoCreditoID = Pro.ProducCreditoID)
			INNER JOIN CLIENTES Cli ON (Cli.ClienteID = Cre.ClienteID)
	WHERE CreditoID = Par_CreditoID;

	SET Var_DiasPermPagAnt	:= IFNULL(( SELECT NumDias FROM CREDDIASPAGANT WHERE ProducCreditoID = Var_ProducCreditoID AND Frecuencia = Var_Frecuencia),Entero_Cero);


	IF (Var_PagaIVA = SiPagaIVA) THEN
		SET Var_IVA  := (SELECT IVA FROM SUCURSALES WHERE SucursalID = Var_SucursalID);

		IF (Var_CobraIVAInteres = SiPagaIVA) THEN
			SET Var_IVAInteresOrdi  := Var_IVA;
		ELSE
			SET Var_IVAInteresOrdi  := Entero_Cero;
		END IF;

		IF (Var_CobraIVAMora = SiPagaIVA) THEN
			SET Var_IVAInteresMora  := Var_IVA;
		ELSE
			SET Var_IVAInteresMora  := Entero_Cero;
		END IF;
	END IF;



	# Si permite pago anticipado se calcula si ya se esta dentro del rango de dias anticipado para la frecuencia
    IF(Var_DiasPermPagAnt > Entero_Cero) THEN
        SELECT MIN(FechaExigible), 	MIN(FechaVencim), 	MIN(AmortizacionID) INTO
               Var_FechaExigible, 	Var_FechaVencim, 	Var_AmortizacionID
		FROM AMORTICREDITO
		WHERE CreditoID   = Par_CreditoID
		  AND FechaVencim > Var_FechaSistema
		  AND Estatus     != Estatus_Pagado;
        SET Var_FechaExigible 	:= IFNULL(Var_FechaExigible, Fecha_Vacia);
        SET Var_FechaVencim		:= IFNULL(Var_FechaVencim, Fecha_Vacia);
        SET Var_AmortizacionID  := IFNULL(Var_AmortizacionID, Entero_Cero);

        IF(Var_FechaExigible != Fecha_Vacia) THEN
            SET Var_DiasAnticipa := DATEDIFF(Var_FechaExigible, Var_FechaSistema);
        ELSE
            SET Var_DiasAnticipa := Entero_Cero;
        END IF;


        SELECT Amo.NumProyInteres, 	Amo.Interes,
               IFNULL(Amo.SaldoInteresPro, Entero_Cero) + IFNULL(Amo.SaldoIntNoConta, Entero_Cero) INTO
                Var_NumProyInteres, Var_Interes, 	Var_IntProvisionActual
            FROM AMORTICREDITO Amo
            WHERE Amo.CreditoID     	= Par_CreditoID
              AND Amo.AmortizacionID 	= Var_AmortizacionID
              AND Amo.Estatus     		!= Estatus_Pagado;
        SET Var_NumProyInteres  	:= IFNULL(Var_NumProyInteres, Entero_Cero);
        SET Var_IntProvisionActual 	:= IFNULL(Var_IntProvisionActual, Entero_Cero);
		SET	Var_Interes				:= IFNULL(Var_Interes, Entero_Cero);



        IF(Var_NumProyInteres = Entero_Cero) THEN
            IF(Var_DiasAnticipa <= Var_DiasPermPagAnt AND Var_ProyInteresPagAde = ProyectaInteres_SI) THEN
				SET Var_IntAnticipado := Entero_Cero;

                IF(Var_IntAnticipado < Entero_Cero) THEN
                    SET Var_IntAnticipado := Entero_Cero;
                END IF;
            END IF;
        END IF;

        IF(Var_DiasAnticipa <= Var_DiasPermPagAnt) THEN
            SET Var_TotalPagoAdelanta := 	ROUND(Var_IntAnticipado + Var_IntProvisionActual,2) +
											ROUND(ROUND(Var_IntAnticipado + Var_IntProvisionActual,2) * Var_IVAInteresOrdi, 2);
        END IF;
    END IF;



	SET Var_TotalInteres	:=
				(SELECT SUM(IFNULL(ROUND(SaldoInteresOrd,2),Entero_Cero) +

						   IFNULL(ROUND(SaldoInteresAtr,2),Entero_Cero) +

						   IFNULL(ROUND(SaldoInteresVen,2),Entero_Cero) +

						   IFNULL(ROUND(SaldoInteresPro + CASE WHEN AmortizacionID = Var_AmortizacionID THEN
																				CASE WHEN Var_EstatusCredito = Estatus_Vigente
																						THEN Var_IntAnticipado
																				ELSE Entero_Cero END
																	  ELSE Entero_Cero END,2),
										  Entero_Cero) +

						   IFNULL(ROUND(SaldoIntNoConta,2) + CASE WHEN AmortizacionID = Var_AmortizacionID THEN
																				CASE WHEN Var_EstatusCredito = Estatus_Vencido
																						THEN Var_IntAnticipado
																				ELSE Entero_Cero END
																	  ELSE Entero_Cero END
										,Entero_Cero)  +

							IFNULL(ROUND(ROUND(SaldoInteresOrd * Var_IVAInteresOrdi,2) +
													ROUND(SaldoInteresAtr * Var_IVAInteresOrdi,2) +
													ROUND(SaldoInteresVen * Var_IVAInteresOrdi,2) +
													ROUND(SaldoIntNoConta * Var_IVAInteresOrdi,2) +
													CASE WHEN AmortizacionID = Var_AmortizacionID THEN Entero_Cero
														 ELSE
															ROUND(SaldoInteresPro * Var_IVAInteresOrdi,2)
													END +
													CASE WHEN AmortizacionID = Var_AmortizacionID
															THEN ROUND(ROUND(SaldoInteresPro + Var_IntAnticipado,2) * Var_IVAInteresOrdi,2)
															ELSE Entero_Cero END,2),0)  +

							IFNULL((SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen),Entero_Cero) +

							IFNULL(ROUND(SaldoMoratorios * Var_IVAInteresMora, 2)  +
											   ROUND(SaldoMoraVencido * Var_IVAInteresMora, 2) +
											   ROUND(SaldoMoraCarVen * Var_IVAInteresMora, 2) ,Entero_Cero))

					FROM AMORTICREDITO
					WHERE CreditoID = Par_CreditoID
					   AND Estatus <> Estatus_Pagado);

	SET Var_TotalInteres := IFNULL(Var_TotalInteres, Entero_Cero);
       RETURN Var_TotalInteres;
END$$