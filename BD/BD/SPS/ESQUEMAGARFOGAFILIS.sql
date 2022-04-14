-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMAGARFOGAFILIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMAGARFOGAFILIS`;DELIMITER $$

CREATE PROCEDURE `ESQUEMAGARFOGAFILIS`(
-- ==================================================================
-- SP PARA LISTAS LOS ESQUEMAS PARA FOGAFI
-- ==================================================================
	Par_ProducCreditoID		INT(11),				# Indica el Número de Producto de Crédito
	Par_NumLis				TINYINT UNSIGNED,		# Indica el Tipo de Lista

	# Parametros de Auditoria
	Par_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
	)
TerminaStore:BEGIN
	/* Declaracion de Constantes */
	DECLARE Lis_Principal		INT;		# Constante: Lista Principal
	DECLARE Lis_PorProdCred		INT; 		# Constante: Lista por Producto de Crédito

	DECLARE Estatus_Activo		CHAR(1);	# Constante: Estatus Activo
	DECLARE Cadena_Vacia		CHAR(1);	# Constante: Cadena Vacía

	/* Asignación de Constantes*/
	SET Lis_Principal			:=3;		# Constante: Lista Principal
	SET Lis_PorProdCred			:=4;		# Constante: Lista por Producto de Crédito

	SET Estatus_Activo			:='A';		# Constante: Estatus Activo
	SET Cadena_Vacia			:='';		# Constante: Cadena Vacía


	IF(Par_NumLis = Lis_Principal) THEN
		  SELECT EsquemaGarFogafiID, 	ProducCreditoID, 	Clasificacion
			FROM ESQUEMAGARFOGAFI;

	END IF;

	IF(Par_NumLis = Lis_PorProdCred) THEN
		 SELECT EsquemaGarFogafiID,	ProducCreditoID, 		Clasificacion,
				FORMAT(LimiteInferior,2) AS LimiteInferior,		FORMAT(LimiteSuperior,2) AS LimiteSuperior,
				FORMAT(Porcentaje,2) AS Porcentaje,	FORMAT(BonificacionFOGAFI,2) AS BonificacionFOGAFI
			FROM ESQUEMAGARFOGAFI
		 WHERE ProducCreditoID = Par_ProducCreditoID;
	END IF;

END TerminaStore$$