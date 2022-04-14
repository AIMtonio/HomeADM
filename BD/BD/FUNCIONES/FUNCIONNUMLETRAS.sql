-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FUNCIONNUMLETRAS
DELIMITER ;
DROP FUNCTION IF EXISTS `FUNCIONNUMLETRAS`;DELIMITER $$

CREATE FUNCTION `FUNCIONNUMLETRAS`(
	-- SP para obtener del monto en valor en letras
    Par_Monto   DECIMAL(18,2)    			-- Valor del monto
) RETURNS varchar(1000) CHARSET latin1
    DETERMINISTIC
BEGIN
	-- Declaracion de variables
	DECLARE XlnEntero 		INT;
	DECLARE XlcRetorno 		VARCHAR(512);
	DECLARE XlnTerna 		INT;
	DECLARE XlcMiles 		VARCHAR(512);
	DECLARE XlcCadena 		VARCHAR(512);
	DECLARE XlnUnidades 	INT;
	DECLARE XlnDecenas 		INT;
	DECLARE XlnCentenas 	INT;
	DECLARE XlnFraccion 	INT;
	DECLARE Xresultado 		VARCHAR(512);
	DECLARE XMoneda 		VARCHAR(100);

	-- Declaracion de Constantes
	DECLARE Entero_Cero		INT(11);

	-- Asignacion de constantes
	SET Entero_Cero			:= 0;

	-- Asignacion de variables
	SET XlnEntero 	:= FLOOR(Par_Monto);
	SET XlnFraccion := (Par_Monto - XlnEntero) * 100;
	SET XlcRetorno 	:= '';
	SET XlnTerna 	:= 1 ;
	SET XMoneda  	:= 'PESOS';

		WHILE( XlnEntero > Entero_Cero) DO

			-- Recorro terna por terna
			SET XlcCadena 	:= '';
			SET XlnUnidades := XlnEntero MOD 10;
			SET XlnEntero 	:= FLOOR(XlnEntero/10);
			SET XlnDecenas 	:= XlnEntero MOD 10;
			SET XlnEntero 	:= FLOOR(XlnEntero/10);
			SET XlnCentenas := XlnEntero MOD 10;
			SET XlnEntero 	:= FLOOR(XlnEntero/10);

			-- Analizo las unidades
			SET XlcCadena =
				CASE -- UNIDADES
					WHEN XlnUnidades = 1 AND XlnTerna = 1 THEN CONCAT('UNO ', XlcCadena)
					WHEN XlnUnidades = 1 AND XlnTerna <> 1 THEN CONCAT('UN ', XlcCadena)
					WHEN XlnUnidades = 2 THEN CONCAT('DOS ', XlcCadena)
					WHEN XlnUnidades = 3 THEN CONCAT('TRES ', XlcCadena)
					WHEN XlnUnidades = 4 THEN CONCAT('CUATRO ', XlcCadena)
					WHEN XlnUnidades = 5 THEN CONCAT('CINCO ', XlcCadena)
					WHEN XlnUnidades = 6 THEN CONCAT('SEIS ', XlcCadena)
					WHEN XlnUnidades = 7 THEN CONCAT('SIETE ', XlcCadena)
					WHEN XlnUnidades = 8 THEN CONCAT('OCHO ', XlcCadena)
					WHEN XlnUnidades = 9 THEN CONCAT('NUEVE ', XlcCadena)
					ELSE XlcCadena
				END; -- UNIDADES

			-- Analizo las decenas
			SET XlcCadena =
				CASE -- DECENAS
					WHEN XlnDecenas = 1 THEN
						CASE XlnUnidades
							WHEN 0 THEN 'DIEZ '
							WHEN 1 THEN 'ONCE '
							WHEN 2 THEN 'DOCE '
							WHEN 3 THEN 'TRECE '
							WHEN 4 THEN 'CATORCE '
							WHEN 5 THEN 'QUINCE '
							ELSE CONCAT('DIECI', XlcCadena)
						END
					WHEN XlnDecenas = 2 AND XlnUnidades = Entero_Cero THEN CONCAT('VEINTE ', XlcCadena)
					WHEN XlnDecenas = 2 AND XlnUnidades <> Entero_Cero THEN CONCAT('VEINTI', XlcCadena)
					WHEN XlnDecenas = 3 AND XlnUnidades = Entero_Cero THEN CONCAT('TREINTA ', XlcCadena)
					WHEN XlnDecenas = 3 AND XlnUnidades <> Entero_Cero THEN CONCAT('TREINTA Y ', XlcCadena)
					WHEN XlnDecenas = 4 AND XlnUnidades = Entero_Cero THEN CONCAT('CUARENTA ', XlcCadena)
					WHEN XlnDecenas = 4 AND XlnUnidades <> Entero_Cero THEN CONCAT('CUARENTA Y ', XlcCadena)
					WHEN XlnDecenas = 5 AND XlnUnidades = Entero_Cero THEN CONCAT('CINCUENTA ', XlcCadena)
					WHEN XlnDecenas = 5 AND XlnUnidades <> Entero_Cero THEN CONCAT('CINCUENTA Y ', XlcCadena)
					WHEN XlnDecenas = 6 AND XlnUnidades = Entero_Cero THEN CONCAT('SESENTA ', XlcCadena)
					WHEN XlnDecenas = 6 AND XlnUnidades <> Entero_Cero THEN CONCAT('SESENTA Y ', XlcCadena)
					WHEN XlnDecenas = 7 AND XlnUnidades = Entero_Cero THEN CONCAT('SETENTA ', XlcCadena)
					WHEN XlnDecenas = 7 AND XlnUnidades <> Entero_Cero THEN CONCAT('SETENTA Y ', XlcCadena)
					WHEN XlnDecenas = 8 AND XlnUnidades = Entero_Cero THEN CONCAT('OCHENTA ', XlcCadena)
					WHEN XlnDecenas = 8 AND XlnUnidades <> Entero_Cero THEN CONCAT('OCHENTA Y ', XlcCadena)
					WHEN XlnDecenas = 9 AND XlnUnidades = Entero_Cero THEN CONCAT('NOVENTA ', XlcCadena)
					WHEN XlnDecenas = 9 AND XlnUnidades <> Entero_Cero THEN CONCAT('NOVENTA Y ', XlcCadena)
					ELSE XlcCadena
				END; -- DECENAS

			-- Analizo las centenas
			SET XlcCadena =
				CASE -- CENTENAS
					WHEN XlnCentenas = 1 AND XlnUnidades = Entero_Cero AND XlnDecenas = Entero_Cero THEN CONCAT('CIEN ', XlcCadena)
					WHEN XlnCentenas = 1 AND NOT(XlnUnidades = Entero_Cero AND XlnDecenas = Entero_Cero) THEN CONCAT('CIENTO ', XlcCadena)
					WHEN XlnCentenas = 2 THEN CONCAT('DOSCIENTOS ', XlcCadena)
					WHEN XlnCentenas = 3 THEN CONCAT('TRESCIENTOS ', XlcCadena)
					WHEN XlnCentenas = 4 THEN CONCAT('CUATROCIENTOS ', XlcCadena)
					WHEN XlnCentenas = 5 THEN CONCAT('QUINIENTOS ', XlcCadena)
					WHEN XlnCentenas = 6 THEN CONCAT('SEISCIENTOS ', XlcCadena)
					WHEN XlnCentenas = 7 THEN CONCAT('SETECIENTOS ', XlcCadena)
					WHEN XlnCentenas = 8 THEN CONCAT('OCHOCIENTOS ', XlcCadena)
					WHEN XlnCentenas = 9 THEN CONCAT('NOVECIENTOS ', XlcCadena)
					ELSE XlcCadena
				END; -- CENTENAS

			-- Analizo la terna
			SET XlcCadena =
				CASE -- TERNA
					WHEN XlnTerna = 1 THEN XlcCadena
					WHEN XlnTerna = 2 AND (XlnUnidades + XlnDecenas + XlnCentenas <> Entero_Cero) THEN CONCAT(XlcCadena,  'MIL ')
					WHEN XlnTerna = 3 AND (XlnUnidades + XlnDecenas + XlnCentenas <> Entero_Cero) AND XlnUnidades = 1 AND XlnDecenas = Entero_Cero AND XlnCentenas = Entero_Cero THEN CONCAT(XlcCadena, 'MILLON ')
					WHEN XlnTerna = 3 AND (XlnUnidades + XlnDecenas + XlnCentenas <> Entero_Cero) AND NOT (XlnUnidades = 1 AND XlnDecenas = Entero_Cero AND XlnCentenas = Entero_Cero) THEN CONCAT(XlcCadena, 'MILLONES ')
					WHEN XlnTerna = 4 AND (XlnUnidades + XlnDecenas + XlnCentenas <> Entero_Cero) THEN CONCAT(XlcCadena, 'MIL MILLONES ')
					ELSE ''
				END; -- TERNA

			-- Armo el retorno terna a terna
			SET XlcRetorno := CONCAT(XlcCadena, XlcRetorno);
			SET XlnTerna := XlnTerna + 1;
		END WHILE; -- FIN WHILE

		IF XlnTerna = 1 THEN SET XlcRetorno = 'CERO'; END IF;

		IF(XlnFraccion > Entero_Cero)THEN
			SET Xresultado := CONCAT(RTRIM(XlcRetorno), " ", XMoneda, ' CON ', RIGHT(CONCAT("00",cast(LTRIM(XlnFraccion) AS CHAR)), 2), '/100 ');
		ELSE
			SET Xresultado := CONCAT(RTRIM(XlcRetorno), " ", XMoneda,' ', RIGHT(CONCAT("00",cast(LTRIM(XlnFraccion) AS CHAR)), 2), '/100 ');
		END IF;

	RETURN Xresultado;

END$$