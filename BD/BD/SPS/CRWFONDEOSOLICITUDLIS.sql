-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWFONDEOSOLICITUDLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRWFONDEOSOLICITUDLIS`;
DELIMITER $$


CREATE PROCEDURE `CRWFONDEOSOLICITUDLIS`(
	-- SP para listar los datos relacionados con fondeosolicitud
	Par_CreditoID		    BIGINT(20), 				-- ID del credito
	Par_SolicituCredID		BIGINT(20),					-- ID de la solicitud de credito
	Par_ClienteID			INT(11),					-- ID de los clientes
	Par_SolFondeoID			BIGINT(20),					-- ID de la solicitud de fondeo
	Par_NumTransacc			BIGINT(20),					-- Numero de transaccion de las amortizaciones
    Par_NumLis				TINYINT UNSIGNED,

	Aud_EmpresaID       INT(11),					-- Auditoria
	Aud_Usuario         INT(11),                    -- Auditoria
	Aud_FechaActual     DATETIME,                   -- Auditoria
	Aud_DireccionIP     VARCHAR(15),                -- Auditoria
	Aud_ProgramaID      VARCHAR(50),                -- Auditoria
	Aud_Sucursal        INT(11),                    -- Auditoria
    Aud_NumTransaccion  BIGINT(20)
	)

TerminaStore: BEGIN

	-- Declaracion de Constantes
    DECLARE Lis_AmortiSoliciFon 	INT(11);						-- Lista de amortizaciones por solicitud de fondeo

    -- Asignacion de Constantes
    SET Lis_AmortiSoliciFon		:= 1;								-- Lista de amortizaciones por solicitud de fondeo

	-- Lista 1: Amortizaciones por solicitud de fondeo
    IF(Par_NumLis = Lis_AmortiSoliciFon) THEN
		
		SELECT  Tmp_Consecutivo,    Tmp_FecIni, 	Tmp_FecFin, 	Tmp_FecVig,     Tmp_Capital,   		Tmp_Interes,
				Tmp_ISR,    		Tmp_SubTotal,	Tmp_Iva,		Tmp_Insoluto, 	NumTransaccion,		Tmp_FrecuPago
		FROM CRWTMPPAGAMORSIM Tmp
		WHERE Tmp.NumTransaccion = Par_NumTransacc;
		
    END IF;

END TerminaStore$$
