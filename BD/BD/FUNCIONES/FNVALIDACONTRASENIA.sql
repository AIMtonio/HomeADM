-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNVALIDACONTRASENIA
DELIMITER ;
DROP FUNCTION IF EXISTS `FNVALIDACONTRASENIA`;DELIMITER $$

CREATE FUNCTION `FNVALIDACONTRASENIA`(
	Par_Contrasenia VARCHAR(100)
) RETURNS varchar(100) CHARSET latin1
    DETERMINISTIC
BEGIN


	-- Declaracion de Variables.
	DECLARE Var_Validacion			VARCHAR(100);
	DECLARE Var_Caracter			CHAR(1);
	DECLARE	Var_Longitud			TINYINT;
	DECLARE	Var_Posicion			TINYINT;
	DECLARE Var_UnaMinus			CHAR(1);
	DECLARE Var_UnaMayus			CHAR(1);
	DECLARE Var_UnDigito			CHAR(1);
	DECLARE Var_CaracterEsp			CHAR(1);


	-- Declaracion de Constantes.
	DECLARE Cadena_Vacia			CHAR(1);					-- Cadena Vacia
	DECLARE Entero_Cero				INT(11);					-- Entero Cero
	DECLARE LongitudMin				TINYINT UNSIGNED;			-- Longitud Minima de la contraseña
	DECLARE LongitudMax				TINYINT UNSIGNED;			-- Longitud Maxima de la contraseña
	DECLARE Letra_S					CHAR(1);					-- Letra S
	DECLARE Letra_N					CHAR(1);					-- Letra N
	DECLARE ASCII_MayusA			TINYINT UNSIGNED;			-- Codigo Ascii de las Letra A Mayuscula
	DECLARE ASCII_MayusZ			TINYINT UNSIGNED;			-- Codigo Ascii de las Letra Z Mayuscula
	DECLARE ASCII_a					TINYINT UNSIGNED;			-- Codigo Ascii de las Letra a Minuscula
	DECLARE ASCII_z					TINYINT UNSIGNED;			-- Codigo Ascii de las Letra z Minuscula
	DECLARE ASCII_0					TINYINT UNSIGNED;			-- Codigo Ascii del numero 0
	DECLARE ASCII_9					TINYINT UNSIGNED;			-- Codigo Ascii del numero 9
	DECLARE ASCII_EnieMayus			TINYINT UNSIGNED;			-- Codigo Ascii de las Letra Ñ Mayuscula
	DECLARE ASCII_EnieMin			TINYINT UNSIGNED;			-- Codigo Ascii de las Letra ñ Minuscula


	-- Asignacion de Constantes
	SET Cadena_Vacia				:= '';						-- Cadena Vacia
	SET Entero_Cero					:= 0;						-- Entero Cero
	SET LongitudMin					:= 8;						-- Longitud Minima de la contraseña
	SET LongitudMax					:= 16;						-- Longitud Maxima de la contraseña

	SET	ASCII_MayusA				:= 65;						-- Codigo Ascii de las Letra A Mayuscula
	SET	ASCII_MayusZ				:= 90;						-- Codigo Ascii de las Letra Z Mayuscula
	SET	ASCII_a						:= 97;						-- Codigo Ascii de las Letra a Minuscula
	SET	ASCII_z						:= 122;						-- Codigo Ascii de las Letra z Minuscula
	SET	ASCII_0						:= 48;						-- Codigo Ascii del numero 0
	SET	ASCII_9						:= 57;						-- Codigo Ascii del numero 9
	SET	ASCII_EnieMayus				:= 165;						-- Codigo Ascii de las Letra Ñ
	SET	ASCII_EnieMin				:= 164;						-- Codigo Ascii de las Letra ñ
	SET Letra_S						:= 'S';						-- Letra S
	SET Letra_N						:= 'N';						-- Letra N


	SET	Var_UnaMinus				:= 'N';						-- Bandera que indica si la contraseña contiene al Menos una Minuscula
	SET	Var_UnaMayus				:= 'N';						-- Bandera que indica si la contraseña contiene al Menos una Mayuscula
	SET	Var_UnDigito				:= 'N';						-- Bandera que indica si la contraseña contiene al Menos un Digito
	SET	Var_CaracterEsp				:= 'N';						-- Bandera que indica si la contraseña contiene al Menos un caracter Especial

		/*
			CONDICIONES QUE SE DEBEN CUMPLIR PARA CONSIDERAR UNA CONTRASEÑA VALIDA

			- Longitud Minima de 8  Caracteres
			- Longitud MÃ¡xima de 16 Caracteres
			- Al menos una letra mayuscula
			- Al menos una letra minucula
			- Al menos un digito
			- No espacios en blanco
			- No Caracteres especiales
		*/

	ManejoErrores: BEGIN

			SET Var_Longitud		:= LENGTH(Par_Contrasenia) ;
			SET Var_Longitud		:= IFNULL(Var_Longitud, Entero_Cero);
			SET Var_Posicion		:= 1;

			IF (Var_Longitud < LongitudMin 	OR 	Var_Longitud > LongitudMax) THEN
					SET	Var_Validacion	:= CONCAT('La longitud de la contraseña es incorrecta, se espera un minimo de ', CAST(LongitudMin AS CHAR) ,' caracteres y un maximo de ', CAST(LongitudMax AS CHAR) );
					LEAVE ManejoErrores;
			END IF;


			ciclo: WHILE (Var_Posicion <= Var_Longitud) DO


					SET	Var_Caracter	:= SUBSTRING(Par_Contrasenia, Var_Posicion, 1 );


					SET	Var_Posicion := Var_Posicion + 1;


					IF (ASCII(Var_Caracter) >= ASCII_a AND ASCII(Var_Caracter) <= ASCII_z) OR ASCII(Var_Caracter) = ASCII_EnieMin THEN
							SET Var_UnaMinus := Letra_S;
							ITERATE ciclo;
					END IF;


					IF (ASCII(Var_Caracter) >= ASCII_MayusA AND ASCII(Var_Caracter) <= ASCII_MayusZ) OR ASCII(Var_Caracter) = ASCII_EnieMayus THEN
							SET Var_UnaMayus := Letra_S;
							ITERATE ciclo;
					END IF;

					IF ASCII(Var_Caracter) >= ASCII_0 AND ASCII(Var_Caracter) <= ASCII_9 THEN
							SET Var_UnDigito := Letra_S;
							ITERATE ciclo;
					END IF;


					IF 			!(  ASCII(Var_Caracter) >= ASCII_0 AND ASCII(Var_Caracter) <= ASCII_9)
							AND !( (ASCII(Var_Caracter) >= ASCII_a AND ASCII(Var_Caracter) <= ASCII_z) OR ASCII(Var_Caracter) = ASCII_EnieMin )
							AND !( (ASCII(Var_Caracter) >= ASCII_MayusA AND ASCII(Var_Caracter) <= ASCII_MayusZ) OR ASCII(Var_Caracter) = ASCII_EnieMayus )THEN

							SET Var_CaracterEsp := Letra_S;

					END IF;



			END WHILE ciclo;

			IF Var_UnaMinus	= Letra_N OR Var_UnaMayus	= Letra_N OR Var_UnDigito	= Letra_N	 OR Var_CaracterEsp = Letra_S	 THEN
					SET	Var_Validacion	:= 'La clave no cumple con los requisitos minimos solicitados.';
					LEAVE ManejoErrores;
			END IF;



			SET	Var_Validacion	:= 'EXITO';

	END ManejoErrores; -- Fin del bloque manejo de errores


RETURN Var_Validacion;

END$$