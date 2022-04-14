-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- VENCIMIENTOSREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `VENCIMIENTOSREP`;

DELIMITER $$


CREATE PROCEDURE `VENCIMIENTOSREP`(
	-- Store Procedure que genera el reporte de Vencimientos en cartera
	-- Modulo Cartera
	Par_FechaInicio			DATE,			-- Parametro Fecha Inicial
	Par_FechaFin			DATE,			-- Parametro Fecha Final
	Par_Sucursal			INT(11),		-- Parametro Sucursal ID
	Par_Moneda				INT(11),		-- Parametro Moneda ID
	Par_ProductoCre			INT(11),		-- Parametro Producto Credito ID

	Par_Promotor			INT(11),		-- Parametro Promotor ID
	Par_Genero				CHAR(1),		-- Parametro Genero
	Par_Estado				INT(11),		-- Parametro Estado ID
	Par_Municipio			INT(11),		-- Parametro Municipio ID
	Par_AtrasoInicial		INT(11),		-- Parametro Dias de Atraso Inicial
	Par_AtrasoFinal			INT(11),		-- Parametro Dias de Atraso Final
	Par_InstNominaID     	INT(11),                -- ID de la empresa de Nomina
	Par_ConvenioID          BIGINT UNSIGNED,        -- Numero de Convenio

	Par_EmpresaID			INT(11),		-- Parametro de Auditoria Empresa ID
	Aud_Usuario				INT(11),		-- Parametro de Auditoria Usuario ID
	Aud_FechaActual			DATETIME,		-- Parametro de Auditoria Fecha Actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de Auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de Auditoria Programa ID
	Aud_Sucursal			INT(11),		-- Parametro de Auditoria Sucursal ID
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de Auditoria Numero de Transaccion
)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE	pagoExigible	DECIMAL(12,2);
DECLARE	TotalCartera	DECIMAL(12,2);
DECLARE	TotalCapVigent	DECIMAL(12,2);
DECLARE	TotalCapVencido	DECIMAL(12,2);
DECLARE	nombreUsuario	VARCHAR(50);
DECLARE Var_Sentencia 			VARCHAR(6000);	-- Sentencia de ejecucion
DECLARE Var_RestringeReporte	CHAR(1);		-- Restringe reporte
DECLARE Var_UsuDependencia		VARCHAR(1000);	-- Usuario de Dependencia

-- Declaracion de Constantes
DECLARE	Cadena_Vacia	CHAR(1);		-- Constante Cadena Vacia
DECLARE	Fecha_Vacia		DATE;			-- Constante Fecha Vacia
DECLARE	Entero_Cero		INT(11);		-- Constante Entero Cerp
DECLARE	Lis_SaldosRep	INT;
DECLARE	Con_Foranea		INT;
DECLARE	Con_PagareTfija	INT;
DECLARE	Con_Saldos		INT;
DECLARE Con_PagareImp 	INT;
DECLARE	Con_PagoCred	INT;
DECLARE	EstatusVigente	CHAR(1);		-- Estatus Vigente
DECLARE	EstatusAtras	CHAR(1);
DECLARE	EstatusPagado	CHAR(1);		-- Estatus Pagado
DECLARE	EstatusVencido	CHAR(1);		-- Estatus Vencido
DECLARE EstatusSuspendido CHAR(1);		-- Estatus suspendido del credito

DECLARE	CienPorciento	DECIMAL(10,2);
DECLARE	FechaSist		DATE;			-- Fecha de Sistema
DECLARE Var_PerFisica 	CHAR(1);		-- Constante Persona Fisica
DECLARE SiCobraIVA		CHAR(1);		-- Constante Si Cobra IVA
DECLARE Var_CliEsp		INT(11);		-- Numero de Cliente Especifico
DECLARE Var_CliTR		INT(11);		-- Cliente Terna de Tres Reyes
DECLARE Var_CliAyE		INT(11);		-- Cliente Accion y Evolucion IALDANA T_14108
DECLARE EsProductoNomina	CHAR(1);
DECLARE Decimal_Cero	DECIMAL(12,2);	-- Constante Decimal Cero
DECLARE Hora_Vacia		TIME;			-- Constante de ]Hora Vacia

