-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AVALESPORSOLIBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `AVALESPORSOLIBAJ`;DELIMITER $$

CREATE PROCEDURE `AVALESPORSOLIBAJ`(
# ============================================================
# ------- STORED PARA BAJA DE AVALES DE LA SOLICITUD ---------
# ============================================================
    Par_SolicitudCreditoID  INT(11),		-- ID de la solicitud de crédito
    Par_AvalID              INT(11),		-- ID de aval
    Par_ClienteID           INT(11),		-- ID de cliente como aval
    Par_ProspectoID         INT(11),		-- ID de prospecto como aval
    Par_NumBaja             INT(11),		-- ID de baja 1: por solicitus 2: por reestructura

    Par_EmpresaID       	INT(11),		-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),		-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,		-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),		-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_ClienteID	INT(11);

	-- Declaracion de Constantes
	DECLARE SalidaSI        CHAR(1);
	DECLARE SalidaNO        CHAR(1);
	DECLARE Entero_Cero     INT;
	DECLARE Decimal_Cero    DECIMAL(12,2);
	DECLARE Cadena_Vacia    CHAR(1);

	DECLARE Baja_AvPorSol   INT;
	DECLARE Baja_AvalReest	INT(11);

	-- Asignacion de Constantes
	SET SalidaSI        := 'S';
	SET SalidaNO        := 'N';
	SET Entero_Cero     := 0;
	SET Decimal_Cero    := 0.00;
	SET Cadena_Vacia    := '';

	SET Baja_AvPorSol   := 1;
	SET Baja_AvalReest	:= 2;

	SET Var_ClienteID = (SELECT ClienteID FROM SOLICITUDCREDITO WHERE SolicitudCreditoID = Par_SolicitudCreditoID);

	IF(IFNULL(Par_SolicitudCreditoID, Entero_Cero)) = Entero_Cero THEN
		SELECT '001' AS NumErr,
			 'La Solicitud no Existe.' AS ErrMen,
			 'solicitudCreditoID' AS control;
		LEAVE TerminaStore;
	END IF;

	SET Aud_FechaActual := CURRENT_TIMESTAMP();

	IF(Par_NumBaja = Baja_AvPorSol) THEN

		DELETE FROM  AVALESPORSOLICI
			WHERE SolicitudCreditoID = Par_SolicitudCreditoID;

	END IF;

	IF(Par_NumBaja = Baja_AvalReest) THEN

		DELETE FROM  AVALESPORSOLICI
		WHERE SolicitudCreditoID = Par_SolicitudCreditoID
		AND ClienteID <> Par_ClienteID;


END IF;

	SELECT '000' AS NumErr ,
	'Solicitud Eliminada.' AS ErrMen,
	'solicitudCreditoID' AS control;

END TerminaStore$$