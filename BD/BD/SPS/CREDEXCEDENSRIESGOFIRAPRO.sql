-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDEXCEDENSRIESGOFIRAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDEXCEDENSRIESGOFIRAPRO`;DELIMITER $$

CREATE PROCEDURE `CREDEXCEDENSRIESGOFIRAPRO`(
	/*SP para el reporte de fira de Excendetes de Riesgo Común*/
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
	DECLARE Decimal_Cero			DOUBLE(14,2);		-- Decimal Cero
	DECLARE Cadena_Vacia			VARCHAR(1);			-- Entero Cero
	DECLARE EsAgropecuarioCons		VARCHAR(1);			-- Es Credito Agropecuario
	DECLARE TipoFondeoFinanciado	VARCHAR(1);			-- Tipo de Fondeo Financiado
	DECLARE TipoReporte_RelCred		INT(11);			-- ID CATREPORTESFIRA

	# Asignacion de Constantes
	SET Entero_Cero					:= 0;
    SET Decimal_Cero				:=0.0;
	SET Cons_No						:= 'N';
	SET Cons_SI						:= 'S';
	SET Cadena_Vacia				:= '';
	SET EsAgropecuarioCons			:= 'S';
	SET TipoFondeoFinanciado		:= 'F';
	SET Aud_FechaActual				:= NOW();
	SET Var_Control					:= 'genera';
	SET TipoReporte_RelCred			:= 8;

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CREDEXCEDENSRIESGOFIRAPRO');
			SET Var_Control := 'sqlException' ;
		END;

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
			TipoReporte_RelCred,			Par_FechaCorte,					@cont,						CONCAT_WS(',','Nombre o ID del grupo de Identificador de riesgo comun',
																											'Nombre de personas integrantes',
																											'Tipo de persona',
																											'RFC',
																											'CURP',
																											'ID acreditado (asignado por el IFNB)',
																											'Saldo insoluto por integrante del Grupo',
                                                                                                            'Saldo Insoluto por grupo'),
																																		Aud_EmpresaID,
			Aud_Usuario,					Aud_FechaActual,				Aud_DireccionIP,			Aud_ProgramaID,					Aud_Sucursal,
			Aud_NumTransaccion);

        /*Se inserta el contenido del reporte*/
		INSERT INTO REPMONITOREOFIRA(
				TipoReporteID,				FechaGeneracion,				ConsecutivoID,			CSVReporte,						EmpresaID,
				Usuario,					FechaActual,					DireccionIP,			ProgramaID,						Sucursal,
				NumTransaccion)
		SELECT
			TipoReporte_RelCred,
			Par_FechaCorte,
			@cont:=@cont+1,
			CONCAT_WS(",",RiesgoID, NombreIntegrante, TipoPersona, RFC, CURP, ClienteID,
			ROUND(SaldoIntegrante,2), ROUND(SaldoGrupal,2)),
			Aud_EmpresaID,
			Aud_Usuario,
			Aud_FechaActual,
			Aud_DireccionIP,
			Aud_ProgramaID,
			Aud_Sucursal,
			Aud_NumTransaccion
			FROM EXCEDENTESGRUPOSRIESGO
            WHERE Fecha = Par_FechaCorte;



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