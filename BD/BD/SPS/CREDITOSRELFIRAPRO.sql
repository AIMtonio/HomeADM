-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOSRELFIRAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOSRELFIRAPRO`;
DELIMITER $$


CREATE PROCEDURE `CREDITOSRELFIRAPRO`(
	/*SP para obtener la informacion de los Creditos Relacionados*/
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
	DECLARE NREG					INT(11);

	# Declaracion de Constantes
	DECLARE Cons_No					CHAR(1);			-- Constantes No
	DECLARE Cons_SI					CHAR(1);			-- Constantes Si
	DECLARE Entero_Cero				INT(11);			-- Entero Cero
	DECLARE Cadena_Vacia			VARCHAR(1);			-- Entero Cero
	DECLARE EsAgropecuarioCons		VARCHAR(1);			-- Es Credito Agropecuario
	DECLARE TipoFondeoFinanciado	VARCHAR(1);			-- Tipo de Fondeo Financiado
	DECLARE TipoReporte_RelCred		INT(11);			-- ID CATREPORTESFIRA
	DECLARE FechaInicial			DATE;

	# Asignacion de Constantes
	SET Entero_Cero					:= 0;
	SET Cons_No						:= 'N';
	SET Cons_SI						:= 'S';
	SET Cadena_Vacia				:= '';
	SET EsAgropecuarioCons			:= 'S';
	SET TipoFondeoFinanciado		:= 'F';
	SET Aud_FechaActual				:= NOW();
	SET Var_Control					:= 'genera';
	SET TipoReporte_RelCred			:= 7;

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CREDITOSRELFIRAPRO');
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
			TipoReporte_RelCred,			Par_FechaCorte,					@cont,						CONCAT_WS(',','Nombre del acreditado',
																											'Tipo de persona',
																											'RFC',
																											'CURP',
																											'ID acreditado (asignado por el IFNB)',
																											'Saldo insoluto total por acreditado',
																											'Monto del saldo que disminuye capital neto',
																											'% asociado de acciones'),
																																		Aud_EmpresaID,
			Aud_Usuario,					Aud_FechaActual,				Aud_DireccionIP,			Aud_ProgramaID,					Aud_Sucursal,
			Aud_NumTransaccion);


		DROP TABLE IF EXISTS TMPTOTALACCIONESFIRA;
		CREATE TEMPORARY TABLE TMPTOTALACCIONESFIRA
			SELECT RelacionadoID AS ClienteID, SUM(IFNULL(PorcAcciones,0)) AS PorcAcciones
			FROM RELACIONEMPLEADO AS REL
			INNER JOIN RELACIONPERSONAS AS RELA ON REL.EmpleadoID = RELA.PersonaID
			GROUP BY REL.RelacionadoID;

		SET NREG := (SELECT COUNT(*) FROM TMPTOTALACCIONESFIRA);

		-- Creditos que estan relacionados.
		DROP TABLE IF EXISTS TMPCREDITOSREL;
		CREATE TEMPORARY TABLE TMPCREDITOSREL (
			ClienteID	int(11),
			CreditoID	bigint(12),
            Estatus		char(1),
			INDEX (ClienteID),
			INDEX (CreditoID)
		);


		INSERT INTO TMPCREDITOSREL (ClienteID, CreditoID, Estatus)
			SELECT Cre.ClienteID, Cre.CreditoID, Cre.Estatus
			FROM CREDITOS Cre
			INNER JOIN TMPTOTALACCIONESFIRA Tmp ON Cre.ClienteID = Tmp.ClienteID
			WHERE Cre.EsAgropecuario = 'S';


		SET FechaInicial := (DATE_SUB(Par_FechaCorte, INTERVAL 1 DAY));

	 -- Creditos que tengan registro en SALDOS CREDITOS
		DROP TABLE IF EXISTS TMPSALDOSCREDITOSREL;
		CREATE TEMPORARY TABLE TMPSALDOSCREDITOSREL (
			ClienteID	int(11),
			CreditoID	bigint(12),
			FechaCorte date,
			Saldo decimal(14,2),
			INDEX (CreditoID),
			INDEX (FechaCorte)
		);

		INSERT INTO TMPSALDOSCREDITOSREL (ClienteID, CreditoID, FechaCorte)
		SELECT Max(Sal.ClienteID), Sal.CreditoID, MAX(Sal.FechaCorte)
			FROM TMPCREDITOSREL Tmp
			INNER JOIN SALDOSCREDITOS Sal ON Sal.CreditoID = Tmp.CreditoID
			WHERE Sal.FechaCorte = FechaInicial
			GROUP BY Sal.CreditoID;


		UPDATE  TMPSALDOSCREDITOSREL Tmp INNER JOIN SALDOSCREDITOS Sal ON Sal.CreditoID = Tmp.CreditoID SET
			Saldo = IFNULL((ROUND(SalCapVigente,2) 	+ ROUND(SalCapAtrasado,2)	+ ROUND(SalCapVencido,2)+
							ROUND(SalCapVenNoExi,2)	+ ROUND(SalIntOrdinario,2)	+ ROUND(SalIntAtrasado,2)+
							ROUND(SalIntVencido,2)	+ ROUND(SalIntProvision,2)	+ ROUND(SalIntNoConta,2)+
							ROUND(SalMoratorios,2)	+ ROUND(SaldoMoraVencido,2)	+ ROUND(SaldoMoraCarVen,2)+
							ROUND(SalComFaltaPago,2)+ ROUND(SaldoComServGar,2)  +  ROUND(SalOtrasComisi,2)),0)
		WHERE Sal.FechaCorte = Tmp.FechaCorte;


		/*Se inserta el contenido del reporte*/
		IF(NREG = 0) THEN
			INSERT INTO REPMONITOREOFIRA(
					TipoReporteID,				FechaGeneracion,				ConsecutivoID,			CSVReporte,						EmpresaID,
					Usuario,					FechaActual,					DireccionIP,			ProgramaID,						Sucursal,
					NumTransaccion)
			SELECT
				TipoReporte_RelCred,
				Par_FechaCorte,
				@cont:=@cont+1,
				CONCAT("Al cierre del mes que se informa, el IFNB no reporta créditos relacionados"),
				Aud_EmpresaID,
				Aud_Usuario,
				Aud_FechaActual,
				Aud_DireccionIP,
				Aud_ProgramaID,
				Aud_Sucursal,
				Aud_NumTransaccion;
		ELSE
		INSERT INTO REPMONITOREOFIRA(
				TipoReporteID,				FechaGeneracion,				ConsecutivoID,			CSVReporte,						EmpresaID,
				Usuario,					FechaActual,					DireccionIP,			ProgramaID,						Sucursal,
				NumTransaccion)
		SELECT
			TipoReporte_RelCred,
			Par_FechaCorte,
			@cont:=@cont+1,
			CONCAT_WS(",",CLI.NombreCompleto, CLI.TipoPersona, CLI.RFC, CLI.CURP, TMP.ClienteID, ROUND(SUM(TMP.Saldo),2), ROUND(SUM(TMP.Saldo),2),
			IFNULL(REL.PorcAcciones,0)),
			Aud_EmpresaID,
			Aud_Usuario,
			Aud_FechaActual,
			Aud_DireccionIP,
			Aud_ProgramaID,
			Aud_Sucursal,
			Aud_NumTransaccion
			FROM TMPSALDOSCREDITOSREL AS TMP INNER JOIN CLIENTES AS CLI ON TMP.ClienteID = CLI.ClienteID
			INNER JOIN TMPTOTALACCIONESFIRA AS REL ON REL.ClienteID = TMP.ClienteID
			GROUP BY TMP.ClienteID, CLI.NombreCompleto, CLI.TipoPersona, CLI.RFC, CLI.CURP, REL.PorcAcciones;
		END IF;

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