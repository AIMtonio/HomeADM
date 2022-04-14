-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SALDOSTOTALESAGROREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `SALDOSTOTALESAGROREP`;

DELIMITER $$
CREATE PROCEDURE `SALDOSTOTALESAGROREP`(
	/*SP QUE GENERA EL REPORTE DE ANALITICO DE CARTERA AGROPECUARIA*/
	Par_Fecha			DATE,			# Fecha corte
	Par_Sucursal		INT(11),		# Numero de Sucursal
	Par_Moneda			INT(11),		# Id de la Moneda
	Par_ProductoCre		INT(11),		# Id del Prodcucto de Crédito
	Par_Promotor		INT(11),		# promotor que tiene el cliente

	Par_Genero  		CHAR(1),		# sexo F o M
	Par_Estado 			INT(11),		# de la tabla de DIRECCLIENTE
	Par_Municipio  		INT(11),		# de la tabla de DIRECCLIENTE
	Par_Clasificacion	INT(11),		# de la tabla de CLASIFICCREDITO
	Par_AtrasoInicial	INT(11),

	Par_AtrasoFinal		INT(11),
	Par_NumList			TINYINT UNSIGNED,
	/*Auditoria*/
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
	)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE Var_Sentencia 			TEXT(90000);
	DECLARE Var_ExisteCobraSeguro	INT(11);	-- Existen creditos que cobran seguros
	DECLARE Var_NatMovimiento		CHAR(1);
	DECLARE Var_PerFisica			CHAR(1);

	-- Declaracion de Variables
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE CienPorciento			DECIMAL(16,2);
	DECLARE Con_Foranea				INT;
	DECLARE Con_PagareImp 			INT;
	DECLARE Con_PagareTfija			INT;
	DECLARE Con_PagoCred			INT;
	DECLARE Con_Saldos				INT;
	DECLARE Entero_Cero				INT;
	DECLARE EstatusAtras			CHAR(1);
	DECLARE EstatusPagado			CHAR(1);
	DECLARE EstatusVencido			CHAR(1);
	DECLARE EstatusVigente			CHAR(1);
	DECLARE Fecha_Vacia				DATE;
	DECLARE FechaSist				DATE;
	DECLARE Lis_SaldosRep			INT;
	DECLARE Lis_SaldosRepEx			INT;
	DECLARE PagoAnual				CHAR(1);	-- PagoAnual (A)
	DECLARE PagoBimestral			CHAR(1);	-- PagoBimestral (B)
	DECLARE PagoCatorcenal			CHAR(1);	-- Pago Catorcenal (C)
	DECLARE PagoMensual				CHAR(1);	-- Pago Mensual (M)
	DECLARE PagoPeriodo				CHAR(1);	-- Pago por periodo (P)
	DECLARE PagoQuincenal			CHAR(1);	-- Pago Quincenal (Q)
	DECLARE PagoSemanal				CHAR(1);	-- Pago Semanal (S)
	DECLARE PagoSemestral			CHAR(1);	-- PagoSemestral (E)
	DECLARE PagoTetrames			CHAR(1);	-- PagoTetraMestral (R)
	DECLARE PagoTrimestral			CHAR(1);	-- PagoTrimestral (T)
	DECLARE PagoUnico				CHAR(1);	-- PagoUnico (U)
	DECLARE Con_Consol				INT(11);	-- Cliente especifico Consol
	DECLARE Var_CliEspeficio		INT(11);	-- Cliente especifico

	-- Asignacion de constantes
	SET Cadena_Vacia				:= '';
	SET CienPorciento				:= 100.00;
	SET Entero_Cero					:= 0;
	SET EstatusAtras				:= 'A';
	SET EstatusPagado				:= 'P';
	SET EstatusVencido				:= 'B';
	SET EstatusVigente				:= 'V';
	SET Fecha_Vacia					:= '1900-01-01';
	SET Lis_SaldosRep				:= 2;
	SET Lis_SaldosRepEx				:= 3;
	SET PagoAnual					:= 'A';			-- PagoAnual
	SET PagoBimestral				:= 'B';			-- PagoBimestral
	SET PagoCatorcenal				:= 'C';			-- PagoCatorcenal
	SET PagoMensual					:= 'M';			-- PagoMensual
	SET PagoPeriodo					:= 'P';			-- PagoPeriodo
	SET PagoQuincenal				:= 'Q';			-- PagoQuincenal
	SET PagoSemanal					:= 'S';			-- PagoSemanal
	SET PagoSemestral				:= 'E';			-- PagoSemestral
	SET PagoTetrames				:= 'R';			-- PagoTetraMestral
	SET PagoTrimestral				:= 'T';			-- PagoTrimestral
	SET PagoUnico					:= 'U';
	SET Var_NatMovimiento			:= 'A';			-- Naturaleza de Moviemiento Abono
	SET Var_PerFisica 				:= 'F';
	SET FechaSist := (SELECT FechaSistema FROM PARAMETROSSIS);
	SET Con_Consol					:=	10;
	SET Var_CliEspeficio			:=	(SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = 'CliProcEspecifico');

	DROP TABLE IF EXISTS tmp_TMPSALDOSTOTALESAGROREP;
	CREATE TEMPORARY TABLE tmp_TMPSALDOSTOTALESAGROREP(
	Transaccion			BIGINT,
	CreditoID			BIGINT(12),
	ProductoCreditoID	INT(12),
	Descripcion 		VARCHAR(200),
	ClienteID			INT(12),
	NombreCompleto		VARCHAR(200),

	DestinoCredID		INT(11),
	DesDestino			VARCHAR(300),
	CreditoFondeoID		BIGINT(20),		/*Tabla RELCREDPASIVOAGRO*/
	FuenteFondeo		VARCHAR(200),
	AcreditadoIDFIRA	BIGINT(20),
	CreditoIDFIRA		BIGINT(20),
	GarantiaDes			VARCHAR(45),
	SubClasifID			INT(11),
	ClaseCredito		VARCHAR(100),	/*Tabla CLASIFICCREDITO*/
	CveRamaFIRA			INT(11),
	DescripcionRamaFIRA	VARCHAR(30),	/*Tabla CATRAMAFIRA*/
	FechaMinistrado		DATE,
	FechaProxVenc		VARCHAR(20),
	MontoProxVenc		DECIMAL(14,2),	/*Tabla AMORTICREDITO*/
	ActividadFIRAID		INT(11),
	ActividadDes		VARCHAR(45),	/*Tabla CATACTIVIDADFIRA*/
	CveCadena			INT(11),
	NomCadenaProdSCIAN	VARCHAR(45),	/*Tabla CATCADENAPRODUCTIVA*/
	Estatus 			CHAR(1),		/*Tabla CREDITOS*/
	ProgEspecialFIRAID	VARCHAR(10),	/*Tabla CATFIRAPROGESP*/
	SubPrograma			VARCHAR(100),
	TipoPersona			CHAR(1),		/*Tabla CLIENTES*/
	PorcComision		DECIMAL(14,2),
	ConceptoInv			VARCHAR(100),
	NumeroUnidades		INT(11),		/*No se guarda va vacio por lo mientras*/
	UnidadesMedida		VARCHAR(100),	/*No se guarda va vacio por lo mientras*/
	GrupoID				INT(11),
	NombreGrupo			VARCHAR(200),	/*Tabla GRUPOSCREDITO*/

	SaldoCapVigent		DECIMAL(16,2),
	SaldoCapAtrasad		DECIMAL(16,2),
	SaldoCapVencido		DECIMAL(16,2),
	SaldCapVenNoExi		DECIMAL(16,2),
	SaldoInterProvi		DECIMAL(16,2),
	SaldoInterAtras		DECIMAL(16,2),
	SaldoInterVenc		DECIMAL(16,2),
	SaldoIntNoConta		DECIMAL(16,2),
	SaldoMoratorios		DECIMAL(16,2),
	SaldComFaltPago		DECIMAL(16,2),
	SaldoOtrasComis		DECIMAL(16,2),
	SaldoIVAInteres		DECIMAL(16,2),
	SaldoIVAMorator		DECIMAL(16,2),
	SalIVAComFalPag		DECIMAL(16,2),
	SaldoIVAComisi		DECIMAL(16,2),
	PasoCapAtraDia		DECIMAL(16,2),
	PasoCapVenDia		DECIMAL(16,2),
	PasoCapVNEDia 		DECIMAL(16,2),
	PasoIntAtraDia		DECIMAL(16,2),
	PasoIntVenDia		DECIMAL(16,2),
	CapRegularizado		DECIMAL(16,2),
	IntOrdDevengado		DECIMAL(16,2),
	IntMorDevengado		DECIMAL(16,2),
	ComisiDevengado		DECIMAL(16,2),
	PagoCapVigDia		DECIMAL(16,2),
	PagoCapAtrDia		DECIMAL(16,2),
	PagoCapVenDia		DECIMAL(16,2),
	PagoCapVenNexDia	DECIMAL(16,2),
	PagoIntOrdDia		DECIMAL(16,2),
	PagoIntAtrDia		DECIMAL(16,2),
	PagoIntVenDia		DECIMAL(16,2),
	PagoIntCalNoCon		DECIMAL(16,2),
	PagoComisiDia		DECIMAL(16,2),
	PagoMoratorios		DECIMAL(16,2),
	PagoIvaDia			DECIMAL(16,2),
	IntCondonadoDia		DECIMAL(16,2),
	MorCondonadoDia		DECIMAL(16,2),
	IntDevCtaOrden		DECIMAL(16,2),
	CapCondonadoDia		DECIMAL(16,2),
	ComAdmonPagDia		DECIMAL(16,2),
	ComCondonadoDia		DECIMAL(16,2),
	DesembolsosDia		DECIMAL(16,2),
	FechaInicio			DATE,
	FechaVencimiento	DATE,
	FechaUltAbonoCre	DATE,
	FrecuenciaCap		VARCHAR(15),
	FrecuenciaInt		VARCHAR(15),
	CapVigenteExi		DECIMAL(16,2),
	MontoTotalExi		DECIMAL(16,2),
	MontoCredito		DECIMAL(16,2),
	TasaFija			DECIMAL(16,2),
	DiasAtraso			INT(12),
	SaldoDispon			DECIMAL(16,2),
	SaldoBloq			DECIMAL(16,2),
	FechaUltDepCta		DATE,
	PromotorID			INT(12),
	NombrePromotor		VARCHAR(200),
	FechaEmision		DATE,
	HoraEmision			TIME,
	MoraVencido 		DECIMAL(16,2),
	MoraCarVen			DECIMAL(16,2),
	CalcInteresID		INT(11),
	MontoSeguroCuota	DECIMAL(12,2),
	IVASeguroCuota		DECIMAL(12,2),
	FolioFondeo			VARCHAR(45),
	SaldoCapVigentePas	DECIMAL(14,2),		/*Tabla SALDOSCREDPASIVOS*/
	SaldoCapAtrasadPas	DECIMAL(14,2),		/*Tabla SALDOSCREDPASIVOS*/
	SaldoInteresProPas	DECIMAL(14,2),		/*Tabla SALDOSCREDPASIVOS*/
	SaldoInteresAtraPas	DECIMAL(14,2),		/*Tabla SALDOSCREDPASIVOS*/
	SucursalID			INT(11),
	NombreSucursal		VARCHAR(50)
	);

	SET Var_Sentencia := '
	INSERT INTO tmp_TMPSALDOSTOTALESAGROREP (
	Transaccion,			CreditoID,			ProductoCreditoID,		Descripcion,		ClienteID,
	NombreCompleto,			SaldoCapVigent,		SaldoCapAtrasad,		SaldoCapVencido,	SaldCapVenNoExi,
	SaldoInterProvi,		SaldoInterAtras,	SaldoInterVenc,			SaldoIntNoConta,	SaldoMoratorios,
	SaldComFaltPago,		SaldoOtrasComis,	SaldoIVAInteres,		SaldoIVAMorator,  	SalIVAComFalPag,
	SaldoIVAComisi,			PasoCapAtraDia,		PasoCapVenDia,			PasoCapVNEDia ,		PasoIntAtraDia,
	PasoIntVenDia,			CapRegularizado,	IntOrdDevengado, 		IntMorDevengado,	ComisiDevengado,
	PagoCapVigDia,  		PagoCapAtrDia,		PagoCapVenDia,			PagoCapVenNexDia, 	PagoIntOrdDia,
	PagoIntAtrDia, 			PagoIntVenDia,		PagoIntCalNoCon, 		PagoComisiDia,		PagoMoratorios,
	PagoIvaDia,				IntCondonadoDia, 	MorCondonadoDia,		IntDevCtaOrden, 	CapCondonadoDia,
	ComAdmonPagDia,  		ComCondonadoDia,	DesembolsosDia, 		FechaInicio, 		FechaVencimiento,
	FechaUltAbonoCre, 		MontoCredito, 		DiasAtraso, 			SaldoDispon,		SaldoBloq ,
	FechaUltDepCta, 		FrecuenciaCap,      FrecuenciaInt,			CapVigenteExi,      MontoTotalExi,
	TasaFija,				PromotorID, 		NombrePromotor,			FechaEmision,		HoraEmision,
	MoraVencido,			MoraCarVen,			CalcInteresID, 			MontoSeguroCuota,	IVASeguroCuota,
	FolioFondeo,			DestinoCredID,		DesDestino,				TipoPersona,		Estatus)';

	IF(Par_NumList = Lis_SaldosRep) THEN
		IF(Par_Fecha < FechaSist) THEN
			SET Var_Sentencia :=  'SELECT  Sal.CreditoID,		Cli.NombreCompleto,	Sal.SalCapVigente ,	Sal.SalCapAtrasado , ';
			SET Var_Sentencia :=  CONCAT(Var_Sentencia,'	 Sal.SalCapVencido ,	Sal.SalIntProvision ,	Sal.SalIntAtrasado , 	Sal.SalIntVencido , ');
			SET Var_Sentencia :=  CONCAT(Var_Sentencia,' Sal.SalCapVenNoExi ,	Sal.SalIntNoConta,
			(Sal.SalMoratorios + Sal.SaldoMoraVencido + Sal.SaldoMoraCarVen) AS SalMoratorios,	Sal.SalComFaltaPago , ');
			SET Var_Sentencia :=  CONCAT(Var_Sentencia,' (Sal.SalOtrasComisi + Sal.SaldoComServGar ) AS SalOtrasComisi , 	Sal.SalIVAInteres ,	Sal.SalIVAMoratorios ,Sal.SalIVAComFalPago , Sal.SalIVAComisi');
			SET Var_Sentencia :=  CONCAT(Var_Sentencia,' FROM SALDOSCREDITOS Sal ');
			SET Var_Sentencia :=  CONCAT(Var_Sentencia,' INNER JOIN CREDITOS Cre ON   Sal.CreditoID = Cre.CreditoID');
			SET Par_Moneda := IFNULL(Par_Moneda,Entero_Cero);

			IF(Par_Moneda!=0)THEN
				SET Var_Sentencia = CONCAT(Var_Sentencia,' AND Cre.MonedaID=',CONVERT(Par_Moneda,CHAR));
			END IF;

			SET Par_Sucursal := IFNULL(Par_Sucursal,Entero_Cero);
			IF(Par_Sucursal!=0)THEN
				SET Var_Sentencia = CONCAT(Var_Sentencia,' AND Cre.SucursalID=',CONVERT(Par_Sucursal,CHAR));
			END IF;
			SET Var_Sentencia := 	CONCAT(Var_Sentencia,' AND	(Cre.Estatus	= "',EstatusVigente,'" OR Cre.Estatus = "',EstatusVencido,'") ');
			SET Var_Sentencia := 	CONCAT(Var_Sentencia,' INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID');
			SET Par_Genero := IFNULL(Par_Genero,Cadena_Vacia);

			IF(Par_Genero!=Cadena_Vacia)THEN
				SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Cli.Sexo="',Par_Genero,'"');
				SET Var_Sentencia := CONCAT(Var_Sentencia,' AND CLI.TipoPersona="',Var_PerFisica,'"');
			END IF;

			SET Par_Estado := IFNULL(Par_Estado,Entero_Cero);
			IF(Par_Estado!=0)THEN
				SET Var_Sentencia := CONCAT(Var_Sentencia,' AND (SELECT Dir.EstadoID FROM DIRECCLIENTE Dir WHERE Dir.Oficial="S" AND Cre.ClienteID=Dir.ClienteID)=',CONVERT(Par_Estado,CHAR));
			END IF;

			SET Par_Municipio := IFNULL(Par_Municipio,Entero_Cero);
			IF(Par_Municipio!=0)THEN
				SET Var_Sentencia := CONCAT(Var_Sentencia,' AND (SELECT Dir.MunicipioID FROM DIRECCLIENTE Dir WHERE Dir.Oficial="S" AND Cre.ClienteID=Dir.ClienteID)=',CONVERT(Par_Municipio,CHAR));
			END IF;

			SET Par_ProductoCre := IFNULL(Par_ProductoCre,Entero_Cero);
			IF(Par_ProductoCre!=0)THEN
				SET Var_Sentencia :=  CONCAT(Var_Sentencia,' INNER JOIN PRODUCTOSCREDITO Pro ON Sal.ProductoCreditoID = Pro.ProducCreditoID');
				SET Var_Sentencia :=  CONCAT(Var_Sentencia,' AND Sal.ProductoCreditoID =',CONVERT(Par_ProductoCre,CHAR));
			END IF;

			SET Par_Promotor := IFNULL(Par_Promotor,Entero_Cero);
			IF(Par_Promotor!=0)THEN
				SET Var_Sentencia := 	CONCAT(Var_Sentencia,' INNER JOIN PROMOTORES PROM ');
				SET Var_Sentencia := CONCAT(Var_sentencia,'  ON PROM.PromotorID=Cli.PromotorActual AND PROM.PromotorID=',CONVERT(Par_Promotor,CHAR));
			END IF;

			SET Var_Sentencia :=  CONCAT(Var_Sentencia,'	 AND	Sal.FechaCorte = ? ');
			SET Var_Sentencia := 	CONCAT(Var_Sentencia,' AND Cre.EsAgropecuario="S"  ORDER BY Sal.CreditoID ASC ; ');
			SET @Sentencia	= (Var_Sentencia);
			SET @Fecha	= Par_Fecha;

			PREPARE STSALDOSTOTALESREP FROM @Sentencia;
			EXECUTE STSALDOSTOTALESREP USING @Fecha;
			DEALLOCATE PREPARE STSALDOSTOTALESREP;
		END IF;

		IF(Par_Fecha = FechaSist) THEN

			SET Var_Sentencia :=  'SELECT	Cre.CreditoID, Cli.NombreCompleto,	Cre.SaldoCapVigent AS SalCapVigente,	Cre.SaldoCapAtrasad AS SalCapAtrasado,	Cre.SaldoCapVencido AS SalCapVencido, ';
			SET Var_Sentencia := 	CONCAT(Var_Sentencia,' Cre.SaldCapVenNoExi AS SalCapVenNoExi,	ROUND(Cre.SaldoInterProvi,2) AS SalIntProvision,	ROUND(Cre.SaldoInterAtras,2) AS SalIntAtrasado, 	ROUND(Cre.SaldoInterVenc,2) AS SalIntVencido,	ROUND(Cre.SaldoIntNoConta,2) AS SalIntNoConta, ');
			SET Var_Sentencia := 	CONCAT(Var_Sentencia,' (Cre.SaldoMoratorios + Cre.SaldoMoraVencido + Cre.SaldoMoraCarVen ) AS SalMoratorios,	Cre.SaldComFaltPago AS SalComFaltaPago,(Cre.SaldoComServGar + Cre.SaldoOtrasComis) AS SalOtrasComisi,	Cre.SaldoIVAInteres AS SalIVAInteres,	Cre.SaldoIVAMorator AS SalIVAMoratorios, ');
			SET Var_Sentencia := 	CONCAT(Var_Sentencia,' Cre.SalIVAComFalPag AS SalIVAComFalPago,	Cre.SaldoIVAComisi AS SalIVAComisi');

			SET Var_Sentencia :=  CONCAT(Var_Sentencia,' FROM CREDITOS Cre ');
			SET Var_Sentencia := 	CONCAT(Var_Sentencia,' INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID');

			SET Par_Genero := IFNULL(Par_Genero,Cadena_Vacia);
			IF(Par_Genero!=Cadena_Vacia)THEN
				SET Var_Sentencia := CONCAT(Var_sentencia,' AND Cli.Sexo="',Par_Genero,'"');
				SET Var_Sentencia := CONCAT(Var_sentencia,' AND CLI.TipoPersona="',Var_PerFisica,'"');
			END IF;

			SET Par_Estado := IFNULL(Par_Estado,Entero_Cero);
			IF(Par_Estado!=0)THEN
				SET Var_Sentencia := CONCAT(Var_sentencia,' AND (SELECT Dir.EstadoID FROM DIRECCLIENTE Dir WHERE Dir.Oficial="S" AND Cre.ClienteID=Dir.ClienteID)=',CONVERT(Par_Estado,CHAR));
			END IF;

			SET Par_Municipio := IFNULL(Par_Municipio,Entero_Cero);
			IF(Par_Municipio!=0)THEN
				SET Var_Sentencia := CONCAT(Var_sentencia,' AND (SELECT Dir.MunicipioID FROM DIRECCLIENTE Dir WHERE Dir.Oficial="S" AND Cre.ClienteID=Dir.ClienteID)=',CONVERT(Par_Municipio,CHAR));
			END IF;


			SET Par_ProductoCre := IFNULL(Par_ProductoCre,Entero_Cero);
			IF(Par_ProductoCre!=0)THEN
				SET Var_Sentencia := 	CONCAT(Var_Sentencia,' INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID');
				SET Var_Sentencia :=  CONCAT(Var_Sentencia,' AND Cre.ProductoCreditoID =',CONVERT(Par_ProductoCre,CHAR));
			END IF;

			SET Par_Promotor := IFNULL(Par_Promotor,Entero_Cero);
			IF(Par_Promotor!=0)THEN
				SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN PROMOTORES PROM ');
				SET Var_Sentencia := CONCAT(Var_sentencia,'  ON PROM.PromotorID=Cli.PromotorActual AND PROM.PromotorID=',CONVERT(Par_Promotor,CHAR));
			END IF;

			SET Par_Moneda := IFNULL(Par_Moneda,Entero_Cero);
			IF(Par_Moneda!=0)THEN
				SET Var_Sentencia = CONCAT(Var_sentencia,' AND Cre.MonedaID=',CONVERT(Par_Moneda,CHAR));
			END IF;

			SET Par_Sucursal := IFNULL(Par_Sucursal,Entero_Cero);
			IF(Par_Sucursal!=0)THEN
				SET Var_Sentencia = CONCAT(Var_sentencia,' AND Cre.SucursalID=',CONVERT(Par_Sucursal,CHAR));
			END IF;

			SET Var_Sentencia := CONCAT(Var_Sentencia,' AND	(Cre.Estatus	= "',EstatusVigente,'" OR Cre.Estatus = "',EstatusVencido,'") ');
			SET Var_Sentencia := 	CONCAT(Var_Sentencia,'AND Cre.EsAgropecuario="S" ORDER BY Cre.CreditoID; ');
			SET @Sentencia	= (Var_Sentencia);
			SET @Fecha	= Par_Fecha;
			PREPARE STSALDOSTOTALESREP FROM @Sentencia;
			EXECUTE  STSALDOSTOTALESREP;
		END IF;
	END IF;

	IF(Par_NumList = Lis_SaldosRepEx) THEN
		IF(Par_Fecha < FechaSist) THEN

			SET Var_Sentencia :=  CONCAT(Var_Sentencia,'SELECT  CONVERT("',Aud_NumTransaccion,'",UNSIGNED INT),Sal.CreditoID,Sal.ProductoCreditoID, Prod.Descripcion, Cli.ClienteID,Cli.NombreCompleto, Sal.SalCapVigente,		Sal.SalCapAtrasado, ');
			SET Var_Sentencia :=  CONCAT(Var_Sentencia,' Sal.SalCapVencido,	Sal.SalCapVenNoExi,			Sal.SalIntProvision,	Sal.SalIntAtrasado, ');
			SET Var_Sentencia :=  CONCAT(Var_Sentencia,' Sal.SalIntVencido,	Sal.SalIntNoConta,
			(Sal.SalMoratorios) AS SalMoratorios,		Sal.SalComFaltaPago, ');
			SET Var_Sentencia := 	CONCAT(Var_Sentencia,' (Sal.SalOtrasComisi + Sal.SaldoComServGar) AS SalOtrasComisi, 	Sal.SalIVAInteres,		Sal.SalIVAMoratorios,	Sal.SalIVAComFalPago, 	Sal.SalIVAComisi, ');
			SET Var_Sentencia := 	CONCAT(Var_Sentencia,' Sal.PasoCapAtraDia,	Sal.PasoCapVenDia	,	Sal.PasoCapVNEDia,		Sal.PasoIntAtraDia, ');
			SET Var_Sentencia := 	CONCAT(Var_Sentencia,' Sal.PasoIntVenDia,	Sal.CapRegularizado,	Sal.IntOrdDevengado,	Sal.IntMorDevengado,	Sal.ComisiDevengado, ');
			SET Var_Sentencia := 	CONCAT(Var_Sentencia,' Sal.PagoCapVigDia,	Sal.PagoCapAtrDia,		Sal.PagoCapVenDia,		Sal.PagoCapVenNexDia,	Sal.PagoIntOrdDia, ');
			SET Var_Sentencia := 	CONCAT(Var_Sentencia,' Sal.PagoIntAtrDia,	Sal.PagoIntVenDia,		Sal.PagoIntCalNoCon,	Sal.PagoComisiDia,		Sal.PagoMoratorios, ');
			SET Var_Sentencia := 	CONCAT(Var_Sentencia,' Sal.PagoIvaDia,		Sal.IntCondonadoDia,	Sal.MorCondonadoDia, 	Sal.IntDevCtaOrden, 	Sal.CapCondonadoDia, Sal.ComAdmonPagDia,	');
			SET Var_Sentencia := 	CONCAT(Var_Sentencia,' Sal.ComCondonadoDia, Sal.DesembolsosDia ,	Sal.FechaInicio,		Sal.FechaVencimiento,');
			SET Var_Sentencia := 	CONCAT(Var_Sentencia,' (SELECT MAX(FechaAplicacion) FROM CREDITOSMOVS WHERE CreditoID=Sal.CreditoID AND NatMovimiento="',Var_NatMovimiento,'")AS FechaUltAbonoCre,');
			-- se agrego el if para el cliente espefico es consol.
			IF( Var_CliEspeficio = Con_Consol ) THEN
				SET Var_Sentencia := 	CONCAT(Var_Sentencia,' Sal.MontoCredito,Sal.DiasAtraso,Cue.SaldoDispon,Cue.SaldoBloq ,');
			ELSE
				SET Var_Sentencia := 	CONCAT(Var_Sentencia,' Sal.MontoCredito,
					CASE WHEN
							Sal.DiasAtraso > 0 THEN (Sal.DiasAtraso)-1
						ELSE Sal.DiasAtraso END AS DiasAtraso,
					Cue.SaldoDispon,Cue.SaldoBloq ,');
			END IF;

			SET Var_Sentencia := 	CONCAT(Var_Sentencia,' CONVERT((SELECT  CASE WHEN (SELECT IFNULL(MAX(Fecha),"',Fecha_Vacia,'") FROM CUENTASAHOMOV WHERE CuentaAhoID= Cre.CuentaID AND NatMovimiento="',Var_NatMovimiento,'") > ');
			SET Var_Sentencia := 	CONCAT(Var_Sentencia,' (SELECT IFNULL(MAX(Fecha),"',Fecha_Vacia,'")  FROM  `HIS-CUENAHOMOV` WHERE CuentaAhoID= Cre.CuentaID AND NatMovimiento="',Var_NatMovimiento,'")');
			SET Var_Sentencia := 	CONCAT(Var_Sentencia,' THEN ');
			SET Var_Sentencia := 	CONCAT(Var_Sentencia,' (SELECT IFNULL(MAX(Fecha),"',Fecha_Vacia,'") FROM CUENTASAHOMOV WHERE CuentaAhoID= Cre.CuentaID AND NatMovimiento="',Var_NatMovimiento,'") ');
			SET Var_Sentencia := 	CONCAT(Var_Sentencia,' ELSE ');
			SET Var_Sentencia := 	CONCAT(Var_Sentencia,' (SELECT IFNULL(MAX(Fecha),"',Fecha_Vacia,'")  FROM `HIS-CUENAHOMOV` WHERE CuentaAhoID= Cre.CuentaID AND NatMovimiento="',Var_NatMovimiento,'") END),CHAR) AS FechaUltDepCta,');
			SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' CASE Cre.FrecuenciaCap WHEN "',PagoSemanal,'" THEN "SEMANAL"');
			SET Var_Sentencia :=  CONCAT(Var_Sentencia, '  WHEN "',PagoCatorcenal,'"	THEN "CATORCENAL"');
			SET Var_Sentencia :=  CONCAT(Var_Sentencia, '  WHEN "',PagoQuincenal,'"	THEN "QUINCENAL"');
			SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' 	WHEN "',PagoMensual,'"	THEN "MENSUAL"');
			SET Var_Sentencia :=  CONCAT(Var_Sentencia, '	WHEN "',PagoPeriodo,'"	THEN "PERIODO"	');
			SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' 	WHEN "',PagoBimestral,'"	THEN "BIMESTRAL"');
			SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' 	WHEN "',PagoTrimestral,'"	THEN "TRIMESTRAL"');
			SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' 	WHEN "',PagoTetrames,'"	THEN "TETRAMES"');
			SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' 	WHEN "',PagoSemestral,'"	THEN "SEMESTRAL"');
			SET Var_Sentencia :=  CONCAT(Var_Sentencia, '	WHEN "',PagoAnual,'"	THEN "ANUAL"');
			SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' 	WHEN "',PagoUnico,'"	THEN "UNICO"');
			SET Var_Sentencia :=  CONCAT(Var_Sentencia, '  ELSE Cre.FrecuenciaCap END AS FrecuenciaCap , ');

			SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' CASE Cre.FrecuenciaInt WHEN "',PagoSemanal,'" THEN "SEMANAL"');
			SET Var_Sentencia :=  CONCAT(Var_Sentencia, '  WHEN "',PagoCatorcenal,'"	THEN "CATORCENAL"');
			SET Var_Sentencia :=  CONCAT(Var_Sentencia, '  WHEN "',PagoQuincenal,'"	THEN "QUINCENAL"');
			SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' 	WHEN "',PagoMensual,'"	THEN "MENSUAL"');
			SET Var_Sentencia :=  CONCAT(Var_Sentencia, '	WHEN "',PagoPeriodo,'"	THEN "PERIODO"	');
			SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' 	WHEN "',PagoBimestral,'"	THEN "BIMESTRAL"');
			SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' 	WHEN "',PagoTrimestral,'"	THEN "TRIMESTRAL"');
			SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' 	WHEN "',PagoTetrames,'"	THEN "TETRAMES"');
			SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' 	WHEN "',PagoSemestral,'"	THEN "SEMESTRAL"');
			SET Var_Sentencia :=  CONCAT(Var_Sentencia, '	WHEN "',PagoAnual,'"	THEN "ANUAL"');
			SET Var_Sentencia :=  CONCAT(Var_Sentencia, 'ELSE Cre.FrecuenciaInt END AS FrecuenciaInt,');
			SET Var_Sentencia :=  CONCAT(Var_Sentencia, '  IFNULL(Sal.CapVigenteExi,0.00)AS CapVigenteExi,');
			SET Var_Sentencia :=  CONCAT(Var_Sentencia, '  FUNCIONDEUCRENOIVA(Cre.CreditoID) AS MontoTotalExi,');
			SET Var_Sentencia := 	CONCAT(Var_Sentencia, 'Cre.TasaFija, Prom.PromotorID, Prom.NombrePromotor,');
			SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' Par.FechaSistema AS FechaEmision, TIME(NOW()) AS HoraEmision,  ');
			SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' Sal.SaldoMoraVencido AS MoraVencido, Sal.SaldoMoraCarVen AS MoraCarVen, Cre.CalcInteresID, Cre.MontoSeguroCuota, Cre.IVASeguroCuota,"',Cadena_Vacia,'",Des.DestinoCreID,Des.Descripcion');
			SET Var_Sentencia := CONCAT(Var_Sentencia,' ,Cli.TipoPersona, Sal.EstatusCredito ');
			SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' FROM SALDOSCREDITOS Sal ');
			SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' INNER JOIN CREDITOS Cre ON   Sal.CreditoID = Cre.CreditoID');
			SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' INNER JOIN CUENTASAHO Cue ON Cue.CuentaAhoID = Cre.CuentaID');
			SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' INNER JOIN PRODUCTOSCREDITO Prod ON Cre.ProductoCreditoID = Prod.ProducCreditoID');
			SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' INNER JOIN  PARAMETROSSIS Par ON Par.EmpresaID=Par.EmpresaID ');


			SET Par_Moneda := IFNULL(Par_Moneda,Entero_Cero);
			IF(Par_Moneda!=0)THEN
				SET Var_Sentencia = CONCAT(Var_sentencia,' AND Cre.MonedaID=',CONVERT(Par_Moneda,CHAR));
			END IF;

			SET Par_Sucursal := IFNULL(Par_Sucursal,Entero_Cero);
			IF(Par_Sucursal!=0)THEN
				SET Var_Sentencia = CONCAT(Var_sentencia,' AND Cre.SucursalID=',CONVERT(Par_Sucursal,CHAR));
			END IF;

			SET Var_Sentencia :=  CONCAT(Var_Sentencia,' INNER JOIN DESTINOSCREDITO Des ON Des.DestinoCreID = Cre.DestinoCreID');
			SET Par_Clasificacion := IFNULL(Par_Clasificacion,Entero_Cero);
			IF(Par_Clasificacion!=Entero_Cero)THEN
				SET Var_Sentencia := CONCAT(Var_sentencia,' AND Des.SubClasifID=',CONVERT(Par_Clasificacion,CHAR));
			END IF;

			SET Var_Sentencia := 	CONCAT(Var_Sentencia,' INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID');
			SET Var_Sentencia :=  CONCAT(Var_Sentencia,' INNER JOIN PROMOTORES Prom ON Cli.PromotorActual = Prom.PromotorID');

			SET Par_Genero := IFNULL(Par_Genero,Cadena_Vacia);
			IF(Par_Genero!=Cadena_Vacia)THEN
				SET Var_Sentencia := CONCAT(Var_sentencia,' AND Cli.Sexo="',Par_Genero,'"');
				SET Var_Sentencia := CONCAT(Var_sentencia,' AND Cli.TipoPersona="',Var_PerFisica,'"');
			END IF;

			SET Par_Estado := IFNULL(Par_Estado,Entero_Cero);
			IF(Par_Estado!=0)THEN
				SET Var_Sentencia := CONCAT(Var_sentencia,' AND (SELECT Dir.EstadoID FROM DIRECCLIENTE Dir WHERE Dir.Oficial="S" AND Cre.ClienteID=Dir.ClienteID)=',CONVERT(Par_Estado,CHAR));
			END IF;

			SET Par_Municipio := IFNULL(Par_Municipio,Entero_Cero);
			IF(Par_Municipio!=0)THEN
				SET Var_Sentencia := CONCAT(Var_sentencia,' AND (SELECT Dir.MunicipioID FROM DIRECCLIENTE Dir WHERE Dir.Oficial="S" AND Cre.ClienteID=Dir.ClienteID)=',CONVERT(Par_Municipio,CHAR));
			END IF;

			SET Par_ProductoCre := IFNULL(Par_ProductoCre,Entero_Cero);
			IF(Par_ProductoCre!=0)THEN
				SET Var_Sentencia := 	CONCAT(Var_Sentencia,' INNER JOIN PRODUCTOSCREDITO Pro ON Sal.ProductoCreditoID = Pro.ProducCreditoID');
				SET Var_Sentencia :=  CONCAT(Var_sentencia,' AND Sal.ProductoCreditoID =',CONVERT(Par_ProductoCre,CHAR));
			END IF;

			SET Par_Promotor := IFNULL(Par_Promotor,Entero_Cero);
			IF(Par_Promotor!=0)THEN
				SET Var_Sentencia := 	CONCAT(Var_Sentencia,' INNER JOIN PROMOTORES PROM ');
				SET Var_Sentencia := CONCAT(Var_sentencia,'  ON PROM.PromotorID=Cli.PromotorActual AND PROM.PromotorID=',CONVERT(Par_Promotor,CHAR));
			END IF;

			SET Var_Sentencia 	:= CONCAT(Var_Sentencia,'	 AND	Sal.FechaCorte = \'',Par_Fecha,'\'');
			SET Var_Sentencia 	:= CONCAT(Var_Sentencia,' AND Cre.EsAgropecuario="S"  ORDER BY Sal.CreditoID ASC ; ');
			SET @Sentencia		:= (Var_Sentencia);
			PREPARE STSALDOSTOTALESREP FROM @Sentencia;
			EXECUTE  STSALDOSTOTALESREP;
			DEALLOCATE PREPARE STSALDOSTOTALESREP;
		END IF;

		IF(Par_Fecha = FechaSist) THEN
			SET Var_Sentencia :=	CONCAT(Var_Sentencia,'SELECT CONVERT("',Aud_NumTransaccion,'",UNSIGNED INT),Cre.CreditoID,Cre.ProductoCreditoID, Pro.Descripcion, Cli.ClienteID, Cli.NombreCompleto,	Cre.SaldoCapVigent,	Cre.SaldoCapAtrasad,	Cre.SaldoCapVencido, ');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia,' Cre.SaldCapVenNoExi,	ROUND(Cre.SaldoInterProvi,2),	ROUND(Cre.SaldoInterAtras,2), 	ROUND(Cre.SaldoInterVenc,2),	ROUND(Cre.SaldoIntNoConta,2), ');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia,' (Cre.SaldoMoratorios),	Cre.SaldComFaltPago,	(Cre.SaldoComServGar + Cre.SaldoOtrasComis) AS SaldoOtrasComis,	Cre.SaldoIVAInteres,	Cre.SaldoIVAMorator, ');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia,' Cre.SalIVAComFalPag,	Cre.SaldoIVAComisi,	0 AS PasoCapAtraDia,	0 AS PasoCapVenDia, ');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia,' 0 AS PasoCapVNEDia ,	0 AS PasoIntAtraDia,	0 AS PasoIntVenDia,	0 AS CapRegularizado, ');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia,' 0 AS IntOrdDevengado, 0 AS IntMorDevengado,	0 AS ComisiDevengado,	0 AS PagoCapVigDia, ');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia,' 0 AS PagoCapAtrDia, 	0 AS PagoCapVenDia,	0 AS PagoCapVenNexDia, 0 AS PagoIntOrdDia, ');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia,' 0 AS PagoIntAtrDia, 	0 AS PagoIntVenDia,	0 AS PagoIntCalNoCon, 0 AS PagoComisiDia, ');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia,' 0 AS PagoMoratorios, 	0 AS PagoIvaDia,		0 AS IntCondonadoDia, 0 AS MorCondonadoDia, 0 AS IntDevCtaOrden, 0 AS CapCondonadoDia,  0 AS ComAdmonPagDia, ');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia,' 0 AS ComCondonadoDia, 0 AS DesembolsosDia, Cre.FechaInicio, Cre.FechaVencimien AS FechaVencimiento, ');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia,' (SELECT MAX(FechaAplicacion) FROM CREDITOSMOVS WHERE CreditoID=Cre.CreditoID AND NatMovimiento="',Var_NatMovimiento,'")AS FechaUltAbonoCre,');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia,' Cre.MontoCredito, FUNCIONDIASATRASO(Cre.CreditoID,"',Par_Fecha,'")AS DiasAtraso, Cue.SaldoDispon,Cue.SaldoBloq ,');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia,' CONVERT((SELECT  CASE WHEN (SELECT IFNULL(MAX(Fecha),"',Fecha_Vacia,'") FROM CUENTASAHOMOV WHERE CuentaAhoID= Cre.CuentaID AND NatMovimiento="',Var_NatMovimiento,'") > ');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia,' (SELECT IFNULL(MAX(Fecha),"',Fecha_Vacia,'")  FROM  `HIS-CUENAHOMOV` WHERE CuentaAhoID= Cre.CuentaID AND NatMovimiento="',Var_NatMovimiento,'")');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia,' THEN ');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia,' (SELECT IFNULL(MAX(Fecha),"',Fecha_Vacia,'") FROM CUENTASAHOMOV WHERE CuentaAhoID= Cre.CuentaID AND NatMovimiento="',Var_NatMovimiento,'") ');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia,' ELSE ');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia,' (SELECT IFNULL(MAX(Fecha),"',Fecha_Vacia,'")  FROM `HIS-CUENAHOMOV` WHERE CuentaAhoID= Cre.CuentaID AND NatMovimiento="',Var_NatMovimiento,'") END),CHAR) AS FechaUltDepCta,');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia, 'CASE Cre.FrecuenciaCap WHEN "',PagoSemanal,'" THEN "SEMANAL"');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia, 'WHEN "',PagoCatorcenal,'"	THEN "CATORCENAL"');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia, '	WHEN "',PagoQuincenal,'"	THEN "QUINCENAL"');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia, ' 	WHEN "',PagoMensual,'"	THEN "MENSUAL"	');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia, ' 	WHEN "',PagoPeriodo,'"	THEN "PERIODO"	');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia, ' 	WHEN "',PagoBimestral,'"	THEN "BIMESTRAL"');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia, '	WHEN "',PagoTrimestral,'"	THEN "TRIMESTRAL"');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia, ' 	WHEN "',PagoTetrames,'"	THEN "TETRAMES"');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia, '	WHEN "',PagoSemestral,'"	THEN "SEMESTRAL"');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia, ' 	WHEN "',PagoAnual,'"	THEN "ANUAL"');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia, '	WHEN "',PagoUnico,'"	THEN "UNICO"');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia, '  ELSE Cre.FrecuenciaCap END AS FrecuenciaCap, ');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia, 'CASE Cre.FrecuenciaInt WHEN "',PagoSemanal,'" THEN "SEMANAL"');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia, ' WHEN "',PagoCatorcenal,'"	THEN "CATORCENAL"');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia, ' WHEN "',PagoQuincenal,'"	THEN "QUINCENAL"');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia, ' WHEN "',PagoMensual,'"	THEN "MENSUAL"	');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia, '	WHEN "',PagoPeriodo,'"	THEN "PERIODO"	');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia, '	WHEN "',PagoBimestral,'"	THEN "BIMESTRAL"');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia, '	WHEN "',PagoTrimestral,'"	THEN "TRIMESTRAL"');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia, '	WHEN "',PagoTetrames,'"	THEN "TETRAMES"');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia, '	WHEN "',PagoSemestral,'"	THEN "SEMESTRAL"');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia, '	WHEN "',PagoAnual,'"	THEN "ANUAL"');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia, ' 	WHEN "',PagoUnico,'"	THEN "UNICO"');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia, ' ELSE Cre.FrecuenciaInt END AS FrecuenciaInt, ');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia,'(SELECT  IFNULL(SUM(SaldoCapVigente), 0) FROM AMORTICREDITO Amo');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia,'   WHERE Amo.CreditoID = Cre.CreditoID AND Amo.Estatus != "P" AND Amo.FechaExigible <= "',FechaSist,'") AS CapVigenteExi,');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia,' FUNCIONDEUCRENOIVA(Cre.CreditoID) AS MontoTotalExi,');

			SET Var_Sentencia :=	CONCAT(Var_Sentencia,'Cre.TasaFija, Prom.PromotorID, Prom.NombrePromotor,');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia, ' Par.FechaSistema AS FechaEmision, TIME(NOW()) AS HoraEmision, ');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia, ' Cre.SaldoMoraVencido, Cre.SaldoMoraCarVen , Cre.CalcInteresID, Cre.MontoSeguroCuota, Cre.IVASeguroCuota,"',Cadena_Vacia,'",Des.DestinoCreID,Des.Descripcion');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia,' ,Cli.TipoPersona,Cre.Estatus ');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia,' FROM CREDITOS Cre ');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia,' INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia,' INNER JOIN CUENTASAHO Cue ON Cue.CuentaAhoID = Cre.CuentaID');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia,' INNER JOIN PROMOTORES Prom ON Cli.PromotorActual = Prom.PromotorID');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia,' INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID');
			SET Var_Sentencia :=	CONCAT(Var_Sentencia, ' INNER JOIN  PARAMETROSSIS Par ON Par.EmpresaID=Par.EmpresaID ');


			SET Par_Genero := IFNULL(Par_Genero,Cadena_Vacia);
			IF(Par_Genero!=Cadena_Vacia)THEN
				SET Var_Sentencia :=  CONCAT(Var_sentencia,' AND Cli.Sexo="',Par_Genero,'"');
                SET Var_Sentencia := CONCAT(Var_sentencia,' AND Cli.TipoPersona="',Var_PerFisica,'"');
			END IF;

			SET Var_Sentencia :=  CONCAT(Var_Sentencia,' INNER JOIN DESTINOSCREDITO Des ON Des.DestinoCreID = Cre.DestinoCreID');
			SET Par_Clasificacion := IFNULL(Par_Clasificacion,Entero_Cero);
			IF(Par_Clasificacion!=Entero_Cero)THEN
				SET Var_Sentencia := CONCAT(Var_sentencia,' AND Des.SubClasifID=',CONVERT(Par_Clasificacion,CHAR));
			END IF;

			SET Par_Estado := IFNULL(Par_Estado,Entero_Cero);
			IF(Par_Estado!=0)THEN
				SET Var_Sentencia := CONCAT(Var_sentencia,' AND (SELECT Dir.EstadoID FROM DIRECCLIENTE Dir WHERE Dir.Oficial="S" AND Cre.ClienteID=Dir.ClienteID)=',CONVERT(Par_Estado,CHAR));
			END IF;

			SET Par_Municipio := IFNULL(Par_Municipio,Entero_Cero);
			IF(Par_Municipio!=0)THEN
				SET Var_Sentencia := CONCAT(Var_sentencia,' AND (SELECT Dir.MunicipioID FROM DIRECCLIENTE Dir WHERE Dir.Oficial="S" AND Cre.ClienteID=Dir.ClienteID)=',CONVERT(Par_Municipio,CHAR));
			END IF;

			SET Par_ProductoCre := IFNULL(Par_ProductoCre,Entero_Cero);
			IF(Par_ProductoCre!=0)THEN
				SET Var_Sentencia :=  CONCAT(Var_sentencia,' AND Cre.ProductoCreditoID =',CONVERT(Par_ProductoCre,CHAR));
			END IF;

			SET Par_Promotor := IFNULL(Par_Promotor,Entero_Cero);
			IF(Par_Promotor!=0)THEN
				SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN PROMOTORES PROM ');
				SET Var_Sentencia := CONCAT(Var_sentencia,'  ON PROM.PromotorID=Cli.PromotorActual AND PROM.PromotorID=',CONVERT(Par_Promotor,CHAR));
			END IF;

			SET Par_Moneda := IFNULL(Par_Moneda,Entero_Cero);
			IF(Par_Moneda!=0)THEN
				SET Var_Sentencia = CONCAT(Var_sentencia,' AND Cre.MonedaID=',CONVERT(Par_Moneda,CHAR));
			END IF;

			SET Par_Sucursal := IFNULL(Par_Sucursal,Entero_Cero);
			IF(Par_Sucursal!=0)THEN
			SET Var_Sentencia = CONCAT(Var_sentencia,' AND Cre.SucursalID=',CONVERT(Par_Sucursal,CHAR));
			END IF;

			SET Var_Sentencia := CONCAT(Var_Sentencia,' AND	(Cre.Estatus	= "',EstatusVigente,'" OR Cre.Estatus = "',EstatusVencido,'") ');
			SET Var_Sentencia := 	CONCAT(Var_Sentencia,' AND Cre.EsAgropecuario="S"  ORDER BY Cre.CreditoID; ');

			SET @Sentencia	= (Var_Sentencia);
			PREPARE STSALDOSTOTALESREP FROM @Sentencia;
			EXECUTE  STSALDOSTOTALESREP;
		END IF;
	END IF;

	SET Var_ExisteCobraSeguro := (SELECT COUNT(CR.CreditoID)
									FROM tmp_TMPSALDOSTOTALESAGROREP AS CR INNER JOIN
									CREDITOS AS C	 ON CR.CreditoID = C.CreditoID
									WHERE CR.Transaccion = Aud_NumTransaccion
									AND C.CobraSeguroCuota = 'S'
									AND CR.DiasAtraso >= Par_AtrasoInicial
									AND CR.DiasAtraso <=Par_AtrasoFinal);

	SET Var_ExisteCobraSeguro := IFNULL(Var_ExisteCobraSeguro,0); -- No existen creditos que cobran seguros

	UPDATE tmp_TMPSALDOSTOTALESAGROREP T
		LEFT JOIN CREDITOS C ON T.CreditoID = C.CreditoID
		LEFT JOIN LINEAFONDEADOR L ON C.LineaFondeo = L.LineaFondeoID
		LEFT JOIN INSTITUTFONDEO I ON C.InstitFondeoID = I.InstitutFondID SET
			T.FolioFondeo = CASE
								WHEN C.LineaFondeo > Entero_Cero THEN L.FolioFondeo
								WHEN C.LineaFondeo = Entero_Cero THEN 'NA'
								END,
			T.FuenteFondeo	= IF(C.TipoFondeo = 'P','REC. PROPIOS',I.NombreInstitFon),
			T.AcreditadoIDFIRA = C.AcreditadoIDFIRA,
			T.CreditoIDFIRA = C.CreditoIDFIRA,
			T.GrupoID = C.GrupoID
		WHERE Transaccion = Aud_NumTransaccion
		AND T.CreditoID = C.CreditoID;

	UPDATE tmp_TMPSALDOSTOTALESAGROREP T
		INNER JOIN GRUPOSCREDITO AS GRU ON T.GrupoID = GRU.GrupoID SET
		T.NombreGrupo = GRU.NombreGrupo
		WHERE T.GrupoID > 0;

	UPDATE SOLICITUDCREDITO AS SOL INNER JOIN CREDITOS AS CRED ON SOL.SolicitudCreditoID = CRED.SolicitudCreditoID SET
		SOL.CreditoID = CRED.CreditoID
		WHERE SOL.CreditoID IS NULL;

	UPDATE tmp_TMPSALDOSTOTALESAGROREP AS T INNER JOIN CREDITOS AS CRED ON T.CreditoID = CRED.CreditoID
		INNER JOIN SUCURSALES AS SUC ON CRED.Sucursal =SUC.SucursalID
		SET
		T.SucursalID = CRED.Sucursal,/*Sucursal de todos los creditos*/
        T.NombreSucursal = SUC.NombreSucurs
		WHERE T.CreditoID =CRED.CreditoID;

	UPDATE tmp_TMPSALDOSTOTALESAGROREP T
		INNER JOIN CREDITOS AS SOL ON T.CreditoID = SOL.CreditoID
		LEFT JOIN CATCADENAPRODUCTIVA AS CAD ON SOL.CadenaProductivaID = CAD.CveCadena
		LEFT JOIN CATRAMAFIRA AS R ON SOL.RamaFIRAID = R.CveRamaFIRA
		LEFT JOIN CATACTIVIDADFIRA AS ACT ON SOL.ActividadFIRAID = ACT.CveActividadFIRA
		LEFT JOIN CATFIRAPROGESP AS PRO ON SOL.ProgEspecialFIRAID = PRO.CveSubProgramaID
		LEFT JOIN CATTIPOGARANTIAFIRA AS GAR ON SOL.TipoGarantiaFIRAID = GAR.TipoGarantiaID
		 SET
		T.CveRamaFIRA 			= SOL.RamaFIRAID,
		T.DescripcionRamaFIRA 	= R.DescripcionRamaFIRA,
		T.ActividadFIRAID 		= SOL.ActividadFIRAID,
		T.ActividadDes 			= ACT.DesActividadFIRA,
		T.CveCadena 			= SOL.CadenaProductivaID,
		T.NomCadenaProdSCIAN 	= CAD.NomCadenaProdSCIAN,
		T.ProgEspecialFIRAID 	= SOL.ProgEspecialFIRAID,
		T.SubPrograma			= PRO.CveSubProgramaID,
		T.GarantiaDes			= IFNULL(GAR.Descripcion,'NINGUNA')
		WHERE T.CreditoID 		= SOL.CreditoID;

	-- Validacion para los creditos que no tiene un pasivo
	UPDATE tmp_TMPSALDOSTOTALESAGROREP T
		INNER JOIN CREDITOS AS CRED ON T.CreditoID = CRED.CreditoID
		LEFT JOIN DESTINOSCREDITO AS DES ON CRED.DestinoCreID = DES.DestinoCreID
		LEFT JOIN CLASIFICCREDITO AS CLAS ON DES.SubClasifID = CLAS.ClasificacionID SET
		T.FechaMinistrado = CRED.FechaMinistrado,
		T.DesDestino = DES.Descripcion,
        T.CreditoFondeoID = 0,
		T.ClaseCredito	  = IF(CLAS.ClasificacionID = 125,"AVIO",
								IF(CLAS.ClasificacionID = 126,
									"REFACCIONARIO",CLAS.DescripClasifica)),
		T.FechaProxVenc = FNFECHAPROXCRE(T.CreditoID,Par_Fecha),
		T.MontoProxVenc = FNEXIGIBLEPROXPAGAGRO(T.CreditoID),
		T.PorcComision = (IFNULL(CRED.MontoComApert,0)/CRED.MontoCredito)*100,
		T.SucursalID = CRED.SucursalID
	WHERE T.CreditoID = CRED.CreditoID;

	UPDATE tmp_TMPSALDOSTOTALESAGROREP T
		INNER JOIN CREDITOS AS CRED ON T.CreditoID = CRED.CreditoID
		LEFT JOIN DESTINOSCREDITO AS DES ON CRED.DestinoCreID = DES.DestinoCreID
		LEFT JOIN CLASIFICCREDITO AS CLAS ON DES.SubClasifID = CLAS.ClasificacionID
		LEFT JOIN RELCREDPASIVOAGRO AS PAS ON CRED.CreditoID = PAS.CreditoID SET
		T.FechaMinistrado = CRED.FechaMinistrado,
		T.CreditoFondeoID = IFNULL(PAS.CreditoFondeoID,0),
		T.DesDestino = DES.Descripcion,
		T.ClaseCredito	  = IF(CLAS.ClasificacionID = 125,"AVIO",
								IF(CLAS.ClasificacionID = 126,
									"REFACCIONARIO",CLAS.DescripClasifica)),
		T.FechaProxVenc = FNFECHAPROXCRE(T.CreditoID,Par_Fecha),
		T.MontoProxVenc = FNEXIGIBLEPROXPAGAGRO(T.CreditoID),
		T.PorcComision = (IFNULL(CRED.MontoComApert,0)/CRED.MontoCredito)*100,
		T.SucursalID = CRED.SucursalID
	WHERE T.CreditoID = CRED.CreditoID AND PAS.EstatusRelacion = 'V';

	UPDATE tmp_TMPSALDOSTOTALESAGROREP T
		INNER JOIN CREDITOFONDEO AS CRED ON T.CreditoFondeoID = CRED.CreditoFondeoID SET
		T.SaldoCapVigentePas = CRED.SaldoCapVigente,
		T.SaldoCapAtrasadPas = CRED.SaldoCapAtrasad,
		T.SaldoInteresProPas = CRED.SaldoInteresPro,
		T.SaldoInteresAtraPas = CRED.SaldoInteresAtra
	WHERE T.CreditoFondeoID = CRED.CreditoFondeoID;

	UPDATE tmp_TMPSALDOSTOTALESAGROREP T
		INNER JOIN SUCURSALES AS SUC ON T.SucursalID = SUC.SucursalID SET
		T.NombreSucursal = SUC.NombreSucurs
		WHERE T.SucursalID = SUC.SucursalID;

	SELECT
		CR.CreditoID,			CR.ProductoCreditoID,	CR.Descripcion,			LPAD(CR.ClienteID,10,0) AS ClienteID,			CR.NombreCompleto,
		CR.SaldoCapVigent,		CR.SaldoCapAtrasad,		CR.SaldoCapVencido,		CR.SaldCapVenNoExi,								CR.SaldoInterProvi,
		CR.SaldoInterAtras,		CR.SaldoInterVenc,		CR.SaldoIntNoConta,		CR.SaldoMoratorios,								CR.SaldComFaltPago,
		CR.SaldoOtrasComis,		CR.SaldoIVAInteres,		CR.SaldoIVAMorator,  	CR.SalIVAComFalPag,								CR.SaldoIVAComisi,
		CR.PasoCapAtraDia,		CR.PasoCapVenDia,  		CR.PasoCapVNEDia ,		CR.PasoIntAtraDia,								CR.PasoIntVenDia,
		CR.CapRegularizado,  	CR.IntOrdDevengado,		CR.IntMorDevengado,		CR.ComisiDevengado,								CR.PagoCapVigDia,
		CR.PagoCapAtrDia, 		CR.PagoCapVenDia,		CR.PagoCapVenNexDia,	CR.PagoIntOrdDia,  								CR.PagoIntAtrDia,
		CR.PagoIntVenDia,		CR.PagoIntCalNoCon,		CR.PagoComisiDia,  		CR.PagoMoratorios, 								CR.PagoIvaDia,
		CR.IntCondonadoDia,		CR.MorCondonadoDia, 	CR.IntDevCtaOrden, 		CR.CapCondonadoDia,  							CR.ComAdmonPagDia,
		CR.ComCondonadoDia, 	CR.DesembolsosDia, 		CR.FechaInicio, 		CR.FechaVencimiento,							CR.FechaUltAbonoCre,
		CR.MontoCredito, 		CR.DiasAtraso, 			CR.SaldoDispon,			CR.SaldoBloq , 									CR.FechaUltDepCta,
		CR.FrecuenciaCap,		CR.FrecuenciaInt,		CR.CapVigenteExi,		CR.MontoTotalExi,								CR.TasaFija,
		CR.PromotorID, 			CR.NombrePromotor,		CR.FechaEmision,		CR.HoraEmision,									CR.MoraVencido,
		CR.MoraCarVen,			F.Formula, 				CR.MontoSeguroCuota, 	CR.IVASeguroCuota,								CR.FolioFondeo,
		IF(Var_ExisteCobraSeguro>0,'S','N') AS ExisteCredCobraSeguro,
		CR.DestinoCredID,
		UPPER(CR.DesDestino) AS DesDestino,
		CR.FuenteFondeo,
		IFNULL(CR.CreditoFondeoID,0) AS CreditoFondeoID,
		CR.AcreditadoIDFIRA,
		CR.CreditoIDFIRA,
		CR.GarantiaDes AS TipoGarantia,
		CR.ClaseCredito,
		CR.CveRamaFIRA,
		CR.DescripcionRamaFIRA,
		CR.FechaMinistrado AS FechaOtorgamiento,
		CR.FechaProxVenc,
		CR.MontoProxVenc,
		CR.ActividadFIRAID,
		CR.ActividadDes,
		CR.CveCadena,
		CR.NomCadenaProdSCIAN,
		IF(CR.Estatus = "V","VIGENTE",
			IF(CR.Estatus = "I","INACTIVO",
				IF(CR.Estatus = "K","CASTIGADO",
					IF(CR.Estatus = "P","PAGADO",
						IF(CR.Estatus = "B","VENCIDO",
							IF(CR.Estatus = "C","CANCELADO","")))))) AS Estatus,
		CR.ProgEspecialFIRAID,
		CR.SubPrograma,
		IF(CR.TipoPersona ="F","FISICA",IF(CR.TipoPersona = "M","MORAL","FISICA CON ACT. EMPRESARIAL")) AS TipoPersona,
		CR.PorcComision,
		CR.ConceptoInv,
		CR.NumeroUnidades,
		CR.UnidadesMedida,
		CR.GrupoID,
		CR.NombreGrupo,

		CR.SaldoCapVigentePas,
		CR.SaldoCapAtrasadPas,
		CR.SaldoInteresProPas,
		CR.SaldoInteresAtraPas,
		CR.NombreSucursal

		FROM tmp_TMPSALDOSTOTALESAGROREP AS CR LEFT JOIN
		FORMTIPOCALINT AS F ON CR.CalcInteresID=F.FormInteresID
		WHERE Transaccion = Aud_NumTransaccion
		AND DiasAtraso >= Par_AtrasoInicial
		AND DiasAtraso <=Par_AtrasoFinal;
		DROP TABLE IF EXISTS tmp_TMPSALDOSTOTALESAGROREP;


END TerminaStore$$