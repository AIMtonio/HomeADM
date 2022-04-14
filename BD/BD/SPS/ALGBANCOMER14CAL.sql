-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ALGBANCOMER14CAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `ALGBANCOMER14CAL`;
DELIMITER $$

CREATE PROCEDURE `ALGBANCOMER14CAL`(
	/*
	* SP QUE GENERA LA REFERENCIA BANCOMER PARA ALGORITMO 14(1 DIGITO VERIFICADOR)
	*/
	Par_InstitucionID 		INT(11),		-- ID de la institucion
	Par_Referencia			VARCHAR(14),	-- Referencia
	INOUT Par_NuevaRefe		VARCHAR(15),	-- Nueva Referencia

	Par_Salida				CHAR(1),		-- Parametro de salida S= si, N= no
	INOUT Par_NumErr		INT(11),		-- Parametro de salida numero de error
	INOUT Par_ErrMen		VARCHAR(400)	-- Parametro de salida mensaje de error
)
TerminaStore:BEGIN
	-- Declaracion de variables
	DECLARE Var_Control			VARCHAR(100);		-- Variable de Control
	DECLARE Var_Consecutivo 	VARCHAR(100);		-- Variable consecutivo
	DECLARE Var_Contador		INT(11);			-- Variable Contador
	DECLARE Aux_Residuo			INT(11);			-- Varialbe para el reciduo
	DECLARE Var_Suma			INT(11);			-- Variable para la suma
	DECLARE Aux_Digito			VARCHAR(2);			-- Variale para el digito extraido de la cadena de la refrencia original
	DECLARE Var_Resultante		INT(11);			-- Variable resultante para la multiplicaicon de digito ya sea por 1 o 2
	DECLARE Var_Decena			CHAR(1);			-- Variable que contendra la parte DECIMAL de un numero de dos digitos
	DECLARE Var_Unidad			CHAR(1);			-- Variable que contendra la parte unidad de un numero de dos digitos
	DECLARE Var_DecenaMayor 	INT(11);			-- Variable para obtener la decena mayor a la suma
	DECLARE Var_NumCaracteres	VARCHAR(15);		-- Variable para obtener el numero de caracteres de la cadena
	DECLARE Var_Referencia		VARCHAR(14);

	-- Declaracion de constantes
	DECLARE Entero_Cero			INT(11);			-- Constante valor 0
	DECLARE Entero_Uno			INT(11);			-- Constante valor 1
	DECLARE Entero_Dos			INT(11);			-- Constante valor 2
	DECLARE Entero_Diez			INT(11);			-- Constante valor 10
	DECLARE Entero_Catorce		INT(11);			-- Constante valor 14
	DECLARE Cadena_Vacia		CHAR(1);			-- Constante para cadena vacia
	DECLARE Salida_SI			CHAR(1);			-- Constante para valo S
	-- Seteo de valores
	SET Entero_Cero			:= 0;
	SET Entero_Uno			:= 1;
	SET Entero_Dos			:= 2;
	SET Entero_Diez			:= 10;
	SET Entero_Catorce		:= 14;
	SET Var_Suma			:= Entero_Cero;
	SET Cadena_Vacia		:= '';
	SET Salida_SI			:='S';

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
							  concretar la operacion.Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-ALGBANCOMER14CAL');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		-- obtenemos la longitud de la cadena
		SET Var_NumCaracteres := CHAR_LENGTH(Par_Referencia);
		-- VALIDA REFERENCIA DE 1 A 14 CARACTERES NUMERICOS
		IF(Var_NumCaracteres != Entero_Catorce)THEN
			SET Par_NumErr 		:= Entero_Uno;
			SET Par_ErrMen 		:= 'Numero de Caracteres incorrecto';
			SET Var_Control		:= 'institucionID';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SET Var_Contador := Entero_Uno;
		SET Var_Referencia := (SELECT REVERSE(Par_Referencia));
		-- Recorremos la cadena para genera la referencia con el digito verificador
		SumaDigitos: WHILE Var_Contador <= Var_NumCaracteres DO
			-- Obtenemos el digito de uno a uno segun la posicion del contador del WHILE
			SET Aux_Digito := SUBSTRING(Var_Referencia,Var_Contador,Entero_Uno);

			-- obtenemos si la posicion es par o inpar (Par  Var_Reciduo= 0 , Impar  Var_Reciduo != 0)
			SET Aux_Residuo := (Var_Contador % Entero_Dos);

			IF Aux_Residuo != Entero_Cero THEN
				-- Multiplica por 2 las posiciones impares
				SET Var_Resultante := CAST(Aux_Digito AS SIGNED INTEGER) * Entero_Dos;
			ELSE
				-- Multiplica por 1 las posiciones pares
				SET Var_Resultante := CAST(Aux_Digito AS SIGNED INTEGER) * Entero_Uno;
			END IF;

			-- Pasamos a cadena el digito obtenido
			SET Aux_Digito := CAST(Var_Resultante AS CHAR);

			-- Comprobamos si la cadena es mayor a un digito
			IF CHAR_LENGTH(Aux_Digito) > Entero_Uno THEN
				-- Obtenemos la parte de la decena
				SET Var_Decena := SUBSTRING(Aux_Digito,Entero_Uno,Entero_Uno);
				-- Obtenemos la parte de la unidad
				SET Var_Unidad := SUBSTRING(Aux_Digito,Entero_Dos,Entero_Uno);
				-- Realizamos la suma de los valores
				SET Var_Suma := Var_Suma + (CAST(Var_Decena AS SIGNED INTEGER)+ CAST(Var_Unidad AS SIGNED INTEGER));
			-- la cadena es menor y es de un solo digito
			ELSE
				-- realizamos la suma de los valores
				SET Var_Suma := Var_Suma + CAST(Aux_Digito AS SIGNED INTEGER);
			END IF;
			-- Incrementamos el contador
			SET Var_Contador := Var_Contador + Entero_Uno;
		END WHILE SumaDigitos;

		-- Obtenemos la decena mayor al valor de la suma
		SET Var_DecenaMayor := Entero_Diez;

		DecenaMayor: WHILE Var_Suma > Var_DecenaMayor DO
			SET Var_DecenaMayor := Var_DecenaMayor +Entero_Diez;
		END WHILE DecenaMayor;

		-- Generamos la referencia con el digito verificador
		SET Par_NuevaRefe := CONCAT(Par_Referencia,(Var_DecenaMayor-Var_Suma));

		-- seteamos valores de salida
		SET Par_NumErr 		:= Entero_Cero;
		SET Par_ErrMen 		:= Par_NuevaRefe;
		SET Var_Control		:= 'referencia';
		SET Var_Consecutivo	:= Par_NuevaRefe;

	END ManejoErrores;
	-- si se indico una salida de mensaje
	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS control,
			Var_Consecutivo AS consecutivo;
	END IF;
END TerminaStore$$