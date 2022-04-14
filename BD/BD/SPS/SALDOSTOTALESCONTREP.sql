-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SALDOSTOTALESCONTREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `SALDOSTOTALESCONTREP`;DELIMITER $$

CREATE PROCEDURE `SALDOSTOTALESCONTREP`(
	/*SP QUE GENERA EL REPORTE DE ANALITICO DE CARTERA AGROPECUARIA*/
	Par_TransaccionID	BIGINT(20),		# Numero de Transaccion
	Par_Fecha			DATE,			# Fecha corte
	Par_NumList			TINYINT UNSIGNED,
	/*Auditoria*/
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE Var_Sentencia 			TEXT(90000);
	DECLARE Var_ExisteCobraSeguro	INT(11);	-- Existen creditos que cobran seguros
	DECLARE Var_NatMovimiento		CHAR(1);
	DECLARE Var_PerFisica			CHAR(1);
	DECLARE FechaSist				date;

	-- Declaracion de Variables
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Entero_Cero				INT;
	DECLARE Fecha_Vacia				DATE;

	-- Asignacion de constantes
	SET Cadena_Vacia				:= '';
	SET Entero_Cero					:= 0;
	SET Fecha_Vacia					:= '1900-01-01';

	DELETE FROM TMPANALITICOCONT WHERE TransaccionID = Par_TransaccionID;
	SET @Var_Consecutivo := (SELECT MAX(Consecutivo)
								FROM TMPANALITICOCONT
									WHERE TransaccionID = Par_TransaccionID);
	SET @Var_Consecutivo := IFNULL(@Var_Consecutivo, Entero_Cero);
	set FechaSist := (Select FechaSistema from PARAMETROSSIS);
	if(Par_Fecha < FechaSist) then
		INSERT INTO TMPANALITICOCONT(
			CreditoFondeoID,		CreditoID,			CreditoIDCont,		AcreditadoIDFIRA,			CreditoIDFIRA,
			ClienteID,				CreditoIDSinFon,	CreditoIDPagoFira,	FechaOtorgamiento,			Estatus,
			SalCapVigente,			SalCapAtrasado,		SalIntProvision,	SalIntVencido,				SaldoMoraCarVen,
			SaldoCapVencido,		SaldoInterVenc,		SalComFaltaPago,	SalOtrasComisi,				Sucursal,
			TipoGarantiaFIRAID,		RamaFIRAID,			ActividadFIRAID,	CadenaProductivaID,			ProgEspecialFIRAID,
			TransaccionID,			Consecutivo,		DestinoCreID)
		  SELECT
			REL.CreditoFondeoID,		CRED.CreditoID,		CONT.CreditoID,		CRED.AcreditadoIDFIRA,		CRED.CreditoIDFIRA,
			CRED.ClienteID,				IF(CRED.TipoGarantiaFIRAID >0 &&

			CRED.TipoFondeo = 'P', CRED.CreditoID,0),		CONT.CreditoID,		CONT.FechaInicio,		IF(CONT.Estatus = 'V','VIGENTE',
																												IF(CONT.Estatus = 'K','CASTIGADO',
																													IF(CONT.Estatus = 'B','VENCIDO','INACTIVO'))) AS Estatus,
			SAL.SalCapVigente,			SAL.SalCapAtrasado,	SAL.SalIntProvision,SAL.SalIntVencido,			SAL.SaldoMoraCarVen,
			CONT.SaldoCapVencido,		CONT.SaldoInterVenc,SAL.SalComFaltaPago,SAL.SalOtrasComisi,			CONT.SucursalID,
			SOL.TipoGarantiaFIRAID,		CRED.RamaFIRAID,	CRED.ActividadFIRAID,	CRED.CadenaProductivaID,		CRED.ProgEspecialFIRAID,
			Par_TransaccionID,			@Var_Consecutivo:= @Var_Consecutivo+1, CONT.DestinoCreID
			FROM
			CREDITOSCONT AS CONT
			INNER JOIN CREDITOS AS CRED ON CONT.CreditoID = CRED.CreditoID
			LEFT JOIN RELCREDPASIVOAGRO AS REL ON CRED.CreditoID = REL.CreditoID
			INNER JOIN SALDOSCREDITOSCONT AS SAL ON CONT.CreditoID = SAL.CreditoID
			LEFT JOIN SOLICITUDCREDITO AS SOL ON CRED.SolicitudCreditoID = SOL.SolicitudCreditoID
			WHERE SAL.FechaCorte = Par_Fecha;
		ELSE
		INSERT INTO TMPANALITICOCONT(
			CreditoFondeoID,		CreditoID,			CreditoIDCont,		AcreditadoIDFIRA,			CreditoIDFIRA,
			ClienteID,				CreditoIDSinFon,	CreditoIDPagoFira,	FechaOtorgamiento,			Estatus,
			SalCapVigente,			SalCapAtrasado,		SalIntProvision,	SalIntVencido,				SaldoMoraCarVen,
			SaldoCapVencido,		SaldoInterVenc,		SalComFaltaPago,	SalOtrasComisi,				Sucursal,
			TipoGarantiaFIRAID,		RamaFIRAID,			ActividadFIRAID,	CadenaProductivaID,			ProgEspecialFIRAID,
			TransaccionID,			Consecutivo,		DestinoCreID)
		  SELECT
			REL.CreditoFondeoID,		CRED.CreditoID,		CONT.CreditoID,		CRED.AcreditadoIDFIRA,		CRED.CreditoIDFIRA,
			CRED.ClienteID,				IF(CRED.TipoGarantiaFIRAID >0 &&

			CRED.TipoFondeo = 'P', CRED.CreditoID,0),		CONT.CreditoID,		CONT.FechaInicio,		IF(CONT.Estatus = 'V','VIGENTE',
																												IF(CONT.Estatus = 'K','CASTIGADO',
																													IF(CONT.Estatus = 'B','VENCIDO','INACTIVO'))) AS Estatus,
			CONT.SaldoCapVigent,		CONT.SaldoCapAtrasad,	CONT.SaldoInterProvi,	CONT.SaldoInterVenc,	CONT.SaldoMoraCarVen,
			CONT.SaldoCapVencido,		CONT.SaldoInterVenc,	CONT.SaldComFaltPago,	CONT.SaldoOtrasComis,	CONT.SucursalID,
			CRED.TipoGarantiaFIRAID,		CRED.RamaFIRAID,		CRED.ActividadFIRAID,CRED.CadenaProductivaID,			CRED.ProgEspecialFIRAID,
			Par_TransaccionID,			@Var_Consecutivo:= @Var_Consecutivo+1, CONT.DestinoCreID
			FROM
			CREDITOSCONT AS CONT
			INNER JOIN CREDITOS AS CRED ON CONT.CreditoID = CRED.CreditoID
			LEFT JOIN RELCREDPASIVOAGRO AS REL ON CRED.CreditoID = REL.CreditoID
			LEFT JOIN SOLICITUDCREDITO AS SOL ON CRED.SolicitudCreditoID = SOL.SolicitudCreditoID
			LEFT JOIN MINISTRACREDAGRO AS MINS ON CRED.CreditoID = MINS.CreditoID AND Numero = 1;
	END IF;

	UPDATE TMPANALITICOCONT AS T INNER JOIN CLIENTES AS CLI ON T.ClienteID = CLI.ClienteID SET
		T.NombreCompleto = CLI.NombreCompleto,
		T.TipoPersona = IF(CLI.TipoPersona='F','FISICA',IF(CLI.TipoPersona='A','FISICA CON ACT. EMPRESARIAL','MORAL'))
		WHERE
			T.TransaccionID = Par_TransaccionID AND
			T.ClienteID = CLI.ClienteID;

	UPDATE TMPANALITICOCONT AS T SET
		T.FechaProxVenc = FNFECHAPROXPAG(T.CreditoID),
		T.MontoProxVenc = FNEXIGIBLEPROXPAG(T.CreditoID),
		T.FechaUltVenc = FNFECHAULTVENC(T.CreditoID)
		WHERE
			T.TransaccionID = Par_TransaccionID AND
			T.CreditoID > 0;

	UPDATE TMPANALITICOCONT AS T INNER JOIN CATTIPOGARANTIAFIRA AS GAR ON T.TipoGarantiaFIRAID = GAR.TipoGarantiaID SET
		T.GarantiaDes = GAR.Descripcion
		WHERE
			T.TransaccionID = Par_TransaccionID AND
			T.TipoGarantiaFIRAID = GAR.TipoGarantiaID;

	UPDATE TMPANALITICOCONT AS T
		LEFT JOIN CATFIRAPROGESP AS PRO ON T.ProgEspecialFIRAID = PRO.CveSubProgramaID
		LEFT JOIN CATCADENAPRODUCTIVA AS CAD ON T.CadenaProductivaID = CAD.CveCadena
		LEFT JOIN CATRAMAFIRA AS RAM ON T.RamaFIRAID=RAM.CveRamaFIRA
		LEFT JOIN CATACTIVIDADFIRA AS ACT ON T.ActividadFIRAID = ACT.CveActividadFIRA
	  SET
		T.RamaFiraDes = RAM.DescripcionRamaFIRA,
		T.ActividadDes = ACT.DesActividadFIRA,
		T.CadenaProDes = CAD.NomCadenaProdSCIAN,
		T.ProgEspecialDes = PRO.SubPrograma
		WHERE
			T.TransaccionID = Par_TransaccionID;

	UPDATE TMPANALITICOCONT AS T
		LEFT JOIN DESTINOSCREDITO AS DES ON T.DestinoCreID = DES.DestinoCreID
		LEFT JOIN CLASIFICCREDITO AS CLAS ON DES.SubClasifID = CLAS.ClasificacionID
	  SET
		T.ClasificacionCred = IF(CLAS.ClasificacionID = 125,"AVIO",IF(CLAS.ClasificacionID = 126,"REFACCIONARIO",CLAS.DescripClasifica))
		WHERE
			T.TransaccionID = Par_TransaccionID;

	UPDATE TMPANALITICOCONT AS T
		LEFT JOIN CREDITOFONDEO AS FON ON T.CreditoFondeoID = FON.CreditoFondeoID
	  SET
		T.TasaPasiva = FON.TasaFija
		WHERE
			T.TransaccionID = Par_TransaccionID;

	UPDATE TMPANALITICOCONT AS T
		INNER JOIN SUCURSALES AS SUC ON T.Sucursal = SUC.SucursalID
	  SET
		T.NombreSucurs = SUC.NombreSucurs
		WHERE
			T.TransaccionID = Par_TransaccionID AND
			T.Sucursal = SUC.SucursalID;

	UPDATE TMPANALITICOCONT AS TMP INNER JOIN
		(SELECT CreditoFondeoID,COUNT(*) AS NCreditos
			FROM RELCREDPASIVOAGRO AS RR
			GROUP BY RR.CreditoFondeoID) AS RELA ON TMP.CreditoFondeoID = RELA.CreditoFondeoID
			SET
		TMP.NumSocios = RELA.NCreditos
		WHERE
			TMP.TransaccionID = Par_TransaccionID
			AND TMP.CreditoFondeoID = RELA.CreditoFondeoID;

	UPDATE
		TMPANALITICOCONT AS TT INNER JOIN
		BITACORAAPLIGAR AS BIS ON TT.CreditoID = BIS.CreditoID SET
		TT.MontoGarAfec = BIS.MontoGarApli
		WHERE
			TT.CreditoID = BIS.CreditoID;


 	  UPDATE
        TMPANALITICOCONT AS TT INNER JOIN
        CREDITOSCONT AS CONT ON TT.CreditoIDCont = CONT.CreditoID
        INNER JOIN CREDITOS AS CRED ON CONT.CreditoID = CRED.CreditoID INNER JOIN
	    ( SELECT DISTINCT SolicitudCreditoID, ClienteID,ConceptoFiraID,Unidad,NoUnidad, ClaveUnidad FROM CONCEPTOINVERAGRO
        WHERE TipoRecurso = 'P') AS CONINV ON CRED.SolicitudCreditoID = CONINV.SolicitudCreditoID
        INNER JOIN CATCONCEPTOSINVERAGRO AS CAT ON CONINV.ConceptoFiraID = CAT.ConceptoFiraID
	  SET
		TT.ConceptoUnidades =  CONINV.Unidad,
        TT.TipoUnidades =  CONINV.ClaveUnidad,
        TT.Unidades =  CONINV.NoUnidad,
        TT.ConceptoInversion = CAT.Descripcion
         WHERE
			TT.CreditoIDCont = CONT.CreditoID;



	SELECT
		TT.CreditoFondeoID,			TT.CreditoID,			TT.CreditoIDCont,		TT.AcreditadoIDFIRA,		TT.CreditoIDFIRA,
		TT.ClienteID,				TT.NombreCompleto,		IF(IFNULL(TT.CreditoIDSinFon,0)=0,'',TT.CreditoIDSinFon) AS CreditoIDSinFon,		TT.CreditoIDPagoFira,		TT.FechaOtorgamiento,
		TT.MontoGarAfec,			TT.FechaProxVenc,		TT.MontoProxVenc,		TT.FechaUltVenc,			TT.Estatus,
		TT.SalCapVigente,			TT.SalCapAtrasado,		TT.SalIntProvision,		TT.SalIntVencido,			TT.SaldoMoraCarVen,
		TT.SaldoCapVencido,			TT.SaldoInterVenc,		TT.SalComFaltaPago,		TT.SalOtrasComisi,			TT.IVAInteresPagado,
		TT.IVAInteresVenc,			TT.IVAMoraPag,			TT.IVAComFaltaPago,		TT.IVAOtrasCom,				TT.Sucursal,
		TT.NombreSucurs,			TT.TipoGarantiaFIRAID,	TT.GarantiaDes,			TT.ClasificacionCred,		TT.RamaFIRAID,
		TT.RamaFiraDes,				TT.ActividadFIRAID,		TT.ActividadDes,		TT.CadenaProductivaID,		TT.CadenaProDes,
		TT.ProgEspecialFIRAID,		TT.ProgEspecialDes,		TT.TipoPersona,			TT.ConceptoInversion,		TT.Unidades,
		TT.ConceptoUnidades,		TT.TipoUnidades,		TT.TasaPasiva,			IF(IFNULL(TT.NumSocios,0) = 0,'',TT.NumSocios) AS NumSocios
		FROM TMPANALITICOCONT AS TT
			WHERE TransaccionID = Par_TransaccionID;


END TerminaStore$$