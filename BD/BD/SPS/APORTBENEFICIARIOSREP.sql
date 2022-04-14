

-- APORTBENEFICIARIOSREP --

DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTBENEFICIARIOSREP`;
-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after  the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE `APORTBENEFICIARIOSREP`(
	/*REPORTE DE APORTACIONES DISPERSADAS */
	Par_FechaInicio					DATE,			-- Fecha de Inicio
	Par_FechaFin					DATE,			-- Fecha Final
	Par_Estatus						CHAR(1),		-- Estatus
	Par_ClienteID					INT(11),
	Par_ProductoID					INT(11),
	Par_tipoLista					TINYINT UNSIGNED,
	/*Parametros de Auditoria */
	Aud_EmpresaID					INT(11),
	Aud_Usuario						INT(11),
	Aud_FechaActual					DATETIME,

	Aud_DireccionIP					VARCHAR(50),
	Aud_ProgramaID					VARCHAR(50),
	Aud_Sucursal					INT(11),
	Aud_NumTransaccion 				BIGINT(20)
	)
TerminaStore: BEGIN
/*DECLARACION DE VARIABLES*/
	DECLARE Cadena_Vacia	CHAR(1);			-- Cadena Vacia
	DECLARE Fecha_Vacia		DATE;				-- Fecha Vacia
	DECLARE Entero_Cero		INT(0);				-- Entero_Cero
	DECLARE	Var_Sentencia		VARCHAR(15000);
	DECLARE Var_NumAport	INT(11);

	DECLARE Aux_NumReg		INT(11);
	DECLARE Aux_Contador	INT(11);
	DECLARE Var_AportacionID 	INT(11);
	DECLARE Var_AmortizacionID BIGINT(12);
	DECLARE Var_ClienteID 	INT(11);
	DECLARE Var_CuentaAhoID BIGINT(12);

	DECLARE Var_Estatus		CHAR(1);
	DECLARE Var_Capital 	DECIMAL(18,2);
	DECLARE Var_Interes 	DECIMAL(18,2);
	DECLARE Var_ISR 		DECIMAL(18,2);
	DECLARE Var_Total		DECIMAL(18,2);

	DECLARE Var_MaxAmort 	INT(11);
	DECLARE Var_PagoIntCapitaliza CHAR(1);
	DECLARE Aux_NumRegAport	INT(11);
	DECLARE Var_EstatusAmort	CHAR(1);

	DECLARE Var_TipoReinversion CHAR(3);
	DECLARE Var_ReinversionAutomatica CHAR(3);
	DECLARE Var_OpcionAportID	INT(11);

	/*DECLARACION DE CONSTANTES*/
	DECLARE Var_EsPrincipal	CHAR(1);
	SET Cadena_Vacia		:= '';
	SET Fecha_Vacia			:= '1900-01-01';
	SET Entero_Cero			:= 0;
	SET Var_Estatus 		:=	Par_Estatus;

	SET Aud_NumTransaccion := ROUND(RAND()*1000000);

	SET Par_Estatus := IFNULL(Par_Estatus,'T');
	SET Var_EsPrincipal := 'S';

	DELETE FROM APORTDISPERSIONESREP WHERE NumTransaccion = Aud_NumTransaccion;

	# MONTOS Y BENEFICIARIOS REGISTRADOS Y PENDIENTES

	SET Var_Sentencia := CONCAT('INSERT INTO APORTDISPERSIONESREP ( ',
		'CuentaAhoID,  		AportacionID,			AmortizacionID,		ClienteID,		NombreAportante, ',
		'PromotorID,		NombrePromotor,			FechaCorte,			Beneficiario,	Capital, ',
		'Interes,			InteresRetener,			Total,				Estatus,		DesEstatus, ',
		'InstitucionID,		TipoCuentaSpei,			Clabe,				CantidadenDispersion,NumTransaccion, ',
		'MontoPendiente,  	CuentaTranID) ');
	SET Var_Sentencia := CONCAT( Var_Sentencia,
		'SELECT ',
			'MAX(AD.CuentaAhoID ), MAX(AD.AportacionID),		MAX(AD.AmortizacionID), MAX(AD.ClienteID),MAX(UPPER(C.NombreCompleto)), ',
			'MAX(C.PromotorActual), "Nombre Promotor",MAX(AD.FechaVencimiento), "",SUM(AD.Capital), ',
			'SUM(AD.Interes),SUM(AD.InteresRetener),	 SUM(AD.Total), MAX(AD.Estatus),CASE WHEN MAX(AD.Estatus) = "P" THEN "PENDIENTE" ',
			'ELSE CASE WHEN MAX(AD.Estatus) = "S" THEN "REGISTRADO" ',
			'END ',
			'END, ',
			'0,0,0,SUM(AD.MontoPendiente),',Aud_NumTransaccion,', ',
			'SUM(AD.MontoPendiente), MAX(AD.CuentaTranID) ',
		'FROM APORTDISPERSIONES AD ',
		'INNER JOIN APORTACIONES AP ON AD.AportacionID = AP.AportacionID ',
		'INNER JOIN CLIENTES C ON AD.ClienteID = C.ClienteID  ');
	SET Var_Sentencia := CONCAT(Var_Sentencia,
		'	WHERE ((AP.Estatus != \'C\' AND AD.FechaVencimiento BETWEEN "',Par_FechaInicio,'" AND "',Par_FechaFin,'" ) ',
			'OR ',
			'(AP.Estatus = \'C\' AND AP.FechaVenAnt BETWEEN "',Par_FechaInicio,'" AND "',Par_FechaFin,'" )) ');

	IF(IFNULL(Par_Estatus,'T') != 'T') THEN
		SET Par_Estatus := IF(Par_Estatus = 'M','S',Par_Estatus );
		SET Var_Sentencia := CONCAT(Var_Sentencia, 'AND AD.Estatus = "',Par_Estatus,'" ');
	END IF;

	IF(IFNULL(Par_ClienteID,Entero_Cero) != Entero_Cero) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia, 'AND AP.ClienteID = ',Par_ClienteID,' ');
	END IF;

	IF(IFNULL(Par_ProductoID,Entero_Cero) != Entero_Cero) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia, 'AND AP.TipoAportacionID = ',Par_ProductoID,' ');
	END IF;

	SET Var_Sentencia := CONCAT(Var_Sentencia, ' GROUP BY AD.CuentaAhoID  UNION ');

	SET Var_Sentencia := CONCAT( Var_Sentencia, 'SELECT AP.CuentaAhoID , AP.AportacionID,		AP.AmortizacionID,			AP.ClienteID,	UPPER(CT.NombreCompleto),
		CT.PromotorActual, "Nombre Promotor", AP.FechaVencimiento, AB.Beneficiario, 0,
		0,	0,	0, AP.Estatus,CASE WHEN AP.Estatus = "P" THEN "PENDIENTE"
		ELSE CASE WHEN AP.Estatus = "S" THEN "REGISTRADO"
		END
		END,
		AB.InstitucionID, AB.TipoCuentaSpei, AB.Clabe, AB.MontoDispersion,',Aud_NumTransaccion,',0, AB.CuentaTranID
		FROM APORTBENEFICIARIOS AB
		INNER JOIN APORTDISPERSIONES AP ON AB.AportacionID = AP.AportacionID AND AB.AmortizacionID = AP.AmortizacionID
		INNER JOIN APORTACIONES APT ON APT.AportacionID = AP.AportacionID
		INNER JOIN CLIENTES CT	ON AP.ClienteID = CT.ClienteID');
	SET Var_Sentencia := CONCAT(Var_Sentencia,
		'	WHERE ((APT.Estatus != \'C\' AND AP.FechaVencimiento BETWEEN "',Par_FechaInicio,'" AND "',Par_FechaFin,'" ) ',
			'OR ',
			'(APT.Estatus = \'C\' AND APT.FechaVenAnt BETWEEN "',Par_FechaInicio,'" AND "',Par_FechaFin,'" )) ');
	SET Var_Sentencia := CONCAT(Var_Sentencia,'	AND  AB.CuentaTranID != IFNULL(AP.CuentaTranID,0) ');

	IF(IFNULL(Par_Estatus,'T') != 'T') THEN
	SET Par_Estatus := IF(Par_Estatus = 'M','S',Par_Estatus );
	SET Var_Sentencia := CONCAT(Var_Sentencia, 'AND AP.Estatus = "',Par_Estatus,'" ');
	END IF;

	IF(IFNULL(Par_ClienteID,Entero_Cero) != Entero_Cero) THEN
	SET Var_Sentencia := CONCAT(Var_Sentencia, 'AND AP.ClienteID = ',Par_ClienteID,' ');
	END IF;

	IF(IFNULL(Par_ProductoID,Entero_Cero) != Entero_Cero) THEN
	SET Var_Sentencia := CONCAT(Var_Sentencia, 'AND APT.TipoAportacionID = ',Par_ProductoID,' ');
	END IF;

	SET Var_Sentencia := CONCAT(Var_Sentencia, ';');

	SET @Sentencia := (Var_Sentencia);


	PREPARE APORTBENEFICIARIOSREP FROM @Sentencia;
	EXECUTE APORTBENEFICIARIOSREP;
	DEALLOCATE PREPARE APORTBENEFICIARIOSREP;

	UPDATE APORTDISPERSIONESREP T
			INNER JOIN APORTDISPERSIONES CT ON T.ClienteID = CT.ClienteID AND  T.CuentaAhoID = CT.CuentaAhoID
		SET T.AmortizacionID = CT.AmortizacionID
		WHERE T.NumTransaccion = Aud_NumTransaccion
			AND T.AportacionID = CT.AportacionID;
	#MONTOS DE DISPERSIONES CANCELADAS

	IF(Par_Estatus IN ('T','C')) THEN

		SET Var_Sentencia := CONCAT('INSERT INTO APORTDISPERSIONESREP (
			CuentaAhoID,  		AportacionID,			AmortizacionID,		ClienteID,		NombreAportante,
			PromotorID,			NombrePromotor,			FechaCorte,			Beneficiario,	Capital,
			Interes,			InteresRetener,			Total,				Estatus,		DesEstatus,
			InstitucionID,		TipoCuentaSpei,			Clabe,				CantidadPagada, NumTransaccion,
			MontoPendiente,  	CuentaTranID) ');
		SET Var_Sentencia := CONCAT(Var_Sentencia,' SELECT
					APD.CuentaAhoID,		 AMT.AportacionID, 				AMT.AmortizacionID, 		APD.ClienteID, 			UPPER(C.NombreCompleto),
				    C.PromotorActual,		 "NOMBRE PROMOTOR", 			AMT.FechaVencimiento,		TMP.Beneficiario, 		AMT.Capital,
				    AMT.Interes,	 		AMT.InteresRetener, 			AMT.Total,						"C", 				"CANCELADO",
				    TMP.InstitucionID,		 TMP.TipoCuentaSpei,			TMP.Clabe, 					TMP.MontoDispersion, ',Aud_NumTransaccion,',
				    0, 						 TMP.CuentaTranID
			FROM HISAPORTBENEFICIARIOS TMP
				INNER JOIN AMORTIZAAPORT AMT ON TMP.AportacionID = AMT.AportacionID AND TMP.AmortizacionID = AMT.AmortizacionID
				INNER JOIN APORTACIONES APD ON TMP.AportacionID = APD.AportacionID
				INNER JOIN CLIENTES C ON APD.ClienteID = C.ClienteID ');
		SET Var_Sentencia := CONCAT(Var_Sentencia,'	WHERE AMT.FechaVencimiento BETWEEN "',Par_FechaInicio,'" AND "',Par_FechaFin,'" AND TMP.TipoBaja = 3 ');


		IF(IFNULL(Par_ClienteID,Entero_Cero) != Entero_Cero) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia, 'AND APD.ClienteID = ',Par_ClienteID,' ');
		END IF;

		IF(IFNULL(Par_ProductoID,Entero_Cero) != Entero_Cero) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia, 'AND APD.TipoAportacionID = ',Par_ProductoID,' ');
		END IF;

		SET @Sentencia := (Var_Sentencia);
		PREPARE APORTBENEFICIARIOSREP FROM @Sentencia;
		EXECUTE APORTBENEFICIARIOSREP;
		DEALLOCATE PREPARE APORTBENEFICIARIOSREP;
	END IF;



	#MONTOS DE DISPERSIONES FINALIZADA
	IF(Par_Estatus IN ('T','D')) THEN
		SET Var_Sentencia := CONCAT('INSERT INTO APORTDISPERSIONESREP (
			CuentaAhoID,  		AportacionID,			AmortizacionID,		ClienteID,		NombreAportante,
			PromotorID,			NombrePromotor,			FechaCorte,			Beneficiario,	Capital,
			Interes,			InteresRetener,			Total,				Estatus,		DesEstatus,
			InstitucionID,		TipoCuentaSpei,			Clabe,				CantidadPagada, NumTransaccion,
			MontoPendiente,  	CuentaTranID) ');
		SET Var_Sentencia := CONCAT(Var_Sentencia,' SELECT
					APD.CuentaAhoID,		 AMT.AportacionID, 				AMT.AmortizacionID, 		APD.ClienteID, 			UPPER(C.NombreCompleto),
				    C.PromotorActual,		 "NOMBRE PROMOTOR", 			AMT.FechaVencimiento,		TMP.Beneficiario, 		AMT.Capital,
				    AMT.Interes,	 		AMT.InteresRetener, 			AMT.Total,						"D", 				"FINALIZADO",
				    TMP.InstitucionID,		 TMP.TipoCuentaSpei,			TMP.Clabe, 					TMP.MontoDispersion, ',Aud_NumTransaccion,',
				    0, 						 TMP.CuentaTranID
			FROM HISAPORTBENEFICIARIOS TMP
				INNER JOIN AMORTIZAAPORT AMT ON TMP.AportacionID = AMT.AportacionID AND TMP.AmortizacionID = AMT.AmortizacionID
				INNER JOIN APORTACIONES APD ON TMP.AportacionID = APD.AportacionID
				INNER JOIN CLIENTES C ON APD.ClienteID = C.ClienteID ');
		SET Var_Sentencia := CONCAT(Var_Sentencia,
		'	WHERE ((APD.Estatus != \'C\' AND AMT.FechaVencimiento BETWEEN "',Par_FechaInicio,'" AND "',Par_FechaFin,'" ) ',
			'OR ',
			'(APD.Estatus = \'C\' AND APD.FechaVenAnt BETWEEN "',Par_FechaInicio,'" AND "',Par_FechaFin,'" )) ');

		IF(IFNULL(Par_ClienteID,Entero_Cero) != Entero_Cero) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia, 'AND APD.ClienteID = ',Par_ClienteID,' ');
		END IF;

		IF(IFNULL(Par_ProductoID,Entero_Cero) != Entero_Cero) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia, 'AND APD.TipoAportacionID = ',Par_ProductoID,' ');
		END IF;

		SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND  TMP.TipoBaja = 2; ');

		SET @Sentencia := (Var_Sentencia);
		PREPARE APORTBENEFICIARIOSREP FROM @Sentencia;
		EXECUTE APORTBENEFICIARIOSREP;
		DEALLOCATE PREPARE APORTBENEFICIARIOSREP;

	END IF;

	UPDATE APORTDISPERSIONESREP AR
		INNER JOIN APORTDISPERSIONES AD ON AR.CuentaAhoID = AD.CuentaAhoID
		INNER JOIN APORTBENEFICIARIOS AB ON AB.AportacionID = AD.AportacionID  AND AB.AmortizacionID = AD.AmortizacionID AND AB.CuentaTranID = AD.CuentaTranID
	SET AR.TipoCuentaSpei = AB.TipoCuentaSpei,
	    AR.Clabe = AB.Clabe,
	    AR.Beneficiario = AB.Beneficiario,
	    AR.CantidadenDispersion = AB.MontoDispersion
	WHERE IFNULL(AR.CantidadenDispersion,Entero_Cero) = Entero_Cero AND AR.Estatus IN ('S','P') AND AR.NumTransaccion = Aud_NumTransaccion;


	UPDATE APORTDISPERSIONESREP T
			INNER JOIN APORTBENEFICIARIOS AB ON T.AportacionID = AB.AportacionID AND T.AmortizacionID = AB.AmortizacionID AND T.Clabe = AB.Clabe
			SET T.InstitucionID = AB.InstitucionID
		WHERE T.NumTransaccion = Aud_NumTransaccion;

	UPDATE APORTDISPERSIONESREP T
				INNER JOIN CUENTASTRANSFER CT ON T.ClienteID = CT.ClienteID AND CT.TipoCuenta = 'E' AND CT.Estatus = 'A'  AND CT.EsPrincipal = Var_EsPrincipal
				LEFT OUTER JOIN TIPOSCUENTASPEI TS ON CT.TipoCuentaSpei = TS.TipoCuentaID
			SET T.InstitucionID = CT.InstitucionID,
				T.TipoCuentaSpei = CT.TipoCuentaSpei,
				T.TipoCuentaSpeiDes = UPPER(TS.Descripcion),
				T.Clabe	= CT.Clabe,
				T.Beneficiario = UPPER(CT.Beneficiario)
	WHERE T.InstitucionID = Entero_Cero
	AND T.NumTransaccion = Aud_NumTransaccion;

	UPDATE APORTDISPERSIONESREP T
				INNER JOIN CUENTASTRANSFER CT ON T.ClienteID = CT.ClienteID AND CT.TipoCuenta = 'E' AND CT.Estatus = 'A'
				LEFT OUTER JOIN TIPOSCUENTASPEI TS ON CT.TipoCuentaSpei = TS.TipoCuentaID
			SET T.InstitucionID = CT.InstitucionID,
				T.TipoCuentaSpei = CT.TipoCuentaSpei,
				T.TipoCuentaSpeiDes = UPPER(TS.Descripcion),
				T.Clabe	= CT.Clabe,
				T.Beneficiario = UPPER(CT.Beneficiario)
	WHERE T.InstitucionID = Entero_Cero
	AND T.NumTransaccion = Aud_NumTransaccion;


	UPDATE APORTDISPERSIONESREP T
		INNER JOIN INSTITUCIONES I ON T.InstitucionID = I.ClaveParticipaSpei
			SET T.NombreInstitucion = UPPER(I.NombreCorto)
		WHERE  T.InstitucionID > Entero_Cero
		AND T.NumTransaccion = Aud_NumTransaccion;

	UPDATE APORTDISPERSIONESREP T
		INNER JOIN TIPOSCUENTASPEI I ON T.TipoCuentaSpei = I.TipoCuentaID
			SET T.TipoCuentaSpeiDes = UPPER(I.Descripcion)
		WHERE T.NumTransaccion = Aud_NumTransaccion;

	# CANTIDAD REGISTRADA (MONTO PENDIENTE)

    DROP TABLE IF EXISTS TMP_APORTDISPERSIONESLIS;
    CREATE TEMPORARY TABLE TMP_APORTDISPERSIONESLIS(
		CuentaAhoID	BIGINT(12) primary KEY,
        MontoPendiente	DECIMAL(14,2)
    );

    DROP TABLE IF EXISTS TMP_APORTDISPERSIONESLIS2;
    CREATE TEMPORARY TABLE TMP_APORTDISPERSIONESLIS2(
		CuentaAhoID	BIGINT(12) primary KEY,
        Total			DECIMAL(14,2),
        MontoTotalPendiente DECIMAL(18,2)
    );

    DROP TABLE IF EXISTS TMP_APORTDISPERSIONESLIS3;
    CREATE TEMPORARY TABLE TMP_APORTDISPERSIONESLIS3(
		CuentaAhoID	BIGINT(12) primary KEY,
        Capital			DECIMAL(14,2),
        Interes 		DECIMAL(18,2),
        InteresRetener  DECIMAL(18,2),
        Total 			DECIMAL(18,2)
    );

    INSERT INTO TMP_APORTDISPERSIONESLIS( CuentaAhoID, MontoPendiente)
	    SELECT CuentaAhoID, SUM(CantidadenDispersion)
		FROM APORTDISPERSIONESREP
		WHERE CuentaAhoID IN (SELECT CuentaAhoID FROM APORTDISPERSIONESREP WHERE NumTransaccion = Aud_NumTransaccion)
	    AND NumTransaccion = Aud_NumTransaccion
		GROUP BY CuentaAhoID,NumTransaccion;

	INSERT INTO TMP_APORTDISPERSIONESLIS2( CuentaAhoID, Total, MontoTotalPendiente)
		SELECT CuentaAhoID, MontoPendiente, MontoPendiente
		FROM APORTCTADISPERSIONES;


	INSERT INTO TMP_APORTDISPERSIONESLIS3( CuentaAhoID, Capital, Interes, InteresRetener, Total)
	    SELECT CuentaAhoID, Capital, Interes, InteresRetener, Total
		FROM APORTDISPERSIONESREP
		WHERE CuentaAhoID IN (SELECT CuentaAhoID FROM APORTDISPERSIONESREP WHERE NumTransaccion = Aud_NumTransaccion)
		AND Total > Entero_Cero
			AND Estatus NOT IN ('C','D')
	    AND NumTransaccion = Aud_NumTransaccion;



	UPDATE TMP_APORTDISPERSIONESLIS2 Tmp2, TMP_APORTDISPERSIONESLIS Tmp
		SET	Tmp2.Total =  CASE WHEN (Tmp2.Total - Tmp.MontoPendiente ) < 0 THEN 0 ELSE (Tmp2.Total - Tmp.MontoPendiente ) END
		WHERE Tmp2.CuentaAhoID = Tmp.CuentaAhoID;

	UPDATE APORTDISPERSIONESREP APD
		INNER JOIN  TMP_APORTDISPERSIONESLIS2 AP ON APD.CuentaAhoID =  AP.CuentaAhoID
			SET APD.CantidadPendiente = AP.Total
		WHERE APD.NumTransaccion = Aud_NumTransaccion AND APD.Estatus IN ('P') AND APD.CantidadenDispersion = Entero_Cero;

	UPDATE  APORTDISPERSIONESREP ARP
		INNER JOIN CLIENTES CLI  ON ARP.ClienteID = CLI.ClienteID
		INNER JOIN PROMOTORES PRO ON CLI.PromotorActual = PRO.PromotorID
			SET ARP.NombrePromotor = UPPER(PRO.NombrePromotor)
		WHERE ARP.NumTransaccion = Aud_NumTransaccion;

	UPDATE  APORTDISPERSIONESREP ARP
		INNER JOIN TMP_APORTDISPERSIONESLIS3 APR  ON ARP.CuentaAhoID = APR.CuentaAhoID
			SET ARP.Capital = APR.Capital,
				ARP.Interes = APR.Interes,
				ARP.InteresRetener = APR.InteresRetener,
				ARP.Total = APR.Total
		WHERE ARP.NumTransaccion = Aud_NumTransaccion;

	UPDATE APORTDISPERSIONESREP Tmp, TMP_APORTDISPERSIONESLIS2 Apo
		SET Tmp.CantidadPendiente = Apo.MontoTotalPendiente
		WHERE Tmp.CuentaAhoID = Apo.CuentaAhoID
		AND Tmp.NumTransaccion = Aud_NumTransaccion ;

	IF (Var_Estatus = 'M' ) THEN
		UPDATE APORTDISPERSIONESREP
			SET Estatus = 'M',
				DesEstatus = 'REGISTRADO CON MONTO PENDIENTE'
		WHERE MontoPendiente < Total
			AND Estatus = 'S'
			AND NumTransaccion = Aud_NumTransaccion;
	END IF;

	SET Aux_NumReg := (SELECT COUNT(AportacionID) FROM APORTDISPERSIONESREP WHERE NumTransaccion = Aud_NumTransaccion);
	SET Aux_Contador := 0;

	-- SE ACTUALIZAN LOS SALDOS
	WHILE Aux_Contador < Aux_NumReg do
		SET Var_ClienteID := (SELECT ClienteID FROM APORTDISPERSIONESREP WHERE NumTransaccion = Aud_NumTransaccion LIMIT Aux_Contador,1);
		SET Var_CuentaAhoID := (SELECT CuentaAhoID FROM APORTDISPERSIONESREP WHERE NumTransaccion = Aud_NumTransaccion LIMIT Aux_Contador,1);
		SET Var_AportacionID := (SELECT AportacionID FROM APORTDISPERSIONESREP WHERE NumTransaccion = Aud_NumTransaccion LIMIT Aux_Contador,1);
		SET Var_AmortizacionID := (SELECT AmortizacionID FROM APORTDISPERSIONESREP WHERE NumTransaccion = Aud_NumTransaccion LIMIT Aux_Contador,1);

		SELECT SUM(Capital),SUM(Interes),SUM(InteresRetener),SUM(Total)
			INTO Var_Capital, 	  Var_Interes, 			Var_ISR, 		 	Var_Total
			FROM HISAPORTDISPERSIONES TMP
			WHERE TMP.CuentaAhoID =  Var_CuentaAhoID
			AND FechaVencimiento BETWEEN Par_FechaInicio AND Par_FechaFin ;

		UPDATE APORTDISPERSIONESREP
			SET Capital = Var_Capital,
				Interes = Var_Interes,
				InteresRetener = Var_ISR,
				Total = Var_Total
		WHERE ClienteID = Var_ClienteID
			AND CuentaAhoID =  Var_CuentaAhoID
			AND Estatus IN ('C','D')
			AND NumTransaccion = Aud_NumTransaccion;

		SET Aux_Contador = Aux_Contador +1;
	END WHILE;

	SET @ID := 0;
	INSERT INTO TMPAPORTACIONESPAG
		SELECT @ID := @ID+1 AS ConsecutivoID,AMT.AportacionID, AMT.AmortizacionID, ADP.CuentaAhoID, ADP.PagoIntCapitaliza, VEN.TipoReinversion,0, VEN.ReinversionAutomatica,VEN.OpcionAportID,Aud_NumTransaccion
		FROM AMORTIZAAPORT AMT
			INNER JOIN APORTACIONES ADP ON AMT.AportacionID = ADP.AportacionID
			LEFT JOIN CONDICIONESVENCIMAPORT VEN ON AMT.AportacionID = VEN.AportacionID
		WHERE AMT.FechaVencimiento  BETWEEN Par_FechaInicio AND Par_FechaFin;

	-- SE ACTUALIZAN LAS APORTACIONES PAGADAS
	SET Aux_NumRegAport := (SELECT COUNT(ConsecutivoID) FROM TMPAPORTACIONESPAG WHERE NumTransaccion = Aud_NumTransaccion);
	SET Aux_Contador := 1;
	SET Var_MaxAmort := 0;
	SET Var_CuentaAhoID := 0;
	SET Var_AportacionID := 0;
	SET Var_AmortizacionID := 0;

	WHILE Aux_Contador < Aux_NumRegAport DO

        SELECT CuentaAhoID, AportacionID, AmortizacionID, TipoReinversion, ReinversionAutomatica, OpcionAportID
			INTO Var_CuentaAhoID, Var_AportacionID, Var_AmortizacionID, Var_TipoReinversion, Var_ReinversionAutomatica, Var_OpcionAportID
		FROM TMPAPORTACIONESPAG WHERE ConsecutivoID = Aux_Contador AND  NumTransaccion = Aud_NumTransaccion;


		IF(Var_TipoReinversion = 'CI' AND Var_ReinversionAutomatica = 'S' AND Var_OpcionAportID != 3)THEN
			DELETE FROM TMPAPORTACIONESPAG
				WHERE AportacionID = Var_AportacionID
				AND NumTransaccion = Aud_NumTransaccion;
		END IF;

		SELECT Estatus
			INTO  Var_EstatusAmort
			FROM AMORTIZAAPORT
			WHERE AportacionID = Var_AportacionID AND FechaPago  BETWEEN Par_FechaInicio AND Par_FechaFin;
		-- SET DESCARTAN LAS AMORTIZACIONES CANCELADAS
		IF(Var_EstatusAmort = 'C') THEN
				DELETE FROM TMPAPORTACIONESPAG
					WHERE AportacionID = Var_AportacionID
					AND NumTransaccion = Aud_NumTransaccion;
		END IF;

		SET Var_MaxAmort := (SELECT MAX(AmortizacionID)  FROM AMORTIZAAPORT WHERE AportacionID = Var_AportacionID);

		UPDATE TMPAPORTACIONESPAG
			SET NumMaxAmort = Var_MaxAmort
			WHERE AportacionID = Var_AportacionID
			AND NumTransaccion = Aud_NumTransaccion;

		SET Var_PagoIntCapitaliza = (SELECT PagoIntCapitaliza
										FROM TMPAPORTACIONESPAG
										WHERE  AportacionID = Var_AportacionID
										AND NumTransaccion = Aud_NumTransaccion);

		-- SE DESCARTAN LAS AMORTIZACIONES INTERMEDIAS Y QUE CAPITALIZEN INTERES.
		IF(Var_AmortizacionID != Var_MaxAmort  AND Var_PagoIntCapitaliza = 'S') THEN
				DELETE FROM TMPAPORTACIONESPAG
					WHERE AportacionID = Var_AportacionID
					AND NumTransaccion = Aud_NumTransaccion;
		END IF;


		SELECT COUNT(AportacionID)  INTO Var_NumAport
				FROM TMPAPORTACIONESPAG
				WHERE CuentaAhoID = Var_CuentaAhoID
				AND NumTransaccion = Aud_NumTransaccion;

		UPDATE APORTDISPERSIONESREP
			SET NumAportaciones =  Var_NumAport
		WHERE  CuentaAhoID =  Var_CuentaAhoID
			AND NumTransaccion = Aud_NumTransaccion;

		SET Aux_Contador := Aux_Contador +1;

	END WHILE;


	SELECT
		CuentaAhoID,			ClienteID,					NombreAportante,		PromotorID,									NombrePromotor,
		FechaCorte,				NumAportaciones,			Capital,				Interes	,									InteresRetener,
		Total,					DesEstatus,					IFNULL(NombreInstitucion,Cadena_Vacia) as NombreInstitucion,		TipoCuentaSpeiDes AS TipoCuentaSpei,		Clabe,
		Beneficiario,
		IFNULL(CantidadPagada,Entero_Cero) AS CantidadPagada,
		IFNULL(CantidadenDispersion,Entero_Cero) AS CantidadenDispersion,
		IFNULL(CantidadPendiente,Entero_Cero) AS CantidadPendiente,  NumTransaccion
	FROM APORTDISPERSIONESREP
	WHERE NumTransaccion = Aud_NumTransaccion ORDER BY CuentaAhoID DESC ;

	DELETE FROM APORTDISPERSIONESREP WHERE NumTransaccion = Aud_NumTransaccion;
	DELETE FROM TMPAPORTACIONESPAG WHERE NumTransaccion = Aud_NumTransaccion;

END TerminaStore$$

