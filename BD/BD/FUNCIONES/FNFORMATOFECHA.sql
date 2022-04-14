-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNFORMATOFECHA
DELIMITER ;
DROP FUNCTION IF EXISTS `FNFORMATOFECHA`;DELIMITER $$

CREATE FUNCTION `FNFORMATOFECHA`(
/* FUNCION QUE FORMATEA UNA CADENA A UNA FECHA VALIDA EN FORMATO [AAAA-MM-DD]*/
	Par_Fecha		VARCHAR(10),		# Fecha a tratar
	Par_Formato		VARCHAR(20) 		# Formato de la fecha
) RETURNS date
    DETERMINISTIC
BEGIN
	-- Declaracion de Constantes
	DECLARE Formato_Default 	VARCHAR(20);
	DECLARE Cadena_Vacia 		CHAR(1);
	DECLARE Fecha_Vacia 		DATE;
	DECLARE Entero_Cero			INT(11);
	DECLARE Entero_Uno			INT(11);
	DECLARE Str_SI				CHAR(1);
	DECLARE Str_NO				CHAR(1);

	-- Declaracion de variables
	DECLARE Var_Fecha 			DATE;
	DECLARE Var_Dia				VARCHAR(2);
	DECLARE Var_Mes				VARCHAR(2);
	DECLARE Var_Anio			VARCHAR(4);
	DECLARE Var_DigVerificador	INT(11);
	DECLARE Var_IniDia			INT(11);
	DECLARE Var_FinDia			INT(11);
	DECLARE Var_IniMes			INT(11);
	DECLARE Var_FinMes			INT(11);
	DECLARE Var_IniAnio			INT(11);
	DECLARE Var_FinAnio			INT(11);
	DECLARE Var_EsBisiesto		VARCHAR(1);

	-- Asignacion de constantes
	SET Formato_Default	:= '%Y-%m-%d';
	SET Cadena_Vacia	:= '';
	SET Fecha_Vacia		:= '1900-01-01';
	SET Par_Formato		:= IFNULL(Par_Formato,Cadena_Vacia);
	SET Par_Formato		:= IF(Par_Formato=Cadena_Vacia,Formato_Default,Par_Formato);
	SET Str_SI			:= 'S';
	SET Str_NO			:= 'N';

	SET Entero_Cero	:= 0;
	SET Entero_Uno	:= 1;
	SET Var_IniDia	:= 7;
	SET Var_IniMes	:= 5;
	SET Var_IniAnio	:= 1;
	SET Var_FinDia	:= 2; -- LONGITUD DEL DIA 2 DIGITOS
	SET Var_FinMes	:= 2; -- LONGITUD DEL MES 2 DIGITOS
	SET Var_FinAnio	:= 4; -- LONGITUD DEL AÑO 4 DIGITOS

	ManejoErrores: BEGIN
		-- Se valida si la fecha empieza con el año a 4 digitos [1989-10-01]
        SET Var_DigVerificador := SUBSTRING(Par_Fecha,3,1) REGEXP '^[0-9]';

        -- SI LA FECHA TIENE UNA LONGITUD DE 10
		IF(LENGTH(Par_Fecha)=10) THEN
			-- SI EL SEPARADOR DE LA FECHA ES UNA DIAGONAL O GUIÓN MEDIO Y NO TIENE GUION BAJO
			IF((LOCATE('/',Par_Fecha)>0 OR LOCATE('-',Par_Fecha)>0) AND LOCATE('_',Par_Fecha)<=0) THEN
				-- SI EL TERCER CARACTER NO ES UN NÚMERO (LA FECHA EMPIEZA POR DÍA)
				IF(IFNULL(Var_DigVerificador,Entero_Cero)=Entero_Cero)THEN
					-- SE OBTIENE LOS INDICES PARA SUSTRAER EL DIA, EL MES Y EL AÑO
					SET Var_IniDia	:= 1;
					SET Var_IniMes	:= 3;
					SET Var_IniAnio	:= 5;

				-- SI EL TERCER CARACTER SÍ ES UN NÚMERO (LA FECHA EMPIEZA POR AÑO)
				ELSE
					IF(IFNULL(Var_DigVerificador,Entero_Cero)=Entero_Uno)THEN
						-- SE OBTIENE EL DIA, EL MES Y EL AÑO
						SET Var_IniDia	:= 7;
						SET Var_IniMes	:= 5;
						SET Var_IniAnio	:= 1;
					END IF;
				END IF;
			END IF;
		END IF;

		-- SE OBTIENEN LOS VALORES PARA EL DIA, MES Y AÑO
		SET Var_Dia 	:= IFNULL(CAST(SUBSTRING(REPLACE(REPLACE(REPLACE(Par_Fecha,'/',''),'_',''),'-',''),Var_IniDia,Var_FinDia) AS CHAR),0);
		SET Var_Mes 	:= IFNULL(CAST(SUBSTRING(REPLACE(REPLACE(REPLACE(Par_Fecha,'/',''),'_',''),'-',''),Var_IniMes,Var_FinMes) AS CHAR),0);
		SET Var_Anio 	:= IFNULL(CAST(SUBSTRING(REPLACE(REPLACE(REPLACE(Par_Fecha,'/',''),'_',''),'-',''),Var_IniAnio,Var_FinAnio) AS CHAR),0);

		SET Var_Dia 	:= IF((Var_Dia = Cadena_Vacia OR Var_Dia = Entero_Cero), 1, Var_Dia);
		SET Var_Mes 	:= IF((Var_Mes = Cadena_Vacia OR Var_Mes = Entero_Cero), 1, Var_Mes);
		SET Var_Anio 	:= IF((Var_Anio = Cadena_Vacia OR Var_Anio = Entero_Cero), 1900, Var_Anio);

		-- SE VALIDA SI EL AÑO DE LA FECHA ES UN AÑO BISIESTO
		SET Var_EsBisiesto := (SELECT CASE WHEN (Var_Anio) % 400 = 0 THEN Str_SI
								WHEN (Var_Anio) % 100 = 0 THEN Str_NO
								WHEN (Var_Anio) % 4 = 0 THEN Str_SI ELSE Str_NO END);

		-- SI NO ES BISIESTO Y EL MES ES FEBRERO Y EL DÍA ES 29, ENTONCES SE LE ASIGNA 28
		IF(Var_EsBisiesto = Str_NO AND Var_Mes = 2 AND Var_Dia =29)THEN
			SET Var_Dia := 28;
		END IF;

		-- SE VALIDA QUE LOS DIAS CORRESPONDAN AL MES PARA FECHAS VÁLIDAS
		SET Var_Dia := IF((Var_Mes IN(4,6,9,11) AND Var_Dia NOT BETWEEN 1 AND 30), 30, Var_Dia);
		SET Var_Dia := IF((Var_Mes IN(1,3,5,7,8,10,12) AND Var_Dia NOT BETWEEN 1 AND 31), 31, Var_Dia);
		SET Var_Mes := IF((Var_Mes NOT BETWEEN 1 AND 12), 12, Var_Mes);

		-- SE VALIDA QUE LOS VALORES SE ENCUENTREN DENTRO DEL RANGO DE ACUERDO A SU TIPO
		IF(Var_Dia > 0 AND Var_Dia<=31 AND Var_Mes > 0 AND Var_Mes <=12 AND Var_Anio > 0) THEN
			SET Var_Fecha := STR_TO_DATE(CONCAT(Var_Dia,'-',Var_Mes,'-',Var_Anio),'%d-%m-%Y');
		END IF;

	END ManejoErrores;

	SET Var_Fecha := IFNULL(Var_Fecha,Fecha_Vacia);
	SET Var_Fecha := DATE_FORMAT(Var_Fecha,Par_Formato);

	RETURN Var_Fecha;
END$$