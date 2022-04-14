-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGB141300003REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGB141300003REP`;DELIMITER $$

CREATE PROCEDURE `REGB141300003REP`(
# ==================================================================
# -- Genera la llamada al regulatorio B1413 para Sofipo ----
# ==================================================================
	Par_Anio           		INT(11),			--  Ano del Reporte
	Par_Mes					INT(11),			-- Mes del Reporte
	Par_NumRep				TINYINT UNSIGNED, 	-- Numero de Reporte 1 - Excel  2 - CSV

    Par_EmpresaID       	INT(11),			-- Empresa ID
    Aud_Usuario         	INT(11),            -- Usuario ID
    Aud_FechaActual     	DATETIME,           -- Fecha Actual
    Aud_DireccionIP     	VARCHAR(15),        -- Direccion IP
    Aud_ProgramaID      	VARCHAR(50),        -- Programa ID
    Aud_Sucursal        	INT(11),            -- Sucursal ID
    Aud_NumTransaccion		BIGINT(20)          -- Numero de transaccion
)
TerminaStore:BEGIN
	-- Variables
	DECLARE Var_Periodo 		VARCHAR(8);		-- periodo
	DECLARE Var_ClaveEntidad 	VARCHAR(10);	-- clave de la entidad
    DECLARE Var_ClaveNivelEnti	VARCHAR(10);	-- clave que tendra la institucion
    DECLARE Var_UltimoRegistro	INT(11);		-- Ultimo registro de la tabla NIVELPRUDENOPERAINS
    DECLARE Var_Anio 			INT(11);		-- ano en que se registro la clave
    DECLARE Var_Mes 			INT(11);		-- Mes en que se registro la clave
    DECLARE Var_FechaPeriodo	DATE;			-- Fecha que conformara el periodo
	-- Constantes
	DECLARE Rep_Excel		INT;
	DECLARE Rep_Csv			INT;
	DECLARE NumReporte		VARCHAR(10);
	DECLARE Entero_Uno 		INT;
	DECLARE Entero_Cero		INT;
	DECLARE Entero_Diez		INT;
	DECLARE Cadena_Vacia 	CHAR(1);
	-- Asignacion de constantes
	SET NumReporte			:= '1413';		-- Clave del reporte
	SET Rep_Excel 			:= 1 ;			-- Reporte en excel
	SET Rep_Csv	  			:= 2;			-- Reporte CSV
	SET Entero_Uno 			:= 1;			-- Entero Uno
	SET Entero_Cero			:= 0;			-- Enetero Cero
    SET Entero_Diez			:= 10;			-- Entero 10
	SET Cadena_Vacia 		:= '';			-- Cadena vacia

	SET Var_Periodo	:= CONCAT(Par_Anio,CASE WHEN Par_Mes < Entero_Diez THEN CONCAT(Entero_Cero,Par_Mes) ELSE Par_Mes END);

	SELECT IFNULL(ClaveEntidad, Cadena_Vacia) INTO Var_ClaveEntidad
		FROM PARAMREGULATORIOS WHERE ParametrosID = Entero_Uno;

    SET Var_ClaveNivelEnti := (SELECT ClaveNivInstitucion FROM NIVELPRUDENOPERAINS
										WHERE Anio = Par_Anio
											AND Mes = Par_Mes);

	SET Var_ClaveNivelEnti:= IFNULL(Var_ClaveNivelEnti,Cadena_Vacia);

    -- No existe registro de clave en dicho periodo
    IF(Var_ClaveNivelEnti = Cadena_Vacia )THEN

		SET Var_UltimoRegistro := (SELECT MAX(NivelPrudOperaID) FROM NIVELPRUDENOPERAINS);

		SET Var_FechaPeriodo   := CONCAT(Par_Anio,'-',Par_Mes,'-','01');

		IF(Var_UltimoRegistro = Entero_Uno )THEN

			SET Var_ClaveNivelEnti := (SELECT ClaveNivInstitucion  FROM NIVELPRUDENOPERAINS WHERE NivelPrudOperaID = Entero_Uno);

		ELSE

			SET Var_ClaveNivelEnti := ( SELECT ClaveNivInstitucion FROM NIVELPRUDENOPERAINS
				WHERE  FechaPeriodo <= Var_FechaPeriodo ORDER BY NivelPrudOperaID DESC LIMIT Entero_Uno);

			SET Var_ClaveNivelEnti:= IFNULL(Var_ClaveNivelEnti,Cadena_Vacia);

			IF(Var_ClaveNivelEnti = Cadena_Vacia )THEN

				SET Var_ClaveNivelEnti := ( SELECT ClaveNivInstitucion FROM NIVELPRUDENOPERAINS
					WHERE NivelPrudOperaID = Entero_Uno);

            END IF;
		END IF;
    END IF;

	IF Par_NumRep = Rep_Excel THEN
		SELECT Var_Periodo AS Periodo,	Var_ClaveEntidad AS ClaveEntidad,		NumReporte AS Subreporte ,		Var_ClaveNivelEnti AS ClaveNivelEntidad;
	END IF;

	IF Par_NumRep = Rep_Csv THEN
		SELECT CONCAT(
				NumReporte, 	';',
				Var_ClaveNivelEnti
			   ) AS Valor;
	END IF;

END TerminaStore$$