-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTACALCAPCONTPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTACALCAPCONTPRO`;
DELIMITER $$

CREATE PROCEDURE `CONTACALCAPCONTPRO`(
-- SP PARA EL CALCULO DEL CAPITAL CONTABLE
    Par_Fecha           DATE,
    Par_EmpresaID       INT,

    Aud_Usuario         INT,
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT,
    Aud_NumTransaccion  BIGINT

)
TerminaStore: BEGIN

DECLARE Var_CtaCapCon   VARCHAR(200);
DECLARE Var_CtaSegmento VARCHAR(50);
DECLARE Var_FechaSaldos DATE;
DECLARE Var_MonCapConta DECIMAL(18,2);

DECLARE Cadena_Vacia    CHAR(1);
DECLARE Entero_Cero     INT;
DECLARE Fecha_Vacia     DATE;
DECLARE Nat_Deudora     CHAR(1);
DECLARE Nat_Acreedora   CHAR(1);

DECLARE Ubi_Actual		CHAR(1);
DECLARE Por_Fecha		CHAR(1);
DECLARE Est_Cerrado		CHAR(1);
DECLARE Var_MinCenCos	INT;
DECLARE Var_MaxCenCos	INT;

DECLARE Var_UltEjercicioCie	INT;
DECLARE Var_UltPeriodoCie	INT;

SET Cadena_Vacia    := '';
SET Entero_Cero     := 0;
SET Fecha_Vacia     := '1900-01-01';
SET Nat_Deudora     := 'D';
SET Nat_Acreedora   := 'A';
SET Ubi_Actual		:= 'A';
SET Por_Fecha		:= 'D';
SET Est_Cerrado		:= 'C';
SET Var_MonCapConta	:=	0;

SELECT CuentasCapConta INTO Var_CtaCapCon
    FROM PARAMETROSSIS
    LIMIT 1;

SET Var_CtaCapCon   := IFNULL(Var_CtaCapCon, Cadena_Vacia);

SET Var_CtaCapCon= TRIM(Var_CtaCapCon);

IF(Var_CtaCapCon != Cadena_Vacia) THEN

    IF(Var_MonCapConta =  Entero_Cero) THEN

		SELECT MAX(EjercicioID) INTO Var_UltEjercicioCie
			FROM PERIODOCONTABLE Per
			WHERE Per.Fin	< Par_Fecha
			  AND  Per.Estatus = Est_Cerrado;

		SELECT  MAX(PeriodoID) INTO Var_UltPeriodoCie
			FROM PERIODOCONTABLE Per
			WHERE Per.EjercicioID	= Var_UltEjercicioCie
			  AND Per.Estatus = Est_Cerrado
			  AND Per.Fin	<= Par_Fecha;

		SELECT MIN(CentroCostoID), MAX(CentroCostoID) INTO Var_MinCenCos, Var_MaxCenCos
			FROM CENTROCOSTOS;

		CALL `EVALFORMULACONTAPRO`(
							Var_CtaCapCon,      Ubi_Actual,		Por_Fecha,          Par_Fecha,      	Var_UltEjercicioCie,
							Var_UltPeriodoCie,  Par_Fecha,		Var_MonCapConta,	Var_MinCenCos,		Var_MaxCenCos,
							Par_EmpresaID,		Aud_Usuario,	Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,
							Aud_Sucursal,   	Aud_NumTransaccion);

		SET Var_MonCapConta	= IFNULL(Var_MonCapConta, Entero_Cero);

		UPDATE PARAMETROSSIS SET
			SaldoCapContable = Var_MonCapConta;

    END IF;

END IF;

DELETE FROM TMPCONTABLE
    WHERE NumeroTransaccion = Aud_NumTransaccion;

END TerminaStore$$