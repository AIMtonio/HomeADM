-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALIFICAPORCENTRESREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CALIFICAPORCENTRESREP`;DELIMITER $$

CREATE PROCEDURE `CALIFICAPORCENTRESREP`(
	/* SP QUE GENERA EL REPORTE DE LA CALIFICACION DE ESTIMACION PREVENTIVA DE RIESGOS CREDITICIOS */

	Par_Fecha			DATE,			-- Fecha del reporte
	Par_ClienteID	 	INT,			-- Numero de cliente
    Par_GrupoID      	INT, 			-- Numero de grupo
    Par_Sucursal		INT, 			-- Numero de Sucursal
	Par_Moneda		 	INT, 			-- Tipo de Moneda
	Par_ProductoCre		INT,			-- Numero de producto de credito
	Par_Promotor   	 	INT, 			-- Numero de promotor
	Par_Genero 		 	CHAR(1), 		-- Genero
	Par_Estado  		INT, 			-- Clave de Estado
	Par_Municipio    	INT, 			-- Clave de Municipio

	Par_EmpresaID		INT,			-- Auditoria
	Aud_Usuario			INT,			-- Auditoria
	Aud_FechaActual		DATETIME,		-- Auditoria
	Aud_DireccionIP		VARCHAR(15),	-- Auditoria
	Aud_ProgramaID		VARCHAR(50),	-- Auditoria
	Aud_Sucursal		INT,			-- Auditoria
	Aud_NumTransaccion	BIGINT			-- Auditoria

	)
TerminaStore: BEGIN


DECLARE	pagoExigible		DECIMAL(12,2);	-- Monto de Pago Exigible
DECLARE	TotalCartera		DECIMAL(12,2);	-- Total de Cartera
DECLARE	TotalCapVigent		DECIMAL(12,2); 	-- Total de Capital vigente
DECLARE	TotalCapVencido		DECIMAL(12,2); 	-- Total de Capital Vencido
DECLARE	nombreUsuario		VARCHAR(50); 	-- Nombre de Usuario
DECLARE Var_Sentencia 		VARCHAR(2000);  -- Sentencia dinamica SQL



DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Entero_Cero			INT;
DECLARE	Lis_SaldosRep		INT;
DECLARE	Con_Foranea			INT;
DECLARE	Con_PagareTfija		INT;
DECLARE	Con_Saldos			INT;
DECLARE Con_PagareImp 		INT;
DECLARE	Con_PagoCred		INT;
DECLARE	EstatusVigente		CHAR(1);
DECLARE	EstatusAtras		CHAR(1);
DECLARE	EstatusPagado		CHAR(1);
DECLARE	EstatusVencido		CHAR(1);
DECLARE	EstatCastigado		CHAR(1);
DECLARE	CienPorciento		DECIMAL(10,2);
DECLARE	FechaSist			DATE;
DECLARE Var_PerFisica 	CHAR(1);

SET	Cadena_Vacia		:= '';
SET	Fecha_Vacia			:= '1900-01-01';
SET	Entero_Cero			:= 0;
SET	Lis_SaldosRep		:= 4;
SET	EstatusVigente		:= 'V';
SET	EstatusAtras		:= 'A';
SET	EstatusPagado		:= 'P';
SET	CienPorciento		:= 100.00;
SET	EstatusVencido		:= 'B';
SET	EstatCastigado		:= 'K';
SET Var_PerFisica 		:='F';


SET FechaSist := (SELECT FechaSistema FROM PARAMETROSSIS);



		SET Var_Sentencia :=  ' SELECT  Cre.CreditoID,Cre.ClienteID,Cli.NombreCompleto,Pro.ProducCreditoID,Pro.Descripcion,Cre.FechaInicio, Cre.FechaVencimien,';
		SET Var_Sentencia :=    CONCAT(Var_Sentencia, ' (Sal.SalCapVigente+Sal.SalCapAtrasado+Sal.SalCapVencido+Sal.SalCapVenNoExi) AS Capital,');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, '(Sal.SalIntAtrasado+Sal.SalIntVencido+Sal.SalIntProvision+Sal.SalIntNoConta) AS Interes, Sal.DiasAtraso,CASE Des.Clasificacion WHEN "C"THEN "COMERCIAL"
                                                     WHEN "H" THEN "VIVIENDA"  WHEN "O"THEN "CONSUMO" END AS Clasifica,Sal.Calificacion,Sal.PorcReserva, Suc.SucursalID, Suc.NombreSucurs, Cli.PromotorActual,PROM.NombrePromotor,Gru.GrupoID,');
       SET Var_Sentencia := 	CONCAT(Var_Sentencia, 'Gru.NombreGrupo,Cre.MonedaID,Cli.Sexo,TIME(NOW()) AS HoraEmision,');
       SET Var_Sentencia := 	CONCAT(Var_Sentencia, 'upper(Crc.DescripClasifica) AS SubClasificacion');
	--
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' FROM SALDOSCREDITOS Sal ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' INNER JOIN CREDITOS Cre ON Sal.CreditoID = Cre.CreditoID');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' INNER JOIN DESTINOSCREDITO Des ON Cre.DestinoCreID = Des.DestinoCreID');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' INNER JOIN CLASIFICCREDITO Crc ON  Crc.ClasificacionID = Des.SubClasifID ');
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

      SET Var_Sentencia :=  CONCAT(Var_Sentencia,' WHERE Sal.FechaCorte = ?   ORDER BY Cre.SucursalID, Cli.PromotorActual,Cre.ProductoCreditoID, Cre.GrupoID, Cre.CreditoID;');

	SET @Sentencia	= (Var_Sentencia);
	SET @Fecha	= Par_Fecha;

      PREPARE STESTIMACREDPREVREP FROM @Sentencia;
      EXECUTE STESTIMACREDPREVREP USING @Fecha;
      DEALLOCATE PREPARE STESTIMACREDPREVREP;

END TerminaStore$$