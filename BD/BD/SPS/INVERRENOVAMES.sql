-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INVERRENOVAMES
DELIMITER ;
DROP PROCEDURE IF EXISTS `INVERRENOVAMES`;DELIMITER $$

CREATE PROCEDURE `INVERRENOVAMES`(
    Par_Anio            	VARCHAR(10),		-- Anio Informacion a Consultar
    Par_Mes            		VARCHAR(10),		-- Mes Informacion a Consultar
    Par_TipoInversionID 	INT(11), 			-- Tipo de Inversion
    Par_PromotorID        	INT(11),			-- Numero de Promotor
    Par_SucursalID        	INT(11),			-- Numero de Sucursal
    Par_Renovada          	INT(11)				-- Renovada = 0 No Renovada = 1
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Sentencia       VARCHAR(1500);
	DECLARE Var_ParaNombre      VARCHAR(100);
	DECLARE Var_ParaSucursal    VARCHAR(100);
	DECLARE Var_ParaMoneda      VARCHAR(100);
	DECLARE Var_Consulta        VARCHAR(100);
	DECLARE Var_Retorna         INT;

	-- Declaracion de Constantes
	DECLARE Entero_Cero         INT(11);
	DECLARE Estatus_Vig         CHAR(1);
	DECLARE Estatus_Can         CHAR(1);
	DECLARE Estatus_Alta        CHAR(1);
	DECLARE No_Reinvierte       CHAR(1);

	-- Asignacion de Constantes
	SET	Entero_Cero		:= 0;		-- Entero Cero
	SET Estatus_Vig		:='N'; 		-- Estatus Inversion: VIGENTE
	SET Estatus_Alta	:='A';		-- Estatus Inversion: ALTA
	SET Estatus_Can		:='C';		-- Estatus Inversion: Cancelada
	SET No_Reinvierte   :='N';		-- No Reinvierte

	-- Se obtiene informacion de inversiones renovadas
	IF (Par_Renovada  = Entero_Cero ) THEN

		SET Var_Sentencia := 'SELECT I.InversionID,I.InversionRenovada, I.ClienteID, C.NombreCompleto, I.Tasa, I.TasaISR,I.TasaNeta,I.Monto,(SELECT Monto FROM INVERSIONES WHERE InversionID = I.InversionRenovada) AS MontoRenovada,I.Plazo,I.FechaInicio,I.FechaVencimiento,I.InteresGenerado,';
		SET Var_Sentencia :=  CONCAT(Var_Sentencia, 'I.InteresRetener, I.InteresRecibir,(I.Monto+I.InteresRecibir)AS TotalRecibir, CI.TipoInversionID, CI.Descripcion AS DescripInversion,P.PromotorID,');
		SET Var_Sentencia :=  CONCAT(Var_Sentencia, 'P.NombrePromotor, S.SucursalID, S.NombreSucurs,C.ClienteID, ');
		SET Var_Sentencia :=  CONCAT(Var_Sentencia, 'CASE I.Estatus WHEN "N" THEN "VIGENTE" WHEN "P" THEN "PAGADA" WHEN "V" THEN "VENCIDA" END AS Estatus ');
		SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' FROM INVERSIONES AS I');

		SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' INNER JOIN CATINVERSION AS CI  ON I.TipoInversionID = CI.TipoInversionID');

		SET Par_TipoInversionID	:= IFNULL(Par_TipoInversionID, Entero_Cero);
		IF(Par_TipoInversionID != Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND CI.TipoInversionID =',CONVERT(Par_TipoInversionID,CHAR));
		END IF;

		SET Var_Sentencia 	:=  CONCAT(Var_Sentencia, ' INNER JOIN CLIENTES AS C ON I.ClienteID = C.ClienteID');

		SET Var_Sentencia 	:=  CONCAT(Var_Sentencia, ' INNER JOIN SUCURSALES AS S ON C.SucursalOrigen = S.SucursalID');

		SET Par_SucursalID	:= IFNULL(Par_SucursalID, Entero_Cero);
		IF(Par_SucursalID != Entero_Cero)THEN
			SET Var_Sentencia = CONCAT(Var_Sentencia, ' AND S.SucursalID =',CONVERT(Par_SucursalID,CHAR));
		END IF;

		SET Var_Sentencia 	:=  CONCAT(Var_Sentencia, ' INNER JOIN PROMOTORES AS P ON C.PromotorActual= P.PromotorID');

		SET Par_PromotorID	:= IFNULL(Par_PromotorID,Entero_Cero);
		IF(Par_PromotorID != Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND P.PromotorID=',CONVERT(Par_PromotorID,CHAR));
		END IF;

		SET Var_Sentencia 	:= CONCAT(Var_Sentencia, ' WHERE I.FechaInicio >= CONCAT(?,"-", ?,"-","01") AND   I.FechaInicio <= LAST_DAY(CONCAT(?,"-", ?,"-","01"))');

		SET Par_Renovada	:= IFNULL(Par_Renovada,Entero_Cero);

		SET Var_Sentencia 	:= CONCAT(Var_Sentencia,' AND I.InversionRenovada > ',CONVERT(Par_Renovada,CHAR));

		SET Var_Sentencia 	:=  CONCAT(Var_Sentencia, ' AND (I.Estatus != "',Estatus_Alta,'" AND I.Estatus != "',Estatus_Can,'")');
		SET Var_Sentencia 	:=  CONCAT(Var_Sentencia, ' ORDER BY S.SucursalID, I.TipoInversionID, P.PromotorID, C.ClienteID,I.InversionID  ;');

	END IF;


     -- Se obtiene informacion de inversiones no renovadas
	IF (Par_Renovada  != Entero_Cero) THEN

		SET Var_Sentencia := 'SELECT I.InversionID,I.InversionRenovada, I.ClienteID, C.NombreCompleto, I.Tasa, I.TasaISR,I.TasaNeta,I.Monto,(SELECT Monto FROM INVERSIONES WHERE InversionID = I.InversionRenovada) AS MontoRenovada,I.Plazo,I.FechaInicio,I.FechaVencimiento,I.InteresGenerado,';
		SET Var_Sentencia :=  CONCAT(Var_Sentencia, 'I.InteresRetener, I.InteresRecibir,(I.Monto+I.InteresRecibir)AS TotalRecibir, CI.TipoInversionID, CI.Descripcion AS DescripInversion,P.PromotorID,');
		SET Var_Sentencia :=  CONCAT(Var_Sentencia, 'P.NombrePromotor, S.SucursalID, S.NombreSucurs,C.ClienteID, ');
		SET Var_Sentencia :=  CONCAT(Var_Sentencia, 'CASE I.Estatus when "N" THEN "VIGENTE" WHEN "P" THEN "PAGADA" WHEN "V" THEN "VENCIDA" END AS Estatus ');
		SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' FROM INVERSIONES AS I');

		SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' INNER JOIN CATINVERSION AS CI  ON I.TipoInversionID = CI.TipoInversionID');

		SET Par_TipoInversionID	:= IFNULL(Par_TipoInversionID, Entero_Cero);
		IF(Par_TipoInversionID != Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND CI.TipoInversionID =',CONVERT(Par_TipoInversionID,CHAR));
		END IF;

		SET Var_Sentencia 	:=  CONCAT(Var_Sentencia, ' INNER JOIN CLIENTES AS C ON I.ClienteID = C.ClienteID');

		SET Var_Sentencia 	:=  CONCAT(Var_Sentencia, ' INNER JOIN SUCURSALES AS S ON C.SucursalOrigen = S.SucursalID');

		SET Par_SucursalID	:= IFNULL(Par_SucursalID, Entero_Cero);
		IF(Par_SucursalID != Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND S.SucursalID =',CONVERT(Par_SucursalID,CHAR));
		END IF;

		SET Var_Sentencia 	:=  CONCAT(Var_Sentencia, ' INNER JOIN PROMOTORES AS P ON C.PromotorActual= P.PromotorID');

		SET Par_PromotorID	:= IFNULL(Par_PromotorID,Entero_Cero);
		IF(Par_PromotorID != Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND P.PromotorID=',CONVERT(Par_PromotorID,CHAR));
		END IF;

		SET Var_Sentencia 	:= CONCAT(Var_Sentencia, ' WHERE I.FechaVencimiento >= CONCAT(?,"-", ?,"-","01") AND   I.FechaVencimiento <= LAST_DAY(CONCAT(?,"-", ?,"-","01"))');

		SET Par_Renovada	:= IFNULL(Par_Renovada,Entero_Cero);

		SET Var_Sentencia 	:=  CONCAT(Var_Sentencia, ' AND (I.Estatus != "',Estatus_Alta,'" AND I.Estatus != "',Estatus_Can,'" AND I.Estatus != "',Estatus_Vig,'")');
		SET Var_Sentencia 	:=  CONCAT(Var_Sentencia, ' AND (I.Reinvertir = "',No_Reinvierte,'")');
		SET Var_Sentencia 	:=  CONCAT(Var_Sentencia, ' ORDER BY S.SucursalID, I.TipoInversionID, P.PromotorID, C.ClienteID,I.InversionID  ;');

	END IF;



	SET @Sentencia	:= (Var_Sentencia);
	SET @Anio := Par_Anio;
	SET @Mes	 := Par_Mes;

	PREPARE SINVERRENOVAMES FROM @Sentencia;
	EXECUTE SINVERRENOVAMES USING @Anio,@Mes,@Anio,@Mes;
	DEALLOCATE PREPARE SINVERRENOVAMES;

END TerminaStore$$