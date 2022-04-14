-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNDISPONIBLEGARANTIA
DELIMITER ;
DROP FUNCTION IF EXISTS `FNDISPONIBLEGARANTIA`;

DELIMITER $$
CREATE FUNCTION `FNDISPONIBLEGARANTIA`(
	-- Funcion para consultar el monto disponible de una garantia
	Par_GarantiaID				INT(11),	-- ID de garantia
	Par_SolicitudCreditoID 		BIGINT(20),	-- Solicitud de credito
	Par_TipoConsulta			INT(11)		-- Numero de consultar
) RETURNS DECIMAL(14,2)
	DETERMINISTIC
BEGIN
	-- Declaracion de Variables
	DECLARE Var_MontoGarantia		DECIMAL(14,2);	-- Monto de Garantia
	DECLARE Var_MontoAsignado		DECIMAL(14,2);	-- Monto Asignado a la Garantia
	DECLARE Var_MontoDisponible		DECIMAL(14,2);	-- Monto Disponible de la Garantia
	DECLARE Var_MontoResultado		DECIMAL(14,2);	-- Monto Resultado
	DECLARE Var_TipoCredito			CHAR(1);		-- Tipo de Solicitud de Credito

	DECLARE Var_TipoLiquidacion		CHAR(1);		-- Tipo de Liquidacion
	DECLARE Var_EvaluarMontoAvaluo	CHAR(1);		-- Evalua el Monto de Avaluo de la Garantia
	DECLARE Var_EsConsolidacionAgro	CHAR(1);		-- Es Solicitud de Credito Consolidada
	DECLARE Var_CreditoRelacionado	BIGINT(12);		-- Credito Relacionado a la solicitud

	-- Declaracion de Consultas
	DECLARE Con_MontoDisponGar 	INT(11);		-- Consulta Monto Disponible de Garantia
	DECLARE Con_MontoAvaluo 	INT(11);		-- Consulta Monto de Avaluo de la Garantia
	DECLARE Con_MontoAsignado 	INT(11);		-- Consulta Monto Asignado de la Garantia

	-- Declaracion de constantes
	DECLARE Entero_Cero			INT(11);		-- Entero Cero
	DECLARE Decimal_Cero 		DECIMAL(12,2);	-- Decimal Cero
	DECLARE Cadena_Vacia 		CHAR(1);		-- Cadena Vacia
	DECLARE Est_Autorizada		CHAR(1);		-- Estatus Garantia Autorizada
	DECLARE Est_Origen			CHAR(1);		-- Estatus de Garantia Origen

	DECLARE Est_Vencido			CHAR(1);		-- Estatus de Credito Vencido
	DECLARE Est_Vigente			CHAR(1);		-- Estatus de Credito Vigente
	DECLARE Est_Pagado          CHAR(1);        -- Estatus de Credito Pagado
	DECLARE Est_Cancelado       CHAR(1);        -- Estatus de Credito Cancelado
	DECLARE Con_Nueva			CHAR(1);		-- Constante de Solicitud Nueva
	DECLARE Con_Reestructura	CHAR(1);		-- Constante de Solicitud Reestructura
	DECLARE Con_Renovada		CHAR(1);		-- Constante de Solicitud Renovada

	DECLARE Liq_Completa		CHAR(1);		-- Constante de Liquidacion Completa
	DECLARE Con_NO				CHAR(1);		-- Constante NO
	DECLARE Con_SI				CHAR(1);		-- Constante SI
	DECLARE Con_LlaveParametro	VARCHAR(50);	-- Llave de Parametro

	-- Asignacion de Consultas
	SET Con_MontoDisponGar		:= 1;
	SET Con_MontoAvaluo			:= 2;
	SET Con_MontoAsignado		:= 3;

	-- Asignacion de Constantes
	SET Entero_Cero				:= 0;
	SET Decimal_Cero 			:= 0.00;
	SET Cadena_Vacia			:= '';
	SET Est_Autorizada			:= 'U';
	SET Est_Origen				:= 'O';

	SET Est_Vencido				:= 'B';
	SET Est_Vigente				:= 'V';
    SET Con_Nueva				:= 'N';
    SET Est_Pagado              := 'P';
    SET Est_Cancelado           := 'C';
	SET Con_Reestructura		:= 'R';
	SET Con_Renovada			:= 'O';

	SET Liq_Completa			:= 'T';
	SET Con_NO 					:= 'N';
	SET Con_SI 					:= 'S';
	SET Con_LlaveParametro		:= 'EvaluarMontoAvaluo';

	SELECT ValorParametro
	INTO Var_EvaluarMontoAvaluo
	FROM PARAMGENERALES
	WHERE LlaveParametro = Con_LlaveParametro;

	SET Par_GarantiaID			:= IFNULL(Par_GarantiaID, Entero_Cero);
	SET Par_SolicitudCreditoID 	:= IFNULL(Par_SolicitudCreditoID, Entero_Cero);
	SET Par_TipoConsulta		:= IFNULL(Par_TipoConsulta, Entero_Cero);

	IF( IFNULL(Var_EvaluarMontoAvaluo, Con_NO) = Con_NO ) THEN
		SELECT MontoGravemen
		INTO Var_MontoGarantia
		FROM GARANTIAS
		WHERE GarantiaID = Par_GarantiaID;
	ELSE
		SELECT MontoAvaluo
		INTO Var_MontoGarantia
		FROM GARANTIAS
		WHERE GarantiaID = Par_GarantiaID;
	END IF;

	SELECT IFNULL(SUM(Asig.MontoAsignado), Decimal_Cero) AS MontoAsignado
	INTO Var_MontoAsignado
	FROM ASIGNAGARANTIAS Asig
	INNER JOIN CREDITOS Cre  ON Asig.CreditoID = Cre.CreditoID
	WHERE Asig.GarantiaID = Par_GarantiaID
	  AND Asig.Estatus = Est_Autorizada
	  AND Cre.Estatus NOT IN (Est_Pagado,Est_Cancelado);

	IF( Par_SolicitudCreditoID > Entero_Cero ) THEN

		SELECT TipoCredito,		TipoLiquidacion,		EsConsolidacionAgro
		INTO Var_TipoCredito,	Var_TipoLiquidacion,	Var_EsConsolidacionAgro
		FROM SOLICITUDCREDITO
		WHERE SolicitudCreditoID = Par_SolicitudCreditoID;

		SET Var_TipoCredito	  	  := IFNULL(Var_TipoCredito, Con_Nueva);
		SET Var_EsConsolidacionAgro := IFNULL(Var_EsConsolidacionAgro, Con_NO);

		IF( Var_TipoCredito = Con_Reestructura OR
			(Var_TipoCredito = Con_Renovada AND Var_TipoLiquidacion = Liq_Completa )) THEN

			SELECT Relacionado
			INTO Var_CreditoRelacionado
			FROM SOLICITUDCREDITO
			WHERE SolicitudCreditoID = Par_SolicitudCreditoID;

			SELECT  IFNULL(SUM(Asig.MontoAsignado), Decimal_Cero) AS MontoAsignado
			INTO Var_MontoAsignado
			FROM ASIGNAGARANTIAS Asig
			INNER JOIN CREDITOS Cre  on Asig.CreditoID = Cre.CreditoID
			WHERE Asig.GarantiaID = Par_GarantiaID
			  AND Asig.EstatusSolicitud <> Est_Origen
			  AND Asig.Estatus = Est_Autorizada
			  AND Asig.CreditoID <> IFNULL(Var_CreditoRelacionado, Entero_Cero)
			  AND Cre.Estatus IN ( Est_Vigente, Est_Vencido);
		END IF;

		IF( Var_EsConsolidacionAgro = Con_SI ) THEN

			SELECT  IFNULL(SUM(Asig.MontoAsignado), Decimal_Cero) AS MontoAsignado
			INTO Var_MontoAsignado
			FROM ASIGNAGARANTIAS Asig
			INNER JOIN CREDITOS Cre  on Asig.CreditoID = Cre.CreditoID
			WHERE Asig.GarantiaID = Par_GarantiaID
			  AND Asig.EstatusSolicitud <> Est_Origen
			  AND Asig.Estatus = Est_Autorizada
			  AND Asig.CreditoID NOT IN (SELECT Det.CreditoID FROM CRECONSOLIDAAGRODET Det WHERE Det.SolicitudCreditoID = Par_SolicitudCreditoID)
			  AND Cre.Estatus IN ( Est_Vigente, Est_Vencido);
		END IF;
	END IF;

	SET Var_MontoGarantia := IFNULL(Var_MontoGarantia,Decimal_Cero);
	SET Var_MontoAsignado := IFNULL(Var_MontoAsignado,Decimal_Cero);

	-- Consulta Monto Disponible de Garantia
	IF(Par_TipoConsulta = Con_MontoDisponGar) THEN
		SET Var_MontoDisponible := Var_MontoGarantia - Var_MontoAsignado;
		SET Var_MontoResultado  := IFNULL(Var_MontoDisponible, Decimal_Cero);
	END IF;

	-- Consulta Monto de Avaluo de la Garantia
	IF(Par_TipoConsulta = Con_MontoAvaluo) THEN
		SET Var_MontoResultado := Var_MontoGarantia;
	END IF;

	-- Consulta Monto Asignado de la Garantia
	IF(Par_TipoConsulta = Con_MontoAsignado) THEN
		SET Var_MontoResultado := Var_MontoAsignado;
	END IF;

	RETURN Var_MontoResultado;
END$$
