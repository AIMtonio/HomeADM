-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRECONSOLIDAAGROENCCON
DELIMITER ;
DROP PROCEDURE IF EXISTS CRECONSOLIDAAGROENCCON;

DELIMITER $$
CREATE PROCEDURE `CRECONSOLIDAAGROENCCON`(
	-- Store Procedure: Que Consulta el Folio de Consolidacion
	-- Modulo Guarda Valores
	Par_FolioConsolidacionID	BIGINT(12),			-- ID de Tabla
	Par_SolicitudCreditoID		BIGINT(20),			-- ID de Solicitud de crédito
	Par_CreditoID		BIGINT(20),			-- ID de Solicitud de crédito
	Par_NumConsulta				TINYINT UNSIGNED,	-- Numero de Consulta

	Aud_EmpresaID				INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,			-- Parametro de auditoria Feha actual
	Aud_DireccionIP				VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables

	-- Declaracion de Constantes
	DECLARE Entero_Cero				INT(11);			-- Constante de Entero Cero
	DECLARE Decimal_Cero			DECIMAL(14,2);		-- Constante de Decimal Cero
	DECLARE Fecha_Vacia				DATE;				-- Constante de Fecha Vacia
	DECLARE	Cadena_Vacia			CHAR(1);			-- Constante de Cadena Vacia

	-- Declaracion de Consultas
	DECLARE Con_Principal			TINYINT UNSIGNED;	-- Consulta Principal
	DECLARE Con_FolioSolicitud		TINYINT UNSIGNED;	-- Consulta Folio de Solicitud
	DECLARE Con_FolioCredito		TINYINT UNSIGNED;	-- Consulta Folio de Credito
	DECLARE Con_TotalExigible		TINYINT UNSIGNED;	-- Consulta Total Exigible;

	-- Asignacion de Constantes
	SET Entero_Cero 			:= 0;
	SET Decimal_Cero			:= 0.00;
	SET Fecha_Vacia 			:= '1900-01-01';
	SET Cadena_Vacia			:= '';

	-- Asignacion de Consultas
	SET Con_Principal			:= 1;
	SET Con_FolioSolicitud		:= 2;
	SET Con_FolioCredito		:= 3;
	SET Con_TotalExigible		:= 4;

	-- Se realiza la consulta principal
	IF( Par_NumConsulta = Con_Principal ) THEN
		SELECT	FolioConsolida,		FechaConsolida,		SolicitudCreditoID,		CreditoID,
				FechaDesembolso,	CantRegistros,		MontoConsolidado,		Estatus,
				Entero_Cero AS DeudorOriginalID
		FROM CRECONSOLIDAAGROENC
		WHERE FolioConsolida = Par_FolioConsolidacionID;
	END IF;

	-- Consulta Folio de Solicitud de Credito
	IF( Par_NumConsulta = Con_FolioSolicitud ) THEN
		SELECT	Enc.FolioConsolida,		Enc.FechaConsolida,		Enc.SolicitudCreditoID,		Enc.CreditoID,
				Enc.FechaDesembolso,	Enc.CantRegistros,		Enc.MontoConsolidado,		Enc.Estatus,
				Sol.DeudorOriginalID
		FROM CRECONSOLIDAAGROENC Enc
		INNER JOIN SOLICITUDCREDITO Sol ON Enc.SolicitudCreditoID = Sol.SolicitudCreditoID
		WHERE Enc.SolicitudCreditoID = Par_SolicitudCreditoID;
	END IF;

	-- Consulta Folio de Credito
	IF( Par_NumConsulta = Con_FolioCredito ) THEN
		SELECT	Enc.FolioConsolida,		Enc.FechaConsolida,		Enc.SolicitudCreditoID,		Enc.CreditoID,
				Enc.FechaDesembolso,	Enc.CantRegistros,		Enc.MontoConsolidado,		Enc.Estatus,
				Sol.DeudorOriginalID
		FROM CRECONSOLIDAAGROENC Enc
		INNER JOIN CREDITOS Cre ON Enc.CreditoID = Cre.CreditoID
		INNER JOIN SOLICITUDCREDITO Sol ON Cre.SolicitudCreditoID = Sol.SolicitudCreditoID
		WHERE Enc.CreditoID = Par_CreditoID;
	END IF;

	-- El Adeudo Total de los creditos a Consolidar.
	IF( Par_NumConsulta = Con_TotalExigible ) THEN
 		SELECT	SUM(IFNULL(FUNCIONTOTDEUDACRE(Det.CreditoID), Entero_Cero)) AS MontoExigible
		FROM CRECONSOLIDAAGROENC Enc
		INNER JOIN CRECONSOLIDAAGRODET Det ON Enc.FolioConsolida = Det.FolioConsolida
		WHERE Enc.FolioConsolida = Par_FolioConsolidacionID;
	END IF;
END TerminaStore$$