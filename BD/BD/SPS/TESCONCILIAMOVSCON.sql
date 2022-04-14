-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TESCONCILIAMOVSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TESCONCILIAMOVSCON`;DELIMITER $$

CREATE PROCEDURE `TESCONCILIAMOVSCON`(
# ==================================================================================
# ---------- SP PARA CONSULTAR LOS MOVIMIENTOS DE TESORERIA A CONCILIAR ------------
# ==================================================================================
	Par_InstitucionID		INT(11),
	Par_NumCtaInstit		VARCHAR(20),
	Par_NumCon			    TINYINT UNSIGNED,
	/* Parametros de Auditoria */
	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE Fecha_Vacia 			DATE;
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Entero_Cero 			INT(11);
	DECLARE Est_NoConc 				CHAR(1);
	DECLARE Est_Concilia 			CHAR(1);
	DECLARE Con_Concilia			INT(11);

	-- Declaracion de variables
	DECLARE varCuentaAhoID			BIGINT(12);		-- Guarda el numero de cuenta consultada
	DECLARE varFolioMov 			INT(11);		-- guarda el numero de folio
	DECLARE varFolioCargaID 		INT(11);		-- guarda el numero de carga de archivo conciliado
	DECLARE varNumeroMov 			INT(11);		-- guarda el numero de movimiento
	DECLARE varFechaOperacion 		DATE;			-- guarda la fecha de operacion
	DECLARE varDescripcionMovExt	VARCHAR(150);	-- guarda la descripcion del movimiento externo
	DECLARE varReferenciaMovExt 	VARCHAR(150);	-- guarda la referencia del movimiento externo
	DECLARE varTipoMovExt 			CHAR(4);		-- guarda el tipo de movimiento externo
	DECLARE varMontoMovExt 			DECIMAL(12,2);	-- guarda el monto del movimiento externo
	DECLARE varNatuMovimientoExt	CHAR(1);		-- guarda la naturaleza delmovimiento externo
	DECLARE varEstConcilia			CHAR(1);		-- guarda el valor del estatus a conciliar
	DECLARE consecutivo             INT(11);

	-- cursor para recorrer movimientos externos e internos y sugerir una conciliacion
	DECLARE  CursorMov  CURSOR FOR
		SELECT 		FolioCargaID,		NumeroMov,	FechaOperacion,		DescripcionMovExt,	ReferenciaMovExt,
					TipoMovExt,			MontoMovExt,NatuMovimientoExt,	EstConcilia
			FROM	TMPTESCONMOVS
			WHERE	EstConcilia	=	Est_NoConc;

	-- Asignacion de constantes
	SET Fecha_Vacia				:= '1900-01-01';	-- fecha vacia
	SET Cadena_Vacia			:= '';				-- cadena o string vacio
	SET Entero_Cero				:= 0;				-- entero en cero
	SET Est_NoConc	 			:= 'N';				-- indica que el estatus es no conciliado
	SET Est_Concilia			:= 'C'; 			-- Indica estatus conciliado
	SET Con_Concilia 			:= 1;				-- indica el numero de consulta de conciliacion

	-- se obtiene el valor de la cuenta interna
	SET varCuentaAhoID := ( SELECT CuentaAhoID FROM CUENTASAHOTESO
								WHERE InstitucionID	= Par_InstitucionID
								AND numCtaInstit 	= Par_NumCtaInstit);

	-- se eliminan datos si es que existen de las tablas de paso
	DELETE FROM TMPCONCILIAMOVS ;
	DELETE FROM TMPTESCONMOVS ;

	-- se insertan los movimientos internos de tesoreria
	INSERT INTO TMPCONCILIAMOVS (
			FolioMovimiento,		NumTransaccion,	FechaMov,	DescripcionMov,	ReferenciaMov,
			TipoMov,				MontoMov,		NatMovimiento)
	SELECT	FolioMovimiento,		FolioMovimiento,FechaMov,	DescripcionMov,	ReferenciaMov,
			TipoMov,				MontoMov,		NatMovimiento
		FROM 	TESORERIAMOVS
		WHERE 	CuentaAhoID	= varCuentaAhoID
		AND 	Status 		!= Est_Concilia;


	-- se insertan los movimientos externos de tesoreria
	INSERT INTO TMPTESCONMOVS (
			FolioCargaID,	NumeroMov,	FechaOperacion,		DescripcionMovExt,	ReferenciaMovExt,
			TipoMovExt,		MontoMovExt,NatuMovimientoExt,	EstConcilia)
	SELECT	FolioCargaID,	NumeroMov, 	FechaOperacion, 	DescripcionMov, 	ReferenciaMov,
			TipoMov, 		MontoMov,	NatMovimiento,		Est_NoConc
		FROM	TESOMOVSCONCILIA  exte
		WHERE	exte.CuentaAhoID	= varCuentaAhoID
		AND 	exte.Status 		!= Est_Concilia;


	-- Se actualizan los valores de la tabla con los que coincidan en
	-- monto, fecha, naturaleza, referencia.
	UPDATE 	TMPCONCILIAMOVS movs,
			TMPTESCONMOVS con 	SET
			movs.Conciliado			= Est_Concilia ,
			movs.FolioCargaID		= con.FolioCargaID,
			movs.NumeroMov			= con.NumeroMov,
			movs.FechaOperacion		= con.FechaOperacion,
			movs.DescripcionMovExt	= con.DescripcionMovExt,
			movs.ReferenciaMovExt	= con.ReferenciaMovExt,
			movs.TipoMovExt			= con.TipoMovExt,
			movs.MontoMovExt		= con.MontoMovExt,
			movs.NatuMovimientoExt	= con.NatuMovimientoExt,
			con.EstConcilia  		= Est_Concilia
	WHERE	con.MontoMovExt 		= movs.MontoMov
	AND 	con.FechaOperacion		= movs.FechaMov
	AND 	con.NatuMovimientoExt	= movs.NatMovimiento
	AND 	con.ReferenciaMovExt	= movs.ReferenciaMov
	AND 	con.EstConcilia 		= Est_NoConc; -- para identificar si ese registro ya se habia insertado

	OPEN  CursorMov;
	BEGIN
		DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
		LOOP
			FETCH CursorMov  INTO
				varFolioCargaID,	varNumeroMov,		varFechaOperacion,		varDescripcionMovExt,	varReferenciaMovExt,
				varTipoMovExt ,	varMontoMovExt ,		varNatuMovimientoExt ,	varEstConcilia;

			SET varFolioMov := (SELECT FolioMovimiento
								FROM 	TMPCONCILIAMOVS movs
								WHERE  	movs.MontoMov		= varMontoMovExt
								AND 	movs.FechaMov		= varFechaOperacion
								AND 	movs.NatMovimiento	= varNatuMovimientoExt
								AND 	IFNULL(movs.Conciliado,Est_NoConc)<> Est_Concilia LIMIT 1);

			-- Se actualizan los valores de la tabla con los que coincidan en
			-- monto, fecha, naturaleza, referencia.


			UPDATE 	TMPCONCILIAMOVS movs ,
					TMPTESCONMOVS con	SET
				movs.Conciliado			= Est_Concilia ,
				movs.FolioCargaID		= varFolioCargaID,
				movs.NumeroMov			= varNumeroMov,
				movs.FechaOperacion		= varFechaOperacion,
				movs.DescripcionMovExt	= varDescripcionMovExt,
				movs.ReferenciaMovExt	= varReferenciaMovExt,
				movs.TipoMovExt			= varTipoMovExt,
				movs.MontoMovExt		= varMontoMovExt,
				movs.NatuMovimientoExt 	= varNatuMovimientoExt,
				con.EstConcilia 		= Est_Concilia
			WHERE FolioMovimiento 		= varFolioMov
			AND con.FolioCargaID		= varFolioCargaID;

		END LOOP;
	END;
	CLOSE CursorMov;
	-- se insertan todos los movimientos que no coincidan

	INSERT INTO TMPCONCILIAMOVS (
			FolioCargaID,	NumeroMov,		FechaOperacion,		DescripcionMovExt,	ReferenciaMovExt,
			TipoMovExt,		MontoMovExt,	NatuMovimientoExt)
	SELECT 	FolioCargaID,	NumeroMov,		FechaOperacion,		DescripcionMovExt,	ReferenciaMovExt,
			TipoMovExt,		MontoMovExt,	NatuMovimientoExt
		FROM TMPTESCONMOVS
		WHERE EstConcilia	!= Est_Concilia;


	-- Se hace un select con los datos insertados en la tabla
	SELECT 	IFNULL(FolioMovimiento, Entero_Cero) AS FolioMovimiento,
			IFNULL(NumTransaccion, Entero_Cero) AS NumTransaccion,
			IFNULL(FechaMov, Fecha_Vacia) AS FechaMov,
			IFNULL(DescripcionMov, Cadena_Vacia) AS DescripcionMov,
			IFNULL(ReferenciaMov, Cadena_Vacia) AS ReferenciaMov,
			IFNULL(TipoMov, Cadena_Vacia) AS TipoMov,
			FORMAT(IFNULL(MontoMov, Entero_Cero),2)  AS MontoMov,
			IFNULL(NatMovimiento, Cadena_Vacia)  AS NatMovimiento,
			IFNULL(Conciliado, Est_NoConc) AS Conciliado,
			IFNULL(FolioCargaID, Entero_Cero) AS FolioCargaID,
			IFNULL(NumeroMov, Entero_Cero) AS NumeroMov,
			IFNULL(FechaOperacion, Fecha_Vacia) AS FechaOperacion,
			IFNULL(DescripcionMovExt, Cadena_Vacia) AS DescripcionMovExt,
			IFNULL(ReferenciaMovExt, Cadena_Vacia) AS ReferenciaMovExt,
			IFNULL(TipoMovExt, Cadena_Vacia) AS TipoMovExt,
			FORMAT(IFNULL(MontoMovExt, Entero_Cero),2)  AS MontoMovExt,
			IFNULL(NatuMovimientoExt, Cadena_Vacia)  AS NatuMovimientoExt
		FROM TMPCONCILIAMOVS;


END TerminaStore$$