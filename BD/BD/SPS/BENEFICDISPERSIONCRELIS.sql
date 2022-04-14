-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BENEFICDISPERSIONCRELIS
DELIMITER ;
DROP PROCEDURE IF EXISTS BENEFICDISPERSIONCRELIS;

DELIMITER $$
CREATE PROCEDURE BENEFICDISPERSIONCRELIS(
# =============================================================================================================
# ----------------------------------- LISTA DE DISPERSIONES POR SOLICITUD-----------------------------------------
# =============================================================================================================
	Par_SolicitudCreditoID		BIGINT(20),			-- Numero de Cliente
	Par_Beneficiario			VARCHAR(50),		-- Nombre Benericiario
	Par_NumLis					TINYINT UNSIGNED,	-- Numero de Lista

	-- Parametros de Auditoria
	Aud_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT
	)
TerminaStore: BEGIN


	-- Declaracion de constantes
	DECLARE	Cadena_Vacia			CHAR(1);		-- Constante cadena vacia
	DECLARE	Entero_Cero				INT;			-- Constante entero cero
	DECLARE Decimal_Cero			DECIMAL(12,2);	-- Constante decimal cero
	DECLARE	Lis_Principal			INT;			-- Constante para la consulta principal
	DECLARE Lis_Nombre				INT;			-- Constante para la consulta por nombre
	DECLARE Lis_Nuevo				INT;			-- Constante para la consulta cartas de liquidación INTERNAS Y EXTERNAS
	DECLARE Con_Str_SI				CHAR(1);		-- Constante para SI
	DECLARE	Con_Str_NO				CHAR(1);		-- Constante para NO
	DECLARE Con_ModExternas			INT;			-- Constante Modifica Internas
	DECLARE Con_ModInternas			INT;			-- Constante Modifica Internas
	DECLARE Con_CartaInter			CHAR(1);		-- Tipo Carta Internas
	DECLARE Var_Beneficiario		VARCHAR(250);	-- Variable de Beneficiario
	DECLARE Var_NoAplica			VARCHAR(10);	-- Constante No Aplica

	-- Asignacion de constantes
	SET	Cadena_Vacia		:= '';				-- Constante cadena vacia
	SET	Entero_Cero			:= 0;				-- Constante entero cero
	SET	Lis_Principal		:= 1;				-- Constante para la consulta principal
	SET Lis_Nombre			:= 2;				-- Constante para la consulta por nombre
	SET Lis_Nuevo			:= 0;				-- Constante para la consulta cartas de liquidación INTERNAS Y EXTERNAS

	SET	Con_Str_SI			:= 'S';				-- Constante para SI
	SET	Con_Str_NO			:= 'N';				-- Constante para NO
	SET Con_ModExternas		:= 2;				-- Constante Modifica Internas
	SET Con_ModInternas		:= 3;				-- Constante Modifica Externas
	SET Con_CartaInter		:= 'I';				-- Tipo Carta Internas
	SET Var_NoAplica		:= 'N';		-- Constante No Aplica



	SET Var_Beneficiario = (SELECT NombreCompleto FROM CLIENTES WHERE ClienteID = 1);

	IF(Par_NumLis = Lis_Principal) THEN

		IF EXISTS (	SELECT SolicitudCreditoID
					  FROM BENEFICDISPERSIONCRE
					 WHERE SolicitudCreditoID = Par_SolicitudCreditoID) THEN

		-- 1.-  Lista principal de dispersiones por solicitudes de credito
			SELECT	SolicitudCreditoID, TipoDispersionID, Beneficiario, Cuenta, MontoDispersion,
					PermiteModificar,	Entero_Cero	 AS Consecutivo
			  FROM BENEFICDISPERSIONCRE
			 WHERE SolicitudCreditoID = Par_SolicitudCreditoID;

		ELSE

			SELECT	CONS.SolicitudCreditoID,
					CAS.TipoDispersionCasa		AS TipoDispersion,
					CAS.NombreCasaCom			AS Beneficiario,
					CAS.CuentaCLABE				AS Cuenta,
					ASI.Monto					AS MontoDispersion,
					Con_ModExternas AS PermiteModificar,
					ASI.AsignacionCartaID 		AS Consecutivo
			  FROM CONSOLIDACIONCARTALIQ		AS CONS
			 INNER JOIN ASIGCARTASLIQUIDACION	AS ASI ON CONS.SOLICITUDCREDITOID	= ASI.SOLICITUDCREDITOID
			 INNER JOIN CASASCOMERCIALES		AS CAS ON ASI.CasaComercialID		= CAS.CasaComercialID
			 WHERE ASI.SolicitudCreditoID 		= Par_SolicitudCreditoID


			UNION

			SELECT	LIQ.SolicitudCreditoID,
					Var_NoAplica			AS TipoDispersion,
					Var_Beneficiario		AS Beneficiario,
					Cadena_Vacia			AS Cuenta,
					CDET.MontoLiquidar		AS MontoDispersion,
					Con_ModInternas			AS PermiteModificar,
					Entero_Cero	     		AS Consecutivo
			 FROM CONSOLIDACIONCARTALIQ			AS LIQ
			INNER JOIN CONSOLIDACARTALIQDET		AS LDET	ON LIQ.ConsolidaCartaID	= LDET.ConsolidaCartaID AND LDET.TIPOCARTA = Con_CartaInter
			INNER JOIN CARTALIQUIDACION			AS Cliq	ON LDET.CartaLiquidaID	= Cliq.CartaLiquidaID
			INNER JOIN CARTALIQUIDACIONDET		AS CDET ON Cliq.CartaLiquidaID	= CDET.CartaLiquidaID
			WHERE	LIQ.SolicitudCreditoID	= Par_SolicitudCreditoID;

		END IF;
	END IF;

	-- 2.-  Lista principal de dispersiones por nombre del Beneficiario
	IF(Par_NumLis = Lis_Nombre) THEN

		SELECT	SolicitudCreditoID, TipoDispersionID, Beneficiario, Cuenta, MontoDispersion,
				PermiteModificar
		  FROM BENEFICDISPERSIONCRE
		 WHERE Beneficiario LIKE CONCAT("%",Par_Beneficiario,"%");

	END IF;



END TerminaStore$$