-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ALGBANCOMER36CAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `ALGBANCOMER36CAL`;
DELIMITER $$


CREATE PROCEDURE `ALGBANCOMER36CAL`(
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
	DECLARE Var_NumCaracteres	INT(11);			-- Numero de caracteres de la referencia
    DECLARE Var_PosicionRef		INT(11);			-- Numero de posicion en la referencia
    DECLARE Var_LetraAux		CHAR(2);			-- Auxiliar para letra
    DECLARE Var_ReferenciaNum	VARCHAR(100);		-- Referencia sustituida con numeros
	DECLARE Var_NumAux			INT(11);			-- Auxiliar para numero
    DECLARE Var_Contador		INT(11);			-- Contador para la multipliacion
	DECLARE Var_Control         VARCHAR(100);   	-- Variable de Control
    DECLARE Var_IdenCadCliente	VARCHAR(2);			-- Caracteres al inicio de la cadena
    DECLARE Var_SumaDigRef		INT(11);			-- Suma de los digitos multiplicados de la referencia

	DECLARE Var_Unidades		INT(11);			-- Variable que almacena Unidades
    DECLARE Var_Decenas			INT(11);			-- Variable que almacena Decenas
    DECLARE Var_DecenaProxima	INT(11);
    DECLARE Var_DigitoVerific 	INT(11);			-- Dijito verificador
    DECLARE Var_Centenas		INT(11);			-- Variable que almacena Centenas

    -- DECLARACION DE CONSTANTES

	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- DECIMAL cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI

	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO
	DECLARE Entero_Uno      	INT(11);      		-- Entero Uno
	DECLARE Entero_Dos	     	INT(11);      		-- Entero Dos
	DECLARE Entero_Tres			INT(11);			-- Entero Tres
	DECLARE Entero_DIECISEIS	INT(11);			-- Entero Dieciseis

    -- ASIGNACIŃ DE CONSTANTES

	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;
	SET Entero_Dos          	:= 2;
	SET Entero_Tres          	:= 3;
	SET Entero_DIECISEIS		:= 16;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
							  concretar la operacion.Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-ALGBANCOMER35CAL');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		-- CUENTA LA CANTIDAD DE CARACTERES DEBEN DE SER 16 CARACTERES ALFANUMERICOS
		SET Var_NumCaracteres := CHAR_LENGTH( Par_Referencia );

        IF ( Var_NumCaracteres != Entero_DIECISEIS  OR Var_NumCaracteres = NULL ) THEN
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
			SET Var_LetraAux	:= CASE Var_LetraAux WHEN  '0' THEN '0'
													 WHEN  '1' THEN '1'
													 WHEN  '2' THEN '2'
													 WHEN  '3' THEN '3'
													 WHEN  '4' THEN '4'
													 WHEN  '5' THEN '5'
													 WHEN  '6' THEN '6'
													 WHEN  '7' THEN '7'
													 WHEN  '8' THEN '8'
													 WHEN  '9' THEN '9'
													 WHEN  'A' THEN '1'
													 WHEN  'B' THEN '2'
													 WHEN  'C' THEN '3'
													 WHEN  'D' THEN '4'
													 WHEN  'E' THEN '5'
													 WHEN  'F' THEN '6'
													 WHEN  'G' THEN '7'
													 WHEN  'H' THEN '8'
													 WHEN  'I' THEN '9'
													 WHEN  'J' THEN '1'
													 WHEN  'K' THEN '2'
													 WHEN  'L' THEN '3'
													 WHEN  'M' THEN '4'
													 WHEN  'N' THEN '5'
													 WHEN  'O' THEN '6'
													 WHEN  'P' THEN '7'
													 WHEN  'Q' THEN '8'
													 WHEN  'R' THEN '9'
													 WHEN  'S' THEN '1'
													 WHEN  'T' THEN '2'
													 WHEN  'U' THEN '3'
													 WHEN  'V' THEN '4'
													 WHEN  'W' THEN '5'
													 WHEN  'X' THEN '6'
													 WHEN  'Y' THEN '7'
													 WHEN  'Z' THEN '8'
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

		-- En este caso se hizo de izquierda a derecha empezando con la secuencia inversamente 1 y 2 en vez de 2 y 1
		-- 2.De derecha a izquierda se van multiplicando cada uno de los digitos por los numeros 2 y 1, siempre iniciando la
		-- secuencia con el numero 2 aun cuando el numero a multiplicar sea 0 debera tomarse en cuenta. Si el resultado de la
		-- multiplicacion es mayor a 9, se deberan sumar las unidades y las decenas, de tal forma que solo se tenga como resultado un
		-- numero menor o igual a 9.
		SET Var_NumCaracteres := CHAR_LENGTH(Var_ReferenciaNum);
        SET Var_PosicionRef := Entero_Uno;
        SET Par_NuevaRefe := Cadena_Vacia;
        SET Var_Contador := Entero_Cero;

		MULTINUM: WHILE Var_PosicionRef <= Var_NumCaracteres DO

			SET Var_LetraAux	:= SUBSTR(Var_ReferenciaNum, Var_PosicionRef, Entero_Uno);
            SET Var_NumAux 		:= CAST(Var_LetraAux AS SIGNED INTEGER);

            -- MULTIPLICA POR UNO
            IF(Var_Contador = Entero_Cero)THEN
				SET Var_NumAux := Var_NumAux * Entero_Uno;
				SET Var_Contador := Entero_Uno;
			ELSE
				-- MULTIPLICA POR DOS
				IF(Var_Contador = Entero_Uno)THEN
					SET Var_NumAux := Var_NumAux * Entero_Dos;
					SET Var_Contador := Entero_Cero;
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

			SET Var_PosicionRef	:= Var_PosicionRef + Entero_Uno;

		END WHILE MULTINUM;

        -- 3.- Se suman todos los resultados de las multiplicaciones del punto 2.
        SET Var_NumCaracteres := CHAR_LENGTH( Par_NuevaRefe );
        SET Var_PosicionRef := Entero_Uno;
        SET Var_NumAux := Entero_Cero;
        SET Var_SumaDigRef := Entero_Cero;

        SUMADIGITOS: WHILE Var_PosicionRef <= Var_NumCaracteres DO

			SET Var_LetraAux	:= SUBSTR( Par_NuevaRefe, Var_PosicionRef, Entero_Uno );
            SET Var_NumAux		:= CAST( Var_LetraAux AS SIGNED INTEGER );

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
        IF ( Var_DigitoVerific = 10 ) THEN
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
