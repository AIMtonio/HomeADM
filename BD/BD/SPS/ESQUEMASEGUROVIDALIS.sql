-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMASEGUROVIDALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMASEGUROVIDALIS`;DELIMITER $$

CREATE PROCEDURE `ESQUEMASEGUROVIDALIS`(

	Par_ProducCreditoID		INT(11),
	Par_EsquemaSeguroID		INT(11),
	Par_NumLis				TINYINT UNSIGNED,


	Par_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT


	)
TerminaStore:BEGIN


	DECLARE Lis_Principal		INT;
	DECLARE Lis_PorProdCred		INT;
	DECLARE Lis_TipoPago		INT;
	DECLARE Lis_TipoPagoCred 	INT;

	DECLARE Estatus_Activo		CHAR(1);
	DECLARE Cadena_Vacia		CHAR(1);


	SET Lis_Principal			:=1;
	SET Lis_PorProdCred			:=2;
	SET Lis_TipoPago			:=3;
	SET Lis_TipoPagoCred		:=4;

	SET Estatus_Activo			:='A';
	SET Cadena_Vacia			:='';



		IF(Par_NumLis = Lis_Principal) THEN
			  SELECT EsquemaSeguroID, 	ProducCreditoID, 	TipoPagoSeguro,	FactorRiesgoSeguro,		DescuentoSeguro,
					 MontoPolSegVida
				FROM ESQUEMASEGUROVIDA;

		END IF;



		IF(Par_NumLis = Lis_PorProdCred) THEN
			  SELECT EsquemaSeguroID, 	ProducCreditoID,	TipoPagoSeguro,			FactorRiesgoSeguro,		DescuentoSeguro,
					 MontoPolSegVida
				FROM ESQUEMASEGUROVIDA
			  WHERE ProducCreditoID = Par_ProducCreditoID;
		END IF;


		IF(Par_NumLis = Lis_TipoPago) THEN
			  SELECT EsquemaSeguroID, 	ProducCreditoID,	TipoPagoSeguro,			FactorRiesgoSeguro,		DescuentoSeguro,
					 MontoPolSegVida,
				case TipoPagoSeguro when 'A' then 'ADELANTADO'
									when 'F' then 'FINANCIAMIENTO'
									when 'D' then 'DEDUCCION'
									when 'O' then 'OTRO'
				end as DescTipPago
				FROM ESQUEMASEGUROVIDA
			  WHERE ProducCreditoID = Par_ProducCreditoID;
		END IF;


	IF(Par_NumLis = Lis_TipoPagoCred) THEN
			  SELECT EsquemaSeguroID, 	ProducCreditoID,	TipoPagoSeguro,			FactorRiesgoSeguro,		DescuentoSeguro,
					 MontoPolSegVida,
				case TipoPagoSeguro when 'A' then 'ADELANTADO'
									when 'F' then 'FINANCIAMIENTO'
									when 'D' then 'DEDUCCION'
									when 'O' then 'OTRO'
				end as DescTipPago
				FROM ESQUEMASEGUROVIDA
			  WHERE ProducCreditoID = Par_ProducCreditoID;
		END IF;



END TerminaStore$$