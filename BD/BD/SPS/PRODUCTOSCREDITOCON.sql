-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PRODUCTOSCREDITOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PRODUCTOSCREDITOCON`;

DELIMITER $$
CREATE PROCEDURE `PRODUCTOSCREDITOCON`(
# =============================================================
# ------- STORE DE CONSULTA PARA PRODUCTOS DE CREDITO ---------
# =============================================================
	Par_ProducCreditoID		INT,				-- Numero de producto de credito
	Par_NumCon				TINYINT UNSIGNED,	-- Numero de consulta

	-- Parametros de Auditoria
	Par_EmpresaID			INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

-- Declaracion  de constantes
DECLARE	Cadena_Vacia		CHAR(1);	-- Constante cadena vacia
DECLARE	Fecha_Vacia			DATE;		-- Cosntante fecha vacia
DECLARE	Entero_Cero			INT(11);	-- Cosntante Cero
DECLARE	Con_Principal		INT;		-- Consulta Principal
DECLARE	Con_Foranea			INT;		-- Cosnulta Foranea
DECLARE	Con_Grupal			INT;		-- Cosnulta Grupal
DECLARE Con_GarantiaLiq		INT;		-- Consulta Garantia
DECLARE Con_Existencia		INT;		-- Consulta Existencia
DECLARE Con_Ind				INT;		-- Cosnulta Productos individuales
DECLARE Con_Agro			INT;		-- Cosnulta Productos Agro
DECLARE	Con_TipoCalIntPro	INT;		-- Consulta del tipo de calculo de Interes Por producto de credito para ws de Milagro

DECLARE	NomanejaLin			CHAR(1);	-- Constante no maneja liena
DECLARE NoRequiereGL		CHAR(1);	-- Constante no requiere Garantia Liquida
DECLARE Var_ProducCreditoID INT;


-- Asignacion de constantes
SET	Cadena_Vacia		:= '';			 -- Cadena Vacia
SET	Fecha_Vacia			:= '1900-01-01'; -- Fecha Vacia
SET	Entero_Cero			:=  0;			 -- Enero cero
SET	Con_Principal		:=  1;			 -- Consulta principal
SET	Con_Foranea			:=  2;			 -- Consulta Foranea
SET	Con_Grupal			:=  4;			 -- Consulta de producto Grupal
SET	Con_GarantiaLiq		:=  5;			 -- consulta los datos de garantia liquida para un producto de credito
SET	Con_Existencia		:=  6;			 -- Consulta la existencia de un producto de credito
SET	Con_Ind				:=  7;			 -- Consulta los productos individuales
SET	Con_Agro			:=  8;			 -- Consulta los productos agropecuarios
SET	Con_TipoCalIntPro	:=  9;			-- Consulta del tipo de calculo de Interes Por producto de credito para ws de Milagro

SET	NomanejaLin 	:= 'N';			 -- No maneja linea
SET	NoRequiereGL	:= 'N';			 -- No Requiere Garantia liquida

-- 1.- Consulta principal
IF(Par_NumCon = Con_Principal) THEN
	SELECT	ProducCreditoID,		Descripcion,		Caracteristicas,			CobraIVAInteres,		CobraIVAMora,
			CobraFaltaPago,			CobraMora,			FactorMora,					TipoPersona, 			ManejaLinea,
			EsRevolvente,			EsGrupal,			RequiereGarantia,			RequiereAvales,			GraciaFaltaPago,
			GraciaMoratorios,		Garantizado,		MontoMinimo, 				MontoMaximo,	 		DiasSuspesion,
			EsReestructura,			EsAutomatico,		MargenPagIgual,				TipoComXapert,			MontoComXapert,
			AhoVoluntario,			PorcAhoVol,			ClasifRegID,				Tipo,					ForCobroComAper,
			CalcInteres,			TipoContratoBCID,	TipoCalInteres,     		InstitutFondID,
			MaxIntegrantes,			MinIntegrantes,		PerRompimGrup,				RaIniCicloGrup,			RaFinCicloGrup,
			RelGarantCred,			PerAvaCruzados,		PerGarCruzadas,				CriterioComFalPag,		MontoMinComFalPag,
			RegistroRECA,			FechaInscripcion,	NombreComercial,			TipoCredito,			MinMujeresSol,
			MaxMujeresSol,			MinMujeres,			MaxMujeres,					MinHombres,				MaxHombres,
			TasaPonderaGru,			TipoPagoSeguro,		ReqSeguroVida,				FactorRiesgoSeguro,		MontoPolSegVida,
			DescuentoSeguro,		TipCobComMorato,	DiasPasoAtraso,				ProyInteresPagAde,		TipCobComFalPago,
			PerCobComFalPag,        ProrrateoComFalPag, ValidaCapConta,         	PorcMaxCapConta,        ProrrateoPago,
			PermitePrepago,     	ProductoNomina,     ModificarPrepago,        	TipoPrepago,			AutorizaComite,
			TipoContratoCCID,		CalculoRatios,		AfectacionContable,			InicioAfuturo,			DiasMaximo,
			Modalidad, 				EsquemaSeguroID,	TipoPagoComFalPago, 		CantidadAvales,			IntercambiaAvales,
            PermiteAutSolPros, 		RequiereReferencias, MinReferencias,			CobraSeguroCuota,		CobraIVASeguroCuota,
            ClaveRiesgo,			ClaveCNBV,			RequiereCheckList,			PerConsolidacion,		ReqInsDispersion,
            EsAgropecuario,			Refinanciamiento,	TipoAutomatico,				PorcentajeMaximo,		FinanciamientoRural,
            ParticipaSpei,			ProductoCLABE,		DiasAtrasoMin,				ReqObligadosSolidarios,	PerObligadosCruzados,
            ReqConsultaSIC,			CobraAccesorios,	CobraComAnual,				TipoComAnual,			ValorComAnual,
            TipoGeneraInteres,		RequiereAnalisiCre,	ReqConsolidacionAgro,		FechaDesembolso,		ValidaConyuge,
            Estatus
    FROM PRODUCTOSCREDITO
    WHERE  ProducCreditoID = Par_ProducCreditoID;
END IF;

-- 2.- Consulta Foranea
IF(Par_NumCon = Con_Foranea) THEN
    SELECT	ProducCreditoID,	Descripcion, 	AhoVoluntario, 	PorcAhoVol, 		ProrrateoPago,
			ManejaLinea, 		EsGrupal,		PermitePrepago, ModificarPrepago,	TipoContratoCCID,
            MontoMinimo,        MontoMaximo, 	Modalidad,		EsquemaSeguroID,    RequiereAnalisiCre,
            Estatus
    FROM PRODUCTOSCREDITO
    WHERE  ProducCreditoID = Par_ProducCreditoID;
END IF;

-- 4.- Consulta de producto Grupal
IF(Par_NumCon = Con_Grupal) THEN
	SELECT	ProducCreditoID,	EsGrupal,				PerRompimGrup,			RaIniCicloGrup,
			RaFinCicloGrup,		RegistroRECA,			FechaInscripcion,		NombreComercial,
			TipoCredito,		MinMujeresSol,			MaxMujeresSol,			MinMujeres,
			MaxMujeres,			MinHombres,				MaxHombres,				TasaPonderaGru,
			MaxIntegrantes,		MinIntegrantes
    FROM PRODUCTOSCREDITO
    WHERE  ProducCreditoID = Par_ProducCreditoID;
END IF;

# Consulta para obtener la parametrizacion de la Garantia Liquida
-- 5.- Consulta los datos de garantia liquida para un producto de credito
IF(Par_NumCon = Con_GarantiaLiq) THEN
	SELECT	ProducCreditoID,		IFNULL(Garantizado,NoRequiereGL) AS RequiereGarantia,	IFNULL(LiberarGaranLiq,NoRequiereGL) AS	LiberarGaranLiq,	BonificacionFOGA,	DesbloqAutFOGA,
			RequiereGarFOGAFI,		ModalidadFOGAFI,										BonificacionFOGAFI,											DesbloqAutFOGAFI
    FROM PRODUCTOSCREDITO
    WHERE  ProducCreditoID = Par_ProducCreditoID;
END IF;

/* No. de Consulta 6
   Usado en: alta de solicitudes grupales via WS para Sana Tus Finanzas
*/
IF(Par_NumCon = Con_Existencia) THEN
	SELECT	ProducCreditoID INTO Var_ProducCreditoID
		FROM PRODUCTOSCREDITO
			WHERE  ProducCreditoID = Par_ProducCreditoID;

    SELECT IFNULL(Var_ProducCreditoID,Entero_Cero) ProducCreditoID;

END IF;

/**
	No. de Consulta 7
	Consulta solo los productos indivuales, se utiliza en el alta de esquema de seguros
**/
IF(Par_NumCon = Con_Ind) THEN
	SELECT	ProducCreditoID,		Descripcion,		Caracteristicas,			CobraIVAInteres,		CobraIVAMora,
			CobraFaltaPago,			CobraMora,			FactorMora,					TipoPersona, 			ManejaLinea,
			EsRevolvente,			EsGrupal,			RequiereGarantia,			RequiereAvales,			GraciaFaltaPago,
			GraciaMoratorios,		Garantizado,		MontoMinimo, 				MontoMaximo,	 		DiasSuspesion,
			EsReestructura,			EsAutomatico,		MargenPagIgual,				TipoComXapert,			MontoComXapert,
			AhoVoluntario,			PorcAhoVol,			ClasifRegID,				Tipo,					ForCobroComAper,
			CalcInteres,			TipoContratoBCID,	TipoCalInteres,     		InstitutFondID,
			MaxIntegrantes,			MinIntegrantes,		PerRompimGrup,				RaIniCicloGrup,			RaFinCicloGrup,
			RelGarantCred,			PerAvaCruzados,		PerGarCruzadas,				CriterioComFalPag,		MontoMinComFalPag,
			RegistroRECA,			FechaInscripcion,	NombreComercial,			TipoCredito,			MinMujeresSol,
			MaxMujeresSol,			MinMujeres,			MaxMujeres,					MinHombres,				MaxHombres,
			TasaPonderaGru,			TipoPagoSeguro,		ReqSeguroVida,				FactorRiesgoSeguro,		MontoPolSegVida,
			DescuentoSeguro,		TipCobComMorato,	DiasPasoAtraso,				ProyInteresPagAde,		TipCobComFalPago,
			PerCobComFalPag,        ProrrateoComFalPag, ValidaCapConta,         	PorcMaxCapConta,        ProrrateoPago,
			PermitePrepago,     	ProductoNomina,     ModificarPrepago,        	TipoPrepago,			AutorizaComite,
			TipoContratoCCID,		CalculoRatios,		AfectacionContable,			InicioAfuturo,			DiasMaximo,
			Modalidad, 				EsquemaSeguroID,	TipoPagoComFalPago, 		CantidadAvales,			IntercambiaAvales,
            PermiteAutSolPros, 		RequiereReferencias, MinReferencias,			CobraSeguroCuota,		CobraIVASeguroCuota,
            ClaveRiesgo,			ClaveCNBV,			RequiereCheckList,			EsAgropecuario,			Refinanciamiento,
            TipoAutomatico,			PorcentajeMaximo,	FinanciamientoRural,		ParticipaSpei,			ProductoCLABE,
            DiasAtrasoMin,			ReqObligadosSolidarios,	PerObligadosCruzados, 	ReqConsultaSIC,			CobraAccesorios,
            CobraComAnual,			TipoComAnual,		ValorComAnual,				 TipoGeneraInteres,		RequiereAnalisiCre,
            PerConsolidacion,		ReqInsDispersion,
			ReqConsolidacionAgro,	FechaDesembolso,	Estatus
    FROM PRODUCTOSCREDITO
    WHERE  ProducCreditoID = Par_ProducCreditoID AND
    EsGrupal = 'N';
END IF;

-- 8.- Consulta los productos a
IF(Par_NumCon = Con_Agro) THEN
	SELECT	ProducCreditoID,		Descripcion,		Caracteristicas,			CobraIVAInteres,		CobraIVAMora,
			CobraFaltaPago,			CobraMora,			FactorMora,					TipoPersona, 			ManejaLinea,
			EsRevolvente,			EsGrupal,			RequiereGarantia,			RequiereAvales,			GraciaFaltaPago,
			GraciaMoratorios,		Garantizado,		MontoMinimo, 				MontoMaximo,	 		DiasSuspesion,
			EsReestructura,			EsAutomatico,		MargenPagIgual,				TipoComXapert,			MontoComXapert,
			AhoVoluntario,			PorcAhoVol,			ClasifRegID,				Tipo,					ForCobroComAper,
			CalcInteres,			TipoContratoBCID,	TipoCalInteres,     		InstitutFondID,
			MaxIntegrantes,			MinIntegrantes,		PerRompimGrup,				RaIniCicloGrup,			RaFinCicloGrup,
			RelGarantCred,			PerAvaCruzados,		PerGarCruzadas,				CriterioComFalPag,		MontoMinComFalPag,
			RegistroRECA,			FechaInscripcion,	NombreComercial,			TipoCredito,			MinMujeresSol,
			MaxMujeresSol,			MinMujeres,			MaxMujeres,					MinHombres,				MaxHombres,
			TasaPonderaGru,			TipoPagoSeguro,		ReqSeguroVida,				FactorRiesgoSeguro,		MontoPolSegVida,
			DescuentoSeguro,		TipCobComMorato,	DiasPasoAtraso,				ProyInteresPagAde,		TipCobComFalPago,
			PerCobComFalPag,        ProrrateoComFalPag, ValidaCapConta,         	PorcMaxCapConta,        ProrrateoPago,
			PermitePrepago,     	ProductoNomina,     ModificarPrepago,        	TipoPrepago,			AutorizaComite,
			TipoContratoCCID,		CalculoRatios,		AfectacionContable,			InicioAfuturo,			DiasMaximo,
			Modalidad, 				EsquemaSeguroID,	TipoPagoComFalPago, 		CantidadAvales,			IntercambiaAvales,
            PermiteAutSolPros, 		RequiereReferencias, MinReferencias,			CobraSeguroCuota,		CobraIVASeguroCuota,
            ClaveRiesgo,			ClaveCNBV,			RequiereCheckList,			EsAgropecuario, 		Refinanciamiento,
            TipoAutomatico,			PorcentajeMaximo,	FinanciamientoRural,		ParticipaSpei,			ProductoCLABE,
            DiasAtrasoMin,			ReqObligadosSolidarios,	PerObligadosCruzados,	ReqConsultaSIC,			CobraAccesorios,
			CobraComAnual,			TipoComAnual,		ValorComAnual,				TipoGeneraInteres,		RequiereAnalisiCre,
			PerConsolidacion,		ReqInsDispersion,	ReqConsolidacionAgro,		FechaDesembolso,	Estatus
    FROM PRODUCTOSCREDITO
    WHERE  ProducCreditoID = Par_ProducCreditoID AND
    EsAgropecuario = 'S';
END IF;

	-- 9.- Consulta del tipo de calculo de Interes Por producto de credito para ws de Milagro
	IF(Par_NumCon = Con_TipoCalIntPro) THEN
		SELECT ProducCreditoID,			TipoCalInteres,		CobraSeguroCuota,		CobraIVASeguroCuota,		CobraAccesorios
			FROM PRODUCTOSCREDITO
			WHERE ProducCreditoID = Par_ProducCreditoID;
	END IF;


END TerminaStore$$