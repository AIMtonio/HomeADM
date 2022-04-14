-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMASEGUROVIDACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMASEGUROVIDACON`;DELIMITER $$

CREATE PROCEDURE `ESQUEMASEGUROVIDACON`(

	Par_ProducCreditoID		INT(11),
	Par_EsquemaSeguroID		INT(11),
	Par_TipoPagoSeguro		CHAR(1),

	Par_NumCon				TINYINT UNSIGNED,


	Par_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
	)
TerminaStore: BEGIN


	DECLARE Entero_Cero			INT;
	DECLARE Con_Principal		INT;
	DECLARE Con_PorTipPago		INT;
	DECLARE	Con_Foranea			INT;
	DECLARE	Con_ForaneaCred		INT;
	DECLARE	Var_ProdCred		INT;
	DECLARE Var_Esquema			INT;


	SET Entero_Cero				:=0;
	SET Con_Principal			:=1;
	SET Con_Foranea				:=2;
	SET Con_PorTipPago			:=3;
	SET Con_ForaneaCred			:=4;


	if(Par_EsquemaSeguroID = Entero_Cero) then
		SET Var_ProdCred	:= Par_ProducCreditoID;
	else
		SET Var_ProdCred	:= (SELECT ProducCreditoID FROM PRODUCTOSCREDITO
										WHERE EsquemaSeguroID = Par_EsquemaSeguroID);
	end if;


	SET Var_Esquema				:=	(SELECT EsquemaSeguroID FROM PRODUCTOSCREDITO
									WHERE ProducCreditoID = Par_ProducCreditoID);

	IF(Par_NumCon = Con_Principal) THEN

		SELECT EsquemaSeguroID, 	ProducCreditoID,	TipoPagoSeguro,			FactorRiesgoSeguro,		DescuentoSeguro,
			   MontoPolSegVida
		FROM ESQUEMASEGUROVIDA
		WHERE ProducCreditoID = Par_ProducCreditoID;

	END IF;



IF(Par_NumCon = Con_Foranea) THEN
		SELECT EsquemaSeguroID, 	ProducCreditoID,	TipoPagoSeguro,			FactorRiesgoSeguro,		DescuentoSeguro,
			   MontoPolSegVida
		FROM ESQUEMASEGUROVIDA
		WHERE ProducCreditoID = Par_ProducCreditoID
		AND	  EsquemaSeguroID = Var_Esquema
		AND   TipoPagoSeguro = Par_TipoPagoSeguro;

	END IF;


	IF(Par_NumCon = Con_ForaneaCred) THEN
		SELECT EsquemaSeguroID, 	ProducCreditoID,	TipoPagoSeguro,			FactorRiesgoSeguro,		DescuentoSeguro,
			   MontoPolSegVida
		FROM ESQUEMASEGUROVIDA
		WHERE ProducCreditoID = Par_ProducCreditoID
		AND	  EsquemaSeguroID = Var_Esquema
		AND   TipoPagoSeguro  = Par_TipoPagoSeguro;

	END IF;



	IF(Par_NumCon = Con_PorTipPago) THEN
		SELECT EsquemaSeguroID, 	ProducCreditoID,	TipoPagoSeguro,			FactorRiesgoSeguro,		DescuentoSeguro,
			   MontoPolSegVida
		FROM ESQUEMASEGUROVIDA
		WHERE ProducCreditoID = Var_ProdCred
		AND	  EsquemaSeguroID = Par_EsquemaSeguroID
		AND   TipoPagoSeguro = Par_TipoPagoSeguro;

	END IF;

END TerminaStore$$