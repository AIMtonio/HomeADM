-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EXIGIBLECARTERAREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `EXIGIBLECARTERAREP`;
DELIMITER $$

CREATE PROCEDURE `EXIGIBLECARTERAREP`(
/* REPORTE EXIGIBLE DE CARTERA POR CLIENTE */
	Par_ClienteID           INT,
	Par_NombreInstitucion	VARCHAR(100),
	Par_FechaReporte		VARCHAR(20),
	Par_Usuario				VARCHAR(100),
    /* Parametros de Auditoria */
    Par_EmpresaID           INT(11),

    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),

    Aud_NumTransaccion      BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_Encabezado  		VARCHAR(400);
DECLARE Var_Credito				BIGINT(12);
DECLARE Var_SucCredito  		INT;
DECLARE Var_CliPagIVA   		CHAR(1);
DECLARE Var_IVAIntOrd   		CHAR(1);
DECLARE Var_IVAIntMor   		CHAR(1);
DECLARE Var_ValIVAIntOr 		DECIMAL(12,2);
DECLARE Var_ValIVAIntMo 		DECIMAL(12,2);
DECLARE Var_ValIVAGen   		DECIMAL(12,2);
DECLARE Var_IVASucurs   		DECIMAL(12,2);
DECLARE Var_TotalAdeudo   		DECIMAL(14,2);
DECLARE Var_TotAtrasado 		DECIMAL(14,2);
DECLARE Var_ProxFecPag			VARCHAR(20);
DECLARE Var_FechaExigible 		DATE;
DECLARE Var_MontoExigible		DECIMAL(14,2);
DECLARE Var_ClienteID			INT(11);
DECLARE Var_ProducCreditoID		INT(11);
DECLARE Var_Descripcion	    	VARCHAR(200);
DECLARE Var_FechaDesembolso		DATE;
DECLARE Var_FechaVtoFinal		DATE;
DECLARE Var_EstatusAmortizacion CHAR(40);
DECLARE Var_EstatusCredito		CHAR(50);
DECLARE Var_SaldoCapital		DECIMAL(14,2);
DECLARE Var_SaldoInteres		DECIMAL(14,2);
DECLARE Var_IvaInteres			DECIMAL(14,2);
DECLARE Var_Comisiones			DECIMAL(14,2);
DECLARE Var_SaldoMoratorios		DECIMAL(14,2);
DECLARE Var_Inicio				DATE;
DECLARE Var_Vencimiento			DATE;
DECLARE Var_DIASATRASO			INT(11);
DECLARE Var_TotAdeudo			DECIMAL(14,2);
DECLARE Var_TotalAde			VARCHAR(30);
DECLARE Var_MontoPag			VARCHAR(30);
DECLARE Var_CreditoID			BIGINT(12);
DECLARE Var_SucursalID			INT(11);
DECLARE Var_NombreSucurs		VARCHAR(100);
DECLARE Var_GrupoID				INT(11);
DECLARE Var_NombreGrupo			VARCHAR(100);
DECLARE Var_MontoCredito		DECIMAL(14,2);
DECLARE Var_NombreCliente		VARCHAR(100);
DECLARE Var_Adeudo				DECIMAL(14,2);
-- Declaracion de Constantes
DECLARE Cadena_Vacia			CHAR(1);
DECLARE Entero_Cero         	INT;
DECLARE Var_Vacio      			CHAR(1);
DECLARE EstatusVigente      	CHAR(1);
DECLARE EstatusAtras        	CHAR(1);
DECLARE EstatusInactivo     	CHAR(1);
DECLARE EstatusCancelado 		CHAR(1);
DECLARE EstatusVencido      	CHAR(1);
DECLARE EstatusPagado       	CHAR(1);
DECLARE EstatusCastigado       	CHAR(1);
DECLARE Cliente					INT(11);
DECLARE FechaSist           	DATE;   -- Fecha del sistema
DECLARE TotalAdeudo				VARCHAR(30);
DECLARE ProxPago				VARCHAR(20);
DECLARE MontoPago				VARCHAR(30);
DECLARE	SiPagaIVA		    	CHAR(1);
DECLARE fecha			    	VARCHAR(30);
DECLARE Var_AmortizacionID		INT(11);
DECLARE Con_nueve				INT(11);
DECLARE Var_CapVigIns			VARCHAR(20);
DECLARE	DescripcionVigente  	VARCHAR(20);
DECLARE	DescripcionAtras     	VARCHAR(20);
DECLARE	DescripcionInactivo  	VARCHAR(20);
DECLARE	DescripcionCancelado  	VARCHAR(20);
DECLARE	DescripcionVencido 		VARCHAR(20);
DECLARE	DescripcionPagado		VARCHAR(20);
DECLARE	DescripcionCastigado  	VARCHAR(20);
DECLARE EstatusSuspendido		CHAR(1); -- Estatus Ssupendidos
DECLARE DescripcionSuspendido 	VARCHAR(20);	-- Estatus Ssupendidos

