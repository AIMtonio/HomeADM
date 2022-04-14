-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GENERACHEQUEREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `GENERACHEQUEREP`;DELIMITER $$

CREATE PROCEDURE `GENERACHEQUEREP`(
# ===================================================================
# ----- SP PARA CONSULTAR POLIZAS DE CHEQUES FORMATO PROFORMA -------
# ===================================================================
	Par_FechaInicial	DATE,
	Par_FechaFinal		DATE,
	Par_Poliza			BIGINT(12),
	Par_Transaccion		BIGINT(20),
 	Par_Sucursal		BIGINT(12),
	Par_Moneda			BIGINT(12),
	Par_PrimerRango		VARCHAR(20),
	Par_SegundoRango	VARCHAR(20),
	Par_PrimerCentro	BIGINT(12),
	Par_SegundoCentro	BIGINT(12),
 	Par_TipoInstrumento	BIGINT(12),
	Par_NumeroCheque	BIGINT(12),
	Par_NumConsulta		INT(1),

	Par_EmpresaID		INT(11),
	Aud_Usuario         INT(11),
	Aud_FechaActual     DATE,
	Aud_DireccionIP     VARCHAR(15),
	Aud_ProgramaID      VARCHAR(50),
	Aud_Sucursal        INT(11),
	Aud_NumTransaccion  BIGINT(20)
)
TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE	Var_EstatusPer		CHAR(1);
	DECLARE Var_FechaSis		DATE;
	DECLARE Var_DiaActual		VARCHAR(50);
	DECLARE Var_HoraActual		VARCHAR(50);

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);
	DECLARE	Sta_Cerrado			CHAR(1);
	DECLARE	Sta_Abierto			CHAR(1);
	DECLARE ChequeVentanilla	INT(1);
	DECLARE ChequeDispersion	INT(1);
    DECLARE	TipChequeraPro		CHAR(2);


	-- Asignacion de Constantes
	SET	Cadena_Vacia			:= '';
	SET	Fecha_Vacia				:= '1900-01-01';
	SET	Entero_Cero				:= 0;
	SET	Sta_Cerrado				:= 'C';				-- Estatus del Periodo: Cerrado
	SET	Sta_Abierto				:= 'N';				-- Estatus del Periodo: Abierto
	SET ChequeVentanilla		:= 1;
	SET ChequeDispersion		:= 2;
    SET TipChequeraPro			:= 'P';				-- Tipo de formato del cheque PROFORMA


	SELECT FechaSistema INTO Var_FechaSis
		FROM PARAMETROSSIS
		LIMIT 1;

	SELECT Estatus INTO Var_EstatusPer
		FROM PERIODOCONTABLE
		WHERE Inicio >= Par_FechaInicial
		  AND Fin <= Par_FechaInicial;

	SET	Var_EstatusPer		:= IFNULL(Var_EstatusPer, Sta_Abierto);
	SET Par_Poliza  		:= IFNULL(Par_Poliza, Entero_Cero);
	SET Par_NumeroCheque 	:= IFNULL(Par_NumeroCheque,Entero_Cero);


	SET Var_DiaActual := (CASE  WEEKDAY(Var_FechaSis)
								WHEN  0 THEN "Lunes"
								WHEN 1 THEN "Martes"
								WHEN 2 THEN "Miercoles"
								WHEN 3 THEN "Jueves"
								WHEN 4 THEN "Viernes"
								WHEN 5 THEN "Sabado"
								WHEN 6 THEN "Domingo"
								ELSE ""	END );

	SET Var_HoraActual := TIME_FORMAT(NOW(),"%r");
	IF(Var_EstatusPer = Sta_Abierto) THEN

		IF (Par_NumeroCheque != Entero_Cero)THEN

			SELECT	Cue.CuentaCompleta, SUM(Pol.Cargos)AS Cargos, SUM(Pol.Abonos)AS Abonos,
					Cue.DescriCorta AS CueDescri,
					Var_DiaActual AS diaActual,
					Var_HoraActual AS formato,
					Che.Beneficiario
				FROM 	DETALLEPOLIZA Pol,
						CUENTASCONTABLES Cue,
						CHEQUESEMITIDOS Che
				WHERE 	Pol.PolizaID 		= Par_Poliza
				AND 	Pol.CuentaCompleta 	= Cue.CuentaCompleta
				AND 	Pol.NumTransaccion 	= Che.NumTransaccion
				AND 	Che.TipoChequera 	= TipChequeraPro
				GROUP BY Pol.CuentaCompleta, Cue.CuentaCompleta, Cue.DescriCorta, Che.Beneficiario;


		ELSE
				SELECT	Cue.CuentaCompleta, Pol.Cargos, Pol.Abonos,
						Cue.DescriCorta AS CueDescri,
						Var_DiaActual AS diaActual,
						Var_HoraActual AS formato,
						Che.Beneficiario
					FROM 	DETALLEPOLIZA Pol,
							CUENTASCONTABLES Cue,
							CHEQUESEMITIDOS Che
					WHERE 	Pol.PolizaID 		= Par_Poliza
					AND 	Che.TipoChequera	= TipChequeraPro
					AND 	Pol.CuentaCompleta	= Cue.CuentaCompleta
					AND 	Pol.NumTransaccion 	= Che.NumTransaccion
                    AND 	Pol.Referencia 		= Che.NumeroCheque;
		END IF;


	ELSE
			IF (Par_NumeroCheque != Entero_Cero)THEN
				SELECT	Cue.CuentaCompleta,SUM(Pol.Cargos)AS Cargos,SUM(Pol.Abonos)AS Abonos,
						Cue.DescriCorta AS CueDescri,
						Var_DiaActual AS diaActual,
						Var_HoraActual AS formato,
						Che.Beneficiario
					FROM 	`HIS-DETALLEPOL` Pol,
							CUENTASCONTABLES Cue,
							CHEQUESEMITIDOS Che
					WHERE 	Pol.PolizaID 		= Par_Poliza
					AND 	Pol.Referencia 		= Par_NumeroCheque
					AND 	Pol.CuentaCompleta 	= Cue.CuentaCompleta
					AND 	Pol.NumTransaccion 	= Che.NumTransaccion
                    AND 	Pol.Referencia 		= Che.NumeroCheque
                    AND 	Che.TipoChequera 	= TipChequeraPro
					GROUP BY Pol.CuentaCompleta, Cue.CuentaCompleta, Cue.DescriCorta, Che.Beneficiario;

		ELSE
				SELECT	Cue.CuentaCompleta, Pol.Cargos, Pol.Abonos,
					Cue.DescriCorta AS CueDescri,
					Var_DiaActual AS diaActual,
					Var_HoraActual AS formato,
					Che.Beneficiario
				FROM 	`HIS-DETALLEPOL` Pol,
						CUENTASCONTABLES Cue,
						CHEQUESEMITIDOS Che
				WHERE 	Pol.PolizaID 		= Par_Poliza
				AND 	Che.TipoChequera 	= TipChequeraPro
				AND 	Pol.CuentaCompleta 	= Cue.CuentaCompleta
				AND 	Pol.NumTransaccion 	= Che.NumTransaccion
				AND 	Pol.Referencia 		= Che.NumeroCheque;
		END IF;

	END IF;

END TerminaStore$$