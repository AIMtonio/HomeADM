-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DEPAMORTIZAACTIVOSREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `DEPAMORTIZAACTIVOSREP`;

DELIMITER $$
CREATE PROCEDURE `DEPAMORTIZAACTIVOSREP`(
	-- Reprote de Depreciación de Activos
	-- Activos --> Reportes --> Depreciacion de Activos
	Par_FechaInicio			DATE,				-- Fecha de Inicio
	Par_FechaFin			DATE,				-- Fecha de Fin
	Par_CentroCostoID		INT(11),			-- Centro de Costo
	Par_TipoActivoID		INT(11),			-- Tipo de Activo
	Par_ClasificacionID		INT(11),			-- Clasificacion

	Par_Estatus				CHAR(2),			-- Estatus
	Par_TipoReporte			TINYINT UNSIGNED,	-- Tipo de Reporre

	Par_EmpresaID			INT(11),			-- Parametro de Auditoria
	Aud_Usuario				INT(11),			-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal			INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion 		BIGINT(20)			-- Parametro de Auditoria
	)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Sentencia			VARCHAR(10000);
	DECLARE Var_ColumnasTotalAnio	TEXT;			-- Total de Columas a recorrer
	DECLARE Var_FechaInicio			DATE;			-- Fecha de Inicio
	DECLARE Var_FechaFinal			DATE;			-- Fecha de Final
	DECLARE Var_AnioIteracion		INT(11);		-- Anio de Interacion
	DECLARE Var_MesIteracion		INT(11);		-- Mes de Interacion
	DECLARE Var_MaximoAnio			INT(11);		-- Maxima Interacion
	DECLARE Var_ValidaINPC			INT(11);		-- Validacion para determinar si existe el INCP a la fecha de consulta
	DECLARE Var_MaxMesINPC			INT(11);		-- Maximo mes registrado para la fecha de consulta
	DECLARE Var_MontoDepreciar		DECIMAL(18,2);	-- Monto de Depreciacion
	DECLARE Var_ValorINPC			DECIMAL(18,2);	-- Monto de INPC Actual


	-- Declaracion de constantes
	DECLARE	Cadena_Vacia		CHAR(1);		-- Cadena vacia
	DECLARE Con_Pipe			CHAR(1);		-- Constante Pipe
	DECLARE Con_Total			CHAR(1);		-- Constante Total
	DECLARE Fecha_Vacia			DATE;			-- Fecha vacia
	DECLARE Entero_Cero			INT(11);		-- Entero cero

	DECLARE Entero_Uno			INT(11);		-- Entero Uno
	DECLARE Decimal_Cero		DECIMAL(14,2);	-- Decimal Cero

	-- Declaracion de Consultas
	DECLARE Con_Mensual 		INT(11);		-- Consulta Monto a Depreciar de un Activo por Mes
	DECLARE Con_Anual 			INT(11);		-- Consulta Monto a Depreciar de un Activo por Anio
	DECLARE Con_DepAcomulada	INT(11);		-- Consulta Monto a Depreciado Acomulado por Activo a una fecha
	DECLARE Con_SalDepreciar	INT(11);		-- Consulta Monto a Por Depreciar por Activo a una fecha

	-- Declaracion de Reportes
	DECLARE Rep_Contable		INT(11);		-- Reporte Contable
	DECLARE Rep_Fiscal			INT(11);		-- Reporte Fiscal
	DECLARE Rep_Ambos			INT(11);		-- Reporte Contable - Fiscal

	-- Asignacion de constantes
	SET Cadena_Vacia		:= '';
	SET Con_Pipe			:= '|';
	SET Con_Total			:= 'T';
	SET Fecha_Vacia			:= '1900-01-01';
	SET Entero_Cero			:= 0;

	SET Entero_Uno			:= 1;
	SET Decimal_Cero		:= 0.00;

	-- Asignacion de Consultas
	SET Con_Mensual				:= 1;
	SET Con_Anual				:= 2;
	SET Con_DepAcomulada		:= 3;
	SET Con_SalDepreciar		:= 4;

	-- Declaracion de Reportes
	SET Rep_Contable			:= 1;
	SET Rep_Fiscal				:= 2;
	SET Rep_Ambos				:= 3;

	SET Par_FechaInicio 	:= IFNULL(Par_FechaInicio, Fecha_Vacia);
	SET Par_FechaFin 		:= IFNULL(Par_FechaFin, Fecha_Vacia);
	SET Par_CentroCostoID 	:= IFNULL(Par_CentroCostoID, Entero_Cero);
	SET Par_TipoActivoID 	:= IFNULL(Par_TipoActivoID, Entero_Cero);
	SET Par_ClasificacionID := IFNULL(Par_ClasificacionID, Entero_Cero);
	SET Par_Estatus 		:= IFNULL(Par_Estatus, Cadena_Vacia);

	DELETE FROM TMPPREVIODEPREAMORTI WHERE NumTransaccion = Aud_NumTransaccion;

	DROP TABLE IF EXISTS TMPPREVIODEPREAMORTIREP_HED;
	CREATE TEMPORARY TABLE TMPPREVIODEPREAMORTIREP_HED(
		ActivoID	INT(11),
	PRIMARY KEY (ActivoID));

	SET Var_Sentencia := CONCAT("
		INSERT INTO TMPPREVIODEPREAMORTIREP_HED(
			ActivoID)
		SELECT 	Bita.ActivoID
		FROM BITACORADEPREAMORTI Bita
		INNER JOIN ACTIVOS Act ON Bita.ActivoID = Act.ActivoID
		INNER JOIN TIPOSACTIVOS Tip ON Act.TipoActivoID = Tip.TipoActivoID");

	-- Filtro por fecha de inicio y fin
	SET Var_Sentencia := CONCAT(Var_Sentencia, "
		WHERE Bita.FechaAplicacion BETWEEN '",Par_FechaInicio,"'", " AND '",Par_FechaFin,"'");

	-- Filtro por Centro de Costos
	IF( Par_CentroCostoID > Entero_Cero ) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia, "
		  AND Act.CentroCostoID = ",Par_CentroCostoID);
	END IF;

	-- Filtro por Tipo de Activo
	IF( Par_TipoActivoID > Entero_Cero)THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia, "
		  AND Act.TipoActivoID = ",Par_TipoActivoID);
	END IF;

	-- Filtro por Clasificacion Tipo de Activo
	IF( Par_ClasificacionID > Entero_Cero)THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia, "
		  AND Tip.ClasificaActivoID = ",Par_ClasificacionID);
	END IF;

	-- Filtro por Estatus
	IF( Par_Estatus <> Cadena_Vacia)THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia, "
		  AND Act.Estatus = '",Par_Estatus,"' ");
	END IF;

	SET Var_Sentencia := CONCAT(Var_Sentencia, "
		GROUP BY Bita.ActivoID;");

	SET @Sentencia	= (Var_Sentencia);

	PREPARE DEPAMORTIZAACTIVOSREP FROM @Sentencia;
	EXECUTE DEPAMORTIZAACTIVOSREP;
	DEALLOCATE PREPARE DEPAMORTIZAACTIVOSREP;
	SET @ConsecutivoID := Entero_Cero;
	INSERT INTO TMPPREVIODEPREAMORTI (
		ConsecutivoID,			ActivoID,				TipoActivoID,			DescTipoActivo,			DescActivo,
		FechaAdquisicion,		NumFactura,				Poliza,					CentroCostoID,			CentroCosto,
		Moi,					InpcInicial,			InpcActual,				FactorActualizacion,	DepreciaContaAnual,
		PorDepreContaAnual,		DepreciaFiscalAnual,	PorDepreFiscalAnual,	TiempoAmortiMeses,		MontoAnio,
		Enero,					Febrero,				Marzo,					Abril,					Mayo,
		Junio,					Julio,					Agosto,					Septiembre,				Octubre,
		Noviembre,				Diciembre,				DepreciadoAcumulado,	SaldoPorDepreciar,		TipoReg,
		Monto,					DepFiscalSaldoInicial,	DepFiscalSaldoFinal,
		EmpresaID,				Usuario,				FechaActual,			DireccionIP,			ProgramaID,
		Sucursal,				NumTransaccion)
	SELECT
		@ConsecutivoID:=(@ConsecutivoID + Entero_Uno), ActivoID, 				Entero_Cero, Cadena_Vacia, Cadena_Vacia,
		Fecha_Vacia,			Cadena_Vacia,		Entero_Cero,				Entero_Cero,			Cadena_Vacia,
		Entero_Cero,			Entero_Cero,		Entero_Cero,				Entero_Cero,			Entero_Cero,
		Entero_Cero,			Entero_Cero,		Entero_Cero,				Entero_Cero,			Cadena_Vacia,
		Entero_Cero,			Entero_Cero,		Entero_Cero,				Entero_Cero,			Entero_Cero,
		Entero_Cero,			Entero_Cero,		Entero_Cero,				Entero_Cero,			Entero_Cero,
		Entero_Cero,			Entero_Cero,		Entero_Cero,				Entero_Cero,			Cadena_Vacia,
		Entero_Cero,			Entero_Cero,		Entero_Cero,
		Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,			Aud_DireccionIP,		Aud_ProgramaID,
		Aud_Sucursal,			Aud_NumTransaccion
	FROM TMPPREVIODEPREAMORTIREP_HED;

	-- Actualizo los datos base del reporte
	UPDATE TMPPREVIODEPREAMORTI Tmp
	INNER JOIN ACTIVOS Act ON Tmp.ActivoID = Act.ActivoID
	INNER JOIN CENTROCOSTOS Cen ON Act.CentroCostoID = Cen.CentroCostoID
	INNER JOIN TIPOSACTIVOS Tip ON Act.TipoActivoID = Tip.TipoActivoID SET
		Tmp.TipoActivoID			= Act.TipoActivoID,
		Tmp.DescActivo				= Act.Descripcion,
		Tmp.FechaAdquisicion		= Act.FechaAdquisicion,
		Tmp.NumFactura				= Act.NumFactura,
		Tmp.Poliza					= Act.PolizaFactura,
		Tmp.Moi						= Act.Moi,
		Tmp.TiempoAmortiMeses		= Act.MesesUso,
		Tmp.CentroCostoID			= Act.CentroCostoID,
		Tmp.CentroCosto				= CONCAT(Cen.CentroCostoID,' - ',Cen.Descripcion),
		Tmp.DescTipoActivo			= Tip.Descripcion,
		Tmp.PorDepreFiscalAnual		= Act.PorDepFiscal,
		Tmp.DepFiscalSaldoInicial	= CASE WHEN Par_TipoReporte = Rep_Fiscal
												THEN Act.DepFiscalSaldoInicio
												ELSE Entero_Cero
									  END,
		Tmp.DepFiscalSaldoFinal		= CASE WHEN Par_TipoReporte = Rep_Fiscal
												THEN Act.DepFiscalSaldoFin
												ELSE Entero_Cero
									  END
	WHERE Tmp.NumTransaccion = Aud_NumTransaccion;

	DROP TABLE IF EXISTS TMPPREVIODEPREAMORTIREP_ANIO;
	CREATE TEMPORARY TABLE TMPPREVIODEPREAMORTIREP_ANIO(
		Anio					INT(11),
		TipoActivoID			INT(11),
		Monto 					DECIMAL(16,2),
		PRIMARY KEY (`Anio`,`TipoActivoID`),
		KEY `IDX_TMPPREVIODEPREAMORTIREP_1` (`TipoActivoID`));

	SET Var_ColumnasTotalAnio := Cadena_Vacia;
	SET Var_AnioIteracion	:= YEAR(Par_FechaInicio);
	SET Var_MaximoAnio		:= YEAR(Par_FechaFin);
	SET Var_MesIteracion	:= MONTH(Par_FechaInicio);

	WHILE ( Var_AnioIteracion <= Var_MaximoAnio ) DO

		IF( Var_AnioIteracion = Var_MaximoAnio ) THEN

			-- Actualizo los totaltes por mes
			UPDATE TMPPREVIODEPREAMORTI Tmp SET
				Tmp.Enero 		= FNDEPREAMORTIZACION(Tmp.ActivoID, Par_FechaInicio, Par_FechaFin, Var_MaximoAnio,  1, Con_Mensual),
				Tmp.Febrero		= FNDEPREAMORTIZACION(Tmp.ActivoID, Par_FechaInicio, Par_FechaFin, Var_MaximoAnio,  2, Con_Mensual),
				Tmp.Marzo		= FNDEPREAMORTIZACION(Tmp.ActivoID, Par_FechaInicio, Par_FechaFin, Var_MaximoAnio,  3, Con_Mensual),
				Tmp.Abril 		= FNDEPREAMORTIZACION(Tmp.ActivoID, Par_FechaInicio, Par_FechaFin, Var_MaximoAnio,  4, Con_Mensual),
				Tmp.Mayo		= FNDEPREAMORTIZACION(Tmp.ActivoID, Par_FechaInicio, Par_FechaFin, Var_MaximoAnio,  5, Con_Mensual),
				Tmp.Junio		= FNDEPREAMORTIZACION(Tmp.ActivoID, Par_FechaInicio, Par_FechaFin, Var_MaximoAnio,  6, Con_Mensual),
				Tmp.Julio 		= FNDEPREAMORTIZACION(Tmp.ActivoID, Par_FechaInicio, Par_FechaFin, Var_MaximoAnio,  7, Con_Mensual),
				Tmp.Agosto		= FNDEPREAMORTIZACION(Tmp.ActivoID, Par_FechaInicio, Par_FechaFin, Var_MaximoAnio,  8, Con_Mensual),
				Tmp.Septiembre	= FNDEPREAMORTIZACION(Tmp.ActivoID, Par_FechaInicio, Par_FechaFin, Var_MaximoAnio,  9, Con_Mensual),
				Tmp.Octubre 	= FNDEPREAMORTIZACION(Tmp.ActivoID, Par_FechaInicio, Par_FechaFin, Var_MaximoAnio, 10, Con_Mensual),
				Tmp.Noviembre	= FNDEPREAMORTIZACION(Tmp.ActivoID, Par_FechaInicio, Par_FechaFin, Var_MaximoAnio, 11, Con_Mensual),
				Tmp.Diciembre	= FNDEPREAMORTIZACION(Tmp.ActivoID, Par_FechaInicio, Par_FechaFin, Var_MaximoAnio, 12, Con_Mensual)
			WHERE Tmp.NumTransaccion = Aud_NumTransaccion;

			-- Se obtiene el monto del activo del año en curso
			UPDATE TMPPREVIODEPREAMORTI Tmp SET
				Tmp.Monto =	ROUND(
								  (Tmp.Enero 	  + Tmp.Febrero + Tmp.Marzo 	+ Tmp.Abril +
								   Tmp.Mayo  	  + Tmp.Junio   + Tmp.Julio 	+ Tmp.Agosto +
								   Tmp.Septiembre + Tmp.Octubre + Tmp.Noviembre + Tmp.Diciembre) , 2)
			WHERE Tmp.NumTransaccion = Aud_NumTransaccion;

			-- Se obtiene el monto  para los campos dinamicos
			UPDATE TMPPREVIODEPREAMORTI Tmp SET
				Tmp.MontoAnio = CONCAT(Tmp.MontoAnio,
											  (ROUND(
													 (Tmp.Enero 	 + Tmp.Febrero + Tmp.Marzo 	   + Tmp.Abril +
													  Tmp.Mayo  	 + Tmp.Junio   + Tmp.Julio 	   + Tmp.Agosto +
													  Tmp.Septiembre + Tmp.Octubre + Tmp.Noviembre + Tmp.Diciembre) , 2)))
			WHERE Tmp.NumTransaccion = Aud_NumTransaccion;

			-- Se insertan los totales por activo
			INSERT INTO TMPPREVIODEPREAMORTIREP_ANIO(
					Anio, 				TipoActivoID, Monto)

			SELECT Var_MaximoAnio,	TipoActivoID,	SUM(Monto)
			FROM TMPPREVIODEPREAMORTI
			WHERE NumTransaccion = Aud_NumTransaccion
			GROUP BY TipoActivoID;

			SET Var_ColumnasTotalAnio := CONCAT(Var_ColumnasTotalAnio, Var_MaximoAnio);

		ELSE

			-- Se obtiene el monto del activo del año en curso
			UPDATE TMPPREVIODEPREAMORTI Tmp SET
				Tmp.Monto = FNDEPREAMORTIZACION(Tmp.ActivoID, Par_FechaInicio, Par_FechaFin, Var_AnioIteracion, Var_MesIteracion, Con_Anual)
			WHERE Tmp.NumTransaccion = Aud_NumTransaccion;

			-- Se obtiene el monto  para los campos dinamicos
			UPDATE TMPPREVIODEPREAMORTI Tmp SET
				Tmp.MontoAnio = CONCAT(Tmp.MontoAnio,
									FNDEPREAMORTIZACION(Tmp.ActivoID, Par_FechaInicio, Par_FechaFin, Var_AnioIteracion, Var_MesIteracion, Con_Anual),
									Con_Pipe)
			WHERE Tmp.NumTransaccion = Aud_NumTransaccion;

			-- Se insertan los totales por activo
			INSERT INTO TMPPREVIODEPREAMORTIREP_ANIO(
					Anio, 				TipoActivoID, Monto)
			SELECT Var_AnioIteracion,	TipoActivoID,	SUM(Monto)
			FROM TMPPREVIODEPREAMORTI
			WHERE NumTransaccion = Aud_NumTransaccion
			GROUP BY TipoActivoID;

			SET Var_ColumnasTotalAnio := CONCAT(Var_ColumnasTotalAnio, Var_AnioIteracion, Con_Pipe);
			SET Var_MesIteracion := Entero_Uno;
		END IF;

		SET Var_AnioIteracion := Var_AnioIteracion + Entero_Uno;
		SET Var_MontoDepreciar := Entero_Cero;
	END WHILE;

	-- Se obtiene el Depreciado acomulado
	UPDATE TMPPREVIODEPREAMORTI Tmp SET
		Tmp.DepreciadoAcumulado = FNDEPREAMORTIZACION(Tmp.ActivoID, Par_FechaInicio, Par_FechaFin, Entero_Cero, Entero_Cero, Con_DepAcomulada),
		Tmp.SaldoPorDepreciar 	= FNDEPREAMORTIZACION(Tmp.ActivoID, Par_FechaInicio, Par_FechaFin, Entero_Cero, Entero_Cero, Con_SalDepreciar)
	WHERE Tmp.NumTransaccion = Aud_NumTransaccion
	  AND Tmp.TipoReg <> Con_Total;

	DROP TABLE IF EXISTS TMPPREVIODEPREAMORTIREP_SUM;
	CREATE TEMPORARY TABLE TMPPREVIODEPREAMORTIREP_SUM(
		TipoActivoID		INT(11),
		Total				TEXT,
		PRIMARY KEY (`TipoActivoID`),
		KEY `IDX_TMPPREVIODEPREAMORTIREP_SUM_1` (`TipoActivoID`));

	-- Se asignan los totales de los campos dinamicos
	INSERT INTO TMPPREVIODEPREAMORTIREP_SUM (
			TipoActivoID,	Total)
	SELECT TipoActivoID,	REPLACE(group_concat(Monto),',', Con_Pipe)
	FROM TMPPREVIODEPREAMORTIREP_ANIO
	GROUP BY TipoActivoID;

	DROP TABLE IF EXISTS TMPPREVIODEPREAMORTIREP_DEP;
	CREATE TEMPORARY TABLE TMPPREVIODEPREAMORTIREP_DEP(
		ActivoID			INT(11),
		PorDepreContaAnual	DECIMAL(14,2),
	PRIMARY KEY (ActivoID));

	INSERT INTO TMPPREVIODEPREAMORTIREP_DEP(
			PorDepreContaAnual,	ActivoID)
	SELECT 	DISTINCT(Bita.DepreciacionAnual),	Bita.ActivoID
	FROM BITACORADEPREAMORTI Bita
	INNER JOIN TMPPREVIODEPREAMORTIREP_HED Tmp ON Bita.ActivoID = Tmp.ActivoID;

	-- Se obtiene la Depreciacion Anual del Activo
	UPDATE TMPPREVIODEPREAMORTI Tmp, TMPPREVIODEPREAMORTIREP_DEP Bita SET
		Tmp.PorDepreContaAnual = Bita.PorDepreContaAnual,
		Tmp.DepreciaContaAnual = ROUND(((Tmp.Moi * Bita.PorDepreContaAnual)/100), 2)
	WHERE Tmp.NumTransaccion = Aud_NumTransaccion
	  AND Tmp.ActivoID = Bita.ActivoID;

	IF( Par_TipoReporte <> Rep_Contable ) THEN
		-- Seccion para el Reporte tipo 3
		-- Se Obtiene el INPC de Registro del Activo
		UPDATE TMPPREVIODEPREAMORTI Tmp
		INNER JOIN ACTIVOS Act ON  Tmp.ActivoID = Act.ActivoID
		LEFT OUTER JOIN INDICENAPRECONS Ind ON YEAR(Act.FechaRegistro) = Ind.Anio
										   AND MONTH(Act.FechaRegistro) = Ind.Mes SET
			Tmp.InpcInicial = CASE WHEN IFNULL(Ind.ValorINPC, Decimal_Cero) = Decimal_Cero
										THEN (SELECT IFNULL(MAX(ValorINPC), Decimal_Cero) FROM INDICENAPRECONS WHERE YEAR(Act.FechaRegistro) = Ind.Anio)
										ELSE IFNULL(Ind.ValorINPC, Decimal_Cero)
							  END
		WHERE Tmp.NumTransaccion = Aud_NumTransaccion;

		-- Valido que exista el año y mes de consulta
		SELECT IFNULL(COUNT(*), Entero_Cero)
		INTO Var_ValidaINPC
		FROM INDICENAPRECONS
		WHERE Anio = YEAR(Par_FechaFin)
		  AND Mes  = MONTH(Par_FechaFin);

		SET Var_MaxMesINPC := MONTH(Par_FechaFin);

		IF( Var_ValidaINPC = Entero_Cero ) THEN
			-- Obtengo el Maximio Mes Registrado para el Año
			SELECT IFNULL(MAX(Mes), Entero_Cero)
			INTO Var_MaxMesINPC
			FROM INDICENAPRECONS
			WHERE Anio = YEAR(Par_FechaFin);
		END IF;

		-- Obtengo el INPC del Mes
		SELECT IFNULL(ValorINPC, Decimal_Cero)
		INTO Var_ValorINPC
		FROM INDICENAPRECONS
		WHERE Anio = YEAR(Par_FechaFin)
		  AND Mes  = Var_MaxMesINPC;

		-- Se Obtiene el INPC Actual del Activo
		UPDATE TMPPREVIODEPREAMORTI Tmp SET
			Tmp.InpcActual = Var_ValorINPC
		WHERE Tmp.NumTransaccion = Aud_NumTransaccion;

		-- Se obtiene el factor de actualizacion
		UPDATE TMPPREVIODEPREAMORTI Tmp SET
			Tmp.FactorActualizacion = CASE WHEN Tmp.InpcInicial = Decimal_Cero AND Tmp.InpcActual = Decimal_Cero
												THEN Decimal_Cero
												ELSE
													CASE WHEN Tmp.InpcInicial = Decimal_Cero
															  THEN Decimal_Cero
															  ELSE Tmp.InpcActual / Tmp.InpcInicial
													END
									  END
		WHERE Tmp.NumTransaccion = Aud_NumTransaccion;

		-- Se Obtiene la Depreciación Fiscal del Activo
		UPDATE TMPPREVIODEPREAMORTI Tmp SET
			Tmp.DepreciaFiscalAnual = (Tmp.FactorActualizacion * Tmp.DepreciaContaAnual)
		WHERE Tmp.NumTransaccion = Aud_NumTransaccion;

	END IF;

	-- Se registran las sumatorias por producto
	SET @ConsecutivoID := IFNULL((SELECT MAX(ConsecutivoID) FROM TMPPREVIODEPREAMORTI WHERE NumTransaccion = Aud_NumTransaccion), Entero_Cero);
	INSERT INTO TMPPREVIODEPREAMORTI (
		ConsecutivoID,				ActivoID,					TipoActivoID,				DescTipoActivo,			DescActivo,
		FechaAdquisicion,			NumFactura,					Poliza,						CentroCostoID,			CentroCosto,
		Moi,						InpcInicial,				InpcActual,					FactorActualizacion,	DepreciaContaAnual,
		PorDepreContaAnual,			DepreciaFiscalAnual,		PorDepreFiscalAnual,		TiempoAmortiMeses,		MontoAnio,
		Enero,						Febrero,					Marzo,						Abril,					Mayo,
		Junio,						Julio,						Agosto,						Septiembre,				Octubre,
		Noviembre,					Diciembre,					DepreciadoAcumulado,		SaldoPorDepreciar,		TipoReg,
		Monto,						DepFiscalSaldoInicial,		DepFiscalSaldoFinal,
		EmpresaID,					Usuario,					FechaActual,				DireccionIP,			ProgramaID,
		Sucursal,					NumTransaccion)
	SELECT @ConsecutivoID:=(@ConsecutivoID + Entero_Uno),	Entero_Cero, 			TipoActivoID, Cadena_Vacia, Cadena_Vacia,
		Fecha_Vacia,				Cadena_Vacia,				Entero_Cero,				Entero_Cero,			Cadena_Vacia,
		SUM(Moi),					Entero_Cero,				Entero_Cero,				Entero_Cero,			SUM(DepreciaContaAnual),
		SUM(PorDepreContaAnual),	SUM(DepreciaFiscalAnual), 	SUM(PorDepreFiscalAnual),	Entero_Cero,			Cadena_Vacia,
		SUM(Enero),					SUM(Febrero),				SUM(Marzo),					SUM(Abril),				SUM(Mayo),
		SUM(Junio),					SUM(Julio),					SUM(Agosto),				SUM(Septiembre),		SUM(Octubre),
		SUM(Noviembre),				SUM(Diciembre),				SUM(DepreciadoAcumulado),	SUM(SaldoPorDepreciar), Con_Total,
		Entero_Cero,				Entero_Cero,				Entero_Cero,
		Par_EmpresaID,				Aud_Usuario,				Aud_FechaActual,			Aud_DireccionIP,		Aud_ProgramaID,
		Aud_Sucursal,				Aud_NumTransaccion
	FROM TMPPREVIODEPREAMORTIREP_HED Bas
	INNER JOIN TMPPREVIODEPREAMORTI Tmp ON Bas.ActivoID = Tmp.ActivoID
	WHERE NumTransaccion = Aud_NumTransaccion
	GROUP BY Tmp.TipoActivoID;

	UPDATE TMPPREVIODEPREAMORTI Tmp, TMPPREVIODEPREAMORTIREP_SUM Tol SET
		Tmp.MontoAnio = Tol.Total
	WHERE Tmp.NumTransaccion = Aud_NumTransaccion
	  AND Tmp.TipoActivoID = Tol.TipoActivoID
	  AND Tmp.TipoReg = Con_Total;

	SELECT ConsecutivoID,
		DescTipoActivo,		DescActivo,					FechaAdquisicion,		NumFactura,				Poliza,
		CentroCosto,		Moi,						InpcInicial,			InpcActual,				FactorActualizacion,
		DepreciaContaAnual,	PorDepreContaAnual, 		DepreciaFiscalAnual,	PorDepreFiscalAnual,	TiempoAmortiMeses,
		Enero,				Febrero,					Marzo,					Abril,					Mayo,
		Junio,				Julio,						Agosto,					Septiembre,				Octubre,
		Noviembre,			Diciembre,					DepreciadoAcumulado,	SaldoPorDepreciar,		ActivoID,
		TipoActivoID,		MontoAnio AS ColumnasAnio,	Var_ColumnasTotalAnio AS Columnas,				TipoReg AS TipoFila,
		Monto,				DepFiscalSaldoInicial,		DepFiscalSaldoFinal
	FROM TMPPREVIODEPREAMORTI
	WHERE NumTransaccion = Aud_NumTransaccion
	ORDER BY TipoActivoID, ConsecutivoID;

	DELETE FROM TMPPREVIODEPREAMORTI WHERE NumTransaccion = Aud_NumTransaccion;
	DROP TABLE IF EXISTS TMPPREVIODEPREAMORTIREP_HED;
	DROP TABLE IF EXISTS TMPPREVIODEPREAMORTIREP_SUM;
	DROP TABLE IF EXISTS TMPPREVIODEPREAMORTIREP_ANIO;
	DROP TABLE IF EXISTS TMPPREVIODEPREAMORTIREP_DEP;

END TerminaStore$$