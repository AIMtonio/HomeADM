-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTPORINICIARREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTPORINICIARREP`;DELIMITER $$

CREATE PROCEDURE `APORTPORINICIARREP`(
# ===================================================================
# ---------- SP PARA REPORTE DE APORTACIONES POR INICIAR ----------
# ===================================================================
    Par_FechaInicial		DATE,			-- Fecha Inicial
    Par_Fechafinal			DATE,			-- Fecha Final
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
	DECLARE Var_Sentencia       VARCHAR(10000); -- Almacena la consulta a ejecutar

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
	SET Var_Sentencia := CONCAT('SELECT C.AportacionID, PO.NombrePromotor, LPAD(C.ClienteID,10,\'0\') AS ClienteID, CL.NombreCompleto, TRUNCATE(C.TasaFija,2) AS Tasa,');
	SET Var_Sentencia := CONCAT(Var_Sentencia, ' C.Monto, C.Plazo, C.FechaVencimiento, C.InteresRecibir,');
	SET Var_Sentencia := CONCAT(Var_Sentencia, ' C.InteresRetener,IF(C.TipoPagoInt = \'V\',\'VENCIMIENTO\',\'MENSUAL\') AS TipoPagoInt,');
    SET Var_Sentencia := CONCAT(Var_Sentencia, 'CASE WHEN C.Estatus = \'C\' THEN  \'CANCELADA\'',
													'WHEN C.Estatus = \'L\' THEN  \'AUTORIZADA\'',
													'WHEN C.Estatus = \'A\' THEN  \'REGISTRADA\'',
                                                    'WHEN C.Estatus = \'N\' THEN  \'VIGENTE\'',
												'END AS Estatus,');
	SET	Var_Sentencia := CONCAT(Var_Sentencia,' C.FechaInicio, IF(C.PagoIntCapitaliza = \'S\',\'SI\',\'NO\') AS Capitaliza,C.MotivoCancela');
	SET Var_Sentencia := CONCAT(Var_Sentencia, ' FROM APORTACIONES C');
	SET Var_Sentencia := CONCAT(Var_Sentencia, ' INNER JOIN CLIENTES AS CL ON C.ClienteID = CL.ClienteID');
	SET Var_Sentencia := CONCAT(Var_Sentencia, ' INNER JOIN PROMOTORES AS PO ON CL.PromotorActual = PO.PromotorID');
	SET Var_Sentencia := CONCAT(Var_Sentencia, ' WHERE C.Estatus IN(\'C\',\'L\',\'A\',\'N\')');
    SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND C.AperturaAport = \'FP\'');
    SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND C.FechaInicio >= \'',Par_FechaInicial,'\'');
    SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND C.FechaInicio <= \'',Par_Fechafinal,'\'');

	IF(IFNULL(Par_SucursalID,Entero_Cero)!=Entero_Cero)THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND C.Sucursal=',IFNULL(Par_SucursalID,Entero_Cero));
	END IF;

	IF(IFNULL(Par_ClienteID,Entero_Cero)!=Entero_Cero)THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND C.ClienteID=',IFNULL(Par_ClienteID,Entero_Cero));
	END IF;

	SET Var_Sentencia := CONCAT(Var_Sentencia, ';');

	SET @Sentencia := (Var_Sentencia);

	PREPARE APORTPORINICIAR FROM @Sentencia;
	EXECUTE APORTPORINICIAR;
	DEALLOCATE PREPARE APORTPORINICIAR;

END TerminaStore$$