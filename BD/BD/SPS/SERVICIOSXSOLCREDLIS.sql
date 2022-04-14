DELIMITER ;
DROP PROCEDURE IF EXISTS `SERVICIOSXSOLCREDLIS`;
DELIMITER $$

CREATE PROCEDURE `SERVICIOSXSOLCREDLIS`(
	-- Stored procedure para obtener listados de servicios adicionales por solicitud y/o crédito
	Par_ServicioSolID		INT(11),					--	ID del servicio que relacionado la solicitud de credito/credito
	Par_ServicioID			INT(11),					--	ID del servicio adicional
	Par_SolicitudCreditoID	INT(11),					--	ID de la solicitud de crédito
	Par_CreditoID			BIGINT(12),					--	ID del crédito
	Par_NumLis				TINYINT UNSIGNED,			--	Tipo de listado

	Aud_EmpresaID			INT(11),					--	Parámetro de auditoría
	Aud_Usuario				INT(11),					--	Parámetro de auditoría
	Aud_FechaActual			DATETIME,					--	Parámetro de auditoría
	Aud_DireccionIP			VARCHAR(15),				--	Parámetro de auditoría
	Aud_ProgramaID			VARCHAR(50),				--	Parámetro de auditoría
	Aud_Sucursal			INT(11),					--	Parámetro de auditoría
	Aud_NumTransaccion		BIGINT(20)					--	Parámetro de auditoría
)
TerminaStore: BEGIN

	-- Constantes
	DECLARE Var_LisSolCre	TINYINT UNSIGNED;	--	Lista por solicitud de crédito
	DECLARE Entero_Cero		INT(11);			--	Entero Cero

	-- Asignacion de constantes
	SET	Var_LisSolCre			:=	2;				--	Se establece el valor a 2
	SET Entero_Cero			:=	0;				--	Se establece el valor a 0

	-- Lista para obtener los servicios adicionales por la solicitud de crédito
	IF Par_NumLis = Var_LisSolCre THEN
		IF Par_SolicitudCreditoID != Entero_Cero AND Par_CreditoID != Entero_Cero THEN
			SELECT ssc.ServicioSolID,	ser.ServicioID,	ser.Descripcion,	ssc.SolicitudCreditoID,	ssc.CreditoID
			FROM SERVICIOSXSOLCRED AS ssc
			INNER JOIN SERVICIOSADICIONALES AS ser ON ser.ServicioID = ssc.ServicioID
			WHERE ssc.SolicitudCreditoID = Par_SolicitudCreditoID OR ssc.CreditoID = Par_CreditoID;
		ELSEIF Par_SolicitudCreditoID != Entero_Cero AND Par_CreditoID = Entero_Cero THEN
			SELECT ssc.ServicioSolID,	ser.ServicioID,	ser.Descripcion,	ssc.SolicitudCreditoID,	ssc.CreditoID
			FROM SERVICIOSXSOLCRED AS ssc
			INNER JOIN SERVICIOSADICIONALES AS ser ON ser.ServicioID = ssc.ServicioID
			WHERE ssc.SolicitudCreditoID = Par_SolicitudCreditoID;
		ELSEIF Par_SolicitudCreditoID = Entero_Cero AND Par_CreditoID != Entero_Cero THEN
			SELECT ssc.ServicioSolID,	ser.ServicioID,	ser.Descripcion,	ssc.SolicitudCreditoID,	ssc.CreditoID
			FROM SERVICIOSXSOLCRED AS ssc
			INNER JOIN SERVICIOSADICIONALES AS ser ON ser.ServicioID = ssc.ServicioID
			WHERE ssc.CreditoID = Par_CreditoID;
		END IF;
	END IF;
END TerminaStore$$