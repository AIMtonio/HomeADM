-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AMORTICREDITOAGROLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `AMORTICREDITOAGROLIS`;
DELIMITER $$


CREATE PROCEDURE `AMORTICREDITOAGROLIS`(
/*SP para listar las amortizaciones de credito, se muestra en el pagare de credito*/
	Par_CreditoID			BIGINT(12),					# Numero de Credito
	Par_NumCon				TINYINT UNSIGNED,			# Numero de Consulta
	/* Parametros de Auditoria */
	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,

	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)

TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_FechaRegistro				DATE;
	DECLARE Var_IVA							DECIMAL(12,2);
	DECLARE Var_IVAMora						DECIMAL(12,2);
	DECLARE Var_PagaIVA						CHAR(1);
	DECLARE Var_PagaIVAInt					CHAR(1);
	DECLARE Var_PagaIVAMor					CHAR(1);
	DECLARE Var_TipoCalInteres				INT(11);
	DECLARE Var_TipoCredito 				CHAR(1);
	DECLARE Var_TotalCap					DECIMAL(14,2);
	DECLARE Var_TotalInt					DECIMAL(14,2);
	DECLARE Var_TotalIva					DECIMAL(14,2);
	DECLARE Var_CobraSeguroCuota			CHAR(1);				# Cobra Seguro por Cuota
	DECLARE Var_CobraIVASeguroCuota			CHAR(1);				# Cobra IVA seguro por Cuota
	DECLARE Var_TotalMontoSeguroCuota		DECIMAL(12,2);			# Total Monto Seguro por Cuota
	DECLARE Var_TotalIVASeguroCuota 		DECIMAL(12,2);			# Total IVA seguro por cuota
	DECLARE Var_FechaIniAmor				DATE;					# WS CREDICLUB
	DECLARE Var_FechaUltAmor				DATE;					# WS CREDICLUB
	DECLARE Var_MaxMontoCuota				DECIMAL(14,2);			# WS CREDICLUB
	DECLARE Var_ClienteID					INT;					# WS CREDICLUB

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia					CHAR(1);
	DECLARE Con_CalWSCRCB					INT; 			-- Calendario para WS Crediclub
	DECLARE Lis_amortPagare					INT; 			-- Consulta Principal
	DECLARE Decimal_Cero					DECIMAL(12,2);
	DECLARE Entero_Cero						INT;
	DECLARE EstDesembolso					CHAR(1);
	DECLARE Fecha_Vacia						DATE;
	DECLARE For_TasaFija					INT;
	DECLARE Int_SalGlobal					INT;
	DECLARE Int_SalInsol					INT;
	DECLARE NOPagaIVA						CHAR(1);
	DECLARE Reestructura					CHAR(1);
	DECLARE SIPagaIVA						CHAR(1);

	-- Asignacion de Constantes
	SET Cadena_Vacia						:= '';
	SET Lis_amortPagare						:= 3;				-- Tipo de Lista para el pagare
	SET Decimal_Cero						:= 0.00;
	SET Entero_Cero							:= 0;								# Entero Cero
	SET EstDesembolso						:= 'D';
	SET Fecha_Vacia							:= '1900-01-01';					# Fecha Vacia
	SET For_TasaFija						:= 1;								# Formula de Calculo de Interes: Tasa Fija
	SET Int_SalGlobal						:= 2;								# Calculo de Interes Sobre Saldos Globales (Monto Original)
	SET Int_SalInsol						:= 1;								# Calculo de Interes Sobre Saldos Insolutos
	SET NOPagaIVA  							:= 'N';
	SET Reestructura						:= 'R';
	SET SIPagaIVA							:= 'S';

	SELECT FechaRegistro  INTO Var_FechaRegistro
		FROM REESTRUCCREDITO Res,
			CREDITOS Cre
				WHERE Res.CreditoOrigenID= Par_CreditoID
					AND Res.CreditoDestinoID = Par_CreditoID
					AND Cre.CreditoID = Res.CreditoDestinoID
					AND Res.EstatusReest = EstDesembolso
					AND Res.Origen= Reestructura;

	IF(Par_NumCon = Lis_amortPagare) THEN
		SELECT Cre.TipoCredito INTO Var_TipoCredito
			FROM CREDITOS Cre,
				CLIENTES Cli,
				SUCURSALES Suc,
				PRODUCTOSCREDITO Pro
				WHERE Cre.CreditoID = Par_CreditoID
					AND Cre.ClienteID = Cli.ClienteID
					AND Cli.SucursalOrigen = Suc.SucursalID
					AND Pro.ProducCreditoID = Cre.ProductoCreditoID;

		IF(Var_TipoCredito != Reestructura) THEN
			SELECT
				SUM(Capital),		SUM(Interes),		SUM(IVAInteres),		SUM(MontoSeguroCuota),		SUM(IVASeguroCuota)
			INTO
				Var_TotalCap,		Var_TotalInt,		Var_TotalIva,			Var_TotalMontoSeguroCuota,	Var_TotalIVASeguroCuota
				FROM AMORTICREDITOAGRO
					WHERE CreditoID = Par_CreditoID;
		  ELSE
			SELECT
				SUM(Amo.Capital),	SUM(Amo.Interes),	SUM(Amo.IVAInteres),	SUM(Amo.MontoSeguroCuota),	SUM(Amo.IVASeguroCuota)
			INTO
				Var_TotalCap,		Var_TotalInt,		Var_TotalIva,			Var_TotalMontoSeguroCuota,	Var_TotalIVASeguroCuota
			FROM SOLICITUDCREDITO Sol
				INNER JOIN CREDITOS Cre
					ON Cre.SolicitudCreditoID = Sol.SolicitudCreditoID
					AND Sol.Estatus= EstDesembolso
					AND Sol.TipoCredito= Reestructura
				INNER JOIN REESTRUCCREDITO Res
					ON Res.CreditoOrigenID = Cre.CreditoID
					AND Res.CreditoDestinoID = Cre.CreditoID
					AND Cre.TipoCredito = Reestructura
				INNER JOIN AMORTICREDITOAGRO Amo
					ON Amo.CreditoID = Cre.CreditoID
				WHERE Amo.CreditoID = Par_CreditoID
					AND (Amo.FechaLiquida > Var_FechaRegistro
					OR Amo.FechaLiquida = Fecha_Vacia);
		END IF;

		SELECT
			AmortizacionID,				FechaInicio, 	FechaVencim, 	FechaExigible,		Estatus,
			Capital,					Interes,		IVAInteres,		MontoSeguroCuota,	IVASeguroCuota,
			(Capital+ Interes + IVAInteres + IFNULL(MontoSeguroCuota, Entero_Cero) + IFNULL(IVASeguroCuota, Entero_Cero))	AS TotalCuota,
			SaldoCapital,FORMAT(Var_TotalCap,2) AS TotalCapital,FORMAT(Var_TotalInt,2) AS TotalInteres,
			FORMAT(Var_TotalIva,2) AS TotalIVA,
			FORMAT(Var_TotalMontoSeguroCuota,2) AS TotalSeguroCuota,
			FORMAT(Var_TotalIVASeguroCuota,2) AS TotalIVASeguroCuota
			FROM AMORTICREDITOAGRO
				WHERE CreditoID = Par_CreditoID;
	END IF;
END TerminaStore$$