-- Asignacion de Constantes
SET	Cadena_Vacia	:= '';
SET	Fecha_Vacia		:= '1900-01-01';
SET	Entero_Cero		:= 0;
SET	Lis_SaldosRep	:= 4;
SET	EstatusVigente	:= 'V';
SET	EstatusAtras	:= 'A';
SET	EstatusPagado	:= 'P';
SET	CienPorciento	:= 100.00;
SET	EstatusVencido	:= 'B';
SET Var_PerFisica := 'F';
SET	SiCobraIVA 		:= 'S';
SET Var_CliEsp		:= (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro='CliProcEspecifico');
SET Var_CliTR 		:= 26;
SET Var_CliAyE		:= 9; -- IALDANA T_14108
SET Hora_Vacia		:= '00:00:00';
SET EstatusSuspendido := 'S';		-- Estatus suspendido del credito

SET EsProductoNomina	:= IFNULL(EsProductoNomina,'N');
SET Par_InstNominaID	:= IFNULL(Par_InstNominaID,0);
SET Par_ConvenioID		:= IFNULL(Par_ConvenioID,0);

CALL TRANSACCIONESPRO (Aud_NumTransaccion);

SELECT	FechaSistema, RestringeReporte
	 INTO FechaSist, Var_RestringeReporte
FROM PARAMETROSSIS LIMIT 1;

SET Var_RestringeReporte:= IFNULL(Var_RestringeReporte,'N');

