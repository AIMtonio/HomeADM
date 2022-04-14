-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOREMESASREP
DELIMITER ;
DROP procedure IF EXISTS `PAGOREMESASREP`;
DELIMITER $$

CREATE PROCEDURE `PAGOREMESASREP`(
	Par_RemesaCatalogoID	INT(11),	
	Par_SucursalID			INT(11),
	Par_UsuarioID			INT(11),
	Par_FechaInicio			DATE,
	Par_FechaFinal			DATE,

    Par_NumRep				tinyint unsigned,
	
    Par_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
)
TerminaStore:BEGIN

-- DECLARACION DE VARIABLES 
DECLARE Var_Sentencia 		TEXT;	-- Almacena la Sentencia de la Consulta
DECLARE Var_FechaSistema	DATE;
-- DECLARACION DE CONSTANTES
DECLARE Rep_Pagada		int;
DECLARE Entero_Cero		int;

-- ASIGNACION DE CONSTANTES
set Rep_Pagada			:=1;
set Entero_Cero			:=0;

-- ASIGNACION DE VARIABLES
SET Var_Sentencia		:= '';
SET Var_FechaSistema	:= (select FechaSistema from PARAMETROSSIS);


-- REPORTE DE REMESAS PAGADAS
IF(Par_NumRep = Rep_Pagada)THEN
	DROP TABLE IF EXISTS TMPPAGOREMESASREP_0;
	CREATE TEMPORARY TABLE TMPPAGOREMESASREP_0(
		FechaDePago			DATE,			-- FECHA DE PAGO
		Remesedora			VARCHAR(200),	
		Referencia			VARCHAR(45),
		Sucursal 			VARCHAR(50),
		Cliente 			VARCHAR(200),	
		Monto				decimal(14,2),
		Cajero 				VARCHAR(200),
		FormaDePago 		VARCHAR(20),
		NumTransaccion 		BIGINT,
		BilletesMil			INT(11),
		BilletesQuinientos	INT(11),
		BilletesDoscientos 	INT(11),
		BilletesCien 		INT(11),
		BilletesCincuenta 	INT(11),
		BilletesVeinte 		INT(11), 
		Monedas 			INT(11),
		NoImpresiones		INT(11)
	);

	SET Var_Sentencia := CONCAT(Var_Sentencia, '  INSERT INTO TMPPAGOREMESASREP_0 ');
	SET Var_Sentencia := CONCAT(Var_Sentencia, ' 	SELECT 	PAG.Fecha, 	CONCAT(PAG.RemesaCatalogoID," - ",REM.Nombre) ,	PAG.RemesaFolio,	CONCAT(SUC.SucursalID ," - ",SUC.NombreSucurs),	PAG.NombreCompleto, ');
	SET Var_Sentencia := CONCAT(Var_Sentencia, ' 			PAG.Monto,	USU.NombreCompleto,		PAG.FormaPago,	PAG.NumTransaccion,		 ');
	SET Var_Sentencia := CONCAT(Var_Sentencia, ' 	0,0, 0, 0, 0, 0, 0, ');
	SET Var_Sentencia := CONCAT(Var_Sentencia, ' ifnull(NumeroImpresiones,',Entero_Cero,') ');
	SET Var_Sentencia := CONCAT(Var_Sentencia, ' 	FROM PAGOREMESAS PAG ');
	SET Var_Sentencia := CONCAT(Var_Sentencia, ' 		INNER JOIN REMESACATALOGO 	REM ON REM.RemesaCatalogoID = PAG.RemesaCatalogoID ');
	SET Var_Sentencia := CONCAT(Var_Sentencia, ' 		INNER JOIN SUCURSALES 		SUC ON SUC.SucursalID 		= PAG.SucursalID ');
	SET Var_Sentencia := CONCAT(Var_Sentencia, ' 		INNER JOIN USUARIOS 		USU ON USU.UsuarioID 		= PAG.UsuarioID ');
	SET Var_Sentencia := CONCAT(Var_Sentencia, ' WHERE PAG.Fecha BETWEEN "',Par_FechaInicio,'"  AND  "',Par_FechaFinal,'" ');

	IF(IFNULL(Par_RemesaCatalogoID, Entero_Cero)) != Entero_Cero THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia, '  AND PAG.RemesaCatalogoID=',Par_RemesaCatalogoID );
	END IF;
	IF(IFNULL(Par_SucursalID, Entero_Cero)) != Entero_Cero THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia, '  AND PAG.SucursalID=',Par_SucursalID );
	END IF;
		IF(IFNULL(Par_UsuarioID, Entero_Cero)) != Entero_Cero THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia, '  AND PAG.UsuarioID=',Par_UsuarioID );
	END IF;

	SET Var_Sentencia := CONCAT(Var_Sentencia,' ; ');

	SET @Sentencia	= (Var_Sentencia);
	PREPARE Ejecuta FROM @Sentencia;
	EXECUTE Ejecuta;
	DEALLOCATE PREPARE Ejecuta;

	UPDATE 	TMPPAGOREMESASREP_0 TMP, DENOMINACIONMOVS DEN SET 
		BilletesMil			= CASE WHEN Naturaleza = 1 THEN Cantidad * -1 ELSE Cantidad END WHERE DEN.NumTransaccion = TMP.NumTransaccion AND DenominacionID = 1;

	UPDATE 	TMPPAGOREMESASREP_0 TMP, DENOMINACIONMOVS DEN SET 
		BilletesQuinientos	= CASE WHEN Naturaleza = 1 THEN Cantidad * -1 ELSE Cantidad END WHERE DEN.NumTransaccion = TMP.NumTransaccion AND DenominacionID = 2;

	UPDATE 	TMPPAGOREMESASREP_0 TMP, DENOMINACIONMOVS DEN SET 
		BilletesDoscientos 	= CASE WHEN Naturaleza = 1 THEN Cantidad * -1 ELSE Cantidad END WHERE DEN.NumTransaccion = TMP.NumTransaccion AND DenominacionID = 3;

	UPDATE 	TMPPAGOREMESASREP_0 TMP, DENOMINACIONMOVS DEN SET 
		BilletesCien 		= CASE WHEN Naturaleza = 1 THEN Cantidad * -1 ELSE Cantidad END WHERE DEN.NumTransaccion = TMP.NumTransaccion AND DenominacionID = 4;

	UPDATE 	TMPPAGOREMESASREP_0 TMP, DENOMINACIONMOVS DEN SET
		BilletesCincuenta 	= CASE WHEN Naturaleza = 1 THEN Cantidad * -1 ELSE Cantidad END WHERE DEN.NumTransaccion = TMP.NumTransaccion AND DenominacionID = 5;

	UPDATE 	TMPPAGOREMESASREP_0 TMP, DENOMINACIONMOVS DEN SET 
		BilletesVeinte 		= CASE WHEN Naturaleza = 1 THEN Cantidad * -1 ELSE Cantidad END WHERE DEN.NumTransaccion = TMP.NumTransaccion AND DenominacionID = 6;

	UPDATE 	TMPPAGOREMESASREP_0 TMP, DENOMINACIONMOVS DEN SET 
		Monedas 			= CASE WHEN Naturaleza = 1 THEN Cantidad * -1 ELSE Cantidad END WHERE DEN.NumTransaccion = TMP.NumTransaccion AND DenominacionID = 7;

	-- HISTORICO
	IF(Par_FechaInicio<Var_FechaSistema )THEN
		UPDATE 	TMPPAGOREMESASREP_0 TMP, `HIS-DENOMMOVS` DEN SET 
			BilletesQuinientos	= CASE WHEN Naturaleza = 1 THEN Cantidad * -1 ELSE Cantidad END WHERE DEN.NumTransaccion = TMP.NumTransaccion AND DenominacionID = 2;

		UPDATE 	TMPPAGOREMESASREP_0 TMP, `HIS-DENOMMOVS` DEN SET 
			BilletesDoscientos 	= CASE WHEN Naturaleza = 1 THEN Cantidad * -1 ELSE Cantidad END WHERE DEN.NumTransaccion = TMP.NumTransaccion AND DenominacionID = 3;

		UPDATE 	TMPPAGOREMESASREP_0 TMP, `HIS-DENOMMOVS` DEN SET 
			BilletesCien 		= CASE WHEN Naturaleza = 1 THEN Cantidad * -1 ELSE Cantidad END WHERE DEN.NumTransaccion = TMP.NumTransaccion AND DenominacionID = 4;

		UPDATE 	TMPPAGOREMESASREP_0 TMP, `HIS-DENOMMOVS` DEN SET
			BilletesCincuenta 	= CASE WHEN Naturaleza = 1 THEN Cantidad * -1 ELSE Cantidad END WHERE DEN.NumTransaccion = TMP.NumTransaccion AND DenominacionID = 5;

		UPDATE 	TMPPAGOREMESASREP_0 TMP, `HIS-DENOMMOVS` DEN SET 
			BilletesVeinte 		= CASE WHEN Naturaleza = 1 THEN Cantidad * -1 ELSE Cantidad END WHERE DEN.NumTransaccion = TMP.NumTransaccion AND DenominacionID = 6;

		UPDATE 	TMPPAGOREMESASREP_0 TMP, `HIS-DENOMMOVS` DEN SET 
			Monedas 			= CASE WHEN Naturaleza = 1 THEN Cantidad * -1 ELSE Cantidad END WHERE DEN.NumTransaccion = TMP.NumTransaccion AND DenominacionID = 7;
	END IF;

	SELECT 
		FechaDePago,		Remesedora, 	Referencia, 		Sucursal, 		Cliente,
		Monto, 				Cajero, 		FormaDePago, 		BilletesMil,	BilletesQuinientos,
		BilletesDoscientos, BilletesCien,	BilletesCincuenta, 	BilletesVeinte, Monedas,
		NoImpresiones
	FROM TMPPAGOREMESASREP_0;



	DROP TABLE IF EXISTS TMPPAGOREMESASREP_0;
END IF; -- FIN DE Rep_Pagada

END TerminaStore$$