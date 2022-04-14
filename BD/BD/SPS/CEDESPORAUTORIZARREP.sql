-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CEDESPORAUTORIZARREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CEDESPORAUTORIZARREP`;DELIMITER $$

CREATE PROCEDURE `CEDESPORAUTORIZARREP`(
# ============================================================
# ---------- SP PARA REPORTE DE CEDES POR AUTORIZAR ----------
# ============================================================
    Par_TipoCedeID			INT(11),	-- ID DE TIPOSCEDES
    Par_PromotorID			INT(11),	-- ID DE PROMOTORES
    Par_SucursalID			INT(11),	-- ID DE SUCURSALES
    Par_ClienteID			INT(11),	-- ID DE CLIENTES

    Aud_EmpresaID		    INT(11),
	Aud_Usuario        	    INT(11),
	Aud_FechaActual    	    DATE,
	Aud_DireccionIP    	    VARCHAR(15),
	Aud_ProgramaID     	    VARCHAR(50),
	Aud_Sucursal       	    INT(11),
	Aud_NumTransaccion      BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_Sentencia       VARCHAR(10000);

	-- Declaracion de constantes
	DECLARE Entero_Cero         INT(3);
	DECLARE Cadena_Vacia        VARCHAR(20);
	DECLARE Fecha_Vacia			DATE;
	DECLARE EstatusRegistrada   CHAR(1);

	-- Asignacion de constantes
	SET	Entero_Cero		        := 0;
	SET Cadena_Vacia            := '';
	SET Fecha_Vacia				:= '1900-01-01';
	SET EstatusRegistrada       := 'A';

	-- Se crea sentencia para reporte
	SET Var_Sentencia := CONCAT('SELECT C.CedeID, LPAD(C.ClienteID,10,\'0\') AS ClienteID, CL.NombreCompleto, C.TasaFija AS Tasa, C.TasaISR,');
	SET Var_Sentencia := CONCAT(Var_Sentencia, ' C.TasaNeta, C.Monto, C.Plazo, C.FechaVencimiento, C.InteresGenerado,');
	SET Var_Sentencia := CONCAT(Var_Sentencia, ' C.InteresRetener, C.InteresRecibir, \'REGISTRADA\' AS Estatus');
	SET Var_Sentencia := CONCAT(Var_Sentencia, ' FROM CEDES C');
	SET Var_Sentencia := CONCAT(Var_Sentencia, ' INNER JOIN CLIENTES AS CL ON C.ClienteID = CL.ClienteID');

	IF(IFNULL(Par_PromotorID,Entero_Cero)!=Entero_Cero)THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia, ' INNER JOIN PROMOTORES AS PO ON CL.PromotorActual = PO.PromotorID');
	END IF;

	SET Var_Sentencia := CONCAT(Var_Sentencia, ' WHERE C.Estatus = \'',EstatusRegistrada,'\'');

	IF(IFNULL(Par_TipoCedeID,Entero_Cero)!=Entero_Cero)THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND C.TipoCedeID=',IFNULL(Par_TipoCedeID,Entero_Cero));
	END IF;

	IF(IFNULL(Par_PromotorID,Entero_Cero)!=Entero_Cero)THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND CL.PromotorActual=',IFNULL(Par_PromotorID,Entero_Cero));
	END IF;

	IF(IFNULL(Par_SucursalID,Entero_Cero)!=Entero_Cero)THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND C.Sucursal=',IFNULL(Par_SucursalID,Entero_Cero));
	END IF;

	IF(IFNULL(Par_ClienteID,Entero_Cero)!=Entero_Cero)THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND C.ClienteID=',IFNULL(Par_ClienteID,Entero_Cero));
	END IF;

	SET Var_Sentencia := CONCAT(Var_Sentencia, ';');

	SET @Sentencia := (Var_Sentencia);

	PREPARE CEDESAUTORIZADASREP FROM @Sentencia;
	EXECUTE CEDESAUTORIZADASREP;
	DEALLOCATE PREPARE CEDESAUTORIZADASREP;

END TerminaStore$$