-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORACARGAFACTREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORACARGAFACTREP`;
DELIMITER $$


CREATE PROCEDURE `BITACORACARGAFACTREP`(
	# =====================================================================================
	# SP PARA GENERAR EL REPORTE DE LOS PROVEEDORES EXISTENTES O NO EXISTENTES
	# =====================================================================================
    Par_FolioCargaID       		INT(11),				-- FOLIO DE CARGA
    Par_NumCon					TINYINT UNSIGNED,		-- NUMERO DE CONSULTA

    Aud_EmpresaID      		 	INT(11),				-- AUDITORIA
    Aud_Usuario         		INT(11),				-- AUDITORIA
    Aud_FechaActual     		DATETIME,				-- AUDITORIA
    Aud_DireccionIP     		VARCHAR(15),			-- AUDITORIA
    Aud_ProgramaID      		VARCHAR(50),			-- AUDITORIA
    Aud_Sucursal        		INT(11),				-- AUDITORIA
    Aud_NumTransaccion  		BIGINT(20)				-- AUDITORIA
		)

TerminaStore: BEGIN

	DECLARE Var_Sentencia 			VARCHAR(15000);

	DECLARE	Cadena_Vacia			CHAR(1);
	DECLARE	Fecha_Vacia				DATE;
	DECLARE	Entero_Cero				INT;
	DECLARE Con_RepProvExiste		TINYINT UNSIGNED;
	DECLARE Con_RepProvNoExiste		TINYINT UNSIGNED;



	SET	Cadena_Vacia				:= '';
	SET	Fecha_Vacia					:= '1900-01-01';
	SET	Entero_Cero					:= 0;
	SET Con_RepProvExiste			:= 1;
	SET Con_RepProvNoExiste			:= 2;

	SET Var_Sentencia := CONCAT("SELECT  MIN(BI.FolioCargaID) AS FolioCargaID, 		MIN(BI.FechaCarga) AS FechaCarga, 					 	MIN(BI.MesSubirFact) AS MesSubirFact, 		 				MIN(BI.Anio) AS Anio,
									MIN(BI.Mes) AS Mes, 							MIN(BI.Dia) AS Dia, 									MIN(BI.UUID) AS UUID,  										MIN(BI.Folio) AS NumFactura,
									BI.RfcEmisor,
									IFNULL(CASE MIN(PROV.TipoPersona) WHEN 'F' THEN TRIM(CONCAT(MIN(PROV.PrimerNombre),' ',MIN(PROV.SegundoNombre),' ',MIN(PROV.ApellidoPaterno), ' ',MIN(PROV.ApellidoMaterno)))
									ELSE MIN(RazonSocial) END, MIN(BI.NombreEmisor)) AS NombreCompleto,
									MIN(IFNULL(PROV.ProveedorID, 0)) AS SafiID,
                                    CASE MIN(IFNULL(PROV.ProveedorID, 0)) WHEN 0 THEN MIN(BI.DescripcionError) ELSE '' END AS DescripcionError
						FROM BITACORACARGAFACT BI
						LEFT JOIN PROVEEDORES PROV ON PROV.RFC =  BI.RfcEmisor OR PROV.RFCpm=BI.RfcEmisor
						WHERE BI.FolioCargaID = '",Par_FolioCargaID,"'	
                        AND IFNULL(BI.RfcEmisor,'')!=''
						GROUP BY BI.RfcEmisor");

	SET @Sentencia	= (Var_Sentencia);
	PREPARE BITACORACARGAFACTREP FROM @Sentencia;
	EXECUTE BITACORACARGAFACTREP;
	DEALLOCATE PREPARE BITACORACARGAFACTREP;

END TerminaStore$$