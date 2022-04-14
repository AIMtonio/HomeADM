-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PERIODOCONTABLEALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PERIODOCONTABLEALT`;DELIMITER $$

CREATE PROCEDURE `PERIODOCONTABLEALT`(
	Par_EjercicioID		INT,
	Par_TipoPeriodo		CHAR(1),
	Par_Inicio			DATE,
	Par_Fin				DATE,
	Par_EmpresaID			INT,

	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
	)
TerminaStore: BEGIN


DECLARE Var_PeriodoID	INT;


DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT;
DECLARE	Sta_NoCerrado		CHAR(1);
DECLARE	Per_NoCerrado		INT;
DECLARE	Per_Inicial		INT;
DECLARE	Tip_Periodo		INT;


SET	Cadena_Vacia		:= '';
SET	Fecha_Vacia		:= '1900-01-01';
SET	Entero_Cero		:= 0;
SET	Sta_NoCerrado		:= 'N';
SET	Per_Inicial		:= 1;
SET	Tip_Periodo		:= 2;

SET Par_EjercicioID:= (SELECT IFNULL(MAX(EjercicioID),Entero_Cero)
					FROM EJERCICIOCONTABLE);
SET Var_PeriodoID := (SELECT IFNULL(MAX(PeriodoID),Entero_Cero) + 1
						FROM PERIODOCONTABLE
						WHERE EjercicioID = Par_EjercicioID);


IF (Var_PeriodoID = Per_Inicial) THEN

	CALL PARAMETROSSISACT(
		Entero_Cero,		Fecha_Vacia,		Entero_Cero,		Cadena_Vacia,		Cadena_Vacia,
		Entero_Cero,		Cadena_Vacia,		Cadena_Vacia,		Entero_Cero,		Entero_Cero,
		Entero_Cero,		Var_PeriodoID,	Tip_Periodo,		Aud_Usuario,		Aud_FechaActual,
		Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
END IF;

INSERT INTO PERIODOCONTABLE VALUES   (
	Par_EjercicioID,	Var_PeriodoID,	Par_TipoPeriodo,	Par_Inicio,		Par_Fin,
	Fecha_Vacia,		Entero_Cero,		Sta_NoCerrado,	Entero_Cero,	Par_EmpresaID,
    Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
    Aud_NumTransaccion);

SELECT '000' AS NumErr,
	  "Periodo Contable Agregado" AS ErrMen,
	  'inicioEjercicio' AS control;

END TerminaStore$$