SET Var_Sentencia :=  '
		INSERT INTO TMPVENCIMCREREP (
			Transaccion,
			GrupoID,
			NombreGrupo,
			CreditoID,
			CicloGrupo,
			ClienteID,
			NombreCompleto,
			MontoCredito,
			FechaInicio,
			FechaVencimien,
			FechaVencim,
			EstatusCredito,
			Capital,
			Interes,
			Moratorios,
			Comisiones,
			Cargos,
			AmortizacionID,
			IVATotal,
			CobraIVAMora,
			CobraIVAInteres,
			SucursalID,
			NombreSucurs,
			ProductoCreditoID,
			Descripcion,
			PromotorActual,
			NombrePromotor,
			TotalCuota,
			Pago,
			FechaPago,
			DiasAtraso,
			SaldoTotal,
			InstitNominaID,
			ConvenioNominaID,
			FechaEmision,
			HoraEmision)
	';
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' SELECT  "',Aud_NumTransaccion,'",IFNULL(Gpo.GrupoID,0), IFNULL(Gpo.NombreGrupo,""),Cre.CreditoID,IFNULL(Cre.CicloGrupo, 0),Cre.ClienteID,Cli.NombreCompleto,Cre.MontoCredito,Cre.FechaInicio,');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' Cre.FechaVencimien, Amc.FechaVencim,');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' CASE 	WHEN Cre.Estatus="I" THEN "INACTIVO" ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, '			WHEN Cre.Estatus="A" THEN "AUTORIZADO" ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' 		WHEN Cre.Estatus="V" THEN "VIGENTE"  ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' 		WHEN Cre.Estatus="P" THEN "PAGADO" ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' 		WHEN Cre.Estatus="C" THEN "CANCELADO" ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' 		WHEN Cre.Estatus="B" THEN "VENCIDO" ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' 		WHEN Cre.Estatus="K" THEN "CASTIGADO" ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' 		WHEN Cre.Estatus="S" THEN "SUSPENDIDO" ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' 		END AS EstatusCredito,');

		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' (Amc.SaldoCapVigente + Amc.SaldoCapAtrasa + Amc.SaldoCapVencido + Amc.SaldoCapVenNExi) AS Capital,');
        SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' (ROUND(Amc.SaldoInteresOrd,2) + ROUND(Amc.SaldoInteresAtr,2)  + ROUND(Amc.SaldoInteresVen,2) ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' + ROUND(Amc.SaldoInteresPro,2)  + ROUND(Amc.SaldoIntNoConta,2) ) AS Interes,');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' (Amc.SaldoMoratorios + Amc.SaldoMoraVencido + Amc.SaldoMoraCarVen)  AS Moratorios,');
        SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' (Amc.SaldoComFaltaPa + Amc.SaldoComServGar + Amc.SaldoOtrasComis) AS Comisiones,');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' 0.00 AS  Cargos,Amc.AmortizacionID,');

		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' ROUND( (');


		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' CASE WHEN  Cli.PagaIVA="',SiCobraIVA,'"   OR Cli.PagaIVA IS NULL THEN');-- IVA  COMISIONES
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' ROUND( (Amc.SaldoComFaltaPa + Amc.SaldoComServGar + Amc.SaldoOtrasComis)');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' * (SELECT IVA FROM SUCURSALES  WHERE  SucursalID = Cre.SucursalID),2)');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' ELSE 0.00');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' END'); --  IvaComisiones+

		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' +');-- mas

		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' 0.00'); --  IVA CARGOS+

		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' +');-- mas

		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' CASE WHEN   Pro.CobraIVAInteres="',SiCobraIVA,'"   OR Pro.CobraIVAInteres IS NULL  THEN');-- IVA INTERES
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' (ROUND(Amc.SaldoInteresOrd,2) + ROUND(Amc.SaldoInteresAtr,2)  + ROUND(Amc.SaldoInteresVen,2)');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' + ROUND(Amc.SaldoInteresPro,2)  + ROUND(Amc.SaldoIntNoConta,2) ) ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' * (SELECT IVA FROM SUCURSALES  WHERE  SucursalID = Cre.SucursalID)');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' ELSE 0.00');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' END'); -- AS IvaInteres

		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' +');-- mas

		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' CASE WHEN   Pro.CobraIVAMora="',SiCobraIVA,'"  OR Pro.CobraIVAMora IS NULL THEN');-- IVA MORATORIO
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' ROUND((Amc.SaldoMoratorios + Amc.SaldoMoraVencido + Amc.SaldoMoraCarVen) * (SELECT IVA FROM SUCURSALES  WHERE  SucursalID = Cre.SucursalID),2)');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' ELSE 0.00');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' END'); --  IvaMoratorio = IVATotal

		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' ) , 2 ) AS IVATotal,Pro.CobraIVAMora,Pro.CobraIVAInteres,');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' Cre.SucursalID, Suc.NombreSucurs,Cre.ProductoCreditoID, Pro.Descripcion, Cli.PromotorActual,PROM.NombrePromotor,');



		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' (Amc.SaldoCapVigente + Amc.SaldoCapAtrasa + Amc.SaldoCapVencido + Amc.SaldoCapVenNExi +');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' ROUND(Amc.SaldoInteresOrd,2) + ROUND(Amc.SaldoInteresAtr,2)  + ROUND(Amc.SaldoInteresVen,2)  ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' + ROUND(Amc.SaldoInteresPro,2)  + ROUND(Amc.SaldoIntNoConta,2) +');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' (Amc.SaldoMoratorios + Amc.SaldoMoraVencido + Amc.SaldoMoraCarVen)+ Amc.SaldoComFaltaPa +  Amc.SaldoComServGar + Amc.SaldoOtrasComis + 0.00 +  ');

		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' ROUND( (');


		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' CASE WHEN  Cli.PagaIVA="',SiCobraIVA,'"   OR Cli.PagaIVA IS NULL THEN');-- IVA  COMISIONES
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' ROUND( (Amc.SaldoComFaltaPa +  Amc.SaldoComServGar + Amc.SaldoOtrasComis)');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' * (SELECT IVA FROM SUCURSALES  WHERE  SucursalID = Cre.SucursalID),2)');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' ELSE 0.00');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' END'); --  IvaComisiones+

		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' +');-- mas

		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' 0.00'); --  IVA CARGOS+

		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' +');-- mas

		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' CASE WHEN   Pro.CobraIVAInteres="',SiCobraIVA,'"   OR Pro.CobraIVAInteres IS NULL  THEN');-- IVA INTERES
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' (ROUND(Amc.SaldoInteresOrd,2) + ROUND(Amc.SaldoInteresAtr,2)  + ROUND(Amc.SaldoInteresVen,2)');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' + ROUND(Amc.SaldoInteresPro,2)  + ROUND(Amc.SaldoIntNoConta,2) ) ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' * (SELECT IVA FROM SUCURSALES  WHERE  SucursalID = Cre.SucursalID)');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' ELSE 0.00');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' END'); -- AS IvaInteres

		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' +');-- mas

		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' CASE WHEN   Pro.CobraIVAMora="',SiCobraIVA,'"  OR Pro.CobraIVAMora IS NULL THEN');-- IVA MORATORIO
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' ROUND((Amc.SaldoMoratorios + Amc.SaldoMoraVencido + Amc.SaldoMoraCarVen)  * (SELECT IVA FROM SUCURSALES  WHERE  SucursalID = Cre.SucursalID),2)');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' ELSE 0.00');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' END'); --  IvaMoratorio = IVATotal

		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' ) , 2 )  ) AS TotalCuota,');


		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' (SELECT SUM(DET.MontoTotPago) FROM DETALLEPAGCRE DET WHERE');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' DET.AmortizacionID=Amc.AmortizacionID AND Amc.CreditoID=DET.CreditoID');
        SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' GROUP BY DET.AmortizacionID,DET.CreditoID) AS Pago, ');



		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' (SELECT MAX(FechaPago) FROM DETALLEPAGCRE DET WHERE');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' DET.AmortizacionID=Amc.AmortizacionID AND Amc.CreditoID=DET.CreditoID');
        SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' GROUP BY DET.AmortizacionID,DET.CreditoID) AS FechaPago ,');


		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' (SELECT  DATEDIFF( Par.FechaSistema, IFNULL(MIN(Amo.FechaExigible), Par.FechaSistema)) FROM AMORTICREDITO Amo WHERE Amo.CreditoID = Amc.CreditoID  ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, '   AND Amo.Estatus IN ("V", "A", "B") ) AS DiasAtraso, ');

		SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' (Cre.SaldoCapVigent + Cre.SaldCapVenNoExi + ');
		SET Var_Sentencia :=  CONCAT(Var_Sentencia, '  ROUND(Cre.SaldoInterProvi,2) + ROUND(Cre.SaldoInterOrdin,2)+ ROUND(Cre.SaldoIntNoConta,2) + ');-- ) AS TotalVigente +
		SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' Cre.SaldoCapAtrasad + Cre.SaldoCapVencido  + Cre.SaldCapVenNoExi +');
		SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' ROUND(Cre.SaldoInterAtras,2)+ Cre.SaldoCapVencido + (Cre.SaldoMoratorios + Cre.SaldoMoraVencido + Cre.SaldoMoraCarVen) +');
		SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' Cre.SaldComFaltPago + 0.0)');--  AS TotalVencido,
		SET Var_Sentencia :=  CONCAT(Var_Sentencia, '  AS SaldoTotal,');
		SET Var_Sentencia :=	CONCAT(Var_Sentencia,' IF(INST.InstitNominaID IS NULL,0,INST.InstitNominaID) AS InstitNominaID, IFNULL(Nomc.ConvenioNominaID,0) AS ConvenioNominaID,');
		SET Var_Sentencia :=	CONCAT(Var_Sentencia, ' Par.FechaSistema AS FechaEmision, TIME(NOW()) AS HoraEmision');

		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' FROM CREDITOS Cre ');

		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' INNER JOIN  PARAMETROSSIS Par ON Par.EmpresaID=Par.EmpresaID ');
		SET Var_Sentencia :=	CONCAT(Var_Sentencia,' LEFT OUTER JOIN NOMCONDICIONCRED Nomc ON Cre.ProductoCreditoID= Nomc.ProducCreditoID AND Cre.ConvenioNominaID=Nomc.ConvenioNominaID
														 LEFT JOIN INSTITNOMINA AS INST ON Nomc.InstitNominaID = INST.InstitNominaID');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' INNER JOIN AMORTICREDITO Amc ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' ON Amc.CreditoID = Cre.CreditoID');



		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID ');
				SET Par_ProductoCre := IFNULL(Par_ProductoCre,Entero_Cero);
                IF(Par_ProductoCre!=0)THEN
                    SET Var_Sentencia :=  CONCAT(Var_sentencia,' AND Pro.ProducCreditoID =',CONVERT(Par_ProductoCre,CHAR));
                END IF;

		SET Var_Sentencia := 	CONCAT(Var_Sentencia,'  INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID');

		SET Par_Genero := IFNULL(Par_Genero,Cadena_Vacia);
                IF(Par_Genero!=Cadena_Vacia)THEN
                    SET Var_Sentencia := CONCAT(Var_sentencia,' AND Cli.Sexo="',Par_Genero,'"');
                    SET Var_Sentencia := CONCAT(Var_sentencia,' AND Cli.TipoPersona="',Var_PerFisica,'"');
		END IF;


		SET Par_Estado := IFNULL(Par_Estado,Entero_Cero);
                IF(Par_Estado!=0)THEN
                    SET Var_Sentencia := CONCAT(Var_sentencia,' AND (SELECT Dir.EstadoID FROM DIRECCLIENTE Dir WHERE Dir.Oficial= "S" AND Cli.ClienteID=Dir.ClienteID)=',CONVERT(Par_Estado,CHAR));
                END IF;

		SET Par_Municipio := IFNULL(Par_Municipio,Entero_Cero);
                IF(Par_Municipio!=0)THEN
                    SET Var_Sentencia := CONCAT(Var_sentencia,' AND (SELECT Dir.MunicipioID FROM DIRECCLIENTE Dir WHERE Dir.Oficial="S" AND Cli.ClienteID=Dir.ClienteID)=',CONVERT(Par_Municipio,CHAR));
                END IF;

		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' INNER JOIN PROMOTORES PROM ON PROM.PromotorID=Cli.PromotorActual ');

		SET Par_Promotor := IFNULL(Par_Promotor,Entero_Cero);
                IF(Par_Promotor!=0)THEN
                    SET Var_Sentencia := CONCAT(Var_sentencia,'   AND PROM.PromotorID=',CONVERT(Par_Promotor,CHAR));
                END IF;

		SET Par_Moneda := IFNULL(Par_Moneda,Entero_Cero);
                IF(Par_Moneda!=0)THEN
                    SET Var_Sentencia = CONCAT(Var_sentencia,' AND Cre.MonedaID=',CONVERT(Par_Moneda,CHAR));
                END IF;

		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' INNER JOIN SUCURSALES Suc ON Suc.SucursalID = Cre.SucursalID ');

		SET Par_Sucursal := IFNULL(Par_Sucursal,Entero_Cero);
                IF(Par_Sucursal!=0)THEN
                    SET Var_Sentencia = CONCAT(Var_sentencia,' AND Cre.SucursalID=',CONVERT(Par_Sucursal,CHAR));
                END IF;
		SET Var_Sentencia = CONCAT(Var_sentencia,' LEFT JOIN GRUPOSCREDITO Gpo ON Gpo.GrupoID = Cre.GrupoID ');
		-- IALDANA T_14108 Se agrega al cliente Accion y evolucion a la condicion de estatus.
		SET Var_Sentencia :=  CONCAT(Var_Sentencia,' WHERE if("',Var_CliEsp,'" IN("',Var_CliTR,'","',Var_CliAyE,'"),(Cre.Estatus	= "',EstatusVigente,'" OR Cre.Estatus = "',EstatusVencido,'"),(Cre.Estatus	= "',EstatusVigente,'" OR Cre.Estatus = "',EstatusVencido,'" OR Cre.Estatus = "',EstatusPagado,'" OR Cre.Estatus = "',EstatusSuspendido,'")) ');
        SET Var_Sentencia :=  CONCAT(Var_Sentencia,' AND Amc.FechaExigible	>= ? AND Amc.FechaExigible <= ? ');

		IF (Var_CliEsp = Var_CliTR) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND Amc.Estatus<> "P" ');
		END IF;

		IF(Par_ProductoCre!=0)THEN
			SELECT ProductoNomina INTO EsProductoNomina FROM PRODUCTOSCREDITO WHERE ProducCreditoID=Par_ProductoCre LIMIT 1;
			IF(EsProductoNomina='S')THEN
				SET Par_InstNominaID	:= IFNULL(Par_InstNominaID,Entero_Cero);
				SET	Par_ConvenioID		:= IFNULL(Par_ConvenioID,Entero_Cero);

				IF(Par_InstNominaID=Entero_Cero AND Par_ConvenioID!=Entero_Cero) THEN
					SET Var_Sentencia	:=	CONCAT(Var_Sentencia,' AND Nomc.ConvenioNominaID=',CONVERT(Par_ConvenioID,CHAR));
				END IF;
				IF(Par_InstNominaID!=Entero_Cero AND Par_ConvenioID=Entero_Cero) THEN
					SET Var_Sentencia	:=	CONCAT(Var_Sentencia, ' AND Nomc.InstitNominaID=', CONVERT(Par_InstNominaID,CHAR));
				END IF;
				IF(Par_InstNominaID!=Entero_Cero AND Par_ConvenioID!=Entero_Cero) THEN
					SET Var_Sentencia	:=	CONCAT(Var_Sentencia, ' AND Nomc.InstitNominaID=', CONVERT(Par_InstNominaID,CHAR),
											' AND Nomc.ConvenioNominaID=',CONVERT(Par_ConvenioID,CHAR));
				END IF;
			END IF;
		END IF;

		SET Var_Sentencia :=  CONCAT(Var_Sentencia,' ORDER BY Cre.SucursalID, Cre.ProductoCreditoID, Cli.PromotorActual,Cre.CreditoID,Amc.FechaVencim;');




	SET @Sentencia	= (Var_Sentencia);
	SET @FechaInicio	= Par_FechaInicio;
	SET @FechaFin		= Par_FechaFin;

   PREPARE STSALDOSCAPITALREP FROM @Sentencia;
      EXECUTE STSALDOSCAPITALREP USING @FechaInicio, @FechaFin;
      DEALLOCATE PREPARE STSALDOSCAPITALREP;

