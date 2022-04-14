-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGPASIVOSFONDEOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGPASIVOSFONDEOPRO`;DELIMITER $$

CREATE PROCEDURE `REGPASIVOSFONDEOPRO`(
	/*SP para el reporte FIRA de Pasivos de FONDEO*/
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

	# Declaracion de Constantes
	DECLARE Cons_No					CHAR(1);			-- Constantes No
	DECLARE Cons_SI					CHAR(1);			-- Constantes Si
	DECLARE Entero_Cero				INT(11);			-- Entero Cero
	DECLARE Cadena_Vacia			VARCHAR(1);			-- Entero Cero
	DECLARE EsAgropecuarioCons		VARCHAR(1);			-- Es Credito Agropecuario
	DECLARE TipoFondeoFinanciado	VARCHAR(1);			-- Tipo de Fondeo Financiado
	DECLARE TipoReporte_PasivoFond	INT(11);			-- ID CATREPORTESFIRA

	# Asignacion de Constantes
	SET Entero_Cero					:= 0;
	SET Cons_No						:= 'N';
	SET Cons_SI						:= 'S';
	SET Cadena_Vacia				:= '';
	SET EsAgropecuarioCons			:= 'S';
	SET TipoFondeoFinanciado		:= 'F';
	SET Aud_FechaActual				:= NOW();
	SET Var_Control					:= 'genera';
	SET TipoReporte_PasivoFond		:= 3;

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-REGPASIVOSFONDEOPRO');
			SET Var_Control := 'sqlException' ;
		END;

		-- Se eliminan los registros de la tabla temporal
		DELETE FROM TEMPREGPASIVOFONDEO WHERE Transaccion = Aud_NumTransaccion;

		SET @cont :=0;
		/*Datos para el reporte de pasivos de fondeo*/
		INSERT INTO TEMPREGPASIVOFONDEO(
			Transaccion,				Consecutivo,		LineaFondeoID,				CapitalVigente,				FinaAdicionalVig,			InteresDev,
			CapitalVencido,				FinaAdicionalVen,	InteresVenc)
			SELECT
			Transaccion,				(@cont:=@cont+1),	LineaFondeo,				CapitalVigente,				FinaAdicionalVig,			InteresDev,
			CapitalVencido,				FinaAdicionalVen,	InteresVenc
			FROM (SELECT
				Aud_NumTransaccion AS Transaccion,
				CRED.LineaFondeo,
				SUM(AMO.SaldoCapVigente) AS CapitalVigente,
				0/*?*/ AS FinaAdicionalVig,
				SUM(AMO.SaldoInteresOrd) AS InteresDev,
				SUM(AMO.SaldoCapVencido) AS CapitalVencido,
				0/*?*/ AS FinaAdicionalVen,
				SUM(AMO.SaldoInteresVen) AS InteresVenc
					FROM
					LINEAFONDEADOR AS LIN LEFT JOIN
					CREDITOS AS CRED ON LIN.LineaFondeoID = CRED.LineaFondeo INNER JOIN
					AMORTICREDITO AS AMO ON CRED.CreditoID = AMO.CreditoID
					WHERE
					(CRED.CreditoID IS NOT NULL AND CRED.TipoFondeo = TipoFondeoFinanciado
					AND CRED.EsAgropecuario=EsAgropecuarioCons
					AND CRED.FechaInicio >= LIN.FechInicLinea
					AND CRED.FechaVencimien <= LIN.FechaMaxVenci)
					OR LIN.LineaFondeoID IS NOT NULL
					GROUP BY CRED.LineaFondeo,Aud_NumTransaccion) AS TEMPORAL;



		-- Se actualizan los datos de auditoria
		UPDATE TEMPREGPASIVOFONDEO SET
			EmpresaID		= Aud_EmpresaID,
			Usuario			= Aud_Usuario,
			FechaActual		= Aud_FechaActual,
			DireccionIP		= Aud_DireccionIP,
			ProgramaID		= Aud_ProgramaID,
			Sucursal		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion
			WHERE Transaccion = Aud_NumTransaccion;

		-- Se eliminan antes los registros generados por el reporte
		DELETE FROM REPMONITOREOFIRA
			WHERE FechaGeneracion = Par_FechaCorte AND TipoReporteID = TipoReporte_PasivoFond;

		SET @cont :=0;
		/*Se inserta el encabezado del reporte*/
		INSERT INTO REPMONITOREOFIRA(
			TipoReporteID,					FechaGeneracion,				ConsecutivoID,				CSVReporte,						EmpresaID,
			Usuario,						FechaActual,					DireccionIP,				ProgramaID,						Sucursal,
			NumTransaccion)
		VALUES(
			TipoReporte_PasivoFond,			Par_FechaCorte,					Entero_Cero,
			CONCAT_WS(',','Tipo','Secuencial',
				'Nombre Institucion',
				'Linea de Credito',
				'Vigencia Linea Credito (DD/MM/YYYY)',
				'Saldo del Pasivo',
				'Capital Vigente',
				'Financiamientos Adicionales Vigentes',
				'Intereses Devengados Vigentes',
				'Capital Vencido',
				'Financiamientos Adicionales Vencidos',
				'Intereses Vencidos'),
			Aud_EmpresaID,
			Aud_Usuario,					Aud_FechaActual,				Aud_DireccionIP,			Aud_ProgramaID,					Aud_Sucursal,
			Aud_NumTransaccion);

		SET @cont2 := Entero_Cero;

		/*Se inserta el contenido del reporte*/
		INSERT INTO REPMONITOREOFIRA(
				TipoReporteID,				FechaGeneracion,				ConsecutivoID,			CSVReporte,						EmpresaID,
				Usuario,					FechaActual,					DireccionIP,			ProgramaID,						Sucursal,
				NumTransaccion)
			SELECT
				TipoReporte_PasivoFond,		Par_FechaCorte,					(@cont2:=@cont2+1),
				CONCAT_WS(',',
					REPLACE(TIP.Descripcion,","," "),
					@cont2,
					REPLACE(INS.NombreInstitFon,","," "),
					LIN.LineaFondeoID,
					DATE_FORMAT(LIN.FechaMaxVenci,'%d/%m/%Y'),
					IF(LIN.SaldoLinea IS NULL OR LIN.SaldoLinea = 0,'',LIN.SaldoLinea),
					IF(CapitalVigente IS NULL OR CapitalVigente = 0, 'N/A',TMP.CapitalVigente),
					IF(FinaAdicionalVig IS NULL OR FinaAdicionalVig = 0, 'N/A',TMP.FinaAdicionalVig),
					IF(InteresDev IS NULL OR InteresDev = 0, 'N/A',TMP.InteresDev),
					IF(CapitalVencido IS NULL OR CapitalVencido = 0, 'N/A',TMP.CapitalVencido),
					IF(FinaAdicionalVen IS NULL OR FinaAdicionalVen = 0, 'N/A',TMP.FinaAdicionalVen),
					IF(InteresVenc IS NULL OR InteresVenc = 0, 'N/A',TMP.InteresVenc)),
				Aud_EmpresaID,
				Aud_Usuario,				Aud_FechaActual,				Aud_DireccionIP,		Aud_ProgramaID,					Aud_Sucursal,
				Aud_NumTransaccion
				FROM
					TIPOSLINEAFONDEA AS TIP LEFT JOIN
					LINEAFONDEADOR AS LIN ON TIP.TipoLinFondeaID = LIN.TipoLinFondeaID LEFT JOIN
					INSTITUTFONDEO AS INS ON LIN.InstitutFondID = INS.InstitutFondID LEFT JOIN
					TEMPREGPASIVOFONDEO AS TMP ON LIN.LineaFondeoID = TMP.LineaFondeoID AND TMP.Transaccion = Aud_NumTransaccion;

		-- Se eliminan los registro de la tabla temporal
		DELETE FROM TEMPREGPASIVOFONDEO WHERE Transaccion = Aud_NumTransaccion;

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