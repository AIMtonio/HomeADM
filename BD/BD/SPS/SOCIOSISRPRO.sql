-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOCIOSISRPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOCIOSISRPRO`;DELIMITER $$

CREATE PROCEDURE `SOCIOSISRPRO`(
# =================================================
# ----------- SP QUE REALIZA CALCULO ISR-----------
# =================================================
	Par_FecActual			DATETIME,
    Par_Salida				CHAR(1),
    Par_tipoCalculo			INT(11),
    Par_Cliente				INT(11),
    Par_Inversion			INT(11),

	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),

	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
    Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
    Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_SalMinAn		DECIMAL(12,2);
	DECLARE Fre_DiasAnio		INT(11);
	DECLARE Var_SalMinDF		DECIMAL(12,2);
	DECLARE Var_DiasInversion	DECIMAL(12,4);
	-- Declaracion de constantes
	DECLARE	Decimal_Cero		DECIMAL(12,2);
	DECLARE Entero_Cien			INT(11);
    DECLARE Entero_Dos			INT(11);
    DECLARE Entero_Cinco		INT(11);
	DECLARE Entero_Cero 		INT(11);
	DECLARE	EstatusBloq			CHAR(1);
	DECLARE	EstatusActi			CHAR(1);
	DECLARE GeneraIntSI     	CHAR(1);
    DECLARE PagaISRSI	     	CHAR(1);
	DECLARE EstatusInvVig    	CHAR(1);
	DECLARE InstrumentoCta     	INT(11);
	DECLARE InstrumentoInv    	INT(11);
	DECLARE DiasAnio			INT(11);
    DECLARE SalidaSI			CHAR(1);
    DECLARE CalculoIndv			INT(11);
    DECLARE CalculoGlobal		INT(11);
    DECLARE InstrumentoCede    	INT(11);

    DECLARE ValorUMA			VARCHAR(15);
	-- Asignacion de constantes
	SET Decimal_Cero			:= 0.00;
	SET Entero_Cien				:= 100;
	SET Entero_Cero				:= 0;
    SET Entero_Dos				:= 2;
    SET Entero_Cinco			:= 5;
	SET	EstatusBloq				:= 'B';
	SET	EstatusActi				:= 'A';
	SET	EstatusInvVig			:= 'N';
	SET GeneraIntSI     		:= 'S';
    SET PagaISRSI   	  		:= 'S';
	SET InstrumentoCta    		:= 2;
	SET InstrumentoInv    		:= 13;
	SET DiasAnio				:= 365;
    SET SalidaSI				:= 'S';
    SET CalculoIndv				:= 1;
    SET CalculoGlobal			:= 2;
    SET InstrumentoCede			:= 28;
	SET @Var_ISR_dia			:= 0.00;
	SET @Var_ISR_total			:= 0.00;
	SET ValorUMA				:= 'ValorUMABase';

    ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT( 'El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										 'esto le ocasiona. Ref: SP-SOCIOSISRPRO');
				END;

		TRUNCATE TOTALESSOCIOS;
		TRUNCATE TMPSOCIOSISR;
		IF (Par_tipoCalculo = CalculoIndv) THEN
			INSERT INTO TMPSOCIOSISR(
							Instrumento,	TipoInstrumentoID,	ClienteID,  	Saldo,		TasaISR)
				SELECT 		CA.CuentaAhoID, InstrumentoCta,		CA.ClienteID,	CA.Saldo,	SU.TasaISR
					FROM 	CUENTASAHO		CA,
							CLIENTES		Cli,
							TIPOSCUENTAS	TiCta,
							SUCURSALES		SU
					WHERE	(CA.Estatus 		= EstatusBloq
					OR		CA.Estatus 			= EstatusActi)
					AND 	CA.ClienteID  		= Cli.ClienteID
					AND 	CA.TipoCuentaID 	= TiCta.TipoCuentaID
					AND 	Cli.SucursalOrigen 	= SU.SucursalID
					AND 	TiCta.GeneraInteres = GeneraIntSI
					AND  	Cli.PagaISR			= PagaISRSI
					AND 	CA.ClienteID 		= Par_Cliente;


			INSERT INTO TMPSOCIOSISR(
							Instrumento,	TipoInstrumentoID,		ClienteID,  	Saldo,		TasaISR )
				SELECT		I.InversionID,	InstrumentoInv, 		I.ClienteID,	I.Monto,	SU.TasaISR
					FROM	INVERSIONES I, CLIENTES Cli,SUCURSALES		SU
					WHERE	I.Estatus		= EstatusInvVig
					AND  	Cli.ClienteID	= I.ClienteID
					AND 	Cli.PagaISR		= PagaISRSI
					AND 	SU.SucursalID	= Cli.SucursalOrigen
					AND 	I.ClienteID 	= Par_Cliente;



			INSERT INTO TMPSOCIOSISR(
							Instrumento,	TipoInstrumentoID,		ClienteID,  	Saldo,		TasaISR )
				SELECT		C.CedeID,		InstrumentoCede, 		C.ClienteID,	C.Monto,	SU.TasaISR
					FROM	CEDES C, CLIENTES Cli,SUCURSALES SU
					WHERE	C.Estatus		= EstatusInvVig
					AND  	Cli.ClienteID	= C.ClienteID
					AND 	Cli.PagaISR		= PagaISRSI
					AND 	SU.SucursalID	= Cli.SucursalOrigen
					AND 	C.ClienteID 	= Par_Cliente;



			INSERT INTO TOTALESSOCIOS (
							ClienteID,	Total)
				SELECT 		ClienteID,	SUM(Saldo)
					FROM 	TMPSOCIOSISR
					GROUP BY ClienteID ;


			UPDATE TMPSOCIOSISR TISR,TOTALESSOCIOS TOTSO SET
						TISR.Saldo_total = total
				WHERE   TISR.ClienteID	 = TOTSO.ClienteID;

            SELECT  	DiasInversion,	SalMinDF
				INTO	Fre_DiasAnio,	Var_SalMinDF
				FROM 	PARAMETROSSIS;

			SET Var_SalMinDF	:= IFNULL(Var_SalMinDF , Decimal_Cero);
			SET Fre_DiasAnio 	:= IFNULL(Fre_DiasAnio , Entero_Cero);
			SET Var_SalMinAn 	:= Var_SalMinDF * Entero_Cinco * DiasAnio;

			/* Cuando sea persona moral siempre se le debe retener ISR sobre el monto total sin contemplar exencion alguna. */
			UPDATE TMPSOCIOSISR TCli
				LEFT JOIN CLIENTES cli
				ON TCli.ClienteID = cli.ClienteID SET
				TCli.ISR_total = CASE WHEN   TCli.Saldo_total> Var_SalMinAn OR cli.TipoPersona = 'M' THEN
											CASE WHEN cli.TipoPersona = 'M' THEN
												ROUND((TCli.Saldo_total  *TCli.TasaISR   ) / (Entero_Cien * Fre_DiasAnio), Entero_Dos)
											ELSE
												ROUND(((TCli.Saldo_total  -Var_SalMinAn )  *TCli.TasaISR   ) / (Entero_Cien * Fre_DiasAnio), Entero_Dos)
											END
										ELSE Decimal_Cero END ;

			UPDATE 	TMPSOCIOSISR TCli, INVERSIONES I SET
						TCli.ISR_dia = CASE WHEN TCli.ISR_total > Entero_Cero
											THEN
												@Var_ISR_dia:=ROUND(((TCli.ISR_total)/Saldo_total )	*(TCli.Saldo  ),Entero_Dos)
											ELSE
												@Var_ISR_dia:=Decimal_Cero
											END,
						I.ISRReal				= I.ISRReal+@Var_ISR_dia
				WHERE	TCli.Instrumento		= I.InversionID
				AND     TCli.TipoInstrumentoID	= InstrumentoInv
				AND 	TCli.Instrumento		= Par_Inversion;
			UPDATE 	TMPSOCIOSISR TCli, CEDES C SET
						TCli.ISR_dia = CASE WHEN TCli.ISR_total > Entero_Cero
											THEN
												  @Var_ISR_dia:=ROUND(((TCli.ISR_total)/Saldo_total )	*(TCli.Saldo  ),Entero_Dos)
											ELSE
												  @Var_ISR_dia:=Decimal_Cero
											END,
						C.ISRReal				= C.ISRReal+@Var_ISR_dia
				WHERE	TCli.Instrumento		= C.CedeID
				AND     TCli.TipoInstrumentoID	= InstrumentoCede
				AND 	TCli.Instrumento		= Par_Inversion;


			INSERT INTO CLIENTESISR  (
						FechaSistema,			 ClienteID, 		TipoInstrumentoID, 		InstrumentoID, 		SaldoDiario,
						SaldoAcumulado,
						Exedente,
						ISR_dia,
						EmpresaID,
						Usuario,
						FechaActual, 	 		 DireccionIP, 		ProgramaID, 			Sucursal, 			NumTransaccion)
				SELECT	Par_FecActual,			 T.ClienteID,		T.TipoInstrumentoID,	T.Instrumento,		IFNULL(T.Saldo,Decimal_Cero),
						IFNULL(T.Saldo_total,Decimal_Cero),
						IFNULL( (T.Saldo_total-Var_SalMinAn),Decimal_Cero),
						IFNULL(T.ISR_dia,Decimal_Cero),
						Aud_EmpresaID,
						Aud_Usuario,
						Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion
					FROM 	TMPSOCIOSISR T
                    WHERE 	T.Instrumento	= Par_Inversion;

            SET Par_NumErr := 0;
			SET Par_ErrMen := 'EXITO';

		ELSE

			INSERT INTO TMPSOCIOSISR(
							Instrumento,	TipoInstrumentoID ,		ClienteID,  	Saldo ,		TasaISR )
				SELECT 		CA.CuentaAhoID, InstrumentoCta,			CA.ClienteID,	CA.Saldo,	SU.TasaISR
					FROM	CUENTASAHO		CA,
							CLIENTES		Cli,
							TIPOSCUENTAS	TiCta,
							SUCURSALES		SU
					WHERE	(CA.Estatus 			= EstatusBloq
					OR		CA.Estatus 			= EstatusActi)
					AND 	CA.ClienteID  		= Cli.ClienteID
					AND 	CA.TipoCuentaID 	= TiCta.TipoCuentaID
					AND 	Cli.SucursalOrigen 	= SU.SucursalID
					AND 	TiCta.GeneraInteres = GeneraIntSI
					AND  	Cli.PagaISR			= PagaISRSI;


			INSERT INTO TMPSOCIOSISR(
							Instrumento,	TipoInstrumentoID ,		ClienteID,  	Saldo,		TasaISR )
				SELECT  	I.InversionID,	InstrumentoInv, 		I.ClienteID,	I.Monto,	SU.TasaISR
					FROM	INVERSIONES I, CLIENTES Cli,SUCURSALES		SU
					WHERE	I.Estatus		= EstatusInvVig
					AND  	Cli.ClienteID	= I.ClienteID
					AND 	Cli.PagaISR		= PagaISRSI
                    AND 	SU.SucursalID	= Cli.SucursalOrigen;

			INSERT INTO TMPSOCIOSISR(
							Instrumento,	TipoInstrumentoID,		ClienteID,  	Saldo,		TasaISR )
				SELECT		C.CedeID,		InstrumentoCede, 		C.ClienteID,	C.Monto,	SU.TasaISR
					FROM	CEDES C, CLIENTES Cli,SUCURSALES SU
					WHERE	C.Estatus		= EstatusInvVig
					AND  	Cli.ClienteID	= C.ClienteID
					AND 	Cli.PagaISR		= PagaISRSI
					AND 	SU.SucursalID	= Cli.SucursalOrigen;


			INSERT INTO TOTALESSOCIOS (
							ClienteID,	Total)
				SELECT 		ClienteID,	SUM(Saldo)
					FROM 	TMPSOCIOSISR
					GROUP BY ClienteID ;


			UPDATE TMPSOCIOSISR TISR,TOTALESSOCIOS TOTSO SET
						TISR.Saldo_total = total
				WHERE   TISR.ClienteID	 = TOTSO.ClienteID;

			SELECT  	DiasInversion,	SalMinDF
						INTO Fre_DiasAnio,	Var_SalMinDF
				FROM 	PARAMETROSSIS;

		SELECT ValorParametro
			INTO Var_DiasInversion
			FROM PARAMGENERALES
		WHERE LlaveParametro=ValorUMA;


			SET Var_SalMinDF	:= IFNULL(Var_SalMinDF , Decimal_Cero);
			SET Fre_DiasAnio 	:= IFNULL(Fre_DiasAnio , Entero_Cero);
			SET Var_SalMinAn 	:= Var_SalMinDF * Entero_Cinco * Var_DiasInversion;

			/* Cuando sea persona moral siempre se le debe retener ISR sobre el monto total sin contemplar exencion alguna. */
			UPDATE TMPSOCIOSISR TCli
				LEFT JOIN CLIENTES cli
				ON TCli.ClienteID = cli.ClienteID SET
				TCli.ISR_total = CASE WHEN   TCli.Saldo_total> Var_SalMinAn OR cli.TipoPersona = 'M' THEN
										CASE WHEN cli.TipoPersona = 'M' THEN
												ROUND((TCli.Saldo_total  *TCli.TasaISR   ) / (Entero_Cien * Fre_DiasAnio), Entero_Dos)
											ELSE
												ROUND(((TCli.Saldo_total  -Var_SalMinAn )  *TCli.TasaISR   ) / (Entero_Cien * Fre_DiasAnio), Entero_Dos)
											END
									ELSE Decimal_Cero END ;

			UPDATE 	TMPSOCIOSISR TCli,CUENTASAHO CH SET
						TCli.ISR_dia =   CASE WHEN    TCli.ISR_total > Entero_Cero THEN
												@Var_ISR_dia:=ROUND(( (TCli.ISR_total)/Saldo_total )	*(TCli.Saldo  ),Entero_Dos)
											ELSE
											@Var_ISR_dia:=Decimal_Cero END,
						CH.ISRReal 	  =	CH.ISRReal+@Var_ISR_dia
				WHERE	TCli.Instrumento		=	CH.CuentaAhoID
				AND 	TCli.TipoInstrumentoID	=	InstrumentoCta;


			UPDATE 	TMPSOCIOSISR TCli, INVERSIONES I SET
						TCli.ISR_dia =  CASE WHEN    TCli.ISR_total > Entero_Cero
													THEN
														@Var_ISR_dia:=ROUND(((TCli.ISR_total)/Saldo_total )	*(TCli.Saldo  ),Entero_Dos)
													ELSE
													@Var_ISR_dia:=Decimal_Cero
												END,
						I.ISRReal				= I.ISRReal+@Var_ISR_dia
				WHERE	TCli.Instrumento		= I.InversionID
				AND     TCli.TipoInstrumentoID	= InstrumentoInv;

			UPDATE 	TMPSOCIOSISR TCli, CEDES C SET
						TCli.ISR_dia = CASE WHEN TCli.ISR_total > Entero_Cero
											THEN
												  @Var_ISR_dia:=ROUND(((TCli.ISR_total)/Saldo_total )	*(TCli.Saldo  ),Entero_Dos)
											ELSE
												  @Var_ISR_dia:=Decimal_Cero
											END,
						C.ISRReal				= C.ISRReal+@Var_ISR_dia
				WHERE	TCli.Instrumento		= C.CedeID
				AND     TCli.TipoInstrumentoID	= InstrumentoCede;



			INSERT INTO CLIENTESISR  (
						FechaSistema,			 ClienteID, 		TipoInstrumentoID, 		InstrumentoID, 		SaldoDiario,
						SaldoAcumulado,
						Exedente,
						ISR_dia,
						EmpresaID,
						Usuario,
						FechaActual, 	 		 DireccionIP, 		ProgramaID, 			Sucursal, 			NumTransaccion)
				SELECT 	Par_FecActual,			 T.ClienteID,	T.TipoInstrumentoID,		T.Instrumento,		IFNULL(T.Saldo,Decimal_Cero),
						IFNULL(T.Saldo_total,Decimal_Cero),
						IFNULL( (T.Saldo_total-Var_SalMinAn),Decimal_Cero),
						IFNULL(T.ISR_dia,Decimal_Cero),
						Aud_EmpresaID,
						Aud_Usuario,
						Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion
					FROM TMPSOCIOSISR T;
			SET Par_NumErr := 0;
			SET Par_ErrMen := 'EXITO';

		END IF;

		TRUNCATE TOTALESSOCIOS;
		TRUNCATE TMPSOCIOSISR;

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen;
	END IF;
END TerminaStore$$