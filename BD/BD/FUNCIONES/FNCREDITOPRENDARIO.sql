DELIMITER ;
DROP FUNCTION IF EXISTS FNCREDITOPRENDARIO;

DELIMITER $$
CREATE FUNCTION `FNCREDITOPRENDARIO`(
	-- Fuction: Que Consulta Determina si el Credito Tiene una Garantia de Tipo Prendaria utilizado en el SP-CRECALCULOSALDOSPRO
	-- Modulo Extraccion Proceso Batch Nocturno
	Par_CreditoID		BIGINT(12)	-- ID Del Credito Reestrucurado o Renovado
) RETURNS CHAR(1) CHARSET latin1
DETERMINISTIC
BEGIN

	-- Declaracion de Variables
	DECLARE Var_EsPrendario		CHAR(1);		-- Verifica si el Credito es de Tipo Prendario
	DECLARE Num_Garantias		INT(11);		-- Numero de Garantias Prendarias

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);		-- Constante Cadena Vacia
	DECLARE Entero_Cero			INT(11);		-- Constante Entero Cero
	DECLARE GarantiaPrendaria	INT(11);		-- Tipo de Garantia Prendaria
	DECLARE Con_NO				CHAR(1);		-- Constante NO
	DECLARE Con_SI				CHAR(1);		-- Constante SI

	-- Asignacion de Variables
	SET Cadena_Vacia			:= '';
	SET Entero_Cero				:= 0;
	SET GarantiaPrendaria		:= 2;
	SET Con_NO					:= 'N';
	SET Con_SI					:= 'S';

	SELECT IFNULL(COUNT(Asig.GarantiaID), Entero_Cero)
	INTO Num_Garantias
	FROM ASIGNAGARANTIAS Asig
	INNER JOIN GARANTIAS Gar ON Asig.GarantiaID = Gar.GarantiaID
	WHERE Asig.CreditoID = Par_CreditoID
	  AND Gar.TipoGarantiaID = GarantiaPrendaria;

	SET Num_Garantias := IFNULL(Num_Garantias, Entero_Cero);
	SET Var_EsPrendario := Con_NO;

	IF( Num_Garantias > Entero_Cero ) THEN
		SET Var_EsPrendario := Con_SI;
	END IF;

	RETURN Var_EsPrendario;

END$$
