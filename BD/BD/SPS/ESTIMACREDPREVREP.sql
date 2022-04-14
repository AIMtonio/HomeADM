-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESTIMACREDPREVREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESTIMACREDPREVREP`;
DELIMITER $$

CREATE PROCEDURE `ESTIMACREDPREVREP`(
	/* SP QUE GENERA EL REPORTE DE LA ESTIMACION PREVENTIVA DE RIESGOS CREDITICIOS */

	Par_Fecha			 DATE,		-- Fecha
	Par_ClienteID	 	 INT(11),	-- Numero de Cliente
	Par_GrupoID      	 INT(11), 	-- Numero de Grupo
	Par_Sucursal		 INT(11),	-- Numero de Sucursal
	Par_Moneda		 	 INT(11),	-- Moneda
	Par_ProductoCre	  	 INT(11),	-- Producto de Credito
	Par_Promotor   	 	 INT(11),	-- Promotor
	Par_Genero 		 	 CHAR(1), 	-- Genero
	Par_Estado  		 INT(11),	-- Estado
	Par_Municipio    	 INT(11),	-- Municipio

    /* Parametros de Auditoria */
	Par_EmpresaID		 INT(11),
	Aud_Usuario			 INT(11),
	Aud_FechaActual		 DATETIME,
	Aud_DireccionIP		 VARCHAR(15),
	Aud_ProgramaID		 VARCHAR(50),
	Aud_Sucursal		 INT(11),
	Aud_NumTransaccion	 BIGINT(11)

	)
TerminaStore: BEGIN


DECLARE	pagoExigible		DECIMAL(12,2);
DECLARE	TotalCartera		DECIMAL(12,2);
DECLARE	TotalCapVigent		DECIMAL(12,2);
DECLARE	TotalCapVencido		DECIMAL(12,2);
DECLARE	nombreUsuario		VARCHAR(50);
DECLARE Var_Sentencia 		VARCHAR(20000);
DECLARE Var_TipoContaMora	CHAR(1);



DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Entero_Cero			INT(11);
DECLARE	Lis_SaldosRep		INT(11);
DECLARE	Con_Foranea			INT(11);
DECLARE	Con_PagareTfija		INT(11);
DECLARE	Con_Saldos			INT(11);
DECLARE Con_PagareImp 		INT(11);
DECLARE	Con_PagoCred		INT(11);
DECLARE	EstatusVigente		CHAR(1);
DECLARE	EstatusAtras		CHAR(1);
DECLARE	EstatusPagado		CHAR(1);
DECLARE	EstatusVencido		CHAR(1);
DECLARE	EstatCastigado		CHAR(1);
DECLARE	CienPorciento		DECIMAL(10,2);
DECLARE	FechaSist			DATE;
DECLARE Var_PerFisica 	   	CHAR(1);
DECLARE Decimal_Cero		DECIMAL(12,2);
DECLARE TipoIngresos		CHAR(1);

SET	Cadena_Vacia		    := '';
SET	Fecha_Vacia				:= '1900-01-01';
SET	Entero_Cero				:= 0;
SET	Lis_SaldosRep		 	:= 4;
SET	EstatusVigente			:= 'V';
SET	EstatusAtras		    := 'A';
SET	EstatusPagado			:= 'P';
SET	CienPorciento			:= 100.00;
SET	EstatusVencido			:= 'B';
SET	EstatCastigado			:= 'K';
SET Var_PerFisica 	        :='F';
SET Decimal_Cero			:=0.00;
SET TipoIngresos			:= 'I';

		SELECT FechaSistema, TipoContaMora
        INTO FechaSist,		Var_TipoContaMora
        FROM PARAMETROSSIS;



		SET Var_Sentencia :=  ' SELECT  Cre.CreditoID,Cli.ClienteID,Cli.NombreCompleto,Pro.ProducCreditoID,Pro.Descripcion,Cre.FechaInicio, Cre.FechaVencimien,Cre.Estatus,';
		SET Var_Sentencia :=    CONCAT(Var_Sentencia, ' Cal.Capital,Cal.Interes,Sal.DiasAtraso AS DiasAtraso,Cal.Calificacion,ROUND(Cal.PorcReservaExp,4)*100 AS PorcReserva,
								ROUND(Cal.PorcReservaCub,4)*100 AS PorcReservaCub,Cal.MontoGarantia,Cal.ReservaCapital AS Reserva, Cal.ReservaInteres, ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, '(Cal.Reserva) AS TotalReserva, Suc.SucursalID, Suc.NombreSucurs, Cli.PromotorActual,PROM.NombrePromotor,Gru.GrupoID,');
        SET Var_Sentencia := 	CONCAT(Var_Sentencia, 'Gru.NombreGrupo,Cre.MonedaID,Cli.Sexo,TIME(NOW()) AS HoraEmision,IFNULL(Cal.ReservaTotCubierto,0.0) AS ReservaTotCubierto, IFNULL(Cal.ReservaTotExpuesto,0.0) AS ReservaTotExpuesto, ');
		SET Var_Sentencia :=CONCAT(Var_Sentencia, 'CASE WHEN Sal.EstatusCredito = "C" THEN "CANCELADO" ');
		SET Var_Sentencia :=CONCAT(Var_Sentencia, 'WHEN Sal.EstatusCredito = "I" THEN "INACTIVO" ');
		SET Var_Sentencia :=CONCAT(Var_Sentencia, 'WHEN Sal.EstatusCredito = "A" THEN "AUTORIZADO" ');
		SET Var_Sentencia :=CONCAT(Var_Sentencia, 'WHEN Sal.EstatusCredito = "V" THEN "VIGENTE" ');
		SET Var_Sentencia :=CONCAT(Var_Sentencia, 'WHEN Sal.EstatusCredito = "P" THEN "PAGADO" ');
		SET Var_Sentencia :=CONCAT(Var_Sentencia, 'WHEN Sal.EstatusCredito = "C" THEN "CANCELADO" ');
		SET Var_Sentencia :=CONCAT(Var_Sentencia, 'WHEN Sal.EstatusCredito = "B" THEN "VENCIDO" ');
		SET Var_Sentencia :=CONCAT(Var_Sentencia, 'WHEN Sal.EstatusCredito = "K" THEN "CASTIGADO" ');
		SET Var_Sentencia :=CONCAT(Var_Sentencia, 'WHEN Sal.EstatusCredito = "S" THEN "SUSPENDIDO"  ELSE "" END AS EstatusCredito, ');


		SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' CASE WHEN Sal.EstatusCredito = "B" THEN ( ROUND(Sal.SaldoMoraVencido,2) ');
        SET Var_Sentencia :=  CONCAT(Var_Sentencia, '   + ROUND(Sal.SalIntVencido,2) )');
        SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' ELSE 0 END   AS SaldoInteresVencido, ');
		SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' CASE WHEN Sal.EstatusCredito = "B" THEN ( ROUND(Sal.SaldoMoraVencido,2) ');
		SET Var_Sentencia :=  CONCAT(Var_Sentencia, '   + ROUND(Sal.SalIntProvision,2) ');
        IF(Var_TipoContaMora = TipoIngresos) THEN
			SET Var_Sentencia :=  CONCAT(Var_Sentencia, '   + ROUND(Sal.SalIntVencido,2) )+Sal.SalIntOrdinario+Sal.SalIntAtrasado+Sal.SalMoratorios ');
		ELSE
			SET Var_Sentencia :=  CONCAT(Var_Sentencia, '   + ROUND(Sal.SalIntVencido,2) )+Sal.SalIntOrdinario+Sal.SalIntAtrasado');
        END IF;
        SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' ELSE 0 END   AS  SaldoInteresAnterior ');
		SET Var_Sentencia :=CONCAT(Var_Sentencia, ',CASE WHEN CH.MontoGarHipo > 0.00 THEN "SI" ELSE "NO" END AS EsHipotecado');

		SET Var_Sentencia :=CONCAT(Var_Sentencia, ', CASE Des.Clasificacion WHEN "O" THEN "CONSUMO"
																						WHEN "C" THEN "COMERCIAL" WHEN "H" THEN "VIVIENDA" END AS Clasificacion , upper(Crc.DescripClasifica) as SubClasificacion,  ');
		SET Var_Sentencia :=CONCAT(Var_Sentencia, 'CASE IFNULL(Res.Origen,"") WHEN "" THEN "NUEVO" WHEN "R" THEN "REESTRUCTURADO"
																WHEN "O"  THEN "RENOVADO" END AS TipoCredito');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ',Cal.ZonaMarginada, Cal.MontoBaseEstCub, Cal.MontoBaseEstExp ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' FROM CALRESCREDITOS Cal ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' INNER JOIN CREDITOS Cre ON Cal.CreditoID = Cre.CreditoID');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' LEFT JOIN CREGARPRENHIPO CH ON Cre.CreditoID = CH.CreditoID');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID');

        SET Par_ProductoCre := IFNULL(Par_ProductoCre,Entero_Cero);
		IF(Par_ProductoCre!=0)THEN
			SET Var_Sentencia :=  CONCAT(Var_sentencia,' AND Pro.ProducCreditoID =',CONVERT(Par_ProductoCre,CHAR));
		END IF;
		SET Var_Sentencia := 	CONCAT(Var_Sentencia,'  INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID');

        SET Par_ClienteID := IFNULL(Par_ClienteID,Entero_Cero);
		IF(Par_ClienteID!=Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND Cli.ClienteID="',Par_ClienteID,'"');
		END IF;

		SET Par_Genero := IFNULL(Par_Genero,Cadena_Vacia);
		IF(Par_Genero!=Cadena_Vacia)THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND Cli.Sexo="',Par_Genero,'"');
		END IF;

		SET Par_Estado := IFNULL(Par_Estado,Entero_Cero);
		IF(Par_Estado!=0)THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND (SELECT Dir.EstadoID FROM DIRECCLIENTE Dir WHERE Dir.Oficial="S" AND Cli.ClienteID=Dir.ClienteID)=',CONVERT(Par_Estado,CHAR));
		END IF;

		SET Par_Municipio := IFNULL(Par_Municipio,Entero_Cero);
		IF(Par_Municipio!=0)THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND (SELECT Dir.MunicipioID FROM DIRECCLIENTE Dir WHERE Dir.Oficial="S" AND Cli.ClienteID=Dir.ClienteID)=',CONVERT(Par_Municipio,CHAR));
		END IF;
		SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN SALDOSCREDITOS Sal ON Sal.CreditoID = Cal.CreditoID AND Sal.ClienteID=Cli.ClienteID
															AND Sal.ProductoCreditoID=Pro.ProducCreditoID AND Cal.CreditoID = Cre.CreditoID
															AND Sal.FechaCorte = "', Par_Fecha, '"');
		SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN DESTINOSCREDITO Des ON  Cre.DestinoCreID = Des.DestinoCreID ');
		SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN CLASIFICCREDITO Crc ON  Crc.ClasificacionID = Des.SubClasifID ');

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

		SET Par_GrupoID := IFNULL(Par_GrupoID,Entero_Cero);
		IF(Par_GrupoID!=0)THEN
			SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' INNER JOIN GRUPOSCREDITO Gru ON Gru.GrupoID = Cre.GrupoID');
			SET Var_Sentencia = CONCAT(Var_sentencia,' AND Cre.GrupoID   =',CONVERT(Par_GrupoID,CHAR));
		END IF;
		IF(Par_GrupoID=0)THEN
			SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' LEFT JOIN GRUPOSCREDITO Gru ON Gru.GrupoID = Cre.GrupoID');
		END IF;
		SET Var_Sentencia := CONCAT(Var_Sentencia,' LEFT OUTER JOIN REESTRUCCREDITO Res ON Res.CreditoDestinoID = Cre.CreditoID ');

      	SET Var_Sentencia :=  CONCAT(Var_Sentencia,' WHERE Cal.Fecha = ? ORDER BY  Cre.SucursalID, Cli.PromotorActual,Cre.ProductoCreditoID, Cre.GrupoID, Cre.CreditoID');

	  	SET Var_Sentencia :=  CONCAT(Var_Sentencia,' AND Cal.Fecha > ',CONVERT(FechaSist,CHAR));



	SET @Sentencia	= (Var_Sentencia);
	SET @Fecha	= Par_Fecha;

      PREPARE STESTIMACREDPREVREP FROM @Sentencia;
      EXECUTE STESTIMACREDPREVREP USING @Fecha;
      DEALLOCATE PREPARE STESTIMACREDPREVREP;


END TerminaStore$$