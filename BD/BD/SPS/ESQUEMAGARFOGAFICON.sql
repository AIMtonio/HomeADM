-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMAGARFOGAFICON
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMAGARFOGAFICON`;DELIMITER $$

CREATE PROCEDURE `ESQUEMAGARFOGAFICON`(
-- ===============================================================
-- SP PARA CONSULTAR LOS ESQUEMAS de FOGAFI
-- ===============================================================
	Par_ProducCreditoID		INT(11),			# Indica Número de Producto de Crédito
	Par_ClienteID			INT(10),			# Indica Número de Cliente
	Par_Calificacion		CHAR(1),			# Indica Clasificación del Cliente
	Par_Monto				DECIMAL(14,2),		# Indica Monto del Crédito

	Par_NumCon				TINYINT UNSIGNED,	# Indica Número de Consulta

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

	/* Declaracion de Variables */
	DECLARE Var_CalificaCredito		CHAR(1);	# Indica Clasificación de Crédito

	/* Declaracion de Constantes */
	DECLARE Con_Principal		INT;		# Tipo de Consulta Principal

	DECLARE NoAsignada			CHAR(1);	# Constante: No Asignada
	DECLARE Cadena_Vacia		CHAR(1);	# Constante: Cadena Vacía
	DECLARE Entero_Cero			INT(1);		# Constante: Entero Cero

	/* Asignación de Constantes */
	SET Con_Principal			:=2;		# Constante: Consutal Principal
	SET NoAsignada				:='N';		# Constante: No Asignada
	SET Cadena_Vacia			:=''; 		# Constante: Cadena Vacía
	SET Entero_Cero				:=0;		# Constante: Entero Cero


	IF(Par_NumCon = Con_Principal) THEN
		IF(IFNULL(Par_ClienteID,Entero_Cero) > Entero_Cero)THEN
			SET Var_CalificaCredito	:= (SELECT IFNULL(CalificaCredito,NoAsignada) FROM CLIENTES WHERE ClienteID = Par_ClienteID);
			SELECT  Esq.EsquemaGarFogafiID,		Esq.ProducCreditoID,		Esq.Clasificacion,			FORMAT(Esq.LimiteInferior,2) AS LimiteInferior,
					FORMAT(Esq.LimiteSuperior,2) AS LimiteSuperior,			FORMAT(Esq.Porcentaje,2) AS Porcentaje
			FROM	ESQUEMAGARFOGAFI Esq
			WHERE	ProducCreditoID = Par_ProducCreditoID
					AND Esq.Clasificacion = Var_CalificaCredito
					AND Par_Monto BETWEEN Esq.LimiteInferior AND LimiteSuperior
			LIMIT 1;
		ELSE
			SET Var_CalificaCredito := Par_Calificacion;
			SELECT  Esq.EsquemaGarFogafiID,		Esq.ProducCreditoID,		Esq.Clasificacion,			FORMAT(Esq.LimiteInferior,2) AS LimiteInferior,
					FORMAT(Esq.LimiteSuperior,2) AS LimiteSuperior,			FORMAT(Esq.Porcentaje,2) AS Porcentaje
			FROM	ESQUEMAGARFOGAFI Esq
			WHERE	ProducCreditoID = Par_ProducCreditoID
					AND Esq.Clasificacion = Var_CalificaCredito
					AND Par_Monto BETWEEN Esq.LimiteInferior AND LimiteSuperior
			LIMIT 1;
		END IF;

	END IF;

END TerminaStore$$