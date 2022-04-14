-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INSTRUCDISPERSIONCRECON
DELIMITER ;
DROP PROCEDURE IF EXISTS INSTRUCDISPERSIONCRECON;
DELIMITER $$

CREATE PROCEDURE INSTRUCDISPERSIONCRECON(
/* SP PARA CONSULTAR LAS INSTRUCCIONES DE DISPERSION */
	Par_SoliCredID			BIGINT(20),			-- Parametro Identificador de la Solicitud de Credito
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
	DECLARE Con_InsDisp INT(11);

	-- Inicialización de variables
	SET Con_InsDisp	:= 1;	-- Consulta una dispersión

	IF(Par_NumCon = Con_InsDisp)THEN

		SELECT Disp.SolicitudCreditoID,		Cli.ClienteID,		Cli.NombreCompleto,		Disp.MontoDispersion,	Disp.Estatus
		  FROM INSTRUCDISPERSIONCRE Disp
		 INNER JOIN SOLICITUDCREDITO SolCre ON Disp.SolicitudCreditoID = SolCre.SolicitudCreditoID
		 INNER JOIN CLIENTES Cli ON SolCre.ClienteID = Cli.ClienteID
		 WHERE Disp.SolicitudCreditoID = Par_SoliCredID;

	END IF;


END TerminaStore$$