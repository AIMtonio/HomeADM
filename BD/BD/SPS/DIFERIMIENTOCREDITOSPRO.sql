
-- DIFERIMIENTOCREDITOSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS DIFERIMIENTOCREDITOSPRO;

DELIMITER $$
CREATE PROCEDURE `DIFERIMIENTOCREDITOSPRO`(
/* Realiza el proceso de diferimiento de creditos */
	Par_Salida						CHAR(1),					# Indica el tipo de salida S.- SI N.- No
	INOUT Par_NumErr				INT,						# Numero de Error
	INOUT Par_ErrMen				VARCHAR(400),				# Mensaje de Error
	/*Parametros de Auditoria*/
	Aud_EmpresaID					INT(11),					-- Auditoria
	Aud_Usuario						INT(11),					-- Auditoria
	Aud_FechaActual					DATETIME,					-- Auditoria
	Aud_DireccionIP					VARCHAR(15),				-- Auditoria
	Aud_ProgramaID					VARCHAR(50),				-- Auditoria
	Aud_Sucursal					INT(11),					-- Auditoria
	Aud_NumTransaccion				BIGINT(12)					-- Auditoria
)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Control				VARCHAR(50);				-- ID del Control en pantalla
	DECLARE Var_Consecutivo 		VARCHAR(200);				-- Numero consecutivo para la imagen a digitalizar
	DECLARE Var_FechaSistema 		DATE;						-- FechaSistema
	DECLARE Var_MesesSuspender		INT(11);					-- Cantidad de meses que se va suspender el credito
	DECLARE Var_NumConsecutivo		INT(11);
	DECLARE Var_MaxCreditos			INT(11);
    DECLARE Var_CreditoID			BIGINT(12);
    DECLARE Var_CreditoOrigen		BIGINT(12);
    DECLARE Var_AmortizacionID		INT;
    DECLARE Var_IniAmortiza			INT;
    DECLARE Var_Estatus				CHAR(1);
    DECLARE Var_AltaPoliza			CHAR(1);
    DECLARE Var_PolizaID			BIGINT;
    DECLARE  Var_ModoPago        	CHAR(1);
    DECLARE Var_EstatusPro			CHAR(1);
    DECLARE Var_TipoDiferimiento	CHAR(1);
    DECLARE Var_MesesDiferidos		INT;
    DECLARE Var_FechaInicio			DATE;
    DECLARE Var_FechaFinCre			DATE;
    DECLARE Var_FechaFinCreAnt		DATE;
    DECLARE Var_CondonaAccesorios	CHAR(1);
    DECLARE Var_TipoPagoCap			CHAR(1);
    DECLARE Var_NumAmortizaciones	INT;
    DECLARE Var_UsuarioID			INT;
    DECLARE Var_TipoPagoInt			CHAR(1);
    DECLARE Var_MotivoError			VARCHAR(400);
    DECLARE Var_FechaExAmortiza		DATE;
    DECLARE Var_FechaAntAmortiza	DATE;
    DECLARE Var_FechaFinPer			DATE;
    DECLARE Var_DiasDiferidos		INT;
    DECLARE Var_AmortFin			INT;
    DECLARE Var_SucursalID			INT;
    DECLARE Var_TasaFija			DECIMAL(16,4);
    DECLARE Var_FechaFinOrig		DATE;
    DECLARE Var_IVA                 DECIMAL(14,2);
    DECLARE Var_TasaPreferencial	DECIMAL(16,4);
    DECLARE Var_InteresPrefe		DECIMAL(14,2);
    DECLARE Var_InteresDiv			DECIMAL(14,2);
    DECLARE Var_InteresAjust		DECIMAL(14,2);
    DECLARE Var_CapitalInsoluto		DECIMAL(16,2);
    DECLARE Var_SaldoAtras			DECIMAL(16,2);
    DECLARE Var_SaldoMora			DECIMAL(16,2);
    DECLARE Var_SaldoComision		DECIMAL(16,2);
    DECLARE Var_DiasDevengo			INT;
	DECLARE Var_TipoCalInt      	INT;
    DECLARE Var_NumErr				VARCHAR(11);
	DECLARE Var_SqlState			VARCHAR(30);
    DECLARE Var_PuestoCondona		VARCHAR(50);
	DECLARE Var_ErrMsg				TEXT;
    DECLARE Var_NumDifer			INT;
    DECLARE Var_NumNoDifer			INT;
    DECLARE Var_FechaIniCred		DATE;
    DECLARE Var_ClienteID			INT;
    DECLARE Var_PagoCuota			CHAR(1);
    DECLARE Var_PagoFinAni			CHAR(1);
    DECLARE Var_DiaMes				INT(11);
    DECLARE Var_DiasFrec			INT(11);
    DECLARE Var_NuevaCuota			INT(11);
    DECLARE Var_CuotasDifer			INT(11);
    DECLARE Var_CuentaID			BIGINT(12);
    DECLARE Var_FechSigAmo			DATE;
    DECLARE Var_ProductoCreditoID	INT;
    DECLARE Var_NumMesesPag			INT;
    DECLARE Var_ClienteOrigen		INT;
    DECLARE Var_DiasAtrasoMarzo		INT;
    DECLARE Var_ClienteEsp			INT;
    DECLARE Var_NumeroMaxDiferimientos	INT(11);
    DECLARE Var_NumeroDiferimientos	INT(11);
    DECLARE Var_FechaAjuste			DATE;
    DECLARE Var_FechaValDiferir		DATE;
    DECLARE Var_FechaAplicacion		DATE;


	-- Declaracion de constantes
	DECLARE Entero_Cero				INT(11);
	DECLARE MaximoMeses				INT(11);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Estatus_Pagado			CHAR(1);
	DECLARE Estatus_Pendiente		CHAR(1);
	DECLARE Estatus_Error			CHAR(1);
	DECLARE Estatus_Vigente			CHAR(1);
	DECLARE Estatus_Vencido			CHAR(1);
	DECLARE Estatus_Bloqueado		CHAR(1);
	DECLARE Estatus_Aplicado		CHAR(1);
	DECLARE Fecha_Vacia				DATE;
	DECLARE Cons_NO					CHAR(1);
	DECLARE SalidaSi				CHAR(1);
	DECLARE FechaCorteVig			DATE;
	DECLARE Fecha_Limite			DATE;
    DECLARE Total_Amortizaciones	CHAR(1);
    DECLARE Unica_Amortizacion		CHAR(1);
    DECLARE Pago_Semanal			CHAR(1);
    DECLARE Pago_Catorcenal			CHAR(1);
	DECLARE Fre_DiasAnio            INT(11);            -- dias del año
    DECLARE Pago_Unico				CHAR(1);
    DECLARE Tipo_Unico				CHAR(1);
	DECLARE Tipo_Completo			CHAR(1);
	DECLARE Tipo_TasaPref			CHAR(1);
    DECLARE Int_SalInsol    		INT;
	DECLARE Int_SalGlobal   		INT;
	DECLARE Tipo_TasaFija   		INT;
	DECLARE Decimal_Cero   			DECIMAL(16,2);
	DECLARE Var_NumTran				BIGINT(20);
    DECLARE Clien_Crediclub			INT;
    DECLARE Entero_Uno 				INT(11);

	-- Asignacion de constantes
	SET Entero_Cero				:= 0;							-- Entero Cero
	SET MaximoMeses				:= 6;							-- Maximo de meses
	SET Cadena_Vacia			:= '';							-- Cadena Vacia
	SET Fecha_Vacia				:= '1900-01-01';				-- Fecha Vacia
	SET Cons_NO					:= 'N';							-- Constante No
	SET SalidaSi				:= 'S';							-- Salida Si
	SET FechaCorteVig			:= '2020-03-31';
	SET Fecha_Limite			:= '2020-05-31';
	SET Estatus_Pagado			:= 'P';
	SET Estatus_Pendiente		:= 'P';
	SET Estatus_Error			:= 'E';
	SET Estatus_Vigente			:= 'V';
	SET Estatus_Vencido			:= 'B';
	SET Estatus_Bloqueado		:= 'B';
	SET Estatus_Aplicado		:= 'A';
    SET Var_AltaPoliza			:= 'S';
    SET Var_ModoPago			:= 'E';
    SET Total_Amortizaciones	:= 'C';
    SET	Unica_Amortizacion		:= 'U';
    SET Pago_Semanal			:= 'S';
    SET Pago_Catorcenal			:= 'C';
    SET Tipo_Unico				:= 'U';
	SET Tipo_Completo			:= 'C';
	SET Tipo_TasaPref			:= 'P';
	SET Pago_Unico				:= 'U';
    SET Int_SalInsol    		:= 1;               -- Calculo de Interes Sobre Saldos Insolutos
	SET Int_SalGlobal   		:= 2;               -- Calculo de Interes Sobre Saldos Globales
    SET Decimal_Cero			:= 0;
    SET Tipo_TasaFija			:= 1;
    SET Clien_Crediclub			:= 24;
    SET Entero_Uno				:= 1;

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr		:= 999;
			SET Par_ErrMen		:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-DIFERIMIENTOCREDITOSPRO');
			SET Var_Control		:= 'sqlException' ;
		END;

		SET FechaCorteVig 		:= (SELECT MAX(FechaCorte)
										FROM SALDOSCREDITOS s
                                        WHERE FechaCorte <= FechaCorteVig);

		SET Var_FechaSistema	:= (SELECT FechaSistema FROM PARAMETROSSIS);
        SET Fre_DiasAnio        := (SELECT DiasCredito  FROM PARAMETROSSIS);  -- Dias Base Anual Parametrizado para Creditos
        SET Var_UsuarioID		:= (SELECT MIN(UsuarioID) FROM USUARIOS);
    	SET Var_FechaValDiferir := Var_FechaSistema;

        SET Var_PuestoCondona := (
			SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = 'DiferClavePuestoCondona'
        );

		SET Var_ClienteEsp := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = 'CliProcEspecifico');
		SET Var_NumeroMaxDiferimientos := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = 'NumeroMaxDiferimientos');


        -- Se actualiza el número de transacción para poder identificar a los que van a ser procesados
        UPDATE TMPCREDITOSPORDIFERIR
			SET NumTransaccion     = Aud_NumTransaccion,
				CantMesesDif       = IFNULL(CantMesesDif,Entero_Cero),
                TipoDiferimiento   = IFNULL(TipoDiferimiento,Cadena_Vacia),
                TasaPreferencial   = IFNULL(TasaPreferencial,Entero_Cero),
                CondonaAccesorios  = IFNULL(CondonaAccesorios,Cadena_Vacia);

		IF NOT EXISTS(SELECT * FROM TMPCREDITOSPORDIFERIR WHERE NumTransaccion = Aud_NumTransaccion) THEN
			SET Par_NumErr		:= 001;
			SET Par_ErrMen		:= 'No Hay Creditos a Procesar';
			LEAVE ManejoErrores;
		END IF;

        SET @Consecutivo := Entero_Cero;

        DELETE FROM TMP_CREDITOSDIFERIDX;

        INSERT INTO TMP_CREDITOSDIFERIDX
        (Consecutivo,		 CreditoID,		 NumRepetido,		 MotivoError)
		SELECT
		(@Consecutivo := @Consecutivo +1),
							CreditoID,		COUNT(CreditoID),	Cadena_Vacia
        FROM TMPCREDITOSPORDIFERIR
        WHERE NumTransaccion = Aud_NumTransaccion
        GROUP BY CreditoID;

		UPDATE TMP_CREDITOSDIFERIDX Dif
			INNER JOIN CREDITOS AS Cre
				ON Dif.CreditoID = Cre.CreditoID
			SET Dif.MotivoError = 'El Credito no se encuentra Vigente o Vencido.'
		WHERE Cre.Estatus NOT IN(Estatus_Vigente,Estatus_Vencido);

        UPDATE TMP_CREDITOSDIFERIDX Dif
			INNER JOIN CREDITOS AS Cre
				ON Dif.CreditoID = Cre.CreditoID
			SET Dif.MotivoError = 'No se puede Diferir Creditos Restructurados/Renovados'
		WHERE Cre.Relacionado > Entero_Cero
		AND Cre.Estatus 	!= Estatus_Pagado;

         UPDATE TMP_CREDITOSDIFERIDX Dif INNER JOIN CREDITOS AS Cre ON Dif.CreditoID = Cre.CreditoID
			SET Dif.MotivoError = 'No se puede Diferir Creditos Agropecuarios'
		WHERE Cre.EsAgropecuario = 'S';


        UPDATE TMP_CREDITOSDIFERIDX Dif
			INNER JOIN CREDITOS AS Cre
				ON Dif.CreditoID = Cre.CreditoID
			SET Dif.MotivoError = 'El crédito es de tasa variable, no se puede aplicar diferimiento.'
		WHERE Cre.CalcInteresID 	!= Tipo_TasaFija;

        UPDATE TMP_CREDITOSDIFERIDX Dif
			INNER JOIN CREDITOINVGAR AS Cre
				ON Dif.CreditoID = Cre.CreditoID
			SET Dif.MotivoError = 'El crédito esta garantízado por una inversión, no se puede aplicar diferimiento'
		WHERE Cre.MontoEnGar 	> Entero_Cero;

        UPDATE TMP_CREDITOSDIFERIDX Dif
				INNER JOIN CREDITOS AS Cre ON Dif.CreditoID = Cre.CreditoID
                INNER JOIN SALDOSCREDITOS AS Sal ON Dif.CreditoID = Sal.CreditoID
			SET Dif.MotivoError = CONCAT('El credito debe estar en cartera vigente la fecha: ',FechaCorteVig)
		WHERE Sal.FechaCorte		= FechaCorteVig
			AND Sal.EstatusCredito	!= Estatus_Vigente;

		UPDATE TMP_CREDITOSDIFERIDX Dif
			INNER JOIN  TMPCREDITOSPORDIFERIR Tem
				ON Dif.CreditoID = Tem.CreditoID
			SET Dif.MotivoError = 'Solo se puede diferir hasta 6 meses.'
		WHERE Tem.NumTransaccion = Aud_NumTransaccion
        AND Tem.CantMesesDif > MaximoMeses
        AND Tem.TipoDiferimiento <> 'R';

        UPDATE TMP_CREDITOSDIFERIDX Dif
			INNER JOIN  TMPCREDITOSPORDIFERIR Tem
				ON Dif.CreditoID = Tem.CreditoID
			SET Dif.MotivoError = 'No se especificó una Tasa Preferencial.'
		WHERE Tem.NumTransaccion = Aud_NumTransaccion
        AND Tem.TipoDiferimiento = Tipo_TasaPref
        AND IFNULL(Tem.TasaPreferencial,Entero_Cero) = Entero_Cero;

		UPDATE TMP_CREDITOSDIFERIDX Dif
				INNER JOIN  TMPCREDITOSPORDIFERIR Tem
                ON Dif.CreditoID = Tem.CreditoID
			SET Dif.MotivoError = 'El Tipo de Diferimiento es Invalido.'
		WHERE Tem.NumTransaccion = Aud_NumTransaccion
        AND Tem.TipoDiferimiento NOT IN(Tipo_Unico,Tipo_Completo,Tipo_TasaPref,'R');

        UPDATE TMP_CREDITOSDIFERIDX Dif
			INNER JOIN CREDITOSDIFERIDOS AS Cre
				ON Dif.CreditoID = Cre.CreditoID
			SET Dif.MotivoError = 'Un Crédito no se puede diferir dos veces en la misma fecha.'
			WHERE Cre.FechaAplicacion = Var_FechaSistema;


         UPDATE TMP_CREDITOSDIFERIDX Dif
			INNER JOIN CREDITOSDIFERIDOS AS Cre
				ON Dif.CreditoID = Cre.CreditoOrigenID
			SET Dif.MotivoError = 'Un Crédito no se puede diferir dos veces en la misma fecha.'
		 WHERE Cre.CreditoOrigenID <> 0
		   AND Cre.FechaAplicacion = Var_FechaSistema;

        UPDATE TMP_CREDITOSDIFERIDX Dif SET Dif.NumRepetido =  Entero_Cero;

		UPDATE TMP_CREDITOSDIFERIDX Dif
			INNER JOIN AMORTICREDITO AS Cre          ON Dif.CreditoID = Cre.CreditoID
             INNER JOIN TMPCREDITOSPORDIFERIR AS Tem ON Dif.CreditoID = Tem.CreditoID
			SET Dif.NumRepetido =  1
		WHERE  Tem.NumTransaccion = Aud_NumTransaccion
            AND Cre.Estatus != Estatus_Pagado
			AND Cre.FechaVencim BETWEEN Var_FechaSistema AND  DATE_ADD(Var_FechaSistema, INTERVAL Tem.CantMesesDif MONTH);



        /* ----------------------------------------------------
        --  Registramos los creditos con error,
			se eliminan de la lista principal
        -- ---------------------------------------------------- */
		INSERT INTO CREDITOSSINDIFERIR(
				TransaccionID, 		FechaAplicacion, 		CreditoID, 		MesesDiferidos, 		TipoDiferimiento,
                MotivoRechazo, 		EmpresaID, 				Usuario,	 	FechaActual, 			DireccionIP,
                ProgramaID, 		Sucursal, 				NumTransaccion)
			SELECT
				Aud_NumTransaccion,Var_FechaSistema,		Dif.CreditoID,	Dif.CantMesesDif,		Dif.TipoDiferimiento,
                Tem.MotivoError,	Aud_EmpresaID,			Aud_Usuario,	Aud_FechaActual,		Aud_DireccionIP,
				Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion
			FROM TMPCREDITOSPORDIFERIR Dif INNER JOIN TMP_CREDITOSDIFERIDX Tem
            ON Dif.CreditoID = Tem.CreditoID
            WHERE Dif.NumTransaccion = Aud_NumTransaccion
            AND Tem.MotivoError <> '';

        DELETE FROM TMP_CREDITOSDIFERIDX
			WHERE MotivoError <> '';

		SET @Consecutivo := Entero_Cero;
		UPDATE TMP_CREDITOSDIFERIDX SET
			Consecutivo = (@Consecutivo := @Consecutivo +1 );

        /* CICLO - SE RECORREN LOS CREDITOS A DIFERIR PARA PODER APLICAR LAS VALIDACIONES CORRESPONDIENTES */

        SET Var_NumConsecutivo	:= 1;
        SET Var_MaxCreditos := (SELECT MAX(Consecutivo) FROM TMP_CREDITOSDIFERIDX) ;
        SET Var_MaxCreditos := IFNULL(Var_MaxCreditos,Entero_Cero);

        WHILE Var_NumConsecutivo <= Var_MaxCreditos DO

			START TRANSACTION;
			PROCESACREDITO:BEGIN
				DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					GET DIAGNOSTICS CONDITION 1
                           Var_NumErr 	= RETURNED_SQLSTATE,
				           Var_SqlState = MYSQL_ERRNO,
                           Var_ErrMsg 	= MESSAGE_TEXT;

				  SET Par_NumErr	:=	999;
				  SET Par_ErrMen = CONCAT("ERROR ", Var_NumErr, " (", Var_SqlState, "): ", Var_ErrMsg);

				END;

                SET Par_ErrMen := '';
				SET Par_NumErr := 0;

				SET Var_CreditoID := Entero_Cero;

				SELECT CreditoID
                INTO Var_CreditoID
                FROM TMP_CREDITOSDIFERIDX
                WHERE Consecutivo = Var_NumConsecutivo;

                IF IFNULL(Var_CreditoID,Entero_Cero) = Entero_Cero THEN
					SET Par_NumErr := 4;
					SET Par_ErrMen := 'El Crédito no existe.';
					LEAVE PROCESACREDITO;
                END IF;

                IF NOT EXISTS(SELECT CreditoID FROM CREDITOS WHERE CreditoID = Var_CreditoID) THEN
					SET Par_NumErr := 4;
					SET Par_ErrMen := 'El Crédito no existe.';
					LEAVE PROCESACREDITO;
                END IF;

                SELECT TipoDiferimiento
                INTO Var_TipoDiferimiento
                FROM TMPCREDITOSPORDIFERIR
                WHERE CreditoID = Var_CreditoID;

                SELECT IFNULL(MAX(NumeroDiferimientos), Entero_Cero) + Entero_Uno
                INTO Var_NumeroDiferimientos
                FROM CREDITOSDIFERIDOS
                WHERE CreditoID = Var_CreditoID;

                IF( Var_NumeroDiferimientos > Entero_Uno ) THEN
                	IF( Var_TipoDiferimiento <> 'C') THEN
						SET Par_NumErr := 005;
						SET Par_ErrMen := 'Para Difererir un Crédito por Segunda Ocación es requerido que el Tipo de Diferimiento sea Completo("C").';
						LEAVE PROCESACREDITO;
					END IF;
                END IF;

                IF( Var_NumeroDiferimientos > Var_NumeroMaxDiferimientos ) THEN
					SET Par_NumErr := 006;
					SET Par_ErrMen := 'El Crédito ha Alcanzado el Número Maximo de Diferimientos parametrizados.';
					LEAVE PROCESACREDITO;
                END IF;

                -- Si es el Primer Diferimiento la fecha de Validacion para los dias de atraso es vacia
                -- En caso contrario se la fecha de validacion es la del sistema

                IF( Var_NumeroDiferimientos = Entero_Uno ) THEN
                	SET Var_FechaValDiferir := Fecha_Vacia;
                ELSE
                	SELECT Var_FechaAplicacion
                	INTO Var_FechaAplicacion
                	FROM CREDITOSDIFERIDOS
                	WHERE CreditoID = Var_CreditoID
                	  AND NumeroDiferimientos = Entero_Uno;
                END IF;

				/* SE RESPALDA EL CREDITO DE CUALQUIER FORMA AUN SI SU PAGO ES UNICO POR CUALQUIER CONTINGENCIA */
				INSERT INTO AMORTICREDITODIFER
					SELECT AmortizacionID,		 	CreditoID,		 			Var_NumeroDiferimientos,	ClienteID,		 			CuentaID,		 			FechaInicio,
							FechaVencim,		 	FechaExigible,		 		Estatus,		 			FechaLiquida,		 		Capital,
							Interes,		 	 	IVAInteres,		 			SaldoCapVigente,			SaldoCapAtrasa,		 		SaldoCapVencido,
							SaldoCapVenNExi,	 	SaldoInteresOrd,		 	SaldoInteresAtr,			SaldoInteresVen,		 	SaldoInteresPro,
							SaldoIntNoConta,	 	SaldoIVAInteres,		 	SaldoMoratorios,			SaldoIVAMorato,		 		SaldoComFaltaPa,
							SaldoIVAComFalP,        SaldoComServGar,            SaldoIVAComSerGar,	 	    MontoOtrasComisiones,		MontoIVAOtrasComisiones,
							SaldoOtrasComis,		SaldoIVAComisi,             ProvisionAcum,		 	    SaldoCapital,		 		NumProyInteres,
							SaldoMoraVencido,		SaldoMoraCarVen,            MontoSeguroCuota,	 	    IVASeguroCuota,		 		SaldoSeguroCuota,
							SaldoIVASeguroCuota,	SaldoComisionAnual,         SaldoComisionAnualIVA, 	    0 as SaldoIntPref,			0 as DiasAtraso,
                            EmpresaID,		 	 	Usuario,		 			FechaActual,                DireccionIP,		 	    ProgramaID,
							Sucursal,		 	 	NumTransaccion
                    FROM AMORTICREDITO AS Amo
						WHERE Amo.CreditoID = Var_CreditoID;



				IF( Var_NumeroDiferimientos = Entero_Uno OR Var_FechaValDiferir = Var_FechaAplicacion) THEN
	                SET Var_DiasAtrasoMarzo :=(SELECT DiasAtraso FROM SALDOSCREDITOS where CreditoID = Var_CreditoID AND FechaCorte = FechaCorteVig);

				ELSE
	                SET Var_DiasAtrasoMarzo :=(SELECT DiasAtraso FROM SALDOSCREDITOS where CreditoID = Var_CreditoID AND FechaCorte = DATE_SUB(Var_FechaSistema, INTERVAL Entero_Uno DAY));

				END IF;


                SET Var_DiasAtrasoMarzo := IFNULL(Var_DiasAtrasoMarzo, Entero_Cero);
				SET Var_DiasDiferidos := Var_DiasAtrasoMarzo;

				UPDATE AMORTICREDITODIFER
					SET DiasAtraso = CASE WHEN Var_ClienteEsp = Clien_Crediclub  THEN Var_DiasAtrasoMarzo
										  ELSE CASE WHEN ((datediff(FechaCorteVig,FechaExigible)+1))<0 THEN 0 ELSE (datediff(FechaCorteVig,FechaExigible)+1) END END
				WHERE CreditoID = Var_CreditoID
				AND Estatus in ('V','A','B');

				INSERT INTO CREDITOSDIFER
				SELECT
					CreditoID,			Var_NumeroDiferimientos,LineaCreditoID,		ClienteID,				CuentaID,				Clabe,
					MonedaID,			ProductoCreditoID,		DestinoCreID,		MontoCredito,			TipoCredito,
					Relacionado,		SolicitudCreditoID,		TipoFondeo,			InstitFondeoID,			LineaFondeo,
					FechaInicio,		FechaInicioAmor,		FechaVencimien,		CalcInteresID,			TasaBase,
					TasaFija,			SobreTasa,				PisoTasa,			TechoTasa,				TipCobComMorato,
					FactorMora,			FrecuenciaCap,			PeriodicidadCap,	FrecuenciaInt,			PeriodicidadInt,
					TipoPagoCapital,	NumAmortizacion,		MontoCuota,			FechTraspasVenc,		FechTerminacion,
					IVAInteres,			IVAComisiones,			Estatus,			FechaAutoriza,			UsuarioAutoriza,
					SaldoCapVigent,		SaldoCapAtrasad,		SaldoCapVencido,	SaldCapVenNoExi,		SaldoInterOrdin,
					SaldoInterAtras,	SaldoInterVenc,			SaldoInterProvi,	SaldoIntNoConta,		SaldoIVAInteres,
					SaldoMoratorios,	SaldoIVAMorator,		SaldComFaltPago,	SalIVAComFalPag,        SaldoComServGar,
					SaldoIVAComSerGar,	SaldoOtrasComis,        SaldoIVAComisi,		ProvisionAcum,			PagareImpreso,
					FechaInhabil,	    CalendIrregular,		DiaPagoInteres,     DiaPagoCapital,		    DiaPagoProd,
					DiaMesInteres,		DiaMesCapital,			AjusFecUlVenAmo,    AjusFecExiVen,		    NumTransacSim,
					FechaMinistrado,	FolioDispersion,		SucursalID,         ValorCAT,			    ClasifRegID,
					MontoComApert,		IVAComApertura,			PlazoID,            TipoDispersion,		    CuentaCLABE,
					TipoCalInteres,		TipoGeneraInteres,		MontoDesemb,        MontoPorDesemb,		    NumAmortInteres,
					AporteCliente,		PorcGarLiq,				MontoSeguroVida,    SeguroVidaPagado,	    ForCobroSegVida,
					ComAperPagado,		ForCobroComAper,		ClasiDestinCred,    CicloGrupo,			    GrupoID,
					TipoPrepago,		SaldoMoraVencido,		SaldoMoraCarVen,    DescuentoSeguro,	    MontoSegOriginal,
					IdenCreditoCNBV,	CobraSeguroCuota,		CobraIVASeguroCuota,MontoSeguroCuota,	    IVASeguroCuota,
					CobraComAnual,		TipoComAnual,			BaseCalculoComAnual,MontoComAnual,		    PorcentajeComAnual,
					DiasGraciaComAnual,	SaldoComAnual,			TipoLiquidacion,    CantidadPagar,		    ComAperCont,
					IVAComAperCont,		ComAperReest,			IVAComAperReest,    FechaAtrasoCapital,	    FechaAtrasoInteres,
				    TipoConsultaSIC,	FolioConsultaBC,		FolioConsultaCC,    EsAgropecuario,		    TipoCancelacion,
					Refinancia,			CadenaProductivaID,		RamaFIRAID,         SubramaFIRAID,		    ActividadFIRAID,
					TipoGarantiaFIRAID,	EstatusGarantiaFIRA,	ProgEspecialFIRAID, FechaCobroComision,	    EsAutomatico,
					TipoAutomatico,		InvCredAut,				CtaCredAut,         AcreditadoIDFIRA,	    CreditoIDFIRA,
					InteresAcumulado,	InteresRefinanciar,		Reacreditado,       TipoComXApertura,	    MontoComXApertura,
					DiasAtrasoMin,		ReferenciaPago,			NivelID,            CobraAccesorios,	    EmpresaID,
					Usuario,			FechaActual,			DireccionIP,        ProgramaID,			    Sucursal,
					NumTransaccion
						FROM CREDITOS AS Amo
						WHERE Amo.CreditoID = Var_CreditoID;

                SELECT Estatus,		FrecuenciaCap,		FrecuenciaInt,		TasaFija,		SucursalID,			TipoCalInteres,
					   (SaldoCapAtrasad+SaldoInterAtras),    IFNULL(SaldoMoratorios+SaldoMoraVencido+SaldoMoraCarVen, Entero_Cero),
                       (IFNULL(SaldComFaltPago, Entero_Cero)+IFNULL(SaldoOtrasComis, Entero_Cero) + IFNULL(SaldoComServGar, Entero_Cero) ),
                       ClienteID,FrecuenciaInt,DiaPagoInteres,DiaMesCapital,PeriodicidadInt,
                       CuentaID,	ProductoCreditoID
                INTO Var_Estatus,	Var_TipoPagoCap,	Var_TipoPagoInt,	Var_TasaFija,	Var_SucursalID,		Var_TipoCalInt,
					 Var_SaldoAtras,					Var_SaldoMora,		Var_SaldoComision,
                     Var_ClienteID,	Var_PagoCuota,		Var_PagoFinAni,		Var_DiaMes,	Var_DiasFrec,
                     Var_CuentaID,	Var_ProductoCreditoID
                FROM CREDITOS
                WHERE CreditoID = Var_CreditoID;


                SET Var_IVA       := (SELECT IFNULL(IVA,Entero_Cero)
											FROM SUCURSALES
											WHERE SucursalID = Var_SucursalID);

                SET Var_IVA		  := IFNULL(Var_IVA,Entero_Cero);

				SELECT TipoDiferimiento,	CantMesesDif,			TasaPreferencial,		CondonaAccesorios,
						CreditoOrigenID
                INTO Var_TipoDiferimiento,	Var_MesesDiferidos,		Var_TasaPreferencial,	Var_CondonaAccesorios,
						Var_CreditoOrigen
                FROM TMPCREDITOSPORDIFERIR
                WHERE CreditoID = Var_CreditoID;

                SET Var_TasaPreferencial := IFNULL(Var_TasaPreferencial,Entero_Cero);

                /* Validacion para creditos que son renovados */
                IF Var_TipoDiferimiento IN ('R') THEN
					SELECT Estatus, ClienteID
                    INTO Var_EstatusPro, Var_ClienteOrigen
                    FROM CREDITOS
                    WHERE CreditoID = Var_CreditoOrigen;

                    IF IFNULL(Var_CreditoOrigen,0) = 0 THEN
                        SET Par_NumErr := 201;
                        SET Par_ErrMen := 'El Credito origen no puede estar vacio';
                        LEAVE PROCESACREDITO;
                    END IF;

                    IF (Var_EstatusPro NOT IN('P')) AND Var_ClienteEsp <> Clien_Crediclub THEN
						SET Par_NumErr := 210;
					    SET Par_ErrMen := 'El Credito origen no esta pagado';
					   LEAVE PROCESACREDITO;
                    END IF;

                    SELECT COUNT(CreditoOrigenID)
                    INTO Var_NumAmortizaciones
                    FROM CREDITOSDIFERIDOS
                    WHERE CreditoOrigenID = Var_CreditoOrigen;

                    IF Var_NumAmortizaciones > 0 THEN
						SET Par_NumErr := 303;
					    SET Par_ErrMen := 'El Credito origen se encuentra ligado a otro credito';
					    LEAVE PROCESACREDITO;
                    END IF;

                    IF Var_ClienteOrigen <> Var_ClienteID THEN
						SET Par_NumErr := 304;
					    SET Par_ErrMen := 'El Cliente del Credito Origen no Coincide con el Cliente del Credito Nuevo';
					    LEAVE PROCESACREDITO;
                    END IF;


					DELETE FROM AMORTICREDITODIFER
						WHERE CreditoID = Var_CreditoID
                        AND AmortizacionID > 1;

					IF( Var_NumeroDiferimientos = Entero_Uno OR Var_FechaValDiferir = Var_FechaAplicacion) THEN
		                SET Var_DiasAtrasoMarzo :=(SELECT DiasAtraso FROM SALDOSCREDITOS where CreditoID = Var_CreditoOrigen AND FechaCorte = FechaCorteVig);
		                SET Var_FechaAjuste := FechaCorteVig;

					ELSE
		                SET Var_DiasAtrasoMarzo :=(SELECT DiasAtraso FROM SALDOSCREDITOS where CreditoID = Var_CreditoOrigen AND FechaCorte = DATE_SUB(Var_FechaSistema, INTERVAL Entero_Uno DAY));
		                SET Var_FechaAjuste := DATE_SUB(Var_FechaSistema, INTERVAL Entero_Uno DAY);

					END IF;

					SET Var_DiasAtrasoMarzo := IFNULL(Var_DiasAtrasoMarzo, Entero_Cero);
					SET Var_DiasDiferidos := Var_DiasAtrasoMarzo;

					UPDATE AMORTICREDITODIFER Amo,SALDOSCREDITOS Sal
						SET Amo.DiasAtraso = Sal.DiasAtraso
					WHERE Sal.CreditoID = Var_CreditoOrigen
                    AND Sal.FechaCorte = Var_FechaAjuste
                    AND Amo.CreditoID = Var_CreditoID;

                    SELECT MIN(FechaExigible)
                    INTO Var_FechaFinPer
                    FROM AMORTICREDITODIFER
                    WHERE CreditoID = Var_CreditoID;

                   SET Var_AmortizacionID	:= 1;

				   SET Par_NumErr := 0;
                   SET Par_ErrMen := 'Credito Vinculado Exitosamente';
				   LEAVE PROCESACREDITO;

				END IF;

                /* Condonacion de accesorios y mora */
                IF (Var_SaldoMora + Var_SaldoComision) > Entero_Cero
					AND Var_CondonaAccesorios = 'S' THEN

                    CALL `CREQUITASPRO`(Var_CreditoID,		Var_UsuarioID,		Var_PuestoCondona,				Var_FechaSistema,		Var_SaldoComision,
										CASE WHEN Var_SaldoComision > Entero_Cero THEN 100 ELSE Entero_Cero END,
                                        Var_SaldoMora,		CASE WHEN Var_SaldoMora > Entero_Cero THEN 100 ELSE Entero_Cero END,
                                        Decimal_Cero,		Decimal_Cero,		Decimal_Cero,		Decimal_Cero,
										Var_PolizaID,		Var_AltaPoliza,		Cons_NO,			Par_NumErr,				Par_ErrMen,
                                        Aud_EmpresaID,		Aud_Usuario ,		Aud_FechaActual,	Aud_DireccionIP, 		Aud_ProgramaID,
                                        Aud_Sucursal,		Aud_NumTransaccion);

					IF Par_NumErr <> Entero_Cero THEN
						SET Par_ErrMen := CONCAT('Error al realizar la Condonacion - (',Par_NumErr,') - ',Par_ErrMen);
						SET Par_NumErr := 5;
						LEAVE PROCESACREDITO;
                    END IF;
                END IF;

				 IF Var_Estatus = Estatus_Vencido OR Var_SaldoAtras > Entero_Cero THEN
					IF (Var_SaldoAtras > Entero_Cero) THEN
						UPDATE AMORTICREDITO
							SET Interes    = SaldoInteresAtr+SaldoInteresVen,
								IVAInteres = ROUND((SaldoInteresAtr+SaldoInteresVen)*Var_IVA,2)
						WHERE CreditoID = Var_CreditoID
						AND Estatus IN ('B','A');
                    END IF;

					/* Se realiza la regularizacion del credito para pasarlo a Vigente */
                    CALL `REGULARIZACREDPRODIFER`(
							Var_CreditoID,		Var_FechaSistema,	Var_AltaPoliza,		Var_PolizaID,		Aud_EmpresaID,
							Cons_NO,			Par_NumErr,			Par_ErrMen, 		Var_ModoPago,		Aud_Usuario ,
							Aud_FechaActual,	Aud_DireccionIP, 	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

					IF Par_NumErr <> Entero_Cero THEN
						SET Var_EstatusPro	:=	Estatus_Error;
						SET Par_ErrMen := CONCAT('Error al realizar la Regularizacion de Credito - (',Par_NumErr,') - ',Par_ErrMen);
						SET Par_NumErr := 5;
						LEAVE PROCESACREDITO;
                    END IF;

                END IF;


				SELECT COUNT(AmortizacionID),	MIN(AmortizacionID)
				INTO Var_NumAmortizaciones,		Var_AmortizacionID
				FROM AMORTICREDITO
				WHERE CreditoID = Var_CreditoID;

                IF  Var_TipoDiferimiento = Tipo_Unico AND Var_NumAmortizaciones > 1 THEN
					SET Par_NumErr := 4;
					SET Par_ErrMen := 'El Crédito no es de Pago Unico, tipo de diferimiento inválido.';

                    LEAVE PROCESACREDITO;
                END IF;

                IF  Var_NumAmortizaciones = 1
                    AND Var_TipoDiferimiento = Tipo_Unico THEN

					-- ------------------------------------------------------------
					-- PROCESO CUANDO ES PÁGO UNICO
                    -- ------------------------------------------------------------
                    SELECT FechaVencim
                    INTO Var_FechaFinOrig
                    FROM AMORTICREDITO
                    WHERE CreditoID = Var_CreditoID
                    AND AmortizacionID = Var_AmortizacionID;

                    IF Var_TipoCalInt = Int_SalInsol THEN
						SELECT SUM(SaldoCapVigente)
						INTO Var_CapitalInsoluto
						FROM AMORTICREDITO
						WHERE CreditoID = Var_CreditoID
						AND Estatus IN ('V','A');
                    ELSE
						SELECT MontoCredito
                        INTO Var_CapitalInsoluto
						FROM CREDITOS
						WHERE CreditoID = Var_CreditoID;
                    END IF;


                    /*ACTUALIZAMOS LAS FECHAS DE TODAS LAS AMORTIZACIONES FUTURAS*/
					UPDATE AMORTICREDITO a SET
						a.FechaVencim		= DATE_ADD(a.FechaVencim, INTERVAL Var_MesesDiferidos MONTH),
						a.FechaExigible		= FNSUMDIASHABIL(a.FechaVencim,Entero_Cero),
                        a.Interes			= a.Interes + ROUND(((Var_CapitalInsoluto * Var_TasaFija * DATEDIFF(a.FechaVencim,Var_FechaFinOrig) ) / (Fre_DiasAnio*100)),2),

                        a.IVAInteres		= ROUND(a.Interes * Var_IVA,2),
						a.NumTransaccion 	= Aud_NumTransaccion
						WHERE
						a.CreditoID 	= Var_CreditoID
						AND a.Estatus 	!= Estatus_Pagado
						AND a.AmortizacionID = Var_AmortizacionID;


                    SET Var_TipoDiferimiento := 'U';
                    SET Var_FechaFinPer := Var_FechaSistema;

                ELSE


                    IF Var_TipoDiferimiento IN (Tipo_Completo,Tipo_TasaPref) THEN
					-- ------------------------------------------------------
					-- PROCESO PARA TODAS LAS AMORTIZACIONES
                    -- ------------------------------------------------------
						SELECT MIN(AmortizacionID),	COUNT(AmortizacionID),	MIN(FechaVencim),		MAX(AmortizacionID)
						INTO Var_AmortizacionID,	Var_NumAmortizaciones,	Var_FechaAntAmortiza,	Var_AmortFin
						FROM AMORTICREDITO
						WHERE CreditoID = Var_CreditoID
						AND Estatus IN ('V','A');


                        CALL `DIFERSIMCALENDARIOPRO`(Var_CreditoID,			Var_AmortizacionID,		Var_AmortFin,			Var_MesesDiferidos,		Var_TipoDiferimiento,
													Cons_NO, 			Par_NumErr,				Par_ErrMen,				Aud_EmpresaID,			Aud_Usuario,
													Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);


                        IF Par_NumErr <> Entero_Cero THEN
							SET Par_ErrMen := CONCAT('Error al ajustar calendario - (',Par_NumErr,') - ',Par_ErrMen);
							SET Par_NumErr := 5;
							LEAVE PROCESACREDITO;
						END IF;

						SELECT FechaVencim INTO Var_FechaExAmortiza
                        FROM AMORTICREDITO
                        WHERE CreditoID = Var_CreditoID
                        AND AmortizacionID = Var_AmortizacionID;



                    END IF;


                     -- Vaidacion de dias en transito
                     SELECT MAX(FechaInicio),		MAX(AmortizacionID)
						INTO Var_FechaAntAmortiza,	Var_NumAmortizaciones
						FROM AMORTICREDITODIFER
						WHERE CreditoID = Var_CreditoID
						AND FechaInicio <= Var_FechaSistema
                        AND Estatus IN ('V','A','B');

					SET  Var_DiasDevengo := DATEDIFF(Var_FechaSistema,Var_FechaAntAmortiza);

                    SELECT MIN(FechaInicio)
						INTO Var_FechaAntAmortiza
						FROM AMORTICREDITO
						WHERE CreditoID = Var_CreditoID
						AND AmortizacionID = Var_NumAmortizaciones;


                    SET Var_FechaFinPer := DATE_ADD(Var_FechaAntAmortiza, INTERVAL Var_DiasDevengo DAY);

                END IF;

                /* Se actualiza la fecha de Vencimiento del Crédito */
                SELECT MAX(FechaVencim)
                INTO Var_FechaFinCre
                FROM AMORTICREDITO
                WHERE CreditoID = Var_CreditoID;

                SELECT FechaVencimien
                INTO Var_FechaFinCreAnt
                FROM CREDITOSDIFER
				WHERE CreditoID = Var_CreditoID
				  AND NumeroDiferimientos = Var_NumeroDiferimientos;

                SET Var_FechaFinCreAnt := DATE_ADD(Var_FechaFinCreAnt,INTERVAL 6 MONTH);
                IF Var_FechaFinCre > Var_FechaFinCreAnt THEN
					SET Par_NumErr := 4;
					SET Par_ErrMen := 'El Diferimiento supera los 6 meses de límite';
                    LEAVE PROCESACREDITO;
                END IF;

                UPDATE CREDITOS SET
					FechaVencimien = Var_FechaFinCre
				WHERE CreditoID = Var_CreditoID;


                /* SE RESPALDA EL CREDITO DE CUALQUIER FORMA AUN SI SU PAGO ES UNICO POR CUALQUIER CONTINGENCIA */
				INSERT INTO AMORTICREDITOPOSTDIFER
					SELECT AmortizacionID,		 	CreditoID,		 			Var_NumeroDiferimientos,	ClienteID,		 			CuentaID,		 			FechaInicio,
							FechaVencim,		 	FechaExigible,		 		Estatus,		 			FechaLiquida,		 		Capital,
							Interes,		 	 	IVAInteres,		 			SaldoCapVigente,			SaldoCapAtrasa,		 		SaldoCapVencido,
							SaldoCapVenNExi,	 	SaldoInteresOrd,		 	SaldoInteresAtr,			SaldoInteresVen,		 	SaldoInteresPro,
							SaldoIntNoConta,	 	SaldoIVAInteres,		 	SaldoMoratorios,			SaldoIVAMorato,		 		SaldoComFaltaPa,
							SaldoIVAComFalP,	 	SaldoComServGar,            SaldoIVAComSerGar,          MontoOtrasComisiones,		MontoIVAOtrasComisiones,
							SaldoOtrasComis,		SaldoIVAComisi,             ProvisionAcum,		 	    SaldoCapital,		 		NumProyInteres,
							SaldoMoraVencido,		SaldoMoraCarVen,            MontoSeguroCuota,	 	    IVASeguroCuota,		 		SaldoSeguroCuota,
							SaldoIVASeguroCuota,	SaldoComisionAnual,         SaldoComisionAnualIVA, 	    0 as SaldoIntPref,			EmpresaID,
							Usuario,		 		FechaActual,                DireccionIP,		 	    ProgramaID, 				Sucursal,
							NumTransaccion
                    FROM AMORTICREDITO AS Amo
						WHERE Amo.CreditoID = Var_CreditoID;

				INSERT INTO CREDITOSPOSTDIFER
					SELECT
					CreditoID,			Var_NumeroDiferimientos,LineaCreditoID,		ClienteID,				CuentaID,				Clabe,
					MonedaID,			ProductoCreditoID,		DestinoCreID,		MontoCredito,			TipoCredito,
					Relacionado,		SolicitudCreditoID,		TipoFondeo,			InstitFondeoID,			LineaFondeo,
					FechaInicio,		FechaInicioAmor,		FechaVencimien,		CalcInteresID,			TasaBase,
					TasaFija,			SobreTasa,				PisoTasa,			TechoTasa,				TipCobComMorato,
					FactorMora,			FrecuenciaCap,			PeriodicidadCap,	FrecuenciaInt,			PeriodicidadInt,
					TipoPagoCapital,	NumAmortizacion,		MontoCuota,			FechTraspasVenc,		FechTerminacion,
					IVAInteres,			IVAComisiones,			Estatus,			FechaAutoriza,			UsuarioAutoriza,
					SaldoCapVigent,		SaldoCapAtrasad,		SaldoCapVencido,	SaldCapVenNoExi,		SaldoInterOrdin,
					SaldoInterAtras,	SaldoInterVenc,			SaldoInterProvi,	SaldoIntNoConta,		SaldoIVAInteres,
					SaldoMoratorios,	SaldoIVAMorator,		SaldComFaltPago,	SalIVAComFalPag,		SaldoComServGar,
					SaldoIVAComSerGar,  SaldoOtrasComis,		SaldoIVAComisi,		ProvisionAcum,			PagareImpreso,
					FechaInhabil,		CalendIrregular,		DiaPagoInteres,     DiaPagoCapital,		    DiaPagoProd,
					DiaMesInteres,		DiaMesCapital,			AjusFecUlVenAmo,    AjusFecExiVen,		    NumTransacSim,
					FechaMinistrado,	FolioDispersion,		SucursalID,         ValorCAT,			    ClasifRegID,
					MontoComApert,		IVAComApertura,			PlazoID,            TipoDispersion,		    CuentaCLABE,
					TipoCalInteres,		TipoGeneraInteres,		MontoDesemb,        MontoPorDesemb,		    NumAmortInteres,
					AporteCliente,		PorcGarLiq,				MontoSeguroVida,    SeguroVidaPagado,	    ForCobroSegVida,
					ComAperPagado,		ForCobroComAper,		ClasiDestinCred,    CicloGrupo,			    GrupoID,
					TipoPrepago,		SaldoMoraVencido,		SaldoMoraCarVen,    DescuentoSeguro,	    MontoSegOriginal,
					IdenCreditoCNBV,	CobraSeguroCuota,		CobraIVASeguroCuota,MontoSeguroCuota,	    IVASeguroCuota,
					CobraComAnual,		TipoComAnual,			BaseCalculoComAnual,MontoComAnual,		    PorcentajeComAnual,
					DiasGraciaComAnual,	SaldoComAnual,			TipoLiquidacion,    CantidadPagar,		    ComAperCont,
					IVAComAperCont,		ComAperReest,			IVAComAperReest,    FechaAtrasoCapital,	    FechaAtrasoInteres,
					TipoConsultaSIC,	FolioConsultaBC,		FolioConsultaCC,    EsAgropecuario,		    TipoCancelacion,
					Refinancia,			CadenaProductivaID,		RamaFIRAID,         SubramaFIRAID,		    ActividadFIRAID,
					TipoGarantiaFIRAID,	EstatusGarantiaFIRA,	ProgEspecialFIRAID, FechaCobroComision,	    EsAutomatico,
					TipoAutomatico,		InvCredAut,				CtaCredAut,     	AcreditadoIDFIRA,	    CreditoIDFIRA,
					InteresAcumulado,	InteresRefinanciar,		Reacreditado,       TipoComXApertura,	    MontoComXApertura,
					DiasAtrasoMin,		ReferenciaPago,			NivelID,            CobraAccesorios,	    EmpresaID,
					Usuario,			FechaActual,			DireccionIP,        ProgramaID,			    Sucursal,
					NumTransaccion
						FROM CREDITOS AS Amo
						WHERE Amo.CreditoID = Var_CreditoID;


				SET Par_NumErr := 0;
                SET Par_ErrMen := 'Credito procesado exitosamente.';
                SET Var_EstatusPro	:=	Estatus_Aplicado;

            END PROCESACREDITO;

            IF Par_NumErr = Entero_Cero THEN

				INSERT INTO CREDITOSDIFERIDOS(
					CreditoID,			NumeroDiferimientos,	FechaAplicacion, 		FechaFinPeriodo, 		CondonaAccesorios,						FechaCorte,
                    MesesDiferidos, 	TipoDiferimiento, 		DiasDiferidos,			TasaPreferencial,		MontoPreferencial,						CreditoOrigenID,
                    AmortizacionID, 	EmpresaID, 				Usuario, 				FechaActual, 			DireccionIP,
                    ProgramaID, 		Sucursal, 				NumTransaccion)
				SELECT
					Var_CreditoID,		Var_NumeroDiferimientos,Var_FechaSistema,		Var_FechaFinPer,		Var_CondonaAccesorios,					FechaCorteVig,
                    Var_MesesDiferidos,	Var_TipoDiferimiento,	Var_DiasAtrasoMarzo,	Var_TasaPreferencial,	IFNULL(Var_InteresPrefe,Entero_Cero),	Var_CreditoOrigen,
					Var_AmortizacionID,	Aud_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion;

                COMMIT;
            ELSE
				ROLLBACK;


				INSERT INTO CREDITOSSINDIFERIR(
					TransaccionID, 		FechaAplicacion, 		CreditoID, 		MesesDiferidos, 		TipoDiferimiento,
					MotivoRechazo, 		EmpresaID, 				Usuario,	 	FechaActual, 			DireccionIP,
					ProgramaID, 		Sucursal, 				NumTransaccion)
				SELECT
					Aud_NumTransaccion,	Var_FechaSistema,		Var_CreditoID,		Var_MesesDiferidos,		Var_TipoDiferimiento,
					Par_ErrMen,			Aud_EmpresaID,			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion;

            END IF;

            SET Var_NumConsecutivo := Var_NumConsecutivo + 1;
        END WHILE;


		SELECT COUNT(*)
        INTO Var_NumDifer
        FROM CREDITOSDIFERIDOS
        WHERE NumTransaccion = Aud_NumTransaccion;

        SELECT COUNT(*)
        INTO Var_NumNoDifer
        FROM CREDITOSSINDIFERIR
        WHERE NumTransaccion = Aud_NumTransaccion;

        SET Var_NumDifer 	:= IFNULL(Var_NumDifer,Entero_Cero);
        SET Var_NumNoDifer 	:= IFNULL(Var_NumNoDifer,Entero_Cero);

		SET	Par_NumErr		:= 000;
		SET	Par_ErrMen		:= CONCAT('Proceso de Diferimiento Terminado Exitosamente.\n Exitosos: ',Var_NumDifer,'\nFallidos: ',Var_NumNoDifer);
		SET Var_Control 	:= 'procesar' ;
		SET Var_Consecutivo	:= Entero_Cero;

        DELETE FROM TMP_CREDITOSDIFERIDX;
        DELETE FROM TMPCREDITOSPORDIFERIR WHERE NumTransaccion =Aud_NumTransaccion;

	END ManejoErrores;

	IF(Par_Salida = SalidaSi) THEN
		SELECT 	Par_NumErr AS NumErr,
		Par_ErrMen AS ErrMen,
		Var_Control AS Control,
		Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$