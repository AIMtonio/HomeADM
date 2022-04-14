DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORADOMICIPAGOSCON`;

DELIMITER $$
CREATE PROCEDURE `BITACORADOMICIPAGOSCON`(
/*SP para consultar a la tabla de bitacoras de pagos domiciliados*/
	Par_FolioID			INT(11),			-- Folio del lote de pagos
    Par_Fecha			DATE,				-- Fecha en la que se registro el lote
    Par_ClienteID		INT(11),			-- Cliente que pertenece a un lote
    Par_InstitucionID	INT(11),			-- Institucion bancaria
    Par_InstitNominaID	INT(11),			-- Institucion de nomina
    Par_CreditoID		BIGINT(12),			-- Credito que fue procesado para el lote
    
    Par_NumConsulta		INT(11),			-- Numero de consulta a realizar
    
    Par_EmpresaID		INT(11),			-- Parametro de auditoria
    Aud_Usuario			INT(11),			-- Parametro de auditoria
	Aud_FechaActual		DATETIME,			-- Parametro de auditoria
	Aud_DireccionIP		VARCHAR(15),		-- Parametro de auditoria
	Aud_ProgramaID		VARCHAR(50),		-- Parametro de auditoria
	Aud_Sucursal		INT(11),			-- Parametro de auditoria
	Aud_NumTransaccion	BIGINT(20)			-- Parametro de auditoria
)
TerminaStore:BEGIN
	-- Declaracion de varialbes
    
    -- Declaracion de constantes
	DECLARE Entero_Cero		INT(11);
    DECLARE Cadena_Vacia	CHAR(1);
    
    DECLARE Con_Principal	INT(11);
    
    -- Seteo de valores
    
    SET Entero_Cero 	:= 0;
    SET Cadena_Vacia	:= '';
    SET Con_Principal	:= 1;
    
    IF Par_NumConsulta = Con_Principal THEN
		SELECT FolioID, DATE(Fecha) AS Fecha
		FROM BITACORADOMICIPAGOS
		WHERE FolioID = Par_FolioID LIMIT 1;
    END IF;
END TerminaStore$$