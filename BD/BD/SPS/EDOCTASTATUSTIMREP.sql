-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
--
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTASTATUSTIMREP`;
DELIMITER $$


CREATE PROCEDURE `EDOCTASTATUSTIMREP`(
	-- Genera el reporte de Timbrados por Periodo
	Par_Periodo			   INT(11),		-- Periodo de Consulta
	Par_ClienteID			INT(11),
    Par_Estatus             CHAR(1),   


	Par_EmpresaID		INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario			INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual		DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP		VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID		VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal		INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion	BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)

TerminaStore: BEGIN

	-- Declaracion de variables
    DECLARE Var_Sentencia 				VARCHAR(4000);
	-- Declaracion de Constantes
	DECLARE Cadena_Vacia 				CHAR(1);		-- Cadena Vacia
	DECLARE Entero_Cero					INT(11);		-- Entero Cero
	DECLARE Entero_Uno					INT(11);		-- Entero Uno
	DECLARE Decimal_Cero				DECIMAL(12,2);	-- Decimal Vacio
    DECLARE Fecha_Vacia					DATE;
   


	-- Asignacion de Constantes
	SET Cadena_Vacia 		:= '';
	SET Entero_Cero 		:= 0;
	SET Entero_Uno			:= 1;
	SET Decimal_Cero 		:= 0.0;
	SET Fecha_Vacia 		:= '1900-01-01';
    SET Var_Sentencia		:= '';

   
    SET Var_Sentencia := CONCAT(Var_Sentencia,'SELECT E.Periodo AS Periodo, E.ClienteID, E.NombreComple AS NombreCliente,
    CASE WHEN E.Estatus=2 THEN "TIMBRADO" ELSE
    "NO TIMBRADO" END AS Estatus FROM EDOCTAHISCDATOSCTE E ');
   
   
    SET Var_Sentencia := CONCAT(Var_Sentencia,'WHERE E.Periodo = "',Par_Periodo,'" ');

	SET Par_ClienteID := IFNULL(Par_ClienteID, Entero_Cero);
    
    IF(Par_ClienteID != Entero_Cero)THEN
        SET Var_Sentencia = CONCAT(Var_sentencia,'AND E.ClienteID =', CONVERT(Par_ClienteID,CHAR));
    END IF;
   
    SET Par_Estatus := IFNULL(Par_Estatus, Cadena_Vacia);
    
	IF(Par_Estatus != Cadena_Vacia)THEN
             SET Var_Sentencia = CONCAT(Var_sentencia,' AND E.PDFGenerado ="',Par_Estatus,'" ' );
    END IF;
  
   
    SET Var_Sentencia := CONCAT(Var_Sentencia,';');

SET @Sentencia	= (Var_Sentencia);

PREPARE ESTATUSTIMBRADOEJEC FROM @Sentencia;
EXECUTE ESTATUSTIMBRADOEJEC;
DEALLOCATE PREPARE ESTATUSTIMBRADOEJEC;


END TerminaStore$$