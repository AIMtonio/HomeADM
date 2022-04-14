-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ALGBANCOMER35CAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `ALGBANCOMER35CAL`;DELIMITER $$

CREATE PROCEDURE `ALGBANCOMER35CAL`(
# =====================================================================================
# ------- STORED PARA GENERAR LA REFERENCIA DE LA INSTITUCION ---------
# =====================================================================================
    Par_InstitucionID 		INT(11),		-- ID de la institucion
	Par_Referencia			VARCHAR(50),	-- Referencia
    INOUT Par_NuevaRefe		VARCHAR(50),	-- Nueva Referencia

    Par_Salida    			CHAR(1),		-- Parametro de salida S= si, N= no
    INOUT Par_NumErr 		INT(11),		-- Parametro de salida numero de error
    INOUT Par_ErrMen  		VARCHAR(400)	-- Parametro de salida mensaje de error
)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES

    DECLARE Var_Consecutivo		VARCHAR(100);   	-- Variable consecutivo
	DECLARE Var_Control         VARCHAR(100);   	-- Variable de Control
    DECLARE Var_NumCaracteres	INT(11);			-- Numero de caracteres de la referencia
    DECLARE Var_PosicionRef		INT(11);			-- Numero de posicion en la referencia
    DECLARE Var_LetraAux		CHAR(2);			-- Auxiliar para letra
    DECLARE Var_ReferenciaNum	VARCHAR(100);		-- Referencia sustituida con numeros
    DECLARE Var_ResultadoRef	VARCHAR(100);		-- Referencia sustituida con numeros
    DECLARE Var_SumaDigRef		INT(11);			-- Suma de los digitos multiplicados de la referencia
    DECLARE Var_NumAux			INT(11);			-- Auxiliar para numero
    DECLARE Var_Contador		INT(11);			-- Contador para la multipliacion
    DECLARE Var_Unidades		INT(11);
    DECLARE Var_Decenas			INT(11);
    DECLARE Var_DecenaProxima	INT(11);
    DECLARE Var_DigitoVerific INT(11);				-- Dijito verificador
    DECLARE Var_Centenas		INT(11);
    -- DECLARACION DE CONSTANTES

	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- DECIMAL cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI

	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO
	DECLARE Entero_Uno      	INT(11);      		-- Entero Uno
	DECLARE Entero_Dos	     	INT(11);      		-- Entero Dos
	DECLARE Entero_Cuatro     	INT(11);      		-- Entero cuatro
	DECLARE Entero_Tres	     	INT(11);      		-- Entero tres

	DECLARE Entero_Ocho	     	INT(11);      		-- Entero ocho

    -- ASIGNACIŃ DE CONSTANTES

	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;
	SET Entero_Dos          	:= 2;
	SET Entero_Cuatro          	:= 4;
	SET Entero_Tres          	:= 3;

	SET Entero_Ocho          	:= 8;


	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
							  concretar la operacion.Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-ALGBANCOMER35CAL');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		-- VALIDA REFERENCIA DE 1 A 19 CARACTERES ALFANUMERICOS
		SET Var_NumCaracteres := CHAR_LENGTH(Par_Referencia);

        IF(Var_NumCaracteres < 1 OR Var_NumCaracteres > 19)THEN
			SET Par_NumErr 		:= 1;
			SET Par_ErrMen 		:= 'Numero de Caracteres incorrecto';
			SET Var_Control		:= 'institucionID';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
        END IF;

        -- 1.- En caso de que la Referencia contenga letras se deberan substituir por su
		-- correspondiente numero
        SET Var_PosicionRef := Entero_Uno;
        SET Var_ReferenciaNum := Cadena_Vacia;

		CAMBIOLETRASXNUM: WHILE Var_PosicionRef <= Var_NumCaracteres DO

			SET Var_LetraAux	:= SUBSTR(Par_Referencia, Var_PosicionRef, Entero_Uno);

            SET Var_LetraAux	:= CASE Var_LetraAux WHEN  '0' THEN '00'
													 WHEN  '1' THEN '01 '
													 WHEN  '2' THEN '02 '
													 WHEN  '3' THEN '03 '
													 WHEN  '4' THEN '04 '
													 WHEN  '5' THEN '05 '
													 WHEN  '6' THEN '06 '
													 WHEN  '7' THEN '07 '
													 WHEN  '8' THEN '08 '
													 WHEN  '9' THEN '09 '
													 WHEN  'A' THEN '01 '
													 WHEN  'B' THEN '02 '
													 WHEN  'C' THEN '03 '
													 WHEN  'D' THEN '04 '
													 WHEN  'E' THEN '05 '
													 WHEN  'F' THEN '06 '
													 WHEN  'G' THEN '07 '
													 WHEN  'H' THEN '08 '
													 WHEN  'I' THEN '09 '
													 WHEN  'J' THEN '10'
													 WHEN  'K' THEN '11'
													 WHEN  'L' THEN '12'
													 WHEN  'M' THEN '13'
													 WHEN  'N' THEN '14'
													 WHEN  'O' THEN '15'
													 WHEN  'P' THEN '16'
													 WHEN  'Q' THEN '17'
													 WHEN  'R' THEN '18'
													 WHEN  'S' THEN '19'
													 WHEN  'T' THEN '20'
													 WHEN  'U' THEN '21'
													 WHEN  'V' THEN '22'
													 WHEN  'W' THEN '23'
													 WHEN  'X' THEN '24'
													 WHEN  'Y' THEN '25'
													 WHEN  'Z' THEN '26'
                                                     ELSE 	''
										END;

            IF(Var_LetraAux = Cadena_Vacia)THEN
				SET Par_NumErr 		:= 2;
				SET Par_ErrMen 		:= CONCAT('Caracter incorrecto en la posicion ',Var_PosicionRef);
				SET Var_Control		:= 'referencia';
				SET Var_Consecutivo	:= Entero_Cero;
				LEAVE ManejoErrores;
            END IF;
            -- SE ARMAN LA REFERENCIA CON SOLO NUMEROS
            SET Var_ReferenciaNum := CONCAT(Var_ReferenciaNum,Var_LetraAux);

			SET Var_PosicionRef	:= Var_PosicionRef + Entero_Uno;

		END WHILE CAMBIOLETRASXNUM;

        -- 2.De izquierda a derecha se van multiplicando cada uno de los digitos por los numeros 4, 3 y 8, siempre iniciando la
		-- secuencia con el numero 4 aun cuando el numero a multiplicar sea 0 debera tomarse en cuenta. Si el resultado de la
		-- multiplicacion es mayor a 9, se deberan sumar las unidades y las decenas, de tal forma que solo se tenga como resultado un
		-- numero menor o igual a 9.
		SET Var_NumCaracteres := CHAR_LENGTH(Var_ReferenciaNum);
        SET Var_PosicionRef := Entero_Uno;
        SET Par_NuevaRefe := Cadena_Vacia;
        SET Var_Contador := Entero_Cero;

		MULTINUM: WHILE Var_PosicionRef <= Var_NumCaracteres DO

			SET Var_LetraAux	:= SUBSTR(Var_ReferenciaNum, Var_PosicionRef, Entero_Dos);

            SET Var_NumAux := CAST(Var_LetraAux AS SIGNED INTEGER);

            -- MULTIPLICA POR CUATRO
            IF(Var_Contador = Entero_Cero)THEN
				SET Var_NumAux := Var_NumAux * Entero_Cuatro;
				SET Var_Contador := Entero_Uno;
			ELSE
				-- MULTIPLICA POR TRES
				IF(Var_Contador = Entero_Uno)THEN
					SET Var_NumAux := Var_NumAux * Entero_Tres;
					SET Var_Contador := Entero_Dos;
				ELSE
					-- MULTIPLICA POR OCHO
					IF(Var_Contador = Entero_Dos)THEN
						SET Var_NumAux := Var_NumAux * Entero_Ocho;
						SET Var_Contador := Entero_Cero;
					END IF;
				END IF;
            END IF;

            IF(Var_NumAux > 9)THEN
				-- LA SUMA DE LAS UNIDADES Y DECENAS HASTA TENER UN VALOR MENOR O IGUAL A 9
				WHILE Var_NumAux > 9 DO

                    -- SE OBTIENES LAS UNIDADES Y DECENAS DEL RESULTADO DE LA MULTIPLICACION
                    SET Var_Unidades := CAST(SUBSTR(Var_NumAux, Entero_Uno, Entero_Uno) AS SIGNED INTEGER);
                    SET Var_Decenas := CAST(SUBSTR(Var_NumAux, Entero_Dos, Entero_Uno) AS SIGNED INTEGER);

                    IF(Var_NumAux > 99)THEN
						SET Var_Centenas := CAST(SUBSTR(Var_NumAux, Entero_Tres, Entero_Uno) AS SIGNED INTEGER);
						-- SE SUMAN LAS UNIDADES, DECENAS Y CENTENAS
						SET Var_NumAux := Var_Unidades + Var_Decenas + Var_Centenas;
					ELSE
						-- SE SUMAN LAS UNIDADES Y DECENAS
						SET Var_NumAux := Var_Unidades + Var_Decenas;
                    END IF;


                END WHILE;
            END IF;
            -- SE ARMAN LA NUEVA REFERENCIA CON SOLO NUMEROS MULTIPLICADOS
            SET Par_NuevaRefe := CONCAT(Par_NuevaRefe, Var_NumAux);

			SET Var_PosicionRef	:= Var_PosicionRef + Entero_Dos;

		END WHILE MULTINUM;

        -- 3.- Se suman todos los resultados de las multiplicaciones del punto 2.
        SET Var_NumCaracteres := CHAR_LENGTH(Par_NuevaRefe);
        SET Var_PosicionRef := Entero_Uno;
        SET Var_NumAux := Entero_Cero;
        SET Var_SumaDigRef := Entero_Cero;

        SUMADIGITOS: WHILE Var_PosicionRef <= Var_NumCaracteres DO

			SET Var_LetraAux	:= SUBSTR(Par_NuevaRefe, Var_PosicionRef, Entero_Uno);
            SET Var_NumAux := CAST(Var_LetraAux AS SIGNED INTEGER);

			SET Var_SumaDigRef := Var_SumaDigRef + Var_NumAux;
			SET Var_PosicionRef	:= Var_PosicionRef + Entero_Uno;

		END WHILE SUMADIGITOS;

        -- 4. El resultado de la suma indicada en el punto 2, debera restarsele a la decena superior mas proxima.
		-- El resultado de esta substraccion sera el digito verificador.
        -- OBTIENE LA DECENAS DE LA SUMA

		SET Var_Decenas := CAST(TRUNCATE((Var_SumaDigRef/10),0) AS SIGNED INTEGER);


        -- SE OBTIENE LA DECENA SUPERIOR MAS PROXIMA
        SET Var_Decenas := Var_Decenas + Entero_Uno;
        SET Var_DecenaProxima := Var_Decenas * 10;

        -- DIGITO VERIFICADOR
        SET Var_DigitoVerific := Var_DecenaProxima - Var_SumaDigRef;
        IF(Var_DigitoVerific = 10)THEN
			SET Var_DigitoVerific := Entero_Cero;
        END IF;

        -- 5. A la referencia se le agregara el digito verificador y esa sera la linea de captura
        -- que recibira el cajero en ventanilla.
        SET Par_NuevaRefe := CONCAT(Par_Referencia,Var_DigitoVerific);


		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= Par_NuevaRefe;
		SET Var_Control		:= 'referencia';
		SET Var_Consecutivo	:= Par_NuevaRefe;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;

	END IF;

END TerminaStore$$