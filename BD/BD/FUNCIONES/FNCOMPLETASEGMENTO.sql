-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNCOMPLETASEGMENTO
DELIMITER ;
DROP FUNCTION IF EXISTS `FNCOMPLETASEGMENTO`;

DELIMITER $$
CREATE FUNCTION `FNCOMPLETASEGMENTO`(
	-- Funcion para completar los segmentos de buro de credito
	Par_Segmento 		CHAR(2),		-- Segmento a Ajusta
	Par_SegmentoMaximo	INT(11),		-- Maximo Segmento a Iterar
	Par_NumeroSegmentos	INT(11)		-- Maximo Segmento a Iterar
	-- Par_Texto 			TEXT			-- Texto del Segmento
) RETURNS TEXT CHARSET latin1
    DETERMINISTIC
BEGIN
	-- Declaracion de Variables
	DECLARE Var_NumIteraciones	INT(11);	-- Numero de Iteraciones
	DECLARE Var_Contador 		INT(11);	-- Contador de Iteraciones
	DECLARE Var_Texto 			VARCHAR(10000);
	-- Declaracion de Constantes
	DECLARE Cadena_Vacia 		CHAR(1);	-- Constante Cadena Vacia
	DECLARE SegmentoAccionista 	CHAR(2);	-- Constante Segmento Accionista
	DECLARE Entero_Cero			INT(11);	-- Constante Entero Vacio
	DECLARE Entero_Uno			INT(11);	-- Constante Entero Uno
	DECLARE SegAccionistaVacio 	VARCHAR(30);-- Segmento de Accionista Vacio
	DECLARE Par_Texto 			TEXT;		-- Segmento de Texto

	-- Asignacion de Constantes
	SET Cadena_Vacia			:= '';
	SET SegmentoAccionista		:= 'AC';
	SET Entero_Cero				:= 0;
	SET Entero_Uno				:= 1;
	SET SegAccionistaVacio 		:= 'AC,,,,,,,,,,,,,,,,,,,,,,,';
	SET Var_Contador 			:= 1;

	SET Par_Texto := IFNULL(Par_Texto, Cadena_Vacia);
	SET Var_Texto := Cadena_Vacia;

	-- Obtengo el numero de Iteraciones del segmento a concatenar
	SET Var_NumIteraciones := IFNULL( (Par_SegmentoMaximo - Par_NumeroSegmentos ) , Entero_Cero);

	IF( Par_Segmento = SegmentoAccionista ) THEN

		IF( Var_NumIteraciones > Entero_Cero ) THEN
			WHILE ( Var_Contador <= Var_NumIteraciones ) DO
				IF( Var_NumIteraciones = Var_Contador) THEN
					SET SegAccionistaVacio 		:= 'AC,,,,,,,,,,,,,,,,,,,,,,';
				END IF;

				SET Var_Texto := CONCAT( Var_Texto, SegAccionistaVacio );
				SET Var_Contador := Var_Contador + Entero_Uno;
			END WHILE;
		END IF;

	END IF;

	SET Par_Texto := Var_Texto;

	RETURN Par_Texto;
END$$
