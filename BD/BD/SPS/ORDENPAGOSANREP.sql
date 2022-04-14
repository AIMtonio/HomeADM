DELIMITER ;
DROP PROCEDURE IF EXISTS `ORDENPAGOSANREP`;

DELIMITER $$
CREATE PROCEDURE `ORDENPAGOSANREP`(
	-- SP PARA EL REPORTE DE DISPERSION POR ORDENES DE PAGO
	Par_FechaInicio			DATE,					-- Fecha de inicio del reporte
	Par_FechaFin			DATE,					-- Fecha de fin del reporte
	Par_SolicitudCreID		INT,					-- Solicitud de credito con forma de pago orden de pago
	Par_Estatus				CHAR(1),				-- Estaus de la orden de pago
	Par_SucursalID			INT(11),				-- Numero de la sucursal
	Par_NumReporte          TINYINT UNSIGNED,		-- Numero del reporte que se genera 1 .- Excel

	Aud_EmpresaID			INT(11),				-- Parametros de auditoria
    Aud_Usuario				INT(11),				-- Parametros de auditoria
    Aud_FechaActual			DATETIME,				-- Parametros de auditoria
    Aud_DireccionIP			VARCHAR(15),			-- Parametros de auditoria
    Aud_ProgramaID			VARCHAR(50),			-- Parametros de auditoria
    Aud_Sucursal			INT(11),				-- Parametros de auditoria
    Aud_NumTransaccion		BIGINT(20)				-- Parametros de auditoria
)
TerminaStore:BEGIN
	-- Declaracion de vairbles
	DECLARE Var_Sentencia	VARCHAR(1500);
	-- Declaracion de constantes
	DECLARE Con_RepExcel	TINYINT UNSIGNED;

	DECLARE Entero_Cero		TINYINT UNSIGNED;
	DECLARE Cadena_Vacia	CHAR(1);
	DECLARE Fecha_Vacia		DATE;
	DECLARE OrdenPago 		CHAR(1);

	-- Seteo de valores
	SET Con_RepExcel		:= 1;

	SET Entero_Cero			:= 0;
	SET Cadena_Vacia		:= '';
	SET Fecha_Vacia			:= '1900-01-01';
	SET OrdenPago 			:= 'O';

	IF Par_NumReporte = Con_RepExcel THEN
		DROP TABLE IF EXISTS TMPORDENPAGOSANREP;
		SET Var_Sentencia := CONCAT("CREATE TEMPORARY TABLE TMPORDENPAGOSANREP (SELECT
		DATE(D.FechaOperacion) AS 'Fecha',	D.FolioOperacion, 	C.SolicitudCreditoID,	C.CreditoID,		
        CASE SUBSTRING(R.Referencia, 1,2) WHEN 71 THEN SUBSTRING(R.Referencia, 1,13) ELSE R.Referencia END AS Referencia,
		M.NombreBenefi,		M.Monto,		M.NomArchivoGenerado AS NombreArchivo,	DATE(M.FechaGenArch) AS FechaGenerado,
		CASE  	WHEN R.Estatus = 'G' THEN 'GENERADA'
				WHEN R.Estatus = 'E' THEN 'ENVIADA'
				WHEN R.Estatus = 'V' THEN 'VENCIDA'
				WHEN R.Estatus = 'M' THEN 'MODIFICADA'
				WHEN R.Estatus = 'C' THEN 'CANCELADA'
				WHEN R.Estatus = 'O' THEN 'EJECUTADA'
				WHEN R.Estatus = 'P' THEN 'EN PROCESO'
				WHEN R.Estatus = 'R' THEN 'PROGRAMADA'
				END Estatus,
		DATE(M.FechaLiquidacion),	R.FechaVencimiento,	'1900-01-01' FechaRechazo,M.ClaveDispMov
		FROM DISPERSION D
		INNER JOIN DISPERSIONMOV M ON D.FolioOperacion = M.DispersionID AND M.FormaPago = 5
		LEFT JOIN CREDITOS C ON M.CreditoID = C.CreditoID
		LEFT JOIN SOLICITUDCREDITO S ON C.SolicitudCreditoID = S.SolicitudCreditoID 
		INNER JOIN REFORDENPAGOSAN R ON D.FolioOperacion = R.FolioOperacion AND M.ClaveDispMov = R.ClaveDispMov
		WHERE D.FechaOperacion BETWEEN '",Par_FechaInicio,"' AND '",Par_FechaFin,"' ");

		IF IFNULL(Par_SolicitudCreID,Entero_Cero) != Entero_Cero THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia," AND S.SolicitudCreditoID = ",CONVERT(Par_SolicitudCreID,CHAR));
		END IF;

		IF IFNULL(Par_Estatus,Cadena_Vacia) != Cadena_Vacia THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia," AND R.Estatus = '",CONVERT(Par_Estatus,CHAR),"' ");
		END IF;

		IF IFNULL(Par_SucursalID,Entero_Cero) != Entero_Cero THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia," AND D.Sucursal = ",CONVERT(Par_SucursalID,CHAR));
		END IF;
		SET Var_Sentencia := CONCAT(Var_Sentencia," );");

	END IF;



	SET @Sentencia	= (Var_Sentencia);

   PREPARE STDISPERSIONREP FROM @Sentencia;
   EXECUTE STDISPERSIONREP;
   DEALLOCATE PREPARE STDISPERSIONREP;

   UPDATE TMPORDENPAGOSANREP T
   INNER JOIN BITREFORDENPAGOSAN B
   ON T.FolioOperacion = B.FolioOperacion AND T.ClaveDispMov = B.ClaveDispMov
   SET
   T.FechaRechazo = B.FechaCambio
   WHERE B.Estatus = 'C';

   SELECT * FROM TMPORDENPAGOSANREP;

END TerminaStore$$