-- CONSTANCIARETCREADIREC
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONSTANCIARETCREADIREC`;
DELIMITER $$

CREATE PROCEDURE `CONSTANCIARETCREADIREC`(
-- --------------------------------------------------------------------------------- --
-- --- SP QUE CREA EL LISTADO DE LAS CARPETAS PARA LAS CONSTANCIAS DE RETENCION  --- --
-- --------------------------------------------------------------------------------- --
    Par_EmpresaID       	INT(11),		-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),		-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,		-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),		-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)TerminaStore:BEGIN

	-- Carpeta principal
	(SELECT DISTINCT CONVERT(CONCAT('mkdir -p -m a=rwx ', RutaExpPDF, AnioProceso), CHAR)    AS cmd
	 FROM CONSTANCIARETCTE,CONSTANCIARETPARAMS WHERE AnioProceso = Anio)
	 UNION
	 -- Ruta para el Alojamiento de la Constancia de Retencion
	(SELECT DISTINCT CONVERT(CONCAT('mkdir -p -m a=rwx ', RutaExpPDF, AnioProceso,'/',RIGHT(CONCAT('000',CAST(SucursalID AS CHAR)) , 3)), CHAR)    AS cmd
	 FROM CONSTANCIARETCTE,CONSTANCIARETPARAMS WHERE AnioProceso = Anio)
	 UNION
	 -- Ruta Alojamiento Codigo Binario
	(SELECT DISTINCT CONVERT(CONCAT('mkdir -p -m a=rwx ', RutaCBB,AnioProceso,'/',RIGHT(CONCAT('000',CAST(SucursalID AS CHAR)) , 3)), CHAR)    AS cmd
	 FROM CONSTANCIARETCTE,CONSTANCIARETPARAMS WHERE AnioProceso = Anio)
	UNION
	 -- Ruta Alojamiento CFDI (.xml)
	(SELECT DISTINCT CONVERT(CONCAT('mkdir -p -m a=rwx ', RutaCFDI,AnioProceso,'/',RIGHT(CONCAT('000',CAST(SucursalID AS CHAR)) , 3)), CHAR)    AS cmd
	 FROM CONSTANCIARETCTE,CONSTANCIARETPARAMS WHERE AnioProceso = Anio);

END TerminaStore$$