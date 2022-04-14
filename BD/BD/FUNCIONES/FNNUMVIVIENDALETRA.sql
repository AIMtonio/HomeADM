-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNNUMVIVIENDALETRA
DELIMITER ;
DROP FUNCTION IF EXISTS `FNNUMVIVIENDALETRA`;DELIMITER $$

CREATE FUNCTION `FNNUMVIVIENDALETRA`(
	Par_numViv VARCHAR(255)
    ) RETURNS varchar(255) CHARSET latin1
    DETERMINISTIC
BEGIN
		DECLARE Var_Posicion INT(2) DEFAULT 0;
        DECLARE Var_Longitud INT(11) DEFAULT 0;
        DECLARE Var_Aux CHAR(1);
        DECLARE Var_Num VARCHAR(5) DEFAULT '';
        DECLARE Var_Cadena3 VARCHAR(255);

		SET Var_Longitud = LENGTH(Par_numViv);
        SET Var_Cadena3 ='';

        IF(Par_numViv!='' OR Par_numViv!=NULL )THEN
				SET Var_Posicion = 1;
				checkString:WHILE Var_Posicion <= Var_Longitud DO
					SET Var_Aux =  SUBSTR(Par_numViv,Var_Posicion,1);
					IF(Var_Aux REGEXP '[0-9]') THEN
						SET Var_Num = CONCAT(Var_Num,Var_Aux);
                        IF(Var_Posicion = Var_Longitud)THEN
							SET Var_Cadena3= CONCAT(Var_Cadena3,' ',FUNCIONSOLONUMLETRAS(Var_Num));
                        END IF;
                    ELSE
                        IF(Var_Num='') THEN
							SET Var_Cadena3= CONCAT(Var_Cadena3,Var_Aux);
						ELSE
							SET Var_Cadena3= CONCAT(Var_Cadena3,' ',FUNCIONSOLONUMLETRAS(Var_Num),Var_Aux);
                            SET Var_Num='';
                        END IF;
                    END IF;
					SET Var_Posicion := Var_Posicion + 1;
				END WHILE;
		ELSE
			SET Var_Cadena3='';
        END IF;
		RETURN UPPER(Var_Cadena3);
END$$