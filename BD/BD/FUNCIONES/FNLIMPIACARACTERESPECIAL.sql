-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNLIMPIACARACTERESPECIAL
DELIMITER ;
DROP FUNCTION IF EXISTS `FNLIMPIACARACTERESPECIAL`;DELIMITER $$

CREATE FUNCTION `FNLIMPIACARACTERESPECIAL`(
/* FUNCION PARA LIMPIAR CARACTERES*/
	Par_Cadena			VARCHAR(150),		-- Cadena
	Tipo_Con			CHAR (1)			-- Tipo de consulta
) RETURNS varchar(70) CHARSET latin1
    DETERMINISTIC
BEGIN
	-- Declaracion de constantes
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Espacio_Vacio		CHAR(1);

	-- Declaracion de variables
	DECLARE Var_Control			VARCHAR(100);		-- Variable de control
	DECLARE Var_Str_Aux			VARCHAR(100);		-- Cadena auxiliar
	DECLARE Var_pos				INT(11);			-- Posicion del caracter
	DECLARE Var_CadFormada		VARCHAR(70);		-- cadena limpia
    DECLARE Var_Preposicion		VARCHAR(10);		-- Preposicion
	DECLARE Var_LongCadena		INT(11);			-- Longitud de la cadena
	DECLARE Var_ControlPrep		INT(11);
    DECLARE Var_Max				INT(11);			-- Numero maximo de preposiciones

	-- Asignacion de constantes
	SET Cadena_Vacia		:= '';					-- Cadena vacia
	SET Par_Cadena := REPLACE(Par_Cadena, 'Á', 'A');
	SET Par_Cadena := REPLACE(Par_Cadena, 'É', 'E');
	SET Par_Cadena := REPLACE(Par_Cadena, 'Í', 'I');
	SET Par_Cadena := REPLACE(Par_Cadena, 'Ó', 'O');
	SET Par_Cadena := REPLACE(Par_Cadena, 'Ú', 'U');

	IF(Tipo_Con = '3')THEN
		SET Var_pos		:= 1;
		SET Var_Str_Aux	:= '';

		WHILE(Var_pos<=LENGTH(Par_Cadena)) DO
			SET Var_Str_Aux := CONCAT(Var_Str_Aux,SUBSTR(Par_Cadena,Var_pos,1));

			IF(SUBSTR(Par_Cadena,Var_pos,1)=' ') THEN
				SET Var_pos := Var_pos+1;
				WHILE(SUBSTR(Par_Cadena,Var_pos,1) =' ' AND Var_pos < LENGTH(Par_Cadena)) DO
					SET Var_pos:=Var_pos+1;
				END WHILE;
			  ELSE
				SET Var_pos:=Var_pos+1;
			END IF;
		END WHILE;

		SET Par_Cadena := LTRIM(RTRIM(Var_Str_Aux));
		SET Var_CadFormada := RTRIM(LTRIM(Par_Cadena));
	  ELSE
		SET Par_Cadena := UPPER(Par_Cadena);
		SET Par_Cadena := REPLACE(Par_Cadena, 'Ã‚Â¤', 'Ãƒâ€˜');
		SET Par_Cadena := REPLACE(Par_Cadena, '?', 'Ãƒâ€˜');
		SET Par_Cadena := REPLACE(Par_Cadena, 'ÃƒÂ', 'A');
		SET Par_Cadena := REPLACE(Par_Cadena, 'Ãƒâ€°', 'E');
		SET Par_Cadena := REPLACE(Par_Cadena, 'ÃƒÂ', 'I');
		SET Par_Cadena := REPLACE(Par_Cadena, 'Ãƒâ€œ', 'O');
		SET Par_Cadena := REPLACE(Par_Cadena, 'ÃƒÅ¡', 'U');
		SET Par_Cadena := REPLACE(Par_Cadena, '.', '');
		SET Par_Cadena := REPLACE(Par_Cadena, ',', '');
		SET Par_Cadena := REPLACE(Par_Cadena, 'Á', 'A');
		SET Par_Cadena := REPLACE(Par_Cadena, 'É', 'E');
		SET Par_Cadena := REPLACE(Par_Cadena, 'Í', 'I');
		SET Par_Cadena := REPLACE(Par_Cadena, 'Ó', 'O');
		SET Par_Cadena := REPLACE(Par_Cadena, 'Ú', 'U');


		IF(Tipo_Con='2') THEN
			SELECT MAX(PreposicionID)
			INTO Var_Max
			FROM CATPREPOSICIONES;

            SET Var_ControlPrep := 1;

			WHILE Var_ControlPrep <= Var_Max DO
				SELECT Preposicion
					INTO Var_Preposicion
					FROM CATPREPOSICIONES
					WHERE PreposicionID = Var_ControlPrep;

					SET Var_LongCadena := CHAR_LENGTH(Var_Preposicion);
					IF Var_Preposicion IS NOT NULL THEN
						SET Par_Cadena := CONCAT(Par_Cadena,' ');
						SET Par_Cadena := REPLACE(Par_Cadena, CONCAT(' ',Var_Preposicion,' '), ' ');

						IF( SUBSTR(Par_Cadena, 1, Var_LongCadena+1) = CONCAT(Var_Preposicion, ' ')) THEN
						SET	Par_Cadena := SUBSTR(Par_Cadena, Var_LongCadena+2, LENGTH(Par_Cadena));

						END IF;
                         SET Par_Cadena := RTRIM(Par_Cadena);
					END IF;
					SET Var_ControlPrep	:= Var_ControlPrep + 1;

			END WHILE;

		END IF;


		IF(Tipo_Con<>'1') THEN
			SET Par_Cadena := REPLACE(Par_Cadena, ' DE ', ' ');
			SET	Par_Cadena := REPLACE(Par_Cadena, ' DEL ', ' ');
			SET	Par_Cadena := REPLACE(Par_Cadena, ' LA ', ' ');
			SET	Par_Cadena := REPLACE(Par_Cadena, ' LOS ', ' ');
			SET	Par_Cadena := REPLACE(Par_Cadena, ' LAS ', ' ');
			SET	Par_Cadena := REPLACE(Par_Cadena, ' Y ', ' ');
			SET	Par_Cadena := REPLACE(Par_Cadena, ' MC ', ' ');
			SET	Par_Cadena := REPLACE(Par_Cadena, ' MAC ', ' ');

			IF( SUBSTR(Par_Cadena, 1, 3) = 'DE ' ) THEN
				SET	Par_Cadena := SUBSTR(Par_Cadena, 4, LENGTH(Par_Cadena));
			END IF;
			IF( SUBSTR(Par_Cadena, 1, 4) = 'DEL ' )THEN
				SET	Par_Cadena := SUBSTR(Par_Cadena, 5, LENGTH(Par_Cadena));
			END IF;
			IF( SUBSTR(Par_Cadena, 1, 3) = 'LA ' ) THEN
				SET	Par_Cadena := SUBSTR(Par_Cadena, 4, LENGTH(Par_Cadena));
			END IF;
			IF( SUBSTR(Par_Cadena, 1, 4) = 'LOS ' ) THEN
				SET	Par_Cadena := SUBSTR(Par_Cadena, 5, LENGTH(Par_Cadena));
			END IF;
			IF( SUBSTR(Par_Cadena, 1, 4) = 'LAS ' ) THEN
				SET	Par_Cadena := SUBSTR(Par_Cadena, 5, LENGTH(Par_Cadena));
			END IF;
			IF( SUBSTR(Par_Cadena, 1, 2) = 'Y ' ) THEN
				SET	Par_Cadena := SUBSTR(Par_Cadena, 3, LENGTH(Par_Cadena));
				SET	Par_Cadena := RTRIM(LTRIM(Par_Cadena));
			END IF;
			IF( SUBSTR(Par_Cadena, 1, 3) = 'MC ' ) THEN
				SET	Par_Cadena := SUBSTR(Par_Cadena, 4, LENGTH(Par_Cadena));
			END IF;
			IF( SUBSTR(Par_Cadena, 1, 4) = 'MAC ' ) THEN
				SET	Par_Cadena := SUBSTR(Par_Cadena, 5, LENGTH(Par_Cadena));
			END IF;

		END IF;
		SET Var_CadFormada := RTRIM(LTRIM(Par_Cadena));
	END IF;

	RETURN Var_CadFormada;
END$$