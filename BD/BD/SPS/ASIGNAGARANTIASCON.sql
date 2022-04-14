-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ASIGNAGARANTIASCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `ASIGNAGARANTIASCON`;
DELIMITER $$

CREATE PROCEDURE `ASIGNAGARANTIASCON`(
	/* SP DE CONSULTA DE ASIGACION DE GARANTIAS */
    Par_SolCredID       	INT(11),
    Par_CreditoID       	BIGINT(12),
    Par_GarantiaID      	INT(11),
    Par_TipConsulta     	TINYINT UNSIGNED,

    Par_EmpresaID	    	INT(11),			-- Parametros de auditoria --
    Aud_Usuario	       		INT(11),
    Aud_FechaActual			DATETIME ,
    Aud_DireccionIP			VARCHAR(15),
    Aud_ProgramaID	    	VARCHAR(70),
    Aud_Sucursal	    	INT(11),
    Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

	/* Declaracion de Variables */
	DECLARE Var_FecReg      DATETIME;

	-- Declaracion de Consultas
	DECLARE Con_MontoDisponGar 	INT(11);	-- Consulta Monto Disponible de Garantia
	DECLARE Con_MontoAvaluo 	INT(11);	-- Consulta Monto de Avaluo de la Garantia
	DECLARE Con_MontoAsignado 	INT(11);	-- Consulta Monto Asignado de la Garantia

	/* Declaracion de Constantes */
	DECLARE Entero_Cero     	INT(11);
	DECLARE Decimal_Cero    	INT(11);
	DECLARE Est_Asignada    	CHAR(1);
	DECLARE Estatus_Vigente 	CHAR(1);
	DECLARE Con_Principal   	TINYINT UNSIGNED;
	DECLARE Con_ForaneaCre		TINYINT UNSIGNED;
	DECLARE Con_ForaneaSol		TINYINT UNSIGNED;
	DECLARE Con_fueAsignada 	TINYINT UNSIGNED;
	DECLARE Con_AsigASolicitud 	TINYINT UNSIGNED;
    DECLARE Con_GarReest		TINYINT UNSIGNED;
	DECLARE Var_CreditoID 		INT(11);
	DECLARE	Var_EstatusCre 		CHAR(1);
	DECLARE	Var_Asignada 		CHAR(1);
    DECLARE Var_SolOrigen		BIGINT(20);

	-- Asignacion de Consultas
	SET Con_MontoDisponGar		:= 1;
	SET Con_MontoAvaluo			:= 2;
	SET Con_MontoAsignado		:= 3;

	/* Asignacion de Constantes */
	SET Entero_Cero     	:= 0;
	SET Decimal_Cero    	:= 0.00;
	SET Est_Asignada     	:= 'A';    -- Estatus de la Asignacion de la Garantia: Asignada
	SET Con_Principal   	:= 2;      -- Consulta Principal
	SET Con_ForaneaCre		:= 3;	  	-- Consulta producto credito requiere garantia
	SET Con_ForaneaSol 		:= 4;		-- Consulta producto credito requiere garantia
	SET Con_fueAsignada 	:= 5;
	SET Con_AsigASolicitud	:= 6;
	SET Con_GarReest		:= 7;
	SET Estatus_Vigente 	:='V';
	SET Var_Asignada 		:='A';

	SET Var_FecReg  := NOW();

	IF(Par_TipConsulta = Con_Principal) THEN

		IF(IFNULL(Par_CreditoID, Entero_Cero) != Entero_Cero) THEN
			SELECT  Gar.GarantiaID, Gar.Observaciones, Gar.ValorComercial, Asi.MontoAsignado ,Asi.Estatus, Asi.SustituyeGL,
			CASE WHEN EstatusSolicitud = '' THEN 'N' ELSE  EstatusSolicitud END AS EstatusSolicitud,
					FNDISPONIBLEGARANTIA(Gar.GarantiaID, Entero_Cero, Con_MontoDisponGar) AS MontoDisponible,
					FNDISPONIBLEGARANTIA(Gar.GarantiaID, Entero_Cero, Con_MontoAvaluo)    AS MontoGarantia,
					FNDISPONIBLEGARANTIA(Gar.GarantiaID, Entero_Cero, Con_MontoAsignado)  AS MontoAvaluado
				FROM ASIGNAGARANTIAS Asi,
					 GARANTIAS Gar
				WHERE Asi.CreditoID     = Par_CreditoID
				  AND Asi.GarantiaID    = Gar.GarantiaID;
		ELSE
			SELECT  Gar.GarantiaID, Gar.Observaciones, Gar.ValorComercial, Asi.MontoAsignado ,Asi.Estatus, Asi.SustituyeGL,
			CASE WHEN EstatusSolicitud = '' THEN 'N' ELSE  EstatusSolicitud END AS EstatusSolicitud,
					FNDISPONIBLEGARANTIA(Gar.GarantiaID, Par_SolCredID, Con_MontoDisponGar) AS MontoDisponible,
					FNDISPONIBLEGARANTIA(Gar.GarantiaID, Par_SolCredID, Con_MontoAvaluo)    AS MontoGarantia,
					FNDISPONIBLEGARANTIA(Gar.GarantiaID, Par_SolCredID, Con_MontoAsignado)  AS MontoAvaluado
				FROM ASIGNAGARANTIAS Asi,
					 GARANTIAS Gar
				WHERE Asi.SolicitudCreditoID    = Par_SolCredID
				  AND Asi.GarantiaID            = Gar.GarantiaID;
		END IF;
	END IF;

	IF(Par_TipConsulta = Con_ForaneaCre) THEN
		--  Consulta que verifica  si el producto de credito requiere garantia en CREDITOS
		SELECT Pro.RequiereGarantia,Cre.Estatus ,ROUND(Pro.RelGarantCred,2) AS RelGarantCred
		FROM PRODUCTOSCREDITO Pro, CREDITOS Cre  WHERE
		Pro.ProducCreditoID = Cre.ProductoCreditoID
		AND Cre.CreditoID=Par_CreditoID;
	END IF;

	IF(Par_TipConsulta = Con_ForaneaSol) THEN
		--  Consulta que verifica  si el producto de credito requiere garantÃ­a en SOLICITUDCREDITO
		SELECT Pro.RequiereGarantia,Sol.Estatus,ROUND(Pro.RelGarantCred,2) AS RelGarantCred
		FROM PRODUCTOSCREDITO Pro, SOLICITUDCREDITO Sol  WHERE
		Pro.ProducCreditoID = Sol.ProductoCreditoID
		AND Sol.SolicitudCreditoID=Par_SolCredID;

	END IF;

	IF(Par_TipConsulta = Con_fueAsignada)THEN

	  -- Consulta el Estatus de credito para verificar que La garantia no se esta usando
		SELECT   Sol.CreditoID,Cre.Estatus
		FROM CREDITOS Cre
		INNER JOIN SOLICITUDCREDITO Sol
			ON Sol.CreditoID = Cre.CreditoID
		INNER JOIN ASIGNAGARANTIAS Asig
			ON  Asig.SolicitudCreditoID=Sol.SolicitudCreditoID AND
			Asig.GarantiaID = Par_GarantiaID ;

	END IF;

	IF(Par_TipConsulta = Con_AsigASolicitud)THEN
	  -- Consulta si la garantia ya la tiene otra solicitud de credito
		SELECT  Asig.SolicitudCreditoID FROM ASIGNAGARANTIAS Asig
	   INNER JOIN SOLICITUDCREDITO Sol
			ON Asig.SolicitudCreditoID = Sol.SolicitudCreditoID
			AND  Sol.CreditoID=0
			AND Asig.GarantiaID=Par_GarantiaID  LIMIT 1;
	END IF;

    IF(Par_TipConsulta = Con_GarReest)THEN


		SELECT  Gar.GarantiaID, Gar.Observaciones, Gar.ValorComercial, Asi.MontoAsignado ,Asi.Estatus ,
			CASE WHEN EstatusSolicitud = '' THEN 'N'
            ELSE
            EstatusSolicitud
            END AS EstatusSolicitud,
			FNDISPONIBLEGARANTIA(Gar.GarantiaID, Par_SolCredID, Con_MontoDisponGar) AS MontoDisponible,
			FNDISPONIBLEGARANTIA(Gar.GarantiaID, Par_SolCredID, Con_MontoAvaluo)    AS MontoGarantia,
			FNDISPONIBLEGARANTIA(Gar.GarantiaID, Par_SolCredID, Con_MontoAsignado)  AS MontoAvaluado
				FROM ASIGNAGARANTIAS Asi,
					 GARANTIAS Gar
				WHERE Asi.SolicitudCreditoID    = Par_SolCredID
				  AND Asi.GarantiaID            = Gar.GarantiaID;

	END IF;
END TerminaStore$$