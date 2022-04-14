-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONSOLIDACIONCARTALIQCON
DELIMITER ;
DROP PROCEDURE IF EXISTS CONSOLIDACIONCARTALIQCON;
DELIMITER $$

CREATE PROCEDURE CONSOLIDACIONCARTALIQCON(
/* SP PARA CONSULTAR LAS INSTRUCCIONES DE DISPERSION */
	Par_ConsolidaCartaID	INT(11),			-- Parametro Identificador de la Consolidacion
	Par_SolicitudCreditoID	INT(11),			-- Parametro Identificador de la Solicitud de Credito
	Par_NumCon				TINYINT UNSIGNED,	-- Numero de Consulta

	-- Parametros de Auditoria
	Aud_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Fecha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)
TerminaStore:BEGIN

	-- Declaracion de variables
	DECLARE Con_Consolidacion INT(11);
	DECLARE Con_Solicitud INT(11);

	-- Inicialización de variables
	SET Con_Consolidacion	:= 1;	-- Consulta una consolidación
	SET Con_Solicitud		:= 3;	-- Consulta por solicitud

	IF(Par_NumCon = Con_Consolidacion)THEN

		SELECT
				Cons.ConsolidaCartaID,		Cli.ClienteID,		Cli.NombreCompleto,		Cons.SolicitudCreditoID,	Cons.EsConsolidado,
				Cons.TipoCredito,			Cons.Relacionado,	Cons.MontoConsolida
		  FROM CONSOLIDACIONCARTALIQ Cons
		 INNER JOIN CLIENTES Cli ON Cons.ClienteID = Cli.ClienteID
		 WHERE Cons.ConsolidaCartaID = Par_ConsolidaCartaID;

	END IF;

	IF(Par_NumCon = Con_Solicitud)THEN

		SELECT
				Cons.ConsolidaCartaID,		Cli.ClienteID,		Cli.NombreCompleto,		Cons.SolicitudCreditoID,	Cons.EsConsolidado,
				Cons.TipoCredito,			Cons.Relacionado,	Cons.MontoConsolida
		  FROM CONSOLIDACIONCARTALIQ Cons
		 INNER JOIN CLIENTES Cli ON Cons.ClienteID = Cli.ClienteID
		 WHERE Cons.SolicitudCreditoID = Par_SolicitudCreditoID;

	END IF;

END TerminaStore$$