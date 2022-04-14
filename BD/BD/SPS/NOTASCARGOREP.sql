-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- NOTASCARGOREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `NOTASCARGOREP`;
DELIMITER $$


CREATE PROCEDURE `NOTASCARGOREP`(

    Par_FechaInicial        DATE,
    Par_FechaFinal          DATE,
    Par_ProductoCreditoID   INT(11),
    Par_InstitucionID 		INT(11),
	Par_ConvenioNominaID	BIGINT UNSIGNED,

    Par_EmpresaID		    INT(11),
	Aud_Usuario        	    INT(11),
	Aud_FechaActual    	    DATE,
	Aud_DireccionIP    	    VARCHAR(15),
	Aud_ProgramaID     	    VARCHAR(50),
	Aud_Sucursal       	    INT(11),
	Aud_NumTransaccion      BIGINT(20)
)
TerminaStore:BEGIN

	-- Declaracion Variables
	DECLARE Var_Sentencia   VARCHAR(10000);
	DECLARE Var_FechaSis	DATE;

	-- Declaracion Constantes
    DECLARE Cadena_Vacia    VARCHAR(20);
	DECLARE Entero_Cero     INT(11);
	DECLARE Cadena_Cero     CHAR(1);
	DECLARE	Decimal_Cero	DECIMAL(12,2);
	DECLARE Fecha_Vacia		DATE;
	DECLARE Con_NO			CHAR(1);
    DECLARE EsNomina        CHAR(1);
    DECLARE Cons_Si         CHAR(1);
	DECLARE Cons_NoAp		VARCHAR(10);
	DECLARE Var_StrVacio	CHAR(1);

	DECLARE Var_EstVigente	CHAR(1);
	DECLARE Var_EstAtraso	CHAR(1);
	DECLARE Var_EstVencido	CHAR(1);
	DECLARE Var_EstSuspend	CHAR(1);

	DECLARE Var_TextVigente	VARCHAR(15);
	DECLARE Var_TextAtraso	VARCHAR(15);
	DECLARE Var_TextVencida	VARCHAR(15);
	DECLARE Var_TextPagada	VARCHAR(15);

	DECLARE PagoUnico		CHAR(1);

	-- Asignacion Constantes
	SET	Entero_Cero		    := 0;
	SET Cadena_Vacia        := 'NULL';
	SET Cadena_Cero			:='0';
    SET Decimal_Cero		:= 0.0;
    SET Fecha_Vacia			:= '1900-01-01';
	SET Con_NO				:='N';
    SET Cons_Si          	:='S';
    SET Cons_NoAp			:='NO APLICA';
    SET Var_StrVacio		:= '';

	SET Var_EstVigente		:= 'V';
	SET Var_EstAtraso		:= 'A';
	SET Var_EstVencido		:= 'B';
	SET Var_EstSuspend		:= 'S';

	SET Var_TextVigente		:= 'VIGENTE';
	SET Var_TextAtraso		:= 'ATRASADA';
	SET Var_TextVencida		:= 'VENCIDA';
	SET Var_TextPagada		:= 'PAGADA';

	-- Asignacion valores por defecto
	SET Par_ProductoCreditoID		:=IFNULL(Par_ProductoCreditoID, Entero_Cero);

    SET EsNomina		:= (SELECT ProductoNomina
								FROM PRODUCTOSCREDITO
                                WHERE ProducCreditoID = Par_ProductoCreditoID);
	SET EsNomina		:= IFNULL(EsNomina, Con_NO);

    DROP TABLE IF EXISTS TMPNOTASCARGOREP;
	CREATE TEMPORARY TABLE TMPNOTASCARGOREP(
		`ProductoCredito` 	    VARCHAR(100),
		`InstitucionNomina` 	VARCHAR(200),
		`ConvenioNomina` 		VARCHAR(150),
		`ClienteID` 			INT(11),
		`NombreCliente` 		VARCHAR(200),
        `CreditoID` 			BIGINT(12),
		`AmortizacionID` 		BIGINT(4),
		`Referencia` 			BIGINT(20),
		`FechaRegistro` 		DATE,
		`TipoNotaCargo` 		VARCHAR(50),

        `Monto` 				DECIMAL(14,2),
        `IVA` 					DECIMAL(14,2),
        `Motivo`		 		VARCHAR(50),
        `AmPagoNoReconoID` 		INT(11),
		`ReferenciaNoRecono` 	BIGINT(20),
		`Capital`	 			DECIMAL(14,2),
        `Interes`	 			DECIMAL(14,2),
		`IVAInteres`	 		DECIMAL(14,2),
        `Moratorio`	 			DECIMAL(14,2),
        `IVAMoratorio`	 		DECIMAL(14,2),

		`OtrasComisiones`	 	DECIMAL(14,2),
        `IVAOtrasComisiones`	DECIMAL(14,2),
		`TotalPago`	 			DECIMAL(14,2),
        `Estatus`	 			VARCHAR(15),
        `DiasPasoAtraso`		INT(11),
        `EstCredito`			CHAR(1)
		);

	CREATE INDEX INDEX_TMPNOTASCARGOREP_01 ON TMPNOTASCARGOREP(CreditoID, AmPagoNoReconoID);

	SET Var_Sentencia :=   "INSERT INTO TMPNOTASCARGOREP (
									ProductoCredito,	InstitucionNomina,	ConvenioNomina,			ClienteID,					NombreCliente,
									CreditoID,			AmortizacionID,		Referencia,				FechaRegistro,				TipoNotaCargo,
									Monto,				IVA,				Motivo,					AmPagoNoReconoID,			ReferenciaNoRecono,
									Capital,			Interes,			IVAInteres,				Moratorio,					IVAMoratorio,
									OtrasComisiones,	IVAOtrasComisiones,	TotalPago,				Estatus,					DiasPasoAtraso,
									EstCredito	)";

    SET Var_Sentencia	:=CONCAT(Var_sentencia,' SELECT PRO.Descripcion AS ProductoCredito, ');

    IF(Par_ProductoCreditoID != Entero_Cero)THEN
			IF(EsNomina = Cons_Si)THEN
				SET Var_Sentencia :=	CONCAT(Var_Sentencia,' INSNOM.NombreInstit AS InstitucionNomina,  CONOM.Descripcion AS ConvenioNomina, ');
			ELSE
				SET Var_Sentencia :=    CONCAT(Var_Sentencia, Cadena_Vacia,' AS InstitucionNomina, ', Cadena_Vacia,' AS ConvenioNomina, ');
			END IF;
    ELSE
		    SET Var_Sentencia :=	CONCAT(Var_Sentencia,' IFNULL(INSNOM.NombreInstit, ', Cadena_Vacia,') AS InstitucionNomina,  IFNULL(CONOM.Descripcion, ', Cadena_Vacia,') AS ConvenioNomina, ');
	END IF;

    SET Var_Sentencia	:=CONCAT(Var_sentencia,' CLI.ClienteID, CLI.NombreCompleto AS NombreCliente,  CR.CreditoID,  NC.AmortizacionID,  NC.NumTransaccion,  NC.FechaRegistro,  TN.NombreCorto, ');
    SET Var_Sentencia	:=CONCAT(Var_sentencia,' NC.Monto,  NC.IVA,  NC.Motivo,  NC.AmortizacionPago,  NC.TranPagoCredito,  NC.Capital,  NC.Interes,  NC.IVAInteres,  NC.Moratorio, ');
    SET Var_Sentencia	:=CONCAT(Var_sentencia,' NC.IVAMoratorio,  NC.OtrasComisiones,  NC.IVAComisiones AS IVAOtrasComisiones,  NC.Monto,  "" AS Estatus, IFNULL(PRO.DiasPasoAtraso, 0) DiasPasoAtraso, CR.Estatus');
    SET Var_Sentencia	:=CONCAT(Var_sentencia,' FROM CREDITOS CR  INNER JOIN PRODUCTOSCREDITO PRO ON CR.ProductoCreditoID = PRO.ProducCreditoID ');
	SET Var_Sentencia	:=CONCAT(Var_sentencia,' INNER JOIN CLIENTES CLI ON CLI.ClienteID = CR.ClienteID ');

    IF(Par_ProductoCreditoID != Entero_Cero)THEN
		IF( EsNomina = Cons_Si) THEN
			IF(IFNULL(Par_InstitucionID,Entero_Cero) != Entero_Cero) THEN
				SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN NOMCONDICIONCRED NOM ON PRO.ProducCreditoID = NOM.ProducCreditoID AND CR.ConvenioNominaID = NOM.ConvenioNominaID  AND NOM.InstitNominaID = ',Par_InstitucionID);
			 ELSE
				SET Var_Sentencia	:=CONCAT(Var_sentencia,' INNER JOIN NOMCONDICIONCRED NOM ON PRO.ProducCreditoID = NOM.ProducCreditoID AND CR.ConvenioNominaID=NOM.ConvenioNominaID');
			END IF;

			IF(IFNULL(Par_ConvenioNominaID,Entero_Cero) != Entero_Cero) THEN
				SET Var_Sentencia	:=CONCAT(Var_sentencia,' INNER JOIN CONVENIOSNOMINA CONOM ON CONOM.ConvenioNominaID = ', Par_ConvenioNominaID);
			  ELSE
				SET Var_Sentencia	:=CONCAT(Var_sentencia,' INNER JOIN CONVENIOSNOMINA CONOM ON CONOM.ConvenioNominaID = NOM.ConvenioNominaID');
			END IF;

		    SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN INSTITNOMINA INSNOM ON INSNOM.InstitNominaID = CONOM.InstitNominaID ');
		 END IF;

      ELSE

         	SET Var_Sentencia	:=CONCAT(Var_sentencia,' LEFT JOIN NOMCONDICIONCRED NOM ON PRO.ProducCreditoID = NOM.ProducCreditoID AND CR.ConvenioNominaID=NOM.ConvenioNominaID');
			SET Var_Sentencia	:=CONCAT(Var_sentencia,' LEFT JOIN CONVENIOSNOMINA CONOM ON CONOM.ConvenioNominaID = NOM.ConvenioNominaID ');
			SET Var_Sentencia	:=CONCAT(Var_sentencia,' LEFT JOIN INSTITNOMINA INSNOM ON INSNOM.InstitNominaID = CONOM.InstitNominaID ');
	END IF;

    SET Var_Sentencia	:=CONCAT(Var_sentencia,' INNER JOIN NOTASCARGO NC ON NC.CreditoID = CR.CreditoID ');
	SET Var_Sentencia	:=CONCAT(Var_sentencia,' INNER JOIN AMORTICREDITO AM ON AM.AmortizacionID = NC.AmortizacionID ');
    SET Var_Sentencia	:=CONCAT(Var_sentencia,' INNER JOIN TIPOSNOTASCARGO TN ON TN.TipoNotaCargoID = NC.TipoNotaCargoID ');

    SET Var_Sentencia 	:=CONCAT(Var_Sentencia,' WHERE NC.FechaRegistro BETWEEN "', Par_FechaInicial ,'" AND "', Par_FechaFinal,'"');

    IF(Par_ProductoCreditoID != Entero_Cero)THEN
		   SET Var_Sentencia :=  CONCAT(Var_Sentencia,' AND CR.ProductoCreditoID =',CONVERT(Par_ProductoCreditoID,CHAR));
	END IF;

    SET Var_Sentencia	:=CONCAT(Var_sentencia,' GROUP BY ProductoCredito, InstitucionNomina, ConvenioNomina,  ');
    SET Var_Sentencia	:=CONCAT(Var_sentencia,' CLI.ClienteID, NombreCliente,  CR.CreditoID,  NC.AmortizacionID,  NC.NumTransaccion,  NC.FechaRegistro,  TN.NombreCorto, ');
    SET Var_Sentencia	:=CONCAT(Var_sentencia,' NC.Monto,  NC.IVA,  NC.Motivo,  NC.AmortizacionPago,  NC.TranPagoCredito,  NC.Capital,  NC.Interes,  NC.IVAInteres,  NC.Moratorio, ');
    SET Var_Sentencia	:=CONCAT(Var_sentencia,' NC.IVAMoratorio,  NC.OtrasComisiones,  IVAOtrasComisiones,  NC.Monto, PRO.DiasPasoAtraso ORDER BY NombreCliente; ');

	SET @Sentencia		= (Var_Sentencia);
	SET @FechaInicio	= Par_FechaInicial;
	SET @FechaFin		= Par_FechaFinal;

	PREPARE STNOTASCARGOREP FROM @Sentencia;
	EXECUTE STNOTASCARGOREP;

	DEALLOCATE PREPARE STNOTASCARGOREP;

	-- Temporal de paso para saldos y actualizacion final de estatus
	DROP TEMPORARY TABLE IF EXISTS TMPNOTAAMOREP;
	CREATE TEMPORARY TABLE TMPNOTAAMOREP (
		CreditoID		BIGINT(12),
		AmortizacionID	INT(11),
		FechaExigible	DATE,
		DiasPasoAtr		INT(11),
		EstCredito		CHAR(1),
		EstAmor			CHAR(1),
		FechaPasoAtras	DATE,
		NumAmorVenc		INT(11),
		Estatus			VARCHAR(15),
		SaldoNotas		DECIMAL(14,2)
	);

	-- Temporal para obtener el numero de amortizaciones vencidas por credito que sirve para calcular el paso a atraso
	DROP TEMPORARY TABLE IF EXISTS TMPAMORVENCNOTAS;
	CREATE TEMPORARY TABLE TMPAMORVENCNOTAS (
		CreditoID		BIGINT(12),
		NumAmor			INT(11)
	);

	CREATE INDEX INDEX_TMPNOTAAMOREP_01 ON TMPNOTAAMOREP(CreditoID, AmortizacionID);
	CREATE INDEX INDEX_TMPAMORVENCNOTAS_01 ON TMPAMORVENCNOTAS(CreditoID);

	INSERT INTO TMPNOTAAMOREP (	CreditoID,		AmortizacionID,		FechaExigible,		DiasPasoAtr,		EstCredito,
								EstAmor,		FechaPasoAtras,		NumAmorVenc,
								Estatus,
								SaldoNotas	)
					SELECT		AM.CreditoID,	AM.AmortizacionID,	AM.FechaExigible,	NC.DiasPasoAtraso,	NC.EstCredito,
								AM.Estatus,		Fecha_Vacia,		Entero_Cero,
								Var_StrVacio,
								ROUND(
									IFNULL(SUM(ROUND(AM.SaldoNotCargoRev, 2)), Entero_Cero) +
									IFNULL(SUM(ROUND(AM.SaldoNotCargoSinIVA, 2)), Entero_Cero) +
									IFNULL(SUM(ROUND(AM.SaldoNotCargoConIVA, 2)), Entero_Cero)
								, 2) SaldoNotas
						FROM	TMPNOTASCARGOREP NC
						INNER JOIN AMORTICREDITO AM ON NC.CreditoID = AM.CreditoID
													AND NC.AmPagoNoReconoID = AM.AmortizacionID
						GROUP BY AM.CreditoID, AM.AmortizacionID, AM.FechaExigible, NC.DiasPasoAtraso, NC.EstCredito, AM.Estatus;

	INSERT INTO TMPAMORVENCNOTAS (	CreditoID,		NumAmor	)
						SELECT		AM.CreditoID,	COUNT(AM.AmortizacionID)
							FROM	TMPNOTAAMOREP TMP
							INNER JOIN AMORTICREDITO AM ON AM.CreditoID = TMP.CreditoID AND AM.Estatus = Var_EstVencido
							GROUP BY AM.CreditoID;

	-- Se actualiza el numero de cuotas vencidas por credito en la temporal de saldos (nos servira para condiciones posteriores)
	UPDATE TMPNOTAAMOREP NC
		INNER JOIN TMPAMORVENCNOTAS AM ON NC.CreditoID = AM.CreditoID
	SET NC.NumAmorVenc = AM.NumAmor;

	-- Primero se marcan las amortizaciones sin saldo de notas como pagadas ya que a las demas se les tendra que calcular el estatus en las que deberian estar si tuvieran saldo de notas y el pago de credito no se hubiera dado
	UPDATE TMPNOTAAMOREP
	SET Estatus = Var_TextPagada
	WHERE SaldoNotas <= Entero_Cero;

	-- INICIO Bloque de reglas tomadas de los SPs GENERAINTERMORAPRO y CREPASOVENCIDOPRO del Cierre General
	SELECT		FechaSistema
		INTO	Var_FechaSis
		FROM	PARAMETROSSIS
		WHERE	EmpresaID = Par_EmpresaID;

	SET Var_FechaSis	:= IFNULL(Var_FechaSis, Fecha_Vacia);

	UPDATE TMPNOTAAMOREP
	SET FechaPasoAtras =	CASE WHEN FechaExigible < DATE_SUB(Var_FechaSis, INTERVAL (DiasPasoAtr + 15 ) DAY) THEN
								FechaExigible
							ELSE
								FUNCIONDIAHABIL(FechaExigible, DiasPasoAtr, Par_EmpresaID) END;

	UPDATE TMPNOTAAMOREP
	SET Estatus = Var_TextAtraso
	WHERE SaldoNotas		> Entero_Cero
	  AND FechaPasoAtras	< Var_FechaSis
	  AND EstAmor			= Var_EstVigente
	  AND ((EstCredito		= Var_EstVigente) OR (EstCredito = Var_EstSuspend AND NumAmorVenc = Entero_Cero));

	UPDATE TMPNOTAAMOREP
	SET Estatus = Var_TextVencida
	WHERE SaldoNotas		> Entero_Cero
	  AND FechaPasoAtras	< Var_FechaSis
	  AND EstAmor			= Var_EstVigente
	  AND ((EstCredito		= Var_EstVencido) OR (EstCredito = Var_EstSuspend AND NumAmorVenc > Entero_Cero));

	UPDATE TMPNOTAAMOREP
	SET Estatus = Var_TextVencida
	WHERE SaldoNotas		> Entero_Cero
	  AND NumAmorVenc		> Entero_Cero;

	UPDATE TMPNOTAAMOREP
	SET Estatus = Var_TextVigente
	WHERE Estatus = Var_StrVacio;

	-- Se actualiza finalmente el estatus en el que debería encontrarse la amortización en caso de no haberse hecho el pago no reconocido
	UPDATE TMPNOTASCARGOREP TMP
		INNER JOIN TMPNOTAAMOREP AM ON AM.CreditoID = TMP.CreditoID
									AND AM.AmortizacionID = TMP.AmPagoNoReconoID
	SET TMP.Estatus = AM.Estatus;

    SELECT 	ProductoCredito,	InstitucionNomina,	ConvenioNomina,			ClienteID,					NombreCliente,
			CreditoID,			AmortizacionID,		Referencia,				FechaRegistro,				TipoNotaCargo,
			Monto,				IVA,				Motivo,					AmPagoNoReconoID,			ReferenciaNoRecono,
			Capital,			Interes,			IVAInteres,				Moratorio,					IVAMoratorio,
			OtrasComisiones,	IVAOtrasComisiones,	TotalPago,				Estatus
    FROM TMPNOTASCARGOREP;

    DROP TABLE IF EXISTS TMPNOTASCARGOREP;
    DROP TEMPORARY TABLE IF EXISTS TMPNOTAAMOREP;

END TerminaStore$$