-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PREVIODEPAMORTIZAACTIVOSREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `PREVIODEPAMORTIZAACTIVOSREP`;
DELIMITER $$

CREATE PROCEDURE `PREVIODEPAMORTIZAACTIVOSREP`(
# ====================================================================
# ----- REPORTE PREVIO DE DEPRECIACION Y AMORTIZACION DE ACTIVOS -----
# ====================================================================
    Par_Anio     		INT(11),			-- Anio
    Par_Mes       		INT(11),			-- Mes

    Par_EmpresaID       INT(11),			-- Parametro de Auditoria
    Aud_Usuario         INT(11),			-- Parametro de Auditoria
    Aud_FechaActual     DATETIME,			-- Parametro de Auditoria
    Aud_DireccionIP     VARCHAR(15),		-- Parametro de Auditoria
    Aud_ProgramaID      VARCHAR(50),		-- Parametro de Auditoria
    Aud_Sucursal        INT(11),			-- Parametro de Auditoria
    Aud_NumTransaccion  BIGINT(20)			-- Parametro de Auditoria
    )
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia    	CHAR(1);
	DECLARE Fecha_Vacia     	DATE;
	DECLARE Entero_Cero     	INT(11);
    DECLARE Est_Registrado		CHAR(1);
    DECLARE Est_Vigente			CHAR(2);
    DECLARE Est_Baja			CHAR(2);

	-- Asignacion de constantes
	SET Cadena_Vacia        := '';				-- Cadena vacia
	SET Fecha_Vacia         := '1900-01-01';	-- Fecha vacia
	SET Entero_Cero         := 0;				-- Entero cero
    SET Est_Registrado		:= 'R';
    SET Est_Vigente			:= 'VI';
    SET Est_Baja			:= 'BA';

	DROP TABLE IF EXISTS TMPPREVIODEPREAMORTIREP;
	CREATE TEMPORARY TABLE TMPPREVIODEPREAMORTIREP(
		ActivoID			INT(11),
		DescTipoActivo		VARCHAR(300),
		DescActivo			VARCHAR(300),
		FechaAdquisicion	DATE,
		NumFactura			VARCHAR(50),

		Poliza				BIGINT(12),
		CentroCostoID		INT(11),
		Moi					DECIMAL(16,2),
        DepreciacionAnual	DECIMAL(16,2),
		TiempoAmortiMeses	INT(11),

		DepreciaContaAnual	DECIMAL(16,2),
        Enero				DECIMAL(16,2),
        Febrero				DECIMAL(16,2),
        Marzo				DECIMAL(16,2),
        Abril				DECIMAL(16,2),

        Mayo				DECIMAL(16,2),
        Junio				DECIMAL(16,2),
        Julio				DECIMAL(16,2),
        Agosto				DECIMAL(16,2),
        Septiembre			DECIMAL(16,2),

        Octubre				DECIMAL(16,2),
        Noviembre			DECIMAL(16,2),
        Diciembre			DECIMAL(16,2),
		DepreciadoAcumulado	DECIMAL(16,2),
		SaldoPorDepreciar	DECIMAL(16,2),

		PRIMARY KEY(ActivoID),
		KEY `IDX_TMPPREVIODEPREAMORTI_1` (`Poliza`)
	);

	INSERT INTO TMPPREVIODEPREAMORTIREP (
				ActivoID, 					DescTipoActivo, 			DescActivo, 			FechaAdquisicion, 			NumFactura,
				Poliza, 					CentroCostoID,	 			Moi, 					DepreciacionAnual, 			TiempoAmortiMeses,
				DepreciaContaAnual, 		Enero, 						Febrero, 				Marzo, 						Abril,
				Mayo, 						Junio, 						Julio, 					Agosto, 					Septiembre,
				Octubre, 					Noviembre, 					Diciembre, 				DepreciadoAcumulado,		SaldoPorDepreciar

	)SELECT 	ACT.ActivoID,				TIP.DescripcionCorta,		ACT.Descripcion, 		ACT.FechaAdquisicion, 		ACT.NumFactura,
				ACT.PolizaFactura,			ACT.CentroCostoID,			ACT.Moi,				BDA.DepreciacionAnual,		BDA.TiempoAmortiMeses,
				BDA.DepreciaContaAnual,     Entero_Cero,				Entero_Cero,			Entero_Cero,				Entero_Cero,
				Entero_Cero,				Entero_Cero,				Entero_Cero,			Entero_Cero,				Entero_Cero,
				Entero_Cero,				Entero_Cero,				Entero_Cero,	        BDA.DepreciadoAcumulado,	BDA.SaldoPorDepreciar
	FROM BITACORADEPREAMORTI BDA
		INNER JOIN ACTIVOS ACT
			ON BDA.ActivoID = ACT.ActivoID
		INNER JOIN TIPOSACTIVOS TIP
			ON ACT.TipoActivoID = TIP.TipoActivoID
	WHERE BDA.Anio = Par_Anio
		AND BDA.Mes = Par_Mes
        AND BDA.Estatus = Est_Registrado
        AND ACT.Estatus IN(Est_Vigente,Est_Baja)
        GROUP BY BDA.ActivoID, 		BDA.DepreciacionAnual,	BDA.TiempoAmortiMeses, 	BDA.DepreciaContaAnual,	BDA.DepreciadoAcumulado, 	BDA.SaldoPorDepreciar,
				 ACT.ActivoID,		TIP.DescripcionCorta,	ACT.Descripcion, 		ACT.FechaAdquisicion, 	ACT.NumFactura, 			ACT.PolizaFactura,
                 ACT.CentroCostoID,	ACT.Moi;

	-- ACTUALIZA MONTOS MESES DEPRECIADOS
    UPDATE TMPPREVIODEPREAMORTIREP TMP, BITACORADEPREAMORTI BDA SET
		TMP.Enero = BDA.MontoDepreciar
	WHERE TMP.ActivoID = BDA.ActivoID
		AND BDA.Anio = Par_Anio
		AND BDA.Mes = 1
        AND BDA.Mes <= Par_Mes;

    UPDATE TMPPREVIODEPREAMORTIREP TMP, BITACORADEPREAMORTI BDA SET
		TMP.Febrero = BDA.MontoDepreciar
	WHERE TMP.ActivoID = BDA.ActivoID
		AND BDA.Anio = Par_Anio
		AND BDA.Mes = 2
        AND BDA.Mes <= Par_Mes;

    UPDATE TMPPREVIODEPREAMORTIREP TMP, BITACORADEPREAMORTI BDA SET
		TMP.Marzo = BDA.MontoDepreciar
	WHERE TMP.ActivoID = BDA.ActivoID
		AND BDA.Anio = Par_Anio
		AND BDA.Mes = 3
        AND BDA.Mes <= Par_Mes;

    UPDATE TMPPREVIODEPREAMORTIREP TMP, BITACORADEPREAMORTI BDA SET
		TMP.Abril = BDA.MontoDepreciar
	WHERE TMP.ActivoID = BDA.ActivoID
		AND BDA.Anio = Par_Anio
		AND BDA.Mes = 4
        AND BDA.Mes <= Par_Mes;

    UPDATE TMPPREVIODEPREAMORTIREP TMP, BITACORADEPREAMORTI BDA SET
		TMP.Mayo = BDA.MontoDepreciar
	WHERE TMP.ActivoID = BDA.ActivoID
		AND BDA.Anio = Par_Anio
		AND BDA.Mes = 5
        AND BDA.Mes <= Par_Mes;

    UPDATE TMPPREVIODEPREAMORTIREP TMP, BITACORADEPREAMORTI BDA SET
		TMP.Junio = BDA.MontoDepreciar
	WHERE TMP.ActivoID = BDA.ActivoID
		AND BDA.Anio = Par_Anio
		AND BDA.Mes = 6
        AND BDA.Mes <= Par_Mes;

    UPDATE TMPPREVIODEPREAMORTIREP TMP, BITACORADEPREAMORTI BDA SET
		TMP.Julio = BDA.MontoDepreciar
	WHERE TMP.ActivoID = BDA.ActivoID
		AND BDA.Anio = Par_Anio
		AND BDA.Mes = 7
        AND BDA.Mes <= Par_Mes;

    UPDATE TMPPREVIODEPREAMORTIREP TMP, BITACORADEPREAMORTI BDA SET
		TMP.Agosto = BDA.MontoDepreciar
	WHERE TMP.ActivoID = BDA.ActivoID
		AND BDA.Anio = Par_Anio
		AND BDA.Mes = 8
        AND BDA.Mes <= Par_Mes;

    UPDATE TMPPREVIODEPREAMORTIREP TMP, BITACORADEPREAMORTI BDA SET
		TMP.Septiembre = BDA.MontoDepreciar
	WHERE TMP.ActivoID = BDA.ActivoID
		AND BDA.Anio = Par_Anio
		AND BDA.Mes = 9
        AND BDA.Mes <= Par_Mes;

    UPDATE TMPPREVIODEPREAMORTIREP TMP, BITACORADEPREAMORTI BDA SET
		TMP.Octubre = BDA.MontoDepreciar
	WHERE TMP.ActivoID = BDA.ActivoID
		AND BDA.Anio = Par_Anio
		AND BDA.Mes = 10
        AND BDA.Mes <= Par_Mes;

    UPDATE TMPPREVIODEPREAMORTIREP TMP, BITACORADEPREAMORTI BDA SET
		TMP.Noviembre = BDA.MontoDepreciar
	WHERE TMP.ActivoID = BDA.ActivoID
		AND BDA.Anio = Par_Anio
		AND BDA.Mes = 11
        AND BDA.Mes <= Par_Mes;

    UPDATE TMPPREVIODEPREAMORTIREP TMP, BITACORADEPREAMORTI BDA SET
		TMP.Diciembre = BDA.MontoDepreciar
	WHERE TMP.ActivoID = BDA.ActivoID
		AND BDA.Anio = Par_Anio
		AND BDA.Mes = 12
        AND BDA.Mes <= Par_Mes;

    SELECT 	ActivoID, 			DescTipoActivo, CONCAT(ActivoID,'-',DescActivo) AS DescActivo, 	FechaAdquisicion, 		NumFactura,
			Poliza, 			CentroCostoID, 	Moi, 			DepreciacionAnual, 		TiempoAmortiMeses,
            DepreciaContaAnual, Enero, 			Febrero, 		Marzo, 					Abril,
            Mayo, 				Junio, 			Julio, 			Agosto, 				Septiembre,
            Octubre, 			Noviembre, 		Diciembre, 		DepreciadoAcumulado, 	SaldoPorDepreciar
	FROM  TMPPREVIODEPREAMORTIREP;

	DROP TABLE IF EXISTS TMPPREVIODEPREAMORTIREP;
END TerminaStore$$