-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
--
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIMBRADOPERIDOSREP`;
DELIMITER $$


CREATE PROCEDURE `TIMBRADOPERIDOSREP`(
	-- Genera el reporte de Timbrados por Periodo
	Par_Periodo			   INT(11),
	Par_ProductoCreditoID  INT(11),		-- Ejercicio de Consulta
	Par_ClienteID			INT(11),	-- Periodo de Consulta


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
	DECLARE Var_RFCEmisor       		VARCHAR(25);
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

    SELECT Ins.RFC INTO Var_RFCEmisor FROM PARAMETROSSIS Par
	INNER JOIN INSTITUCIONES Ins
    ON Par.InstitucionID = Ins.InstitucionID;
   
    SET Var_Sentencia := CONCAT(Var_Sentencia,'SELECT E.Periodo AS Periodo, E.ClienteID, MAX(E.NombreComple) AS NombreCliente, MAX(E.CFDIUUID) AS UUID, "',Var_RFCEmisor,'"  AS RFCEmisor,
    MAX(E.RFC) AS RFCReceptor, MAX(E.CFDITotal) AS CFDITotal, MAX(Pro.Descripcion) AS Producto
    FROM EDOCTAHISCDATOSCTE E');
    
	SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN EDOCTADETCRE Edo ON E.ClienteID = Edo.ClienteID
    AND E.Periodo = Edo.AnioMes ');
     
	SET Var_Sentencia := CONCAT(Var_Sentencia,'INNER JOIN CREDITOS Cre ON Cre.CreditoID = Edo.CreditoID ');
   
	SET Var_Sentencia := CONCAT(Var_Sentencia,'INNER JOIN PRODUCTOSCREDITO Pro ON Pro.ProducCreditoID = Cre.ProductoCreditoID
    WHERE E.Periodo = "',Par_Periodo,'"');
  
	SET Par_ProductoCreditoID := IFNULL(Par_ProductoCreditoID, Entero_Cero);
    
    IF(Par_ProductoCreditoID != Entero_Cero)THEN
        SET Var_Sentencia = CONCAT(Var_sentencia,' AND Pro.ProducCreditoID  =', CONVERT(Par_ProductoCreditoID,CHAR));
    END IF;
  
	SET Par_ClienteID := IFNULL(Par_ClienteID, Entero_Cero);
    
    IF(Par_ClienteID != Entero_Cero)THEN
        SET Var_Sentencia = CONCAT(Var_sentencia,' AND E.ClienteID =', CONVERT(Par_ClienteID,CHAR));
    END IF;
   
    SET Var_Sentencia := CONCAT(Var_Sentencia,'  GROUP BY E.ClienteID;');

SET @Sentencia	= (Var_Sentencia);

PREPARE TIMBRADOSEJEC FROM @Sentencia;
EXECUTE TIMBRADOSEJEC;
DEALLOCATE PREPARE TIMBRADOSEJEC;


END TerminaStore$$