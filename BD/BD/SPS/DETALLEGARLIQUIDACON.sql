-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEGARLIQUIDACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `DETALLEGARLIQUIDACON`;DELIMITER $$

CREATE PROCEDURE `DETALLEGARLIQUIDACON`(
-- ===================================================================
-- SP PARA CONSULTAR INFO DE LAS GARANTÍAS DE UN CRÉDITO
-- ===================================================================
	Par_CreditoID 			INT(11),			# Indica el Identificador del Crédito
    Par_SolicitudCreditoID	INT(11),			# Indica Solicitud de Crrédito
	Par_TipoConsulta		TINYINT UNSIGNED,	# Indica el Tipo de Consulta

	# Parametros de Auditoria
	Aud_EmpresaID 			INT(11),
	Aud_Usuario 			INT(11),
  	Aud_FechaActual 		DATETIME,
  	Aud_DireccionIP 		VARCHAR(15),
  	Aud_ProgramaID 			VARCHAR(50),
  	Aud_Sucursal 			INT(11),
  	Aud_NumTransaccion 		BIGINT(20)
)
TerminaStore:BEGIN

	DECLARE Con_Principal	INT(11); 		# Tipo de Consulta Principal
    DECLARE StringSi		CHAR(1); 		# Constante: Si
    DECLARE Entero_Cero		INT(11);		# Constante: Entero Creo
    DECLARE Decimal_Cero	DECIMAL(12,2);  # Constante: Decimal Cero


    SET Con_Principal 	:= 13; 		# Consulta Principal
    SET StringSi 		:= 'S'; 	# Constante: Cadena Si
    SET Entero_Cero		:= 0;		# Constante: Entero Cero
    SET Decimal_Cero 	:= 0.00; 	# Constante: Decimal Cero



	IF(Par_TipoConsulta=Con_Principal)THEN
		SELECT SolicitudCreditoID,		CreditoID,					ProductoCreditoID,		RequiereGarantia,	Bonificacion,
				PorcBonificacion,		DesbloqAut,					RequiereGarFOGAFI,		PorcGarFOGAFI,		ModalidadFOGAFI,
                BonificacionFOGAFI,		PorcBonificacionFOGAFI,		DesbloqAutFOGAFI,		LiberaGarLiq,		MontoGarLiq,
                MontoGarFOGAFI,			FechaLiquidaGar,			FechaLiquidaFOGAFI,		MontoBloqueadoGar,	MontoBloqueadoFOGAFI,
                (MontoGarLiq - MontoBloqueadoGar) AS SaldoGarLiquida,(MontoGarFOGAFI - MontoBloqueadoFOGAFI) AS	SaldoFOGAFI
		FROM DETALLEGARLIQUIDA
		WHERE CASE WHEN Par_CreditoID > Entero_Cero THEN CreditoID = Par_SolicitudCreditoID
        ELSE SolicitudCreditoID = Par_SolicitudCreditoID END;

	END IF;

END TerminaStore$$