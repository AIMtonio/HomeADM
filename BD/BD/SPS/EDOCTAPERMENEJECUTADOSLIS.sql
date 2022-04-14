-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAPERMENEJECUTADOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAPERMENEJECUTADOSLIS`;
DELIMITER $$


CREATE PROCEDURE `EDOCTAPERMENEJECUTADOSLIS`(
#	-- Stored procedure para listar los periodos en los que se ha generado el estado de cuenta
	Par_NumLis						TINYINT UNSIGNED,		-- Numero de lista
    Par_Anio						VARCHAR(50),

	Aud_EmpresaID					INT(11),				-- Parametro de auditoria
	Aud_Usuario						INT(11),				-- Parametro de auditoria
	Aud_FechaActual					DATETIME,				-- Parametro de auditoria
	Aud_DireccionIP					VARCHAR(15),    		-- Parametro de auditoria
	Aud_ProgramaID					VARCHAR(50),			-- Parametro de auditoria
	Aud_Sucursal					INT(11),				-- Parametro de auditoria
	Aud_NumTransaccion				BIGINT(20)				-- Parametro de auditoria
)

TerminaStore:BEGIN
	-- Declaracion de constantes
	DECLARE Entero_Cero				INT(11);				-- Entero vacio
	DECLARE Entero_Dos				INT(11);				-- Entero dos
	DECLARE Cadena_Vacia			CHAR(1);				-- Cadena vacia
	DECLARE Lis_PeriodoMensual		TINYINT;				-- Opcion para devolver todos los meses en los que se ha generado el estado de cuenta
	DECLARE Lis_PeriodoSemestral	TINYINT;				-- Opcion para devolver todos los semestres en los que se ha generado el estado de cuenta
	DECLARE GeneracionMensual		CHAR(1);				-- Generacion de estado de cuenta de tipo mensual
	DECLARE GeneracionSemestral		CHAR(1);				-- Generacion de estado de cuenta de tipo semestral
	DECLARE Lis_PeriodoMes			TINYINT;                -- Genereción de los periodos hasta la actualidad por mes
    
	-- Asignacion de constantes
	SET Entero_Cero					:= 0;					-- Asignacion de entero vacio
	SET Entero_Dos					:= 2;					-- Asignacion de entero dos
	SET Cadena_Vacia				:= '';					-- Asignacion de cadena vacia
	SET Lis_PeriodoMensual			:= 1;					-- Opcion para devolver todos los servicios y sus clasificaciones
	SET Lis_PeriodoSemestral		:= 2;					-- Opcion para devolver las distintas clasificaciones de servicio
	SET GeneracionMensual			:= 'M';					-- Opcion para devolver las distintas clasificaciones de servicio
	SET GeneracionSemestral			:= 'S';					-- Opcion para devolver las distintas clasificaciones de servicio
	SET Lis_PeriodoMes				:= 3;  					

	-- Valores por default
	SET Par_NumLis					:= IFNULL(Par_NumLis,Entero_Cero);

	-- LISTA DE LOS PERIODOS MENSUALES EJECUTADOS
	IF(Par_NumLis = Lis_PeriodoMensual) THEN
		SELECT CONCAT(Anio,LPAD(MesInicio,Entero_Dos,Entero_Cero)) AS AnioMes,
				CONCAT((CASE MesInicio
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
						WHEN 12 THEN 'Diciembre' END),
						'-',
						Anio) AS Periodo
			FROM EDOCTAPERMENEJECUTADOS
			WHERE Tipo = GeneracionMensual;
	END IF;

	-- LISTA DE LOS PERIODOS SEMESTRALES EJECUTADOS
	IF(Par_NumLis = Lis_PeriodoSemestral) THEN
		SELECT CONCAT(Anio,LPAD(MesInicio,Entero_Dos,Entero_Cero),LPAD(MesFin,Entero_Dos,Entero_Cero)) AS AnioMes,
				CONCAT((CASE MesInicio
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
						WHEN 12 THEN 'Diciembre' END),
						'-',
						(CASE MesFin
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
							WHEN 12 THEN 'Diciembre' END),
						' ',
						Anio) AS Periodo
			FROM EDOCTAPERMENEJECUTADOS
			WHERE Tipo = GeneracionSemestral;
	END IF;
    
    -- LISTA DE LOS PERIODOS MENSUALES EJECUTADOS
	IF(Par_NumLis = Lis_PeriodoMes) THEN
		SELECT CONCAT(Anio,LPAD(MesInicio,Entero_Dos,Entero_Cero)) AS AnioMes
			FROM EDOCTAPERMENEJECUTADOS
			WHERE Anio  LIKE CONCAT("%",Par_Anio, "%");
	END IF;

-- Fin del SP
END TerminaStore$$