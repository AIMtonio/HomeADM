-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SALDOSCONTABLESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SALDOSCONTABLESCON`;DELIMITER $$

CREATE PROCEDURE `SALDOSCONTABLESCON`(
	Par_NumCon			TINYINT UNSIGNED,		-- numero de consulta
	Par_FechaCreacion	DATE,					-- fecha de consulta
	-- parametros de auditoria
	Aud_EmpresaID		INT,
	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
	)
TerminaStore: BEGIN

-- declaracion de constantes
DECLARE		Entero_Cero		INT;			-- constante para el valor 0
DECLARE		Con_DebeHaber	INT;			-- consulta para el debe y el haber
DECLARE 	Var_UltimoDia	VARCHAR(10);	-- si es el ultimo dia
DECLARE		Cadena_Vacia	CHAR(1);		-- constante para un valor texto vacio.
-- declaracion de varables
DECLARE 	Var_Ejercicio 	INT(11);		-- ejercicion
DECLARE		Var_Periodo		INT(11);		-- perido del ejercicio
DECLARE		Var_FechaIni	DATE;			-- fecha de inicio
DECLARE		Var_FechaFin	DATE;			-- fecha de fin

DECLARE		TipoConsulta	VARCHAR(100);	-- Tipo de la consulta
DECLARE 	Var_FechaUlti	DATE;			-- fecha de ultima a consultar
DECLARE 	NivelDetalle	VARCHAR(50);	-- nivel del detalle para el reporte.
DECLARE 	Par_TipoConsulta CHAR(1);		--  tipo de consulta
DECLARE 	Par_NivelDet	VARCHAR(50);	-- nivel de detalle
-- seteo de valores
SET	Entero_Cero		:= 0;
SET	Con_DebeHaber	:= 1;
SET Cadena_Vacia	:='';

SET TipoConsulta	:='CONTAELECTRONICA';
SET	Var_FechaUlti	:= last_day(Par_FechaCreacion);
SET	NivelDetalle	:='G';
SET Par_TipoConsulta:='D';
SET Par_NivelDet	:='';



SELECT EjercicioID,PeriodoID,Inicio,Fin
INTO  Var_Ejercicio , Var_Periodo,   Var_FechaIni,
      Var_FechaFin
FROM PERIODOCONTABLE
WHERE Inicio =Par_FechaCreacion AND Fin =Var_FechaUlti;

IF(Par_NumCon = Con_DebeHaber) THEN
	SET Var_UltimoDia=last_day(Par_FechaCreacion);

CALL BALANZACONTAREP(Var_Ejercicio,	Var_Periodo,	Var_FechaUlti,
					Par_TipoConsulta, 			'S', 				'P',
					Entero_Cero,	Entero_Cero,	Cadena_Vacia,	Cadena_Vacia, Par_NivelDet,	NivelDetalle,	1,	1,	NOW(),
					Aud_DireccionIP,	TipoConsulta,	1,Entero_Cero);


SELECT tem.CuentaContable AS CuentaCompleta,IFNULL(tem.Cargos,Entero_Cero) AS Debe,
IFNULL(tem.Abonos,Entero_Cero) AS Haber,
		CASE WHEN Cue.Naturaleza = 'D'
					THEN ROUND((tem.SaldoInicial - tem.SaldoInicialAcre),2)
			  WHEN Cue.Naturaleza = 'A'
						THEN ROUND((tem.SaldoInicialAcre -tem.SaldoInicial),2)
					ELSE Entero_Cero END AS SaldoInicial,

			CASE WHEN Cue.Naturaleza = 'D'
						 THEN
               ROUND((tem.SaldoInicial - tem.SaldoInicialAcre),2) +(ROUND(IFNULL(tem.Cargos, Entero_Cero),2) -
                        ROUND(IFNULL(tem.Abonos, Entero_Cero),2))
                 WHEN Cue.Naturaleza = 'A'
						THEN
               ROUND((tem.SaldoInicialAcre -tem.SaldoInicial),2) +( ROUND(IFNULL(tem.Abonos, Entero_Cero),2) -
                        ROUND(IFNULL(tem.Cargos, Entero_Cero),2))
					ELSE Entero_Cero END AS SaldoFinal
FROM temporal_balanza tem
INNER JOIN CUENTASCONTABLES Cue ON tem.CuentaContable = Cue.CuentaCompleta;


 DROP TABLE IF EXISTS temporal_balanza;

END IF;

END TerminaStore$$