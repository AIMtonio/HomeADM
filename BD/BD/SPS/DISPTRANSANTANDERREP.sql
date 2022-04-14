-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DISPTRANSANTANDERREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `DISPTRANSANTANDERREP`;
DELIMITER $$

CREATE PROCEDURE `DISPTRANSANTANDERREP`(
# =========================================================================
# ----------	SP PARA EL REPORTE DE TRANSFERENCIAS SANTANDER	-----------
# =========================================================================
    Par_FechaInicio				DATE,			-- FECHA DE CANCELACION
    Par_FechaFin				DATE,			-- FECHA DE CANCELACION
    Par_SolicitudID				INT(11),		-- SOLICITUD DE CRDITO
    Par_Estatus					VARCHAR(3),		-- ESTATUS
    Par_SucursalID				INT(11),		-- SUCURSAL
   
	Aud_EmpresaID				INT(11),		-- AUDITORIA
	Aud_Usuario					INT(11),		-- AUDITORIA
	Aud_FechaActual				DATETIME,		-- AUDITORIA
	Aud_DireccionIP				VARCHAR(15),	-- AUDITORIA
	Aud_ProgramaID				VARCHAR(50),	-- AUDITORIA
	Aud_Sucursal				INT(11),		-- AUDITORIA
	Aud_NumTransaccion			BIGINT(20)		-- AUDITORIA
)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
	DECLARE Var_Control				VARCHAR(100);		-- CONTROL
	DECLARE Var_FechaSis			DATE;				-- FECHA DEL SISTEMA
    DECLARE	Var_Sentencia			VARCHAR(15000);		-- SENTENCIA
    DECLARE Var_Consecutivo			INT(11);			-- CONSECUTIVO
    
	-- DECLARACION DE CONSTANTES
	DECLARE Entero_Cero				INT(11);
	DECLARE SalidaSi  				CHAR(1);
	DECLARE SalidaNo  				CHAR(1);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Fecha_Vacia				DATE;
    
    -- ASIGNACION DE CONSTANTES
	SET Entero_Cero					:= 0;
	SET SalidaSi					:= 'S';
	SET SalidaNo					:= 'N';
	SET Cadena_Vacia				:= '';
	SET Fecha_Vacia					:= '1900-01-01';
	
    SET Par_SolicitudID 			:= IFNULL(Par_SolicitudID, Entero_Cero);
    SET Par_Estatus 				:= IFNULL(Par_Estatus, Cadena_Vacia);
    SET Par_SucursalID 				:= IFNULL(Par_SucursalID, Entero_Cero);
    
			
	SET Var_Sentencia := CONCAT('
		SELECT  CASE IFNULL(DATE(DIS.FechaEnvio), "1900-01-01") WHEN "1900-01-01" THEN "" ELSE DATE(DIS.FechaEnvio) END AS FechaDispersion, 
		   IFNULL(DIS.DispersionID, 0) AS FolioDispersion,
		   IFNULL(CRE.SolicitudCreditoID,0) AS Solicitud,
		   IFNULL(CRE.CreditoID, "") AS Credito,
           IFNULL(DIS.Referencia, "") AS Referencia,
		   IFNULL(DIS.NombreBenefi,"") AS NombreCliente,
		   IFNULL(DIS.Monto,0.0) AS Monto,
		   IFNULL(DIS.NomArchivoGenerado, "") AS NomArchivoGenerado,
		   CASE IFNULL(DATE(DIS.FechaGenArch), "1900-01-01") WHEN "1900-01-01" THEN "" ELSE DIS.FechaGenArch END AS FechaArchivo,
		   IFNULL(CAT.Descripcion, "") AS Estatus,
		   CASE IFNULL(DATE(DIS.FechaLiquidacion), "1900-01-01") WHEN "1900-01-01" THEN "" ELSE DIS.FechaLiquidacion END AS FechaPago,
		   CASE IFNULL(DATE(DIS.FechaRechazo), "1900-01-01") WHEN "1900-01-01" THEN "" ELSE DIS.FechaRechazo END AS FechaRechazado
           
	FROM DISPERSIONMOV AS DIS
	LEFT OUTER JOIN CREDITOS CRE ON CRE.CreditoID=DIS.CreditoID
	LEFT OUTER JOIN CATSTATUSDISPERSIONES CAT ON DIS.EstatusResSanta=CAT.CodigoID AND CAT.Banco="S" AND (CAT.TipoOper="T" OR CAT.TipoOper="D")
	WHERE DIS.FormaPago = 6 
    AND DATE(DIS.FechaEnvio) BETWEEN "',Par_FechaInicio,'" AND "',Par_FechaFin,'" ');
	
	IF(Par_SolicitudID!=Entero_Cero)THEN
		SET Var_Sentencia :=CONCAT(Var_Sentencia, ' CRE.SolicitudCreditoID= ',Par_SolicitudID);
	END IF;
	
	IF(Par_Estatus!=Cadena_Vacia)THEN
		SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND DIS.EstatusResSanta= "',Par_Estatus,'"');
	END IF;
	
	IF(Par_SucursalID!=Entero_Cero)THEN
		SET Var_Sentencia :=CONCAT(Var_Sentencia, ' CRE.SucursalID= ',Par_SucursalID);
	END IF;
	
	SET @Sentencia := (Var_Sentencia);
	PREPARE DISPTRANSANTANDERREP FROM @Sentencia;
	EXECUTE DISPTRANSANTANDERREP;
	DEALLOCATE PREPARE DISPTRANSANTANDERREP;
    


END TerminaStore$$