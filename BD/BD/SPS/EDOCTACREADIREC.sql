-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTACREADIREC
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTACREADIREC`;
DELIMITER $$


CREATE PROCEDURE `EDOCTACREADIREC`(

	Par_Prefijo     VARCHAR(50)     -- Parametro de Prefijo de la Compania necesario para generar rutas individuales por cliente

)
BEGIN

(Select distinct convert(CONCAT('mkdir -p -m a=rwx ', RutaExpPDF, Par_Prefijo, '/', MesProceso,'/',RIGHT(CONCAT('000',CAST(SucursalID as char)) , 3)), char)    as cmd
 from EDOCTADATOSCTE,EDOCTAPARAMS where MesProceso=AnioMes)
UNION
(Select distinct convert(CONCAT('mkdir -p -m a=rwx ', RutaExpPDF,'CBB/', Par_Prefijo, '/', MesProceso,'/',RIGHT(CONCAT('000',CAST(SucursalID as char)) , 3)), char)    as cmd
 from EDOCTADATOSCTE,EDOCTAPARAMS where MesProceso=AnioMes)
UNION
(Select distinct convert(CONCAT('mkdir -p -m a=rwx ', RutaExpPDF,'XML/', Par_Prefijo, '/', MesProceso,'/',RIGHT(CONCAT('000',CAST(SucursalID as char)) , 3)), char)    as cmd
 from EDOCTADATOSCTE,EDOCTAPARAMS where MesProceso=AnioMes)
UNION
(Select distinct convert(CONCAT('mkdir -p -m a=rwx ', RutaExpPDF,'TXT/', Par_Prefijo, '/', MesProceso,'/',RIGHT(CONCAT('000',CAST(SucursalID as char)) , 3)), char)    as cmd
 from EDOCTADATOSCTE,EDOCTAPARAMS where MesProceso=AnioMes);


END$$