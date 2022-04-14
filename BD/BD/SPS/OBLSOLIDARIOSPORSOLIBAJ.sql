-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- OBLSOLIDARIOSPORSOLIBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `OBLSOLIDARIOSPORSOLIBAJ`;DELIMITER $$

CREATE PROCEDURE `OBLSOLIDARIOSPORSOLIBAJ`(
	-- STORED PARA BAJA DE OBLIGADOS SOLIDARIOS POR SOLICITUD
	Par_SolicitudCreditoID		INT(11),			-- ID de la solicitud de crédito
	Par_OblSolidID				INT(11),			-- Identificador del Obligado solidario
	Par_ClienteID				INT(11),			-- ID de cliente como aval
	Par_ProspectoID				INT(11),			-- ID de prospecto como aval
	Par_NumBaja					INT(11),			-- ID de baja 1: por solicitus 2: por reestructura
	Par_EmpresaID				INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,			-- Parametro de auditoria Fecha actual
	Aud_DireccionIP				VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
	)
TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE Var_ClienteID	INT(11);

	-- Declaracion de Constantes
	DECLARE SalidaSI			CHAR(1);			-- Salida si
	DECLARE SalidaNO			CHAR(1);			-- salida no
	DECLARE Entero_Cero			INT;				-- Entero cero
	DECLARE Decimal_Cero		DECIMAL(12,2);		-- Decimal Cero
	DECLARE Cadena_Vacia		CHAR(1);			-- Cadena vacia
	DECLARE Baja_AvPorSol		INT(11);				-- Baja_AvPorSol
	DECLARE Baja_AvalReest		INT(11);			-- Baja_AvalReest

	-- Asignacion de Constantes
	SET SalidaSI				:= 'S';				-- salida  si
	SET SalidaNO				:= 'N';				-- salida no
	SET Entero_Cero				:= 0;				-- Entero Cero
	SET Decimal_Cero			:= 0.00;			-- Decimal cero
	SET Cadena_Vacia			:= '';				-- cadena Vacia
	SET Baja_AvPorSol			:= 1;				-- Baja_AvPorSol
	SET Baja_AvalReest			:= 2;				-- Baja_AvalReest

	SET Var_ClienteID = (SELECT ClienteID FROM SOLICITUDCREDITO WHERE SolicitudCreditoID = Par_SolicitudCreditoID);

	IF(IFNULL(Par_SolicitudCreditoID, Entero_Cero)) = Entero_Cero THEN
		SELECT '001' AS NumErr,
			'La Solicitud no Existe.' AS ErrMen,
			'solicitudCreditoID' AS control;
		LEAVE TerminaStore;
	END IF;

	SET Aud_FechaActual := CURRENT_TIMESTAMP();

	IF(Par_NumBaja = Baja_AvPorSol) THEN

	DELETE FROM  OBLSOLIDARIOSPORSOLI
		WHERE SolicitudCreditoID = Par_SolicitudCreditoID;

	END IF;

	IF(Par_NumBaja = Baja_AvalReest) THEN

		DELETE FROM  OBLSOLIDARIOSPORSOLI
		WHERE SolicitudCreditoID = Par_SolicitudCreditoID
		AND ClienteID <> Par_ClienteID;

	END IF;

	SELECT '000' AS NumErr ,
			'Solicitud Eliminada.' AS ErrMen,
			'solicitudCreditoID' AS control;

END TerminaStore$$