DECLARE CURSOREXIGIBLECARTERA CURSOR FOR
SELECT Cre.CreditoID, Cli.PagaIVA, Cre.SucursalID, Pro.CobraIVAInteres, Pro.CobraIVAMora
        FROM CREDITOS Cre,
             PRODUCTOSCREDITO Pro,
             CLIENTES Cli
        WHERE ProductoCreditoID = ProducCreditoID
          AND Cre.ClienteID     = Cli.ClienteID
          AND Cre.ClienteID     = Par_ClienteID
		  AND Cre.Estatus IN ('V','B','S');

-- Asignacion de Constantes
SET Cadena_Vacia          := '';
SET	Entero_Cero           := 0;
SET	EstatusVigente        := 'V'; -- Estatus Vigente
SET	EstatusAtras          := 'A'; -- Estatus Atrasado
SET	EstatusInactivo       := 'I'; -- Estatus Inactivo
SET	EstatusCancelado      := 'C'; -- Estatus Cancelado
SET	EstatusVencido        := 'B'; -- Estatus Vencido
SET	EstatusPagado         := 'P'; -- Estatus Pagado
SET	EstatusCastigado	  := 'K'; -- Estatus Castigado
SET EstatusSuspendido	  := 'S'; -- Estatus Ssupendidos
SET SiPagaIVA			  := 'S';
SET Var_Vacio			  := '';
SET Con_nueve			  := 9; -- numero de consulta al store de CREPROXPAGCON
SET	DescripcionVigente    := 'VIGENTE';		-- Descripcion Vigente
SET	DescripcionAtras      := 'ATRASADO';	-- Descripcion Atrasado
SET	DescripcionInactivo   := 'INACTIVO';	-- Descripcion Inactivo
SET	DescripcionCancelado  := 'CANCELADO';	-- Descripcion Cancelado
SET	DescripcionVencido    := 'VENCIDO';		-- Descripcion Vencido
SET	DescripcionPagado     := 'PAGADO'; 		-- Descripcion Pagado
SET	DescripcionCastigado  := 'CASTIGADO';	-- Descripcion Castigado
SET DescripcionSuspendido := 'SUSPENDIDO';	-- Estatus Ssupendidos

DROP TABLE IF EXISTS TMPORAL;
CREATE TEMPORARY TABLE TMPORAL(
    `Tmp_Institucion`  	 VARCHAR(400),
    `Tmp_Credito`        VARCHAR(100),
    `Tmp_Adeudo`         VARCHAR(20),
	`Tmp_Ade`            DECIMAL(14,2),
    `Tmp_MontoPag`       DECIMAL(14,2) ,
	`Tmp_Proxpag`        VARCHAR(20),
    `Tmp_Cliente`  		 INT(11),
    `Tmp_Product`        INT(11),
    `Tmp_Desc`           VARCHAR(100) ,
	`Tmp_Desembolso`     DATE,
    `Tmp_FechaFin`       DATE,
	`Tmp_EstatAm`        VARCHAR(50),
	`Tmp_EstatCred`		 VARCHAR(50),
    `Tmp_SucusalID`      INT(11),
    `Tmp_NombreSuc`      VARCHAR(100) ,
	`Tmp_GrupoID`        INT(11),
    `Tmp_NombreGrupo`    VARCHAR(100) ,
	`Tmp_MontoCredito`   DECIMAL(14,2),
    `Tmp_DiasAtraso`     INT(11),
    `Tmp_SaldoCap`       DECIMAL(14,2) ,
	`Tmp_SaldoInt`       DECIMAL(14,2),
    `Tmp_IvaInt`         DECIMAL(14,2) ,
	`Tmp_SaldoMor`  	 DECIMAL(14,2),
    `Tmp_Comision`    	 DECIMAL(14,2),
    `Tmp_Inicio`     	 DATE,
	`Tmp_NombreCliente`  VARCHAR(100),
    `Tmp_SeguroCuota`  	 DECIMAL(14,2),
    `Tmp_IVASegCuota` 	 DECIMAL(14,2),
    INDEX (Tmp_Credito)
);
SET FechaSist := (SELECT FechaSistema FROM PARAMETROSSIS);

