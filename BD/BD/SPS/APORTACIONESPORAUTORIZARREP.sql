-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTACIONESPORAUTORIZARREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTACIONESPORAUTORIZARREP`;DELIMITER $$

CREATE PROCEDURE `APORTACIONESPORAUTORIZARREP`(
# ===================================================================
# ---------- SP PARA REPORTE DE APORTACIONES POR AUTORIZAR ----------
# ===================================================================
    Par_TipoAportacionID	INT(11),		-- ID del tipo de aportacion
    Par_PromotorID			INT(11),		-- ID del promotor
    Par_SucursalID			INT(11),		-- ID de la sucursal
    Par_ClienteID			INT(11),		-- ID del cliente

    Aud_EmpresaID		    INT(11),		-- Parametro de auditoria
	Aud_Usuario        	    INT(11),		-- Parametro de auditoria
	Aud_FechaActual    	    DATE,			-- Parametro de auditoria
	Aud_DireccionIP    	    VARCHAR(15),	-- Parametro de auditoria
	Aud_ProgramaID     	    VARCHAR(50),	-- Parametro de auditoria
	Aud_Sucursal       	    INT(11),		-- Parametro de auditoria
	Aud_NumTransaccion      BIGINT(20)		-- Parametro de auditoria
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_Sentencia       VARCHAR(10000); -- Almacena la consultas a ejecutar

	-- Declaracion de constantes
	DECLARE Entero_Cero         INT(3);
	DECLARE Cadena_Vacia        VARCHAR(20);
	DECLARE Fecha_Vacia			DATE;
	DECLARE EstatusRegistrada   CHAR(1);

	-- Asignacion de constantes
	SET	Entero_Cero		        := 0;				-- Entero cero
	SET Cadena_Vacia            := '';				-- Cadena vacia
	SET Fecha_Vacia				:= '1900-01-01';	-- Fecha vacia
	SET EstatusRegistrada       := 'A'; 			-- Estatus registrada

	-- Se crea sentencia para reporte
	SET Var_Sentencia := CONCAT('SELECT C.AportacionID, LPAD(C.ClienteID,10,\'0\') AS ClienteID, CL.NombreCompleto, C.TasaFija AS Tasa, C.TasaISR,');
	SET Var_Sentencia := CONCAT(Var_Sentencia, ' C.TasaNeta, C.Monto, C.Plazo, C.FechaVencimiento, C.InteresGenerado,');
	SET Var_Sentencia := CONCAT(Var_Sentencia, ' C.InteresRetener, C.InteresRecibir, \'REGISTRADA\' AS Estatus');
	SET Var_Sentencia := CONCAT(Var_Sentencia, ' FROM APORTACIONES C');
	SET Var_Sentencia := CONCAT(Var_Sentencia, ' INNER JOIN CLIENTES AS CL ON C.ClienteID = CL.ClienteID');

	IF(IFNULL(Par_PromotorID,Entero_Cero)!=Entero_Cero)THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia, ' INNER JOIN PROMOTORES AS PO ON CL.PromotorActual = PO.PromotorID');
	END IF;

	SET Var_Sentencia := CONCAT(Var_Sentencia, ' WHERE C.Estatus = \'',EstatusRegistrada,'\'');

	IF(IFNULL(Par_TipoAportacionID,Entero_Cero)!=Entero_Cero)THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND C.TipoAportacionID=',IFNULL(Par_TipoAportacionID,Entero_Cero));
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

	PREPARE APORTAUTORIZADASREP FROM @Sentencia;
	EXECUTE APORTAUTORIZADASREP;
	DEALLOCATE PREPARE APORTAUTORIZADASREP;

END TerminaStore$$