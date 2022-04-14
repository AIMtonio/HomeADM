-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGC045100006REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGC045100006REP`;
DELIMITER $$


CREATE PROCEDURE `REGC045100006REP`(
# ============================================================================================================
# ------------------ SP PARA OBTENER DATOS PARA EL REPORTE DE C0451 Version 2015 -----------------------
# ============================================================================================================
	Par_Fecha           DATETIME,				# Fecha del reporte
	Par_NumReporte      TINYINT UNSIGNED,		# Tipo de reporte 1: Excel 2: CVS
	Par_NumDecimales    INT,					# Numero de Decimales en Cantidades o Montos

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
		)

TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_UltFecEPRC 		DATE;			-- Ultima fecha de estimaciones preventivas
	DECLARE	Var_ClaveEntidad	VARCHAR(300);	-- Clave de la Entidad de la institucion
	DECLARE Var_Periodo			CHAR(6);		-- Periodo al que pertenece el reporte año+mes

	-- Declaracion de Constantes
	DECLARE Rep_Excel       	INT(11);
	DECLARE Rep_Csv				INT(11);
	DECLARE For_0451			INT(11);
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Espacio_blanco		VARCHAR(2);
	DECLARE Fecha_Vacia			DATE;
	DECLARE SI 					CHAR(1);
	DECLARE NO 					CHAR(1);
	DECLARE Fisica				CHAR(1);
	DECLARE Moral				CHAR(1);
	DECLARE Fisica_empre		CHAR(1);
	DECLARE Masculino			CHAR(1);
	DECLARE Femenino    		CHAR(1);
	DECLARE Vencido 			CHAR(1);
	DECLARE Vigente 			CHAR(1);
	DECLARE Pagado				CHAR(1);
	DECLARE Nacional 			CHAR(1);
	DECLARE Cadena_Espacio		VARCHAR(2);
	DECLARE Entero_Cero			INT(11);
    DECLARE Apellido_Vacio		CHAR(1);  -- Cuando no tiene apellido se coloca X

	DECLARE Tipo_Consanguineo	CHAR(1);
	DECLARE Tipo_Afinidad		CHAR(1);
	DECLARE Rel_GradoUno		INT(11);
	DECLARE Rel_GradoDos		INT(11);
	DECLARE Tipo_Cliente		INT(11);
	DECLARE Tipo_Empleado		INT(11);

    DECLARE	Cla_SinRelacion		VARCHAR(2);
	DECLARE Cla_ConsejoAdmon	VARCHAR(2);
	DECLARE Cla_ConsejoVigil	VARCHAR(2);
	DECLARE Cla_ComiteCredito	VARCHAR(2);
	DECLARE Cla_DirGeneral		VARCHAR(2);
    DECLARE	Cla_FamFuncionario	VARCHAR(2);

	-- Asignacion de Constantes
	SET Rep_Excel       	:= 	1;      		-- Opcion para generar los datos para el excel
	SET Rep_Csv				:=	2;				-- Opcion para generar datos para el CVS
	SET For_0451			:= 	0451;			-- Clave del Formulario o Reporte 0451.
	SET Cadena_Vacia		:= 	'';				-- Cadena vacia
	SET Espacio_blanco  	:=	' ';			-- Espacio en blanco
	SET Fecha_Vacia			:= 	'1900-01-01';	-- Fecha vacia
	SET SI 					:=	'S';			-- SI
	SET NO 					:=	'N'; 			-- NO
	SET Fisica				:=	'F';			-- Tipo de persona fisica
	SET Moral				:=	'M';			-- Tipo de persona moral
	SET Fisica_empre		:=	'A';			-- Persona Fisica Con Actividad Empresarial
	SET Masculino			:=	'M';			-- Sexo masculino
	SET Femenino			:=	'F';			-- Sexo femenino
	SET Vencido  			:=	'B';			-- Vencido
	SET Vigente 			:= 	'V';			-- Vigente
	SET Pagado 				:=  'P';			-- Pagado
	SET Nacional			:= 	'N';			-- Nacionalidad del cliente 'N' = Nacional
	SET Cadena_Espacio		:= ' ';				-- Espacio en blanco
	SET Entero_Cero			:= 0;
	SET Par_NumDecimales	:= 0;			-- EL reporte se presenta con montos a 0 decimales
	SET Apellido_Vacio 		:= 'X';
	SET Tipo_Consanguineo	:= "C";			-- Tipo de Relacion: Consanguinea
	SET Tipo_Afinidad		:= "A";			-- Tipo de Relacion: Afinidad
	SET Rel_GradoUno		:= 1;			-- Nivel de la Relacion: UNO
	SET Rel_GradoDos		:= 2;			-- Nivel de la Relacion: DOS
	SET Tipo_Cliente		:= 1;			-- Tipo de Relacionado: Cliente
	SET Tipo_Empleado		:= 2;			-- Tipo de Relacionado: Empleado

	SET Cla_SinRelacion		:= '1';			-- Tipo de Relacionado: Sin Relacion
	SET Cla_ConsejoAdmon	:= '2';			-- Tipo de Relacionado: Familiar de Funcionario
	SET Cla_ConsejoVigil	:= '3';			-- Tipo de Relacionado: Familiar de Funcionario
	SET Cla_ComiteCredito	:= '4';			-- Tipo de Relacionado: Familiar de Funcionario
	SET Cla_DirGeneral		:= '7';			-- Tipo de Relacionado: Familiar de Funcionario
	SET Cla_FamFuncionario	:= '6';			-- Tipo de Relacionado: Familiar de Funcionario


	SET Var_Periodo = CONCAT(SUBSTRING(REPLACE(CONVERT(Par_Fecha, CHAR),'-',Cadena_Vacia),1,4),
							  SUBSTRING(REPLACE(CONVERT(Par_Fecha, CHAR),'-',Cadena_Vacia),5,2));

	SET Var_ClaveEntidad	:= IFNULL((SELECT Ins.ClaveEntidad
										FROM PARAMETROSSIS Par,
											 INSTITUCIONES Ins
										WHERE Par.InstitucionID = Ins.InstitucionID), Cadena_Vacia);

	CALL TRANSACCIONESPRO(Aud_NumTransaccion);

	DELETE FROM TMPREGR04C0451
		WHERE NumTransaccion = Aud_NumTransaccion;


	INSERT INTO TMPREGR04C0451
		SELECT	Aud_NumTransaccion,	Sal.CreditoID, Sal.ClienteID, IFNULL(Dir.DireccionID, Entero_Cero),
				IFNULL(Dir.EstadoID, Entero_Cero), Cadena_Vacia,
				IFNULL(Dir.MunicipioID, Entero_Cero), Cadena_Vacia,
				Dir.ColoniaID,
				CASE WHEN Cli.TipoPersona = Moral AND Cli.Nacion = Nacional THEN '2'
					 WHEN Cli.TipoPersona IN (Fisica_empre, Fisica)  THEN '1'
				END,
				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						UPPER(
							SUBSTRING(CONCAT(IFNULL(Cli.PrimerNombre, Cadena_Vacia),
								CASE WHEN IFNULL(Cli.SegundoNombre, Cadena_Vacia) != Cadena_Vacia THEN
									CONCAT(Espacio_blanco, Cli.SegundoNombre) ELSE Cadena_Vacia
								END,
								CASE WHEN IFNULL(Cli.TercerNombre, Cadena_Vacia) != Cadena_Vacia THEN
									CONCAT(Espacio_blanco, Cli.TercerNombre) ELSE Cadena_Vacia
								END),  1, 200)
	                    )
					 ELSE UPPER(CONCAT( REPLACE(REPLACE(REPLACE(REPLACE( REPLACE(Cli.RazonSocial, 'S.A DE C.V.', Cadena_Vacia),
									'SA DE CV', Cadena_Vacia), 'S. A. de CV.', Cadena_Vacia), 'sa de cv', Cadena_Vacia), 's.a. de c.v.', Cadena_Vacia)))
				END,
				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						   CASE WHEN IFNULL(Cli.ApellidoPaterno,Cadena_Vacia) = Cadena_Vacia
									OR IFNULL(Cli.ApellidoPaterno,Cadena_Vacia) = '.' THEN
								Apellido_Vacio
							ELSE
								UPPER(IFNULL(Cli.ApellidoPaterno,Apellido_Vacio))
							END
					 ELSE Cadena_Vacia
				END ,
				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						CASE WHEN IFNULL(Cli.ApellidoMaterno,Cadena_Vacia) = Cadena_Vacia
							OR	IFNULL(Cli.ApellidoMaterno,Cadena_Vacia) = '.' THEN
								Apellido_Vacio
						ELSE
						   UPPER(IFNULL(Cli.ApellidoMaterno,Apellido_Vacio))
						END
					 ELSE Cadena_Vacia
				END,
				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						   Cli.RFCOficial
					 ELSE IFNULL(CONCAT("_", SUBSTR(Cli.RFCOficial,1,12)),Cadena_Vacia)
				END,
				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						   Cli.CURP
					 ELSE Entero_Cero
				END,
				CASE WHEN Cli.TipoPersona = Moral THEN Entero_Cero -- vk
					 WHEN Cli.TipoPersona IN (Fisica_empre, Fisica) AND Cli.Sexo = Masculino THEN '2'
					 WHEN Cli.TipoPersona IN (Fisica_empre, Fisica) AND Cli.Sexo = Femenino THEN '1'
				END,
				CONVERT(Cre.SucursalID, CHAR), Sal.DestinoCreID,
				Entero_Cero AS ClasifRegID,
				Cadena_Vacia AS ClasifConta, Pro.Descripcion,
				DATE_FORMAT(Cre.FechaInicio, '%Y%m%d') AS FechaDisp,
				DATE_FORMAT(Cre.FechaVencimien, '%Y%m%d') AS FechaVencim,

				CASE WHEN Pro.ManejaLinea = SI AND Pro.EsRevolvente = SI THEN 7
					 WHEN Pro.ManejaLinea = NO AND Sal.NumAmortizacion <= 1 THEN 1
					 WHEN Pro.ManejaLinea = NO AND Sal.NumAmortizacion > 1
												AND Sal.FrecuenciaCap = 'S' THEN 4
					 WHEN Pro.ManejaLinea = NO AND Sal.NumAmortizacion > 1
												AND Sal.FrecuenciaCap IN ('C', 'Q') THEN 5
					 WHEN Pro.ManejaLinea = NO AND Sal.NumAmortizacion > 1
												AND Sal.FrecuenciaCap = 'M' THEN 6
					 WHEN Pro.ManejaLinea = NO AND Sal.NumAmortizacion > 1
												AND Sal.FrecuenciaCap NOT IN ('S', 'C', 'Q','M') THEN 3
				END,
				Cre.MontoCredito,
				Entero_Cero AS PeriodicidadCap, Entero_Cero AS PeriodicidadInt,
				Cre.TasaFija,

				CASE WHEN Cre.FechaVencimien > Par_Fecha THEN
							(SELECT MIN(Amo.AmortizacionID)
								FROM AMORTICREDITO Amo
								WHERE Amo.CreditoID = Cre.CreditoID
								  AND Amo.FechaVencim > Par_Fecha )

						WHEN Cre.FechaVencimien <= Par_Fecha THEN
							(SELECT MAX(Amo.AmortizacionID)
								FROM AMORTICREDITO Amo
								WHERE Amo.CreditoID = Cre.CreditoID
								  AND Amo.FechaVencim <= Par_Fecha )
				END,

				(SELECT	IFNULL(MAX(Det.FechaPago), Fecha_Vacia)
					FROM DETALLEPAGCRE Det
					WHERE Det.CreditoID  = Sal.CreditoID
					  AND Det.FechaPago <= Par_Fecha
					  AND (Det.MontoCapAtr + Det.MontoCapOrd + Det.MontoCapVen) > 0 ) AS FecUltPagoCap,

				(SELECT	IFNULL(MAX(Det.FechaPago), Fecha_Vacia)
					FROM DETALLEPAGCRE Det
					WHERE Det.CreditoID  = Sal.CreditoID
					  AND Det.FechaPago <= Par_Fecha
					  AND (Det.MontoIntAtr + Det.MontoIntOrd + Det.MontoIntVen) > 0 ) AS FecUltPagoInt,

				Entero_Cero AS MonUltPagoCap,
				Entero_Cero AS MonUltPagoInt,

				(SELECT CONVERT(IFNULL(MIN(FechaExigible), Fecha_Vacia), CHAR)
					FROM AMORTICREDITO Amo
					WHERE Amo.CreditoID = Cre.CreditoID
					  AND (Amo.Estatus != Pagado
					   OR  ( 	Amo.Estatus = Pagado
						   AND	Amo.FechaLiquida  > Par_Fecha ) )
					  AND Amo.FechaExigible <= Par_Fecha ),

				(SELECT IFNULL(SUM(MontoCapital + MontoInteres), Entero_Cero)
					FROM  CREQUITAS Quita
					WHERE Quita.CreditoID = Cre.CreditoID
					  AND Quita.FechaRegistro <= Par_Fecha ),

				(SELECT CONVERT(IFNULL(MAX(FechaRegistro), Fecha_Vacia), CHAR)
					FROM  CREQUITAS Quita
					WHERE Quita.CreditoID = Cre.CreditoID
					  AND Quita.FechaRegistro <= Par_Fecha ),

				Entero_Cero AS DiasAtraso,
				'1' AS TipoCredito,
				Sal.EstatusCredito,
				Cadena_Vacia AS SituacionContable,
				(Sal.SalCapVigente + Sal.SalCapAtrasado + Sal.SalCapVencido + Sal.SalCapVenNoExi) AS SalCapital,
				(Sal.SalIntProvision + Sal.SalIntAtrasado + Sal.SalIntVencido) AS SalIntOrdin,
				(Sal.SalMoratorios + Sal.SaldoMoraVencido) AS SalIntMora,
				(Sal.SalIntNoConta) AS SalIntCtaOrden,
				(Sal.SaldoMoraCarVen + Sal.SalOtrasComisi + Sal.SaldoComServGar  + Sal.SalComFaltaPago) AS  SalMoraCtaOrden,
				Entero_Cero AS IntereRefinan,

				(Sal.SalCapVigente + Sal.SalCapAtrasado + Sal.SalCapVencido + Sal.SalCapVenNoExi) +
				(Sal.SalIntProvision + Sal.SalIntAtrasado + Sal.SalIntVencido) +
				(Sal.SalMoratorios + Sal.SaldoMoraVencido) AS SaldoInsoluto,

				'1' AS TipoRelacion, -- En caso de que el acreditado no sea considerado como relacionado
				' ' AS TipCarCalifi, -- Tipo de Cartera para Fines de Calificacion
				Entero_Cero AS CalifIndividual,
				Entero_Cero AS CalifCubierta,
				Entero_Cero AS CalifExpuesta,
				Entero_Cero AS ReservaCubierta,
				Entero_Cero AS ReservaExpuesta,

	            CASE WHEN Sal.EstatusCredito = Vencido THEN
							Sal.SalIntProvision + Sal.SalIntVencido +  Sal.SaldoMoraVencido
					 ELSE Entero_Cero
				END AS EPRCAdiCarVen,

	            Entero_Cero AS EPRCAdiSIC,
				Entero_Cero AS EPRCAdiCNVB,

				(SELECT SUM(CASE WHEN NatMovimiento = Vencido THEN  MontoBloq ELSE MontoBloq *-1 END)
					FROM BLOQUEOS Blo,
						 CUENTASAHO Cue
					WHERE Blo.CuentaAhoID = Cue.CuentaAhoID
					  AND DATE(FechaMov) <= Par_Fecha
					  AND Blo.Referencia = Sal.CreditoID
					  AND Cue.ClienteID = Sal.ClienteID
					  AND Blo.TiposBloqID = 8) AS GtiaCtaAhorro,

				(SELECT SUM(Gar.MontoEnGar)
					FROM CREDITOINVGAR Gar
					WHERE Gar.FechaAsignaGar <= Par_Fecha
					  AND Gar.CreditoID = Sal.CreditoID) AS GtiaInversion,

				(SELECT SUM(Gar.MontoEnGar)
					FROM HISCREDITOINVGAR Gar
					WHERE Gar.Fecha > Par_Fecha
					  AND Gar.FechaAsignaGar <= Par_Fecha
					  AND Gar.ProgramaID NOT IN ('CIERREGENERALPRO')
					  AND Gar.CreditoID = Sal.CreditoID  ) AS GtiaHisInver,

				Entero_Cero AS TotGtiaLiquida,
				Entero_Cero AS GtiaHipotecaria,

				(SELECT CONVERT(IFNULL(MAX(CONVERT(FechaConsulta,DATE)), Cadena_Vacia), CHAR)
					FROM SOLBUROCREDITO Sob
					WHERE Sob.FechaConsulta <= Par_Fecha
					  AND Sob.RFC = Cli.RFCOficial
					  AND (	IFNULL(Sob.FolioConsulta, Cadena_Vacia) != Cadena_Vacia
					   OR	IFNULL(Sob.FolioConsultaC, Cadena_Vacia) != Cadena_Vacia)
					) AS FecConsultaSIC,

				' ' AS ClaveSIC,

				(SELECT IFNULL(MAX(Amo.FechaExigible), Fecha_Vacia)
						FROM AMORTICREDITO Amo
						WHERE Amo.CreditoID = Cre.CreditoID
						  AND Amo.FechaVencim < Par_Fecha ) AS FecUltAmorti


			FROM CLIENTES Cli,
				 CREDITOS Cre,
				 PRODUCTOSCREDITO Pro,
				 SALDOSCREDITOS Sal

			LEFT OUTER JOIN DIRECCLIENTE Dir ON Dir.ClienteID = Sal.ClienteID
											AND IFNULL(Dir.Oficial, NO) = SI

		WHERE
			Cre.Estatus !='C'
		  AND Sal.FechaCorte = Par_Fecha
		  AND Sal.EstatusCredito IN (Vigente, Vencido)
		  AND Sal.CreditoID = Cre.CreditoID
		  AND Cli.ClienteID = Sal.ClienteID
		  AND Cre.ProductoCreditoID = Pro.ProducCreditoID;

	-- ------------------------------------
	-- GARANTIAS HIPOTECARIAS -------------
	-- -------------------------------------
	UPDATE TMPREGR04C0451 Tem, CREGARPRENHIPO Gah SET
		GtiaHipotecaria = Gah.GarHipotecaria

		WHERE Tem.CreditoID = Gah.CreditoID
		  AND IFNULL(Gah.CreditoID, Entero_Cero) != Entero_Cero
		  AND IFNULL(Gah.GarHipotecaria, Entero_Cero) > Entero_Cero
		  AND Tem.NumTransaccion = Aud_NumTransaccion;

	UPDATE TMPREGR04C0451 Tem SET
		TotGtiaLiquida = IFNULL(GtiaCtaAhorro, Entero_Cero) + IFNULL(GtiaInversion,Entero_Cero) + IFNULL(GtiaHisInver,Entero_Cero)
		WHERE Tem.NumTransaccion = Aud_NumTransaccion;

	UPDATE TMPREGR04C0451 Tem SET
		TotGtiaLiquida = SaldoInsoluto
		WHERE TotGtiaLiquida > SaldoInsoluto
		  AND Tem.NumTransaccion = Aud_NumTransaccion;

	-- FIN GARANTIAS HIPOTECARIAS -------------

	-- ---------------------------------------------------------------------------------------------------------------------
	-- PERSONAS RELACIONADAS -------------
	-- ---------------------------------------------------------------------------------------------------------------------

	-- Actualizamos al Titular que tiene la Relacion, cuando el titular con el puesto es Cliente

	UPDATE TMPREGR04C0451 Tem, PERSONARELACIONADA Per SET
		Tem.TipoRelacion = CONVERT(Per.ClaveCNBV, CHAR)

		WHERE Tem.ClienteID = Per.ClienteID
		  AND Tem.NumTransaccion = Aud_NumTransaccion;

	-- Parientes de una Persona Relacionada, cuando la Persona Relacionada es un Cliente de la Sociedad.
	DROP TABLE IF EXISTS TMPRELPERSONAS;

	CREATE TEMPORARY TABLE TMPRELPERSONAS(
		ClienteID		BIGINT,
		ClaveCNVB		VARCHAR(2),
		TipoRelacion	CHAR(1),
		GradoRelacion	INT,

		INDEX TMPRELPERSONAS_idx1(ClienteID)
	);

	INSERT INTO TMPRELPERSONAS
		SELECT Tem.ClienteID, MAX(Per.ClaveCNBV), MAX(Tip.Tipo), MAX(Tip.Grado)

			FROM TMPREGR04C0451 Tem,
				 RELACIONCLIEMPLEADO Rel,
				 PERSONARELACIONADA Per,
				 TIPORELACIONES Tip

			WHERE Tem.ClienteID = Rel.ClienteID
			  AND Rel.TipoRelacion = Tipo_Cliente
			  AND Rel.RelacionadoID = Per.ClienteID
			  AND Rel.ParentescoID = Tip.TipoRelacionID
			  AND Tem.NumTransaccion = Aud_NumTransaccion
		GROUP BY Tem.ClienteID;

	UPDATE TMPREGR04C0451 Tem, TMPRELPERSONAS Rel SET
		 Tem.TipoRelacion = CASE ClaveCNVB
								WHEN Cla_ConsejoAdmon  THEN Cla_FamFuncionario
								WHEN Cla_ConsejoVigil THEN Cla_FamFuncionario
								WHEN Cla_ComiteCredito THEN Cla_FamFuncionario
								WHEN Cla_DirGeneral THEN Cla_FamFuncionario
								ELSE Tem.TipoRelacion
							END
		WHERE Tem.ClienteID = Rel.ClienteID
		  AND Tem.NumTransaccion = Aud_NumTransaccion
		  AND Tem.TipoRelacion = Cla_SinRelacion

		  AND ( (	Rel.TipoRelacion = Tipo_Afinidad
				AND Rel.GradoRelacion = Rel_GradoUno )
			OR (	Rel.TipoRelacion = Tipo_Consanguineo
				AND Rel.GradoRelacion BETWEEN Rel_GradoUno AND Rel_GradoDos )
			);

	-- Parientes de una Persona Relacionada, cuando la Persona Relacionada es un Empleado de la Sociedad.
	DELETE FROM TMPRELPERSONAS;

	INSERT INTO TMPRELPERSONAS
		SELECT Tem.ClienteID, MAX(Per.ClaveCNBV), MAX(Tip.Tipo), MAX(Tip.Grado)

			FROM TMPREGR04C0451 Tem,
				 RELACIONCLIEMPLEADO Rel,
				 PERSONARELACIONADA Per,
				 TIPORELACIONES Tip

			WHERE Tem.ClienteID = Rel.ClienteID
			  AND Rel.TipoRelacion = Tipo_Empleado
			  AND Rel.RelacionadoID = Per.EmpleadoID
			  AND Rel.ParentescoID = Tip.TipoRelacionID
			  AND Tem.NumTransaccion = Aud_NumTransaccion
			GROUP BY Tem.ClienteID;

	UPDATE TMPREGR04C0451 Tem, TMPRELPERSONAS Rel SET
		 Tem.TipoRelacion = CASE ClaveCNVB
								WHEN Cla_ConsejoAdmon  THEN Cla_FamFuncionario
								WHEN Cla_ConsejoVigil THEN Cla_FamFuncionario
								WHEN Cla_ComiteCredito THEN Cla_FamFuncionario
								WHEN Cla_DirGeneral THEN Cla_FamFuncionario
								ELSE Tem.TipoRelacion
							END

		WHERE Tem.ClienteID = Rel.ClienteID
		  AND Tem.NumTransaccion = Aud_NumTransaccion
		  AND Tem.TipoRelacion = Cla_SinRelacion

		  AND ( (	Rel.TipoRelacion = Tipo_Afinidad
				AND Rel.GradoRelacion = Rel_GradoUno )
			OR (	Rel.TipoRelacion = Tipo_Consanguineo
				AND Rel.GradoRelacion BETWEEN Rel_GradoUno AND Rel_GradoDos )
			);

	DROP TABLE IF EXISTS TMPRELPERSONAS;

	-- FIN DE PERSONAS RELACIONADAS ----------

	-- SITUACION DEL CREDITO -------------------
	UPDATE TMPREGR04C0451 Prin SET
		NumDiasAtraso = CASE WHEN
        IFNULL(FecPrimAtraso,Fecha_Vacia) = Fecha_Vacia THEN
        Entero_Cero ELSE
        DATEDIFF(Par_Fecha, CONVERT(FecPrimAtraso, DATE))
		END
		WHERE FecPrimAtraso	!= Cadena_Vacia
		  AND Prin.NumTransaccion = Aud_NumTransaccion;

	UPDATE TMPREGR04C0451 Prin SET
		SituacContable = CASE WHEN EstatusCredito = Vigente AND NumDiasAtraso = 0 THEN '1'
							  WHEN EstatusCredito = Vigente AND NumDiasAtraso >= 1  THEN '2'
							  WHEN EstatusCredito = Vencido THEN '3'
						 END
		WHERE Prin.NumTransaccion = Aud_NumTransaccion;



	UPDATE TMPREGR04C0451 Prin, REESTRUCCREDITO Res SET
		TipoCredito = CASE WHEN Origen = 'R' THEN '3'
						   WHEN Origen = 'O' THEN '2'
						   ELSE TipoCredito
					  END,

		IntereRefinan = CASE WHEN Res.EstatusCreacion = Vencido AND Res.Regularizado = NO THEN Res.SaldoInteres
							 ELSE Entero_Cero
						END

		WHERE Prin.CreditoID = Res.CreditoDestinoID
		  AND Prin.NumTransaccion = Aud_NumTransaccion;


	UPDATE TMPREGR04C0451 Prin, AMORTICREDITO Amo SET
		Prin.PeriodicidadCap = DATEDIFF(Amo.FechaVencim, Amo.FechaInicio),
		Prin.PeriodicidadInt = DATEDIFF(Amo.FechaVencim, Amo.FechaInicio)

		WHERE Prin.CreditoID = Amo.CreditoID
		  AND Prin.UltimaAmorti = Amo.AmortizacionID
		  AND Prin.NumTransaccion = Aud_NumTransaccion;

	-- ----------------------------------------------
	-- ULTIMOS PAGOS REALIZADOS ---------------------
	-- ----------------------------------------------
	DROP TABLE IF EXISTS R04C0451_PAGOS;

	CREATE TEMPORARY TABLE R04C0451_PAGOS(
		CreditoID		BIGINT(12),
		PagCapital		DECIMAL(16,2),
		INDEX R04C0451_PAGOS(CreditoID)
	);

	INSERT INTO R04C0451_PAGOS
		SELECT	Det.CreditoID,
				SUM(Det.MontoCapAtr + Det.MontoCapOrd + Det.MontoCapVen)
			FROM DETALLEPAGCRE Det,
				 TMPREGR04C0451 Tem
			WHERE Det.CreditoID = Tem.CreditoID
			  AND Det.FechaPago = Tem.FecUltPagoCap
			  AND Tem.FecUltPagoCap != Fecha_Vacia
			  AND Tem.NumTransaccion = Aud_NumTransaccion
			GROUP BY Det.CreditoID;

	UPDATE TMPREGR04C0451 Prin, R04C0451_PAGOS Tem SET
		Prin.MonUltPagoCap = Tem.PagCapital
		WHERE Prin.CreditoID = Tem.CreditoID
		  AND Prin.NumTransaccion = Aud_NumTransaccion;

	DROP TABLE R04C0451_PAGOS;

	DROP TABLE IF EXISTS R04C0451_PAGOS;

	CREATE TEMPORARY TABLE R04C0451_PAGOS(
		CreditoID		BIGINT(12),
		PagInteres		DECIMAL(16,2),
		INDEX R04C0451_PAGOS(CreditoID)
	);

	INSERT INTO R04C0451_PAGOS
		SELECT	Det.CreditoID,
				SUM(Det.MontoIntAtr + Det.MontoIntOrd + Det.MontoIntVen)
			FROM DETALLEPAGCRE Det,
				 TMPREGR04C0451 Tem
			WHERE Det.CreditoID = Tem.CreditoID
			  AND Det.FechaPago = Tem.FecUltPagoInt
			  AND Tem.FecUltPagoInt != Fecha_Vacia
			  AND Tem.NumTransaccion = Aud_NumTransaccion
			GROUP BY Det.CreditoID;

	UPDATE TMPREGR04C0451 Prin, R04C0451_PAGOS Tem SET
		Prin.MonUltPagoInt = Tem.PagInteres
		WHERE Prin.CreditoID = Tem.CreditoID
		  AND Prin.NumTransaccion = Aud_NumTransaccion;

	DROP TABLE R04C0451_PAGOS;

	-- FIN ULTIMOS PAGOS REALIZADOS

	-- ------------------------------------
	-- CLASIFICACION DEL CREDITO ----------
	-- -------------------------------------

	UPDATE  TMPREGR04C0451 Tem, DESTINOSCREDITO Des SET
		Tem.ClasifRegID	= Des.ClasifRegID,
		Tem.TipCarCalifi =  CASE WHEN Des.Clasificacion = 'O' THEN '1'
								 WHEN Des.Clasificacion = 'C' THEN '3'
								 WHEN Des.Clasificacion = 'H' THEN '8'
							END
		WHERE Tem.DestinoCreID	= Des.DestinoCreID
		  AND Tem.NumTransaccion = Aud_NumTransaccion;


	-- Cartera Tipo II. Reestructurada y Renovada
	UPDATE  TMPREGR04C0451 Tem, REESTRUCCREDITO Res SET

		Tem.TipCarCalifi =  CASE WHEN Tem.TipCarCalifi = '1' THEN '2'
								 WHEN Tem.TipCarCalifi = '3' THEN '4'
								 WHEN Tem.TipCarCalifi = '8' THEN '9'
							END
		WHERE Tem.CreditoID	= Res.CreditoDestinoID
		  AND Tem.NumTransaccion = Aud_NumTransaccion;

	-- Reclasificacion por Garantías Hipotecarias
	-- Clasificaciones que pasan de Consumo a Vivienda
	DROP TABLE IF EXISTS TEM_CONSUMO_VIVIENDA;

	CREATE TABLE TEM_CONSUMO_VIVIENDA
		SELECT Tem.CreditoID
			FROM TMPREGR04C0451 Tem
			INNER JOIN CREGARPRENHIPO Gah ON Gah.CreditoID = Tem.CreditoID

			WHERE Tem.TipCarCalifi IN ('1','2')
			  AND IFNULL(Gah.CreditoID, Entero_Cero) != Entero_Cero
			  AND IFNULL(Gah.GarHipotecaria, Entero_Cero) > Entero_Cero
			  AND Tem.NumTransaccion = Aud_NumTransaccion;

	UPDATE TMPREGR04C0451 Tem, TEM_CONSUMO_VIVIENDA Rec SET
		Tem.TipCarCalifi = CASE WHEN Tem.TipCarCalifi = '1' THEN '8'
								WHEN Tem.TipCarCalifi = '2' THEN '9'
						   END
		WHERE Tem.CreditoID = Rec.CreditoID
		  AND Tem.TipCarCalifi IN ('1','2')
		  AND Tem.NumTransaccion = Aud_NumTransaccion;

	DROP TABLE IF EXISTS TEM_CONSUMO_VIVIENDA;

	-- Reclasificacion por Garantías Hipotecarias
	-- Clasificaciones que pasan de Vivienda a Consumo
	DROP TABLE IF EXISTS TEM_VIVIENDA_CONSUMO;

	CREATE TABLE TEM_VIVIENDA_CONSUMO
		SELECT Tem.CreditoID
			FROM TMPREGR04C0451 Tem
			LEFT OUTER JOIN CREGARPRENHIPO Gah ON Gah.CreditoID = Tem.CreditoID

			WHERE Tem.TipCarCalifi IN ('8','9')
			  AND IFNULL(Gah.CreditoID, Entero_Cero) = Entero_Cero
			  AND Tem.NumTransaccion = Aud_NumTransaccion;


	UPDATE TMPREGR04C0451 Tem, TEM_VIVIENDA_CONSUMO Rec SET
		Tem.TipCarCalifi = CASE WHEN Tem.TipCarCalifi = '8' THEN '1'
								WHEN Tem.TipCarCalifi = '9' THEN '2'
						   END
		WHERE Tem.CreditoID = Rec.CreditoID
		  AND Tem.TipCarCalifi IN ('8','9')
		  AND Tem.NumTransaccion = Aud_NumTransaccion;

	DROP TABLE IF EXISTS TEM_VIVIENDA_CONSUMO;

	-- Clasificacion Contable
	UPDATE  TMPREGR04C0451 Tem, CATCLASIFREPREG Cat SET
		Tem.ClasifConta		=	Cat.ClavePorDestino
		WHERE Tem.ClasifRegID	= Cat.ClasifRegID
		  AND Tem.NumTransaccion = Aud_NumTransaccion;


	-- --------------------------------------
	-- ESTADOS Y MUNICIPIOS -----------------
	-- --------------------------------------
	UPDATE TMPREGR04C0451 Tem SET
		Tem.EstadoClave = IFNULL(Tem.EstadoID, Entero_Cero)
		WHERE Tem.NumTransaccion = Aud_NumTransaccion;

	UPDATE TMPREGR04C0451 Tem, COLONIASREPUB Col SET
		Tem.MunicipioClave = Col.CodigoPostal

		WHERE Tem.EstadoID = Col.EstadoID
		  AND Tem.MunicipioID = Col.MunicipioID
		  AND Tem.ColoniaID = Col.ColoniaID
		  AND Tem.NumTransaccion = Aud_NumTransaccion;

	UPDATE TMPREGR04C0451 Tem, SUCURSALES Suc SET
		Tem.MunicipioClave = Suc.CP
		WHERE CONVERT(Tem.ClaveSucursal, SIGNED INTEGER) = Suc.SucursalID
        AND Tem.MunicipioClave = Cadena_Vacia OR Tem.MunicipioClave IS NULL
		AND Tem.NumTransaccion = Aud_NumTransaccion;


	-- ESTIMACIONES PREVENTIVAS ------------------
	SELECT MAX(Fecha) INTO Var_UltFecEPRC
		FROM CALRESCREDITOS
		WHERE Fecha <= Par_Fecha;

	SET Var_UltFecEPRC := IFNULL(Var_UltFecEPRC, Fecha_Vacia);

	UPDATE TMPREGR04C0451 Tem,  CALRESCREDITOS Res SET
		Tem.ReservaCubierta	= IFNULL(Res.ReservaTotCubierto, Entero_Cero),
		Tem.ReservaExpuesta	= IFNULL(Res.ReservaTotExpuesto, Entero_Cero)

		WHERE Tem.CreditoID = Res.CreditoID
		  AND Fecha = Var_UltFecEPRC
		  AND Tem.NumTransaccion = Aud_NumTransaccion;

	-- FIN ESTIMACIONES PREVENTIVAS ------------------

	-- CLAVE SIC ----------------------------------------

	-- De acuerdo al Anexo 3 - Forma de Pago MOP de acuerdo a Buro de Credito
	UPDATE TMPREGR04C0451 Tem SET
		ClaveSIC = '10000'				-- Cuenta que todavia no tiene Exigibilidad

		WHERE Tem.UltFecVen = Fecha_Vacia
		  AND IFNULL(Tem.NumDiasAtraso, Entero_Cero) = Entero_Cero
		  AND Tem.TipoPersona = 1
		  AND Tem.NumTransaccion = Aud_NumTransaccion;

	UPDATE TMPREGR04C0451 Tem SET
		ClaveSIC = '10001'

		WHERE UltFecVen != Fecha_Vacia
		  AND IFNULL(NumDiasAtraso, Entero_Cero) = Entero_Cero
		  AND Tem.TipoPersona = 1
		  AND Tem.NumTransaccion = Aud_NumTransaccion;

	UPDATE TMPREGR04C0451 Tem SET
		ClaveSIC = '10002'

		WHERE UltFecVen != Fecha_Vacia
		  AND IFNULL(NumDiasAtraso, Entero_Cero) BETWEEN 1 AND 29
		  AND Tem.TipoPersona = 1
		  AND Tem.NumTransaccion = Aud_NumTransaccion;

	UPDATE TMPREGR04C0451 Tem SET
		ClaveSIC = '10003'

		WHERE UltFecVen != Fecha_Vacia
		  AND IFNULL(NumDiasAtraso, Entero_Cero) BETWEEN 30 AND 59
		  AND Tem.TipoPersona = 1
		  AND Tem.NumTransaccion = Aud_NumTransaccion;

	UPDATE TMPREGR04C0451 Tem SET
		ClaveSIC = '10004'

		WHERE UltFecVen != Fecha_Vacia
		  AND IFNULL(NumDiasAtraso, Entero_Cero) BETWEEN 60 AND 89
		  AND Tem.TipoPersona = 1
		  AND Tem.NumTransaccion = Aud_NumTransaccion;

	UPDATE TMPREGR04C0451 Tem SET
		ClaveSIC = '10005'

		WHERE UltFecVen != Fecha_Vacia
		  AND IFNULL(NumDiasAtraso, Entero_Cero) BETWEEN 90 AND 119
		  AND Tem.TipoPersona = 1
		  AND Tem.NumTransaccion = Aud_NumTransaccion;

	UPDATE TMPREGR04C0451 Tem SET
		ClaveSIC = '10006'

		WHERE UltFecVen != Fecha_Vacia
		  AND IFNULL(NumDiasAtraso, Entero_Cero) BETWEEN 120 AND 149
		  AND Tem.TipoPersona = 1
		  AND Tem.NumTransaccion = Aud_NumTransaccion;


	UPDATE TMPREGR04C0451 Tem SET
		ClaveSIC = '10007'

		WHERE UltFecVen != Fecha_Vacia
		  AND IFNULL(NumDiasAtraso, Entero_Cero) BETWEEN 150 AND 360
		  AND Tem.TipoPersona = 1
		  AND Tem.NumTransaccion = Aud_NumTransaccion;


	UPDATE TMPREGR04C0451 Tem SET
		ClaveSIC = '10008'

		WHERE UltFecVen != Fecha_Vacia
		  AND IFNULL(NumDiasAtraso, Entero_Cero)  > 360
		  AND Tem.TipoPersona = 1
		  AND Tem.NumTransaccion = Aud_NumTransaccion;

	UPDATE TMPREGR04C0451 Tem SET
		FecConsultaSIC = FechaDisp

		WHERE TRIM(FecConsultaSIC) = Cadena_Vacia
		  AND Tem.NumTransaccion = Aud_NumTransaccion;

	-- FIN CLAVE SIC.

	IF(Par_NumReporte = Rep_Excel) THEN
		SELECT	Var_Periodo,	Var_ClaveEntidad,	For_0451,
				MunicipioClave, EstadoClave,	CONVERT(ClienteID, CHAR) AS ClienteID,
				TipoPersona,	Denominacion,	ApellidoPat,	ApellidoMat,	RFC,
				CURP,			Genero,			CONVERT(CreditoID, CHAR) AS CreditoID,
				CONVERT(ClaveSucursal, CHAR) AS ClaveSucursal,
				ClasifConta,	ProductoCredito,
				REPLACE(FechaDisp,'-',Cadena_Vacia) AS FechaDisp,
				REPLACE(FechaVencim,'-',Cadena_Vacia) AS FechaVencim,
				TipoAmorti,	ROUND(IFNULL(MontoCredito,Entero_Cero),Par_NumDecimales) AS MontoCredito, PeriodicidadCap,	PeriodicidadInt,
				ROUND(TasaInteres,2) AS TasaInteres,
				CASE WHEN IFNULL(FecUltPagoCap,Fecha_Vacia) != Fecha_Vacia THEN
						REPLACE(CONVERT(FecUltPagoCap,CHAR),'-',Cadena_Vacia)
					  ELSE REPLACE(CONVERT(Fecha_Vacia,CHAR),'-',Cadena_Vacia)
				END AS FecUltPagoCap,
				ROUND(IFNULL(MonUltPagoCap,Entero_Cero),Par_NumDecimales) AS MonUltPagoCap,
				CASE WHEN IFNULL(FecUltPagoInt,Fecha_Vacia) != Fecha_Vacia THEN
						REPLACE(CONVERT(FecUltPagoInt,CHAR),'-',Cadena_Vacia)
					 ELSE REPLACE(CONVERT(Fecha_Vacia,CHAR),'-',Cadena_Vacia)
				END FecUltPagoInt,
				ROUND(IFNULL(MonUltPagoInt,Entero_Cero),Par_NumDecimales) AS MonUltPagoInt,
				REPLACE(FecPrimAtraso,'-',Cadena_Vacia) AS FecPrimAtraso,
				ROUND(IFNULL(MontoCondona,Entero_Cero),Par_NumDecimales) AS MontoCondona,
				REPLACE(FecUltCondona,'-',Cadena_Vacia) AS FecUltCondona,
				NumDiasAtraso,	TipoCredito,	SituacContable,
				ROUND(IFNULL(SalCapital,Entero_Cero),Par_NumDecimales) AS SalCapital,
				ROUND(IFNULL(SalIntOrdin,Entero_Cero),Par_NumDecimales) AS SalIntOrdin,
				ROUND(IFNULL(SalIntMora,Entero_Cero),Par_NumDecimales) AS SalIntMora,
				ROUND(IFNULL(SalIntCtaOrden,Entero_Cero),Par_NumDecimales) AS SalIntCtaOrden,
				ROUND(IFNULL(SalMoraCtaOrden,Entero_Cero),Par_NumDecimales) AS SalMoraCtaOrden,
				ROUND(IFNULL(IntereRefinan,Entero_Cero),Par_NumDecimales) AS IntereRefinan,
				ROUND(IFNULL(SaldoInsoluto,Entero_Cero),Par_NumDecimales) AS SaldoInsoluto,

				TipoRelacion,	TipCarCalifi,	CalifiIndiv,		CalifCubierta,	CalifExpuesta,
				ROUND(IFNULL(ReservaCubierta, Entero_Cero) * -1, Par_NumDecimales) AS ReservaCubierta,
				ROUND(IFNULL(ReservaExpuesta, Entero_Cero) * -1,Par_NumDecimales)  AS ReservaExpuesta,
				ROUND(IFNULL(EPRCAdiCarVen, Entero_Cero) * -1,Par_NumDecimales)  AS EPRCAdiCarVen,
				ROUND(IFNULL(EPRCAdiSIC, Entero_Cero) * -1,Par_NumDecimales)  AS EPRCAdiSIC,
				ROUND(IFNULL(EPRCAdiCNVB, Entero_Cero) * -1,Par_NumDecimales)  AS EPRCAdiCNVB,
				REPLACE(FecConsultaSIC,'-',Cadena_Vacia) AS FecConsultaSIC,
				ClaveSIC,
				ROUND(IFNULL(TotGtiaLiquida,Entero_Cero),Par_NumDecimales) AS TotGtiaLiquida,
				ROUND(IFNULL(GtiaHipotecaria,Entero_Cero),Par_NumDecimales) AS GtiaHipotecaria

			FROM TMPREGR04C0451 Tem
			WHERE Tem.NumTransaccion = Aud_NumTransaccion;
	ELSE
		IF(Par_NumReporte = Rep_Csv) THEN

			SELECT	CONCAT(
					For_0451,';',
                    IFNULL(MunicipioClave,Cadena_Vacia), ';',
					IFNULL(EstadoClave,Cadena_Vacia),';',
                    CONVERT(IFNULL(ClienteID,Cadena_Vacia), CHAR),';',
                    IFNULL(TipoPersona,Cadena_Vacia),';',
					IFNULL(Denominacion,Cadena_Vacia),';',
                    IFNULL(ApellidoPat,Cadena_Vacia),';',
                    IFNULL(ApellidoMat,Cadena_Vacia),';',
                    IFNULL(RFC,Cadena_Vacia),';',
					IFNULL(CURP,Cadena_Vacia),';',
                    IFNULL(Genero,Cadena_Vacia),';',
                    CONVERT(IFNULL(CreditoID,Cadena_Vacia), CHAR),';',
					CONVERT(IFNULL(ClaveSucursal,Cadena_Vacia), CHAR),';',
                    IFNULL(ClasifConta,Cadena_Vacia),';',
                    IFNULL(ProductoCredito,Cadena_Vacia),';',
					REPLACE(IFNULL(FechaDisp,Fecha_Vacia),'-',Cadena_Vacia),';',
                    REPLACE(IFNULL(FechaVencim,Fecha_Vacia),'-',Cadena_Vacia),';',
					IFNULL(TipoAmorti,Cadena_Vacia),';',
                    ROUND(IFNULL(MontoCredito,Entero_Cero),Par_NumDecimales),';', PeriodicidadCap,';',
					IFNULL(PeriodicidadInt,Entero_Cero),';',
                    ROUND(IFNULL(TasaInteres,Entero_Cero),2),';',
					CASE WHEN IFNULL(FecUltPagoCap,Fecha_Vacia) != Fecha_Vacia THEN
							REPLACE(CONVERT(IFNULL(FecUltPagoCap,Fecha_Vacia),CHAR),'-',Cadena_Vacia)
						  ELSE REPLACE(CONVERT(Fecha_Vacia,CHAR),'-',Cadena_Vacia)
					END,';',
					ROUND(IFNULL(MonUltPagoCap,Entero_Cero),Par_NumDecimales),';',
					CASE WHEN IFNULL(FecUltPagoInt,Fecha_Vacia) != Fecha_Vacia THEN
							REPLACE(CONVERT(IFNULL(FecUltPagoInt,Fecha_Vacia),CHAR),'-',Cadena_Vacia)
						 ELSE REPLACE(CONVERT(Fecha_Vacia,CHAR),'-',Cadena_Vacia)
					END ,';',
					ROUND(IFNULL(MonUltPagoInt,Entero_Cero),Par_NumDecimales),';',
                    REPLACE(FecPrimAtraso,'-',Cadena_Vacia),';',
					ROUND(IFNULL(MontoCondona,Entero_Cero),Par_NumDecimales),';',
                    REPLACE(FecUltCondona,'-',Cadena_Vacia),';',
					IFNULL(NumDiasAtraso,Entero_Cero),	';',
					IFNULL(TipoCredito,Cadena_Vacia),';',
					IFNULL(SituacContable,Cadena_Vacia),';',
					ROUND(IFNULL(SalCapital,Entero_Cero),Par_NumDecimales),';',
					ROUND(IFNULL(SalIntOrdin,Entero_Cero),Par_NumDecimales),';',
					ROUND(IFNULL(SalIntMora,Entero_Cero),Par_NumDecimales),';',
					ROUND(IFNULL(SalIntCtaOrden,Entero_Cero),Par_NumDecimales),';',
					ROUND(IFNULL(SalMoraCtaOrden,Entero_Cero),Par_NumDecimales),';',
					ROUND(IFNULL(IntereRefinan,Entero_Cero),Par_NumDecimales),';',
					ROUND(IFNULL(SaldoInsoluto,Entero_Cero),Par_NumDecimales),';',
					IFNULL(TipoRelacion,Cadena_Vacia),';',
					IFNULL(TipCarCalifi,Cadena_Vacia),';',
					IFNULL(CalifiIndiv,Cadena_Vacia),';',
					IFNULL(CalifCubierta,Cadena_Vacia),';',
					IFNULL(CalifExpuesta,Cadena_Vacia),';',
					ROUND(IFNULL(ReservaCubierta, Entero_Cero) * -1, Par_NumDecimales),';',
					ROUND(IFNULL(ReservaExpuesta, Entero_Cero) * -1,Par_NumDecimales),';',
					ROUND(IFNULL(EPRCAdiCarVen, Entero_Cero) * -1,Par_NumDecimales),';',
					ROUND(IFNULL(EPRCAdiSIC, Entero_Cero) * -1,Par_NumDecimales),';',
					ROUND(IFNULL(EPRCAdiCNVB, Entero_Cero) * -1,Par_NumDecimales),';',
					REPLACE(IFNULL(FecConsultaSIC,Fecha_Vacia),'-',Cadena_Vacia),';',
					IFNULL(ClaveSIC,Cadena_Vacia),';',
					ROUND(IFNULL(TotGtiaLiquida, Entero_Cero),Par_NumDecimales),';',
					ROUND(IFNULL(GtiaHipotecaria, Entero_Cero),Par_NumDecimales)) AS Valor

				FROM TMPREGR04C0451 Tem
				WHERE Tem.NumTransaccion = Aud_NumTransaccion;
		END IF;
	END IF;

	DELETE FROM TMPREGR04C0451
		WHERE NumTransaccion = Aud_NumTransaccion;

END TerminaStore$$