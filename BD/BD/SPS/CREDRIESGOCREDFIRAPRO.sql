-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDRIESGOCREDFIRAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDRIESGOCREDFIRAPRO`;DELIMITER $$

CREATE PROCEDURE `CREDRIESGOCREDFIRAPRO`(
	/*SP para el reporte de fira de Riesgo de Crédito*/
	Par_FechaCorte					DATE,				# Fecha de Corte para generar el reporte
	Par_Salida						CHAR(1),			# Tipo de Salida S. Si N. No
	INOUT	Par_NumErr				INT(11),			# Numero de Error
	INOUT	Par_ErrMen				VARCHAR(400),		# Mensaje de Error

	/* Parametros de Auditoria */
	Aud_EmpresaID					INT(11),			# Auditoria
	Aud_Usuario						INT(11),			# Auditoria
	Aud_FechaActual					DATETIME,			# Auditoria
	Aud_DireccionIP					VARCHAR(15),		# Auditoria

	Aud_ProgramaID					VARCHAR(50),		# Auditoria
	Aud_Sucursal					INT(11),			# Auditoria
	Aud_NumTransaccion				BIGINT(20)			# Auditoria
)
TerminaStore: BEGIN
	# Declaracion de Variables
	DECLARE Var_FechaSis			DATE;				-- Fecha del sistema
	DECLARE Var_Control				VARCHAR(50);		-- Variable para el ID del control de pantalla
	DECLARE FechaSist				DATE;
	DECLARE Var_UltEjercicioCie		INT(11);
	DECLARE Var_UltPeriodoCie		INT(11);
    DECLARE Var_FechaFinPeriodo		DATE;
    DECLARE Var_MontoCarVig			DECIMAL(14,2);
    DECLARE Var_MontoCarVen			DECIMAL(14,2);
    DECLARE Var_Cajas				DECIMAL(14,2);
    DECLARE Var_Bancos				DECIMAL(14,2);
    DECLARE Var_CajasMicro			DECIMAL(14,2);
    DECLARE Var_TituloNeg			DECIMAL(14,2);

	# Declaracion de Constantes
	DECLARE Cons_No					CHAR(1);			-- Constantes No
	DECLARE Cons_SI					CHAR(1);			-- Constantes Si
	DECLARE Entero_Cero				INT(11);			-- Entero Cero
	DECLARE Cadena_Vacia			VARCHAR(1);			-- Entero Cero
    DECLARE Fecha_Vacia				DATE;				-- Fecha Vacia
	DECLARE EsAgropecuarioCons		VARCHAR(1);			-- Es Credito Agropecuario
	DECLARE TipoFondeoFinanciado	VARCHAR(1);			-- Tipo de Fondeo Financiado
	DECLARE TipoReporte_RelCred		INT(11);			-- ID CATREPORTESFIRA
	DECLARE Var_OperOtrasFuenE14	DECIMAL(18,2);
	DECLARE Var_Fila8CeldaD			DECIMAL(18,2);
	DECLARE Var_TotalSaldoInsoluto	DECIMAL(18,2);
	DECLARE MaxAudTransaccion 		BIGINT(20);
    DECLARE Con_Periodo				CHAR(1);
    DECLARE Con_Pesos				CHAR(1);
	DECLARE Est_Cerrado				CHAR(1);
    DECLARE PorcGarantia			DECIMAL(18,2);
	# Asignacion de Constantes
	SET Entero_Cero					:= 0;
    SET Fecha_Vacia					:= '1900-01-01';
	SET Cons_No						:= 'N';
	SET Cons_SI						:= 'S';
	SET Cadena_Vacia				:= '';
	SET EsAgropecuarioCons			:= 'S';
	SET TipoFondeoFinanciado		:= 'F';
	SET Aud_FechaActual				:= NOW();
	SET Var_Control					:= 'genera';
	SET TipoReporte_RelCred			:= 9;
    SET Con_Periodo					:= 'P';
    SET Con_Pesos					:= 'P';
    SET Est_Cerrado					:= 'C';


	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CREDRIESGOCREDFIRAPRO');
			SET Var_Control := 'sqlException' ;
		END;
		SET FechaSist := (SELECT FechaSistema FROM PARAMETROSSIS);
		-- Se eliminan antes los registros generados por el reporte
		DELETE FROM REPMONITOREOFIRA
			WHERE FechaGeneracion = Par_FechaCorte AND TipoReporteID = TipoReporte_RelCred;

		SET @cont :=0;

		/*Se inserta el encabezado del reporte*/
		INSERT INTO REPMONITOREOFIRA(
			TipoReporteID,					FechaGeneracion,				ConsecutivoID,				CSVReporte,						EmpresaID,
			Usuario,						FechaActual,					DireccionIP,				ProgramaID,						Sucursal,
			NumTransaccion)
		VALUES(
			TipoReporte_RelCred,			Par_FechaCorte,					@cont,						CONCAT_WS(',',
																										'#','GRUPO','CONCEPTO','OPERACIONES FONDEO FIRA',
																										'OPERACIONES OTRAS FUENTES DE FONDEO','OPERACIONES NO ELEGIBLES FIRA'),
																																		Aud_EmpresaID,
			Aud_Usuario,					Aud_FechaActual,				Aud_DireccionIP,			Aud_ProgramaID,					Aud_Sucursal,
			Aud_NumTransaccion);

		DELETE FROM TMPREPFIRARIESGOCRED WHERE TransaccionID = Aud_NumTransaccion;

		INSERT INTO TMPREPFIRARIESGOCRED(
			TransaccionID,		Numero,			EmpresaID,			Usuario,		FechaActual,
			DireccionIP,		ProgramaID,		Sucursal,			NumTransaccion)
			SELECT
			Aud_NumTransaccion,	Numero,			Aud_EmpresaID,		Aud_Usuario,	NOW(),
			Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion
			FROM CATREPFIRARIESGOCRED;

		IF(Par_FechaCorte<FechaSist) THEN
			SET Var_OperOtrasFuenE14 := IFNULL((SELECT SUM(CRED.SalCapVigente + CRED.SalCapAtrasado + CRED.SalCapVencido + CRED.SalCapVenNoExi)
				FROM SALDOSCREDITOS AS CRED
				INNER JOIN CREDITOS AS CC ON CRED.CreditoID = CC.CreditoID
				INNER JOIN SOLICITUDCREDITO AS SOL ON CC.SolicitudCreditoID = SOL.SolicitudCreditoID
				WHERE CC.EsAgropecuario = 'S' AND
				CRED.InstitFondeoID != 1 AND
				SOL.TipoGarantiaFIRAID>0 AND
				CC.Estatus IN ('V','B','K') AND CRED.FechaCorte = Par_FechaCorte),0);
		  ELSE
			SET Var_OperOtrasFuenE14 := (SELECT SUM(CRED.SaldoCapVigent + CRED.SaldoCapVencido + CRED.SaldoCapAtrasad + CRED.SaldCapVenNoExi)
				FROM CREDITOS AS CRED INNER JOIN SOLICITUDCREDITO AS SOL ON CRED.SolicitudCreditoID = SOL.SolicitudCreditoID
				WHERE CRED.EsAgropecuario = 'S' AND
				CRED.InstitFondeoID != 1 AND
				SOL.TipoGarantiaFIRAID>0 AND CRED.Estatus IN ('V','B','K'));
		END IF;

		SET MaxAudTransaccion := (SELECT MAX(TransaccionID) FROM TMPCALCARTERAFIRA2);


		SELECT SUM(CAL.SaldoInsolutoIfAcre * (CAL.GarantiaEfectivaFEGA/100)),	SUM(CAL.SaldoInsolutoIfAcre)
			INTO
			Var_Fila8CeldaD,			Var_TotalSaldoInsoluto
			FROM TMPCALCARTERAFIRA2 AS CAL ;


		SET Var_Fila8CeldaD 			:= IFNULL(Var_Fila8CeldaD,0.0);
		SET Var_TotalSaldoInsoluto 		:= IFNULL(Var_TotalSaldoInsoluto,0.0);

		UPDATE TMPREPFIRARIESGOCRED AS TMP SET
			TMP.OperFonFira = Var_Fila8CeldaD
			WHERE TMP.Numero = 8;

		UPDATE TMPREPFIRARIESGOCRED AS TMP SET
			TMP.OperFonFira = IFNULL(Var_TotalSaldoInsoluto - Var_Fila8CeldaD,0)
			WHERE TMP.Numero = 13;

		UPDATE TMPREPFIRARIESGOCRED AS TMP SET
			TMP.OperOtrasFuen = IFNULL(Var_OperOtrasFuenE14,0)
			WHERE TMP.Numero = 13;

		-- ==================== SE OBTIENEN LOS DATOS DEL BALANCE CONTABLE ==========================

		SELECT  MAX(EjercicioID) INTO Var_UltEjercicioCie
				FROM PERIODOCONTABLE Per
				WHERE Per.Fin   <= Par_FechaCorte
				  AND Per.Estatus = Est_Cerrado;


		SET Var_UltEjercicioCie    := IFNULL(Var_UltEjercicioCie, Entero_Cero);

        SELECT  MAX(PeriodoID) INTO Var_UltPeriodoCie
            FROM PERIODOCONTABLE Per
            WHERE Per.EjercicioID   = Var_UltEjercicioCie
              AND Per.Estatus = Est_Cerrado
              AND Per.Fin   <= Par_FechaCorte;

		SET Var_UltPeriodoCie    := IFNULL(Var_UltPeriodoCie, Entero_Cero);

         SELECT  MAX(Fin) INTO Var_FechaFinPeriodo
            FROM PERIODOCONTABLE Per
            WHERE Per.EjercicioID   = Var_UltEjercicioCie
              AND Per.PeriodoID 	= Var_UltPeriodoCie;

		SET Var_FechaFinPeriodo    := IFNULL(Var_FechaFinPeriodo, Fecha_Vacia);

        # SE OBTIENEN LOS DATOS DEL BALANCE CONTABLE PARA LA CARTERA VIGENTE Y VENCIDA
         CALL BALANCERIESGOEVAL(
			Var_UltEjercicioCie,	Var_UltPeriodoCie,	 	Var_FechaFinPeriodo,	Con_Periodo,		Cons_SI,
			Con_Pesos,	 			Entero_Cero,			Entero_Cero,			Var_MontoCarVig,	Var_MontoCarVen,
			Aud_EmpresaID,			Aud_Usuario,			Aud_FechaActual,  	 	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,			Aud_NumTransaccion	);

		# SE OBTIENEN LOS DATOS DEL BALANCE CONTABLE PARA DISPONIBILIDADES
        CALL BALANCEDISPEVAL(
			Var_UltEjercicioCie,	Var_UltPeriodoCie,	 	Var_FechaFinPeriodo,	Con_Periodo,		Cons_SI,
			Con_Pesos,	 			Entero_Cero,			Entero_Cero,			Var_Cajas,			Var_Bancos,
            Var_CajasMicro,			Var_TituloNeg,			Aud_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
            Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion	);


		UPDATE TMPREPFIRARIESGOCRED AS TMP SET
			TMP.OperNoLegibles = IFNULL(Var_MontoCarVig+Var_MontoCarVen,0)
			WHERE TMP.Numero = 13;

		UPDATE TMPREPFIRARIESGOCRED AS TMP SET
			TMP.OperOtrasFuen = IFNULL(Var_Cajas+Var_Bancos+Var_CajasMicro,0)
			WHERE TMP.Numero = 1;

		UPDATE TMPREPFIRARIESGOCRED AS TMP SET
			TMP.OperOtrasFuen = IFNULL(Var_TituloNeg,0)
			WHERE TMP.Numero = 10;
 -- ==================== FIN DATOS BALANCE CONTABLE ==================================

		/*Se inserta el contenido del reporte*/
		INSERT INTO REPMONITOREOFIRA(
				TipoReporteID,				FechaGeneracion,				ConsecutivoID,			CSVReporte,						EmpresaID,
				Usuario,					FechaActual,					DireccionIP,			ProgramaID,						Sucursal,
				NumTransaccion)
		SELECT
			DISTINCT
			TipoReporte_RelCred,
			Par_FechaCorte,
			@cont:=@cont+1,
			CONCAT_WS(",",
					TT.Numero,			CAT.GrupoID,		CAT.Concepto,	IFNULL(TT.OperFonFira,0),			IFNULL(TT.OperOtrasFuen,0),
					IFNULL(TT.OperNoLegibles,0)),
			Aud_EmpresaID,
			Aud_Usuario,
			Aud_FechaActual,
			Aud_DireccionIP,
			Aud_ProgramaID,
			Aud_Sucursal,
			Aud_NumTransaccion
			FROM
				TMPREPFIRARIESGOCRED AS TT INNER JOIN
				CATREPFIRARIESGOCRED AS CAT ON TT.Numero = CAT.Numero
				WHERE TransaccionID = Aud_NumTransaccion;


		TRUNCATE TMPREPFIRARIESGOCRED;

		SET Par_NumErr	:= 00;
		SET Par_ErrMen	:='Informacion Generada Exitosamente.';
	END ManejoErrores;

	IF(Par_Salida='S')THEN
		SELECT	Par_NumErr AS NumErr,
		Par_ErrMen AS ErrMen,
		Par_FechaCorte AS Consecutivo,
		Var_Control AS Control;
	END IF;

END TerminaStore$$