-- paliativo
UPDATE TMPVENCIMCREREP
	SET DiasAtraso=Entero_Cero
		WHERE  DiasAtraso < Entero_Cero;
        /*--->*/
      UPDATE
        TMPVENCIMCREREP AS TM
        INNER JOIN
        CLIENTES AS CL
        ON
        TM.ClienteID=CL.ClienteID
		SET TM.TotalCuota=ROUND((TM.TotalCuota-TM.IVATotal),2),
        TM.IVATotal=0
        WHERE
        CL.PagaIVA="N";


	-- CUANDO EL PARAMETRO RESTRINGE CARTERA ES NO, MOSTRARA LA INFORMACION COMPLETA
	IF(Var_RestringeReporte = 'N')THEN
		SELECT
			IFNULL(Transaccion, Entero_Cero) AS Transaccion,
			IFNULL(GrupoID, Entero_Cero) AS GrupoID,
			IFNULL(NombreGrupo, Cadena_Vacia) AS NombreGrupo,
			IFNULL(CreditoID,Entero_Cero) AS CreditoID,
			IFNULL(CicloGrupo, Entero_Cero) AS CicloGrupo ,
			IFNULL(ClienteID, Entero_Cero) AS ClienteID,
			IFNULL(NombreCompleto, Cadena_Vacia) AS NombreCompleto,
			IFNULL(MontoCredito, Decimal_Cero) AS MontoCredito,
			IFNULL(FechaInicio, Fecha_Vacia) AS FechaInicio,
			IFNULL(FechaVencimien, Fecha_Vacia) AS FechaVencimien,
			IFNULL(FechaVencim, Fecha_Vacia) AS FechaVencim,
			IFNULL(EstatusCredito, Cadena_Vacia) AS EstatusCredito,
			IFNULL(Capital, Decimal_Cero) AS Capital,
			IFNULL(Interes, Decimal_Cero) AS Interes,
			IFNULL(Moratorios, Decimal_Cero) AS Moratorios,
			IFNULL(Comisiones, Decimal_Cero) AS Comisiones,
			IFNULL(Cargos, Decimal_Cero) AS Cargos,
			IFNULL(AmortizacionID, Entero_Cero) AS AmortizacionID,
			IFNULL(IVATotal, Decimal_Cero)	AS IVATotal,
			IFNULL(CobraIVAMora, Cadena_Vacia) AS CobraIVAMora,
			IFNULL(CobraIVAInteres, Cadena_Vacia) AS CobraIVAInteres,
			IFNULL(SucursalID, Entero_Cero) AS SucursalID,
			IFNULL(NombreSucurs, Cadena_Vacia) AS NombreSucurs,
			IFNULL(ProductoCreditoID, Entero_Cero) AS ProductoCreditoID,
			IFNULL(Descripcion, Cadena_Vacia) AS Descripcion,
			IFNULL(PromotorActual, Entero_Cero) AS PromotorActual,
			IFNULL(NombrePromotor, Cadena_Vacia) AS NombrePromotor,
			IFNULL(TotalCuota, Decimal_Cero) AS TotalCuota,
			IFNULL(Pago, Decimal_Cero) AS Pago,
			IFNULL(FechaPago, Cadena_Vacia) AS FechaPago,
			IFNULL(DiasAtraso, Entero_Cero) AS DiasAtraso,
			IFNULL(SaldoTotal, Entero_Cero) AS SaldoTotal,
			InstitNominaID,
			ConvenioNominaID,
			IFNULL(FechaEmision, Fecha_Vacia) AS FechaEmision,
			IFNULL(HoraEmision, Hora_Vacia) AS HoraEmision
		FROM TMPVENCIMCREREP
		WHERE Transaccion = Aud_NumTransaccion
		  AND DiasAtraso >= Par_AtrasoInicial
		  AND DiasAtraso <= Par_AtrasoFinal
		ORDER BY SucursalID, ProductoCreditoID, PromotorActual, CreditoID, FechaVencim;
	END IF;

	-- CUANDO EL PARAMETRO RESTRINGE CARTERA ES SI, MOSTRARA LA INFORMACION POR USUARIO DE ACUERDO AL CRONOGRAMA
	IF(Var_RestringeReporte = 'S')THEN

		-- OBTENEMOS LOS USUARIOS QUE SON DEPENDENCIAS
		SET Var_UsuDependencia := (SELECT FNUSUARIOSDEPENDECIA(Aud_Usuario));

		SET Var_Sentencia := CONCAT('
		SELECT
			IFNULL(TMP.Transaccion, 0) AS Transaccion,
			IFNULL(TMP.GrupoID, 0) AS GrupoID,
			IFNULL(TMP.NombreGrupo, "") AS NombreGrupo,
			IFNULL(TMP.CreditoID, 0) AS CreditoID,
			IFNULL(TMP.CicloGrupo, 0) AS CicloGrupo,
			IFNULL(TMP.ClienteID, 0) AS ClienteID,
			IFNULL(TMP.NombreCompleto, "") AS NombreCompleto,
			IFNULL(TMP.MontoCredito, 0.00) AS MontoCredito,
			IFNULL(TMP.FechaInicio, "1900-01-00") AS FechaInicio,
			IFNULL(TMP.FechaVencimien, "1900-01-00") AS FechaVencimien,
			IFNULL(TMP.FechaVencim, "1900-01-00") AS FechaVencim,
			IFNULL(TMP.EstatusCredito, "") AS EstatusCredito,
			IFNULL(TMP.Capital, 0.00) AS Capital,
			IFNULL(TMP.Interes, 0.00) AS Interes,
			IFNULL(TMP.Moratorios, 0.00) AS Moratorios,
			IFNULL(TMP.Comisiones, 0.00) AS Comisiones,
			IFNULL(TMP.Cargos, 0.00) AS Cargos,
			IFNULL(TMP.AmortizacionID, 0) AS AmortizacionID,
			IFNULL(TMP.IVATotal, 0.00) AS IVATotal,
			IFNULL(TMP.CobraIVAMora, "") AS CobraIVAMora,
			IFNULL(TMP.CobraIVAInteres, "") AS CobraIVAInteres,
			IFNULL(TMP.SucursalID, 0) AS SucursalID,
			IFNULL(TMP.NombreSucurs, "") AS NombreSucurs,
			IFNULL(TMP.ProductoCreditoID, 0) AS ProductoCreditoID,
			IFNULL(TMP.Descripcion, "") AS Descripcion,
			IFNULL(TMP.PromotorActual, 0) AS PromotorActual,
			IFNULL(TMP.NombrePromotor, "") AS NombrePromotor,
			IFNULL(TMP.TotalCuota, 0.00) AS TotalCuota,
			IFNULL(TMP.Pago, 0.00) AS Pago,
			IFNULL(TMP.FechaPago, "") AS FechaPago,
			IFNULL(TMP.DiasAtraso, 0) AS DiasAtraso,
			IFNULL(TMP.SaldoTotal, 0.00) AS SaldoTotal,
			TMP.InstitNominaID,
			TMP.ConvenioNominaID,
			IFNULL(TMP.FechaEmision, "1900-01-01") AS FechaEmision,
			IFNULL(TMP.HoraEmision, "00:00:00") AS HoraEmision
		FROM TMPVENCIMCREREP TMP
		INNER JOIN SOLICITUDCREDITO SOL ON TMP.CreditoID = SOL.CreditoID
		WHERE Transaccion = 	',Aud_NumTransaccion,'
		  AND TMP.DiasAtraso >=	',Par_AtrasoInicial,'
		  AND TMP.DiasAtraso <=	',Par_AtrasoFinal,'
		  AND SOL.UsuarioAltaSol IN(',Var_UsuDependencia,')
		ORDER BY TMP.SucursalID, TMP.ProductoCreditoID, TMP.PromotorActual, TMP.CreditoID, TMP.FechaVencim;
        ');

		SET @Sentencia2	= (Var_Sentencia);

		PREPARE STSALDOSCAPITALREP2 FROM @Sentencia2;
		EXECUTE STSALDOSCAPITALREP2;
		DEALLOCATE PREPARE STSALDOSCAPITALREP2;

    END IF;

	DELETE FROM TMPVENCIMCREREP WHERE Transaccion = Aud_NumTransaccion;


END TerminaStore$$