OPEN CURSOREXIGIBLECARTERA;
BEGIN
	DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
	LOOP
		FETCH CURSOREXIGIBLECARTERA
			INTO Var_CreditoID,  Var_CliPagIVA, Var_SucCredito, Var_IVAIntOrd, Var_IVAIntMor;

		CALL CREPROXPAGCON(Var_CreditoID,Con_nueve,Var_TotalAde,Var_MontoPag ,Var_ProxFecPag,Var_CapVigIns,Par_EmpresaID,
					   Aud_Usuario,	Aud_FechaActual,Aud_DireccionIP,Aud_ProgramaID,	Aud_Sucursal,
					   Aud_NumTransaccion);


		IF (Var_CliPagIVA = SiPagaIVA) THEN     -- El Cliente si paga IVA
			SET Var_IVASucurs	:= IFNULL((SELECT IVA
										FROM SUCURSALES
										 WHERE  SucursalID = Var_SucCredito),  Entero_Cero);
		ELSE
			SET	Var_IVASucurs	:= Entero_Cero;
		END IF;


		SET Var_SaldoMoratorios := (SELECT SUM(Amc.SaldoMoratorios + Amc.SaldoMoraVencido + Amc.SaldoMoraCarVen)
				FROM  CREDITOS Cre
						LEFT OUTER JOIN AMORTICREDITO Amc ON Cre.CreditoID = Amc.CreditoID
						INNER JOIN PRODUCTOSCREDITO   Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
						INNER JOIN CLIENTES Cli ON Cli.ClienteID=Cre.ClienteID
						INNER JOIN SUCURSALES Suc ON Suc.SucursalID=Cre.SucursalID
						LEFT OUTER JOIN GRUPOSCREDITO Gru	ON Gru.GrupoID=Cre.GrupoID
							WHERE Cre.CreditoID=Var_CreditoID
								AND Amc.Estatus IN (EstatusVigente, EstatusVencido, EstatusAtras)
								AND FechaExigible <= FechaSist );

		SET Var_SaldoMoratorios := IFNULL(Var_SaldoMoratorios,Entero_Cero);

		IF (Var_SaldoMoratorios > Entero_Cero) THEN

			INSERT INTO TMPORAL (
				Tmp_Cliente,	Tmp_Product,		Tmp_Desc,			Tmp_Desembolso ,	Tmp_FechaFin,
				Tmp_EstatAm,	Tmp_EstatCred,		Tmp_SaldoCap,		Tmp_SaldoInt,		Tmp_IvaInt,
				Tmp_SaldoMor,	Tmp_Comision,		Tmp_Inicio,			Tmp_SucusalID,		Tmp_NombreSuc,
				Tmp_GrupoID,	Tmp_NombreGrupo,	Tmp_MontoCredito,	Tmp_DiasAtraso,		Tmp_NombreCliente,
				Tmp_Institucion,Tmp_Credito,		Tmp_Adeudo,			Tmp_MontoPag,		Tmp_Proxpag,
				Tmp_SeguroCuota,Tmp_IVASegCuota)

			SELECT  MAX(Amc.ClienteID),MAX(Pro.ProducCreditoID),MAX(Pro.Descripcion),MIN(Amc.FechaInicio), MIN(Amc.FechaVencim),
					CASE  MAX(Amc.Estatus)
						  WHEN EstatusInactivo THEN DescripcionInactivo
						  WHEN EstatusAtras THEN DescripcionAtras
						  WHEN EstatusVigente THEN DescripcionVigente
						  WHEN EstatusVencido THEN DescripcionVencido
						  WHEN EstatusCancelado THEN DescripcionCancelado
						  WHEN EstatusPagado THEN DescripcionPagado
					END AS Var_EstatusAmortizacion,
					CASE MAX(Cre.Estatus)
						 WHEN EstatusInactivo THEN DescripcionInactivo
						 WHEN EstatusAtras THEN DescripcionAtras
						 WHEN EstatusVigente THEN DescripcionVigente
						 WHEN EstatusVencido THEN DescripcionVencido
						 WHEN EstatusCancelado THEN DescripcionCancelado
						 WHEN EstatusPagado THEN DescripcionPagado
						 WHEN EstatusCastigado THEN DescripcionCastigado
						 WHEN EstatusSuspendido THEN DescripcionSuspendido
					END AS Var_EstatusCredito,

					SUM(ROUND(Amc.SaldoCapVigente,2) + ROUND(Amc.SaldoCapAtrasa,2)+
						ROUND(Amc.SaldoCapVencido,2) + ROUND(Amc.SaldoCapVenNExi,2)),

					SUM(ROUND(Amc.SaldoInteresOrd,2) + ROUND(Amc.SaldoInteresAtr,2)+
						ROUND(Amc.SaldoInteresVen,2) + ROUND(Amc.SaldoIntNoConta,2)+ ROUND(Amc.SaldoInteresPro,2)),

					ROUND(SUM(
							ROUND(ROUND(Amc.SaldoInteresOrd,2) * Var_IVASucurs,2) +
							ROUND(ROUND(Amc.SaldoInteresAtr,2) * Var_IVASucurs,2) +
							ROUND(ROUND(Amc.SaldoInteresVen,2) * Var_IVASucurs,2) +
							ROUND(ROUND(Amc.SaldoInteresPro,2) * Var_IVASucurs,2) +
							ROUND(ROUND(Amc.SaldoIntNoConta,2) * Var_IVASucurs,2) +

							ROUND(ROUND(Amc.SaldoComFaltaPa,2) * Var_IVASucurs,2) +
							ROUND(ROUND(Amc.SaldoComServGar,2) * Var_IVASucurs,2) +
							ROUND(ROUND(Amc.SaldoOtrasComis,2) * Var_IVASucurs,2) +
							ROUND(ROUND(Amc.SaldoMoratorios + Amc.SaldoMoraVencido + Amc.SaldoMoraCarVen, 2) * Var_IVASucurs,2)
							),2),

					SUM(Amc.SaldoMoratorios + Amc.SaldoMoraVencido + Amc.SaldoMoraCarVen),
					SUM( ROUND(Amc.SaldoComFaltaPa,2) + ROUND(Amc.SaldoComServGar,2) + ROUND(Amc.SaldoOtrasComis,2)),
					MIN(Amc.FechaInicio),MAX(Cre.SucursalID), 	MAX(Suc.NombreSucurs),

					MAX(Gru.GrupoID),MAX(Gru.NombreGrupo),MAX(ROUND(Cre.MontoCredito,2)),FUNCIONDIASATRASO(Cre.CreditoID,(FechaSist)), MAX(Cli.NombreCompleto),
					Par_NombreInstitucion,	Var_CreditoID,	  Var_TotalAde,    CAST(REPLACE(Var_MontoPag,',','') AS DECIMAL(14,2)) ,      Var_ProxFecPag,
					SUM(ROUND(Amc.SaldoSeguroCuota,2)), SUM(ROUND(Amc.SaldoIVASeguroCuota,2))
					FROM  CREDITOS Cre
							LEFT OUTER JOIN AMORTICREDITO Amc ON Cre.CreditoID = Amc.CreditoID
							INNER JOIN PRODUCTOSCREDITO   Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
							INNER JOIN CLIENTES Cli ON Cli.ClienteID=Cre.ClienteID
							INNER JOIN SUCURSALES Suc ON Suc.SucursalID=Cre.SucursalID
							LEFT OUTER JOIN GRUPOSCREDITO Gru	ON Gru.GrupoID=Cre.GrupoID
								WHERE Cre.CreditoID=Var_CreditoID
									AND Amc.Estatus IN (EstatusVigente, EstatusVencido, EstatusAtras)
									AND FechaExigible <= FechaSist
						GROUP BY Cre.CreditoID;

		ELSE

			SET  Var_AmortizacionID := (SELECT MIN(AmortizacionID)
										FROM AMORTICREDITO
											WHERE CreditoID   = Var_CreditoID
											AND FechaExigible >= FechaSist
											AND Estatus		   != EstatusPagado);
			INSERT INTO TMPORAL (
				Tmp_Cliente,		Tmp_Product,		Tmp_Desc,			Tmp_Desembolso ,	Tmp_FechaFin,
				Tmp_EstatAm,		Tmp_EstatCred,		Tmp_SaldoCap,		Tmp_SaldoInt,		Tmp_IvaInt,
				Tmp_SaldoMor,		Tmp_Comision,		Tmp_Inicio,			Tmp_SucusalID,		Tmp_NombreSuc,
				Tmp_GrupoID,		Tmp_NombreGrupo,	Tmp_MontoCredito,	Tmp_DiasAtraso,		Tmp_NombreCliente,
				Tmp_Institucion,	Tmp_Credito,		Tmp_Adeudo,			Tmp_MontoPag,		Tmp_Proxpag,
				Tmp_SeguroCuota,	Tmp_IVASegCuota)
			SELECT  Amc.ClienteID,	Pro.ProducCreditoID,Pro.Descripcion,	Amc.FechaInicio, 	Amc.FechaVencim,
					CASE Amc.Estatus
						  WHEN EstatusInactivo THEN DescripcionInactivo
						  WHEN EstatusAtras THEN DescripcionAtras
						  WHEN EstatusVigente THEN DescripcionVigente
						  WHEN EstatusVencido THEN DescripcionVencido
						  WHEN EstatusCancelado THEN DescripcionCancelado
						  WHEN EstatusPagado THEN DescripcionPagado
					END AS Var_EstatusAmortizacion,
					CASE Cre.Estatus
						 WHEN EstatusInactivo THEN DescripcionInactivo
						 WHEN EstatusAtras THEN DescripcionAtras
						 WHEN EstatusVigente THEN DescripcionVigente
						 WHEN EstatusVencido THEN DescripcionVencido
						 WHEN EstatusCancelado THEN DescripcionCancelado
						 WHEN EstatusPagado THEN DescripcionPagado
						 WHEN EstatusCastigado THEN DescripcionCastigado
						 WHEN EstatusSuspendido THEN DescripcionSuspendido
					END AS Var_EstatusCredito,
					ROUND(Amc.Capital,2),	ROUND(Amc.Interes, 2), 			ROUND(Amc.IVAInteres, 2),

					(Amc.SaldoMoratorios + Amc.SaldoMoraVencido + Amc.SaldoMoraCarVen),	ROUND(Amc.SaldoComFaltaPa,2) + ROUND(Amc.SaldoComServGar,2)+ ROUND(Amc.SaldoOtrasComis,2),
					(Amc.FechaInicio),	 Cre.SucursalID, 		Suc.NombreSucurs,

					Gru.GrupoID,			Gru.NombreGrupo,			(ROUND(Cre.MontoCredito,2)),
					FUNCIONDIASATRASO(Cre.CreditoID,(FechaSist)),		Cli.NombreCompleto,

					Par_NombreInstitucion,	Var_CreditoID,	  Var_TotalAde,    CAST(REPLACE(Var_MontoPag,',','') AS DECIMAL(14,2)) ,      Var_ProxFecPag,
					ROUND(Amc.SaldoSeguroCuota,2), ROUND(Amc.SaldoIVASeguroCuota,2)
						FROM  CREDITOS Cre
							LEFT OUTER JOIN AMORTICREDITO Amc ON Cre.CreditoID = Amc.CreditoID
							INNER JOIN PRODUCTOSCREDITO   Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
							INNER JOIN CLIENTES Cli ON Cli.ClienteID=Cre.ClienteID
							INNER JOIN SUCURSALES Suc ON Suc.SucursalID=Cre.SucursalID
							LEFT OUTER JOIN GRUPOSCREDITO Gru	ON Gru.GrupoID=Cre.GrupoID
								WHERE Cre.CreditoID=Var_CreditoID
									AND Amc.Estatus IN (EstatusVigente, EstatusVencido, EstatusAtras)
									AND AmortizacionID = Var_AmortizacionID;

		END IF;
	END LOOP;
END;
CLOSE CURSOREXIGIBLECARTERA;

SELECT
		Tmp_Institucion,Tmp_Proxpag,    	Tmp_Credito, 	  	Tmp_GrupoID,    	Tmp_NombreGrupo,
		Tmp_EstatCred,  Tmp_Desembolso, 	Tmp_MontoCredito, 	Tmp_DiasAtraso, 	Tmp_Product,
		Tmp_Desc,      	Tmp_MontoPag, 		Tmp_Inicio,       	Tmp_FechaFin,   	Tmp_EstatAm,
		Tmp_SaldoCap,   Tmp_SaldoInt, 		Tmp_SaldoMor,     	Tmp_Comision,   	Tmp_IvaInt,
		Tmp_Adeudo ,	Tmp_NombreCliente,	Tmp_SeguroCuota,	Tmp_IVASegCuota
    FROM TMPORAL
		ORDER BY Tmp_Proxpag DESC, Tmp_Credito;

DROP TABLE TMPORAL;
END TerminaStore$$