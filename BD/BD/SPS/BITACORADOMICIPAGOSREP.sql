DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORADOMICIPAGOSREP`;

DELIMITER $$

CREATE PROCEDURE `BITACORADOMICIPAGOSREP`(
-- SP para genera el reporte de la bitacora de los pagos
-- de domiciliacion.
Par_FolioID				BIGINT(20),		-- Folio con el que se guardo el layaut
Par_FechaInicial		DATE,			-- Fecha  inicialen el que se realiza el filtro
Par_FechaFinal			DATE,			-- Fecha final de generacion del reporte
Par_ClienteID			INT(11),		-- Cliente si es el filtro de un cliente

Par_InstitNominaID		INT(11),		-- Institucionde nomia
Par_Frecuencia			CHAR(1),		-- Frecuencia de los pagos
Par_TipoReporte			INT(11), 		-- Tipo de reporte si es Excel o PDF
Par_EmpresaID			INT(11),		-- Parametro de Auditoria

Aud_Usuario				INT(11),		-- Parametro de Auditoria
Aud_FechaActual			DATETIME,		-- Parametro de Auditoria
Aud_DireccionIP			VARCHAR(15),	-- Parametro de Auditoria
Aud_ProgramaID			VARCHAR(50), 	-- Parametro de Auditoria
Aud_Sucursal			INT(11),		-- Parametro de Auditoria

Aud_NumTransaccion		BIGINT(20)		-- Parametro de Auditoria
)
TerminaStore:BEGIN
	-- Declaracion de varialbes
		DECLARE Var_Sentencia	VARCHAR(2000);
	-- Declaracion de constantes
		DECLARE Entero_Cero		INT(11);
        DECLARE Cadena_Vacia	CHAR(1);
        DECLARE Con_Excel		INT(11);
        DECLARE Con_Pdf			INT(11);
    -- Seteo de valores
		SET Entero_Cero		:= 0;
        SET Cadena_Vacia	:= '';
        SET Con_Excel		:= 1;
        SET Con_Pdf			:= 2;

        IF Par_TipoReporte = Con_Excel THEN 
			SET Var_Sentencia := 'SELECT BTC.FolioID,DATE(BTC.Fecha) AS Fecha,TIME(BTC.Fecha) AS Hora, Referencia,CLI.ClienteID,';
            SET Var_Sentencia := CONCAT(Var_Sentencia, ' CLI.NombreCompleto, BTC.CreditoID,UPPER(NOM.NombreInstit) AS NombreInstit,BTC.ConvenioNominaID,UPPER(INS.NombreCorto) AS NombreCorto,');
            SET Var_Sentencia := CONCAT(Var_Sentencia, ' BTC.CuentaClabe, BTC.MontoAplicado, BTC.MontoNoAplicado, CuotasPendientes, MontoPendiente,');
            SET Var_Sentencia := CONCAT(Var_Sentencia, ' BTC.ClaveDomicilia, CASE BTC.Frecuencia WHEN "S" THEN "SEMANAL"
						WHEN "D" THEN "DECENAL"
						WHEN "C" THEN "CATORCENAL"
						WHEN "Q" THEN "QUINCENAL"
						WHEN "M" THEN "MENSUAL"
						WHEN "B" THEN "BIMESTRAL"
						WHEN "T" THEN "TRIMESTRAL"
						WHEN "R" THEN "TETRAMESTRAL"
						WHEN "E" THEN "SEMESTRAL"
						WHEN "A" THEN "ANUAL"
						WHEN "P" THEN "PERIODO"
						WHEN "U" THEN "PAGO UNICO"
						WHEN "L" THEN "LIBRE"
						END AS Frecuencia,CRE.FechaVencimien,  CRE.MontoDesemb, CRE.NumAmortizacion,');
            SET Var_Sentencia := CONCAT(Var_Sentencia, ' CRE.MontoCuota, CASE BTC.Reprocesado WHEN "S" THEN "SI" ELSE "NO" END AS Reprocesado, BTC.NumTransaccion');
            SET Var_Sentencia := CONCAT(Var_Sentencia, ' FROM BITACORADOMICIPAGOS BTC');
            SET Var_Sentencia := CONCAT(Var_Sentencia, ' INNER JOIN CLIENTES CLI ON BTC.ClienteID = CLI.ClienteID');
            SET Var_Sentencia := CONCAT(Var_Sentencia, ' INNER JOIN INSTITNOMINA NOM ON BTC.InstitNominaID = NOM.InstitNominaID');
            SET Var_Sentencia := CONCAT(Var_Sentencia, ' INNER JOIN INSTITUCIONES INS ON BTC.InstitucionID = INS.InstitucionID');
            SET Var_Sentencia := CONCAT(Var_Sentencia, ' INNER JOIN CREDITOS CRE ON BTC.CreditoID = CRE.CreditoID');
            SET Var_Sentencia := CONCAT(Var_Sentencia, ' WHERE BTC.FolioID =',Par_FolioID,' AND DATE(BTC.Fecha) >="',Par_fechaInicial,'" AND DATE(BTC.Fecha) <= "',Par_FechaFinal,'"');

            IF Par_ClienteID != Entero_Cero THEN
				SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND BTC.ClienteID=',Par_ClienteID);
            END IF;

            IF Par_InstitNominaID != Entero_Cero THEN
				SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND BTC.InstitNominaID = ',Par_InstitNominaID);
            END IF;

            IF IFNULL(Par_Frecuencia,Cadena_Vacia) != Cadena_Vacia THEN
				SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND BTC.Frecuencia = "',Par_Frecuencia,'"');
            END IF;

            SET Var_Sentencia := CONCAT(Var_Sentencia,';');

            SET @Sentencia  = (Var_Sentencia);
			PREPARE Ejecuta FROM @Sentencia;
			EXECUTE Ejecuta;
			DEALLOCATE PREPARE Ejecuta;

		END IF;


END TerminaStore$$