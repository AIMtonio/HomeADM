-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNFECHACOMPLETA
DELIMITER ;
DROP FUNCTION IF EXISTS `FNFECHACOMPLETA`;DELIMITER $$

CREATE FUNCTION `FNFECHACOMPLETA`(
/* FORMATEA LA FECHA EN LETRAS, CONCIDERANDO O NO EL DÍA DE LA SEMANA, EN MAYUSCULAS O NO */
	Par_Fecha		DATE,		-- Fecha a formatear
	Par_TipoResp	TINYINT		-- Tipo de Respuesta

) RETURNS varchar(100) CHARSET latin1
    DETERMINISTIC
BEGIN

-- Declaracion de constantes
DECLARE Entero_Uno			INT;
DECLARE TipoConDiaSem		INT;
DECLARE TipoConDiaSemMayus	INT;
DECLARE TipoSinDiaSem		INT;
DECLARE TipoSinDiaSemMayus	INT;
DECLARE TipoDDMMMAA			INT;
DECLARE TipoNumsLetras		INT;
DECLARE TipoDiaSemana		INT;
DECLARE TipoNombMes			INT;
DECLARE Fecha_Vacia			DATE;

-- Declaracion de Variables.
DECLARE Var_Dia				VARCHAR(2);
DECLARE Var_DiaSem			INT;
DECLARE Var_Mes				INT;
DECLARE Var_Anio			INT;
DECLARE Var_FechaCompleta	VARCHAR(100);
DECLARE Var_NombreMes		VARCHAR(20);
DECLARE Var_NombreDiaSem	VARCHAR(20);

-- Asignacion de Constantes
SET Entero_Uno 			:= 1;
SET Fecha_Vacia			:= '1900-01-01';
SET TipoConDiaSem		:= 1;			-- Fecha con dia de la sem,
SET TipoConDiaSemMayus	:= 2;			-- Fecha con dia sem en mayus,
SET TipoSinDiaSem		:= 3;			-- Fecha sin dia sem,
SET TipoSinDiaSemMayus	:= 4;			-- Fecha sin dia sem en mayus
SET TipoDDMMMAA			:= 5;			-- Fecha formato DD/MMM/AA para Reporte de Circulo de Credito
SET TipoNumsLetras		:= 6;			-- Fecha con Números y Letras para Contratos Agro 7 Sólo día de la semana.
SET TipoDiaSemana		:= 7;			-- Sólo día de la semana
SET TipoNombMes			:= 8;			-- Sólo mes

-- Asignacion de Variables
SET	Par_Fecha			:= IFNULL(Par_Fecha, Fecha_Vacia);
SET Var_Dia 			:= DATE_FORMAT(Par_Fecha, '%d');
SET Var_DiaSem 			:= DATE_FORMAT(Par_Fecha, '%w');
SET Var_Mes 			:= MONTH(Par_Fecha);
SET Var_Anio 			:= YEAR(Par_Fecha);

-- Construcción de la fecha
IF(IFNULL(Par_TipoResp,Entero_Uno)IN(
	TipoConDiaSem,	TipoConDiaSemMayus,	TipoSinDiaSem,	TipoSinDiaSemMayus,	TipoNumsLetras,
	TipoDiaSemana,	TipoNombMes))THEN
	SET Var_NombreMes := CASE Var_Mes
							WHEN 1 THEN 'Enero'
							WHEN 2 THEN 'Febrero'
							WHEN 3 THEN 'Marzo'
							WHEN 4 THEN 'Abril'
							WHEN 5 THEN 'Mayo'
							WHEN 6 THEN 'Junio'
							WHEN 7 THEN 'Julio'
							WHEN 8 THEN 'Agosto'
							WHEN 9 THEN 'Septiembre'
							WHEN 10 THEN 'Octubre'
							WHEN 11 THEN 'Noviembre'
							WHEN 12 THEN 'Diciembre'
							END;

	SET Var_NombreDiaSem := CASE Var_DiaSem
							WHEN 0 THEN 'Domingo'
							WHEN 1 THEN 'Lunes'
							WHEN 2 THEN 'Martes'
							WHEN 3 THEN 'Miércoles'
							WHEN 4 THEN 'Jueves'
							WHEN 5 THEN 'Viernes'
							WHEN 6 THEN 'Sábado'
							END;
	SET Var_FechaCompleta :=
		CASE IFNULL(Par_TipoResp,Entero_Uno)
			WHEN TipoConDiaSem THEN
				CONCAT(Var_NombreDiaSem,' ',Var_Dia, ' de ', Var_NombreMes, ' de ', Var_Anio)
			WHEN TipoConDiaSemMayus THEN
				UPPER(CONCAT(Var_NombreDiaSem,' ',Var_Dia, ' de ', Var_NombreMes, ' de ', Var_Anio))
			WHEN TipoSinDiaSem THEN
				CONCAT(Var_Dia, ' de ', Var_NombreMes, ' de ', Var_Anio)
			WHEN TipoSinDiaSemMayus THEN
				UPPER(CONCAT(Var_Dia, ' de ', Var_NombreMes, ' de ', Var_Anio))
		END;
