-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITONOMINABEREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITONOMINABEREP`;
DELIMITER $$


CREATE PROCEDURE `CREDITONOMINABEREP`(
	# ==================================================================================================================
	#  ----------------- SP QUE SIRVE PARA GENERAR EL REPORTE DE DESCUENTOS EN EL MODULO DE NOMINA ---------------------
	# ==================================================================================================================
	Par_InstitNominaID      INT,				# Id de la institucion de nomina
	Par_NumLis				TINYINT UNSIGNED,	# Numero de lista

	Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
	)

TerminaStore: BEGIN

	# Declaracion de variables
	DECLARE Var_ClienteID			INT(11);
	DECLARE Var_FolioCtrl			VARCHAR(20);
	DECLARE Var_NombreCliente		VARCHAR(100);
	DECLARE Var_CreditoID			BIGINT(12);
	DECLARE Var_MontoExigible		DECIMAL(14,2);
	DECLARE Var_TotalAde			DECIMAL(14,2);
	DECLARE Var_MontoPag			DECIMAL(14,2);
	DECLARE Var_ProxFecPag			VARCHAR(20);
	DECLARE Var_Plazo				VARCHAR(30);
	DECLARE Var_NomInstit			VARCHAR(200);
	DECLARE Var_NumPago				INT;
	DECLARE Var_TotAtrasado			DECIMAL(14,2);
	DECLARE Var_FecActual			DATE;
	DECLARE Var_IVASucurs   		DECIMAL(12,2);
	DECLARE Var_SucCredito  		INT;
	DECLARE Var_CliPagIVA   		CHAR(1);
	DECLARE Var_IVAIntOrd   		CHAR(1);
	DECLARE Var_ProuctoID			INT(11);
	DECLARE Var_ValIVAIntOr 		DECIMAL(12,2);
	DECLARE Var_ValIVAIntMo 		DECIMAL(12,2);
	DECLARE Var_ValIVAGen   		DECIMAL(12,2);
	DECLARE Var_IVAIntMor   		CHAR(1);
	DECLARE Var_TotalDeudaCre		DECIMAL(12,2);
	DECLARE Var_Accesorios			DECIMAL(14,2);
	DECLARE Var_InteresAccesorio	DECIMAL(14,2);
	DECLARE Var_IvaInteresAccesorio	DECIMAL(14,2);

	# Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Decimal_Cero		DECIMAL(12,2);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT;
	DECLARE Sta_Activo			CHAR(1);
	DECLARE EstatusVigente      CHAR(1);
	DECLARE EstatusVencido      CHAR(1);
	DECLARE EstatusPagado       CHAR(1);
	DECLARE EstatusAtrasado		CHAR(1);
	DECLARE	Lis_DescNom			INT;
	DECLARE FechaSist           DATE;   -- Fecha del sistema
	DECLARE CliIVASI            CHAR(1);
	DECLARE Estatus_Baja        CHAR(1);


	# Declaracion de cursor
	DECLARE CREDITOSEMPNOM CURSOR FOR
		SELECT  Cre.CreditoID,  		IFNULL(FolioCtrl, Cadena_Vacia) AS FolioCtrl,
				NombreCompleto, 		Descripcion AS Plazo,
				NombreInstit,			MIN(AmortizacionID) AS NumPago ,
				MIN(Amr.FechaExigible),	MIN(Cre.SucursalID),
				MIN(Cli.PagaIVA), 		MIN(Cre.ProductoCreditoID), MIN(Cre.ClienteID)
		FROM INSTITNOMINA Ins
				INNER JOIN SOLICITUDCREDITOBE Sol ON Ins.InstitNominaID=Sol.InstitNominaID
				INNER JOIN  CREDITOS Cre ON Sol.SolicitudCreditoID =Cre.SolicitudCreditoID
				INNER JOIN AMORTICREDITO  Amr ON Cre.CreditoID = Amr.CreditoID AND Amr.Estatus  IN (EstatusVigente, EstatusVencido,EstatusAtrasado)
				INNER JOIN CREDITOSPLAZOS Pla ON Cre.PlazoID =Pla.PlazoID
				INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID
				INNER JOIN NOMINAEMPLEADOS Nom ON Cli.ClienteID=Nom.ClienteID
		WHERE Amr.CreditoID=Cre.CreditoID
			AND Ins.InstitNominaID = Par_InstitNominaID
			AND Nom.Estatus != Estatus_Baja
		GROUP BY Cre.CreditoID;

	# Asignacion de constantes
	SET	Cadena_Vacia	:= '';            -- Cadena Vacia
	SET	Decimal_Cero	:= 0.0;			  -- Decimal Cero
	SET	Fecha_Vacia		:= '1900-01-01';  -- Fecha Vacia
	SET	Entero_Cero		:= 0;             -- Entero Cero
	SET	Sta_Activo		:= 'A';			  -- Estatus de Activo
	SET	EstatusVigente  := 'V';           -- Estatus de Credito Vigente
	SET	EstatusVencido  := 'B';           -- Estatus de Credito vencido
	SET	EstatusAtrasado := 'A';   		  -- Estatus de Credito Atrasado
	SET	EstatusPagado   := 'P';           -- Estatus de Credito Pagado
	SET	Lis_DescNom		:= 1; 		      -- Lista para Reporte de Descuentos Nomina
	SET CliIVASI        := 'S';			  -- Constante para comparacion si el cliente Paga Iva o no
	SET Estatus_Baja    := 'B';			  -- Estatus Baja

	SELECT FechaSistema INTO Var_FecActual FROM PARAMETROSSIS;



	IF(Par_NumLis = Lis_DescNom) THEN
		-- Creacion de Tabla Temporal
		DROP TABLE IF EXISTS   TMPORAL;
		CREATE TEMPORARY TABLE TMPORAL(
				ClienteID  		  	INT(11),
				CreditoID  		  	BIGINT(12),
				FolioCtrl    	  	VARCHAR(200),
				NombreCompleto 	  	VARCHAR(200),
				Plazo             	VARCHAR(200),
				NombreInstitucion 	VARCHAR(200),
				NumPago           	INT,
				FechaExigible     	DATE,
				MontoPago         	DECIMAL(14,2),
				MontoAtraso       	DECIMAL(14,2),
				MontoExigible     	DECIMAL(14,2),
				MontoTotal        	DECIMAL(14,2),
				AdeudoTotal       	DECIMAL(14,2),
				Accesorios       	DECIMAL(14,2),
				InteresAccesorio    DECIMAL(14,2),
				IvaInteresAccesorio DECIMAL(14,2)
			);



		OPEN  CREDITOSEMPNOM;
			BEGIN
			DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			CICLOCREDITOSCLIEN: LOOP

				FETCH CREDITOSEMPNOM  INTO
					Var_CreditoID, Var_FolioCtrl,	Var_NombreCliente,	Var_Plazo,		Var_NomInstit,
					Var_NumPago,   Var_ProxFecPag,	Var_SucCredito,		Var_CliPagIVA,	Var_ProuctoID,
					Var_ClienteID;

				SET Var_IVAIntOrd := (SELECT Pro.CobraIVAInteres FROM PRODUCTOSCREDITO Pro WHERE ProducCreditoID = Var_ProuctoID);
				SET Var_IVAIntMor :=(SELECT  Pro.CobraIVAMora FROM PRODUCTOSCREDITO Pro WHERE ProducCreditoID = Var_ProuctoID);

				SET Var_ValIVAIntOr := Decimal_Cero;
				SET Var_ValIVAIntMo := Decimal_Cero;
				SET Var_ValIVAGen   := Decimal_Cero;

				IF(Var_CliPagIVA= CliIVASI) THEN
					SET	Var_IVASucurs	:= IFNULL((SELECT IVA FROM SUCURSALES WHERE SucursalID = Var_SucCredito), Decimal_Cero);

					-- IVA General (Comisiones y Otro Cargos)
					SET Var_ValIVAGen  := Var_IVASucurs;

					-- Verificamos si Paga IVA de Interes Ordinario
					IF (Var_IVAIntOrd = CliIVASI) THEN
						SET Var_ValIVAIntOr  := Var_IVASucurs;
					END IF;

					IF (Var_IVAIntMor = CliIVASI) THEN
						SET Var_ValIVAIntMo  := Var_IVASucurs;
					END IF;
				END IF;

				SET Var_TotAtrasado := (SELECT  ROUND(IFNULL(
															SUM(ROUND(SaldoCapVigente,2) + ROUND(SaldoCapAtrasa,2) +
																ROUND(SaldoCapVencido,2) + ROUND(SaldoCapVenNExi,2) +

																  ROUND(SaldoInteresOrd + SaldoInteresAtr +
																		SaldoInteresVen + SaldoInteresPro + SaldoIntNoConta, 2) +

																  ROUND(ROUND(SaldoInteresOrd * Var_ValIVAIntOr, 2) +
																		ROUND(SaldoInteresAtr * Var_ValIVAIntOr, 2) +
																		ROUND(SaldoInteresVen * Var_ValIVAIntOr, 2) +
																		ROUND(SaldoInteresPro * Var_ValIVAIntOr, 2) +
																		ROUND(SaldoIntNoConta * Var_ValIVAIntOr, 2),2)+

																  ROUND(SaldoComFaltaPa,2) + ROUND(ROUND(SaldoComFaltaPa,2) * Var_ValIVAGen,2) +
																  ROUND(SaldoComServGar,2) + ROUND(ROUND(SaldoComServGar,2) * Var_ValIVAGen,2) +
																  ROUND(SaldoOtrasComis,2) + ROUND(ROUND(SaldoOtrasComis,2) * Var_ValIVAGen,2) +
																  ROUND(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen,2) +
																  ROUND(ROUND(SaldoMoratorios * Var_ValIVAIntMo,2)+
																		ROUND(SaldoMoraVencido * Var_ValIVAIntMo,2)+
																		ROUND(SaldoMoraCarVen * Var_ValIVAIntMo,2),2)
																 ),
															   Entero_Cero)
														, 2)
										FROM AMORTICREDITO
										WHERE FechaExigible < Var_FecActual
											  AND Estatus IN (EstatusAtrasado, EstatusVencido)
											  AND CreditoID = Var_CreditoID);

				SET Var_MontoPag = (SELECT SUM(Capital+Interes+IVAInteres+ MontoOtrasComisiones + MontoIVAOtrasComisiones + MontoIntOtrasComis + MontoIVAIntComisi)
										FROM AMORTICREDITO WHERE CreditoID=Var_CreditoID
									   AND  AmortizacionID = Var_NumPago);

				SET Var_TotAtrasado		:= IFNULL( Var_TotAtrasado, Decimal_Cero);
				SET Var_MontoPag		:= IFNULL( Var_MontoPag, Decimal_Cero);
				SET Var_TotalAde		:= FUNCIONCONPAGOANTCRE(Var_CreditoID);	# Exible al dia mas pago adenlantado
				SET Var_MontoExigible	:= FUNCIONEXIGIBLE(Var_CreditoID);		# Monto exigible a la fecha
				SET Var_TotalDeudaCre	:= FUNCIONTOTDEUDACRE(Var_CreditoID);  # Aduedo total del credito

				SET Var_Accesorios			:= IFNULL(
												(SELECT (SUM(SaldoOtrasComis) + SUM(SaldoIntOtrasComis) + SUM(SaldoIVAIntComisi))
													FROM AMORTICREDITO
									   					WHERE CreditoID = Var_CreditoID), Decimal_Cero );

				SET Var_InteresAccesorio	:= IFNULL(
												(SELECT SUM(SaldoIntOtrasComis)
													FROM AMORTICREDITO
									   					WHERE CreditoID = Var_CreditoID), Decimal_Cero );

				SET Var_IvaInteresAccesorio	:= IFNULL(
												(SELECT SUM(SaldoIVAIntComisi)
													FROM AMORTICREDITO
									   					WHERE CreditoID = Var_CreditoID), Decimal_Cero );

				INSERT INTO TMPORAL VALUES (
					Var_ClienteID,			Var_CreditoID,	Var_FolioCtrl,		Var_NombreCliente,	Var_Plazo,
					Var_NomInstit,			Var_NumPago,	Var_ProxFecPag,		Var_MontoPag,		Var_TotAtrasado,
					Var_MontoExigible,		Var_TotalAde,	Var_TotalDeudaCre, 	Var_Accesorios, 	Var_InteresAccesorio,
					Var_IvaInteresAccesorio);
			END LOOP;
			END;

		CLOSE CREDITOSEMPNOM;


		# ------------ SE OBTIENES LOS DATOS PARA MOSTRAR EN EL REPORTE -----------------------------
		SELECT	CreditoID,	FolioCtrl,		  NombreCompleto,							Plazo,		 NombreInstitucion,
				NumPago,	FechaExigible,	  MontoPago,								MontoAtraso, MontoExigible,
				MontoTotal,	AdeudoTotal,	  CONVERT(TIME(NOW()),CHAR) AS HoraEmision,	ClienteID,
				Accesorios, InteresAccesorio, IvaInteresAccesorio
		FROM TMPORAL;

		DROP TABLE IF EXISTS TMPORAL;
	END IF; # FIN IF(Par_NumLis = Lis_DescNom) THEN

END TerminaStore$$
