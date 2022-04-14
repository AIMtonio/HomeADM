-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATALOGOACTIVOSREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATALOGOACTIVOSREP`;
DELIMITER $$


CREATE PROCEDURE `CATALOGOACTIVOSREP`(
# ====================================================================
# -------- REPORTE DEPRECIACION Y AMORTIZACION DE ACTIVOS ------------
# ====================================================================
    Par_FechaInicio     DATE,				-- Fecha de Inicio
    Par_FechaFin        DATE,				-- Fecha de Fin
    Par_CentroCosto     INT(11),			-- Centro de Costo
    Par_TipoActivo      INT(11),			-- Tipo de Activo
    Par_Clasificacion   INT(11),			-- Clasificacion

    Par_Estatus	        CHAR(2),			-- Estatus

    Par_EmpresaID       INT(11),			-- Parametro de Auditoria
    Aud_Usuario         INT(11),			-- Parametro de Auditoria
    Aud_FechaActual     DATETIME,			-- Parametro de Auditoria
    Aud_DireccionIP     VARCHAR(15),		-- Parametro de Auditoria
    Aud_ProgramaID      VARCHAR(50),		-- Parametro de Auditoria
    Aud_Sucursal        INT(11),			-- Parametro de Auditoria
    Aud_NumTransaccion  BIGINT(20)			-- Parametro de Auditoria
    )
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES

	DECLARE Var_Sentencia		VARCHAR(6000);		-- Sentencia SQL
	DECLARE Var_ValorINPC			DECIMAL(18,2);	-- Monto de INPC Actual
	DECLARE Var_ValidaINPC			INT(11);		-- Validacion para determinar si existe el INCP a la fecha de consulta
	DECLARE Var_MaxMesINPC			INT(11);		-- Maximo mes registrado para la fecha de consulta


    -- DECLARACION DE CONSTANTES

	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- DECIMAL cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI

	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO
	DECLARE Entero_Uno      	INT(11);      		-- Entero Uno

	-- Declaracion de Consultas
	DECLARE Con_DepAcomulada	INT(11);		-- Consulta Monto a Depreciado Acomulado por Activo a una fecha
	DECLARE Con_SalDepreciar	INT(11);		-- Consulta Monto a Por Depreciar por Activo a una fecha


    -- ASIGNACION DE CONSTANTES

	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;

		-- Asignacion de Consultas
	SET Con_DepAcomulada		:= 3;
	SET Con_SalDepreciar		:= 4;

	SET @Contador				:= Entero_Cero;

	DELETE FROM TMPCATALOGOSACTIVOS WHERE NumTransaccion = Aud_NumTransaccion;

	SET Var_Sentencia := CONCAT("
		INSERT INTO TMPCATALOGOSACTIVOS (
			ConsecutivoID,		TipoActivoID,		ActivoID,			DescTipoActivo,		DescActivo,					FechaAdquisicion,			NumFactura,
			PolizaFactura,		CentroCostoID,		Clasificacion,		Moi,						Estatus,
			DepreciacionAnual,	TiempoAmortiMeses,	DepreContaAnual,	DepreciadoAcumulado,		TotalDepreciar,
			DepreciacionAnualFiscal,				TiempoAmortiMesesFiscal, TipoReg,				EmpresaID,					Usuario,
			FechaActual,		DireccionIP,		ProgramaID,			Sucursal,					NumTransaccion
		)
		SELECT 	(@Contador := @Contador + 1),	TIP.TipoActivoID, 		ACT.ActivoID,			TIP.DescripcionCorta AS DescTipoActivo, 	CONCAT(ACT.ActivoID,'-',ACT.Descripcion) AS DescActivo, ACT.FechaAdquisicion, 	ACT.NumFactura,
				ACT.PolizaFactura,		CONCAT(CC.CentroCostoID,'-',CC.Descripcion) AS CentroCostoID, 		CLA.Descripcion AS Clasificacion, 			ACT.Moi,
				CASE WHEN ACT.Estatus = 'VI' THEN 'VIGENTE'
					WHEN ACT.Estatus = 'BA' THEN 'BAJA'
					WHEN ACT.Estatus = 'VE' THEN 'VENDIDO'
							END AS Estatus,
				TIP.DepreciacionAnual,
				TIP.TiempoAmortiMeses,	ROUND((ACT.Moi * TIP.DepreciacionAnual)/100,2) AS DepreContaAnual, ACT.DepreciadoAcumulado,
				ACT.TotalDepreciar,		ACT.PorDepFiscal,		TIP.TiempoAmortiMeses, 'A',		1,			1,
				'1900-01-01',		'0.0.0.1',			'',					1,			'",Aud_NumTransaccion,"'
		FROM ACTIVOS ACT
			INNER JOIN TIPOSACTIVOS TIP
				ON ACT.TipoActivoID = TIP.TipoActivoID
			INNER JOIN CLASIFICACTIVOS CLA
				ON TIP.ClasificaActivoID = CLA.ClasificaActivoID
			INNER JOIN CENTROCOSTOS CC ON ACT.CentroCostoID = CC.CentroCostoID
        ");

    -- Filtro por fecha de inicio y fin
	SET Var_Sentencia := CONCAT(Var_Sentencia, " WHERE ACT.FechaRegistro BETWEEN '",Par_FechaInicio,"'", " AND '",Par_FechaFin,"'");

	-- Filtro por Centro de Costos
	IF(IFNULL(Par_CentroCosto,Entero_Cero) > Entero_Cero)THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia, " AND ACT.CentroCostoID = ",Par_CentroCosto);
	END IF;

	-- Filtro por Tipo de Activo
	IF(IFNULL(Par_TipoActivo,Entero_Cero) > Entero_Cero)THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia, " AND ACT.TipoActivoID = ",Par_TipoActivo);
	END IF;

	-- Filtro por Clasificacion Tipo de Activo
	IF(IFNULL(Par_Clasificacion,Entero_Cero) > Entero_Cero)THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia, " AND TIP.ClasificaActivoID = ",Par_Clasificacion);
	END IF;

	-- Filtro por Estatus
	IF(IFNULL(Par_Estatus,Cadena_Vacia) <> Cadena_Vacia)THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia, " AND ACT.Estatus = '",Par_Estatus,"' ");
	END IF;


	SET Var_Sentencia := CONCAT(Var_Sentencia, " ORDER BY ACT.TipoActivoID ");

	SET Var_Sentencia := CONCAT(Var_Sentencia, " ;");

	SET @Sentencia	= (Var_Sentencia);

	PREPARE CATALOGOACTIVOSREP FROM @Sentencia;
	EXECUTE CATALOGOACTIVOSREP;
	DEALLOCATE PREPARE CATALOGOACTIVOSREP;


	-- Se obtiene el Depreciado acomulado
	UPDATE TMPCATALOGOSACTIVOS Tmp SET
		Tmp.DepreciadoAcumulado = FNDEPREAMORTIZACION(Tmp.ActivoID, Par_FechaInicio, Par_FechaFin, Entero_Cero, Entero_Cero, Con_DepAcomulada),
		Tmp.TotalDepreciar 		= FNDEPREAMORTIZACION(Tmp.ActivoID, Par_FechaInicio, Par_FechaFin, Entero_Cero, Entero_Cero, Con_SalDepreciar)
	WHERE NumTransaccion = Aud_NumTransaccion;

	-- Se Calculo la Deprecion Fiscal de los Activos
	DROP TABLE IF EXISTS TMPACTIVOSFISCALREP;
	CREATE TABLE `TMPACTIVOSFISCALREP` (
	`tmpID` 				INT(11) AUTO_INCREMENT,
	`ActivoID` 				INT(11),
	`FechaRegistro` 		DATE,
	`ValorINPCMes` 			DECIMAL(12,3),
	`AnioINPC`		 		INT(11),
	`MesINPC`		 		INT(11),
	`ValorINPCProm` 		DECIMAL(12,3),
	`FactorAct` 			DECIMAL(12,3),
	PRIMARY KEY (`tmpID`));

	INSERT INTO TMPACTIVOSFISCALREP(
		ActivoID,		FechaRegistro,			ValorINPCMes,		AnioINPC,		MesINPC,
		ValorINPCProm,	FactorAct)
	SELECT
		Tmp.ActivoID, 		Act.FechaRegistro,	Decimal_Cero,		YEAR(Par_FechaFin),		Entero_Cero,
		Decimal_Cero,		Decimal_Cero
	FROM TMPCATALOGOSACTIVOS Tmp
		INNER JOIN ACTIVOS Act ON Act.ActivoID = Tmp.ActivoID;

	-- Se obtiene el Mes de INPC a obtener de acuerdo al promedio del mes
	UPDATE TMPACTIVOSFISCALREP TMP
	LEFT OUTER JOIN CATBASEINPC CAT
		ON MONTH(TMP.FechaRegistro) = CAT.MesBase
	SET TMP.MesINPC = CAT.MesINPC;

	-- Se obtiene el Valor del INPC del Mes de Fecha de Registro del Activo
	UPDATE TMPACTIVOSFISCALREP TMP
	LEFT OUTER JOIN INDICENAPRECONS IND
		ON YEAR(TMP.FechaRegistro) = IND.Anio
		AND MONTH(TMP.FechaRegistro) = IND.Mes
	SET
		TMP.ValorINPCMes = IF(ValorINPC = Entero_Cero, (SELECT IFNULL(MAX(ValorINPC),Entero_Cero) FROM INDICENAPRECONS WHERE YEAR(TMP.FechaRegistro) = IND.Anio),ValorINPC);

	-- Se Valida que exista el año y mes de consulta
	SELECT IFNULL(COUNT(*), Entero_Cero)
	INTO Var_ValidaINPC
	FROM INDICENAPRECONS
	WHERE Anio = YEAR(Par_FechaFin)
	  AND Mes  = MONTH(Par_FechaFin);

	SET Var_MaxMesINPC := MONTH(Par_FechaFin);

	IF( Var_ValidaINPC = Entero_Cero ) THEN
		-- Se Obtiene el Maximio Mes Registrado para el Año
		SELECT IFNULL(MAX(Mes), Entero_Cero)
		INTO Var_MaxMesINPC
		FROM INDICENAPRECONS
		WHERE Anio = YEAR(Par_FechaFin);
	END IF;

	-- Se Obtiene el INPC del Mes
	SELECT IFNULL(ValorINPC, Decimal_Cero)
	INTO Var_ValorINPC
	FROM INDICENAPRECONS
	WHERE Anio = YEAR(Par_FechaFin)
	  AND Mes  = Var_MaxMesINPC;

	-- Se Obtiene el Valor del INPc del Prom del Mes de Consulta
	UPDATE TMPACTIVOSFISCALREP TMP
	LEFT OUTER JOIN INDICENAPRECONS IND
		ON TMP.AnioINPC = IND.Anio
		AND TMP.MesINPC = IND.Mes
	SET
		TMP.ValorINPCProm = IF(IFNULL(IND.ValorINPC, 0) = Entero_Cero,Var_ValorINPC, IND.ValorINPC);

	-- Se obtiene el Fator de Actualizacion
	UPDATE TMPACTIVOSFISCALREP TMP
	SET  TMP.FactorAct = CASE WHEN IFNULL(TMP.ValorINPCProm, Entero_Cero) = Entero_Cero AND IFNULL(TMP.ValorINPCMes, Entero_Cero) = Entero_Cero
								   THEN Decimal_Cero
								   ELSE
									   CASE WHEN IFNULL(TMP.ValorINPCMes, Entero_Cero) = Entero_Cero
												THEN Decimal_Cero
												ELSE IFNULL(TMP.ValorINPCProm, Entero_Cero) / IFNULL(TMP.ValorINPCMes, Entero_Cero)
									   END
						 END;

	-- Se realiza los calculos para los valores fiscales
	UPDATE TMPCATALOGOSACTIVOS REP
		INNER JOIN TMPACTIVOSFISCALREP TMP ON REP.ActivoID = TMP.ActivoID
	SET
		REP.DepreFiscalAnual = 			IFNULL(REP.DepreContaAnual, Entero_Cero) * IFNULL(TMP.FactorAct, Entero_Cero),
		REP.DepreciadoAcumuladoFiscal = IFNULL(REP.DepreciadoAcumulado, Entero_Cero) * IFNULL(TMP.FactorAct, Entero_Cero),
		REP.SaldoDepreciarFiscal = 		IFNULL(REP.TotalDepreciar, Entero_Cero) * IFNULL(TMP.FactorAct, Entero_Cero),
		REP.PorcentajeFactor = 			IFNULL(TMP.FactorAct, Entero_Cero)
	WHERE NumTransaccion = Aud_NumTransaccion;

	-- Se realiza el calculo de Sumatorias agrupado por el TipoActivoID
	INSERT INTO TMPCATALOGOSACTIVOS (
			ConsecutivoID,			TipoActivoID,			DescTipoActivo,		DescActivo,			FechaAdquisicion,			NumFactura,
			PolizaFactura,			CentroCostoID,		Clasificacion,		Moi,						Estatus,
			DepreciacionAnual,		TiempoAmortiMeses,	DepreContaAnual,	DepreciadoAcumulado,		TotalDepreciar,
			DepreciacionAnualFiscal,	TiempoAmortiMesesFiscal,			DepreFiscalAnual,			DepreciadoAcumuladoFiscal,
			SaldoDepreciarFiscal,		PorcentajeFactor,					TipoReg,					EmpresaID,					Usuario,
			FechaActual,				DireccionIP,						ProgramaID,					Sucursal,					NumTransaccion
		)
	SELECT (@Contador := @Contador + 1), TipoActivoID, 		Cadena_Vacia, 		Cadena_Vacia, 			Fecha_Vacia,				Cadena_Vacia,
			Entero_Cero,		Entero_Cero,		Cadena_Vacia,			Entero_Cero,				Cadena_Vacia,
			Entero_Cero,		Entero_Cero,		SUM(DepreContaAnual),	SUM(DepreciadoAcumulado),	SUM(TotalDepreciar),
			Entero_Cero,		Entero_Cero,		SUM(DepreFiscalAnual),	SUM(DepreciadoAcumuladoFiscal),
			SUM(SaldoDepreciarFiscal),				Entero_Cero,			'T',						Par_EmpresaID,				Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion
	FROM TMPCATALOGOSACTIVOS
		GROUP BY TipoActivoID;


	-- Select Final del Reporte
	SELECT
		IF(TipoReg = 'T', Cadena_Vacia,DescTipoActivo) AS DescTipoActivo,
		IF(TipoReg = 'T', Cadena_Vacia,DescActivo) AS DescActivo,
		IF(TipoReg = 'T', Cadena_Vacia,FechaAdquisicion) AS FechaAdquisicion,
		IF(TipoReg = 'T', Cadena_Vacia,NumFactura) AS NumFactura,
		IF(TipoReg = 'T', Cadena_Vacia,PolizaFactura) AS PolizaFactura,
		IF(TipoReg = 'T', Cadena_Vacia,CentroCostoID) AS CentroCostoID,
		IF(TipoReg = 'T', Cadena_Vacia,Clasificacion) AS Clasificacion,
		IF(TipoReg = 'T', Cadena_Vacia,Moi) AS Moi,
		IF(TipoReg = 'T', Cadena_Vacia,Estatus) AS Estatus,
		IF(TipoReg = 'T', Cadena_Vacia,CONCAT(DepreciacionAnual,'%'))AS DepreciacionAnual,
		IF(TipoReg = 'T', 'SUBTOTAL',TiempoAmortiMeses) AS TiempoAmortiMeses,
		DepreContaAnual,
		DepreciadoAcumulado,
		TotalDepreciar,
		IF(TipoReg = 'T', Cadena_Vacia,CONCAT(DepreciacionAnualFiscal,'%')) AS DepreciacionAnualFiscal,
		IF(TipoReg = 'T', 'SUBTOTAL',TiempoAmortiMesesFiscal) AS TiempoAmortiMesesFiscal,
		DepreFiscalAnual,
		DepreciadoAcumuladoFiscal,
		SaldoDepreciarFiscal,
		TipoReg AS TipoRegistro
	FROM TMPCATALOGOSACTIVOS
	WHERE NumTransaccion = Aud_NumTransaccion
	ORDER BY TipoActivoID, ConsecutivoID;

	DELETE FROM TMPCATALOGOSACTIVOS WHERE NumTransaccion = Aud_NumTransaccion;

END TerminaStore$$