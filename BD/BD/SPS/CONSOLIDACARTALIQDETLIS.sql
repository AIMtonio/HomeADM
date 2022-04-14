-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONSOLIDACARTALIQDETLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS CONSOLIDACARTALIQDETLIS;

DELIMITER $$
CREATE PROCEDURE CONSOLIDACARTALIQDETLIS(
# =============================================================================================================
# ----------------------------------- LISTA DE CONSOLIDACIONES-----------------------------------------
# =============================================================================================================
	Par_ConsolidaCartaID		INT(11),			-- Numero de Cliente
	Par_NombreCompleto			VARCHAR(50),		-- Nombre completo del cliente
	Par_CreditoID				BIGINT(12),			-- Número de cŕedito
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
	DECLARE Lis_NoCredito			INT;			-- Consulta cartas de liqudaciòn interna
	DECLARE Lis_NombreCre			INT;			-- Consulta por nombre en cartas internas
	DECLARE Con_Str_SI	   			CHAR(1);		-- Constante para SI
	DECLARE	Con_Str_NO	   			CHAR(1);		-- Constante para NO
	DECLARE Cons_A					CHAR(1);		-- Constante A


	-- Asignacion de constantes
	SET	Cadena_Vacia	:= '';	-- Constante cadena vacia
	SET	Entero_Cero		:= 0;	-- Constante entero cero
	SET	Lis_Principal	:= 1;	-- Constante para la consulta principal
	SET Lis_Nombre		:= 2;	-- Constante para la consulta por nombre
	Set Lis_NoCredito	:= 3;	-- Consulta cartas de liqudaciòn internas
	SET Lis_NombreCre	:= 4;	-- Consulta por nombre en cartas internas


	SET	Con_Str_SI		:= 'S';	-- Constante para SI
	SET	Con_Str_NO		:= 'N';	-- Constante para NO
	SET Cons_A			:= 'A';	-- Constante A



	-- 1.-  Lista principal de dispersiones por solicitudes de credito
		IF(Par_NumLis = Lis_Principal) THEN

			SELECT CONID.ConsolidaCartaID AS FolioConsolidacion,	CLI.NombreCompleto
			  FROM CONSOLIDACIONCARTALIQ AS CONID
			 INNER JOIN CLIENTES AS CLI ON CONID.ClienteID = CLI.ClienteID
			 WHERE CONID.ConsolidaCartaID =  Par_ConsolidaCartaID
			 LIMIT 0, 15;

		END IF;

		IF(Par_NumLis = Lis_Nombre) THEN

			SELECT CONID.ConsolidaCartaID AS FolioConsolidacion,	CLI.NombreCompleto
			  FROM CONSOLIDACIONCARTALIQ AS CONID
			 INNER JOIN CLIENTES AS CLI ON CONID.ClienteID = CLI.ClienteID
			 WHERE CLI.NombreCompleto LIKE CONCAT("%",Par_NombreCompleto,"%")
			 LIMIT 0, 15;

		END IF;

		IF (Par_NumLis = Lis_NoCredito) THEN

			SELECT CLI.NombreCompleto, CRE.CreditoID, CRE.MontoCredito, CLIQ.FechaVencimiento
			  FROM CARTALIQUIDACION CLIQ
			 INNER JOIN CREDITOS CRE ON CLIQ.CreditoID = CRE.CreditoID
			 INNER JOIN CLIENTES CLI ON CLIQ.ClienteID = CLI.ClienteID
			 WHERE CLIQ.Estatus = Cons_A
			   AND CRE.CreditoID = Par_CreditoID
			 LIMIT 0, 15;

		END IF;

		IF (Par_NumLis = Lis_NombreCre) THEN

			SELECT CLI.NombreCompleto, CRE.CreditoID, CRE.MontoCredito, CLIQ.FechaVencimiento
			  FROM CARTALIQUIDACION CLIQ
			 INNER JOIN CREDITOS CRE ON CLIQ.CreditoID = CRE.CreditoID
			 INNER JOIN CLIENTES CLI ON CLIQ.ClienteID = CLI.ClienteID
			 WHERE CLIQ.Estatus = Cons_A
			   AND CLI.NombreCompleto LIKE CONCAT("%",Par_NombreCompleto,"%")
			 LIMIT 0, 15;

		END IF;

END TerminaStore$$