ELSE -- Fecha formato DD/MMM/AA para Reporte de Circulo de Credito
	SET Var_FechaCompleta :=
		CASE Var_Mes
			WHEN 1 THEN
				UPPER(CONCAT(DATE_FORMAT(Par_Fecha,'%d/'),'Ene',DATE_FORMAT(Par_Fecha,'/%y')))
			WHEN 2 THEN
				UPPER(CONCAT(DATE_FORMAT(Par_Fecha,'%d/'),'Feb',DATE_FORMAT(Par_Fecha,'/%y')))
			WHEN 3 THEN
				UPPER(CONCAT(DATE_FORMAT(Par_Fecha,'%d/'),'Mar',DATE_FORMAT(Par_Fecha,'/%y')))
			WHEN 4 THEN
				UPPER(CONCAT(DATE_FORMAT(Par_Fecha,'%d/'),'Abr',DATE_FORMAT(Par_Fecha,'/%y')))
			WHEN 5 THEN
				UPPER(CONCAT(DATE_FORMAT(Par_Fecha,'%d/'),'May',DATE_FORMAT(Par_Fecha,'/%y')))
			WHEN 6 THEN
				UPPER(CONCAT(DATE_FORMAT(Par_Fecha,'%d/'),'Jun',DATE_FORMAT(Par_Fecha,'/%y')))
			WHEN 7 THEN
				UPPER(CONCAT(DATE_FORMAT(Par_Fecha,'%d/'),'Jul',DATE_FORMAT(Par_Fecha,'/%y')))
			WHEN 8 THEN
				UPPER(CONCAT(DATE_FORMAT(Par_Fecha,'%d/'),'Ago',DATE_FORMAT(Par_Fecha,'/%y')))
			WHEN 9 THEN
				UPPER(CONCAT(DATE_FORMAT(Par_Fecha,'%d/'),'Sep',DATE_FORMAT(Par_Fecha,'/%y')))
			WHEN 10 THEN
				UPPER(CONCAT(DATE_FORMAT(Par_Fecha,'%d/'),'Oct',DATE_FORMAT(Par_Fecha,'/%y')))
			WHEN 11 THEN
				UPPER(CONCAT(DATE_FORMAT(Par_Fecha,'%d/'),'Nov',DATE_FORMAT(Par_Fecha,'/%y')))
			WHEN 12 THEN
				UPPER(CONCAT(DATE_FORMAT(Par_Fecha,'%d/'),'Dic',DATE_FORMAT(Par_Fecha,'/%y')))
			END;
END IF;

IF(IFNULL(Par_TipoResp,Entero_Uno)IN(TipoNumsLetras))THEN
	SET Var_FechaCompleta := CONCAT(Var_Dia,' (',
								TRIM(FNLETRACAPITAL(FUNCIONSOLONUMLETRAS(Var_Dia))),
								') días del mes de ',Var_NombreMes,
								' del año ',Var_Anio,' (',
								TRIM(FNLETRACAPITAL(FUNCIONSOLONUMLETRAS(Var_Anio))),')');
END IF;

IF(IFNULL(Par_TipoResp,Entero_Uno)IN(TipoDiaSemana))THEN
	SET Var_FechaCompleta := CONCAT(Var_NombreDiaSem);
END IF;

IF(IFNULL(Par_TipoResp,Entero_Uno)IN(TipoNombMes))THEN
	SET Var_FechaCompleta := CONCAT(Var_NombreMes);
END IF;

RETURN Var_FechaCompleta;

END$$