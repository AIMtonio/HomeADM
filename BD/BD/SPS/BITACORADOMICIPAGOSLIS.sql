DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORADOMICIPAGOSLIS`;

DELIMITER $$
CREATE PROCEDURE `BITACORADOMICIPAGOSLIS`(
	Par_FolioID			INT(11),			-- Folio del lote de pagos
    Par_Fecha			DATE,				-- Fecha en la que se registro el lote
    Par_ClienteID		INT(11),			-- Cliente que pertenece a un lote
    Par_InstitucionID	INT(11),			-- Institucion bancaria
    Par_InstitNominaID	INT(11),			-- Institucion de nomina
    Par_CreditoID		BIGINT(12),			-- Credito que fue procesado para el lote
    Par_Frecuencia		CHAR(1),			-- frecuenca del credito
    
    Par_NumLista		INT(11),			-- Numero de consulta a realizar
    
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
    
    DECLARE Lis_Frecuencua	INT(11);
    
    -- Seteo de valores
    
    SET Entero_Cero 	:= 0;
    SET Cadena_Vacia	:= '';
    SET Lis_Frecuencua	:= 2;
    
    IF Par_NumLista = Lis_Frecuencua THEN
		SELECT DISTINCT Frecuencia,
		CASE Frecuencia WHEN 'S' THEN 'SEMANAL'
						WHEN 'D' THEN 'DECENAL'
						WHEN 'C' THEN 'CATORCENAL'
						WHEN 'Q' THEN 'QUINCENAL'
						WHEN 'M' THEN 'MENSUAL'
						WHEN 'B' THEN 'BIMESTRAL'
						WHEN 'T' THEN 'TRIMESTRAL'
						WHEN 'R' THEN 'TETRAMESTRAL'
						WHEN 'E' THEN 'SEMESTRAL'
						WHEN 'A' THEN 'ANUAL'
						WHEN 'P' THEN 'PERIODO'
						WHEN 'U' THEN 'PAGO UNICO'
						WHEN 'L' THEN 'LIBRE'
						END AS DescFrecuencia
		FROM BITACORADOMICIPAGOS
		WHERE FolioID=Par_FolioID;
	END IF;
    
END TerminaStore$$