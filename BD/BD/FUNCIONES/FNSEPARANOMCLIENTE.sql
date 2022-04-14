-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNSEPARANOMCLIENTE
DELIMITER ;
DROP FUNCTION IF EXISTS `FNSEPARANOMCLIENTE`;
DELIMITER $$


CREATE FUNCTION `FNSEPARANOMCLIENTE`(
/* FUNCION PARA SEPARAR NOMBRE DEL CLIENTE EN APELLIDOS, NOMBRES*/
	Par_NombreCompleto		VARCHAR(1000), 		-- NOMBRE COMPLETO
    Par_TipoRetorno			INT(11),			-- APELLIDOS, NOMBRES
    Par_TipoOrdenCadena		VARCHAR(3)			-- NA.-PRIMERO ES NOMBRE(S) Y APELLDOS, AN.-PRIMERO ES APELLIDOS NOMBRE(S)
) RETURNS VARCHAR(100)
    DETERMINISTIC
BEGIN
	-- Declaracion de variables
	DECLARE Var_Cadena 				VARCHAR(100);			-- CADENA A RETORNAR
	DECLARE Var_ApePaterno			VARCHAR(100);			-- APELLIDO PATERNO
	DECLARE Var_ApeMaterno			VARCHAR(100);			-- APELLIDO MATERNO
	DECLARE Var_PrimerNombre		VARCHAR(100);			-- PRIMER NOMBRE
	DECLARE Var_SegundoNombre		VARCHAR(100);			-- SEGUNDO NOMBRE
	DECLARE Var_TercerNombre		VARCHAR(100);			-- TERCER NOMBRE
    DECLARE Var_Posicion			INT(11);				-- POSICION
    DECLARE Var_Contador			INT(11);				-- CONTADOR
    DECLARE Cons_CadenaAuxiliar		VARCHAR(150);			-- CADENA AUXILIAR

    DECLARE Par_PrimerNombre 		VARCHAR(400);
	DECLARE Par_SegundoNombre 		VARCHAR(400);
	DECLARE Par_ApellidoPaterno 	VARCHAR(400);
	DECLARE Par_ApellidoMaterno 	VARCHAR(400);

	DECLARE Var_ApellidoPaterno 	VARCHAR(400);
	DECLARE Var_ApellidoMaterno 	VARCHAR(400);
	DECLARE Var_PosCortar			INT(11);
	DECLARE Var_TipoNombre			INT(11);

	DECLARE Maximo_Cadena			INT(11);
	DECLARE Pos_Puntero 			INT(11);
	DECLARE Var_Caracter		 	VARCHAR(2);
	DECLARE Var_CaracterAnt 		VARCHAR(2);
	DECLARE Var_Texto				VARCHAR(200);
	DECLARE Salida_SI				CHAR(1);


    -- Declaracion de Constantes
	DECLARE Cadena_Vacia 		CHAR(1);
    DECLARE Fecha_Vacia			DATE;


	-- Asignacion de constantes
	SET Fecha_Vacia 			:= '1900-01-01';
    SET Cadena_Vacia			:= '';
    SET Var_Posicion			:= 0;
    SET Var_Contador			:= 0;

	ManejoErrores: BEGIN

        IF(Par_TipoOrdenCadena = "AN")THEN
			-- APELLIDO PATERNO
			SET Var_ApePaterno := SUBSTRING(Par_NombreCompleto,1, LOCATE(' ',Par_NombreCompleto));
			SET Var_ApePaterno := IFNULL(Var_ApePaterno, Cadena_Vacia);

			-- APELLIDO MATERNO
			SET Var_Posicion := LOCATE(' ',Par_NombreCompleto);
			SET Var_ApeMaterno := SUBSTRING(SUBSTRING_INDEX(Par_NombreCompleto,' ', 2),(Var_Posicion+1),100);
			SET Var_ApeMaterno := IFNULL(Var_ApeMaterno, Cadena_Vacia);

			-- PRIMER NOMBRE
			SET Var_Posicion := LOCATE(' ',Par_NombreCompleto, (Var_Posicion+1));
			SET Var_PrimerNombre := SUBSTRING(SUBSTRING_INDEX(Par_NombreCompleto,' ', 3),(Var_Posicion+1),100);
			SET Var_PrimerNombre := IFNULL(Var_PrimerNombre, Cadena_Vacia);

			-- SEGUNDO NOMBRE
			SET Var_Posicion := LOCATE(' ',Par_NombreCompleto, (Var_Posicion+1));
			SET Var_SegundoNombre := SUBSTRING(SUBSTRING_INDEX(Par_NombreCompleto,' ', 4),(Var_Posicion+1),100);
			SET Var_SegundoNombre := IFNULL(Var_SegundoNombre, Cadena_Vacia);

			IF(LOCATE(' ',Var_SegundoNombre) > 0)THEN
				SET Var_SegundoNombre := Cadena_Vacia;
			END IF;

			-- TERCER NOMBRE
			SET Var_Posicion := LOCATE(' ',Par_NombreCompleto, (Var_Posicion+1));
			SET Var_TercerNombre := SUBSTRING(SUBSTRING_INDEX(Par_NombreCompleto,' ', 5),(Var_Posicion+1),100);
			SET Var_TercerNombre := IFNULL(Var_TercerNombre, Cadena_Vacia);

			IF(LOCATE(' ',Var_TercerNombre) > 0)THEN
				SET Var_TercerNombre := Cadena_Vacia;
			END IF;
        END IF;


        IF(Par_TipoOrdenCadena = "NA")THEN
			-- PRIMER NOMBRE
            SET Cons_CadenaAuxiliar := Par_NombreCompleto;
            SET Var_Posicion := LOCATE(' ',Cons_CadenaAuxiliar);
			SET Cons_CadenaAuxiliar := SUBSTRING(Cons_CadenaAuxiliar,(Var_Posicion+1),100);
			IF(Var_Posicion > 0)THEN
				SET Var_Contador:=Var_Contador+1;
            END IF;

            SET Var_Posicion := LOCATE(' ',Cons_CadenaAuxiliar);
			SET Cons_CadenaAuxiliar := SUBSTRING(Cons_CadenaAuxiliar,(Var_Posicion+1),100);
			IF(Var_Posicion > 0)THEN
				SET Var_Contador:=Var_Contador+1;
            END IF;

            SET Var_Posicion := LOCATE(' ',Cons_CadenaAuxiliar);
			SET Cons_CadenaAuxiliar := SUBSTRING(Cons_CadenaAuxiliar,(Var_Posicion+1),100);
			IF(Var_Posicion > 0)THEN
				SET Var_Contador:=Var_Contador+1;
            END IF;

            SET Var_Posicion := LOCATE(' ',Cons_CadenaAuxiliar);
			SET Cons_CadenaAuxiliar := SUBSTRING(Cons_CadenaAuxiliar,(Var_Posicion+1),100);
			IF(Var_Posicion > 0)THEN
				SET Var_Contador:=Var_Contador+1;
            END IF;

            SET Var_Posicion := LOCATE(' ',Cons_CadenaAuxiliar);
			SET Cons_CadenaAuxiliar := SUBSTRING(Cons_CadenaAuxiliar,(Var_Posicion+1),100);
			IF(Var_Posicion > 0)THEN
				SET Var_Contador:=Var_Contador+1;
            END IF;

            SET Var_Posicion:= 0;

            -- PRIMER NOMBRE
            SET Var_PrimerNombre := SUBSTRING(Par_NombreCompleto,1, LOCATE(' ',Par_NombreCompleto));
			SET Var_PrimerNombre := IFNULL(Var_PrimerNombre, Cadena_Vacia);


            CASE Var_Contador
						WHEN 2 THEN
                            -- APELLIDO PATERNO
							SET Var_Posicion := LOCATE(' ',Par_NombreCompleto, (Var_Posicion+1));
							SET Var_ApePaterno := SUBSTRING(SUBSTRING_INDEX(Par_NombreCompleto,' ', 2),(Var_Posicion+1),100);
							SET Var_ApePaterno := IFNULL(Var_ApePaterno, Cadena_Vacia);

							-- APELLIDO MATERNO
							SET Var_Posicion := LOCATE(' ',Par_NombreCompleto, (Var_Posicion+1));
							SET Var_ApeMaterno := SUBSTRING(SUBSTRING_INDEX(Par_NombreCompleto,' ', 3),(Var_Posicion+1),100);
							SET Var_ApeMaterno := IFNULL(Var_ApeMaterno, Cadena_Vacia);

						WHEN 3 THEN
							-- SEGUNDO NOMBRE
							SET Var_Posicion := LOCATE(' ',Par_NombreCompleto);
							SET Var_SegundoNombre := SUBSTRING(SUBSTRING_INDEX(Par_NombreCompleto,' ', 2),(Var_Posicion+1),100);
							SET Var_SegundoNombre := IFNULL(Var_SegundoNombre, Cadena_Vacia);

                            -- APELLIDO PATERNO
							SET Var_Posicion := LOCATE(' ',Par_NombreCompleto, (Var_Posicion+1));
							SET Var_ApePaterno := SUBSTRING(SUBSTRING_INDEX(Par_NombreCompleto,' ', 3),(Var_Posicion+1),100);
							SET Var_ApePaterno := IFNULL(Var_ApePaterno, Cadena_Vacia);

							-- APELLIDO MATERNO
							SET Var_Posicion := LOCATE(' ',Par_NombreCompleto, (Var_Posicion+1));
							SET Var_ApeMaterno := SUBSTRING(SUBSTRING_INDEX(Par_NombreCompleto,' ', 4),(Var_Posicion+1),100);
							SET Var_ApeMaterno := IFNULL(Var_ApeMaterno, Cadena_Vacia);
					ELSE
							-- SEGUNDO NOMBRE
							SET Var_Posicion := LOCATE(' ',Par_NombreCompleto);
							SET Var_SegundoNombre := SUBSTRING(SUBSTRING_INDEX(Par_NombreCompleto,' ', 2),(Var_Posicion+1),100);
							SET Var_SegundoNombre := IFNULL(Var_SegundoNombre, Cadena_Vacia);

                            -- TERCER NOMBRE
                            SET Var_Posicion := LOCATE(' ',Par_NombreCompleto, (Var_Posicion+1));
							SET Var_TercerNombre := SUBSTRING(SUBSTRING_INDEX(Par_NombreCompleto,' ', 3),(Var_Posicion+1),100);
							SET Var_TercerNombre := IFNULL(Var_TercerNombre, Cadena_Vacia);

                            -- APELLIDO PATERNO
							SET Var_Posicion := LOCATE(' ',Par_NombreCompleto, (Var_Posicion+1));
							SET Var_ApePaterno := SUBSTRING(SUBSTRING_INDEX(Par_NombreCompleto,' ', 4),(Var_Posicion+1),100);
							SET Var_ApePaterno := IFNULL(Var_ApePaterno, Cadena_Vacia);

							-- APELLIDO MATERNO
							SET Var_Posicion := LOCATE(' ',Par_NombreCompleto, (Var_Posicion+1));
							SET Var_ApeMaterno := SUBSTRING(SUBSTRING_INDEX(Par_NombreCompleto,' ', 5),(Var_Posicion+1),100);
							SET Var_ApeMaterno := IFNULL(Var_ApeMaterno, Cadena_Vacia);
            END CASE;

        END IF;

		SET Var_ApePaterno := IFNULL(Var_ApePaterno, " ");
		SET Var_ApeMaterno := IFNULL(Var_ApeMaterno, " ");
		SET Var_PrimerNombre := IFNULL(Var_PrimerNombre, " ");
		SET Var_SegundoNombre := IFNULL(Var_SegundoNombre, " ");
		SET Var_TercerNombre := IFNULL(Var_TercerNombre, " ");

		SET Var_Cadena :=CASE Par_TipoRetorno
						WHEN 1 THEN TRIM(Var_ApePaterno) 		-- APELLIDO PATERNO
						WHEN 2 THEN TRIM(Var_ApeMaterno)		-- APELLIDO MATERNO
						WHEN 3 THEN TRIM(Var_PrimerNombre)		-- PRIMER NOMBRE
						WHEN 4 THEN TRIM(Var_SegundoNombre)		-- SEGUNDO NOMBRE
						WHEN 5 THEN TRIM(Var_TercerNombre)		-- TERCER NOMBRE
						WHEN 6 THEN TRIM(CONCAT(Var_PrimerNombre, " ",Var_SegundoNombre, " ",Var_TercerNombre))	-- SOLO NOMBRES
						WHEN 7 THEN TRIM(CONCAT(Var_ApePaterno, " ",Var_ApeMaterno))	-- SOLO APELLIDOS
			ELSE Cadena_Vacia END;


    END ManejoErrores;



	SET Var_Cadena := IFNULL(Var_Cadena,Cadena_Vacia);

	RETURN Var_Cadena;
END$$