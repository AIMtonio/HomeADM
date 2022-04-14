-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMAGARANTIALIQLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMAGARANTIALIQLIS`;DELIMITER $$

CREATE PROCEDURE `ESQUEMAGARANTIALIQLIS`(
-- --------------------------------------------------------------------------------
-- lista de esquemas de garantia liquida para Productos de Credito
-- --------------------------------------------------------------------------------
	/* declaracion de parametros */
	Par_ProducCreditoID		INT(11),			# ID del producto de credito
	Par_NumLis				TINYINT UNSIGNED,	# no. del tipo de lista que se requiera

	/* parametros de auditoria */
	Par_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
	)
TerminaStore:BEGIN 	#bloque main del sp

	/* declaracion de variables*/

	/* declaracion de constantes*/
	DECLARE Lis_Principal		INT;
	DECLARE Lis_PorProdCred		INT;

	DECLARE Estatus_Activo		CHAR(1);		# Estatus activo
	DECLARE Cadena_Vacia		CHAR(1);		# Cadena vacia

	/* asignacion de constantes*/
	SET Lis_Principal			:=1;
	SET Lis_PorProdCred			:=2;

	SET Estatus_Activo			:='A';
	SET Cadena_Vacia			:='';


	/* Lista principal*/
		IF(Par_NumLis = Lis_Principal) THEN
			  SELECT EsquemaGarantiaLiqID, 	ProducCreditoID, 	Clasificacion
				FROM ESQUEMAGARANTIALIQ;

		END IF;

	/* Lista los esquemas por producto de credito para grid*/
		IF(Par_NumLis = Lis_PorProdCred) THEN
			 SELECT EsquemaGarantiaLiqID,	ProducCreditoID, 		Clasificacion,
					FORMAT(LimiteInferior,2) AS LimiteInferior,		FORMAT(LimiteSuperior,2) AS LimiteSuperior,
					FORMAT(Porcentaje,2) AS Porcentaje,	FORMAT(BonificacionFOGA,2) AS BonificacionFOGA
				FROM ESQUEMAGARANTIALIQ
			 WHERE ProducCreditoID = Par_ProducCreditoID;
		END IF;


	END TerminaStore$$