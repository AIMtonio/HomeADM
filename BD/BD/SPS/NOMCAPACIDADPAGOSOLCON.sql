DELIMITER ;
DROP PROCEDURE IF EXISTS NOMCAPACIDADPAGOSOLCON;

DELIMITER $$
CREATE PROCEDURE `NOMCAPACIDADPAGOSOLCON`(
	-- SP PARA CONSULTAR LA CAPACIDAD DE PAGO
	Par_NomCapacidadPagoSolID	BIGINT(20),			-- Identificador de la tabla NOMCAPACIDADPAGOSOL
    Par_SolicitudCreditoID		BIGINT(20),			-- Identificador de la tabla SOLICITUDCREDITO
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
	DECLARE Entero_Cero			INT(11);			-- Constante de Entero Cero
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- Constante de Decimal Cero
	DECLARE Fecha_Vacia			DATE;				-- Constante de Fecha Vacia
	DECLARE	Cadena_Vacia		CHAR(1);			-- Constante de Cadena Vacia
	DECLARE Con_SI				CHAR(1);			-- Constante SI
	DECLARE Con_NO				CHAR(1);			-- Constante NO
	DECLARE Con_Principal		TINYINT UNSIGNED;	-- Consulta Principal
	DECLARE Con_Solicitud		TINYINT UNSIGNED;	-- Consulta Foranea

	-- Asignacion de Constantes
	SET Entero_Cero 			:= 0;
	SET Decimal_Cero			:= 0.00;
	SET Fecha_Vacia 			:= '1900-01-01';
	SET Cadena_Vacia			:= '';
	SET Con_SI					:= 'S';
	SET Con_NO					:= 'N';
	SET Con_Principal			:= 1;
	SET Con_Solicitud			:= 2;
	SET Aud_FechaActual			:= NOW();

	-- Se realiza la consulta principal
	IF( Par_NumConsulta = Con_Principal ) THEN

		SELECT	NomCapacidadPagoSolID,	SolicitudCreditoID,	CapacidadPago,	MontoCasasComer,	MontoResguardo,
				PorcentajeCapacidad
		FROM NOMCAPACIDADPAGOSOL
		WHERE NomCapacidadPagoSolID = Par_NomCapacidadPagoSolID;

	END IF;

    -- Se realiza la consulta de CapacidadPago por SolicitudCreditoID
	IF( Par_NumConsulta = Con_Solicitud ) THEN

		SELECT	NomCapacidadPagoSolID,	SolicitudCreditoID,	CapacidadPago,	MontoCasasComer,	MontoResguardo,
				PorcentajeCapacidad
		FROM NOMCAPACIDADPAGOSOL
		WHERE SolicitudCreditoID = Par_SolicitudCreditoID;

	END IF;

END TerminaStore$$
