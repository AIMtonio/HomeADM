
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRWSALDOSINVERCON`;
DELIMITER $$

CREATE PROCEDURE `CRWSALDOSINVERCON`(
	Par_ClienteID 		INT(11),
	Par_CuentaAhoID		BIGINT(12),
	Par_EmpresaID		INT(11),
    
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)

TerminaStore: BEGIN

	DECLARE	InteresCobrado	    DECIMAL(14,4);
	DECLARE	PagTotalRecib		DECIMAL(14,4);
	DECLARE	SaldoTotal		    DECIMAL(14,4);
	DECLARE	NumEfecDisp		    INT(11);
	DECLARE	SalEfecDisp		    DECIMAL(12,4);
	DECLARE	NumInvProceso		INT(11);
	DECLARE	SalInvProceso		DECIMAL(12,4);
	DECLARE	NumInvActivas		INT(11);
	DECLARE	SalInvActivas		DECIMAL(12,4);
	DECLARE	NumTotInver		    INT(11);
	DECLARE	NumInvActResum	    INT(11);
	DECLARE	SalInvActResum	    DECIMAL(12,4);
	DECLARE	NumErr		 	    INT(11);
	DECLARE	ErrMen			    VARCHAR(40);
	DECLARE Var_FecActual		DATE;
	DECLARE	Entero_Cero		    INT(11);
	DECLARE	Decimal_Cero 		DECIMAL(12,4);
	DECLARE	EstatVigente		CHAR(1);
	DECLARE	EstatProceso		CHAR(1);
	DECLARE	EstatPagada		    CHAR(1);
	DECLARE	EstatVencida		CHAR(1);

	DECLARE	GanAnuTotal 		DECIMAL(12,4);
	DECLARE	NumIntDeveng		INT(11);
	DECLARE	SalIntDeveng		DECIMAL(12,4);
	DECLARE	NumInvAtra1a15 		INT(11);
	DECLARE	SalInvAtra1a15		DECIMAL(12,4);
	DECLARE	NumInvAtra16a30		INT(11);
	DECLARE	SalInvAtra16a30		DECIMAL(12,4);
	DECLARE	NumInvAtra31a90		INT(11);
	DECLARE	SalInvAtra31a90		DECIMAL(12,4);
	DECLARE	NumInvVen91a120		INT(11);
	DECLARE	SalInvVen91a120		DECIMAL(12,4);
	DECLARE	NuInvVen120a180		INT(11);
	DECLARE	SaInvVen120a180		DECIMAL(12,4);
	DECLARE	CapitalCobrado		DECIMAL(14,4);
	DECLARE	NumCapCobrado		INT(11);
	DECLARE	MoraCobrado			DECIMAL(12,4);
	DECLARE	CFPagPagado			DECIMAL(12,4);
	DECLARE	NumMorCobrado		INT(11);
	DECLARE	NumCFCobrado		INT(11);
	DECLARE	NumIntCobrado		INT(11);
	DECLARE Var_Global 		DECIMAL(12,4);
	DECLARE Var_PlazoFijo 	DECIMAL(12,4);

	DECLARE	NumInvQuebrant		INT(11);
	DECLARE	SalInvQuebrant		DECIMAL(12,4);
	DECLARE	NumInvLiquidada		INT(11);
	DECLARE	SalInvLiquidada		DECIMAL(12,4);
	DECLARE NumInvPFActivas	  	INT(11);
	DECLARE MontoInversiones  	DECIMAL(14,2);
	DECLARE IntARecibir       	DECIMAL(14,2);

	SET	Entero_Cero				:= 0;
	SET Decimal_Cero			:= 0.0;
	SET	EstatVigente			:= 'N';
	SET	EstatProceso			:= 'F';
	SET	EstatPagada				:= 'P';
	SET	EstatVencida			:= 'V';
	SET GanAnuTotal				:= 0.0;
	SET NumInvAtra1a15			:= 0;
	SET SalInvAtra1a15			:= 0.0;
	SET NumInvAtra16a30			:= 0;
	SET SalInvAtra16a30			:= 0.0;
	SET NumInvAtra31a90			:= 0;
	SET SalInvAtra31a90			:= 0.0;
	SET NumInvVen91a120			:= 0;
	SET SalInvVen91a120			:= 0.0;
	SET NuInvVen120a180			:= 0;
	SET SaInvVen120a180			:= 0.0;
	SET SaldoTotal 				:= 0.0;

	SET	NumInvQuebrant			:= 0;
	SET SalInvQuebrant			:= 0.0;
	SET NumMorCobrado 			:= 0;
	SET NumCFCobrado			:= 0;
	SET NumIntCobrado			:= 0;
	SET	CFPagPagado				:= 0.00;
	SET	NumInvActResum			:= 0;
	SET	SalInvActResum			:= 0.00;
	SET	NumTotInver				:= 0;
	SET	NumInvActivas			:= 0;

	SET	Par_ClienteID			:= IFNULL(Par_ClienteID, Entero_Cero);
	SET Par_CuentaAhoID 		:= IFNULL(Par_CuentaAhoID,Entero_Cero);
	SET Var_FecActual			:= (SELECT FechaSistema FROM PARAMETROSSIS);

	DELETE FROM TMPCRWFONDEOINV WHERE ClienteID = Par_ClienteID AND CuentaAhoID = Par_CuentaAhoID;
			
	INSERT INTO TMPCRWFONDEOINV(
			FondeoID,		ClienteID,          CreditoID,          CuentaAhoID,    MontoFondeo,
			Estatus,        SaldoCapVigente,    SaldoCapExigible,   SaldoInteres,   EmpresaID,
			Usuario,        FechaActual,        DireccionIP,        ProgramaID,     Sucursal,
			NumTransaccion
	)SELECT SolFondeoID,	ClienteID,          CreditoID,          CuentaAhoID,    MontoFondeo,
			Estatus,        SaldoCapVigente,    SaldoCapExigible,   SaldoInteres,   EmpresaID,
			Usuario,        FechaActual,        DireccionIP,        ProgramaID,     Sucursal,
			NumTransaccion 
		FROM CRWFONDEO 
			WHERE ClienteID = Par_ClienteID 
				 AND CuentaAhoID = Par_CuentaAhoID
					AND Estatus IN(EstatVigente,EstatPagada);          
 
	SELECT		SUM(SaldoDispon),	COUNT(CuentaAhoID)
		INTO	SalEfecDisp,		NumEfecDisp
			FROM 	CUENTASAHO
				WHERE CuentaAhoID = Par_CuentaAhoID;

	SET SalEfecDisp 	:= IFNULL(SalEfecDisp,Decimal_Cero);
    SET NumEfecDisp		:= IFNULL(NumEfecDisp,Entero_Cero);
    
	SELECT	COUNT(SolicitudCreditoID), SUM(MontoFondeo)
		INTO NumInvProceso,	SalInvProceso
			FROM CRWFONDEOSOLICITUD 
				WHERE ClienteID = Par_ClienteID
						AND CuentaAhoID = Par_CuentaAhoID 
                        AND Estatus = EstatProceso;
                        
	SET NumInvProceso 	:= IFNULL(NumInvProceso,Entero_Cero);
	SET SalInvProceso 	:= IFNULL(SalInvProceso,Decimal_Cero);
    
	SELECT  SUM(InteresGlobal), SUM(InteresPlazoF),	SUM(InteresImpulso), SUM(InteresImpulsoMora) 
		INTO Var_Global,		Var_PlazoFijo,		InteresCobrado,			MoraCobrado
			FROM CRWINTERESES 
				WHERE CuentaAhoID = Par_CuentaAhoID;
                
	SET InteresCobrado		:= IFNULL(InteresCobrado,Decimal_Cero);
	SET MoraCobrado			:= IFNULL(MoraCobrado,Decimal_Cero);
    SET	Var_Global			:= IFNULL(Var_Global, Decimal_Cero);
    SET	Var_PlazoFijo		:= IFNULL(Var_PlazoFijo, Decimal_Cero);
    
	SELECT COUNT(Amo.SolFondeoID),SUM(Amo.Capital-ROUND(Amo.SaldoCapVigente,2)-ROUND(Amo.SaldoCapExigible,2))
		INTO NumCapCobrado,			CapitalCobrado 
		FROM TMPCRWFONDEOINV Fon INNER JOIN AMORTICRWFONDEO Amo ON Fon.FondeoID = Amo.SolFondeoID  
			WHERE
					Fon.ClienteID = Par_ClienteID
				AND Fon.CuentaAhoID = Par_CuentaAhoID
                AND Amo.Estatus IN(EstatVigente,EstatPagada)
				AND Amo.SaldoCapCtaOrden = Entero_Cero;
	
	SET PagTotalRecib := (Var_Global + CapitalCobrado + InteresCobrado + MoraCobrado + Var_PlazoFijo);

	SELECT	COUNT(FondeoID),	SUM(MontoFondeo)
		INTO NumInvLiquidada,	SalInvLiquidada
			FROM TMPCRWFONDEOINV
			WHERE
				Estatus	 	= EstatPagada
                AND ClienteID 	= Par_ClienteID
				AND CuentaAhoID = Par_CuentaAhoID;
										
	SELECT ROUND(SUM(Amo.SaldoCapVigente + Amo.SaldoCapExigible),2), ROUND(SUM(Amo.SaldoInteres),2)
		INTO SalInvActivas, SalIntDeveng
		FROM TMPCRWFONDEOINV Fon  INNER JOIN   AMORTICRWFONDEO Amo
			ON Fon.FondeoID = Amo.SolFondeoID 
				WHERE  	
					Fon.Estatus <> EstatPagada
                    AND Amo.Estatus <> EstatPagada
					AND Fon.ClienteID = Par_ClienteID 
					AND Fon.CuentaAhoID  = Par_CuentaAhoID;
	
    SET SalInvActivas 	:= IFNULL(SalInvActivas,Decimal_Cero);
	SET SalIntDeveng 	:= IFNULL(SalIntDeveng,Decimal_Cero);
    
	SELECT COUNT(InversionID), IFNULL(SUM(Monto),Entero_Cero), IFNULL(SUM(SaldoProvision),Entero_Cero) 
		INTO NumInvPFActivas, MontoInversiones, IntARecibir
			FROM INVERSIONES 
				WHERE ClienteID = Par_ClienteID
					AND CuentaAhoID = Par_CuentaAhoID 
					AND Estatus = EstatVigente;

	SET SaldoTotal := (SalEfecDisp + SalInvProceso + SalInvActivas + SalIntDeveng + MontoInversiones + IntARecibir);

	SET PagTotalRecib	:= IFNULL(PagTotalRecib,Decimal_Cero);
	SET SaldoTotal		:= IFNULL(SaldoTotal,Decimal_Cero);
	SET NumIntDeveng 	:= IFNULL(NumIntDeveng,Entero_Cero);	
	SET NumInvLiquidada := IFNULL(NumInvLiquidada,Entero_Cero);
	SET SalInvLiquidada := IFNULL(SalInvLiquidada,Decimal_Cero);
	SET CapitalCobrado 	:= IFNULL(CapitalCobrado,Decimal_Cero);

	SELECT 	ROUND(GanAnuTotal,2) AS GanAnuTotal,			NumIntCobrado,      							ROUND(InteresCobrado,2) AS InteresCobrado,		ROUND(PagTotalRecib,2) AS PagTotalRecib,		ROUND(SaldoTotal,2) AS SaldoTotal,
			NumEfecDisp,									ROUND(SalEfecDisp,2) AS SalEfecDisp,			NumInvProceso,									ROUND(SalInvProceso,2) AS SalInvProceso,		NumInvActivas,
			ROUND(SalInvActivas,2) AS SalInvActivas,		NumIntDeveng,									ROUND(SalIntDeveng,2) AS SalIntDeveng,			NumTotInver,									NumInvActResum,
			ROUND(SalInvActResum,2) AS SalInvActResum,		NumInvAtra1a15,									ROUND(SalInvAtra1a15,2) AS SalInvAtra1a15,		NumInvAtra16a30,								ROUND(SalInvAtra16a30,2) AS SalInvAtra16a30,
			NumInvAtra31a90,								ROUND(SalInvAtra31a90,2) AS SalInvAtra31a90,	NumInvVen91a120,								ROUND(SalInvVen91a120,2) AS SalInvVen91a120,	NuInvVen120a180,
			ROUND(SaInvVen120a180,2) AS SaInvVen120a180,	NumInvQuebrant,									ROUND(SalInvQuebrant,2) AS SalInvQuebrant,		NumInvLiquidada,								ROUND(SalInvLiquidada,2) AS SalInvLiquidada,
			NumCapCobrado,									ROUND(CapitalCobrado,2) AS CapitalCobrado,		NumMorCobrado,									ROUND(MoraCobrado,2) AS MoraCobrado,			NumCFCobrado,
			ROUND(CFPagPagado,2) AS CFPagPagado,			0.00 AS GAT;

	DELETE FROM TMPCRWFONDEOINV WHERE ClienteID = Par_ClienteID AND CuentaAhoID=Par_CuentaAhoID;
        
END TerminaStore$$