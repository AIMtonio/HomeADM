DELIMITER ;
DROP PROCEDURE IF EXISTS `BANPRODUCTOSCREDITOSLIS`;
DELIMITER $$
CREATE  PROCEDURE `BANPRODUCTOSCREDITOSLIS`(
	Par_ProducCreditoID				INT(11),				-- Parametro producto de credito
	Par_NumLis						TINYINT UNSIGNED,		-- Parametro numero de lista

	Aud_EmpresaID					INT(11),				-- Parametro de Auditoria
	Aud_Usuario						INT(11),				-- Parametro de Auditoria
	Aud_FechaActual					DATETIME,				-- Parametro de Auditoria
	Aud_DireccionIP					VARCHAR(15),			-- Parametro de Auditoria
	Aud_ProgramaID					VARCHAR(50),			-- Parametro de Auditoria
	Aud_Sucursal					INT(11),				-- Parametro de Auditoria
	Aud_NumTransaccion				BIGINT(20)				-- Parametro de Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE Var_NumLisPrincipal		TINYINT UNSIGNED;		-- Lista principal
	DECLARE Var_NumLisBancas		TINYINT UNSIGNED;		-- Lista bancas
	DECLARE Var_NumLisFormular		TINYINT UNSIGNED;		-- Lista formulario web
	DECLARE Entero_Cero				INT(1);					-- Entero cero
	DECLARE Cadena_Vacia			CHAR(1);				-- Cadena Vacia

	-- Asignacion de constantes
	SET Var_NumLisPrincipal			:= 1;					-- Lista principal
	SET Var_NumLisBancas			:= 2;					-- Lista para bancas
	SET Var_NumLisFormular			:= 3;					-- Lista para formulario web
	SET Entero_Cero					:= 0;					-- Entero cero
	SET	Cadena_Vacia				:= '';					-- Cadena Vacia
	-- Asignacion de valores por defecto

	SET Par_ProducCreditoID := IFNULL(Par_ProducCreditoID, Entero_Cero);


	IF (Par_NumLis = Var_NumLisPrincipal) THEN


		SELECT	ProducCreditoID,		Descripcion,			FactorMora,					MontoMinimo,		MontoMaximo
				FROM PRODUCTOSCREDITO
				WHERE ProducCreditoID = IF (Par_ProducCreditoID > Entero_Cero, Par_ProducCreditoID, ProducCreditoID)
				ORDER BY ProducCreditoID;
	END IF;

	IF (Par_NumLis = Var_NumLisBancas) THEN

		SELECT	ProducCreditoID,		Descripcion
				FROM PRODUCTOSCREDITO Prod
				INNER JOIN PRODUCTOSCREDITOBE ProdBe ON Prod.ProducCreditoID = ProdBe.ProductoCreditoID
				WHERE ProducCreditoID = IF (Par_ProducCreditoID > Entero_Cero, Par_ProducCreditoID, ProducCreditoID)
				ORDER BY ProducCreditoID;
	END IF;

	IF (Par_NumLis = Var_NumLisFormular) THEN

		SELECT	DISTINCT 	ProducCreditoID,		Descripcion,			Caracteristicas,			CobraIVAInteres,			CobraIVAMora,
							CobraFaltaPago,			CobraMora,				FactorMora,					TipoPersona,				ManejaLinea,
							EsRevolvente,			EsGrupal,				RequiereGarantia,			BonificacionFOGA,			DesbloqAutFOGA,
							RequiereGarFOGAFI,		ModalidadFOGAFI,		BonificacionFOGAFI,			DesbloqAutFOGAFI,			RequiereAvales,
							GraciaFaltaPago,		GraciaMoratorios,		Garantizado,				LiberarGaranLiq,			MontoMinimo,
							MontoMaximo,			DiasSuspesion,			EsReestructura,				EsAutomatico,				MargenPagIgual,
							TipoComXapert,			MontoComXapert,			AhoVoluntario,				PorcAhoVol,					ClasifRegID,
							Tipo,					ForCobroComAper,		CalcInteres,				TipoContratoBCID,			TipoCalInteres,
							TipoGeneraInteres,		InstitutFondID,			MaxIntegrantes,				MinIntegrantes,				PerRompimGrup,
							RaIniCicloGrup,			RaFinCicloGrup,			RelGarantCred,				PerAvaCruzados,				PerGarCruzadas,
							CriterioComFalPag,		MontoMinComFalPag,		RegistroRECA,				FechaInscripcion,			NombreComercial,
							TipoCredito,			MinMujeresSol,			MaxMujeresSol,				MinMujeres,					MaxMujeres,
							MinHombres,				MaxHombres,				TasaPonderaGru,				ReqSeguroVida,				TipoPagoSeguro,
							FactorRiesgoSeguro,		DescuentoSeguro,		MontoPolSegVida,			ProyInteresPagAde,			TipCobComFalPago,
							PerCobComFalPag,		ProrrateoComFalPag,		TipCobComMorato,			DiasPasoAtraso,				TipoPagoComFalPago,
							ValidaCapConta,			PorcMaxCapConta,		ProrrateoPago,				PermitePrepago,				ProductoNomina,
							ModificarPrepago,		TipoPrepago,			AutorizaComite,				TipoContratoCCID,			CalculoRatios,
							AfectacionContable,		InicioAfuturo,			DiasMaximo,					Modalidad,					EsquemaSeguroID,
							CantidadAvales,			IntercambiaAvales,		PermiteAutSolPros,			ClaveRiesgo,				RequiereReferencias,
							MinReferencias,			ClaveCNBV,				RequiereCheckList,			EsAgropecuario,				Refinanciamiento,
							TipoAutomatico,			PorcentajeMaximo,		FinanciamientoRural,		ParticipaSpei,				ProductoCLABE,
							DiasAtrasoMin,			ReqObligadosSolidarios,	PerObligadosCruzados,		ReqConsultaSIC,				CobraAccesorios,
							CobraComAnual,			TipoComAnual,			ValorComAnual,				CobraSeguroCuota,			CobraIVASeguroCuota
				FROM PRODUCTOSCREDITO Prod
				INNER JOIN PRODUCTOSCREDITOFW ProdBe ON Prod.ProducCreditoID = ProdBe.ProductoCreditoID
				WHERE ProducCreditoID = IF (Par_ProducCreditoID > Entero_Cero, Par_ProducCreditoID, ProducCreditoID)
				ORDER BY ProducCreditoID;
	END IF;


END TerminaStore$$