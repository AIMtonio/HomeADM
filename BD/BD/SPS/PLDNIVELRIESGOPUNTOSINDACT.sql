
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDNIVELRIESGOPUNTOSINDACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDNIVELRIESGOPUNTOSINDACT`;

DELIMITER $$
CREATE PROCEDURE `PLDNIVELRIESGOPUNTOSINDACT`(
	Par_ClienteID			INT(11),			# ID del Cliente CLIENTES
	Par_Salida 				CHAR(1), 			# Salida S:Si N:No
	INOUT	Par_NumErr		INT(11),			# Numero de error
	INOUT	Par_ErrMen		VARCHAR(400),		# Mensaje de error

	/* Parametros de Auditoria */
	Aud_Empresa				INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),

	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Control					VARCHAR(20);	# Campo para el id del control de pantalla
	DECLARE Var_Consecutivo				VARCHAR(50);	# Consecutivo que se mostrara en pantalla
	DECLARE Var_NivelObtenido			CHAR(1);		# Nivel de Riesgo Obtenido
	DECLARE Var_PEP						CHAR(1);

	DECLARE Var_FolioMatriz				INT(11);		# Numero de Folio de la parametrización actual
	DECLARE Var_TipoMatriz				INT(11);		# Tipo de Matriz
	DECLARE Var_TipoPersona				CHAR(1);		# Tipo de Persona CLIENTES
	DECLARE Var_NivelRiesgoFin			CHAR(1);		# Nivel de Riesgo Final
	DECLARE Var_FechaActual				DATE;			# Fecha Actual
	DECLARE Var_EdadActual				INT(11);		# Edad Actual del Cliente
	DECLARE Var_ComercioExp				CHAR(1);		# CONOCIMIENTOCTE
	DECLARE Var_ComercioInt				CHAR(1);		# CONOCIMIENTOCTE
	DECLARE Var_LocaliAlto				CHAR(1);		# DIRECCLIENTE
	DECLARE Var_LocaliMedio				CHAR(1);		# DIRECCLIENTE
	DECLARE Var_LocaliBajo				CHAR(1);		# DIRECCLIENTE
	DECLARE Var_ActBMXNivel				CHAR(1);		# ACTIVIDADESBMX
	DECLARE Var_ClienteEvaluaMatriz		CHAR(1);		# CONOCIMIENTOCTE
	DECLARE Var_FechaNacimiento			DATE;			# CLIENTES
	DECLARE Var_Fechaconstitucion		DATE;			# CLIENTES
	DECLARE Var_NivelOrigen				CHAR(1);		# PLDPERFILTRANSACCIONAL
	DECLARE Var_NivelDestino			CHAR(1);		# PLDPERFILTRANSACCIONAL
	DECLARE Var_DepositosMax			DECIMAL(16,2);	# Monto Máximo de Abonos y Retiros por Operación.
	DECLARE Var_RetirosMax				DECIMAL(16,2);	# Número Máximo de Transacciones
	DECLARE Var_NumDepositos			INT(11);		# Número de Depositos Maximos realizados en un periodo de un Mes
	DECLARE Var_NumDepoEfec				INT(11);		# Numero de Retiros en Efectivo
	DECLARE Var_NumDepoChe				INT(11);		# Numero de Retiros en Cheque
	DECLARE Var_NumDepoTran				INT(11);		# Numero de Retiros En Transferencia
	DECLARE Var_NumRetiros				INT(11);		# Número de Retiros Maximos realizados en un periodo de un Mes
	DECLARE Var_NumRetirosEfec			INT(11);		# Numero de Retiros en Efectivo
	DECLARE Var_NumRetirosChe			INT(11);		# Numero de Retiros en Cheque
	DECLARE Var_NumRetirosTran			INT(11);		# Numero de Retiros En Transferencia
	DECLARE Var_EstatusListasNegras		CHAR(1);		# Estatus en Listas Negras
	DECLARE Var_PerfDepositosMax		DECIMAL(16,2);
	DECLARE Var_PerfRetirosMax			DECIMAL(16,2);
	DECLARE Var_PerfNumDepositos		INT(11);
	DECLARE Var_PerfNumRetiros			INT(11);
	DECLARE Var_PerfNumDepoEfecApli		INT(11);
	DECLARE Var_PerfNumDepoCheApli		INT(11);
	DECLARE Var_PerfNumDepoTranApli		INT(11);
	DECLARE Var_PerfNumRetirosEfecApli	INT(11);
	DECLARE Var_PerfNumRetirosCheApli	INT(11);
	DECLARE Var_PerfNumRetirosTranApli	INT(11);
	DECLARE Var_Maximo					TINYINT(4);
	DECLARE Var_Minimo					TINYINT(4);
	DECLARE Var_MesesSig				INT(11);


	# Nivel 1
	DECLARE Var_PonderadoTotal			DECIMAL(12,2);	# Porcentaje por Concepto
	DECLARE Var_AnteCliente				DECIMAL(12,2);	# Porcentaje por Concepto
	DECLARE Var_Localidad				DECIMAL(12,2);	# Porcentaje por Concepto
	DECLARE Var_ActividadEco			DECIMAL(12,2);	# Porcentaje por Concepto
	DECLARE Var_OriRecursos				DECIMAL(12,2);	# Porcentaje por Concepto
	DECLARE Var_DesRecursos				DECIMAL(12,2);	# Porcentaje por Concepto
	DECLARE Var_PerfilTransaccional		DECIMAL(12,2);	# Porcentaje por Concepto
	DECLARE Var_EBR						DECIMAL(12,2);	# Porcentaje por Concepto
	# Nivel 2
	DECLARE Var_FechanacimientoP		DECIMAL(12,2);	# Porcentaje por Concepto 2 Nivel
	DECLARE Var_ListasNegras			DECIMAL(12,2);	# Porcentaje por Concepto 2 Nivel
	DECLARE Var_FechaconstP				DECIMAL(12,2);	# Porcentaje por Concepto 2 Nivel
	DECLARE Var_ListasNegrasM			DECIMAL(12,2);	# Porcentaje por Concepto 2 Nivel
	DECLARE Var_ComercioExterior		DECIMAL(12,2);	# Porcentaje por Concepto 2 Nivel

	DECLARE Var_LocalidadNivel			DECIMAL(12,2);	# Porcentaje por Concepto 2 Nivel

	DECLARE Var_ActividadBMX			DECIMAL(12,2);	# Porcentaje por Concepto 2 Nivel
	DECLARE Var_OrigenRecursos			DECIMAL(12,2);	# Porcentaje por Concepto 2 Nivel
	DECLARE Var_DestinoRecursos			DECIMAL(12,2);	# Porcentaje por Concepto 2 Nivel
	DECLARE Var_MontosFisica			DECIMAL(12,2);	# Porcentaje por Concepto 2 Nivel
	DECLARE Var_MontosMoral				DECIMAL(12,2);	# Porcentaje por Concepto 2 Nivel
	DECLARE Var_InstrumentoMFi			DECIMAL(12,2);	# Porcentaje por Concepto 2 Nivel
	DECLARE Var_InstrumentoMMo			DECIMAL(12,2);	# Porcentaje por Concepto 2 Nivel
	DECLARE Var_NumeroOperaFi			DECIMAL(12,2);	# Porcentaje por Concepto 2 Nivel
	DECLARE Var_NumeroOperaMo			DECIMAL(12,2);	# Porcentaje por Concepto 2 Nivel

	# Nivel 3
	DECLARE Var_PorcEdad				DECIMAL(12,2);	# Porcentaje por Concepto 3 Nivel
	DECLARE Var_PorcListasNegras		DECIMAL(12,2);	# Porcentaje por Concepto 3 Nivel
	DECLARE Var_PorcComercioExp			DECIMAL(12,2);	# Porcentaje por Concepto 3 Nivel
	DECLARE Var_PorMontoPersFis			DECIMAL(12,2);	# Porcentaje por Concepto 3 Nivel
	DECLARE Var_PorMontoPersMor			DECIMAL(12,2);	# Porcentaje por Concepto 3 Nivel
	DECLARE Var_PorInstrumentoEfec		DECIMAL(12,2);	# Porcentaje por Concepto 3 Nivel
	DECLARE Var_PorInstrumentoCheq		DECIMAL(12,2);	# Porcentaje por Concepto 3 Nivel
	DECLARE Var_PorInstrumentoTrans		DECIMAL(12,2);	# Porcentaje por Concepto 3 Nivel
	DECLARE Var_PorInstrumentoEfecMor	DECIMAL(12,2);	# Porcentaje por Concepto 3 Nivel
	DECLARE Var_PorInstrumentoCheqMor	DECIMAL(12,2);	# Porcentaje por Concepto 3 Nivel
	DECLARE Var_PorInstrumentoTransMor	DECIMAL(12,2);	# Porcentaje por Concepto 3 Nivel
	DECLARE Var_PorNumOpeFisicas		DECIMAL(12,2);	# Porcentaje por Concepto 3 Nivel
	DECLARE Var_PorNumOpeMoral			DECIMAL(12,2);	# Porcentaje por Concepto 3 Nivel

	# IDS QUE SE GUARDAN EN LA TABLA
	DECLARE Var_Con1AntecedentesCte				INT(11);
	DECLARE Var_Con1FechaNacID					INT(11);
	DECLARE Var_Con1ListasNegFID				INT(11);
	DECLARE Var_Con1FechaConsID					INT(11);
	DECLARE Var_Con1ListasNegMID				INT(11);
	DECLARE Var_Con1ComercioExtID				INT(11);
	DECLARE Var_Con2LocalidadID					INT(11);
	DECLARE Var_Con3ActEconID					INT(11);
	DECLARE Var_Con4OriRecID					INT(11);
	DECLARE Var_Con5DestRecID					INT(11);
	DECLARE Var_Con6Perfiltrans					INT(11);
	DECLARE Var_Con6MontosFID					INT(11);
	DECLARE Var_Con6InstMoneFID					INT(11);
	DECLARE Var_Con6InstMoneFIDEfec				INT(11);
	DECLARE Var_Con6InstMoneFIDCheq				INT(11);
	DECLARE Var_Con6InstMoneFIDTrans			INT(11);
	DECLARE Var_Con6NumeroOpeFID				INT(11);
	DECLARE Var_Con6MontosMID					INT(11);
	DECLARE Var_Con6InstMoneMID					INT(11);
	DECLARE Var_Con6InstMoneMIDEfec				INT(11);
	DECLARE Var_Con6InstMoneMIDCheq				INT(11);
	DECLARE Var_Con6InstMoneMIDTrans			INT(11);
	DECLARE Var_Con6NumeroOpeMID				INT(11);
	DECLARE Var_Con7EBR							INT(11);

	# VALORES DEL HISTRICO
	DECLARE Var_HisFolioMatrizID						DECIMAL(12,2);
	DECLARE Var_HisNivelRiesgoObt						CHAR(1);
	DECLARE Var_HisTotalPonderado						DECIMAL(12,2);
	DECLARE Var_HisPorc1TotalAntec						DECIMAL(12,2);
	DECLARE Var_HisPorc2Localidad						DECIMAL(12,2);
	DECLARE Var_HisPorc3ActividadEc					DECIMAL(12,2);
	DECLARE Var_HisPorc4TotalOriRe						DECIMAL(12,2);
	DECLARE Var_HisPorc5TotalDesRe						DECIMAL(12,2);
	DECLARE Var_HisPorc6TotalPerf						DECIMAL(12,2);
	DECLARE Var_HisPorc1TotalEBR						DECIMAL(12,2);
	DECLARE Var_HisCon1FechaNacID						INT(11);
	DECLARE Var_HisPorc1FechaNac						DECIMAL(12,2);
	DECLARE Var_HisCon1ListasNegFID					INT(11);
	DECLARE Var_HisPorc1ListasNegF						DECIMAL(12,2);
	DECLARE Var_HisCon1FechaConsID						INT(11);
	DECLARE Var_HisPorc1FechaCons						DECIMAL(12,2);
	DECLARE Var_HisCon1ListasNegMID					INT(11);
	DECLARE Var_HisPorc1ListasNegM						DECIMAL(12,2);
	DECLARE Var_HisCon1ComercioExtID					INT(11);
	DECLARE Var_HisPorc1ComercioExt					DECIMAL(12,2);
	DECLARE Var_HisCon2LocalidadID						INT(11);
	DECLARE Var_HisCon3ActEconID						INT(11);
	DECLARE Var_HisPorc3ActEcon						DECIMAL(12,2);
	DECLARE Var_HisCon4OriRecID						INT(11);
	DECLARE Var_HisPorc4OriRec							DECIMAL(12,2);
	DECLARE Var_HisCon5DestRecID						INT(11);
	DECLARE Var_HisPorc5DestRec						DECIMAL(12,2);
	DECLARE Var_HisCon6MontosFID						INT(11);
	DECLARE Var_HisPorcMontoFisica						DECIMAL(12,2);
	DECLARE Var_HisInstrumentoMFi						DECIMAL(12,2);
	DECLARE Var_HisCon6InstMoneFIDEfec					INT(11);
	DECLARE Var_HisPorInstrumentoEfec					DECIMAL(12,2);
	DECLARE Var_HisCon6InstMoneFIDCheq					INT(11);
	DECLARE Var_HisPorInstrumentoCheq					DECIMAL(12,2);
	DECLARE Var_HisCon6InstMoneFIDTrans				INT(11);
	DECLARE Var_HisPorInstrumentoTrans					DECIMAL(12,2);
	DECLARE Var_HisCon6NumeroOpeFID					INT(11);
	DECLARE Var_HisPorcNumeroOperaFi					DECIMAL(12,2);
	DECLARE Var_HisCon6MontosMID						INT(11);
	DECLARE Var_HisPorcMontosMoral						DECIMAL(12,2);
	DECLARE Var_HisInstrumentoMMo						DECIMAL(12,2);
	DECLARE Var_HisCon6InstMoneMIDEfe					INT(11);
	DECLARE Var_HisPorInstrumentoEfecMor				DECIMAL(12,2);
	DECLARE Var_HisCon6InstMoneMIDChe					INT(11);
	DECLARE Var_HisPorInstrumentoCheqMor				DECIMAL(12,2);
	DECLARE Var_HisCon6InstMoneMIDTrans				INT(11);
	DECLARE Var_HisPorInstrumentoTransMor				DECIMAL(12,2);
	DECLARE Var_HisCon6NumeroOpeMID					INT(11);
	DECLARE Var_HisPorcNumeroOperaMo					DECIMAL(12,2);

	-- Declaracion de constantes
	DECLARE Cadena_Vacia			CHAR(1);		# Cadena Vacia
	DECLARE Cons_SI					CHAR(1);		# Constante Si
	DECLARE Cons_No					CHAR(1);		# Constante No
	DECLARE Entero_Cero				INT(11);		# Entero Cero
	DECLARE Salida_NO				CHAR(1);		# Salida No
	DECLARE Salida_SI				CHAR(1);		# Salida Si
	DECLARE TipoPersonaFisica		CHAR(1);		# Tipo de Persona Fisica
	DECLARE TipoPersonaMoral		CHAR(1);		# Tipo de Persona Moral
	DECLARE TipoPersonaActEmp		CHAR(1);		# Tipo de Persona Actividad Empresarial

	-- Asignacion de Constantes
	SET Cadena_Vacia				:= '';
	SET Cons_SI						:= 'S';
	SET Cons_No						:= 'N';
	SET Entero_Cero					:= 0;
	SET Salida_NO					:= 'N';
	SET Salida_SI					:= 'S';
	SET TipoPersonaFisica			:= 'F';
	SET TipoPersonaMoral			:= 'M';
	SET TipoPersonaActEmp			:= 'A';

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDNIVELRIESGOPUNTOSINDACT');
			SET Var_Control := 'sqlException';
		END;

		SELECT
			PAR.FechaSistema,			FrecuenciaMensual
		  INTO
			Var_FechaActual,			Var_MesesSig
			FROM PARAMETROSSIS AS PAR;

		SELECT
			CTE.EvaluaXMatriz,			CLI.TipoPersona,	CLI.FechaNacimiento,			CLI.Fechaconstitucion,
			CTE.PEPs
			INTO
			Var_ClienteEvaluaMatriz,	Var_TipoPersona,	Var_FechaNacimiento,			Var_Fechaconstitucion,
			Var_PEP
			FROM
				CLIENTES AS CLI LEFT JOIN CONOCIMIENTOCTE AS CTE ON CLI.ClienteID = CTE.ClienteID
				WHERE CLI.ClienteID = Par_ClienteID;

		SET Var_ClienteEvaluaMatriz	:= IFNULL(Var_ClienteEvaluaMatriz, Cons_SI);
		SET Var_PEP					:= IFNULL(Var_PEP, 'N');
		SET Var_FolioMatriz			:= (SELECT MAX(FolioID) FROM PLDHISMATRIZRIESGOXCONC LIMIT 1);


		IF(Var_ClienteEvaluaMatriz = Cons_SI) THEN
				/* 1 ANTECEDENTES ============================================================================================== */
				BloqueAntedentes: BEGIN
					IF(Var_TipoPersona = TipoPersonaFisica OR Var_TipoPersona = TipoPersonaActEmp) THEN
						/* FISICA ================================================================================================== */
						/* 8 - Fecha de Nacimiento XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */
						SET Var_EdadActual 			:= timestampdiff(YEAR,Var_FechaNacimiento,Var_FechaActual);
						SELECT
							PLD.Porcentaje,		PLD.MatrizCatalogoID
							INTO
							Var_PorcEdad,		Var_Con1FechaNacID
							FROM
								PLDMATRIZRIESGOXCONC AS PLD
								WHERE
									PLD.MatrizConceptoID = 8
									AND Var_EdadActual<PLD.LimiteSuperior AND Var_EdadActual>PLD.LimiteInferior;

						SET Var_PorcEdad			:= IFNULL(Var_PorcEdad, Entero_Cero);
						SET Var_FechanacimientoP 	:= IFNULL((SELECT PLD.Porcentaje FROM
														PLDMATRIZRIESGOXCONC AS PLD
														WHERE
														PLD.MatrizCatalogoID = 8), Entero_Cero)*(Var_PorcEdad/100);
						/* XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */
						/*09 - Listas Negras XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */
						SET Var_EstatusListasNegras := IFNULL((SELECT Estatus
																	FROM PLDCOINCIDENCIAS AS PLD INNER JOIN PLDLISTANEGRAS AS NEGR ON PLD.ListaNegraID = NEGR.ListaNegraID
																		WHERE PLD.ClavePersonaInv = Par_ClienteID AND
																			PLD.TipoPersSAFI = 'CTE'
																			ORDER BY Estatus ASC
																			LIMIT 1),'');
						# Activo
						IF(Var_EstatusListasNegras='A') THEN
							SET Var_Con1ListasNegFID	:= 16;
							SET Var_PorcListasNegras	:= IFNULL((SELECT PLD.Porcentaje FROM
																	PLDMATRIZRIESGOXCONC AS PLD
																	WHERE
																		PLD.MatrizCatalogoID = Var_Con1ListasNegFID), Entero_Cero);
						END IF;
						# Inactivo
						IF(Var_EstatusListasNegras='I') THEN
							SET Var_Con1ListasNegFID	:= 17;
							SET Var_PorcListasNegras	:= IFNULL((SELECT PLD.Porcentaje FROM
																	PLDMATRIZRIESGOXCONC AS PLD
																	WHERE
																		PLD.MatrizCatalogoID = Var_Con1ListasNegFID), Entero_Cero);
						END IF;

						SET Var_PorcListasNegras		:= IFNULL(Var_PorcListasNegras, Entero_Cero);
						SET Var_Con1ListasNegFID		:= IFNULL(Var_Con1ListasNegFID, Entero_Cero);
						SET Var_ListasNegras 			:= IFNULL((SELECT PLD.Porcentaje FROM
																	PLDMATRIZRIESGOXCONC AS PLD
																	WHERE
																	PLD.MatrizCatalogoID = 10), Entero_Cero)*(Var_PorcListasNegras/100);
						/* XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */
					  ELSE
						/* MORAL =================================================================================================== */
						/* 10 - Fecha de ConstitucioXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */
						SET Var_EdadActual 			:= timestampdiff(YEAR,Var_Fechaconstitucion,Var_FechaActual);

						SELECT
							PLD.Porcentaje,		PLD.MatrizCatalogoID
							INTO
							Var_PorcEdad,		Var_Con1FechaConsID
							FROM
								PLDMATRIZRIESGOXCONC AS PLD
								WHERE
									PLD.MatrizConceptoID = 10
									AND Var_EdadActual<PLD.LimiteSuperior AND Var_EdadActual>PLD.LimiteInferior;

						SET Var_PorcEdad			:= IFNULL(Var_PorcEdad, Entero_Cero);
						SET Var_FechaconstP 		:= IFNULL((SELECT PLD.Porcentaje FROM
														PLDMATRIZRIESGOXCONC AS PLD
														WHERE
														PLD.MatrizCatalogoID = 10), Entero_Cero)*(Var_PorcEdad/100);
						/* XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */
						/*11 - Listas Negras XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */
						SET Var_EstatusListasNegras := IFNULL((SELECT Estatus
																	FROM PLDCOINCIDENCIAS AS PLD INNER JOIN PLDLISTANEGRAS AS NEGR ON PLD.ListaNegraID = NEGR.ListaNegraID
																		WHERE PLD.ClavePersonaInv = Par_ClienteID AND
																			PLD.TipoPersSAFI = 'CTE'
																			ORDER BY Estatus ASC
																			LIMIT 1),'');
						# Activo
						IF(Var_EstatusListasNegras='A') THEN
							SET Var_Con1ListasNegMID	:= 20;
							SET Var_PorcListasNegras	:= IFNULL((SELECT PLD.Porcentaje FROM
																	PLDMATRIZRIESGOXCONC AS PLD
																	WHERE
																		PLD.MatrizCatalogoID = Var_Con1ListasNegMID), Entero_Cero);
						END IF;
						# Inactivo
						IF(Var_EstatusListasNegras='I') THEN
							SET Var_Con1ListasNegMID	:= 21;
							SET Var_PorcListasNegras	:= IFNULL((SELECT PLD.Porcentaje FROM
																	PLDMATRIZRIESGOXCONC AS PLD
																	WHERE
																		PLD.MatrizCatalogoID = Var_Con1ListasNegMID), Entero_Cero);
						END IF;

						SET Var_PorcListasNegras		:= IFNULL(Var_PorcListasNegras, Entero_Cero);
						SET Var_ListasNegrasM 			:= IFNULL((SELECT PLD.Porcentaje FROM
																	PLDMATRIZRIESGOXCONC AS PLD
																	WHERE
																	PLD.MatrizCatalogoID = 11), Entero_Cero)*(Var_PorcListasNegras/100);
						/* XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */
						/*12 - Comercio Exterior XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */
						SELECT
							Exporta,			Importa
							INTO
							Var_ComercioExp,	Var_ComercioInt
							FROM CONOCIMIENTOCTE AS CON
								WHERE CON.ClienteID = Par_ClienteID;

						SET Var_ComercioInt			:= IFNULL(Var_ComercioInt,	Cons_No);
						SET Var_ComercioExp			:= IFNULL(Var_ComercioExp,	Cons_No);

						IF(Var_ComercioInt = Cons_SI AND Var_ComercioExp = Cons_SI) THEN
							SET Var_Con1ComercioExtID	:= 24;
							SET Var_PorcComercioExp := (SELECT
															PLD.Porcentaje
															FROM
															PLDMATRIZRIESGOXCONC AS PLD
															WHERE
															PLD.MatrizCatalogoID = 24);
						  ELSEIF(Var_ComercioInt = Cons_SI) THEN
							SET Var_Con1ComercioExtID	:= 23;
							SET Var_PorcComercioExp := (SELECT
															PLD.Porcentaje
															FROM
															PLDMATRIZRIESGOXCONC AS PLD
															WHERE
															PLD.MatrizCatalogoID = 23);
						  ELSEIF(Var_ComercioInt = Cons_SI) THEN
							SET Var_Con1ComercioExtID	:= 22;
							SET Var_PorcComercioExp := (SELECT
															PLD.Porcentaje
															FROM
															PLDMATRIZRIESGOXCONC AS PLD
															WHERE
															PLD.MatrizCatalogoID = 22);
						END IF;
						SET Var_PorcComercioExp		:= IFNULL(Var_PorcComercioExp, Entero_Cero);
						SET Var_ComercioExterior	:= IFNULL((SELECT PLD.Porcentaje FROM
															PLDMATRIZRIESGOXCONC AS PLD
															WHERE
															PLD.MatrizCatalogoID = 12), Entero_Cero)*(Var_PorcComercioExp/100);
						/* XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */
					END IF;

					SET Var_FechanacimientoP		:= IFNULL(Var_FechanacimientoP, Entero_Cero);
					SET Var_ListasNegras			:= IFNULL(Var_ListasNegras, Entero_Cero);
					SET Var_FechaconstP				:= IFNULL(Var_FechaconstP, Entero_Cero);
					SET Var_ListasNegrasM			:= IFNULL(Var_ListasNegrasM, Entero_Cero);
					SET Var_ComercioExterior		:= IFNULL(Var_ComercioExterior, Entero_Cero);

					IF(Var_TipoPersona = TipoPersonaFisica OR Var_TipoPersona = TipoPersonaActEmp) THEN
						SET Var_AnteCliente :=
							IFNULL((SELECT PLD.Porcentaje FROM
														PLDMATRIZRIESGOXCONC AS PLD
														WHERE
														PLD.MatrizCatalogoID = 1), Entero_Cero)*
														((Var_FechanacimientoP + Var_ListasNegras)/100);
					  ELSE
						SET Var_AnteCliente :=
							IFNULL((SELECT PLD.Porcentaje FROM
															PLDMATRIZRIESGOXCONC AS PLD
															WHERE
															PLD.MatrizCatalogoID = 1), Entero_Cero)*
														((Var_FechaconstP + Var_ListasNegrasM + Var_ComercioExterior)/100);
					END IF;
				END BloqueAntedentes;
				/* FIN ANTECEDENTES ============================================================================================== */
				/* 2 - LOCALIDAD ================================================================================================= */
				BloqueLocalidad: BEGIN
					SET Var_LocaliAlto		:= (SELECT LOC.ClaveRiesgo
													FROM DIRECCLIENTE AS DIR INNER JOIN
														LOCALIDADREPUB AS LOC ON DIR.EstadoID = LOC.EstadoID AND DIR.MunicipioID=LOC.MunicipioID AND DIR.LocalidadID = LOC.LocalidadID
														WHERE DIR.ClienteID = Par_ClienteID AND LOC.ClaveRiesgo = 'A'
														LIMIT 1);
					SET Var_LocaliMedio		:= (SELECT LOC.ClaveRiesgo
													FROM DIRECCLIENTE AS DIR INNER JOIN LOCALIDADREPUB AS LOC ON DIR.EstadoID = LOC.EstadoID AND DIR.MunicipioID=LOC.MunicipioID AND DIR.LocalidadID = LOC.LocalidadID
														WHERE DIR.ClienteID = Par_ClienteID AND LOC.ClaveRiesgo = 'M'
														LIMIT 1);
					SET Var_LocaliBajo		:= (SELECT LOC.ClaveRiesgo
													FROM DIRECCLIENTE AS DIR INNER JOIN LOCALIDADREPUB AS LOC ON DIR.EstadoID = LOC.EstadoID AND DIR.MunicipioID=LOC.MunicipioID AND DIR.LocalidadID = LOC.LocalidadID
														WHERE DIR.ClienteID = Par_ClienteID AND LOC.ClaveRiesgo = 'B'
														LIMIT 1);
					IF(Var_LocaliAlto = 'A') THEN
						SET Var_Con2LocalidadID	:= 25;
						SET Var_LocalidadNivel := (SELECT PLD.Porcentaje FROM
															PLDMATRIZRIESGOXCONC AS PLD
															WHERE
															PLD.MatrizCatalogoID = Var_Con2LocalidadID);
					  ELSEIF(Var_LocaliMedio = 'M') THEN
						SET Var_Con2LocalidadID	:= 26;
						SET Var_LocalidadNivel := (SELECT PLD.Porcentaje FROM
															PLDMATRIZRIESGOXCONC AS PLD
															WHERE
															PLD.MatrizCatalogoID = Var_Con2LocalidadID);
					  ELSE
						SET Var_Con2LocalidadID	:= 27;
						SET Var_LocalidadNivel := (SELECT PLD.Porcentaje FROM
															PLDMATRIZRIESGOXCONC AS PLD
															WHERE
															PLD.MatrizCatalogoID = Var_Con2LocalidadID);
					END IF;
					SET Var_LocalidadNivel		:= IFNULL(Var_LocalidadNivel, Entero_Cero);
					SET Var_Localidad			:= IFNULL((SELECT PLD.Porcentaje FROM
															PLDMATRIZRIESGOXCONC AS PLD
															WHERE
																PLD.MatrizCatalogoID = 2), Entero_Cero)*(Var_LocalidadNivel/100);
				END BloqueLocalidad;
				/* FIN LOCALIDAD ================================================================================================== */
				/* 3 - ACTIVIDAD ECONÓMICA ======================================================================================== */
				BloqueActEconomica: BEGIN
					SET Var_ActBMXNivel 		:= (SELECT BMX.ClaveRiesgo
														FROM 	CLIENTES AS CTE INNER JOIN
																ACTIVIDADESBMX AS BMX ON CTE.ActividadBancoMX = BMX.ActividadBMXID
															WHERE CTE.ClienteID = Par_ClienteID);
					IF(Var_ActBMXNivel = 'A') THEN
						SET Var_Con3ActEconID := 28;
						SET Var_ActividadBMX := (SELECT PLD.Porcentaje FROM
															PLDMATRIZRIESGOXCONC AS PLD
															WHERE
															PLD.MatrizCatalogoID = Var_Con3ActEconID);
					  ELSEIF(Var_ActBMXNivel = 'M') THEN
						SET Var_Con3ActEconID := 29;
						SET Var_ActividadBMX := (SELECT PLD.Porcentaje FROM
															PLDMATRIZRIESGOXCONC AS PLD
															WHERE
															PLD.MatrizCatalogoID = Var_Con3ActEconID);
					  ELSE
						SET Var_Con3ActEconID := 30;
						SET Var_ActividadBMX := (SELECT PLD.Porcentaje FROM
															PLDMATRIZRIESGOXCONC AS PLD
															WHERE
															PLD.MatrizCatalogoID = Var_Con3ActEconID);
					END IF;

					SET Var_ActividadBMX		:= IFNULL(Var_ActividadBMX, Entero_Cero);
					SET Var_ActividadEco		:= IFNULL((SELECT PLD.Porcentaje FROM
																PLDMATRIZRIESGOXCONC AS PLD
																WHERE
																	PLD.MatrizCatalogoID = 3), Entero_Cero)*(Var_ActividadBMX/100);
				END BloqueActEconomica;
				/* END ACTIVIDAD ECONÓMICA ======================================================================================== */
				/* 4 - ORIGEN DE LOS RECURSOS ===================================================================================== */
				BloqueOrigenRec: BEGIN
					SELECT
						DES.NivelRiesgo,		ORI.NivelRiesgo
						INTO
						Var_NivelDestino,		Var_NivelOrigen
						FROM
						PLDPERFILTRANS AS PLD INNER JOIN CATPLDDESTINOREC AS DES ON PLD.CatDestinoRecID = DES.CatDestinoRecID INNER JOIN
						CATPLDORIGENREC AS ORI ON PLD.CatOrigenRecID = ORI.CatOrigenRecID
							WHERE PLD.ClienteID = Par_ClienteID;
					SET Var_NivelOrigen			:= IFNULL(Var_NivelOrigen, Cadena_Vacia);
					IF(Var_NivelOrigen = 'A') THEN
						SET Var_Con4OriRecID		:= 31;
						SET Var_OrigenRecursos		:= (SELECT PLD.Porcentaje FROM
																PLDMATRIZRIESGOXCONC AS PLD
																WHERE
																PLD.MatrizCatalogoID = Var_Con4OriRecID);
					  ELSEIF(Var_NivelOrigen = 'M') THEN
						SET Var_Con4OriRecID		:= 32;
						SET Var_OrigenRecursos		:= (SELECT PLD.Porcentaje FROM
																PLDMATRIZRIESGOXCONC AS PLD
																WHERE
																PLD.MatrizCatalogoID = Var_Con4OriRecID);
					  ELSEIF(Var_NivelOrigen = 'B') THEN
						SET Var_Con4OriRecID		:= 33;
						SET Var_OrigenRecursos		:= (SELECT PLD.Porcentaje FROM
																PLDMATRIZRIESGOXCONC AS PLD
																WHERE
																PLD.MatrizCatalogoID = Var_Con4OriRecID);
					END IF;
					SET Var_OrigenRecursos		:= IFNULL(Var_OrigenRecursos, Entero_Cero);
					SET Var_OriRecursos			:= IFNULL((SELECT PLD.Porcentaje FROM
															PLDMATRIZRIESGOXCONC AS PLD
															WHERE
																PLD.MatrizCatalogoID = 4), Entero_Cero)*(Var_OrigenRecursos/100);
				END BloqueOrigenRec;
				/* END ORIGEN DE LOS RECURSOS ===================================================================================== */
				/* 5 - DESTINO DE LOS RECURSOS ==================================================================================== */
				BloqueDestinoRec: BEGIN
					SET Var_NivelDestino		:= IFNULL(Var_NivelDestino, Cadena_Vacia);
					IF(Var_NivelDestino = 'A') THEN
						SET Var_Con5DestRecID		:= 34;
						SET Var_DestinoRecursos		:= (SELECT PLD.Porcentaje FROM
																PLDMATRIZRIESGOXCONC AS PLD
																WHERE
																PLD.MatrizCatalogoID = Var_Con5DestRecID);
					  ELSEIF(Var_NivelDestino = 'M') THEN
						SET Var_Con5DestRecID		:= 35;
						SET Var_DestinoRecursos		:= (SELECT PLD.Porcentaje FROM
																PLDMATRIZRIESGOXCONC AS PLD
																WHERE
																PLD.MatrizCatalogoID = Var_Con5DestRecID);
					  ELSEIF(Var_NivelDestino = 'B') THEN
						SET Var_Con5DestRecID		:= 36;
						SET Var_DestinoRecursos		:= (SELECT PLD.Porcentaje FROM
																PLDMATRIZRIESGOXCONC AS PLD
																WHERE
																PLD.MatrizCatalogoID = Var_Con5DestRecID);
					END IF;

					SET Var_DestinoRecursos		:= IFNULL(Var_DestinoRecursos, Entero_Cero);
					SET Var_DesRecursos			:= IFNULL((SELECT PLD.Porcentaje FROM
															PLDMATRIZRIESGOXCONC AS PLD
															WHERE
																PLD.MatrizCatalogoID = 5), Entero_Cero)*(Var_DestinoRecursos/100);
				END BloqueDestinoRec;
				/* FIN DESTINO DE LOS RECURSOS ==================================================================================== */

				/* 6 - PERFIL TRANSACCIONAL ======================================================================================= */
				BloquePerfilTrans: BEGIN
					SELECT
						PLD.DepositosMax,					PLD.RetirosMax,					PLD.NumDepositos,					PLD.NumRetiros,					PLD.NumDepoEfecApli,
						PLD.NumDepoCheApli,					PLD.NumDepoTranApli,			PLD.NumRetirosEfecApli,				PLD.NumRetirosCheApli,			PLD.NumRetirosTranApli
					  INTO
						Var_PerfDepositosMax,				Var_PerfRetirosMax,				Var_PerfNumDepositos,				Var_PerfNumRetiros,				Var_PerfNumDepoEfecApli,
						Var_PerfNumDepoCheApli,				Var_PerfNumDepoTranApli,		Var_PerfNumRetirosEfecApli,			Var_PerfNumRetirosCheApli,		Var_PerfNumRetirosTranApli
					  FROM PLDPERFILTRANS AS PLD
						WHERE ClienteID = Par_ClienteID;

					SET Var_PerfDepositosMax			:= IFNULL(Var_PerfDepositosMax,Entero_Cero);
					SET Var_PerfRetirosMax				:= IFNULL(Var_PerfRetirosMax,Entero_Cero);
					SET Var_PerfNumDepositos			:= IFNULL(Var_PerfNumDepositos,Entero_Cero);
					SET Var_PerfNumRetiros				:= IFNULL(Var_PerfNumRetiros,Entero_Cero);
					SET Var_PerfNumDepoEfecApli			:= IFNULL(Var_PerfNumDepoEfecApli,Entero_Cero);
					SET Var_PerfNumDepoCheApli			:= IFNULL(Var_PerfNumDepoCheApli,Entero_Cero);
					SET Var_PerfNumDepoTranApli			:= IFNULL(Var_PerfNumDepoTranApli,Entero_Cero);
					SET Var_PerfNumRetirosEfecApli		:= IFNULL(Var_PerfNumRetirosEfecApli,Entero_Cero);
					SET Var_PerfNumRetirosCheApli		:= IFNULL(Var_PerfNumRetirosCheApli,Entero_Cero);
					SET Var_PerfNumRetirosTranApli		:= IFNULL(Var_PerfNumRetirosTranApli,Entero_Cero);

					IF(Var_TipoPersona = TipoPersonaFisica OR Var_TipoPersona = TipoPersonaActEmp) THEN
						/*37 - MONTOS-FISICA XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */
						SELECT
							PLD.Porcentaje,				PLD.MatrizCatalogoID
							INTO
							Var_PorMontoPersFis,		Var_Con6MontosFID
							FROM
								PLDMATRIZRIESGOXCONC AS PLD
								WHERE
									PLD.MatrizConceptoID = 37
									AND ((Var_PerfDepositosMax<PLD.LimiteSuperior AND Var_PerfDepositosMax>PLD.LimiteInferior) OR
										(Var_PerfRetirosMax<PLD.LimiteSuperior AND Var_PerfRetirosMax>PLD.LimiteInferior))
										ORDER BY PLD.Porcentaje DESC
										LIMIT 1;

						SET Var_PorMontoPersFis	:= IFNULL(Var_PorMontoPersFis, Entero_Cero);
						SET Var_MontosFisica 	:= IFNULL((SELECT PLD.Porcentaje FROM
															PLDMATRIZRIESGOXCONC AS PLD
															WHERE
															PLD.MatrizCatalogoID = 37), Entero_Cero)*(Var_PorMontoPersFis/100);
						/* XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */

						/*38 - INSTRUMENTOS MONETARIOS XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */
						IF(Var_PerfNumDepoEfecApli > Entero_Cero OR Var_PerfNumRetirosEfecApli > Entero_Cero) THEN
							SET Var_Con6InstMoneFIDEfec		:= 46;
							SET Var_PorInstrumentoEfec		:= IFNULL((SELECT PLD.Porcentaje FROM
																PLDMATRIZRIESGOXCONC AS PLD
																WHERE
																PLD.MatrizCatalogoID = Var_Con6InstMoneFIDEfec), Entero_Cero);
						END IF;
						IF(Var_PerfNumDepoCheApli > Entero_Cero OR Var_PerfNumRetirosCheApli > Entero_Cero) THEN
							SET Var_Con6InstMoneFIDCheq		:= 47;
							SET Var_PorInstrumentoCheq		:= IFNULL((SELECT PLD.Porcentaje FROM
																PLDMATRIZRIESGOXCONC AS PLD
																WHERE
																PLD.MatrizCatalogoID = Var_Con6InstMoneFIDCheq), Entero_Cero);
						END IF;
						IF(Var_PerfNumDepoTranApli > Entero_Cero OR Var_PerfNumRetirosTranApli > Entero_Cero) THEN
							SET Var_Con6InstMoneFIDTrans	:= 48;
							SET Var_PorInstrumentoTrans		:= IFNULL((SELECT PLD.Porcentaje FROM
																PLDMATRIZRIESGOXCONC AS PLD
																WHERE
																PLD.MatrizCatalogoID = Var_Con6InstMoneFIDTrans), Entero_Cero);
						END IF;
						SET Var_PorInstrumentoEfec 		:= IFNULL(Var_PorInstrumentoEfec, Entero_Cero);
						SET Var_PorInstrumentoCheq 		:= IFNULL(Var_PorInstrumentoCheq, Entero_Cero);
						SET Var_PorInstrumentoTrans 	:= IFNULL(Var_PorInstrumentoTrans, Entero_Cero);
						SET Var_InstrumentoMFi := IFNULL((SELECT PLD.Porcentaje FROM
															PLDMATRIZRIESGOXCONC AS PLD
															WHERE
															PLD.MatrizCatalogoID = 38), Entero_Cero)*
														((Var_PorInstrumentoEfec + Var_PorInstrumentoCheq + Var_PorInstrumentoTrans)/100);


						/* XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */
						/*39 - NÚMERO DE OPERACIONES XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */
						SELECT
							PLD.Porcentaje,					PLD.MatrizCatalogoID
							INTO
							Var_PorNumOpeFisicas,		Var_Con6NumeroOpeFID
							FROM
								PLDMATRIZRIESGOXCONC AS PLD
								WHERE
									PLD.MatrizConceptoID = 39
									AND ((Var_PerfNumDepositos<PLD.LimiteSuperior AND Var_PerfNumDepositos>PLD.LimiteInferior) OR
										(Var_PerfNumRetiros<PLD.LimiteSuperior AND Var_PerfNumRetiros>PLD.LimiteInferior))
									ORDER BY PLD.Porcentaje DESC
									LIMIT 1;

						SET Var_NumeroOperaFi 	:= IFNULL((SELECT PLD.Porcentaje FROM
															PLDMATRIZRIESGOXCONC AS PLD
															WHERE
															PLD.MatrizCatalogoID = 39), Entero_Cero)*(Var_PorNumOpeFisicas/100);
						/*FIN xxxxxxxxxxxxxxxxxxxxxxxXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */
					  ELSE

						/*40 - MONTOS-MORAL XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */
						SELECT
							PLD.Porcentaje,				PLD.MatrizCatalogoID
							INTO
							Var_PorMontoPersMor,		Var_Con6MontosMID
							FROM
								PLDMATRIZRIESGOXCONC AS PLD
								WHERE
									PLD.MatrizConceptoID = 40
									AND ((Var_PerfDepositosMax<PLD.LimiteSuperior AND Var_PerfDepositosMax>PLD.LimiteInferior) OR
										(Var_PerfRetirosMax<PLD.LimiteSuperior AND Var_PerfRetirosMax>PLD.LimiteInferior))
										ORDER BY PLD.Porcentaje DESC
										LIMIT 1;


						SET Var_PorMontoPersMor	:= IFNULL(Var_PorMontoPersMor, Entero_Cero);
						SET Var_MontosMoral 	:= IFNULL((SELECT PLD.Porcentaje FROM
															PLDMATRIZRIESGOXCONC AS PLD
															WHERE
															PLD.MatrizCatalogoID = 40), Entero_Cero)*(Var_PorMontoPersMor/100);
						/* XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */
						/*41 - INSTRUMENTOS MONETARIOS XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */
						IF(Var_PerfNumDepoEfecApli > Entero_Cero OR Var_PerfNumRetirosEfecApli > Entero_Cero) THEN
							SET Var_Con6InstMoneMIDEfec		:= 55;
							SET Var_PorInstrumentoEfecMor	:= IFNULL((SELECT PLD.Porcentaje FROM
																PLDMATRIZRIESGOXCONC AS PLD
																WHERE
																PLD.MatrizCatalogoID = Var_Con6InstMoneMIDEfec), Entero_Cero);
						END IF;
						IF(Var_PerfNumDepoCheApli > Entero_Cero OR Var_PerfNumRetirosCheApli > Entero_Cero) THEN
							SET Var_Con6InstMoneMIDCheq		:= 56;
							SET Var_PorInstrumentoCheqMor	:= IFNULL((SELECT PLD.Porcentaje FROM
																PLDMATRIZRIESGOXCONC AS PLD
																WHERE
																PLD.MatrizCatalogoID = Var_Con6InstMoneMIDCheq), Entero_Cero);
						END IF;
						IF(Var_PerfNumDepoTranApli > Entero_Cero OR Var_PerfNumRetirosTranApli > Entero_Cero) THEN
							SET Var_Con6InstMoneMIDTrans		:= 57;
							SET Var_PorInstrumentoTransMor	:= IFNULL((SELECT PLD.Porcentaje FROM
																PLDMATRIZRIESGOXCONC AS PLD
																WHERE
																PLD.MatrizCatalogoID = Var_Con6InstMoneMIDTrans), Entero_Cero);
						END IF;
						SET Var_PorInstrumentoEfecMor 		:= IFNULL(Var_PorInstrumentoEfecMor, Entero_Cero);
						SET Var_PorInstrumentoCheqMor 		:= IFNULL(Var_PorInstrumentoCheqMor, Entero_Cero);
						SET Var_PorInstrumentoTransMor 		:= IFNULL(Var_PorInstrumentoTransMor, Entero_Cero);
						SET Var_InstrumentoMMo := IFNULL((SELECT PLD.Porcentaje FROM
															PLDMATRIZRIESGOXCONC AS PLD
															WHERE
															PLD.MatrizCatalogoID = 41), Entero_Cero)*
														((Var_PorInstrumentoEfecMor + Var_PorInstrumentoCheqMor + Var_PorInstrumentoTransMor)/100);


						/* XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */
						/*42 - NÚMERO DE OPERACIONES XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */
						SELECT
							PLD.Porcentaje,					PLD.MatrizCatalogoID
							INTO
							Var_PorNumOpeMoral,				Var_Con6NumeroOpeMID
							FROM
								PLDMATRIZRIESGOXCONC AS PLD
								WHERE
									PLD.MatrizConceptoID = 42
									AND ((Var_PerfNumDepositos<PLD.LimiteSuperior AND Var_PerfNumDepositos>PLD.LimiteInferior) OR
										(Var_PerfNumRetiros<PLD.LimiteSuperior AND Var_PerfNumRetiros>PLD.LimiteInferior))
										ORDER BY PLD.Porcentaje DESC
										LIMIT 1;

						SET Var_NumeroOperaMo 	:= IFNULL((SELECT PLD.Porcentaje FROM
															PLDMATRIZRIESGOXCONC AS PLD
															WHERE
															PLD.MatrizCatalogoID = 42), Entero_Cero)*(Var_PorNumOpeMoral/100);
						/*FIN xxxxxxxxxxxxxxxxxxxxxxxXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */
					END IF;

					SET Var_TipoPersona 	:= IFNULL(Var_TipoPersona, '');
					SET Var_MontosFisica	:= IFNULL(Var_MontosFisica, Entero_Cero);
					SET Var_InstrumentoMFi	:= IFNULL(Var_InstrumentoMFi, Entero_Cero);
					SET Var_NumeroOperaFi	:= IFNULL(Var_NumeroOperaFi, Entero_Cero);
					SET Var_MontosMoral		:= IFNULL(Var_MontosMoral, Entero_Cero);
					SET Var_InstrumentoMMo	:= IFNULL(Var_InstrumentoMMo, Entero_Cero);
					SET Var_NumeroOperaMo	:= IFNULL(Var_NumeroOperaMo, Entero_Cero);

					IF(Var_TipoPersona = TipoPersonaFisica OR Var_TipoPersona = TipoPersonaActEmp) THEN
						SET Var_PerfilTransaccional :=
							IFNULL((SELECT PLD.Porcentaje FROM
														PLDMATRIZRIESGOXCONC AS PLD
														WHERE
														PLD.MatrizCatalogoID = 6), Entero_Cero)*
														((Var_MontosFisica + Var_InstrumentoMFi + Var_NumeroOperaFi)/100);
					  ELSE
						SET Var_PerfilTransaccional :=
							IFNULL((SELECT PLD.Porcentaje FROM
															PLDMATRIZRIESGOXCONC AS PLD
															WHERE
															PLD.MatrizCatalogoID = 6), Entero_Cero)*
														((Var_MontosMoral + Var_InstrumentoMMo + Var_NumeroOperaMo)/100);
					END IF;

				END BloquePerfilTrans;
				/* FIN PERFIL TRANSACCIONAL ======================================================================================= */
				SET Var_EBR 				:= (SELECT Porcentaje FROM PLDMATRIZRIESGOXCONC AS PLD WHERE MatrizCatalogoID = 7);
				# FISICA
				SET Var_PorInstrumentoEfec 			:= IFNULL(Var_PorInstrumentoEfec, Entero_Cero);
				SET Var_PorInstrumentoCheq 			:= IFNULL(Var_PorInstrumentoCheq, Entero_Cero);
				SET Var_PorInstrumentoTrans 		:= IFNULL(Var_PorInstrumentoTrans, Entero_Cero);
				# MORAL
				SET Var_PorInstrumentoEfecMor 		:= IFNULL(Var_PorInstrumentoEfecMor, Entero_Cero);
				SET Var_PorInstrumentoCheqMor 		:= IFNULL(Var_PorInstrumentoCheqMor, Entero_Cero);
				SET Var_PorInstrumentoTransMor 		:= IFNULL(Var_PorInstrumentoTransMor, Entero_Cero);
				/*FIN 6 PERFIL*/
				SET Var_AnteCliente 				:= IFNULL(Var_AnteCliente, Entero_Cero);
				SET Var_Localidad 					:= IFNULL(Var_Localidad, Entero_Cero);
				SET Var_ActividadEco 				:= IFNULL(Var_ActividadEco, Entero_Cero);
				SET Var_OriRecursos 				:= IFNULL(Var_OriRecursos, Entero_Cero);
				SET Var_DesRecursos 				:= IFNULL(Var_DesRecursos, Entero_Cero);
				SET Var_PerfilTransaccional 		:= IFNULL(Var_PerfilTransaccional, Entero_Cero);

				SET Var_PonderadoTotal := (Var_AnteCliente+Var_Localidad+Var_ActividadEco + Var_OriRecursos + Var_DesRecursos +Var_PerfilTransaccional+Var_EBR);
				SET Var_PonderadoTotal := CEILING(Var_PonderadoTotal);

				SET Var_NivelObtenido	:= (SELECT CAT.NivelRiesgoID
											FROM CATNIVELESRIESGO AS CAT
											WHERE CAT.TipoPersona = Var_TipoPersona
												AND CAT.Estatus = 'A'
												AND Var_PonderadoTotal BETWEEN CAT.Minimo AND CAT.Maximo);

				SET Var_NivelObtenido := IFNULL(Var_NivelObtenido,'B');
				SET Aud_FechaActual := NOW();
				UPDATE CLIENTES
				SET
					NivelRiesgo = Var_NivelObtenido,
					FechaSigEvalPLD = FNSUMMESESFECHA(Var_FechaActual,Var_MesesSig)
				WHERE ClienteID = Par_ClienteID;

			IF NOT EXISTS(SELECT ClienteID FROM PLDNIVELRIESGOXCLIENTE WHERE ClienteID = Par_ClienteID) THEN

					INSERT INTO PLDNIVELRIESGOXCLIENTE(
						ClienteID,					Fecha,						Hora,						FolioMatrizID,					NivelRiesgoObt,
						TotalPonderado,				Porc1TotalAntec,			Porc2Localidad,				Porc3ActividadEc,				Porc4TotalOriRe,
						Porc5TotalDesRe,			Porc6TotalPerf,				Porc1TotalEBR,				Con1FechaNacID,					Porc1FechaNac,
						Con1ListasNegFID,			Porc1ListasNegF,			Con1FechaConsID,			Porc1FechaCons,					Con1ListasNegMID,
						Porc1ListasNegM,			Con1ComercioExtID,			Porc1ComercioExt,			Con2LocalidadID,				Con3ActEconID,
						Porc3ActEcon,				Con4OriRecID,				Porc4OriRec,				Con5DestRecID,					Porc5DestRec,
						Con6MontosFID,				PorcMontoFisica,			InstrumentoMFi,				Con6InstMoneFIDEfec,			PorInstrumentoEfec,
						Con6InstMoneFIDCheq,		PorInstrumentoCheq,			Con6InstMoneFIDTrans,		PorInstrumentoTrans,			Con6NumeroOpeFID,
						PorcNumeroOperaFi,			Con6MontosMID,				PorcMontosMoral,			InstrumentoMMo,					Con6InstMoneMIDEfe,
						PorInstrumentoEfecMor,		Con6InstMoneMIDChe,			PorInstrumentoCheqMor,		Con6InstMoneMIDTrans,			PorInstrumentoTransMor,
						Con6NumeroOpeMID,			PorcNumeroOperaMo,			EmpresaID,					Usuario,						FechaActual,
						DireccionIP,				ProgramaID,					Sucursal,					NumTransaccion)
					  SELECT
						Par_ClienteID,				Var_FechaActual,			CURRENT_TIME(),				Var_FolioMatriz,				Var_NivelObtenido,
						Var_PonderadoTotal,			Var_AnteCliente,			Var_Localidad,				Var_ActividadEco,				Var_OriRecursos,
						Var_DesRecursos,			Var_PerfilTransaccional,	Var_EBR,					Var_Con1FechaNacID,				Var_FechanacimientoP,
						Var_Con1ListasNegFID,		Var_ListasNegras,			Var_Con1FechaConsID,		Var_FechaconstP,				Var_Con1ListasNegMID,
						Var_ListasNegrasM,			Var_Con1ComercioExtID,		Var_ComercioExterior,		Var_Con2LocalidadID,			Var_Con3ActEconID,
						Var_ActividadEco,			Var_Con4OriRecID,			Var_OriRecursos,			Var_Con5DestRecID,				Var_DesRecursos,
						Var_Con6MontosFID,			Var_MontosFisica,			Var_InstrumentoMFi,			Var_Con6InstMoneFIDEfec,		Var_PorInstrumentoEfec,
						Var_Con6InstMoneFIDCheq,	Var_PorInstrumentoCheq,		Var_Con6InstMoneFIDTrans,	Var_PorInstrumentoTrans,		Var_Con6NumeroOpeFID,
						Var_NumeroOperaFi,			Var_Con6MontosMID,			Var_MontosMoral,			Var_InstrumentoMMo,				Var_Con6InstMoneMIDEfec,
						Var_PorInstrumentoEfecMor,	Var_Con6InstMoneMIDCheq,	Var_PorInstrumentoCheqMor,	Var_Con6InstMoneMIDTrans,		Var_PorInstrumentoTransMor,
						Var_Con6NumeroOpeMID,		Var_NumeroOperaMo,			Aud_Empresa,				Aud_Usuario,					Aud_FechaActual,
						Aud_DireccionIP,			Aud_ProgramaID,				Aud_Sucursal,				Aud_NumTransaccion;
				  ELSE

					UPDATE PLDNIVELRIESGOXCLIENTE SET
						ClienteID				= Par_ClienteID,
						Fecha					= Var_FechaActual,
						Hora					= CURRENT_TIME(),
						FolioMatrizID			= Var_FolioMatriz,
						NivelRiesgoObt			= Var_NivelObtenido,
						TotalPonderado			= Var_PonderadoTotal,
						Porc1TotalAntec			= Var_AnteCliente,
						Porc2Localidad			= Var_Localidad,
						Porc3ActividadEc		= Var_ActividadEco,
						Porc4TotalOriRe			= Var_OriRecursos,
						Porc5TotalDesRe			= Var_DesRecursos,
						Porc6TotalPerf			= Var_PerfilTransaccional,
						Porc1TotalEBR			= Var_EBR,
						Con1FechaNacID			= Var_Con1FechaNacID,
						Porc1FechaNac			= Var_FechanacimientoP,
						Con1ListasNegFID		= Var_Con1ListasNegFID,
						Porc1ListasNegF			= Var_ListasNegras,
						Con1FechaConsID			= Var_Con1FechaConsID,
						Porc1FechaCons			= Var_FechaconstP,
						Con1ListasNegMID		= Var_Con1ListasNegMID,
						Porc1ListasNegM			= Var_ListasNegrasM,
						Con1ComercioExtID		= Var_Con1ComercioExtID,
						Porc1ComercioExt		= Var_ComercioExterior,
						Con2LocalidadID			= Var_Con2LocalidadID,
						Con3ActEconID			= Var_Con3ActEconID,
						Porc3ActEcon			= Var_ActividadEco,
						Con4OriRecID			= Var_Con4OriRecID,
						Porc4OriRec				= Var_OriRecursos,
						Con5DestRecID			= Var_Con5DestRecID,
						Porc5DestRec			= Var_DesRecursos,
						Con6MontosFID			= Var_Con6MontosFID,
						PorcMontoFisica			= Var_MontosFisica,
						InstrumentoMFi			= Var_InstrumentoMFi,
						Con6InstMoneFIDEfec		= Var_Con6InstMoneFIDEfec,
						PorInstrumentoEfec		= Var_PorInstrumentoEfec,
						Con6InstMoneFIDCheq		= Var_Con6InstMoneFIDCheq,
						PorInstrumentoCheq		= Var_PorInstrumentoCheq,
						Con6InstMoneFIDTrans	= Var_Con6InstMoneFIDTrans,
						PorInstrumentoTrans		= Var_PorInstrumentoTrans,
						Con6NumeroOpeFID		= Var_Con6NumeroOpeFID,
						PorcNumeroOperaFi		= Var_NumeroOperaFi,
						Con6MontosMID			= Var_Con6MontosMID,
						PorcMontosMoral			= Var_MontosMoral,
						InstrumentoMMo			= Var_InstrumentoMMo,
						Con6InstMoneMIDEfe		= Var_Con6InstMoneMIDEfec,
						PorInstrumentoEfecMor	= Var_PorInstrumentoEfecMor,
						Con6InstMoneMIDChe		= Var_Con6InstMoneMIDCheq,
						PorInstrumentoCheqMor	= Var_PorInstrumentoCheqMor,
						Con6InstMoneMIDTrans	= Var_Con6InstMoneMIDTrans,
						PorInstrumentoTransMor	= Var_PorInstrumentoTransMor,
						Con6NumeroOpeMID		= Var_Con6NumeroOpeMID,
						PorcNumeroOperaMo		= Var_NumeroOperaMo,
						EmpresaID				= Aud_Empresa,
						Usuario					= Aud_Usuario,
						FechaActual				= Aud_FechaActual,
						DireccionIP				= Aud_DireccionIP,
						ProgramaID				= Aud_ProgramaID,
						Sucursal				= Aud_Sucursal,
						NumTransaccion			= Aud_NumTransaccion
						WHERE
						ClienteID = Par_ClienteID;
				END IF;

				INSERT IGNORE INTO PLDHISNIVELRIESGOXCLIENTE(
					ClienteID,					Fecha,						Hora,						FolioMatrizID,					NivelRiesgoObt,
					TotalPonderado,				Porc1TotalAntec,			Porc2Localidad,				Porc3ActividadEc,				Porc4TotalOriRe,
					Porc5TotalDesRe,			Porc6TotalPerf,				Porc1TotalEBR,				Con1FechaNacID,					Porc1FechaNac,
					Con1ListasNegFID,			Porc1ListasNegF,			Con1FechaConsID,			Porc1FechaCons,					Con1ListasNegMID,
					Porc1ListasNegM,			Con1ComercioExtID,			Porc1ComercioExt,			Con2LocalidadID,				Con3ActEconID,
					Porc3ActEcon,				Con4OriRecID,				Porc4OriRec,				Con5DestRecID,					Porc5DestRec,
					Con6MontosFID,				PorcMontoFisica,			InstrumentoMFi,				Con6InstMoneFIDEfec,			PorInstrumentoEfec,
					Con6InstMoneFIDCheq,		PorInstrumentoCheq,			Con6InstMoneFIDTrans,		PorInstrumentoTrans,			Con6NumeroOpeFID,
					PorcNumeroOperaFi,			Con6MontosMID,				PorcMontosMoral,			InstrumentoMMo,					Con6InstMoneMIDEfe,
					PorInstrumentoEfecMor,		Con6InstMoneMIDChe,			PorInstrumentoCheqMor,		Con6InstMoneMIDTrans,			PorInstrumentoTransMor,
					Con6NumeroOpeMID,			PorcNumeroOperaMo,			EmpresaID,					Usuario,						FechaActual,
					DireccionIP,				ProgramaID,					Sucursal,					NumTransaccion)
				  SELECT
					Par_ClienteID,				Var_FechaActual,			CURRENT_TIME(),				Var_FolioMatriz,				Var_NivelObtenido,
					Var_PonderadoTotal,			Var_AnteCliente,			Var_Localidad,				Var_ActividadEco,				Var_OriRecursos,
					Var_DesRecursos,			Var_PerfilTransaccional,	Var_EBR,					Var_Con1FechaNacID,				Var_FechanacimientoP,
					Var_Con1ListasNegFID,		Var_ListasNegras,			Var_Con1FechaConsID,		Var_FechaconstP,				Var_Con1ListasNegMID,
					Var_ListasNegrasM,			Var_Con1ComercioExtID,		Var_ComercioExterior,		Var_Con2LocalidadID,			Var_Con3ActEconID,
					Var_ActividadEco,			Var_Con4OriRecID,			Var_OriRecursos,			Var_Con5DestRecID,				Var_DesRecursos,
					Var_Con6MontosFID,			Var_MontosFisica,			Var_InstrumentoMFi,			Var_Con6InstMoneFIDEfec,		Var_PorInstrumentoEfec,
					Var_Con6InstMoneFIDCheq,	Var_PorInstrumentoCheq,		Var_Con6InstMoneFIDTrans,	Var_PorInstrumentoTrans,		Var_Con6NumeroOpeFID,
					Var_NumeroOperaFi,			Var_Con6MontosMID,			Var_MontosMoral,			Var_InstrumentoMMo,				Var_Con6InstMoneMIDEfec,
					Var_PorInstrumentoEfecMor,	Var_Con6InstMoneMIDCheq,	Var_PorInstrumentoCheqMor,	Var_Con6InstMoneMIDTrans,		Var_PorInstrumentoTransMor,
					Var_Con6NumeroOpeMID,		Var_NumeroOperaMo,			Aud_Empresa,				Aud_Usuario,					Aud_FechaActual,
					Aud_DireccionIP,			Aud_ProgramaID,				Aud_Sucursal,				Aud_NumTransaccion;
		END IF;

		SET Par_NumErr	:= 000;
		SET Par_ErrMen	:= CONCAT('Nivel de Riesgo Actualizado Exitosamente.');
		SET Var_Control	:= 'clienteID';
		SET Var_Consecutivo := Par_ClienteID;

	END ManejoErrores;

	IF(Par_Salida = Salida_SI) THEN
		SELECT Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$

