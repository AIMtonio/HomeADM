-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTRATOAVIOFIRAREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTRATOAVIOFIRAREP`;DELIMITER $$

CREATE PROCEDURE `CONTRATOAVIOFIRAREP`(
	/*CONTRATOS DE ADHESIÓN CREDITOS PARA PERS FISICAS Y MORALES [FIRA] */
	Par_CreditoID				BIGINT(12),			# Número del Crédito
	Par_TipoReporte				TINYINT,			# Tipo de reporte
	/* Parametros de Auditoria */
	Aud_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,

	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore: BEGIN
	# Declaracion de Variables
	DECLARE Var_FechaSis			DATE;
	DECLARE Var_ClienteInstitucion	INT(11);
	DECLARE Var_ClienteID			INT(11);
	DECLARE Var_NombreRepresentante	VARCHAR(100);
	DECLARE Var_NombreInstitucion	VARCHAR(100);
	DECLARE Var_Direccion			VARCHAR(300);
	DECLARE Var_NombreCliente		VARCHAR(200);
	DECLARE Var_NombreCompleto		VARCHAR(200);
	DECLARE Var_RFC					VARCHAR(20);
	DECLARE Var_NombreRepLegal		VARCHAR(200);
	DECLARE Var_DirRepLegal			VARCHAR(300);
	DECLARE Var_ClientesGarID		VARCHAR(200);
	DECLARE Var_ValorCAT			DECIMAL(16,4);
	DECLARE Var_MontoCredito		DECIMAL(14,2);
	DECLARE Var_FechaAutoriza		DATE;
	DECLARE Var_PlazoID				VARCHAR(20);
	DECLARE Var_TasaFija			DECIMAL(14,4);
	DECLARE Var_TasaBase			DECIMAL(14,4);
	DECLARE Var_FactorMora			DECIMAL(12,2);
	DECLARE Var_ProductoCreditoID	INT(11);
	DECLARE Var_TasaBaseID			INT(11);
	DECLARE Var_DestinoCreID		INT(11);
	DECLARE Var_SubClasifID			INT(11);
	DECLARE Var_TipoSociedadID		INT(11);
	DECLARE Var_NomTipoSociedad		VARCHAR(100);
	DECLARE Var_MontoSeguroVida		DECIMAL(14,2);
	DECLARE Var_SeguroVidaPagado	DECIMAL(14,2);
	DECLARE Var_MontoComApert		DECIMAL(14,2);
	DECLARE Var_Descripcion			VARCHAR(100);
	DECLARE Var_RegistroRECA		VARCHAR(100);
	DECLARE Var_PlazoMeses			INT(11);
	DECLARE Var_PlazoDescripcion	VARCHAR(50);
	DECLARE Var_PorcentajeFEGA		DECIMAL(18,2);
	DECLARE Var_TipoPersona			CHAR(1);
	DECLARE Var_PermiteLiqAntici	CHAR(1);
	DECLARE Var_CobraComLiqAntici	CHAR(1);
	DECLARE Var_TipComLiqAntici		CHAR(1);
	DECLARE Var_ComisionLiqAntici	DECIMAL(16,4);
	DECLARE Var_ComisionAdmon		VARCHAR(100);
	DECLARE Var_SaldoInsoluto		DECIMAL(16,4);
	DECLARE Var_CalcInteresID		INT(11);
	DECLARE Var_GarantiaID			INT(11);
	DECLARE Var_GarantiasID			VARCHAR(50);
	DECLARE Var_NombreGarante		TEXT;
	DECLARE Var_NombreAval			TEXT;
	DECLARE Var_SolicitudCreditoID	BIGINT(11);
	DECLARE Var_CuentaAhoID			BIGINT(12);
	DECLARE Var_EscrituraPublic		VARCHAR(50);
	DECLARE Var_NoEscritura			BIGINT;
	DECLARE Var_NoEscrituraD		DECIMAL;
	DECLARE Var_FechaEsc			DATE;
	DECLARE Var_Notaria				INT(11);
	DECLARE Var_EstadoIDEsc			INT(11);
	DECLARE Var_LocalidadEsc		INT(11);
	DECLARE Var_NomNotario			VARCHAR(100);
	DECLARE Var_NomApoderado		VARCHAR(150);
	DECLARE Var_FolioRegPub			VARCHAR(10);
	DECLARE Var_NomMunicipio		VARCHAR(150);
	DECLARE Var_NomEstado			VARCHAR(150);
	DECLARE Var_EscrituraPublicCte	VARCHAR(50);
	DECLARE Var_NoEscrituraCte		BIGINT;
	DECLARE Var_NoEscrituraDCte		DECIMAL;
	DECLARE Var_FechaEscCte			DATE;
	DECLARE Var_NotariaCte			INT(11);
	DECLARE Var_EstadoIDEscCte		INT(11);
	DECLARE Var_LocalidadEscCte		INT(11);
	DECLARE Var_NomNotarioCte		VARCHAR(100);
	DECLARE Var_NomApoderadoCte		VARCHAR(150);
	DECLARE Var_FolioRegPubCte		VARCHAR(10);
	DECLARE Var_NomMunicipioCte		VARCHAR(150);
	DECLARE Var_NomEstadoCte		VARCHAR(150);
	DECLARE Var_EstadoIDRegCte		INT(11);
	DECLARE Var_LocalidadRegPubCte	INT(11);
	DECLARE Var_NomMunRegPubCte		VARCHAR(150);
	DECLARE Var_NomEstadoRegPubCte	VARCHAR(150);
	DECLARE Var_MontoPrestamo		DECIMAL(16,2);
	DECLARE Var_MontoSolicitante	DECIMAL(16,2);
	DECLARE Var_MontoProyecto		DECIMAL(16,2);
	DECLARE Var_MontoComApProd		DECIMAL(16,2);
	DECLARE Var_TipoComXapert		CHAR(1);
	DECLARE Var_ComApertura			DECIMAL(16,2);
	DECLARE Var_EstadoCivil			VARCHAR(2);
	DECLARE Var_NomGarantesP		VARCHAR(1200);
	DECLARE Var_NomGarantesH		VARCHAR(1200);
	DECLARE Var_NomGarantesG		VARCHAR(1200);
	DECLARE Var_ObservGarantiaP		VARCHAR(1200);
	DECLARE Var_ObservGarantiaH		VARCHAR(1200);
	DECLARE Var_ObservGarantiaG		VARCHAR(1200);
	DECLARE Var_RequiereGL			CHAR(1);
	DECLARE Var_PorcGarLiq			DECIMAL(16,2);
	DECLARE Var_AportaCliente		DECIMAL(16,2);
	DECLARE Var_CalificaCredito		CHAR(1);
	DECLARE Var_DireccionesGarAva	VARCHAR(1200);
	DECLARE Var_TiposGarantias		TEXT;
	DECLARE Var_TipoSubClasif		VARCHAR(50);
	DECLARE Var_CorreoUnidadEsp		VARCHAR(50);

	# Declaracion de Constantes
	DECLARE Entero_Cero				INT(11);
	DECLARE Decimal_Cero			DECIMAL(12,2);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Fecha_Vacia				DATE;
	DECLARE Cons_No					CHAR(1);
	DECLARE Cons_SI					CHAR(1);
	DECLARE TipoEncabezadoCont		INT(11);
	DECLARE TipoCuadroInform		INT(11);
	DECLARE TipoAmortizaciones		INT(11);
	DECLARE TipoDeclaraciones		INT(11);
	DECLARE TipoClausula1Parte		INT(11);
	DECLARE TipoConceptoInversion	INT(11);
	DECLARE TipoMinistraciones		INT(11);
	DECLARE TipoConInvOtrasF		INT(11);
	DECLARE Tipo5taHoja				INT(11);
	DECLARE TipoAmortizacionesSexta	INT(11);
	DECLARE TipoDecimaPrimera		INT(11);
	DECLARE TipoDecimaPrimera2da	INT(11);
	DECLARE TipoVigesima4ta			INT(11);
	DECLARE TipoTrigesima3era		INT(11);
	DECLARE TipoSeccionGrales		INT(11);
	DECLARE TipoSeccionGralesFirmas	INT(11);
	DECLARE TipoSeccionFirmasGar	INT(11);
	DECLARE TipoSeccionFirmasAval	INT(11);
	DECLARE TipoSeccionFirmasTest	INT(11);
	DECLARE TipoSeccionAnexo1		INT(11);
	DECLARE TipoSeccionAnexoAdUnico	INT(11);
	DECLARE Por_Porcentaje			CHAR(1);
	DECLARE EstatusAutorizado		CHAR(1);
	DECLARE EstatusVig				CHAR(1);
	DECLARE ConcInvRecPrestamo		CHAR(1);
	DECLARE ConcInvRecSolicitante	CHAR(1);
	DECLARE ConcInvRecOtrasF		CHAR(2);
	DECLARE ComXPorcentaje			CHAR(1);
	DECLARE ComXMonto				CHAR(1);
	DECLARE EdoCivilCS				CHAR(2);
	DECLARE EdoCivilCC				CHAR(2);
	DECLARE EdoCivilCM				CHAR(2);
	DECLARE EdoCivilUnion			CHAR(2);
	DECLARE TipoGarantiaPrend		INT(11);
	DECLARE TipoGarantiaHipo		INT(11);
	DECLARE TipoGarantiaGuber		INT(11);
	DECLARE TipoElector				INT(11);
	DECLARE TasaFija				INT(11);
	DECLARE TipoHabilitacionAvio	INT(11);
	DECLARE TipoRefaccionario		INT(11);
	DECLARE PersonaMoral			CHAR(1);

	# Asignacion de Constantes
	SET Entero_Cero				:= 0;			-- Entero Cero
	SET Decimal_Cero			:= 0.0;			-- Decimal cero
	SET Cadena_Vacia			:= '';			-- Cadena Vacia
	SET Fecha_Vacia				:= '1900-01-01';-- Fecha Vacia
	SET Cons_No					:= 'N';			-- Constantes No
	SET Cons_SI					:= 'S';			-- Constantes Si
	SET TipoEncabezadoCont		:= 100;			-- Contrato para pers. física con tasa fija
	SET TipoCuadroInform		:= 01;			-- Contrato para pers. física con tasa fija
	SET TipoAmortizaciones		:= 02;			-- Seccion de amortizaciones.
	SET TipoDeclaraciones		:= 03;			-- Seccion de declaraciones.
	SET TipoClausula1Parte		:= 04;			-- Seccion de 1 clausulas.
	SET TipoConceptoInversion	:= 05;			-- Conceptos de inversión.
	SET TipoMinistraciones		:= 06;			-- Tabla de ministraciones.
	SET TipoConInvOtrasF		:= 07;			-- Seccion de 1 clausulas.
	SET Tipo5taHoja				:= 08;			-- Hoja 5 Quinta.
	SET TipoAmortizacionesSexta	:= 09;			-- Sexta, amortizaciones y plazo.
	SET TipoDecimaPrimera		:= 10;			-- Decima primera: Garantías.
	SET TipoDecimaPrimera2da	:= 11;			-- Decima primera: Garantías. Segunda hoja.
	SET TipoVigesima4ta			:= 12;			-- Vigesima cuarta.
	SET TipoTrigesima3era		:= 13;			-- Trigesima tercera: domicilios.
	SET TipoSeccionGrales		:= 14;			-- Seccion Generales.
	SET TipoSeccionGralesFirmas	:= 15;			-- Seccion Generales Firmas.
	SET TipoSeccionFirmasGar	:= 16;			-- Seccion Generales Firmas. Garantes.
	SET TipoSeccionFirmasAval	:= 17;			-- Seccion Generales Firmas. Avales.
	SET TipoSeccionFirmasTest	:= 18;			-- Seccion Generales Firmas. Testigos.
	SET TipoSeccionAnexo1		:= 19;			-- Seccion ANEXO 1.
	SET TipoSeccionAnexoAdUnico	:= 20;			-- Seccion ANEXO 1. Administrador Unico Moral.
	SET Por_Porcentaje			:= 'S';			-- Porcentaje de Saldo Insoluto.
	SET EstatusAutorizado		:= 'U';			-- Estatus de la garantía o de los avales: autorizado(a).
	SET EstatusVig				:= 'V';			-- Estatus Vigente.
	SET ConcInvRecPrestamo		:= 'P';			-- Concepto de inversión por Recursos del Prestamo.
	SET ConcInvRecSolicitante	:= 'S';			-- Concepto de inversión por Recursos del Solicitante.
	SET ConcInvRecOtrasF		:= 'OF';		-- Concepto de inversión por Recursos Otras Fuentes.
	SET ComXPorcentaje			:= 'P';			-- Comision por Apertura por Porcentaje.
	SET ComXMonto				:= 'M';			-- Comision por Apertura por Monto.
	SET EdoCivilCS				:= 'CS';		-- Estado Civil Casado Bienes Separados
	SET EdoCivilCC				:= 'CC';		-- Estado Civil Casado Bienes Mancomunados con Capitulacion
	SET EdoCivilCM				:= 'CM';		-- Estado Civil Casado Bienes Mancomunados
	SET EdoCivilUnion			:= 'U';			-- Estado Civil Union Libre
	SET TipoGarantiaPrend		:= 2;			-- Tipo de garantía Mobiliaria
	SET TipoGarantiaHipo		:= 3;			-- Tipo de garantía Inmobiliaria
	SET TipoGarantiaGuber		:= 4;			-- Tipo de garantía Gubernamental
	SET TipoElector				:= 1;			-- Tipo de Identificacion Credencial de elector (TIPOSIDENTI)
	SET TasaFija				:= 1;			-- Tipo de Calculo de Interes: Tasa Fija.
	SET TipoHabilitacionAvio	:= 125;			-- Subclasificación de acuerdo a CLASIFICCREDITO
	SET TipoRefaccionario		:= 126;			-- Subclasificación de acuerdo a CLASIFICCREDITO
	SET PersonaMoral			:= 'M';			-- Tipo persona moral
	SET Var_CorreoUnidadEsp		:= 'agarcia@consolnegocios.com';-- Correo electrónco de la unidad especializada

	-- DATOS DE LA INSTITUCION FINANCIERA
	SELECT
		UPPER(Par.NombreRepresentante),	UPPER(Inst.Nombre),		Par.FechaSistema,
		ClienteInstitucion
	INTO
		Var_NombreRepresentante,		Var_NombreInstitucion,	Var_FechaSis,
		Var_ClienteInstitucion
	FROM INSTITUCIONES Inst,PARAMETROSSIS Par
		WHERE Inst.InstitucionID  = Par.InstitucionID;

	-- DATOS DEL CRÉDITO
	SELECT	C.ClienteID,		C.SolicitudCreditoID,	C.MontoCredito,		C.FechaAutoriza,
			C.CalcInteresID,	C.TasaBase,				C.DestinoCreID,		C.CuentaID,
			P.Descripcion,		P.RegistroRECA
	INTO	Var_ClienteID,		Var_SolicitudCreditoID,	Var_MontoCredito,	Var_FechaAutoriza,
			Var_CalcInteresID,	Var_TasaBaseID,			Var_DestinoCreID,	Var_CuentaAhoID,
			Var_Descripcion,	Var_RegistroRECA
	FROM CREDITOS C INNER JOIN PRODUCTOSCREDITO P ON C.ProductoCreditoID=P.ProducCreditoID
		WHERE C.CreditoID = Par_CreditoID;

	-- Se obtiene el valor de la tasa base
	IF(Var_CalcInteresID != TasaFija)THEN
		SET Var_TasaBase := (SELECT Valor FROM TASASBASE WHERE TasaBaseID = Var_TasaBaseID);
	END IF;
	SET Var_TasaBase := IFNULL(Var_TasaBase,Entero_Cero);

	/* Se obtiene la subclasificación del destino para saber
	 * si es de habilitación o avio o Refaccionario. */
	SELECT
		SubClasifID
	INTO
		Var_SubClasifID
		FROM DESTINOSCREDITO
		WHERE DestinoCreID= IFNULL(Var_DestinoCreID, Entero_Cero);

	SET Var_SubClasifID		:= IFNULL(Var_SubClasifID, Entero_Cero);
	SET Var_TipoSubClasif	:= CASE Var_SubClasifID
								WHEN TipoHabilitacionAvio THEN 'HABILITACIÓN O AVÍO'
								WHEN TipoRefaccionario THEN 'REFACCIONARIO'
								ELSE Cadena_Vacia
								END;
	-- DATOS DE CLIENTE
	SELECT
		Cli.NombreCompleto,		Cli.EstadoCivil,	Dir.DireccionCompleta,	Cli.TipoPersona,
		Cli.TipoSociedadID,		Cli.RFCOficial
	INTO
		Var_NombreCliente,		Var_EstadoCivil,	Var_Direccion,			Var_TipoPersona,
		Var_TipoSociedadID,		Var_RFC
		FROM CLIENTES				Cli
		INNER JOIN DIRECCLIENTE		Dir		ON Cli.ClienteID = Dir.ClienteID
			WHERE Cli.ClienteID = Var_ClienteID
			AND Dir.Oficial = Cons_SI;

	-- SE OBTIENEN LOS DATOS DEL REPRESENTANTE LEGAL EN CASO DE QUE SEA PERSONA MORAL
	IF(IFNULL(Var_TipoPersona, Cadena_Vacia) = PersonaMoral)THEN
		SELECT
			C.NombreCompleto,	D.DireccionCompleta
		INTO
			Var_NombreRepLegal,	Var_DirRepLegal
		FROM CUENTASPERSONA C LEFT JOIN DIRECCLIENTE D ON (C.ClienteID=D.ClienteID)
		WHERE C.CuentaAhoID = Var_CuentaAhoID
			AND C.EsApoderado = Cons_SI
			AND C.EstatusRelacion = EstatusVig
			AND C.ClienteID!=Entero_Cero
			AND D.Oficial = Cons_SI;
	END IF;
	SET Var_NombreRepLegal	:= IFNULL(Var_NombreRepLegal, Cadena_Vacia);
	SET Var_DirRepLegal		:= IFNULL(Var_DirRepLegal, Cadena_Vacia);

	-- ENCABEZADO DE TODAS LAS HOJAS DEL CONTRATO.
	IF(IFNULL(Par_TipoReporte,Entero_Cero)=TipoEncabezadoCont)THEN
		DELETE FROM TMPGARANTESAGRO WHERE CreditoID=Par_CreditoID;
		DELETE FROM TMPAVALESAGRO WHERE CreditoID=Par_CreditoID;
		DELETE FROM TMPGENERALESAGRO WHERE CreditoID=Par_CreditoID;

		INSERT INTO TMPGARANTESAGRO (
			GarantiaID,		ClienteID,		ProspectoID,	CreditoID,			NombreCompleto,
			Observaciones,	TipoGarantiaID,
			DireccionCompleta)
		SELECT
			G.GarantiaID,	IFNULL(G.ClienteID, Entero_Cero),	IFNULL(G.ProspectoID, Entero_Cero), Par_CreditoID,
			G.GaranteNombre,
			G.Observaciones,G.TipoGarantiaID,
			FNGENDIRECCION(1, G.EstadoIDGarante, G.MunicipioGarante, G.LocalidadID, G.ColoniaID,
				G.CalleGarante, G.NumExtGarante, G.NumIntGarante, Cadena_Vacia, Cadena_Vacia,
				Cadena_Vacia, G.CodPostalGarante, Cadena_Vacia, Cadena_Vacia, Cadena_Vacia)
		FROM GARANTIAS G INNER JOIN ASIGNAGARANTIAS A ON G.GarantiaID=A.GarantiaID
			WHERE A.SolicitudCreditoID = Var_SolicitudCreditoID
				AND A.Estatus = EstatusAutorizado;

		-- Garantes que son clientes
		UPDATE TMPGARANTESAGRO G INNER JOIN CLIENTES C ON G.ClienteID=C.ClienteID
			INNER JOIN DIRECCLIENTE D ON (G.ClienteID=D.ClienteID)
		SET G.DireccionCompleta = D.DireccionCompleta,
			G.NombreCompleto = C.NombreCompleto,
			G.RFC = C.RFC
			WHERE G.ClienteID != Entero_Cero
				AND G.CreditoID = Par_CreditoID
				AND D.Oficial = Cons_SI;

		-- Garantes que son prospectos que no son clientes
		UPDATE TMPGARANTESAGRO G INNER JOIN PROSPECTOS P ON (G.ProspectoID=P.ProspectoID)
		SET G.DireccionCompleta = FNGENDIRECCION(1, EstadoID, MunicipioID, LocalidadID, ColoniaID,
									Calle, NumExterior, NumInterior, Cadena_Vacia, Cadena_Vacia,
									Cadena_Vacia, CP, Cadena_Vacia, Lote, Manzana),
			G.NombreCompleto = P.NombreCompleto,
			G.RFC = P.RFC
			WHERE G.ClienteID = Entero_Cero
				AND G.CreditoID = Par_CreditoID
				AND G.ProspectoID != Entero_Cero;

		-- AVALES
		INSERT INTO TMPAVALESAGRO (
			AvalID,		ClienteID,		ProspectoID,	DireccionCompleta, CreditoID)
		SELECT
			IFNULL(ASOL.AvalID, Entero_Cero),	IFNULL(ASOL.ClienteID, Entero_Cero),		IFNULL(ASOL.ProspectoID, Entero_Cero), Cadena_Vacia, Par_CreditoID
			FROM AVALESPORSOLICI ASOL
			WHERE ASOL.SolicitudCreditoID = Var_SolicitudCreditoID
				AND ASOL.Estatus = EstatusAutorizado;

		-- Avales que son clientes
		UPDATE TMPAVALESAGRO T INNER JOIN CLIENTES C ON T.ClienteID=C.ClienteID
			INNER JOIN DIRECCLIENTE D ON (T.ClienteID=D.ClienteID)
		SET T.DireccionCompleta = D.DireccionCompleta,
			T.NombreCompleto = C.NombreCompleto,
			T.RFC = C.RFC
			WHERE T.ClienteID != Entero_Cero
				AND T.CreditoID = Par_CreditoID
				AND D.Oficial = Cons_SI;

		-- Avales que no son clientes ni prospectos
		UPDATE TMPAVALESAGRO T INNER JOIN AVALES A ON (T.AvalID=A.AvalID)
		SET T.DireccionCompleta = A.DireccionCompleta,
			T.NombreCompleto = A.NombreCompleto,
			T.RFC = A.RFC
			WHERE T.AvalID != Entero_Cero
				AND T.CreditoID = Par_CreditoID
				AND T.ClienteID = Entero_Cero
				AND T.ProspectoID = Entero_Cero;

		-- Avales que son sólo prospectos
		UPDATE TMPAVALESAGRO T INNER JOIN PROSPECTOS P ON (T.ProspectoID=P.ProspectoID)
		SET T.DireccionCompleta = FNGENDIRECCION(1, EstadoID, MunicipioID, LocalidadID, ColoniaID,
									Calle, NumExterior, NumInterior, Cadena_Vacia, Cadena_Vacia,
									Cadena_Vacia, CP, Cadena_Vacia, Lote, Manzana),
			T.NombreCompleto = P.NombreCompleto,
			T.RFC = P.RFC
			WHERE T.ClienteID = Entero_Cero
				AND T.CreditoID = Par_CreditoID
				AND T.ProspectoID != Entero_Cero
				AND T.AvalID = Entero_Cero;

		-- Se acompleta la información de los garantes que son clientes
		UPDATE TMPGARANTESAGRO T
			INNER JOIN IDENTIFICLIENTE I ON (T.ClienteID=I.ClienteID)
		SET T.IFE = I.NumIdentific
			WHERE T.ClienteID != Entero_Cero
				AND T.CreditoID = Par_CreditoID
				AND I.TipoIdentiID = TipoElector;

		-- Se acompleta la información de los avales que son clientes
		UPDATE TMPAVALESAGRO T
			INNER JOIN IDENTIFICLIENTE I ON (T.ClienteID=I.ClienteID)
		SET T.IFE = I.NumIdentific
			WHERE T.ClienteID != Entero_Cero
				AND T.CreditoID = Par_CreditoID
				AND I.TipoIdentiID = TipoElector;

		IF(IFNULL(Var_TipoPersona, Cadena_Vacia)=PersonaMoral) THEN
			INSERT INTO TMPGENERALESAGRO (
				ConsecutivoID,	NombreCompleto,		RFC,		DireccionCompleta,	IFE,
				CreditoID,		ClienteID)
			VALUES (
				Entero_Cero,	Var_NombreCliente,	Var_RFC,	Var_Direccion,		Cadena_Vacia,
				Par_CreditoID,	Var_ClienteID);
		END IF;

		SET @Var_Consecutivo := Entero_Cero;

		INSERT INTO TMPGENERALESAGRO (
			ConsecutivoID,	ClienteID,	ProspectoID,		RolID,
			NombreCompleto,	RFC,		DireccionCompleta,	IFE,	CreditoID)
		SELECT
			(@Var_Consecutivo := @Var_Consecutivo +1),	ClienteID,	ProspectoID,1,
			NombreCompleto,	RFC,	DireccionCompleta,	IFE,		CreditoID
			FROM TMPGARANTESAGRO WHERE CreditoID=Par_CreditoID;

		INSERT INTO TMPGENERALESAGRO (
			ConsecutivoID,	ClienteID,	ProspectoID,		RolID,
			NombreCompleto,	RFC,		DireccionCompleta,	IFE,	CreditoID)
		SELECT
			(@Var_Consecutivo := @Var_Consecutivo +1),	ClienteID,	ProspectoID,2,
			NombreCompleto,	RFC,	DireccionCompleta,	IFE,		CreditoID
			FROM TMPAVALESAGRO WHERE CreditoID=Par_CreditoID;

		-- DATOS QUE SE OCUPAN SÓLO EN EL ENCABEZADO.
		SELECT
			Var_NombreRepresentante AS ApoderadoLegal,
			Var_NombreInstitucion AS NombreInstitucionFin,
			Var_NombreCliente AS NombreCompletoCliente,
			Var_CorreoUnidadEsp AS CorreoUnidadEsp,
			Var_NombreRepLegal AS Presidente,
			Var_TipoSubClasif AS TipoSubClasif,
			Var_Descripcion AS ProductoCredito,
			IFNULL(Var_TipoPersona, Cadena_Vacia) AS TipoPersona,
			Var_RegistroRECA AS RECA;
	END IF;

	-- CUADRO INFORMATIVO DEL CRÉDITO (PRIMERA HOJA)
	IF(IFNULL(Par_TipoReporte,Entero_Cero)=TipoCuadroInform)THEN
		-- DATOS DEL CREDITO.
		SELECT
			C.ValorCAT,				C.MontoCredito,			C.PlazoID,				C.TasaFija,			C.FactorMora,
			C.ProductoCreditoID,	C.MontoSeguroVida,		C.SeguroVidaPagado,		P.Descripcion,		P.RegistroRECA,
			C.MontoComApert
		INTO
			Var_ValorCAT,			Var_MontoCredito,		Var_PlazoID,			Var_TasaFija,		Var_FactorMora,
			Var_ProductoCreditoID,	Var_MontoSeguroVida,	Var_SeguroVidaPagado,	Var_Descripcion,	Var_RegistroRECA,
			Var_MontoComApert
		FROM CREDITOS C INNER JOIN PRODUCTOSCREDITO P ON C.ProductoCreditoID=P.ProducCreditoID
			WHERE C.CreditoID = Par_CreditoID;

		SELECT ROUND(Dias/30),	Descripcion
		INTO Var_PlazoMeses,	Var_PlazoDescripcion
		FROM CREDITOSPLAZOS
			WHERE PlazoID = Var_PlazoID;

		-- SE OBTIENE LA INFORMACIÓN DE LAS GARANTÍAS
		SELECT PorcentajeApli
		INTO Var_PorcentajeFEGA
		FROM BITACORAAPLIGAR
			WHERE CreditoID = Par_CreditoID;

		SET Var_PorcentajeFEGA := IFNULL(Var_PorcentajeFEGA, Entero_Cero);

		SELECT
			GROUP_CONCAT(UPPER(CONCAT(G.GarantiaID, ': ',LEFT(G.Observaciones,700))) SEPARATOR ', ')
		INTO
			Var_TiposGarantias
			FROM GARANTIAS G INNER JOIN ASIGNAGARANTIAS A ON G.GarantiaID=A.GarantiaID
				INNER JOIN TIPOGARANTIAS T ON G.TipoGarantiaID=T.TipoGarantiasID
			WHERE A.SolicitudCreditoID = Var_SolicitudCreditoID
				AND A.Estatus = EstatusAutorizado;

		-- PORCENTAJE DE LA COMISION POR ADMINISTRACIÓN (LIQ. ANTICIPADA)
		SELECT
			PermiteLiqAntici,		CobraComLiqAntici,		TipComLiqAntici,		ComisionLiqAntici
		INTO
			Var_PermiteLiqAntici,	Var_CobraComLiqAntici,	Var_TipComLiqAntici,	Var_ComisionLiqAntici
		FROM ESQUEMACOMPRECRE ES INNER JOIN PRODUCTOSCREDITO PC ON (ES.ProductoCreditoID = PC.ProducCreditoID)
		WHERE  ES.ProductoCreditoID = Var_ProductoCreditoID;

		SET Var_PermiteLiqAntici	:= IFNULL(Var_PermiteLiqAntici, Cons_No);
		SET Var_CobraComLiqAntici	:= IFNULL(Var_CobraComLiqAntici, Cons_No);
		SET Var_TipComLiqAntici		:= IFNULL(Var_TipComLiqAntici, Cons_No);
		SET Var_ComisionLiqAntici	:= IFNULL(Var_ComisionLiqAntici, Entero_Cero);

		IF(Var_PermiteLiqAntici = Cons_SI AND Var_CobraComLiqAntici = Cons_SI
			AND Var_TipComLiqAntici = Por_Porcentaje)THEN
			-- SE OBTIENE EL SALDO INSOLUTO DEL CRÉDITO
			SELECT	SUM(Capital + Interes + IVAInteres)
			INTO	Var_SaldoInsoluto
				FROM AMORTICREDITOAGRO
				WHERE CreditoID = Par_CreditoID;
		ELSE
			SET Var_ComisionLiqAntici := Entero_Cero;
		END IF;

		SET Var_SaldoInsoluto	:= IFNULL(Var_MontoCredito, Entero_Cero);
		SET Var_SaldoInsoluto	:= (Var_MontoComApert * 100)/Var_SaldoInsoluto;

		SET Var_ComisionAdmon := CONCAT(ROUND(Var_SaldoInsoluto, 2),'% del crédito total = ',CONVPORCANT(Var_MontoComApert,'$C','2' ,''));

		SET Var_ComisionAdmon := UPPER(Var_ComisionAdmon);

		SELECT
			Var_NombreRepresentante AS ApoderadoLegal,
			Var_NombreInstitucion AS NombreInstitucionFin,
			Var_Direccion AS DomicilioCliente,
			Var_NombreCliente AS NombreCompletoCliente,
			CONCAT('"',Var_NombreCliente,'"') AS NombreClienteMoral,
			Par_CreditoID AS CreditoID,
			CONVPORCANT(Var_ValorCAT,'%A','2' ,'ANUAL') AS CAT,
			CONVPORCANT(Var_MontoCredito,'$C','2' ,'') AS MontoAutorizado,
			IF(Var_CalcInteresID = TasaFija, CONVPORCANT(Var_TasaFija,'%A','4' ,'ANUAL'), CONCAT('TASA VARIABLE que se calculará a razón de la Tasa de Interés Interbancaria de Equilibrio (T.I.I.E.) mas ',ROUND(Var_TasaBase,2),' Puntos; la tasa pactada se revisará y ajustará mensualmente conforme a las variaciones de T.I.I.E.')) AS TasaInteres,
			CONCAT('Tasa de Interés Ordinaria por ',Var_FactorMora,'.') AS FactorMora,
			CONVPORCANT(IFNULL(Var_MontoSeguroVida,Entero_Cero),'$C','2' ,'') AS MontoSegVida,
			CONVPORCANT(IFNULL(Var_SeguroVidaPagado,Entero_Cero),'$C','2' ,'') AS MontoCubiertoSegVida,
			Var_ComisionAdmon AS ComisionAdmon,
			CONCAT(ROUND(Var_PorcentajeFEGA, 2),'% más IVA por el monto del crédito.') AS PorcentajeFEGA,
			Var_ProductoCreditoID,
			Var_Descripcion AS ProductoCredito,
			Var_RegistroRECA AS RECA,
			Var_PlazoMeses,
			Var_PlazoDescripcion AS PlazoMeses,
			Var_TipoSubClasif AS TipoSubClasif,
			IFNULL(Var_TipoPersona, Cadena_Vacia) AS TipoPersona,
			CONCAT(UPPER(IFNULL(Var_TiposGarantias, Cadena_Vacia))) AS TiposGarantias,
			Var_NombreRepLegal AS Presidente,
			Cadena_Vacia AS Secretario,
			Cadena_Vacia AS Tesorero,
			CONCAT('Domicilio: Juárez Norte No. 6, Col. Centro Tlajomulco de Zúñiga, Jalisco, Tel (33) 37982000, 37980766, Fax. 37980237, www.consolnegocios.com, Correo electrónico: ', Var_CorreoUnidadEsp) AS DatosUnidadEsp,
			'/opt/SAFI/imgReportes/LogoContratoConsol.png' AS LogoContrato;
	END IF;

	-- TIPO DE REPORTE QUE MUESTRA LAS AMORTIZACIONES DE UN CRÉDITO.
	IF(IFNULL(Par_TipoReporte,Entero_Cero)=TipoAmortizaciones)THEN
		SELECT AmortizacionID, FNFECHACOMPLETA(FechaExigible,3) AS Fecha, CONVPORCANT(Capital,'$C','2' ,'') AS Monto
			FROM AMORTICREDITOAGRO
		WHERE CreditoID = Par_CreditoID;
	END IF;

	-- SECCION DE DECLARACIONES DE LA 2DA HOJA.
	IF(IFNULL(Par_TipoReporte,Entero_Cero)=TipoDeclaraciones)THEN
		SET Var_NombreGarante	:= (SELECT GROUP_CONCAT(DISTINCT G.NombreCompleto SEPARATOR ', ')
										FROM TMPGARANTESAGRO G
											WHERE G.CreditoID = Par_CreditoID);
		SET Var_NombreAval		:= (SELECT GROUP_CONCAT(DISTINCT G.NombreCompleto SEPARATOR ', ')
										FROM TMPAVALESAGRO G
											WHERE G.CreditoID = Par_CreditoID);

		SET Var_NombreGarante := IFNULL(Var_NombreGarante, Cadena_Vacia);
		SET Var_NombreAval := IFNULL(Var_NombreAval, Cadena_Vacia);

		-- Datos de la escritura pública de Consol
		SELECT
			EscrituraPublic,		FechaEsc,			Notaria,		LocalidadEsc,		NomNotario,
			NomApoderado,			FolioRegPub,		EstadoIDEsc
		INTO
			Var_EscrituraPublic,	Var_FechaEsc,		Var_Notaria,	Var_LocalidadEsc,	Var_NomNotario,
			Var_NomApoderado,		Var_FolioRegPub,	Var_EstadoIDEsc
		FROM ESCRITURAPUB
			WHERE ClienteID = Var_ClienteInstitucion
				AND Estatus = EstatusVig
			ORDER BY FechaEsc DESC
			LIMIT 1;

		SET Var_EscrituraPublic		:= IFNULL(Var_EscrituraPublic, Entero_Cero);
		SET Var_NoEscritura			:= CONVERT(Var_EscrituraPublic, SIGNED);
		SET Var_NoEscritura			:= CAST(Var_EscrituraPublic AS SIGNED);
		SET Var_NoEscrituraD		:= CAST(Var_NoEscritura AS DECIMAL);
		SET Var_FechaEsc			:= IFNULL(Var_FechaEsc, Fecha_Vacia);
		SET Var_Notaria				:= IFNULL(Var_Notaria, Entero_Cero);
		SET Var_EstadoIDEsc			:= IFNULL(Var_EstadoIDEsc, Entero_Cero);
		SET Var_LocalidadEsc		:= IFNULL(Var_LocalidadEsc, Entero_Cero);
		SET Var_NomNotario			:= IFNULL(Var_NomNotario, Cadena_Vacia);
		SET Var_NomApoderado		:= IFNULL(Var_NomApoderado, Cadena_Vacia);
		SET Var_NomMunicipio		:= IFNULL(Var_NomMunicipio, Cadena_Vacia);

		SET Var_NomMunicipio := (SELECT	Nombre
									FROM MUNICIPIOSREPUB
										WHERE EstadoID = Var_EstadoIDEsc AND MunicipioID = Var_LocalidadEsc);
		-- DATOS DEL CLIENTE CUANDO ES DE TIPO MORAL
		IF(IFNULL(Var_TipoPersona, Cadena_Vacia) = PersonaMoral)THEN
			-- Datos de la escritura pública del cliente
			SELECT
				EscrituraPublic,		FechaEsc,			Notaria,		LocalidadEsc,		NomNotario,
				NomApoderado,			FolioRegPub,		EstadoIDEsc,	EstadoIDReg,		LocalidadRegPub
			INTO
				Var_EscrituraPublicCte,	Var_FechaEscCte,		Var_NotariaCte,	Var_LocalidadEscCte,	Var_NomNotarioCte,
				Var_NomApoderadoCte,		Var_FolioRegPubCte,	Var_EstadoIDEscCte,	Var_EstadoIDRegCte,		Var_LocalidadRegPubCte
			FROM ESCRITURAPUB
				WHERE ClienteID = Var_ClienteID
					AND Estatus = EstatusVig
				ORDER BY FechaEsc DESC
				LIMIT 1;

			SET Var_EscrituraPublicCte	:= IFNULL(Var_EscrituraPublicCte, Entero_Cero);
			SET Var_NoEscrituraCte		:= CONVERT(Var_EscrituraPublicCte, SIGNED);
			SET Var_NoEscrituraCte		:= CAST(Var_EscrituraPublicCte AS SIGNED);
			SET Var_NoEscrituraDCte		:= CAST(Var_NoEscrituraCte AS DECIMAL);
			SET Var_FechaEscCte			:= IFNULL(Var_FechaEscCte, Fecha_Vacia);
			SET Var_NotariaCte			:= IFNULL(Var_NotariaCte, Entero_Cero);
			SET Var_EstadoIDEscCte		:= IFNULL(Var_EstadoIDEscCte, Entero_Cero);
			SET Var_LocalidadEscCte		:= IFNULL(Var_LocalidadEscCte, Entero_Cero);
			SET Var_NomNotarioCte		:= IFNULL(Var_NomNotarioCte, Cadena_Vacia);
			SET Var_NomApoderadoCte		:= IFNULL(Var_NomApoderadoCte, Cadena_Vacia);
			SET Var_EstadoIDRegCte		:= IFNULL(Var_EstadoIDRegCte, Entero_Cero);
			SET Var_LocalidadRegPubCte	:= IFNULL(Var_LocalidadRegPubCte, Entero_Cero);

			SET Var_NomEstadoCte := (SELECT	Nombre
										FROM ESTADOSREPUB
											WHERE EstadoID = Var_EstadoIDEscCte);

			SET Var_NomMunicipioCte := (SELECT	Nombre
										FROM MUNICIPIOSREPUB
											WHERE EstadoID = Var_EstadoIDEscCte AND MunicipioID = Var_LocalidadEscCte);

			SET Var_NomEstadoRegPubCte := (SELECT	Nombre
										FROM ESTADOSREPUB
											WHERE EstadoID = Var_EstadoIDRegCte);

			SET Var_NomMunRegPubCte := (SELECT	Nombre
										FROM MUNICIPIOSREPUB
											WHERE EstadoID = Var_EstadoIDRegCte AND MunicipioID = Var_LocalidadRegPubCte);

			SET Var_NomEstadoCte		:= IFNULL(Var_NomEstadoCte, Cadena_Vacia);
			SET Var_NomMunicipioCte		:= IFNULL(Var_NomMunicipioCte, Cadena_Vacia);
			SET Var_NomEstadoRegPubCte	:= IFNULL(Var_NomEstadoRegPubCte, Cadena_Vacia);
			SET Var_NomMunRegPubCte		:= IFNULL(Var_NomMunRegPubCte, Cadena_Vacia);

			SET Var_NomTipoSociedad := (SELECT Descripcion FROM TIPOSOCIEDAD WHERE TipoSociedadID = Var_TipoSociedadID LIMIT 1);
		END IF;

		SET Var_NoEscritura			:= IFNULL(Var_NoEscritura,Entero_Cero);
		SET Var_FechaEsc			:= IFNULL(Var_FechaEsc,Fecha_Vacia);
		SET Var_Notaria				:= IFNULL(Var_Notaria,Entero_Cero);
		SET Var_NomMunicipio		:= IFNULL(Var_NomMunicipio,Cadena_Vacia);
		SET Var_NomNotario			:= IFNULL(Var_NomNotario,Cadena_Vacia);
		SET Var_FolioRegPub			:= IFNULL(Var_FolioRegPub,Entero_Cero);
		SET Var_NomApoderado		:= IFNULL(Var_NomApoderado,Cadena_Vacia);
		SET Var_FolioRegPubCte		:= IFNULL(Var_FolioRegPubCte, Entero_Cero);
		SET Var_NomEstadoRegPubCte	:= IFNULL(Var_NomEstadoRegPubCte, Cadena_Vacia);
		SET Var_NomMunRegPubCte		:= IFNULL(Var_NomMunRegPubCte, Cadena_Vacia);
		SET Var_NomMunicipioCte		:= IFNULL(Var_NomMunicipioCte, Cadena_Vacia);
		SET Var_NomTipoSociedad		:= IFNULL(Var_NomTipoSociedad, Cadena_Vacia);
		SET Var_NomEstadoCte		:= IFNULL(Var_NomEstadoCte, Cadena_Vacia);
		SET Var_NoEscrituraCte		:= IFNULL(Var_NoEscrituraCte, Entero_Cero);

		SELECT
			Var_NombreGarante AS Garantes,
			CONCAT('USUFRUCTUARIO(S)”, ASÍ MISMO COMPARECE (N) EL (LOS) SEÑOR (ES): ',Var_NombreAval,' COMO EL (LOS) AVAL (ES) U OBLIGADO SOLIDARIO A QUIEN (ES) EN LO SUCESIVO SE LE (S) DENOMINARÁ CONJUNTA E INDISTINTAMENTE COMO “EL(LOS) AVAL(ES) U OBLIGADO SOLIDARIO”, DE CONFORMIDAD CON LAS SIGUIENTES DECLARACIONES Y CLÁUSULAS.') AS Avales,

			CONVERT(CONCAT('Que con fecha 05 (Cinco) del mes de Marzo del 2007 se cambió la denominación social de “FIRAGRO SA de CV” a “',Var_NombreInstitucion,'”, según consta en la Escritura Pública número 16,356 (Dieciséis Mil Trescientos Cincuenta y Seis) otorgada bajo la fe del notario público número 3 (tres) Lic. Edmundo Márquez Hernández,  en legal ejercicio en la ciudad de Tlajomulco de Zúñiga, Jalisco e  inscrita en el Registro Público de la Propiedad y de Comercio del estado de Jalisco con fecha 29 de marzo del 2007 con el folio mercantil Electrónico No. 23674*1.') USING utf8) AS IncisoB,
			CONVERT(CONCAT('Las facultades con las que actúa no le han sido revocadas ni restringidas, por lo que comparece en pleno ejercicio de facultades delegadas, según costa en la Escritura Pública número 16,473 (Dieciséis Mil Cuatrocientos Setenta y tres) que contiene la aclaración de la sociedad denominada ',Var_NombreInstitucion,', de fecha 02 (Dos) de mayo del 2007 otorgada bajo la fe del notario público número 3 (tres) Lic. Edmundo Márquez Hernández, en legal ejercicio en la ciudad de Tlajomulco de Zúñiga, Jalisco, e inscrita en el Registro Público de la Propiedad y de Comercio del Estado de Jalisco con fecha 25 de junio del 2007.') USING utf8) AS IncisoC,

			CONVERT(CONCAT('La personalidad con la que se actúa se acredita mediante la Escritura Pública número ',FORMAT(Var_NoEscritura,0),' (',TRIM(FUNCIONSOLONUMLETRAS(Var_NoEscritura)), ') de fecha ', FNFECHACOMPLETA(Var_FechaEsc,3), ' otorgada ante la Fe del Notario Público Número ',FORMAT(Var_Notaria,0),' (',TRIM(FUNCIONSOLONUMLETRAS(Var_Notaria)),'), de la Ciudad de ', TRIM(FNLETRACAPITAL(Var_NomMunicipio)), ', Jalisco, Lic. ',UPPER(Var_NomNotario), ' inscrita en el Registro Público de la Propiedad y de Comercio con el Folio Mercantil Electrónico No. ', Var_FolioRegPub, ' en el cual se otorga al C. ', Var_NomApoderado, ' poder Judicial para Pleitos y Cobranzas y para Suscripción de Títulos y Operaciones de Crédito en los términos del Artículo 9° noveno de la Ley General de Títulos y Operaciones de Crédito.') USING utf8) AS IncisoD,
			CONVERT(CONCAT('Que es una ',IFNULL(Var_NomTipoSociedad, Cadena_Vacia),'  constituida mediante escritura número ',FORMAT(Var_NoEscrituraCte,0),' (',TRIM(FUNCIONSOLONUMLETRAS(Var_NoEscrituraCte)), ') de fecha ', FNFECHACOMPLETA(Var_FechaEscCte,3), ' pasada ante la fe del notario público número ',FORMAT(Var_NotariaCte,0),' (',TRIM(FUNCIONSOLONUMLETRAS(Var_NotariaCte)),') de la municipalidad de ', TRIM(FNLETRACAPITAL(Var_NomMunicipioCte)), ', ',TRIM(FNLETRACAPITAL(Var_NomEstadoCte)),', la cual se encuentra inscrita en el Registro Público de la Propiedad y de Comercio con sede en ', TRIM(FNLETRACAPITAL(Var_NomMunRegPubCte)), ', ',TRIM(FNLETRACAPITAL(Var_NomEstadoRegPubCte)),' con el folio mercantil ',Var_FolioRegPubCte,'.') USING utf8) AS IncisoAII,
			CONVERT(CONCAT('Que tiene su domicilio en ',Var_Direccion) USING utf8) AS IncisoCII,
			CONVERT(CONCAT('Que la Sociedad                                                                                     tiene por objeto social: I.-                                                                                   ,   II.-                                                           ; III.-                                                                 ; IV.-                                                                         .') USING utf8) AS IncisoDII,
			CONVERT(CONCAT('La personalidad con la que se actúa se acredita mediante la Escritura Pública número ',FORMAT(Var_NoEscrituraCte,0),' (',TRIM(FUNCIONSOLONUMLETRAS(Var_NoEscrituraCte)), ') de fecha ', FNFECHACOMPLETA(Var_FechaEscCte,3), ' otorgada ante la Fe del Notario Público Número ',FORMAT(Var_NotariaCte,0),' (',TRIM(FUNCIONSOLONUMLETRAS(Var_NotariaCte)),') de la Ciudad de ', TRIM(FNLETRACAPITAL(Var_NomMunicipioCte)), ', ',TRIM(FNLETRACAPITAL(Var_NomEstadoCte)),', Lic. ______, inscrita en el Registro Público de la Propiedad y de Comercio con el Folio Mercantil Electrónico No. ', Var_FolioRegPubCte, ' en el cual se otorga al C. ', Var_NomApoderadoCte, ' poder Judicial para Pleitos y Cobranzas y para Suscripción de Títulos y Operaciones de Crédito en los términos del Artículo 9° noveno de la Ley General de Títulos y Operaciones de Crédito.') USING utf8) AS IncisoEII
		;
	END IF;

	-- TIPO DE REPORTE DE LA PRIMERA PARTE DE LAS CLAUSULAS.
	IF(IFNULL(Par_TipoReporte,Entero_Cero)=TipoClausula1Parte)THEN

	-- Se obtiene el monto total de los Recursos del Préstamo
		SET Var_MontoPrestamo := (SELECT SUM(Con.Monto)
										FROM CONCEPTOINVERAGRO Con
									WHERE Con.SolicitudCreditoID = Var_SolicitudCreditoID
										AND Con.TipoRecurso = ConcInvRecPrestamo);

	-- Se obtiene el monto total de los Recursos del Solicitante
		SET Var_MontoSolicitante := (SELECT SUM(Con.Monto)
											FROM CONCEPTOINVERAGRO Con
										WHERE Con.SolicitudCreditoID = Var_SolicitudCreditoID
											AND Con.TipoRecurso = ConcInvRecSolicitante);

		-- Se obtienen los porcentajes respecto al monto del crédito.
		SET Var_MontoPrestamo		:= FNPORCENTAJE(Var_MontoCredito, Var_MontoPrestamo, Entero_Cero);
		SET Var_MontoSolicitante	:= FNPORCENTAJE(Var_MontoCredito, Var_MontoSolicitante, Entero_Cero);

		SELECT
			CONVERT(CONCAT('SEGUNDA.- OTORGAMIENTO DE “EL CRÉDITO”.- Por este acto “LA ACREDITANTE” establece en favor de “EL ACREDITADO” un Crédito de ',Var_TipoSubClasif,', hasta por ',CONVPORCANT(Var_MontoCredito,'$C','2' ,''), ' Este monto se denominará dentro del presente contrato como “EL CRÉDITO”.') USING utf8) AS SegClausula,
			CONVERT(CONCAT('El monto del préstamo a que se refiere el párrafo anterior representa el ',CONVPORCANT(Var_MontoPrestamo,'%C','2' ,')'),' de los recursos que requiere “EL ACREDITADO” para desarrollar el Proyecto, obligándose “EL ACREDITADO” a realizar con sus propios recursos el  segundo concepto y que representa el ',CONVPORCANT(Var_MontoSolicitante,'%C','2' ,')'),'.') USING utf8) AS SegClausula2Par;
	END IF;

	-- TIPO DE REPORTE PARA LISTAR LOS CONCEPTOS Y UNIDADES DE INVERSIÓN
	IF(IFNULL(Par_TipoReporte,Entero_Cero) IN (TipoConceptoInversion))THEN
		DELETE FROM TMPCONCEPTOSINVFIRA WHERE CreditoID=Par_CreditoID;

		SET @Var_Consecutivo := Entero_Cero;

		-- ENCABEZADO SECCIÓN CONCEPTOS DE INVERSIÓN RECURSOS DEL PRÉSTAMO
		INSERT INTO TMPCONCEPTOSINVFIRA (
			ConsecutivoID,	ConceptoFiraID,	TipoRecurso,	Descripcion,		NoUnidades,
			Unidad,			Monto,			UnidadAlingn,	UnidadBorderLeft,	DescripcionBold,
			UnidadBold,		MontoBold,		CreditoID)
		VALUES (
			(@Var_Consecutivo := @Var_Consecutivo +1),
			Entero_Cero,	ConcInvRecPrestamo, 'Con Recursos del Préstamo:', Cadena_Vacia,
			Cadena_Vacia,	Cadena_Vacia,	'RIGHT', '0', 'true', 'true', 'true', Par_CreditoID);

		INSERT INTO TMPCONCEPTOSINVFIRA (
			ConsecutivoID,	ConceptoFiraID,	TipoRecurso,	Descripcion,	NoUnidades,
			Unidad,			Monto,			MontoDecimal,	CreditoID)
		SELECT
			(@Var_Consecutivo := @Var_Consecutivo +1),
			Con.ConceptoFiraID, Con.TipoRecurso, Cat.Descripcion, Con.NoUnidad,
			Con.Unidad,	FORMAT(Con.Monto,2),	ROUND(Con.Monto,2),	Par_CreditoID
		FROM CONCEPTOINVERAGRO Con
			INNER JOIN  CATCONCEPTOSINVERAGRO Cat ON(Cat.ConceptoFiraID = Con.ConceptoFiraID)
		WHERE Con.SolicitudCreditoID = Var_SolicitudCreditoID
			AND Con.ClienteID = Var_ClienteID
			AND Con.TipoRecurso = ConcInvRecPrestamo
		ORDER BY Con.ConceptoFiraID;

		-- Conceptos de Inversión Recursos del Préstamo (TOTALES)
		SET Var_MontoPrestamo := (SELECT SUM(Con.MontoDecimal)
									FROM TMPCONCEPTOSINVFIRA Con
									WHERE Con.CreditoID = Par_CreditoID
										AND Con.TipoRecurso = ConcInvRecPrestamo);

		INSERT INTO TMPCONCEPTOSINVFIRA (
			ConsecutivoID,	ConceptoFiraID,	TipoRecurso,	Descripcion,		NoUnidades,
			Unidad,			Monto,			UnidadAlingn,	UnidadBorderLeft,	DescripcionBold,
			UnidadBold,		MontoBold,		CreditoID)
		VALUES (
			(@Var_Consecutivo := @Var_Consecutivo +1),
			Entero_Cero,	ConcInvRecPrestamo, Cadena_Vacia, Cadena_Vacia,
			'Total Crédito', FORMAT(IFNULL(Var_MontoPrestamo, Entero_Cero),2),	'RIGHT', '0', 'true', 'true', 'true', Par_CreditoID);

		-- ENCABEZADO SECCIÓN CONCEPTOS DE INVERSIÓN RECURSOS DEL SOLICITANTE
		INSERT INTO TMPCONCEPTOSINVFIRA (
			ConsecutivoID,	ConceptoFiraID,	TipoRecurso,	Descripcion,		NoUnidades,
			Unidad,			Monto,			UnidadAlingn,	UnidadBorderLeft,	DescripcionBold,
			UnidadBold,		MontoBold,		CreditoID)
		VALUES (
			(@Var_Consecutivo := @Var_Consecutivo +1),
			Entero_Cero,	ConcInvRecSolicitante, 'Con Recursos del Acreditado:', Cadena_Vacia,
			Cadena_Vacia,	Cadena_Vacia,	'RIGHT', '0', 'true', 'true', 'true', Par_CreditoID);

		INSERT INTO TMPCONCEPTOSINVFIRA (
			ConsecutivoID,	ConceptoFiraID,	TipoRecurso,	Descripcion,	NoUnidades,
			Unidad,			Monto,			MontoDecimal,	CreditoID)
		SELECT
			(@Var_Consecutivo := @Var_Consecutivo +1),
			Con.ConceptoFiraID, Con.TipoRecurso, Cat.Descripcion, Con.NoUnidad,
			Con.Unidad,	FORMAT(Con.Monto,2), ROUND(Con.Monto,2),	Par_CreditoID
		FROM CONCEPTOINVERAGRO Con
			INNER JOIN  CATCONCEPTOSINVERAGRO Cat ON(Cat.ConceptoFiraID = Con.ConceptoFiraID)
		WHERE Con.SolicitudCreditoID = Var_SolicitudCreditoID
			AND Con.ClienteID = Var_ClienteID
			AND Con.TipoRecurso = ConcInvRecSolicitante
		ORDER BY Con.ConceptoFiraID;

		-- Conceptos de Inversión Recursos del Solicitante (TOTALES)
		SET Var_MontoPrestamo := (SELECT SUM(Con.MontoDecimal)
									FROM TMPCONCEPTOSINVFIRA Con
									WHERE Con.CreditoID = Par_CreditoID
										AND Con.TipoRecurso = ConcInvRecSolicitante);

		INSERT INTO TMPCONCEPTOSINVFIRA (
			ConsecutivoID,	ConceptoFiraID,	TipoRecurso,	Descripcion,		NoUnidades,
			Unidad,			Monto,			UnidadAlingn,	UnidadBorderLeft,	DescripcionBold,
			UnidadBold,		MontoBold,		CreditoID)
		VALUES (
			(@Var_Consecutivo := @Var_Consecutivo +1),
			Entero_Cero,	ConcInvRecSolicitante, Cadena_Vacia, Cadena_Vacia,
			'Total Aportación', FORMAT(IFNULL(Var_MontoPrestamo, Entero_Cero),2),	'RIGHT', '0', 'true', 'true', 'true', Par_CreditoID);

		-- ENCABEZADO SECCIÓN CONCEPTOS DE INVERSIÓN RECURSOS DE OTRAS FUENTES
		INSERT INTO TMPCONCEPTOSINVFIRA (
			ConsecutivoID,	ConceptoFiraID,	TipoRecurso,	Descripcion,		NoUnidades,
			Unidad,			Monto,			UnidadAlingn,	UnidadBorderLeft,	DescripcionBold,
			UnidadBold,		MontoBold,		CreditoID)
		VALUES (
			(@Var_Consecutivo := @Var_Consecutivo +1),
			Entero_Cero,	ConcInvRecOtrasF, 'Con Recursos de Otras Fuentes:', Cadena_Vacia,
			Cadena_Vacia,	Cadena_Vacia,	'RIGHT', '0', 'true', 'true', 'true', Par_CreditoID);

		INSERT INTO TMPCONCEPTOSINVFIRA (
			ConsecutivoID,	ConceptoFiraID,	TipoRecurso,	Descripcion,	NoUnidades,
			Unidad,			Monto,			MontoDecimal,	CreditoID)
		SELECT
			(@Var_Consecutivo := @Var_Consecutivo +1),
			Con.ConceptoFiraID, Con.TipoRecurso, Cat.Descripcion, Con.NoUnidad,
			Con.Unidad,	FORMAT(Con.Monto,2),	ROUND(Con.Monto,2),	Par_CreditoID
		FROM CONCEPTOINVERAGRO Con
			INNER JOIN  CATCONCEPTOSINVERAGRO Cat ON(Cat.ConceptoFiraID = Con.ConceptoFiraID)
		WHERE Con.SolicitudCreditoID = Var_SolicitudCreditoID
			AND Con.ClienteID = Var_ClienteID
			AND Con.TipoRecurso = ConcInvRecOtrasF
		ORDER BY Con.ConceptoFiraID;

		SET Var_MontoPrestamo := (SELECT SUM(Con.MontoDecimal)
									FROM TMPCONCEPTOSINVFIRA Con
									WHERE Con.CreditoID = Par_CreditoID
										AND Con.TipoRecurso = ConcInvRecOtrasF);

		-- Totales
		INSERT INTO TMPCONCEPTOSINVFIRA (
			ConsecutivoID,	ConceptoFiraID,	TipoRecurso,	Descripcion,		NoUnidades,
			Unidad,			Monto,			UnidadAlingn,	UnidadBorderLeft,	DescripcionBold,
			UnidadBold,		MontoBold,		CreditoID)
		VALUES (
			(@Var_Consecutivo := @Var_Consecutivo +1),
			Entero_Cero,	ConcInvRecOtrasF, Cadena_Vacia, Cadena_Vacia,
			'Total Aportación', FORMAT(IFNULL(Var_MontoPrestamo, Entero_Cero),2),	'RIGHT', '0', 'true', 'true', 'true', Par_CreditoID);

		SET Var_MontoProyecto := (SELECT SUM(Con.MontoDecimal)
									FROM TMPCONCEPTOSINVFIRA Con
									WHERE Con.CreditoID = Par_CreditoID);
		-- TOTAL DEL PROYECTO
		INSERT INTO TMPCONCEPTOSINVFIRA (
			ConsecutivoID,	ConceptoFiraID,	TipoRecurso,	Descripcion,		NoUnidades,
			Unidad,			Monto,			UnidadAlingn,	UnidadBorderLeft,	DescripcionBold,
			UnidadBold,		MontoBold,		CreditoID)
		VALUES (
			(@Var_Consecutivo := @Var_Consecutivo +1),
			Entero_Cero,	ConcInvRecOtrasF, Cadena_Vacia, Cadena_Vacia,
			'Total del Proyecto', FORMAT(IFNULL(Var_MontoProyecto, Entero_Cero),2),	'RIGHT', '0', 'true', 'true', 'true', Par_CreditoID);

		SELECT
			Descripcion,		NoUnidades,			Unidad,			Monto,		UnidadAlingn,
			UnidadBorderLeft,	DescripcionBold,	UnidadBold,		MontoBold
		FROM TMPCONCEPTOSINVFIRA
			WHERE CreditoID = Par_CreditoID
			ORDER BY ConsecutivoID;
	END IF;

	-- TIPO DE REPORTE QUE MUESTRA LAS MINISTRACIONES DE UN CRÉDITO.
	IF(IFNULL(Par_TipoReporte,Entero_Cero)=TipoMinistraciones)THEN
		DELETE FROM TMPMINISTRACIONESFIRA WHERE CreditoID=Par_CreditoID;

		SET @Var_Consecutivo := Entero_Cero;

		INSERT INTO TMPMINISTRACIONESFIRA(
			ConsecutivoID,	Numero,	Fecha,	Monto, CreditoID)
		SELECT
			(@Var_Consecutivo := @Var_Consecutivo +1),
			Numero, IF(Numero = 1, 'AL CONTRATAR', FNFECHACOMPLETA(FechaPagoMinis, 3)) AS FechaMinistracion,
			CONVPORCANT(Capital,'$C','2' ,'') AS Capital, Par_CreditoID
			FROM MINISTRACREDAGRO
			WHERE CreditoID = Par_CreditoID;

		SET Var_MontoProyecto := (SELECT SUM(Capital) FROM MINISTRACREDAGRO
									WHERE CreditoID = Par_CreditoID);

		INSERT INTO TMPMINISTRACIONESFIRA(
			ConsecutivoID,		Numero,			Fecha,		FechaAlingn,	FechaBorderLeft,
			Monto,				FechaBold,		CreditoID)
		VALUES(
			(@Var_Consecutivo := @Var_Consecutivo +1),
			Cadena_Vacia,	'Total',	'LEFT',	'0',
			CONVPORCANT(Var_MontoProyecto,'$C','2' ,''), 'true', Par_CreditoID);

		-- Datos de la escritura pública
		SELECT
			EscrituraPublic,		FechaEsc,			Notaria,		LocalidadEsc,		NomNotario,
			NomApoderado,			FolioRegPub,		EstadoIDEsc
		INTO
			Var_EscrituraPublic,	Var_FechaEsc,		Var_Notaria,	Var_LocalidadEsc,	Var_NomNotario,
			Var_NomApoderado,		Var_FolioRegPub,	Var_EstadoIDEsc
		FROM ESCRITURAPUB
			WHERE ClienteID = Var_ClienteID
				AND Estatus = EstatusVig
			ORDER BY FechaEsc DESC
			LIMIT 1;

		SET Var_NomEstado := (SELECT	Nombre
									FROM ESTADOSREPUB
										WHERE EstadoID = Var_EstadoIDEsc);

		SET Var_NomMunicipio := (SELECT	Nombre
									FROM MUNICIPIOSREPUB
										WHERE EstadoID = Var_EstadoIDEsc AND MunicipioID = Var_LocalidadEsc);

		SET Var_EscrituraPublic		:= IFNULL(Var_EscrituraPublic, Entero_Cero);
		SET Var_NoEscritura			:= CONVERT(Var_EscrituraPublic, SIGNED);
		SET Var_NoEscritura			:= CAST(Var_EscrituraPublic AS SIGNED);
		SET Var_NoEscrituraD		:= CAST(Var_NoEscritura AS DECIMAL);
		SET Var_FechaEsc			:= IFNULL(Var_FechaEsc, Fecha_Vacia);
		SET Var_Notaria				:= IFNULL(Var_Notaria, Entero_Cero);
		SET Var_EstadoIDEsc			:= IFNULL(Var_EstadoIDEsc, Entero_Cero);
		SET Var_LocalidadEsc		:= IFNULL(Var_LocalidadEsc, Entero_Cero);
		SET Var_NomNotario			:= IFNULL(Var_NomNotario, Cadena_Vacia);
		SET Var_NomApoderado		:= IFNULL(Var_NomApoderado, Cadena_Vacia);
		SET Var_NomEstado			:= IFNULL(Var_NomEstado, Cadena_Vacia);
		SET Var_NomMunicipio		:= IFNULL(Var_NomMunicipio, Cadena_Vacia);

		-- Resultado Final
		SELECT
			Numero,				Fecha,			Monto,		FechaAlingn,	FechaBorderLeft,
			FechaBold,

			CONVERT(CONCAT('“EL ACREDITADO”  reconoce y acepta que esta disposición se sujeta a los derechos y obligaciones establecidos en el Contrato de Crédito en Escritura Pública Número ',Var_EscrituraPublic,', de Fecha ',FNFECHACOMPLETA(Var_FechaEsc, 3),' pasada ante la fe del Licenciado ',UPPER(Var_NomNotario),', Notario Público Número ',Var_Notaria,', con ejercicio en ',TRIM(FNLETRACAPITAL(Var_NomMunicipio)),' municipio de ',TRIM(FNLETRACAPITAL(Var_NomEstado)),', del estado de ',TRIM(FNLETRACAPITAL(Var_NomEstado)),'.') USING utf8) AS 1erParrMinistra
			FROM TMPMINISTRACIONESFIRA
			WHERE CreditoID = Par_CreditoID
			ORDER BY ConsecutivoID;
	END IF;


	-- TIPO DE REPORTE QUE MUESTRA LAS MINISTRACIONES DE UN CRÉDITO.
	IF(IFNULL(Par_TipoReporte,Entero_Cero)=Tipo5taHoja)THEN
		-- DATOS DEL CREDITO.
		SELECT
			C.ValorCAT,				C.TasaFija,				C.FactorMora,	C.ProductoCreditoID,	C.MontoSeguroVida,
			C.SeguroVidaPagado,		P.MontoComXapert,		P.TipoComXapert,	C.MontoCredito,		C.MontoComApert
		INTO
			Var_ValorCAT,			Var_TasaFija,			Var_FactorMora,	Var_ProductoCreditoID,	Var_MontoSeguroVida,
			Var_SeguroVidaPagado,	Var_MontoComApProd,		Var_TipoComXapert,	Var_MontoCredito,	Var_MontoComApert
		FROM CREDITOS C INNER JOIN PRODUCTOSCREDITO P ON C.ProductoCreditoID=P.ProducCreditoID
			WHERE C.CreditoID = Par_CreditoID;

		SET Var_SaldoInsoluto	:= IFNULL(Var_MontoCredito, Entero_Cero);
		-- Var_SaldoInsoluto representa el porcentaje de comisión por apertura/admon
		SET Var_SaldoInsoluto	:= (Var_MontoComApert * 100)/Var_SaldoInsoluto;

		-- SE OBTIENE LA INFORMACIÓN DE LAS GARANTÍAS
		SELECT PorcentajeApli
		INTO Var_PorcentajeFEGA
		FROM BITACORAAPLIGAR
			WHERE CreditoID = Par_CreditoID;

		SET Var_PorcentajeFEGA := IFNULL(Var_PorcentajeFEGA, Entero_Cero);

		SELECT
			CONVERT(CONCAT(IF(Var_SubClasifID=TipoHabilitacionAvio,'PARA CRÉDITOS DE ','PARA CRÉDITOS '),Var_TipoSubClasif,',  Intereses ordinarios sobre saldo insoluto a una ',IF(Var_CalcInteresID = TasaFija, CONVERT(CONCAT('tasa de ', CONVPORCANT(Var_TasaFija,'%A','4' ,'ANUAL'),'.') USING utf8), CONCAT('TASA VARIABLE que se calculará a razón de la Tasa de Interés Interbancaria de Equilibrio (T.I.I.E.) mas ',ROUND(Var_TasaBase,2),' Puntos; la tasa pactada se revisará y ajustará mensualmente conforme a las variaciones de T.I.I.E..'))) USING utf8) AS IncisoA,
			CONCAT('3.- COMISIÓN POR APERTURA DE “EL CRÉDITO”.- "EL ACREDITADO”   se obliga a pagar a "LA ACREDITANTE"  , por única vez mientras dure la vigencia de este crédito equivalente al ',CONVPORCANT(Var_SaldoInsoluto,'%C','2' ,')'),' del monto de crédito. Para obtener el monto de la comisión a pagar debe multiplicarse el crédito otorgado señalado en la cláusula segunda de este contrato por el ',ROUND(Var_SaldoInsoluto,2),'% equivalente a ',CONVPORCANT(Var_MontoComApert,'$C','2' ,'')) AS Punto3,
			CONCAT('.                                                   El costo de prima anual será de ',CONVPORCANT(Var_MontoSeguroVida,'%C','2' ,')'),' para una suma asegurada de ',CONVPORCANT(Var_SeguroVidaPagado,'%C','2' ,')'),' Los detalles del aseguramiento se establecerán en la póliza correspondiente.') AS Punto4,
			CONCAT('.                                                                                                                                                                                           ',CONVPORCANT(Var_ValorCAT,'%A','2' ,'ANUAL'),' a Tasa Fija y  para fines informativos y de comparación exclusivamente.') AS Punto5,
			CONVERT(CONCAT(CONVPORCANT(1.23,'%A','2' ,'ANUAL'),' para créditos de ', IF(Var_SubClasifID = TipoHabilitacionAvio, UPPER('HABILITACIÓN O AVÍO'), LOWER('HABILITACIÓN O AVÍO')), ' y el ',CONVPORCANT(1.23,'%A','2' ,'ANUAL'),' para créditos ', IF(Var_SubClasifID = TipoHabilitacionAvio, LOWER('REFACCIONARIOS'), UPPER('REFACCIONARIOS')), ' multiplicados por el monto del crédito.') USING utf8) AS Punto7,
			Var_SubClasifID AS SubClasifID
			;

	END IF;

	-- TIPO DE REPORTE QUE MUESTRA LAS AMORTIZACIONES DE UN CRÉDITO con el plazo del credito
	IF(IFNULL(Par_TipoReporte,Entero_Cero)=TipoAmortizacionesSexta)THEN

		-- DATOS DEL CREDITO.
		SELECT
			C.PlazoID
		INTO
			Var_PlazoID
		FROM CREDITOS C
			WHERE C.CreditoID = Par_CreditoID;

		SELECT ROUND(Dias/30),	Descripcion
		INTO Var_PlazoMeses,	Var_PlazoDescripcion
		FROM CREDITOSPLAZOS
			WHERE PlazoID = Var_PlazoID;

		SELECT AmortizacionID, FNFECHACOMPLETA(FechaExigible,3) AS Fecha, CONVPORCANT(Capital,'$C','2' ,'') AS Monto,
			CONCAT('SEXTA.- PLAZO Y FORMA DE PAGO.- “EL ACREDITADO”   sin necesidad de previo requerimiento, se obliga a pagar a “LA ACREDITANTE” el importe del Crédito dispuesto, los intereses estipulados y las demás sumas que resulten a su cargo derivadas del presente contrato, en un plazo de ',Var_PlazoMeses,' (',TRIM(FUNCIONSOLONUMLETRAS(Var_PlazoMeses)),') meses, de acuerdo al siguiente calendario de amortizaciones.') AS Sexta
			FROM AMORTICREDITOAGRO
		WHERE CreditoID = Par_CreditoID;
	END IF;

	-- TIPO DE REPORTE PARA LAS GARANTIAS
	IF(IFNULL(Par_TipoReporte,Entero_Cero)=TipoDecimaPrimera)THEN
		-- Garantías Mobiliarias
		SELECT
			GROUP_CONCAT(UPPER(CONCAT(G.GarantiaID, ': ',G.Observaciones)) SEPARATOR ', ')
		INTO
			Var_ObservGarantiaP
			FROM TMPGARANTESAGRO G
			WHERE G.CreditoID = Par_CreditoID AND G.TipoGarantiaID = TipoGarantiaPrend;

		-- Se obtienen los nombres de los garantes Mobiliarios
		SELECT
			GROUP_CONCAT(DISTINCT G.NombreCompleto SEPARATOR ', ')
		INTO
			Var_NomGarantesP
			FROM TMPGARANTESAGRO G
			WHERE G.CreditoID = Par_CreditoID AND G.TipoGarantiaID = TipoGarantiaPrend;

		-- Garantías Hipotecarias
		SELECT
			GROUP_CONCAT(UPPER(CONCAT(G.GarantiaID, ': ',G.Observaciones)) SEPARATOR ', ')
		INTO
			Var_ObservGarantiaH
			FROM TMPGARANTESAGRO G
			WHERE G.CreditoID = Par_CreditoID AND G.TipoGarantiaID = TipoGarantiaHipo;

		-- Se obtienen los nombres de los garantes Hipotecarios
		SELECT
			GROUP_CONCAT(DISTINCT G.NombreCompleto SEPARATOR ', ')
		INTO
			Var_NomGarantesH
			FROM TMPGARANTESAGRO G
			WHERE G.CreditoID = Par_CreditoID AND G.TipoGarantiaID = TipoGarantiaHipo;

		SET Var_ObservGarantiaP	:= IFNULL(Var_ObservGarantiaP, Cadena_Vacia);
		SET Var_NomGarantesP	:= IFNULL(Var_NomGarantesP, Cadena_Vacia);
		SET Var_ObservGarantiaH	:= IFNULL(Var_ObservGarantiaH, Cadena_Vacia);
		SET Var_NomGarantesH	:= IFNULL(Var_NomGarantesH, Cadena_Vacia);

		SELECT
			Var_ObservGarantiaP AS ObservGarantiaP,
			CONCAT('Garantía Prendaría.   A efecto de garantizar el fiel cumplimiento de todas y cada una de las obligaciones que a su cargo se derivan del presente Contrato y de los “Pagares”, y especialmente para garantizar el pago del Crédito, su suma principal, intereses ordinarios y moratorios, en su caso, comisiones, costos, gastos y todas y cada una de las demás cantidades pagaderas por  “EL ACREDITADO”   a   “LA ACREDITANTE”, “EL GARANTE PRENDARIO (S) Y AVAL (ES) U OBLIGADO SOLIDARIO”    , con el consentimiento (en su caso) de su (s) cónyuge(s), el (los) señor (es): ',Var_NomGarantesP,' constituye(n) a favor de “LA ACREDITANTE”   un gravamen en primer lugar sobre el(los) bien(es) mueble(s) descritos a continuación:') AS IncisoB,
			Var_ObservGarantiaH AS ObservGarantiaH,
			CONCAT('Garantía Hipotecaria.   En garantía del cumplimiento de todas y cada una de las obligaciones derivadas de este contrato, de los “Pagares” y de la Ley o de resoluciones judiciales dictadas a favor de   “LA ACREDITANTE”   y a cargo de   “EL ACREDITADO”  ,  especialmente el  pago de   “EL CRÉDITO”  , su suma principal, intereses ordinarios y moratorios, comisiones, gastos y demás accesorios, así como los gastos y costas en caso de  juicio, el (los)   “GARANTE (S) HIPOTECARIO (S) Y AVAL (ES) U OBLIGADO SOLIDARIO”  , con el consentimiento (en su caso) de su(s) cónyuge(s), el (los) señor (es): ',Var_NomGarantesH,' constituye(n) a favor de “LA ACREDITANTE”, HIPOTECA EXPRESA EN PRIMER  LUGAR  Y GRADO sobre el(los) inmueble(s) cuyas características quedan descritas en el párrafo siguiente:') AS IncisoC
			;

	END IF;

	-- TIPO DE REPORTE PARA LAS GARANTIAS SEGUNDA HOJA
	IF(IFNULL(Par_TipoReporte,Entero_Cero)=TipoDecimaPrimera2da)THEN
		-- Garantías gubernamentales
		SELECT
			GROUP_CONCAT(UPPER(CONCAT(G.GarantiaID, ': ',G.Observaciones)) SEPARATOR ', ')
		INTO
			Var_ObservGarantiaG
			FROM TMPGARANTESAGRO G
			WHERE G.CreditoID = Par_CreditoID AND G.TipoGarantiaID = TipoGarantiaGuber;

		-- Se obtienen los nombres de los garantes gubernamentales
		SELECT
			GROUP_CONCAT(DISTINCT G.NombreCompleto SEPARATOR ', ')
		INTO
			Var_NomGarantesG
			FROM TMPGARANTESAGRO G
			WHERE G.CreditoID = Par_CreditoID AND G.TipoGarantiaID = TipoGarantiaGuber;

		SELECT
			C.ProductoCreditoID
		INTO
			Var_ProductoCreditoID
		FROM CREDITOS C INNER JOIN PRODUCTOSCREDITO P ON C.ProductoCreditoID=P.ProducCreditoID
			WHERE C.CreditoID = Par_CreditoID;

		-- Garantía Líquida: validacion para la Garantia Liquida
		SET Var_RequiereGL		:= (SELECT IFNULL(Garantizado,Cons_No) FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Var_ProductoCreditoID);

		# si el producto de credito no requiere GL, guardara ceros
		IF(Var_RequiereGL = Cons_No)THEN
			SET	Var_PorcGarLiq		:= Decimal_Cero;
			SET Var_AportaCliente	:= Decimal_Cero;
		ELSE
			SET Var_CalificaCredito	:=(SELECT IFNULL(CalificaCredito,Cons_No) FROM CLIENTES WHERE ClienteID = Var_ClienteID);
			SELECT Porcentaje
			INTO Var_PorcGarLiq
				FROM ESQUEMAGARANTIALIQ
				WHERE Clasificacion = Var_CalificaCredito
					AND ProducCreditoID = Var_ProductoCreditoID
					AND Var_MontoCredito BETWEEN LimiteInferior AND LimiteSuperior
				LIMIT 1;

			SET Var_AportaCliente	:= ROUND((Var_MontoCredito * Var_PorcGarLiq) / 100,2);

		END IF;

		-- Nombre de todos los garantes
		SELECT
			GROUP_CONCAT(DISTINCT G.NombreCompleto SEPARATOR ', ')
		INTO
			Var_NombreGarante
			FROM TMPGARANTESAGRO G
			WHERE G.CreditoID = Par_CreditoID;

		SET Var_NombreGarante	:= IFNULL(Var_NombreGarante, Cadena_Vacia);
		SET Var_ObservGarantiaG	:= IFNULL(Var_ObservGarantiaG, Cadena_Vacia);
		SET Var_NomGarantesG	:= IFNULL(Var_NomGarantesG, Cadena_Vacia);

		SELECT
			Var_ObservGarantiaG AS ObservGarantiaG,
			Var_NomGarantesG AS NomGarantesG,
			CONCAT('Garantía Liquida: "EL ACREDITADO"  aporta en garantía liquida un monto de dinero equivalente a ',CONVPORCANT(Var_AportaCliente,'$C','2' ,''),' el cual corresponde al ',CONVPORCANT(Var_PorcGarLiq,'%C','2' ,')'),' del importe del crédito. ') AS IncisoE,
			CONCAT('DECIMA SEGUNDA.- DEPOSITARIO.-   Designan las partes como Depositario de los bienes pignorados al propio “GARANTE HIPOTECARIO”, "GARANTE USUFRUCTUARIO" Y “GARANTE PRENDARIO” por conducto de, ',Var_NombreGarante,' Constituyéndose el depósito en los domicilios señalados en sus generales quienes en este acto aceptan el cargo de Depositario y protestan su fiel y legal desempeño.') AS Decima2da;
	END IF;

	-- TIPO DE REPORTE SECCION VIGESIMA CUARTA
	IF(IFNULL(Par_TipoReporte,Entero_Cero)=TipoVigesima4ta)THEN
		-- Nombre de todos los garantes y avales
		SELECT
			GROUP_CONCAT(DISTINCT G.NombreCompleto SEPARATOR ', ')
		INTO
			Var_NombreGarante
			FROM TMPGENERALESAGRO G
			WHERE G.CreditoID = Par_CreditoID
				AND G.ConsecutivoID != Entero_Cero;

		SET Var_NombreGarante	:= IFNULL(Var_NombreGarante, Cadena_Vacia);

		SELECT
			Var_NombreCliente AS NombreCliente,
			CONCAT('SOLIDARIO".- ',Var_NombreGarante,'.') AS NombreGarante,
			CONCAT(Var_NombreGarante,'.') AS NombreGaranteAval;
	END IF;

	-- TIPO DE REPORTE SECCION TRIGESIMA TERCERA
	IF(IFNULL(Par_TipoReporte,Entero_Cero)=TipoTrigesima3era)THEN
		SET Var_DireccionesGarAva := (SELECT GROUP_CONCAT(DISTINCT DireccionCompleta SEPARATOR ' | ')
											FROM TMPGENERALESAGRO WHERE CreditoID=Par_CreditoID AND ConsecutivoID != Entero_Cero ORDER BY ConsecutivoID);

		SELECT
			CONCAT('"EL ACREDITADO”:   ',Var_Direccion) AS DireccionCliente,
			CONCAT(Var_DireccionesGarAva) AS DireccionesGA,
			CONCAT(Var_DirRepLegal) AS DirPresidente,
			CONCAT(Cadena_Vacia) AS DirSecretario,
			CONCAT(Cadena_Vacia) AS DirTesorero,
			CONCAT('En el domicilio señalado por  "LA ACREDITANTE"   se encuentra la Unidad Especializada de Atención a Usuarios, mediante  la  cual  “EL ACREDITADO”  , podrá solicitar aclaraciones, consultas de saldo, movimientos, entre otros. El teléfono y correo electrónico de dicha Unidad es ',Var_CorreoUnidadEsp,' con domicilio en Juárez Norte no. 06, Colonia Centro, Tlajomulco de Zúñiga, Jal. C.P. 45640; teléfono 01 33 379 820 00, o') AS DomicilioAcreditante,
			CONCAT('lo podrá hacer directamente en cualquier sucursal de  “LA ACREDITANTE”   que exista en la República Mexicana.') AS DomicilioAcreditante2
			;
	END IF;

	-- TIPO DE REPORTE SECCION GENERALES
	IF(IFNULL(Par_TipoReporte,Entero_Cero)=TipoSeccionGrales)THEN
		DELETE FROM TMPGRALESAGRO2 WHERE CreditoID = Par_CreditoID;

		INSERT INTO TMPGRALESAGRO2(
			NombreCompleto,			CreditoID
		)
		SELECT
			DISTINCT NombreCompleto, CreditoID
		FROM TMPGENERALESAGRO
			WHERE CreditoID=Par_CreditoID;

 		UPDATE TMPGRALESAGRO2 T1
			INNER JOIN TMPGENERALESAGRO T2 ON (T1.CreditoID=T2.CreditoID AND T1.NombreCompleto=T2.NombreCompleto)
		SET
			T1.ConsecutivoID = IFNULL(T2.ConsecutivoID,1),
			T1.RolID = IFNULL(T2.RolID,0),
	        T1.RFC = IFNULL(T2.RFC, Cadena_Vacia),
	        T1.DireccionCompleta = IFNULL(T2.DireccionCompleta, Cadena_Vacia),
	        T1.IFE = IFNULL(T2.IFE, Cadena_Vacia)
			WHERE T1.CreditoID=Par_CreditoID;

		-- Los que son avales y garantes
 		UPDATE TMPGRALESAGRO2 T1
			INNER JOIN TMPAVALESAGRO TA ON (T1.CreditoID=TA.CreditoID AND T1.NombreCompleto=TA.NombreCompleto)
			INNER JOIN TMPGARANTESAGRO TG ON (T1.CreditoID=TG.CreditoID AND T1.NombreCompleto=TG.NombreCompleto)
		SET
			T1.RolID = 3
			WHERE T1.CreditoID=Par_CreditoID;

		SELECT T1.NombreCompleto,	T1.RFC, T1.DireccionCompleta,	T1.IFE,
			CONCAT('Los que suscriben el presente contrato manifiesta ser: PAULINO ALEJANDRO LEYVA HERNANDEZ declara por sus generales ser mexicano por nacimiento, nació el 24 de Abril del 1991 con domicilio en calle Licurgo n° 415, col. Lagos de Oriente, CP.44770, Guadalajara, Jalisco. Quien se identifica con credencial de elector folio LYHRPL91042414H000.') AS DatosRepLegal
			FROM TMPGRALESAGRO2 T1
			WHERE T1.CreditoID=Par_CreditoID
				ORDER BY T1.ConsecutivoID;
	END IF;

	-- TIPO DE REPORTE SECCION GENERALES FIRMAS
	IF(IFNULL(Par_TipoReporte,Entero_Cero)=TipoSeccionGralesFirmas)THEN
		IF(Var_FechaAutoriza != Fecha_Vacia)THEN
			SELECT CONCAT(FNFECHACOMPLETA(Var_FechaAutoriza,6), '.') AS FechaSistema;
		ELSE
			SELECT CONCAT(FNFECHACOMPLETA(Var_FechaSis,6), '.') AS FechaSistema;
		END IF;
	END IF;

	-- TIPO DE REPORTE SECCION GENERALES FIRMAS DE LOS GARANTES
	IF(IFNULL(Par_TipoReporte,Entero_Cero)=TipoSeccionFirmasGar)THEN
		SELECT
			NombreCompleto, DireccionCompleta
		FROM TMPGRALESAGRO2
			WHERE CreditoID = Par_CreditoID
				AND RolID IN (1,3);
	END IF;

	-- TIPO DE REPORTE SECCION GENERALES FIRMAS DE LOS AVALES
	IF(IFNULL(Par_TipoReporte,Entero_Cero)=TipoSeccionFirmasAval)THEN
		SELECT
			NombreCompleto, DireccionCompleta
		FROM TMPGRALESAGRO2
			WHERE CreditoID = Par_CreditoID
				AND RolID IN (2,3);
	END IF;

	-- TIPO DE REPORTE SECCION GENERALES FIRMAS DE LOS TESTIGOS
	IF(IFNULL(Par_TipoReporte,Entero_Cero)=TipoSeccionFirmasTest)THEN
		SELECT
			NombreCompleto, DireccionCompleta
		FROM TESTIGOS
			ORDER BY TestigoID;
	END IF;

	-- TIPO DE REPORTE ANEXO 1
	IF(IFNULL(Par_TipoReporte,Entero_Cero)=TipoSeccionAnexo1)THEN
		SELECT
			CONVPORCANT(Var_MontoCredito,'$C','2' ,'') AS MontoCredito,
			CONCAT(Var_NombreCliente,' REPRESENTADA EN ESTE ACTO POR LOS SEÑORES ',Var_NombreRepLegal,', ____________________ Y ____________________ EN SU CARÁCTER DE PRESIDENTE, SECRETARIO Y  TESORERO, RESPECTIVAMENTE DEL CONSEJO DE ADMINISTRACIÓN.') AS NombreMoral,
			CONCAT(FNFECHACOMPLETA(Var_FechaAutoriza,6), '') AS FechaSistema;
	END IF;

	-- TIPO DE REPORTE ANEXO 1 ADMINISTRADOR UNICO MORAL
	IF(IFNULL(Par_TipoReporte,Entero_Cero)=TipoSeccionAnexoAdUnico)THEN
		SELECT
			CONVPORCANT(Var_MontoCredito,'$C','2' ,'') AS MontoCredito,
			CONCAT(Var_NombreCliente,' REPRESENTADA EN ESTE ACTO POR EL SEÑOR ',Var_NombreRepLegal,', EN SU CARÁCTER DE ADMINISTRADOR ÚNICO.') AS NombreMoral,
			CONCAT(FNFECHACOMPLETA(Var_FechaAutoriza,6), '') AS FechaSistema;
	END IF;

END TerminaStore$$