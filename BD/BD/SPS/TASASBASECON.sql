-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TASASBASECON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TASASBASECON`;
DELIMITER $$


CREATE PROCEDURE `TASASBASECON`(
/* SP QUE CONSULTA LAS TASAS BASE */
	Par_TasaBaseID 		INT(11),
	Par_NumCon			TINYINT UNSIGNED,
	Aud_Empresa			INT(11),

	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)

TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_FechaSistema	DATETIME;
DECLARE Var_FecFinMesAnt 	DATE;
DECLARE Var_FecIniMesAnt	DATE;

-- Declaracion de Constantes
DECLARE Cadena_Vacia		CHAR(1);
DECLARE Fecha_Vacia			DATE;
DECLARE Entero_Cero			INT;
DECLARE Con_Principal		INT;
DECLARE Con_TasaBaseHis		INT;
DECLARE Con_UltReg			INT(11);

-- Asignacion de constan	tes
SET	Cadena_Vacia			:= '';
SET	Fecha_Vacia				:= '1900-01-01';
SET	Entero_Cero				:= 0;
SET	Con_Principal			:= 1;
SET	Con_TasaBaseHis			:= 2;
SET Con_UltReg				:= 3;

SELECT FechaSistema INTO Var_FechaSistema
	FROM PARAMETROSSIS
	LIMIT 1;

/* Consulta No 1: Principal*/
IF(Par_NumCon = Con_Principal) THEN
	SELECT	TasaBaseID, 	Nombre, 	Descripcion, 	Valor, 	ClaveCNBV
		FROM TASASBASE
			WHERE  TasaBaseID  = Par_TasaBaseID ;
END IF;

/* Consulta No 2: Tasa Base del Mes Anterior*/
IF(Par_NumCon = Con_TasaBaseHis) THEN
	 --  Validacion Existencia de una tasabase de el mes anterior para creditos con calculo de interes tipo 4
	SET	Var_FecFinMesAnt	:= LAST_DAY(DATE_SUB(Var_FechaSistema, INTERVAL 1 MONTH));
	SET Var_FecIniMesAnt    := DATE_SUB(Var_FecFinMesAnt, INTERVAL DAYOFMONTH(Var_FecFinMesAnt)-1 DAY);

	SELECT	H.TasaBaseID, 	T.Nombre, 	T.Descripcion, 	H.Valor
		FROM TASASBASE T INNER JOIN `HIS-TASASBASE` H ON(T.TasaBaseID=H.TasaBaseID)
			WHERE H.TasaBaseID = Par_TasaBaseID  AND  H.Fecha BETWEEN Var_FecIniMesAnt AND Var_FecFinMesAnt
		LIMIT 1;
END IF;
IF(Par_NumCon = Con_UltReg) THEN
	SELECT	H.TasaBaseID, 	T.Nombre, 	T.Descripcion, 	H.Valor
		FROM TASASBASE T INNER JOIN `HIS-TASASBASE` H ON T.TasaBaseID=H.TasaBaseID
			WHERE H.TasaBaseID = Par_TasaBaseID  AND  H.Fecha < Var_FechaSistema
		ORDER BY H.Fecha DESC
		LIMIT 1;
END IF;

END TerminaStore$$
