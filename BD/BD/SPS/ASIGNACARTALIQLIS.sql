-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ASIGNACARTALIQLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS ASIGNACARTALIQLIS;

DELIMITER $$
CREATE PROCEDURE ASIGNACARTALIQLIS(
-- ========================================================================
-- ------------- PROCEDIMIENTO DE LISTAS DE ASIGNACION DE CARTAS ----------
-- ========================================================================

	Par_ConsolidaCartaID		INT(11),		-- Folio de consolidación de cartas de liquidacióm
	Par_SolicitudCreditoID		INT(11), 		-- ID de Solicitud de Credito1
	Par_TipoLista				TINYINT,		-- TIPO DE LISTA: 1 lista Principal

	Par_EmpresaID				INT(11),		-- Parametros de Auditoria
	Aud_Usuario					INT(11),		-- Parametros de Auditoria
	Aud_FechaActual				DATETIME,		-- Parametros de Auditoria
	Aud_DireccionIP				VARCHAR(15),	-- Parametros de Auditoria
	Aud_ProgramaID				VARCHAR(50),	-- Parametros de Auditoria
	Aud_Sucursal				INT(11),		-- Parametros de Auditoria
	Aud_NumTransaccion			BIGINT(20)		-- Parametros de Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia	VARCHAR(1);		-- Constante cadena vacia
	DECLARE	Fecha_Vacia		DATE;			-- Constaante fecha vacia
	DECLARE	Entero_Cero		INT(11);		-- Constante entero cero
	DECLARE	SalidaSI		CHAR(1);		-- Constante SI
	DECLARE	SalidaNO		CHAR(1);		-- Constante NO
	DECLARE	ListaPrinExt	INT(11);		-- lista Principal de cartas Externas cuando ya existe solicitud de crédito
	DECLARE	ListaPrinInt	INT(11);		-- lista Principal de cartas Internas cuando ya existe solicitud de crédito
	DECLARE ListaExterna	INT(11);		-- Lista para cartas externas cuando no hay solicitud de crédito
	DECLARE ListaInterna	INT(11);		-- Lista para cartas internas cuando no hay solicitud de crédito
	DECLARE ListaDocInt		INT(11);		-- Lista para cartas externas que se actualizarán con el ID del expediente
	DECLARE Con_TipoCarta	CHAR(1);		-- Tipo Carta I.- Interna, E.- Externa
	DECLARE Con_EstatusA	CHAR(1);		-- Estatus de la carta de liquidación
	DECLARE Var_CartaLiq	INT(11);		-- Tipo de documento 996.- Carta Liquidación
	DECLARE Var_Pagare		INT(11);		-- Tipo de documento 997.- Pagaré
	DECLARE Con_TipoExt		CHAR(1);		-- Tipo carta E.- Externa
	DECLARE Var_IDCartaE	CHAR(1);
	DECLARE Var_IDCartaN	CHAR(1);

	-- Asignacion de Constantes
	SET Cadena_Vacia		:= '';				-- Cadena vacia
	SET Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia
	SET Entero_Cero			:= 0;				-- Entero Cero
	SET	SalidaSI			:= 'S';				-- Salida Si
	SET	SalidaNO			:= 'N'; 			-- Salida No
	SET	ListaPrinExt		:= 1;				-- lista Principal de cartas Externas cuando ya existe solicitud de crédito
	SET ListaPrinInt		:= 2;				-- lista Principal de cartas Internas cuando ya existe solicitud de crédito
	SET ListaExterna		:= 3;				-- Lista para cartas externas cuando no hay solicitud de crédito
	SET ListaInterna		:= 4;				-- Lista para cartas internas cuando no hay solicitud de crédito
	SET ListaDocInt			:= 5;				-- Lista para cartas externas que se actualizarán con el ID del expediente
	SET Con_TipoCarta		:= 'I';				-- Tipo carta I.- Interna
	SET Con_TipoExt			:= 'E';				-- Tipo carta E.- Externa
	SET Con_EstatusA		:= 'A';				-- Estatus de la carta de liquidación A.- Activa
	SET Var_CartaLiq		:= 9996;				-- Tipo de documento 996.- Carta Liquidación
	SET Var_Pagare			:= 9997;				-- Tipo de documento 997.- Pagaré
	SET Var_IDCartaE		:= 'E';
	SET Var_IDCartaN		:= 'N';

	IF(Par_TipoLista = ListaPrinExt) THEN

		DROP TABLE IF EXISTS TMPASIGCARTAS;
		CREATE TABLE TMPASIGCARTAS(
			id INT NOT NULL AUTO_INCREMENT,
			AsignacionCartaID bigint(11),
			CasaComercialID bigint(11),
			NombreCasaCom VARCHAR(200),
			Monto decimal(18,2),
			MontoDispersion decimal(18,2),
			FechaVigencia date,
			Estatus char(1),
			NombreCartaLiq VARCHAR(200),
			RecursoCarta VARCHAR(200),
			ExtensionCarta VARCHAR(200),
			ComentarioCarta VARCHAR(200),
			ArchivoIDCarta INT(11),
			NombreComproPago VARCHAR(200),
			RecursoPago VARCHAR(200),
			ExtensionPago VARCHAR(200),
			ComentarioPago VARCHAR(200) ,
			ArchivoIDPago  INT(11),
			PRIMARY KEY ( id )
			);

		INSERT INTO TMPASIGCARTAS(
						AsignacionCartaID,		CasaComercialID,	NombreCasaCom,		Monto,		MontoDispersion,
						FechaVigencia,			Estatus,			ArchivoIDCarta,		ArchivoIDPago)

		SELECT	ASI.AsignacionCartaID,		ASI.CasaComercialID,	CAS.NombreCasaCom,		ASI.Monto, 			ASI.MontoDispersion,
				ASI.FechaVigencia,			ASI.Estatus,			ASI.ArchivoIDCarta,		ASI.ArchivoIDPago
		  FROM ASIGCARTASLIQUIDACION ASI
		 INNER JOIN CASASCOMERCIALES CAS ON ASI.CasaComercialID = CAS.CasaComercialID
		 WHERE ASI.SolicitudCreditoID = Par_SolicitudCreditoID
		 ORDER BY ASI.AsignacionCartaID ASC;

		UPDATE TMPASIGCARTAS TMP
		 INNER JOIN SOLICITUDARCHIVOS SOL ON TMP.ArchivoIDCarta = SOL.DigSolID
		   SET	TMP.NombreCartaLiq		= FNVALORARCHIVOS(TMP.ArchivoIDCarta,Var_IDCartaN),
				TMP.RecursoCarta		= SOL.Recurso,
				TMP.ExtensionCarta		= FNVALORARCHIVOS(TMP.ArchivoIDCarta,Var_IDCartaE),
				TMP.ComentarioCarta		= SOL.Comentario
		 WHERE	SOL.TipoDocumentoID		= Var_CartaLiq;


		UPDATE TMPASIGCARTAS TMP
		 INNER JOIN SOLICITUDARCHIVOS SOL ON  TMP.ArchivoIDPago = SOL.DigSolID
		   SET TMP.NombreComproPago	= FNVALORARCHIVOS(TMP.ArchivoIDPago,Var_IDCartaN),
			TMP.RecursoPago			= SOL.Recurso,
			TMP.ExtensionPago		= FNVALORARCHIVOS(TMP.ArchivoIDPago,Var_IDCartaE),
			TMP.ComentarioPago		= SOL.Comentario
		WHERE  SOL.TipoDocumentoID	= Var_Pagare;

		SELECT	id,					AsignacionCartaID,		CasaComercialID,		NombreCasaCom,			Monto,
				MontoDispersion,	FechaVigencia,			Estatus,				NombreCartaLiq,			RecursoCarta,
				ExtensionCarta,		ComentarioCarta,		ArchivoIDCarta,			NombreComproPago,		RecursoPago,
				ExtensionPago,		ComentarioPago,			ArchivoIDPago
		 FROM TMPASIGCARTAS;
	END IF;

	IF(Par_TipoLista = ListaPrinInt) THEN

		SELECT	CONS.ConsolidaCartaID,	DET.CartaLiquidaID,	CLIQ.CreditoID,	CLIQ.FechaVencimiento,	CDET.MontoLiquidar AS MontoCredito,
				ARCH.Recurso AS RecursoCartaLiq
		  FROM CONSOLIDACIONCARTALIQ		AS CONS
		 INNER JOIN CONSOLIDACARTALIQDET	AS DET		ON CONS.ConsolidaCartaID	= DET.ConsolidaCartaID	AND DET.TipoCarta	= Con_TipoCarta
		 INNER JOIN CARTALIQUIDACION		AS CLIQ		ON DET.CartaLiquidaID		= CLIQ.CartaLiquidaID	AND CLIQ.Estatus	= Con_EstatusA
		 INNER JOIN CARTALIQUIDACIONDET		AS CDET 	ON CLIQ.CartaLiquidaID		= CDET.CartaLiquidaID
		 INNER JOIN CREDITOARCHIVOS			AS ARCH		ON CLIQ.ArchivoIDCarta		= ARCH.DigCreaID
		 WHERE CONS.SolicitudCreditoID = Par_SolicitudCreditoID;

	END IF;

	IF(Par_TipoLista = ListaExterna) THEN

		SELECT	ASI.ConsolidaCartaID,
				ASI.Consecutivo,
				ASI.CasaComercialID,
				CAS.NombreCasaCom,
				ASI.Monto,
				ASI.FechaVigencia,
				IFNULL(ASI.RecursoCarta,Cadena_Vacia) AS RecursoCarta,
				IFNULL(ASI.RecursoPagare,Cadena_Vacia) AS RecursoPagare,
				ASI.ExtencionCarta,
				ASI.ExtencionPagare,
				ASI.ComentarioCarta,
				ASI.ComentarioPagare
		  FROM TMPASIGCARTASLIQUIDA ASI
		 INNER JOIN CASASCOMERCIALES CAS ON ASI.CasaComercialID = CAS.CasaComercialID
		 WHERE ASI.ConsolidaCartaID = Par_ConsolidaCartaID;

	END IF;

	IF(Par_TipoLista = ListaInterna) THEN

			SELECT	LIQ.ConsolidaCartaID,	LDET.CartaLiquidaID,	Cre.CreditoID,	Cliq.FechaVencimiento,	CDET.MontoLiquidar AS MontoCredito,
					LDET.RecursoCartaLiq
			  FROM CONSOLIDACIONCARTALIQ			AS LIQ
			 INNER JOIN TMPCARTASLIQUIDACION		AS LDET	ON LIQ.ConsolidaCartaID	= LDET.ConsolidaCartaID
			 INNER JOIN CARTALIQUIDACION			AS Cliq	ON LDET.CartaLiquidaID	= Cliq.CartaLiquidaID
			 INNER JOIN CARTALIQUIDACIONDET			AS CDET ON Cliq.CartaLiquidaID	= CDET.CartaLiquidaID
			 INNER JOIN CREDITOS					AS Cre	ON Cliq.CreditoID		= Cre.CreditoID
			 WHERE	LIQ.ConsolidaCartaID	= Par_ConsolidaCartaID;

	END IF;


	IF(Par_TipoLista = ListaDocInt) THEN

			DROP TABLE IF EXISTS TMPDET;
			CREATE TABLE TMPDET(Consecutivo INT,
								ConsolidaCartaID INT,
								AsignacionCartaID bigint(11),
								PRIMARY KEY ( Consecutivo ));

			SET @REG := 0;

			INSERT INTO TMPDET(
					Consecutivo,
					ConsolidaCartaID,
					AsignacionCartaID)
			SELECT (@REG := @REG + 1) AS CONSECUTIVO,
					DET.ConsolidaCartaID,
					DET.AsignacionCartaID
			  FROM CONSOLIDACARTALIQDET DET
			 WHERE DET.ConsolidaCartaID = Par_ConsolidaCartaID
			   AND DET.TipoCarta		= Con_TipoExt
			 ORDER BY AsignacionCartaID ;


			SELECT	LIQ.SolicitudCreditoID, ASI.ConsolidaCartaID,	DET.AsignacionCartaID,	ASI.Consecutivo,
					ASI.CasaComercialID,	CAS.NombreCasaCom,		ASI.Monto,				ASI.FechaVigencia,
					ASI.RecursoCarta,		ASI.RecursoPagare,		ASI.ExtencionCarta,		ASI.ExtencionPagare,
					ASI.ComentarioCarta,	ASI.ComentarioPagare
			  FROM TMPASIGCARTASLIQUIDA ASI
			 INNER JOIN CONSOLIDACIONCARTALIQ LIQ ON ASI.ConsolidaCartaID = LIQ.ConsolidaCartaID
			 INNER JOIN TMPDET DET ON ASI.ConsolidaCartaID = DET.ConsolidaCartaID AND ASI.Consecutivo = DET.Consecutivo
			 INNER JOIN CASASCOMERCIALES CAS ON ASI.CasaComercialID = CAS.CasaComercialID
			 WHERE ASI.ConsolidaCartaID = Par_ConsolidaCartaID;

			DROP TABLE IF EXISTS TMPDET;


	END IF;

END TerminaStore$$