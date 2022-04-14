-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTDISPERSIONESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTDISPERSIONESLIS`;
DELIMITER $$

CREATE PROCEDURE `APORTDISPERSIONESLIS`(
/* SP DE BAJA DE DISPERSIONES EN APORTACIONES */
	Par_AportacionID			INT(11),		-- ID de Aportación.
	Par_AmortizacionID			INT(11),		-- Id de la Amortizacion.
	Par_ClienteID				INT(11),		-- Cliente ID.
	Par_NombreCompleto			VARCHAR(50),	-- Nombre Completo del Cliente.
	Par_TipoLista				INT(11),		-- Número de Lista.

	/* Parametros de Auditoria */
	Par_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),

	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE	Var_Control			CHAR(15);
DECLARE	Var_FechaSistema	CHAR(15);
DECLARE	Var_Sentencia		VARCHAR(1500);
DECLARE Var_MontoTotal		DECIMAL(18,2);
DECLARE	Var_TotalBenef		INT(11);

-- Declaracion de Constantes
DECLARE	Cadena_Vacia	VARCHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT(11);
DECLARE	Decimal_Cero	DECIMAL(12,2);
DECLARE	Cons_SI			CHAR(1);
DECLARE	Cons_NO			CHAR(1);
DECLARE	EstatusDisp		CHAR(1);
DECLARE	EstatusActiva	CHAR(1);
DECLARE	CuentaExterna	CHAR(1);
DECLARE	EstatusInact	CHAR(1);
DECLARE	ListaPrincipal	INT(11);
DECLARE	ListaBenefAport	INT(11);
DECLARE	ListaBenefCD	INT(11);
DECLARE	ListaAyuda		INT(11);
DECLARE Aux_i			INT(11);
DECLARE Var_Estatus	 CHAR(1);
DECLARE Var_CtaTrans	INT(11);
DECLARE Var_NumBeneficiarios INT(11);
DECLARE Var_ClienteID 	BIGINT(12);
DECLARE Var_AmortizacionID INT(11);
DECLARE Var_AportacionID   INT(11);
DECLARE Var_MontoDispersion DECIMAL(18,2);
DECLARE Var_MontoPendiente DECIMAL(18,2);
-- Asignacion de Constantes
SET Cadena_Vacia		:= '';				-- Cadena vacia.
SET Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia.
SET Entero_Cero			:= 0;				-- Entero Cero.
SET Decimal_Cero		:= 0.00;			-- Decimal Cero.
SET	Cons_SI				:= 'S';				-- Constante Si.
SET	Cons_NO				:= 'N'; 			-- Constante No.
SET	EstatusDisp			:= 'D'; 			-- Estatus Procesada de Dispersión (Dispersada).
SET	EstatusActiva		:= 'A'; 			-- Estatus Activa.
SET	CuentaExterna		:= 'E'; 			-- Estatus Procesada de Dispersión (Dispersada).
SET	EstatusInact		:= 'I'; 			-- Estatus Inactivo (Clientes).
SET ListaPrincipal		:= 01;				-- Lista Principal.
SET ListaBenefAport		:= 02;				-- Lista de Beneficiarios de Aportaciones.
SET ListaBenefCD		:= 03;				-- Lista de Beneficiarios Cuentas Destino.
SET ListaAyuda			:= 19;				-- Lista de Clientes con Aportaciones Pend. por Disp.
SET Aud_FechaActual 	:= NOW();

IF(Par_TipoLista=ListaPrincipal)THEN
	DELETE FROM TMPAPORTDISPERSIONES
	WHERE NumTransaccion = Aud_NumTransaccion;
 /* AGRUPAR LAS DISPERSIONES POR CUENTA */
	SET Var_Sentencia := CONCAT(
		'INSERT INTO TMPAPORTDISPERSIONES ( ',
			'AportacionID,		AmortizacionID,		ClienteID,		NombreCompleto,			Capital, ',
			'Interes,			InteresRetener,		Total,			NumTransaccion,			Estatus, ',
			'CuentaAhoID,		CuentaTranID,		MontoPendiente,	MontoDispersion,		TieneBen) ',
		'SELECT ',
			' MAX(AD.AportacionID),		MAX(AD.AmortizacionID),	MAX(AD.ClienteID),	MAX(UPPER(C.NombreCompleto)), SUM(AD.Capital), ',
			' SUM(AD.Interes),			SUM(AD.InteresRetener),	SUM(AD.Total),		',Aud_NumTransaccion,',	MAX(AD.Estatus), ',
			' MAX(AD.CuentaAhoID ),		MAX(IFNULL(AD.CuentaTranID,0)),	SUM(AD.MontoPendiente),	0 ,	"T"',
		' FROM APORTDISPERSIONES AD ',
			' INNER JOIN CLIENTES C ON AD.ClienteID = C.ClienteID ');

	IF(IFNULL(Par_ClienteID, Entero_Cero)!=Entero_Cero)THEN
		
 SET Var_Sentencia := CONCAT(Var_Sentencia, ' WHERE AD.ClienteID = ',Par_ClienteID,' GROUP BY AD.CuentaAhoID ');
	ELSE 
		SET Var_Sentencia := CONCAT(Var_Sentencia, ' GROUP BY AD.CuentaAhoID ');
	END IF;

	 SET Var_Sentencia := CONCAT(Var_Sentencia, ' UNION ');
	 SET Var_Sentencia := CONCAT(Var_Sentencia, ' SELECT ',
			 ' AB.AportacionID,		AB.AmortizacionID,	 	AP.ClienteID,			CT.NombreCompleto,							0,
				0,							0,				 0,'			,Aud_NumTransaccion, ', "B", 
				AP.CuentaAhoID, IFNULL(AB.CuentaTranID,0), 0 , AB.MontoDispersion,	"B"',
			' FROM APORTBENEFICIARIOS AB  
				INNER JOIN APORTDISPERSIONES AP ON AB.AportacionID = AP.AportacionID AND AB.AmortizacionID = AP.AmortizacionID
				INNER JOIN CLIENTES CT	ON AP.ClienteID = CT.ClienteID ');
	
		IF(IFNULL(Par_ClienteID, Entero_Cero)!=Entero_Cero)THEN
			
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' WHERE AP.ClienteID = ',Par_ClienteID,' AND AB.CuentaTranID != IFNULL(AP.CuentaTranID,0) ');
		ELSE 
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' WHERE AB.CuentaTranID != IFNULL(AP.CuentaTranID,0) ');
		END IF;

	SET Var_Sentencia := CONCAT(Var_Sentencia, '; ');
	SET @Sentencia := (Var_Sentencia);
	PREPARE APORTDISPERSGRID FROM @Sentencia;
	EXECUTE APORTDISPERSGRID;
	DEALLOCATE PREPARE APORTDISPERSGRID;

	UPDATE TMPAPORTDISPERSIONES T
			INNER JOIN APORTDISPERSIONES CT ON T.ClienteID = CT.ClienteID AND  T.CuentaAhoID = CT.CuentaAhoID
		SET T.AmortizacionID = CT.AmortizacionID
		WHERE T.NumTransaccion = Aud_NumTransaccion
			AND T.AportacionID = CT.AportacionID;

	UPDATE TMPAPORTDISPERSIONES Tmp, APORTBENEFICIARIOS Apo 
	SET
		Tmp.MontoDispersion = Apo.MontoDispersion
    WHERE Tmp.AportacionID = Apo.AportacionID 
      AND Tmp.AmortizacionID = Apo.AmortizacionID
      AND Tmp.CuentaTranID = Apo.CuentaTranID
	  AND Tmp.NumTransaccion = Aud_NumTransaccion;

	# ACTUALIZA SI LA DISPESIÓN CUENTA CON BENEFICIARIOS CAPTURAOS.
	UPDATE TMPAPORTDISPERSIONES T
		INNER JOIN APORTBENEFICIARIOS AB ON T.AportacionID = AB.AportacionID AND T.AmortizacionID = AB.AmortizacionID 
	SET
		T.TotalBenef = 1
	WHERE T.NumTransaccion = Aud_NumTransaccion;

-- SI ES LA PRIMERA VEZ QUE LE DA IMPORTAR 

			# ACTUALIZACIÓN DE LOS DATOS DE LA CUENTA DESTINO EXTERNA PRINCIPAL.

			UPDATE TMPAPORTDISPERSIONES T
				INNER JOIN CUENTASTRANSFER CT ON T.ClienteID = CT.ClienteID AND CT.TipoCuenta = CuentaExterna AND CT.Estatus = EstatusActiva  AND CT.EsPrincipal = Cons_SI
				LEFT OUTER JOIN TIPOSCUENTASPEI TS ON CT.TipoCuentaSpei = TS.TipoCuentaID
			SET
				T.CuentaTranID = CT.CuentaTranID,
				T.InstitucionID = CT.InstitucionID,
				T.TipoCuentaSpei = CT.TipoCuentaSpei,
				T.TipoCuentaDesc = UPPER(TS.Descripcion),
				T.Clabe = CT.Clabe,
				T.Beneficiario = UPPER(CT.Beneficiario),
				T.EsPrincipal = CT.EsPrincipal
			WHERE T.NumTransaccion = Aud_NumTransaccion
				AND T.TotalBenef = Entero_Cero
				AND T.CuentaTranID = Entero_Cero
				AND T.Estatus in ('S','P');
		
	        # ACTUALIZACIÓN DE LOS DATOS DE LA CUENTA DESTINO EXTERNA PRINCIPAL.
			UPDATE TMPAPORTDISPERSIONES T
				INNER JOIN CUENTASTRANSFER CT ON T.ClienteID = CT.ClienteID AND CT.TipoCuenta = CuentaExterna AND CT.Estatus = EstatusActiva  AND CT.EsPrincipal = Cons_SI
				LEFT OUTER JOIN TIPOSCUENTASPEI TS ON CT.TipoCuentaSpei = TS.TipoCuentaID
			SET
				T.CuentaTranID = CT.CuentaTranID,
				T.InstitucionID = CT.InstitucionID,
				T.TipoCuentaSpei = CT.TipoCuentaSpei,
				T.TipoCuentaDesc = UPPER(TS.Descripcion),
				T.Clabe = CT.Clabe,
				T.Beneficiario = UPPER(CT.Beneficiario),
				T.EsPrincipal = CT.EsPrincipal
			WHERE T.NumTransaccion = Aud_NumTransaccion
				AND T.TotalBenef = Entero_Cero
				AND T.CuentaTranID = Entero_Cero
				AND T.MontoPendiente = Decimal_Cero
				AND T.Estatus IN ('S','P');
			
			UPDATE TMPAPORTDISPERSIONES T
				INNER JOIN CUENTASTRANSFER CT ON T.ClienteID = CT.ClienteID AND CT.TipoCuenta = CuentaExterna AND CT.Estatus = EstatusActiva  AND CT.EsPrincipal = Cons_SI
				LEFT OUTER JOIN TIPOSCUENTASPEI TS ON CT.TipoCuentaSpei = TS.TipoCuentaID
			SET
				T.CuentaTranID = CT.CuentaTranID,
				T.InstitucionID = CT.InstitucionID,
				T.TipoCuentaSpei = CT.TipoCuentaSpei,
				T.TipoCuentaDesc = UPPER(TS.Descripcion),
				T.Clabe = CT.Clabe,
				T.Beneficiario = UPPER(CT.Beneficiario),
				T.EsPrincipal = CT.EsPrincipal
			WHERE T.NumTransaccion = Aud_NumTransaccion
				AND T.TotalBenef = Entero_Cero
				AND T.CuentaTranID = Entero_Cero
				AND T.Estatus in ('S','P');	
			
-- SI CUENTA CON BENEFICIARIOS CAPTURADOS (SI YA LE DIO GUARDAR Y SE GUARDO ALMENOS UN BENEFICIARIO) 
			

			# ACTUALIZACIÓN DE LOS DATOS DEL BENEFICIARIO DE CUENTA PRINCIPAL.
			UPDATE TMPAPORTDISPERSIONES T
				INNER JOIN APORTBENEFICIARIOS AB ON T.AportacionID = AB.AportacionID AND T.AmortizacionID = AB.AmortizacionID AND T.CuentaTranID = AB.CuentaTranID 
				LEFT OUTER JOIN TIPOSCUENTASPEI TS ON AB.TipoCuentaSpei = TS.TipoCuentaID
			SET
				T.CuentaTranID = AB.CuentaTranID,
				T.InstitucionID = AB.InstitucionID,
				T.TipoCuentaSpei = AB.TipoCuentaSpei,
				T.TipoCuentaDesc = UPPER(TS.Descripcion),
				T.Clabe = AB.Clabe,
				T.Beneficiario = UPPER(AB.Beneficiario),
				T.EsPrincipal = AB.EsPrincipal
			WHERE T.NumTransaccion = Aud_NumTransaccion
				AND T.TotalBenef > Entero_Cero
				AND T.Estatus = 'B';
		      
			# ACTUALIZACIÓN DE LOS DATOS DEL BENEFICIARIO DE CUENTA PRINCIPAL.
			UPDATE TMPAPORTDISPERSIONES T
				INNER JOIN APORTBENEFICIARIOS AB ON T.AportacionID = AB.AportacionID AND T.AmortizacionID = AB.AmortizacionID AND T.CuentaTranID = AB.CuentaTranID 
				LEFT OUTER JOIN TIPOSCUENTASPEI TS ON AB.TipoCuentaSpei = TS.TipoCuentaID
			SET
				T.CuentaTranID = AB.CuentaTranID,
				T.InstitucionID = AB.InstitucionID,
				T.TipoCuentaSpei = AB.TipoCuentaSpei,
				T.TipoCuentaDesc = UPPER(TS.Descripcion),
				T.Clabe = AB.Clabe,
				T.Beneficiario = UPPER(AB.Beneficiario),
				T.EsPrincipal = AB.EsPrincipal
			WHERE T.NumTransaccion = Aud_NumTransaccion
				AND T.TotalBenef > Entero_Cero;
			                
			UPDATE TMPAPORTDISPERSIONES T
				INNER JOIN APORTBENEFICIARIOS AB ON T.AportacionID = AB.AportacionID AND T.AmortizacionID = AB.AmortizacionID AND T.CuentaTranID = AB.CuentaTranID 
				LEFT OUTER JOIN TIPOSCUENTASPEI TS ON AB.TipoCuentaSpei = TS.TipoCuentaID
			SET
				T.CuentaTranID = AB.CuentaTranID,
				T.InstitucionID = AB.InstitucionID,
				T.TipoCuentaSpei = AB.TipoCuentaSpei,
				T.TipoCuentaDesc = UPPER(TS.Descripcion),
				T.Clabe = AB.Clabe,
				T.Beneficiario = UPPER(AB.Beneficiario),
				T.EsPrincipal = AB.EsPrincipal
			WHERE T.NumTransaccion = Aud_NumTransaccion
				AND T.CuentaTranID > Entero_Cero
				AND T.TotalBenef = Entero_Cero;

            UPDATE TMPAPORTDISPERSIONES T
				INNER JOIN CUENTASTRANSFER CT ON T.ClienteID = CT.ClienteID AND CT.TipoCuenta = CuentaExterna AND CT.Estatus = EstatusActiva
				LEFT OUTER JOIN TIPOSCUENTASPEI TS ON CT.TipoCuentaSpei = TS.TipoCuentaID
			SET
				T.CuentaTranID = CT.CuentaTranID,
				T.InstitucionID = CT.InstitucionID,
				T.TipoCuentaSpei = CT.TipoCuentaSpei,
				T.TipoCuentaDesc = UPPER(TS.Descripcion),
				T.Clabe = CT.Clabe,
				T.Beneficiario = UPPER(CT.Beneficiario),
				T.EsPrincipal = CT.EsPrincipal
			WHERE T.NumTransaccion = Aud_NumTransaccion
				AND T.TotalBenef = Entero_Cero
                AND IFNULL(T.InstitucionID,Entero_Cero) = Entero_Cero
				AND T.CuentaTranID > Entero_Cero
				AND T.Estatus in ('S','P');	

	# ACTUALIZA SI LA DISPESIÓN CUENTA CON BENEFICIARIOS CAPTURAOS.
	UPDATE TMPAPORTDISPERSIONES T
		INNER JOIN APORTBENEFICIARIOS AB ON T.AportacionID = AB.AportacionID AND T.AmortizacionID = AB.AmortizacionID 
	SET
		T.TotalBenef = 1
	WHERE T.NumTransaccion = Aud_NumTransaccion;
 
 
	# ACTUALIZA EL NOMBRE DE LA INSTITUCIÓN BANCARIA.
	UPDATE TMPAPORTDISPERSIONES T
		INNER JOIN INSTITUCIONES I ON T.InstitucionID = I.ClaveParticipaSpei
	SET
		T.Nombre = UPPER(I.NombreCorto)
	WHERE T.NumTransaccion = Aud_NumTransaccion;


	UPDATE TMPAPORTDISPERSIONES T
	SET
		T.TotalBenP = IFNULL(T.CuentaTranID, Entero_Cero)
	WHERE T.NumTransaccion = Aud_NumTransaccion;
    
    
	UPDATE TMPAPORTDISPERSIONES T
	SET
		  T.Estatus = 'S'
	WHERE T.Estatus = 'B' AND T.NumTransaccion = Aud_NumTransaccion;
 
 	
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
    
    
    INSERT INTO TMP_APORTDISPERSIONESLIS( CuentaAhoID, MontoPendiente)
    SELECT CuentaAhoID, SUM(MontoDispersion)
	FROM TMPAPORTDISPERSIONES 
	WHERE CuentaAhoID IN (SELECT CuentaAhoID FROM TMPAPORTDISPERSIONES WHERE NumTransaccion = Aud_NumTransaccion)
    AND NumTransaccion = Aud_NumTransaccion
	GROUP BY CuentaAhoID,NumTransaccion;
    
	INSERT INTO TMP_APORTDISPERSIONESLIS2( CuentaAhoID, Total, MontoTotalPendiente)
	SELECT CuentaAhoID, MontoPendiente, MontoPendiente
	FROM APORTCTADISPERSIONES;
	
    
    UPDATE TMP_APORTDISPERSIONESLIS2 Tmp2, TMP_APORTDISPERSIONESLIS Tmp SET 
		Tmp2.Total =  CASE WHEN (Tmp2.Total - Tmp.MontoPendiente ) < 0 THEN 0 ELSE (Tmp2.Total - Tmp.MontoPendiente ) END
	WHERE Tmp2.CuentaAhoID = Tmp.CuentaAhoID;
	

	
	UPDATE TMPAPORTDISPERSIONES Tmp, TMP_APORTDISPERSIONESLIS2 Apo    -- CUANDO SE FINALIZA
		SET Tmp.MontoPendiente = Apo.Total,
			Tmp.MontoTotalPendiente = Apo.MontoTotalPendiente,
			Tmp.MontoDispersion = Apo.Total
    WHERE Tmp.CuentaAhoID = Apo.CuentaAhoID
      AND Apo.Total > 0
      AND Tmp.TieneBen = 'T'
      AND Tmp.TotalBenef = Entero_Cero
      AND Tmp.NumTransaccion = Aud_NumTransaccion ;
	
    UPDATE TMPAPORTDISPERSIONES Tmp, TMP_APORTDISPERSIONESLIS2 Apo  -- RECIEN SE IMPORTAN 
		SET Tmp.MontoPendiente = Apo.Total,
			Tmp.MontoTotalPendiente = Apo.MontoTotalPendiente 
    WHERE Tmp.CuentaAhoID = Apo.CuentaAhoID
      AND Apo.Total > 0
      AND Tmp.TieneBen = 'T'
      AND Tmp.TotalBenef > Entero_Cero
      AND Tmp.NumTransaccion = Aud_NumTransaccion ;

  UPDATE TMPAPORTDISPERSIONES Tmp, TMP_APORTDISPERSIONESLIS2 Apo    -- CUANDO SE GRABAN LOS BENEFICIARIOS
		SET Tmp.MontoPendiente = Apo.Total,
			Tmp.MontoTotalPendiente = Apo.MontoTotalPendiente 
    WHERE Tmp.CuentaAhoID = Apo.CuentaAhoID
      AND Apo.Total = 0
      AND Tmp.TieneBen = 'T'
      AND Tmp.TotalBenef > Entero_Cero
      AND Tmp.NumTransaccion = Aud_NumTransaccion ;


	SELECT
		CuentaAhoID AS CuentaAhoID,			AportacionID AS AportacionID,	AmortizacionID AS AmortizacionID,		ClienteID AS ClienteID,					CONCAT(ClienteID,'-',NombreCompleto) AS NombreCompleto,	
		Capital AS Capital,					Interes AS Interes,				InteresRetener AS InteresRetener,		Total AS Total,							CuentaTranID AS CuentaTranID,	
		InstitucionID AS InstitucionID,		Nombre AS Nombre,				TipoCuentaSpei AS TipoCuentaSpei,		TipoCuentaDesc AS TipoCuentaDesc,		Clabe AS Clabe,			
		Beneficiario AS Beneficiario,		EsPrincipal AS EsPrincipal,		MontoDispersion AS MontoDispersion,		Estatus AS Estatus,						TotalBenP AS TotalBenP,		
		IFNULL(TotalBenNP,Entero_Cero) AS TotalBenNP,	MontoPendiente,		MontoTotalPendiente
	FROM TMPAPORTDISPERSIONES
		WHERE NumTransaccion = Aud_NumTransaccion 
			ORDER BY CuentaAhoID DESC ;
 
 	 DELETE FROM TMPAPORTDISPERSIONES
 	 WHERE NumTransaccion = Aud_NumTransaccion;

END IF;


IF(Par_TipoLista=ListaBenefCD)THEN
	SET Var_MontoTotal := (SELECT Total FROM APORTDISPERSIONES WHERE AportacionID = Par_AportacionID AND AmortizacionID =Par_AmortizacionID);
	SET Var_MontoTotal := IFNULL(Var_MontoTotal, Entero_Cero);

	SET Var_TotalBenef := (SELECT COUNT(*) FROM APORTBENEFICIARIOS
							WHERE AportacionID = Par_AportacionID AND AmortizacionID =Par_AmortizacionID AND EsPrincipal = Cons_NO);

	IF(IFNULL(Var_TotalBenef,Entero_Cero) > Entero_Cero)THEN
		INSERT INTO TMPAPORTDISPERSIONES (
			CuentaTranID,		InstitucionID,		Nombre,						TipoCuentaSpei,TipoCuentaDesc,
			Clabe,				Beneficiario,		EsPrincipal,				Total,
			AportacionID,		AmortizacionID,		MontoDispersion,			NumTransaccion,TieneBen
			)
		SELECT
			AB.CuentaTranID,	AB.InstitucionID,	UPPER(I.Nombre)AS Nombre,	TS.TipoCuentaID,	TS.Descripcion,
			AB.Clabe,			AB.Beneficiario,	AB.EsPrincipal,				Var_MontoTotal AS Total,
			AB.AportacionID,	AB.AmortizacionID,	AB.MontoDispersion,	Aud_NumTransaccion,Cons_SI
		FROM APORTBENEFICIARIOS AB
			INNER JOIN TIPOSCUENTASPEI TS ON AB.TipoCuentaSpei = TS.TipoCuentaID
			INNER JOIN INSTITUCIONES I ON AB.InstitucionID = I.ClaveParticipaSpei
		WHERE AB.AportacionID = Par_AportacionID
			AND AB.AmortizacionID = Par_AmortizacionID
			AND AB.EsPrincipal = Cons_NO;
	ELSE
		INSERT INTO TMPAPORTDISPERSIONES (
			CuentaTranID,		InstitucionID,		Nombre,						TipoCuentaSpei,TipoCuentaDesc,
			Clabe,				Beneficiario,		EsPrincipal,				Total,
			AportacionID,		AmortizacionID,		MontoDispersion,			NumTransaccion,TieneBen
			)
		SELECT
			CT.CuentaTranID,	CT.InstitucionID,	UPPER(I.Nombre)AS Nombre,	TS.TipoCuentaID,	TS.Descripcion,
			CT.Clabe,			CT.Beneficiario,	CT.EsPrincipal,				Var_MontoTotal AS Total,
			Par_AportacionID AS AportacionID,	Par_AmortizacionID AS AmortizacionID,
			Decimal_Cero AS MontoDispersion,Aud_NumTransaccion,Cons_SI
		FROM CUENTASTRANSFER CT
			INNER JOIN TIPOSCUENTASPEI TS ON CT.TipoCuentaSpei = TS.TipoCuentaID
			INNER JOIN INSTITUCIONES I ON CT.InstitucionID = I.ClaveParticipaSpei
		WHERE CT.ClienteID = Par_ClienteID
			AND CT.TipoCuenta = CuentaExterna
			AND CT.Estatus = EstatusActiva
			AND CT.EsPrincipal = Cons_NO;
	END IF;

	IF NOT EXISTS(SELECT * FROM TMPAPORTDISPERSIONES WHERE NumTransaccion = Aud_NumTransaccion)THEN
		INSERT INTO TMPAPORTDISPERSIONES (
			AportacionID,		AmortizacionID,		NumTransaccion,		TieneBen)
		VALUES (
			Par_AportacionID,	Par_AmortizacionID,	Aud_NumTransaccion,	Cons_NO);

	END IF;
	SELECT
		CuentaTranID,	InstitucionID,	Nombre,			TipoCuentaSpei AS TipoCuentaID,TipoCuentaDesc AS Descripcion,
		Clabe,			Beneficiario,	EsPrincipal,	Total,
		AportacionID,	AmortizacionID,	MontoDispersion,NumTransaccion,TieneBen
	FROM TMPAPORTDISPERSIONES
		WHERE NumTransaccion = Aud_NumTransaccion;

END IF;

IF(Par_TipoLista=ListaAyuda)THEN
	SELECT DISTINCT
		C.ClienteID,	C.NombreCompleto
	FROM APORTDISPERSIONES AD
		INNER JOIN CLIENTES C ON AD.ClienteID = C.ClienteID
	WHERE C.NombreCompleto LIKE CONCAT("%", Par_NombreCompleto, "%")
		AND C.Estatus != EstatusInact
	ORDER BY C.NombreCompleto
		LIMIT 0,15;
END IF;

END TerminaStore$$	