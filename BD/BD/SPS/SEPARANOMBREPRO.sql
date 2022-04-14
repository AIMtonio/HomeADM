
DELIMITER ;
DROP PROCEDURE IF EXISTS SEPARANOMBREPRO;

delimiter $$
CREATE PROCEDURE SEPARANOMBREPRO(
-- SP PARA SEPARAR EL NOMBRE
	Par_NombreCompleto 			VARCHAR(500),
	INOUT Par_PrimerNombre 		VARCHAR(400),
	INOUT Par_SegundoNombre 	VARCHAR(400),
	INOUT Par_ApellidoPaterno 	VARCHAR(400),
	INOUT Par_ApellidoMaterno 	VARCHAR(400),

	Par_Salida           		CHAR(1),
	INOUT Par_NumErr     		INT,
	INOUT Par_ErrMen     		VARCHAR(400),


	Par_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)

)TERMINASTORE:BEGIN

DECLARE Var_PrimerNombre 		VARCHAR(400);
DECLARE Var_SegundoNombre 		VARCHAR(400);
DECLARE Var_ApellidoPaterno 	VARCHAR(400);
DECLARE Var_ApellidoMaterno 	VARCHAR(400);
DECLARE Var_PosCortar			INT;
DECLARE Var_TipoNombre			INT;

DECLARE Maximo_Cadena			INT;
DECLARE Pos_Puntero 			INT;
DECLARE Var_Caracter		 	VARCHAR(2);
DECLARE Var_CaracterAnt 		VARCHAR(2);
DECLARE Var_Texto				VARCHAR(200);
DECLARE Salida_SI				CHAR(1);


SET Salida_SI 					:= 'S';

MANEJOERRORES:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SEPARANOMBREPRO');
            SET Par_PrimerNombre 	 	:= '';
			SET Par_SegundoNombre  		:= '';
			SET Par_ApellidoPaterno  	:= '';
			SET Par_ApellidoMaterno  	:= '';

		END;
SET Par_NombreCompleto := UPPER(TRIM(Par_NombreCompleto));
SET Par_NombreCompleto := SUBSTR(Par_NombreCompleto,1,200);
SET Maximo_Cadena:= LENGTH(Par_NombreCompleto);
SET Pos_Puntero := 1;
SET Var_Texto := '';
SET Var_TipoNombre := 1;
SET Var_CaracterAnt := '';

SET Var_PrimerNombre := '';
SET Var_SegundoNombre := '';
SET Var_ApellidoPaterno := '';
SET Var_ApellidoMaterno := '';

WHILE Pos_Puntero <= Maximo_Cadena DO
CICLONOMBRE:BEGIN
	IF LOCATE(' ',SUBSTR(Par_NombreCompleto,Pos_Puntero)) = 0 THEN
		IF LENGTH(Var_PrimerNombre)> 0 THEN
			IF LENGTH(Var_SegundoNombre)> 0 THEN
				IF LENGTH(Var_ApellidoPaterno)> 0 THEN
					SET Var_ApellidoMaterno := SUBSTR(Par_NombreCompleto,Pos_Puntero);
				ELSE
					SET Var_ApellidoPaterno := SUBSTR(Par_NombreCompleto,Pos_Puntero);
				END IF;
			ELSE
				SET Var_SegundoNombre := SUBSTR(Par_NombreCompleto,Pos_Puntero);
            END IF;
		ELSE
			SET Var_PrimerNombre :=  SUBSTR(Par_NombreCompleto,Pos_Puntero);
        END IF;

		SET Pos_Puntero := Maximo_Cadena + 1;
        LEAVE CICLONOMBRE;
    END IF;

	SET Var_Caracter := SUBSTR(Par_NombreCompleto,Pos_Puntero,1);

    IF Var_CaracterAnt = ' ' AND Var_Caracter = ' ' THEN
		LEAVE CICLONOMBRE;
    END IF;


    IF Var_Caracter = ' ' AND LENGTH(Var_Texto) > 3 AND Var_TipoNombre = 1 THEN
		SET Var_PrimerNombre := TRIM(Var_Texto);
        SET Var_Texto := '';
        SET Var_TipoNombre := 2;
    END IF;

    IF Var_Caracter = ' ' AND LENGTH(Var_Texto) > 3 AND Var_TipoNombre = 2 THEN
		SET Var_SegundoNombre := TRIM(Var_Texto);
        SET Var_Texto := '';
        SET Var_TipoNombre := 3;
    END IF;

    IF Var_Caracter = ' ' AND LENGTH(Var_Texto) > 3 AND Var_TipoNombre = 3 THEN
		SET Var_ApellidoPaterno := TRIM(Var_Texto);
        SET Var_ApellidoMaterno := SUBSTR(TRIM(Par_NombreCompleto),(Pos_Puntero+1));
        SET Var_Texto := '';
        SET Pos_Puntero := Maximo_Cadena + 1;
    END IF;

    SET Var_Texto := CONCAT(Var_Texto,Var_Caracter);
    SET Var_CaracterAnt := Var_Caracter;
END CICLONOMBRE;
    SET Pos_Puntero := Pos_Puntero +1;
END WHILE;


IF Var_ApellidoPaterno = '' AND Var_SegundoNombre != '' THEN
	SET Var_ApellidoPaterno := Var_SegundoNombre;
    SET Var_SegundoNombre   := '';
END IF;

IF Var_ApellidoPaterno = '' AND Var_SegundoNombre = '' THEN
	SET Var_ApellidoPaterno := 'X';
END IF;

SET Par_PrimerNombre 	 	:= SUBSTR(Var_PrimerNombre,1,50);
SET Par_SegundoNombre  		:= SUBSTR(Var_SegundoNombre,1,50);
SET Par_ApellidoPaterno  	:= SUBSTR(Var_ApellidoPaterno,1,50);
SET Par_ApellidoMaterno  	:= SUBSTR(Var_ApellidoMaterno,1,50);


END MANEJOERRORES;

IF Par_Salida = Salida_SI THEN
	SELECT Par_NumErr AS NumErr,
    Par_ErrMen AS ErrMen,
	Var_PrimerNombre 	AS PrimerNombre,
	Var_SegundoNombre 	AS SegundoNombre,
	Var_ApellidoPaterno AS ApellidoPaterno ,
	Var_ApellidoMaterno AS ApellidoMaterno ;
END IF;

END TERMINASTORE$$
