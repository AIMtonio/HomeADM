DELIMITER ;
DROP PROCEDURE IF EXISTS NOMCAPACIDADPAGOSOLIS;

DELIMITER $$
CREATE PROCEDURE NOMCAPACIDADPAGOSOLIS(
	Par_NomCapacidadPagoSolID	BIGINT(20),			-- Identificador de la tabla NOMCAPACIDADPAGOSOL
	Par_SolicitudCreditoID		BIGINT(20),			-- Identificador de la tabla SOLICITUDCREDITO
	Par_NumLis					TINYINT UNSIGNED,	-- Numero de Consulta

	Aud_EmpresaID				INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,			-- Parametro de auditoria Feha actual
	Aud_DireccionIP				VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE Entero_Cero			INT(11);			-- Constante de Entero Cero
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- Constante de Decimal Cero
	DECLARE Fecha_Vacia			DATE;				-- Constante de Fecha Vacia
	DECLARE	Cadena_Vacia		CHAR(1);			-- Constante de Cadena Vacia
	DECLARE Con_SI				CHAR(1);			-- Constante SI
	DECLARE Con_NO				CHAR(1);			-- Constante NO
	DECLARE Lis_CasaComerPorSol	TINYINT UNSIGNED;	-- Listado de las casa comerciales por solicitud de credito

	-- Asignacion de Constantes
	SET Entero_Cero 			:= 0;
	SET Decimal_Cero			:= 0.00;
	SET Fecha_Vacia 			:= '1900-01-01';
	SET Cadena_Vacia			:= '';
	SET Con_SI					:= 'S';
	SET Con_NO					:= 'N';
	SET Lis_CasaComerPorSol		:= 1;		-- Listado de las casa comerciales por solicitud de credito


	-- 1.- Listado de las casa comerciales por solicitud de credito
	IF( Par_NumLis = Lis_CasaComerPorSol ) THEN

		SELECT	ASIG.CasaComercialID,		CASA.NombreCasaCom,		ASIG.Monto AS MontoCasaComercial
		FROM ASIGCARTASLIQUIDACION ASIG
		INNER JOIN CASASCOMERCIALES CASA ON CASA.CasaComercialID = ASIG.CasaComercialID
		WHERE ASIG.SolicitudCreditoID = Par_SolicitudCreditoID;

	END IF;

END TerminaStore$$
