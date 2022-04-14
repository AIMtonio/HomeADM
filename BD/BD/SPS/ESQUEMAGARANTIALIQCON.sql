-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMAGARANTIALIQCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMAGARANTIALIQCON`;DELIMITER $$

CREATE PROCEDURE `ESQUEMAGARANTIALIQCON`(




	Par_ProducCreditoID		INT(11),
	Par_ClienteID			INT(10),
	Par_Calificacion		CHAR(1),
	Par_Monto				DECIMAL(14,2),

	Par_NumCon				TINYINT UNSIGNED,


	Par_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
	)
TerminaStore:BEGIN


	DECLARE Var_CalificaCredito		CHAR(1);



	DECLARE Con_Principal		INT;

	DECLARE NoAsignada			CHAR(1);
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Entero_Cero			INT(1);


	SET Con_Principal			:=1;

	SET NoAsignada				:='N';
	SET Cadena_Vacia			:='';
	SET Entero_Cero				:=0;



		IF(Par_NumCon = Con_Principal) THEN
			IF(IFNULL(Par_ClienteID,Entero_Cero) > Entero_Cero)THEN
				SET Var_CalificaCredito	:= (SELECT IFNULL(CalificaCredito,NoAsignada) FROM CLIENTES WHERE ClienteID = Par_ClienteID);
				SELECT  Esq.EsquemaGarantiaLiqID,		Esq.ProducCreditoID,		Esq.Clasificacion,			FORMAT(Esq.LimiteInferior,2) AS LimiteInferior,
						FORMAT(Esq.LimiteSuperior,2) AS LimiteSuperior,			FORMAT(Esq.Porcentaje,2) AS Porcentaje
				FROM	ESQUEMAGARANTIALIQ Esq
				WHERE	ProducCreditoID = Par_ProducCreditoID
						AND Esq.Clasificacion = Var_CalificaCredito
						AND Par_Monto BETWEEN Esq.LimiteInferior AND LimiteSuperior
				LIMIT 1;
			ELSE
				SET Var_CalificaCredito := NoAsignada;
				SELECT  Esq.EsquemaGarantiaLiqID,		Esq.ProducCreditoID,		Esq.Clasificacion,			FORMAT(Esq.LimiteInferior,2) AS LimiteInferior,
						FORMAT(Esq.LimiteSuperior,2) AS LimiteSuperior,			FORMAT(Esq.Porcentaje,2) AS Porcentaje
				FROM	ESQUEMAGARANTIALIQ Esq
				WHERE	ProducCreditoID = Par_ProducCreditoID
						AND Esq.Clasificacion = Var_CalificaCredito
						AND Par_Monto BETWEEN Esq.LimiteInferior AND LimiteSuperior
				LIMIT 1;
			END IF;

		END IF;

	END TerminaStore$$