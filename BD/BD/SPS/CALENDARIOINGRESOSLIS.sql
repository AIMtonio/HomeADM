-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALENDARIOINGRESOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CALENDARIOINGRESOSLIS`;
DELIMITER $$

CREATE PROCEDURE `CALENDARIOINGRESOSLIS`(
	Par_InstitNominaID		INT(11),			-- Numero de Institucion Nomina
	Par_ConvenioNominaID    BIGINT UNSIGNED,	-- Numero de Convenio Nomina
    Par_Anio				INT(4),				-- Numero de Anio
    Par_Estatus				CHAR(1),			-- Estatus del Calendario de Ingresos

	Par_NumLis				TINYINT UNSIGNED,	-- Numero de Lista
    -- AUDITORIA
    Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
	)

TerminaStore: BEGIN
	-- DECLARACION DE VARIABLES
	DECLARE Var_AnioActual		INT(4);
	DECLARE Var_Sentencia   	VARCHAR(500);
	DECLARE Var_Anio			INT(4);

	-- DECLARACION DE CONSTANTES
	DECLARE	Cadena_Vacia		CHAR(1);	-- Constante Cadena Vacia
	DECLARE	Fecha_Vacia			DATE;		-- Constante Fecha Vacia
	DECLARE	Entero_Cero			INT;		-- Constante Entero Cero
	DECLARE Cons_TresAnios		INT(1);		-- Constante Tres Anios
	DECLARE Cons_Uno			INT(1);		-- Constante Uno

	DECLARE Incremento			INT(1);		-- Constante Incremento
	DECLARE Lis_Principal		INT(11);	-- Lista de Información de Calendario de Ingresos
	DECLARE	Lis_AnioCalendar	INT(11);	-- Lista de los anios del Calendario de Ingresos

	-- ASIGNACION DE CONSTANTES
	SET	Cadena_Vacia	:= '';
	SET	Fecha_Vacia		:= '1900-01-01';
	SET	Entero_Cero		:= 0;
	SET Cons_TresAnios	:= 3;
	SET Cons_Uno		:= 1;

	SET Incremento 		:= 1;
	SET Lis_Principal	:= 1;
	SET	Lis_AnioCalendar:= 2;

	-- 1.- Lista de los Anios del Calendario de Registros
	IF(Par_NumLis = Lis_Principal) THEN
		SELECT FechaLimiteEnvio, FechaPrimerDesc, NumCuotas, FechaLimiteRecep FROM CALENDARIOINGRESOS
		WHERE InstitNominaID = Par_InstitNominaID
		AND ConvenioNominaID = Par_ConvenioNominaID
		AND Anio = Par_Anio
		AND Estatus = Par_Estatus;
	   /*select * from CALENDARIOINGRESOS;*/
	END IF;

    -- 2.-  Lista de los anios del Calendario de Ingresos
	IF(Par_NumLis = Lis_AnioCalendar) THEN
		DROP TEMPORARY TABLE IF EXISTS TMP_ANIOSCALENDARIO;

		CREATE TEMPORARY TABLE TMP_ANIOSCALENDARIO(Anio  INT(4));
		SET Var_AnioActual := (SELECT YEAR(FechaSistema) AS Anio FROM PARAMETROSSIS );

		INSERT INTO TMP_ANIOSCALENDARIO (Anio)
		SELECT Var_AnioActual;

		WHILE  Incremento <= Cons_TresAnios DO
			INSERT INTO TMP_ANIOSCALENDARIO (Anio)
			SELECT Var_AnioActual+Incremento;
			SET Incremento := Incremento + Cons_Uno;
		END WHILE;

		SELECT MIN(Anio) INTO Var_Anio FROM CALENDARIOINGRESOS;
		IF(Var_Anio<Var_AnioActual) THEN
			INSERT INTO TMP_ANIOSCALENDARIO (Anio)
			SELECT Anio FROM CALENDARIOINGRESOS WHERE Anio < Var_AnioActual GROUP BY Anio;
		END IF;

	   SELECT * FROM TMP_ANIOSCALENDARIO ORDER BY Anio ASC;
	END IF;

END TerminaStore$$
