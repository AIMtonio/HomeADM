-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BANAMORTICREDITOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `BANAMORTICREDITOLIS`;

DELIMITER $$
CREATE PROCEDURE `BANAMORTICREDITOLIS`(
	# =================================================================
	# ----------- SP PARA LISTAS DE AMORTIZACION DEL CREDITO PARA BANCA MOVIL -----------
	# =================================================================
	Par_CreditoID			BIGINT(11),				-- Numero de Credito
	Par_TamanioLista		INT(11),				-- Parametro tamanio de la lista
	Par_NumLis				TINYINT UNSIGNED,		-- Numero de Lista

	Aud_Empresa				INT(11),				-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),				-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,				-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),			-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),			-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),				-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)				-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_EstatusISR	CHAR(1);

	DECLARE Var_FechaRegistro   DATE;

	DECLARE Var_CobraSeguroCuota    		CHAR(1);
	DECLARE Var_CobraIVASeguroCuota   		CHAR(1);
	DECLARE Var_TotalMontoSeguroCuota   	DECIMAL(12,2);
	DECLARE Var_TotalIVASeguroCuota   		DECIMAL(12,2);
	DECLARE Var_TotalOtrasComisiones  		DECIMAL(12,2);
	DECLARE Var_TotalIVAOtrasComisiones 	DECIMAL(12,2);

	DECLARE Var_PagaIVA       				CHAR(1);
	DECLARE Var_IVA           				DECIMAL(12,2);
	DECLARE Var_PagaIVAInt    				CHAR(1);
	DECLARE Var_PagaIVAMor    				CHAR(1);
	DECLARE Var_IVAMora       				DECIMAL(12,2);
	DECLARE Var_TotalCap    				DECIMAL(14,2);
	DECLARE Var_TotalInt    				DECIMAL(14,2);
	DECLARE Var_TotalIva    				DECIMAL(14,2);
	DECLARE Var_TipoCredito   				CHAR(1);
	DECLARE Var_TipoCalInteres  			INT(11);
	DECLARE Var_CobraAccesoriosGen  		CHAR(1);
	DECLARE Var_IVASucursal     			DECIMAL(12,2);

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia			CHAR(1);			-- Cadena VAcia
	DECLARE	Fecha_Vacia				DATE;				-- Fecha Vacia
	DECLARE	Entero_Cero				INT(11);			-- Entero Cero
	DECLARE Decimal_Cero    		DECIMAL(12,2);		-- Decimal Cero
	DECLARE SIPagaIVA     			CHAR(1);
	DECLARE NOPagaIVA     			CHAR(1);
	DECLARE Int_SalInsol    		INT(11);
	DECLARE Int_SalGlobal   		INT(11);
	DECLARE Llave_CobraAccesorios 	VARCHAR(100);
	DECLARE EstDesembolso       	CHAR(1);
	DECLARE Reestructura    		CHAR(1);

	DECLARE Lis_AmortCredito	INT(1);				-- Opcion para lista de Amortizacion del credito del cliente
	DECLARE Con_Saldos          INT(1);

	-- Asignacion de constantes
	SET	Cadena_Vacia			:= '';				-- Cadena VAcia
	SET	Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
	SET	Entero_Cero				:= 0;				-- Entero Cero
	SET Decimal_Cero			:=0.00;				-- Decimal cero
	SET SIPagaIVA           	:= 'S';
	SET NOPagaIVA           	:= 'N';
	SET Int_SalInsol        	:= 1;
	SET Int_SalGlobal       	:= 2;
	SET Llave_CobraAccesorios	:= 'CobraAccesorios';
	SET EstDesembolso     		:= 'D';
	SET Reestructura      	    := 'R';

	SET	Lis_AmortCredito		:= 1;				-- Opcion para lista de Amortizacion del credito del cliente
	SET Con_Saldos          	:= 2;

	-- Opcion para lista de Amortizacion del credito del cliente
	IF(Par_NumLis = Lis_AmortCredito) THEN
		SELECT	AmortizacionID,				CreditoID,					ClienteID,					CuentaID,				FechaInicio,
				FechaVencim,				FechaExigible,				FechaLiquida,				Capital,				Interes,
				IVAInteres,					SaldoCapVigente,			SaldoCapAtrasa,				SaldoCapVencido,		SaldoCapVenNExi,
				SaldoInteresOrd,			SaldoInteresAtr,			SaldoInteresVen,			SaldoInteresPro,		SaldoIntNoConta,
				SaldoIVAInteres,			SaldoMoratorios,			SaldoIVAMorato,				SaldoComFaltaPa,		SaldoIVAComFalP,
			    MontoOtrasComisiones,		MontoIVAOtrasComisiones,(SaldoComServGar + SaldoOtrasComis) AS SaldoOtrasComis,
                SaldoIVAComisi,			    ProvisionAcum,              SaldoCapital,				NumProyInteres,			SaldoMoraVencido,
				SaldoMoraCarVen,		    MontoSeguroCuota,           IVASeguroCuota,				SaldoSeguroCuota,		SaldoIVASeguroCuota,
                SaldoComisionAnual,		    SaldoComisionAnualIVA,      Estatus
			FROM AMORTICREDITO
			WHERE CreditoID = Par_CreditoID;
	END IF;
	IF(Par_NumLis = Con_Saldos) THEN

        SELECT FechaRegistro  INTO Var_FechaRegistro
        FROM REESTRUCCREDITO Res,
            CREDITOS Cre
        WHERE Res.CreditoOrigenID		= Par_CreditoID
            AND Res.CreditoDestinoID 	= Par_CreditoID
            AND Cre.CreditoID 			= Res.CreditoDestinoID
            AND Res.EstatusReest		= EstDesembolso
            AND Res.Origen 				= Reestructura;

		SELECT  Cli.PagaIVA,    		Suc.IVA,     				Pro.CobraIVAInteres,  			Pro.CobraIVAMora, 			Suc.IVA,
				Cre.TipoCredito,  		Cre.TipoCalInteres, 		Cre.CobraSeguroCuota, 			Cre.CobraIVASeguroCuota
		INTO  	Var_PagaIVA,    		Var_IVA,      				Var_PagaIVAInt,     			Var_PagaIVAMor,   			Var_IVAMora,
				Var_TipoCredito,  		Var_TipoCalInteres, 		Var_CobraSeguroCuota, 			Var_CobraIVASeguroCuota
			FROM CREDITOS Cre,
			CLIENTES Cli,
			SUCURSALES Suc,
			PRODUCTOSCREDITO Pro
			WHERE Cre.CreditoID 		= Par_CreditoID
			AND Cre.ClienteID 			= Cli.ClienteID
			AND Cli.SucursalOrigen 		= Suc.SucursalID
			AND Pro.ProducCreditoID 	= Cre.ProductoCreditoID;



		SET Var_CobraAccesoriosGen  := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = Llave_CobraAccesorios);
		SET Var_IVASucursal     	:= Var_IVA;

		SET Var_PagaIVA       		:= IFNULL(Var_PagaIVA, SIPagaIVA);
		SET Var_PagaIVAInt      	:= IFNULL(Var_PagaIVAInt, SIPagaIVA);
		SET Var_PagaIVAMor      	:= IFNULL(Var_PagaIVAMor, SIPagaIVA);
		SET Var_TipoCalInteres    	:= IFNULL(Var_TipoCalInteres, Int_SalInsol);
		SET Var_IVA         		:= IFNULL(Var_IVA, Entero_Cero);
		SET Var_IVAMora       		:= IFNULL(Var_IVAMora, Entero_Cero);
		SET Var_CobraAccesoriosGen  := IFNULL(Var_CobraAccesoriosGen,Cadena_Vacia);

		IF(Var_PagaIVA = NOPagaIVA ) THEN
			SET Var_IVA := Entero_Cero;
			SET Var_IVAMora := Entero_Cero;
		ELSE
			IF (Var_PagaIVAInt = NOPagaIVA) THEN
			SET Var_IVA := Entero_Cero;
			END IF;

			IF (Var_PagaIVAMor = NOPagaIVA) THEN
			SET Var_IVAMora := Entero_Cero;
			END IF;
		END IF;


		IF(Var_TipoCredito != Reestructura) THEN
			SELECT   	SUM(Capital),				SUM(Interes), 					SUM(IVAInteres),  	SUM(MontoSeguroCuota),  	SUM(IVASeguroCuota),
						SUM(SaldoOtrasComis),  		SUM(SaldoIVAComisi)
			INTO 		Var_TotalCap,				Var_TotalInt,					Var_TotalIva,  		Var_TotalMontoSeguroCuota,  Var_TotalIVASeguroCuota,
						Var_TotalOtrasComisiones, 	Var_TotalIVAOtrasComisiones
			FROM AMORTICREDITO
			WHERE CreditoID = Par_CreditoID;
			ELSE
			SELECT 	SUM(Amo.Capital),    			SUM(Amo.Interes), 					SUM(Amo.IVAInteres),  	SUM(Amo.MontoSeguroCuota),  	SUM(Amo.IVASeguroCuota),
					SUM(Amo.SaldoOtrasComis),  		SUM(Amo.SaldoIVAComisi)
			INTO 	Var_TotalCap,      				Var_TotalInt,   					Var_TotalIva,			Var_TotalMontoSeguroCuota,    	Var_TotalIVASeguroCuota,
					Var_TotalOtrasComisiones, 		Var_TotalIVAOtrasComisiones
			FROM SOLICITUDCREDITO Sol
				INNER JOIN CREDITOS Cre
				ON Cre.SolicitudCreditoID 	= Sol.SolicitudCreditoID
				AND Sol.Estatus				= EstDesembolso
				AND Sol.TipoCredito			= Reestructura
				INNER JOIN REESTRUCCREDITO Res
				ON Res.CreditoOrigenID 		= Cre.CreditoID
				AND Res.CreditoDestinoID 	= Cre.CreditoID
				AND Cre.TipoCredito 		= Reestructura
				INNER JOIN AMORTICREDITO Amo
				ON Amo.CreditoID 			= Cre.CreditoID
				WHERE Amo.CreditoID 		= Par_CreditoID
				AND (Amo.FechaLiquida 		> Var_FechaRegistro
				OR Amo.FechaLiquida 		= Fecha_Vacia);
		END IF;


		SELECT AmortizacionID,  FechaInicio,        FechaVencim,        FechaExigible,
		CASE Estatus 	WHEN "I" THEN "INACTIVO"
						WHEN "V" THEN "VIGENTE"
						WHEN "P" THEN "PAGADO"
						WHEN "C" THEN "CANCELADO"
						WHEN "B" THEN "VENCIDO"
						WHEN "A" THEN "ATRASADO"
		END AS 	descEstatus,            Capital,            Interes,            IVAInteres,
				SaldoCapital,       	SaldoCapVigente,    SaldoCapAtrasa,     SaldoCapVencido,
		SaldoCapVenNExi,
		ROUND(SaldoInteresPro,2) AS SaldoInteresPro,
		ROUND(SaldoInteresAtr,2) AS SaldoInteresAtr,
		ROUND(SaldoInteresVen,2) AS SaldoInteresVen,
		ROUND(SaldoIntNoConta,2) AS SaldoIntNoConta,

		CASE Var_TipoCalInteres
		WHEN Int_SalInsol THEN
		ROUND(SaldoInteresPro * Var_IVA, 2) +
		ROUND(SaldoInteresAtr * Var_IVA, 2) +
		ROUND(SaldoInteresVen * Var_IVA, 2) +
		ROUND(SaldoIntNoConta * Var_IVA, 2)
		WHEN Int_SalGlobal THEN
		ROUND(IF((ROUND(SaldoInteresPro,2)+ROUND(SaldoInteresAtr,2)+ROUND(SaldoInteresVen,2)+ROUND(SaldoIntNoConta,2))=Interes,
		 IVAInteres,
		 ((ROUND(SaldoInteresPro,2)+ROUND(SaldoInteresAtr,2)+ROUND(SaldoInteresVen,2)+ROUND(SaldoIntNoConta,2)) * Var_IVA)), 2)
		END AS SaldoIVAInteres,

		(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen) AS SaldoMoratorios,

		ROUND(SaldoMoratorios * Var_IVAMora, 2) +
		ROUND(SaldoMoraVencido * Var_IVAMora, 2) +
		ROUND(SaldoMoraCarVen * Var_IVAMora, 2) AS SaldoIVAMora,

		SaldoComFaltaPa AS SaldoComFaltaPa,
		ROUND(SaldoComFaltaPa * Var_IVA, 2) AS SaldoIVAComFalPag,
		SaldoOtrasComis AS SaldoOtrasComis,


				CASE WHEN Var_CobraAccesoriosGen = SIPagaIVA THEN FNEXIGIBLEIVAACCESORIOS(Par_CreditoID, AmortizacionID,Var_IVASucursal, Var_PagaIVA)
		ELSE
			ROUND(SaldoOtrasComis * Var_IVA, 2)
				END  AS SaldoIVAOtrCom,
		ROUND(SaldoCapVigente + SaldoCapAtrasa + SaldoCapVencido +
		SaldoCapVenNExi + SaldoInteresPro + SaldoInteresAtr +
		SaldoInteresVen + SaldoIntNoConta +
		(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen) + SaldoComFaltaPa +
		SaldoOtrasComis, 2)  +

		ROUND(SaldoInteresPro * Var_IVA, 2) +
		ROUND(SaldoInteresAtr * Var_IVA, 2) +
		ROUND(SaldoInteresVen * Var_IVA, 2) +
		ROUND(SaldoIntNoConta * Var_IVA, 2) +
		ROUND(SaldoMoratorios * Var_IVAMora, 2) +
		ROUND(SaldoMoraVencido * Var_IVAMora, 2) +
		ROUND(SaldoMoraCarVen * Var_IVAMora, 2) +
		ROUND(SaldoComFaltaPa * Var_IVA, 2) +
			( CASE WHEN Var_CobraAccesoriosGen = SIPagaIVA THEN FNEXIGIBLEIVAACCESORIOS(Par_CreditoID, AmortizacionID,Var_IVASucursal, Var_PagaIVA)
		ELSE
			ROUND(SaldoOtrasComis * Var_IVA, 2)
				END ) +
		ROUND(SaldoComisionAnual, 2) +
		ROUND(SaldoComisionAnual * Var_IVA, 2) +
		ROUND(SaldoSeguroCuota,2) +
		ROUND(SaldoIVASeguroCuota,2) AS TotalCuota,

		ROUND(Capital + Interes + IVAInteres + IFNULL(MontoSeguroCuota,Decimal_Cero) + IFNULL(IVASeguroCuota,Decimal_Cero) + IFNULL(SaldoOtrasComis,Decimal_Cero) + IFNULL(SaldoIVAComisi,Decimal_Cero),2) AS MontoCuota,
		Var_TotalCap,Var_TotalInt,Var_TotalIva,

		ROUND(SaldoSeguroCuota,2) AS SaldoSeguroCuota,
		ROUND(SaldoIVASeguroCuota,2) AS SaldoIVASeguroCuota,
		ROUND(MontoSeguroCuota,2) AS MontoSeguroCuota,
		ROUND(IVASeguroCuota,2) AS IVASeguroCuota,
		Var_TotalMontoSeguroCuota AS TotalSeguroCuota,
		Var_TotalIVASeguroCuota AS TotalIVASeguroCuota,
		Var_CobraSeguroCuota AS CobraSeguroCuota,
		Var_CobraIVASeguroCuota AS CobraIVASeguroCuota,
		ROUND(SaldoComisionAnual, 2) AS SaldoComAnual,
		ROUND(SaldoComisionAnual * Var_IVA, 2) SaldoComAnualIVA,
				Var_TotalOtrasComisiones AS TotalOtrasComisiones,
				Var_TotalIVAOtrasComisiones AS TotalIVAOtrasComisiones,
				ROUND(SaldoOtrasComis,2) AS MontoOtrasComisiones,
				ROUND(SaldoIVAComisi,2) AS MontoIVAOtrasComisiones,
				ROUND(SaldoOtrasComis,2) AS SaldoOtrasComisiones
		FROM AMORTICREDITO
		WHERE CreditoID = Par_CreditoID;

	END IF;

END TerminaStore$$
