DELIMITER $$
DROP PROCEDURE IF EXISTS SALDOSCAPITALDIFERIDOREP$$

DELIMITER $$
CREATE PROCEDURE `SALDOSCAPITALDIFERIDOREP`(
    Par_Fecha			DATE,
    Par_Sucursal		INT(11),
    Par_Moneda			INT(11),
    Par_ProductoCre 	INT(11),
    Par_Promotor 		INT(11),

    Par_Genero 			CHAR(1),
    Par_Estado 			INT(11),
    Par_Municipio 		INT(11),
    Par_Criterio 		CHAR(1),
    Par_AtrasoInicial 	INT(11),

    Par_AtrasoFinal 	INT(11),
    Par_EmpresaID 		INT(11),
    Aud_Usuario 		INT(11),
    Aud_FechaActual 	DATETIME,
    Aud_DireccionIP 	VARCHAR(15),

    Aud_ProgramaID	 	VARCHAR(50),
    Aud_Sucursal 		INT(11),
    Aud_NumTransaccion 	BIGINT(20)		)
TerminaStore: BEGIN


	DECLARE pagoExigible        DECIMAL(12,2);
	DECLARE TotalCartera        DECIMAL(12,2);
	DECLARE TotalCapVigent      DECIMAL(12,2);
	DECLARE TotalCapVencido     DECIMAL(12,2);
	DECLARE nombreUsuario       VARCHAR(50);

	DECLARE Var_Sentencia       VARCHAR(9000);
    DECLARE Var_PerFisica       CHAR(1);


	DECLARE Con_PagareTfija     INT(11);
	DECLARE Con_Saldos          INT(11);
	DECLARE Con_PagareImp       INT(11);
	DECLARE Con_PagoCred        INT(11);


	DECLARE Cadena_Vacia        CHAR(1);
	DECLARE Fecha_Vacia         DATE;
	DECLARE Entero_Cero         INT(11);
	DECLARE Lis_SaldosRep       INT(11);
	DECLARE Con_Foranea         INT(11);

	DECLARE EstatusVigente      CHAR(1);

    DECLARE EstatusAtras        CHAR(1);
	DECLARE EstatusPagado       CHAR(1);
	DECLARE EstatusVencido      CHAR(1);
	DECLARE CienPorciento       DECIMAL(10,2);
	DECLARE FechaSist           DATE;

	DECLARE SiCobraIVA          CHAR(1);
	DECLARE CriterioConta       CHAR(1);
	DECLARE CriterioComer       CHAR(1);


	SET Cadena_Vacia            := '';
	SET Fecha_Vacia             := '1900-01-01';
	SET Entero_Cero             := 0;
	SET Lis_SaldosRep           := 4;
	SET EstatusVigente          := 'V';
	SET EstatusAtras            := 'A';
	SET EstatusPagado           := 'P';
	SET CienPorciento           := 100.00;
	SET EstatusVencido          := 'B';
	SET Var_PerFisica           := 'F';
	SET SiCobraIVA              := 'S';
	SET CriterioConta           := 'C';
	SET CriterioComer           := 'O';

	SET Aud_NumTransaccion := ROUND(RAND()*1000000);

	SET FechaSist := (SELECT FechaSistema FROM PARAMETROSSIS);

	DROP TABLE IF EXISTS tmp_TMPSALDOSCAPITALDIFERIDOREP;
	CREATE TEMPORARY TABLE `tmp_TMPSALDOSCAPITALDIFERIDOREP` (
		`Transaccion` bigint(20) DEFAULT NULL,
		`GrupoID` int(12) DEFAULT NULL,
		`NombreGrupo` varchar(200) DEFAULT NULL,
		`CreditoID` bigint(12) DEFAULT NULL,
		`ClienteID` int(12) DEFAULT NULL,
		`NombreCompleto` varchar(250) DEFAULT NULL,
		`ProductoCreditoID` int(12) DEFAULT NULL,
		`Descripcion` varchar(100) DEFAULT NULL,
		`MontoCredito` decimal(14,2) DEFAULT NULL,
		`FechaInicio` date DEFAULT NULL,
		`FechaVencimiento` date DEFAULT NULL,
		`CapitalVigente` decimal(14,2) DEFAULT NULL,
		`InteresesVigente` decimal(14,2) DEFAULT NULL,
		`MoraVigente` decimal(14,2) DEFAULT NULL,
		`CargosVigente` decimal(14,2) DEFAULT NULL,
		`IvaVigente` decimal(14,2) DEFAULT NULL,
		`TotalVigente` decimal(14,2) DEFAULT NULL,
		`CapitalVencido` decimal(14,2) DEFAULT NULL,
		`InteresesVencido` decimal(14,2) DEFAULT NULL,
		`MoraVencido` decimal(14,2) DEFAULT NULL,
		`CargosVencido` decimal(14,2) DEFAULT NULL,
		`IvaVencido` decimal(14,2) DEFAULT NULL,
		`TotalVencido` decimal(14,2) DEFAULT NULL,
		`DiasAtraso` int(12) DEFAULT NULL,
		`SucursalID` int(12) DEFAULT NULL,
		`NombreSucurs` varchar(50) DEFAULT NULL,
		`PromotorActual` int(12) DEFAULT NULL,
		`NombrePromotor` varchar(100) DEFAULT NULL,
		`FechaEmision` date DEFAULT NULL,
		`HoraEmision` time DEFAULT NULL,
		`EstatusCre` char(1) DEFAULT NULL,
		`DiasAtrasoCredDif` int(12) DEFAULT NULL,
	  KEY `tmp_TMPSALDOSCAPITALDIFERIDOREP_1` (`CreditoID`)
	) ENGINE=InnoDB DEFAULT CHARSET=latin1;

	SET Var_Sentencia := '
	INSERT INTO tmp_TMPSALDOSCAPITALDIFERIDOREP (
			Transaccion,        GrupoID,            NombreGrupo,        CreditoID,          ClienteID,
			NombreCompleto,     ProductoCreditoID,  Descripcion,        MontoCredito,       FechaInicio,
			FechaVencimiento,   CapitalVigente,     InteresesVigente,   MoraVigente,        CargosVigente,
			IvaVigente,         TotalVigente,       CapitalVencido,     InteresesVencido,   MoraVencido,
			CargosVencido,      IvaVencido,         TotalVencido,       DiasAtraso,         SucursalID,
			NombreSucurs,       PromotorActual,     NombrePromotor,     FechaEmision,       HoraEmision,
			EstatusCre,			DiasAtrasoCredDif)';
	IF(Par_Fecha < FechaSist) THEN
		SET Var_Sentencia :=    CONCAT(Var_Sentencia, '
		SELECT
		CONVERT("',Aud_NumTransaccion,'",UNSIGNED INT), IFNULL(Gpo.GrupoID, 0) ,    Gpo.NombreGrupo , SAL.CreditoID,    SAL.ClienteID,
		CLI.NombreCompleto,                             SAL.ProductoCreditoID,      PRO.Descripcion,  SAL.MontoCredito, SAL.FechaInicio,
		SAL.FechaVencimiento, ');

		IF(Par_Criterio = CriterioConta) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, '
		CASE WHEN SAL.EstatusCredito = "V" THEN SAL.SalCapVigente + SAL.SalCapAtrasado ELSE 0.00 END AS CapitalVigente,
		CASE WHEN SAL.EstatusCredito = "V" THEN (SAL.SalIntProvision + SAL.SalIntOrdinario +SAL.SalIntAtrasado) ELSE  0.00 END AS InteresesVigente,
		CASE WHEN SAL.EstatusCredito = "V" THEN (SAL.SalMoratorios + SAL.SaldoMoraVencido + SAL.SaldoMoraCarVen)  ELSE 0.00 END AS MoraVigente,
		CASE WHEN SAL.EstatusCredito = "V" THEN SAL.SalComFaltaPago ELSE 0.00 END AS CargosVigente,
		CASE WHEN SAL.EstatusCredito = "V" THEN ROUND( CASE WHEN   PRO.CobraIVAInteres="',SiCobraIVA,'"   OR PRO.CobraIVAInteres IS NULL  THEN
		(ROUND(SAL.SalIntAtrasado,2)+ ROUND(SAL.SalIntProvision,2))*(Suc.IVA)
		ELSE 0.00 END  +
		CASE WHEN   PRO.CobraIVAMora="',SiCobraIVA,'"  OR PRO.CobraIVAMora IS NULL THEN
		ROUND((SAL.SalMoratorios + SAL.SaldoMoraVencido + SAL.SaldoMoraCarVen) * (Suc.IVA),2)
		ELSE 0.00 END + ROUND( SAL.SalComFaltaPago *(Suc.IVA) ,2) ,2) ELSE 0.00 END AS IvaVigente,
		CASE WHEN SAL.EstatusCredito = "V" THEN ROUND( CASE WHEN   PRO.CobraIVAInteres="',SiCobraIVA,'"   OR PRO.CobraIVAInteres IS NULL  THEN
															(ROUND(SAL.SalIntAtrasado,2)+ ROUND(SAL.SalIntProvision,2)) * (Suc.IVA)
															ELSE 0.00 END  +
		CASE WHEN PRO.CobraIVAMora = "',SiCobraIVA,'"  OR PRO.CobraIVAMora IS NULL THEN
													   ROUND((SAL.SalMoratorios + SAL.SaldoMoraVencido + SAL.SaldoMoraCarVen) * (Suc.IVA),2)
													   ELSE 0.00 END + ROUND( SAL.SalComFaltaPago *(Suc.IVA) ,2) ,2) +
													   (SAL.SalCapVigente + SAL.SalCapAtrasado + SAL.SalIntProvision + SAL.SalIntOrdinario + SAL.SalIntAtrasado +
													   SAL.SalComFaltaPago + SAL.SalMoratorios + SAL.SaldoMoraVencido + SAL.SaldoMoraCarVen) ELSE 0.00 END AS TotalVigente,
		CASE WHEN SAL.EstatusCredito = "V" THEN 0.00 ELSE (SAL.SalCapVencido  + SAL.SalCapVenNoExi) END AS CapitalVencido,
		CASE WHEN SAL.EstatusCredito = "B" THEN (SAL.SalIntVencido) ELSE 0.00 END AS InteresesVencido,
		CASE WHEN SAL.EstatusCredito = "V" THEN 0.00 ELSE SAL.SalMoratorios + SAL.SaldoMoraVencido + SAL.SaldoMoraCarVen END AS MoraVencido,
		CASE WHEN SAL.EstatusCredito = "V" THEN 0.00 ELSE SAL.SalComFaltaPago END AS CargosVencido,
		CASE WHEN SAL.EstatusCredito = "V" THEN 0.00 ELSE ROUND(CASE WHEN   PRO.CobraIVAInteres="',SiCobraIVA,'"   OR PRO.CobraIVAInteres IS NULL  THEN
																	(ROUND(SAL.SalIntVencido,2)) * (Suc.IVA) ELSE 0.00 END  +
		CASE WHEN   PRO.CobraIVAMora="',SiCobraIVA,'"  OR PRO.CobraIVAMora IS NULL THEN
													   ROUND((SAL.SalMoratorios + SAL.SaldoMoraVencido + SAL.SaldoMoraCarVen) * (Suc.IVA),2)
													   ELSE 0.00 END + ROUND( SAL.SalComFaltaPago * (Suc.IVA) ,2) ,2) END AS IvaVencido,
		CASE WHEN SAL.EstatusCredito = "V" THEN 0.00 ELSE ROUND(CASE WHEN   PRO.CobraIVAInteres="',SiCobraIVA,'"   OR PRO.CobraIVAInteres IS NULL  THEN
													  (ROUND(SAL.SalIntVencido,2)) * (Suc.IVA) ELSE 0.00 END  +
		CASE WHEN   PRO.CobraIVAMora="',SiCobraIVA,'"  OR PRO.CobraIVAMora IS NULL THEN
														ROUND((SAL.SalMoratorios + SAL.SaldoMoraVencido + SAL.SaldoMoraCarVen) * (Suc.IVA),2) ELSE 0.00 END +
														ROUND( SAL.SalComFaltaPago *(Suc.IVA) ,2) ,2) +
														(SAL.SalCapVencido + SAL.SalCapVenNoExi) + (SAL.SalIntVencido+ SAL.SalIntAtrasado) +
														SAL.SalMoratorios + SAL.SaldoMoraVencido + SAL.SaldoMoraCarVen +
														SalComFaltaPago END AS TotalVencido,
	');
		ELSE
			SET Var_Sentencia := CONCAT(Var_Sentencia, '
		(SAL.SalCapVigente + SAL.SalCapVenNoExi) AS CapitalVigente,
		(SAL.SalIntProvision + SAL.SalIntOrdinario +SAL.SalIntNoConta) AS InteresesVigente, 0.0 AS MoraVigente, 0.0 AS CargosVigente,
		CASE WHEN   PRO.CobraIVAInteres="',SiCobraIVA,'"   OR PRO.CobraIVAInteres IS NULL  THEN
				(ROUND(SAL.SalIntProvision,2) + ROUND(SAL.SalIntOrdinario,2)+ ROUND(SAL.SalIntNoConta,2)) *
				(Suc.IVA) ELSE 0.00 END AS IvaVigente,
		(SAL.SalCapVigente + SAL.SalCapVenNoExi +
		CASE WHEN   PRO.CobraIVAInteres="',SiCobraIVA,'"   OR PRO.CobraIVAInteres IS NULL  THEN
				(ROUND(SAL.SalIntProvision,2) + ROUND(SAL.SalIntOrdinario,2)+ ROUND(SAL.SalIntNoConta,2)) *
				(Suc.IVA) ELSE 0.00 END +
		SAL.SalIntProvision + SAL.SalIntOrdinario+ SAL.SalIntNoConta) AS TotalVigente,
		(SAL.SalCapAtrasado + SAL.SalCapVencido) AS CapitalVencido,
		(SAL.SalIntAtrasado + SAL.SalIntVencido) AS InteresesVencido,
		SAL.SalMoratorios + SAL.SaldoMoraVencido + SAL.SaldoMoraCarVen AS MoraVencido ,
		SAL.SalComFaltaPago AS CargosVencido,
		ROUND(CASE WHEN   PRO.CobraIVAInteres="',SiCobraIVA,'"   OR PRO.CobraIVAInteres IS NULL  THEN
			(ROUND(SAL.SalIntAtrasado,2)+ ROUND(SAL.SalIntVencido,2)) *(Suc.IVA) ELSE 0.00 END  +
			CASE WHEN   PRO.CobraIVAMora="',SiCobraIVA,'"  OR PRO.CobraIVAMora IS NULL
		THEN ROUND((SAL.SalMoratorios + SAL.SaldoMoraVencido + SAL.SaldoMoraCarVen)  * (Suc.IVA),2) ELSE 0.00 END +
			ROUND( SAL.SalComFaltaPago *(Suc.IVA) ,2) ,2) AS IvaVencido,
		(SAL.SalCapAtrasado + SAL.SalCapVencido  +  SAL.SalIntAtrasado + SAL.SalIntVencido +
			SAL.SalMoratorios + SAL.SaldoMoraVencido + SAL.SaldoMoraCarVen + SAL.SalComFaltaPago +
			ROUND( CASE WHEN   PRO.CobraIVAInteres="',SiCobraIVA,'"   OR PRO.CobraIVAInteres IS NULL  THEN
			(ROUND(SAL.SalIntAtrasado,2)+ ROUND(SAL.SalIntVencido,2))*(Suc.IVA) ELSE 0.00 END  +
		CASE WHEN   PRO.CobraIVAMora="',SiCobraIVA,'"  OR PRO.CobraIVAMora IS NULL
		THEN ROUND((SAL.SalMoratorios + SAL.SaldoMoraVencido + SAL.SaldoMoraCarVen ) * (Suc.IVA),2) ELSE 0.00 END +
			 ROUND( SAL.SalComFaltaPago *(Suc.IVA),2) ,2)  + 0.0 ) AS TotalVencido,
	');
		END IF;
		SET Var_Sentencia :=    CONCAT(Var_Sentencia,
	   'SAL.DiasAtraso AS DiasAtraso,    SAL.Sucursal AS SucursalID, Suc.NombreSucurs,   CLI.PromotorActual,
		PROM.NombrePromotor,Par.FechaSistema AS FechaEmision, TIME(NOW()) AS HoraEmision, SAL.EstatusCredito AS EstatusCre,IFNULL(Dif.DiasDiferidos,0) AS DiasAtrasoCredDif
	FROM SALDOSCREDITOS SAL
	INNER JOIN  PARAMETROSSIS Par ON Par.EmpresaID=Par.EmpresaID
	INNER JOIN CREDITOS Cre ON Cre.CreditoID = SAL.CreditoID
	LEFT JOIN GRUPOSCREDITO Gpo ON Gpo.GrupoID = Cre.GrupoID
	INNER JOIN PRODUCTOSCREDITO PRO ON SAL.ProductoCreditoID = PRO.ProducCreditoID
	LEFT JOIN CREDITOSDIFERIDOS Dif ON SAL.CreditoID = Dif.CreditoID');

		SET Par_ProductoCre := IFNULL(Par_ProductoCre,Entero_Cero);
		IF(Par_ProductoCre!=0)THEN
			SET Var_Sentencia :=  CONCAT(Var_sentencia,' AND SAL.ProductoCreditoID =',CONVERT(Par_ProductoCre,CHAR));
		END IF;

		SET Var_Sentencia :=    CONCAT(Var_Sentencia,'
		INNER JOIN CLIENTES CLI ON SAL.ClienteID = CLI.ClienteID');

		SET Par_Genero := IFNULL(Par_Genero,Cadena_Vacia);
			IF(Par_Genero!=Cadena_Vacia)THEN
				SET Var_Sentencia := CONCAT(Var_sentencia,' AND CLI.Sexo="',Par_Genero,'" AND CLI.TipoPersona="',Var_PerFisica,'"');
		   END IF;

		SET Par_Estado := IFNULL(Par_Estado,Entero_Cero);
		IF(Par_Estado!=0)THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,'
		LEFT JOIN DIRECCLIENTE Dir ON CLI.ClienteID=Dir.ClienteID AND Dir.Oficial="',SiCobraIVA,'"  AND Dir.EstadoID= ',CONVERT(Par_Estado,CHAR));
		END IF;

		SET Par_Municipio := IFNULL(Par_Municipio,Entero_Cero);
		IF(Par_Municipio!=0)THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,'
		LEFT JOIN DIRECCLIENTE Dir ON CLI.ClienteID=Dir.ClienteID AND Dir.Oficial="',SiCobraIVA,'"  AND Dir.MunicipioID= ',CONVERT(Par_Municipio,CHAR));
		END IF;

		SET Var_Sentencia :=    CONCAT(Var_Sentencia,'
		INNER JOIN PROMOTORES PROM ON PROM.PromotorID=CLI.PromotorActual ');
		SET Par_Promotor := IFNULL(Par_Promotor,Entero_Cero);
		IF(Par_Promotor!=0)THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,'  AND PROM.PromotorID=',CONVERT(Par_Promotor,CHAR));
		END IF;
		SET Par_Moneda := IFNULL(Par_Moneda,Entero_Cero);
		IF(Par_Moneda!=0)THEN
			SET Var_Sentencia = CONCAT(Var_sentencia,' AND SAL.MonedaID=',CONVERT(Par_Moneda,CHAR));
		END IF;

		SET Var_Sentencia :=    CONCAT(Var_Sentencia, '
		INNER JOIN SUCURSALES Suc ON Suc.SucursalID =  Cre.SucursalID ');
		SET Par_Sucursal := IFNULL(Par_Sucursal,Entero_Cero);
			IF(Par_Sucursal!=0)THEN
				SET Var_Sentencia = CONCAT(Var_sentencia,' AND Cre.SucursalID=',CONVERT(Par_Sucursal,CHAR));
			END IF;
		SET Var_Sentencia :=    CONCAT(Var_Sentencia,'
		WHERE   (SAL.EstatusCredito = "',EstatusVigente,'" OR SAL.EstatusCredito = "',EstatusVencido,'")
		AND SAL.FechaCorte = ?
		ORDER BY SAL.Sucursal, SAL.ProductoCreditoID,CLI.PromotorActual, IFNULL(Gpo.GrupoID, 0), SAL.CreditoID ; ');
		SET @Sentencia  = (Var_Sentencia);
		SET @Fecha  = Par_Fecha;
	  PREPARE STSALDOSCAPITALREP FROM @Sentencia;
	  EXECUTE STSALDOSCAPITALREP USING @Fecha;
	  DEALLOCATE PREPARE STSALDOSCAPITALREP;
	END IF;

	IF(Par_Fecha = FechaSist) THEN
		SET Var_Sentencia :=CONCAT(Var_Sentencia,  'SELECT  CONVERT("',Aud_NumTransaccion,'",UNSIGNED INT),
		IFNULL(Gpo.GrupoID, 0) AS GrupoID, IFNULL(Gpo.NombreGrupo, "") AS NombreGrupo, CRE.CreditoID,          CRE.ClienteID,      CLI.NombreCompleto, ');
		SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' CRE.ProductoCreditoID,  PRO.Descripcion,    CRE.MontoCredito,');
		SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' CRE.FechaInicio,        CRE.FechaVencimien  AS FechaVencimiento,');

		IF(Par_Criterio = CriterioConta) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' CASE WHEN CRE.Estatus = "V" THEN ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, 'CRE.SaldoCapVigent + CRE.SaldoCapAtrasad ELSE ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, '0.00 END AS CapitalVigente,');
		ELSE
			SET Var_Sentencia := CONCAT(Var_Sentencia, 'CRE.SaldoCapVigent + CRE.SaldCapVenNoExi AS CapitalVigente,');
		END IF;

		IF(Par_Criterio = CriterioConta) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' CASE WHEN CRE.Estatus = "V" THEN ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, '(CRE.SaldoInterProvi + CRE.SaldoInterOrdin + CRE.SaldoInterAtras) ELSE ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' 0.00 END AS InteresesVigente,');
		ELSE
			SET Var_Sentencia := CONCAT(Var_Sentencia, '(CRE.SaldoInterProvi + CRE.SaldoInterOrdin + CRE.SaldoIntNoConta) AS InteresesVigente, ');
		END IF;

		IF(Par_Criterio = CriterioConta) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' CASE WHEN CRE.Estatus = "V" THEN ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, '(CRE.SaldoMoratorios + CRE.SaldoMoraVencido + CRE.SaldoMoraCarVen) ELSE 0.00 END AS MoraVigente,');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' CASE WHEN CRE.Estatus = "V" THEN ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, 'CRE.SaldComFaltPago ELSE 0.00 END AS CargosVigente,');
		ELSE
			SET Var_Sentencia :=    CONCAT(Var_Sentencia, '0.0 AS MoraVigente, 0.0 AS CargosVigente,   ');
		END IF;

		IF(Par_Criterio = CriterioConta) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' CASE WHEN CRE.Estatus = "V" THEN ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, 'ROUND( CASE WHEN   PRO.CobraIVAInteres="',SiCobraIVA,'"   OR PRO.CobraIVAInteres IS NULL  THEN');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' (ROUND(CRE.SaldoInterAtras,2)+ ROUND(CRE.SaldoInterProvi,2))');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' *(Suc.IVA)');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ELSE 0.00');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' END ');

			SET Var_Sentencia := CONCAT(Var_Sentencia, ' +');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' CASE WHEN   PRO.CobraIVAMora="',SiCobraIVA,'"  OR PRO.CobraIVAMora IS NULL THEN');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ROUND( (CRE.SaldoMoratorios + CRE.SaldoMoraVencido + CRE.SaldoMoraCarVen) *(Suc.IVA),2)');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ELSE 0.00');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' END');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' +');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ROUND( CRE.SaldComFaltPago *(SELECT IVA FROM SUCURSALES  WHERE  SucursalID = CRE.Sucursal) ,2) ,2)');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ELSE 0.00 END AS IvaVigente, ');
		ELSE

			SET Var_Sentencia := CONCAT(Var_Sentencia, ' CASE WHEN   PRO.CobraIVAInteres="',SiCobraIVA,'"   OR PRO.CobraIVAInteres IS NULL  THEN');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' (ROUND(CRE.SaldoInterProvi,2) + ROUND(CRE.SaldoInterOrdin,2)+ ROUND(CRE.SaldoIntNoConta,2))');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' *(Suc.IVA)');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ELSE 0.00');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' END AS IvaVigente,');
		END IF;

		IF(Par_Criterio = CriterioConta) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' CASE WHEN CRE.Estatus = "V" THEN ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, 'ROUND( CASE WHEN   PRO.CobraIVAInteres="',SiCobraIVA,'"   OR PRO.CobraIVAInteres IS NULL  THEN');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' (ROUND(CRE.SaldoInterAtras,2)+ ROUND(CRE.SaldoInterProvi,2))');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' * (Suc.IVA)');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ELSE 0.00');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' END ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' +');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' CASE WHEN PRO.CobraIVAMora = "',SiCobraIVA,'"  OR PRO.CobraIVAMora IS NULL THEN');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ROUND( (CRE.SaldoMoratorios + CRE.SaldoMoraVencido + CRE.SaldoMoraCarVen) * (Suc.IVA),2)');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ELSE 0.00');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' END');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' +');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ROUND( CRE.SaldComFaltPago *(Suc.IVA) ,2) ,2)');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' + ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' (CRE.SaldoCapVigent + CRE.SaldoCapAtrasad + ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' CRE.SaldoInterProvi + CRE.SaldoInterOrdin + CRE.SaldoInterAtras +');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' CRE.SaldComFaltPago + CRE.SaldoMoratorios + CRE.SaldoMoraVencido + CRE.SaldoMoraCarVen)');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ELSE 0.00 END AS TotalVigente, ');
		ELSE
			SET Var_Sentencia := CONCAT(Var_Sentencia, '(CRE.SaldoCapVigent + CRE.SaldCapVenNoExi + ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' CASE WHEN   PRO.CobraIVAInteres="',SiCobraIVA,'"   OR PRO.CobraIVAInteres IS NULL  THEN');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' (ROUND(CRE.SaldoInterProvi,2) + ROUND(CRE.SaldoInterOrdin,2)+ ROUND(CRE.SaldoIntNoConta,2))');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' *(Suc.IVA)');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ELSE 0.00');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' END +');
			SET Var_Sentencia := CONCAT(Var_Sentencia, 'CRE.SaldoInterProvi + CRE.SaldoInterOrdin+ CRE.SaldoIntNoConta) AS TotalVigente, ');
		END IF;

		IF(Par_Criterio = CriterioConta) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' CASE WHEN CRE.Estatus = "V" THEN ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' 0.00 ELSE ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, '(CRE.SaldoCapVencido  + CRE.SaldCapVenNoExi) END AS CapitalVencido,');
		ELSE
			SET Var_Sentencia := CONCAT(Var_Sentencia, '(CRE.SaldoCapAtrasad + CRE.SaldoCapVencido) AS CapitalVencido, ');
		END IF;

		IF(Par_Criterio = CriterioConta) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' CASE WHEN CRE.Estatus = "B" THEN ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ( CRE.SaldoInterVenc)  ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ELSE 0.00 END AS InteresesVencido,');
		ELSE
			SET Var_Sentencia := CONCAT(Var_Sentencia, '(CRE.SaldoInterAtras + CRE.SaldoInterVenc) AS InteresesVencido, ');
		END IF;

		IF(Par_Criterio = CriterioConta) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' CASE WHEN CRE.Estatus = "V" THEN ');
			SET Var_Sentencia := CONCAT(Var_Sentencia,  '0.00 ELSE (CRE.SaldoMoratorios + CRE.SaldoMoraVencido + CRE.SaldoMoraCarVen) END AS MoraVencido,');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' CASE WHEN CRE.Estatus = "V" THEN ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' 0.00 ELSE CRE.SaldComFaltPago END AS CargosVencido,');
		ELSE
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' (CRE.SaldoMoratorios + CRE.SaldoMoraVencido + CRE.SaldoMoraCarVen)AS MoraVencido , ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' CRE.SaldComFaltPago AS CargosVencido, ');
		END IF;

		IF(Par_Criterio = CriterioConta) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' CASE WHEN CRE.Estatus = "V" THEN 0.00 ELSE ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, 'ROUND( CASE WHEN   PRO.CobraIVAInteres="',SiCobraIVA,'"   OR PRO.CobraIVAInteres IS NULL  THEN');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' (ROUND(CRE.SaldoInterVenc,2))');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' *(Suc.IVA)');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ELSE 0.00');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' END ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' +');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' CASE WHEN   PRO.CobraIVAMora="',SiCobraIVA,'"  OR PRO.CobraIVAMora IS NULL THEN');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ROUND( (CRE.SaldoMoratorios + CRE.SaldoMoraVencido + CRE.SaldoMoraCarVen) *(Suc.IVA),2)');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ELSE 0.00');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' END');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' +');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ROUND( CRE.SaldComFaltPago *(Suc.IVA) ,2) ,2)');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' END AS IvaVencido, ');
		ELSE
			SET Var_Sentencia := CONCAT(Var_Sentencia, 'ROUND( CASE WHEN   PRO.CobraIVAInteres="',SiCobraIVA,'"   OR PRO.CobraIVAInteres IS NULL  THEN');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' (ROUND(CRE.SaldoInterAtras,2)+ ROUND(CRE.SaldoInterVenc,2))');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' *(Suc.IVA)');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ELSE 0.00');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' END ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' +');

			SET Var_Sentencia := CONCAT(Var_Sentencia, ' CASE WHEN   PRO.CobraIVAMora="',SiCobraIVA,'"  OR PRO.CobraIVAMora IS NULL THEN');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ROUND( ( CRE.SaldoMoratorios + CRE.SaldoMoraVencido + CRE.SaldoMoraCarVen)* (Suc.IVA),2)');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ELSE 0.00');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' END');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' +');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ROUND( CRE.SaldComFaltPago *(Suc.IVA) ,2) ,2)');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' AS IvaVencido, ');
		 END IF;

		IF(Par_Criterio = CriterioConta) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' CASE WHEN CRE.Estatus = "V" THEN 0.00 ELSE ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, 'ROUND( CASE WHEN   PRO.CobraIVAInteres="',SiCobraIVA,'"   OR PRO.CobraIVAInteres IS NULL  THEN');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' (ROUND(CRE.SaldoInterVenc,2))');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' *(Suc.IVA)');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ELSE 0.00');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' END ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' +');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' CASE WHEN   PRO.CobraIVAMora="',SiCobraIVA,'"  OR PRO.CobraIVAMora IS NULL THEN');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ROUND( ( CRE.SaldoMoratorios + CRE.SaldoMoraVencido + CRE.SaldoMoraCarVen) * (Suc.IVA),2)');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ELSE 0.00');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' END');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' +');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ROUND( CRE.SaldComFaltPago *(Suc.IVA) ,2) ,2) + ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, '(CRE.SaldoCapVencido + CRE.SaldCapVenNoExi) + ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, '(CRE.SaldoIntNoConta + CRE.SaldoInterVenc) + ');
			SET Var_Sentencia := CONCAT(Var_Sentencia,  ' CRE.SaldoMoratorios + CRE.SaldoMoraVencido + CRE.SaldoMoraCarVen + ');
			SET Var_Sentencia := CONCAT(Var_Sentencia,  ' CRE.SaldComFaltPago ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' END AS TotalVencido, ');
		ELSE
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' (CRE.SaldoCapAtrasad + CRE.SaldoCapVencido + ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, '  CRE.SaldoInterAtras + CRE.SaldoInterVenc + CRE.SaldoMoratorios + CRE.SaldoMoraVencido + CRE.SaldoMoraCarVen + CRE.SaldComFaltPago+');
			SET Var_Sentencia := CONCAT(Var_Sentencia, 'ROUND( CASE WHEN   PRO.CobraIVAInteres="',SiCobraIVA,'"   OR PRO.CobraIVAInteres IS NULL  THEN');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' (ROUND(CRE.SaldoInterAtras,2)+ ROUND(CRE.SaldoInterVenc,2))');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' *(Suc.IVA)');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ELSE 0.00');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' END ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' +');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' CASE WHEN   PRO.CobraIVAMora="',SiCobraIVA,'"  OR PRO.CobraIVAMora IS NULL THEN');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ROUND( (CRE.SaldoMoratorios + CRE.SaldoMoraVencido + CRE.SaldoMoraCarVen) *(Suc.IVA),2)');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ELSE 0.00');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' END');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' +');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ROUND( CRE.SaldComFaltPago *(Suc.IVA) ,2) ,2)');
			SET Var_Sentencia := CONCAT(Var_Sentencia, '  +0.0 ) AS TotalVencido,');
		END IF;

			SET Var_Sentencia := CONCAT(Var_Sentencia, 'IFNULL(DATEDIFF("',Par_Fecha,'",(SELECT MIN(FechaExigible)');
			SET Var_Sentencia := CONCAT(Var_Sentencia, 'FROM AMORTICREDITO ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, 'WHERE CreditoID     = CRE.CreditoID ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, 'AND FechaExigible <="', Par_Fecha,'"');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND Estatus !="', EstatusPagado,'")),0)AS DiasAtraso,');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' CRE.SucursalID, Suc.NombreSucurs,CLI.PromotorActual,PROM.NombrePromotor,');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' Par.FechaSistema AS FechaEmision, TIME(NOW()) AS HoraEmision,  ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' CRE.Estatus AS EstatusCre ,  IFNULL(Dif.DiasDiferidos,0) AS DiasAtrasoCredDif ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' FROM CREDITOS CRE');
			SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN PRODUCTOSCREDITO PRO ON CRE.ProductoCreditoID = PRO.ProducCreditoID');
			SET Var_Sentencia := CONCAT(Var_Sentencia,' LEFT JOIN CREDITOSDIFERIDOS Dif ON CRE.CreditoID = Dif.CreditoID');

			SET Par_ProductoCre := IFNULL(Par_ProductoCre,Entero_Cero);
		IF(Par_ProductoCre!=0)THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND CRE.ProductoCreditoID =',CONVERT(Par_ProductoCre,CHAR));
		END IF;
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' INNER JOIN  PARAMETROSSIS Par ON Par.EmpresaID=Par.EmpresaID ');
			SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN CLIENTES CLI ON CRE.ClienteID = CLI.ClienteID');
			SET Par_Genero := IFNULL(Par_Genero,Cadena_Vacia);
		IF(Par_Genero!=Cadena_Vacia)THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND CLI.Sexo="',Par_Genero,'"');
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND CLI.TipoPersona="',Var_PerFisica,'"');
	   END IF;

			SET Par_Estado := IFNULL(Par_Estado,Entero_Cero);
			IF(Par_Estado!=0)THEN
			   SET Var_Sentencia := CONCAT(Var_sentencia,'
			   LEFT JOIN DIRECCLIENTE Dir ON CLI.ClienteID=Dir.ClienteID AND Dir.Oficial="',SiCobraIVA,'"  AND Dir.EstadoID= ',CONVERT(Par_Estado,CHAR));
			END IF;

			SET Par_Municipio := IFNULL(Par_Municipio,Entero_Cero);
			IF(Par_Municipio!=0)THEN
			   SET Var_Sentencia := CONCAT(Var_sentencia,'
			   LEFT JOIN DIRECCLIENTE Dir ON CLI.ClienteID=Dir.ClienteID AND Dir.Oficial="',SiCobraIVA,'"  AND Dir.MunicipioID= ',CONVERT(Par_Municipio,CHAR));
			   END IF;

			SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN PROMOTORES PROM ON PROM.PromotorID=CLI.PromotorActual ');

			SET Par_Promotor := IFNULL(Par_Promotor,Entero_Cero);
			IF(Par_Promotor!=0)THEN
				SET Var_Sentencia := CONCAT(Var_sentencia,'   AND PROM.PromotorID=',CONVERT(Par_Promotor,CHAR));
			END IF;

			SET Par_Moneda := IFNULL(Par_Moneda,Entero_Cero);
			IF(Par_Moneda!=0)THEN
				SET Var_Sentencia = CONCAT(Var_sentencia,' AND CRE.MonedaID=',CONVERT(Par_Moneda,CHAR));
			END IF;

			SET Var_Sentencia := CONCAT(Var_Sentencia, ' LEFT JOIN GRUPOSCREDITO Gpo ON Gpo.GrupoID = CRE.GrupoID ');
			SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN SUCURSALES Suc ON Suc.SucursalID =  CRE.SucursalID ');
			SET Par_Sucursal := IFNULL(Par_Sucursal,Entero_Cero);
			IF(Par_Sucursal!=0)THEN
				SET Var_Sentencia = CONCAT(Var_sentencia,' AND CRE.SucursalID=',CONVERT(Par_Sucursal,CHAR));
			END IF;

			SET Var_Sentencia :=    CONCAT(Var_Sentencia,' AND  (CRE.Estatus    = "',EstatusVigente,'" OR CRE.Estatus = "',EstatusVencido,'") ');

		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' ORDER BY CRE.SucursalID,CRE.ProductoCreditoID,CLI.PromotorActual, IFNULL(Gpo.GrupoID, 0), CRE.CreditoID ; ');
		  SET @Sentencia    = (Var_Sentencia);
		  PREPARE STSALDOSCAPITALREP FROM @Sentencia;
		  EXECUTE STSALDOSCAPITALREP;
		  DEALLOCATE PREPARE STSALDOSCAPITALREP;

	END IF;

	SELECT
		GrupoID,            NombreGrupo,        CreditoID,          ClienteID,      NombreCompleto,
		ProductoCreditoID,  Descripcion,        MontoCredito,       FechaInicio,    FechaVencimiento,
		CapitalVigente,     InteresesVigente,   MoraVigente,        CargosVigente,  IvaVigente,
		TotalVigente,       CapitalVencido,     InteresesVencido,   MoraVencido,    CargosVencido,
		IvaVencido,         TotalVencido,       DiasAtraso,         SucursalID,     NombreSucurs,
		PromotorActual,     NombrePromotor,     FechaEmision,       HoraEmision,    EstatusCre,
        DiasAtrasoCredDif
		FROM tmp_TMPSALDOSCAPITALDIFERIDOREP
		WHERE Transaccion = Aud_NumTransaccion
		AND DiasAtraso >= Par_AtrasoInicial
		AND DiasAtraso <=Par_AtrasoFinal
        AND (CapitalVigente +  InteresesVigente +  MoraVigente +  CargosVigente +  IvaVigente +
			TotalVigente +  CapitalVencido +  InteresesVencido +  MoraVencido +  CargosVencido +
			IvaVencido +  TotalVencido) > Entero_Cero;

	DROP TABLE IF EXISTS tmp_TMPSALDOSCAPITALDIFERIDOREP;
END TerminaStore$$
