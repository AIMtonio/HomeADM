-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_PERIODOSLINEACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TC_PERIODOSLINEACON`;
DELIMITER $$


CREATE PROCEDURE `TC_PERIODOSLINEACON`(
#SP PARA CONSULTAR PERIODOS DE LINEA
	Par_LineaTarCredID      INT(11),	-- Parametro Linea tarjeta Credito ID
    Par_FechaConsulta		DATE,		-- Parametro Fecha Consulta
    Par_NumCon              INT(11),	-- Parametro numero de consulta

    Par_EmpresaID           INT(11),	-- Parametro de Auditoria
    Aud_Usuario             INT(11),	-- Parametro de Auditoria
    Aud_FechaActual         DATETIME,	-- Parametro de Auditoria
    Aud_DireccionIP         VARCHAR(15),-- Parametro de Auditoria
    Aud_ProgramaID          VARCHAR(50),-- Parametro de Auditoria
    Aud_Sucursal            INT(11),	-- Parametro de Auditoria
    Aud_NumTransaccion      BIGINT(20)	-- Parametro de Auditoria
	)

TerminaStore: BEGIN
-- declaracion de variables
DECLARE Var_EstatusCargo	CHAR(1);		-- Variable de Estatus Cargo
DECLARE	Var_EstatusPago		CHAR(1);		-- Variable de Estatus Pago
DECLARE Con_Principal    	INT(11);		-- Consulta Principal
DECLARE Var_SaldoFavor		DECIMAL(16,2);	-- Variable de saldo favor
DECLARE Var_SaldoFecha		DECIMAL(16,2);	-- Variable de saldo fecha
DECLARE Var_MontoDisponible	DECIMAL(16,2);	-- Variable de monto disponible
DECLARE Entero_Cero			INT;			-- entero cero
DECLARE DecimalCero			DECIMAL(16,2);	-- DECIMAL cero
DECLARE FechaVacia			DATE;			-- fecha vacia
DECLARE Var_FechaCorte		DATE;			-- Variable fecha corte

-- Asignacion de Constantes
SET Con_Principal      		:= 1;    -- Consulta Principal
SET Var_EstatusCargo        :='C';
SET Var_EstatusPago			:='A';
SET Entero_Cero 			:= 0;
SET Var_SaldoFavor			:= 0.0;
SET DecimalCero				:= 0.0;
SET FechaVacia				:= '1900-01-01';



	IF (Par_NumCon = Con_Principal) THEN

		SET Var_FechaCorte = (SELECT MAX(FechaCorte) FROM TC_PERIODOSLINEA WHERE FechaCorte <= Par_FechaConsulta AND LineaTarCredID = Par_LineaTarCredID);
        SET Var_FechaCorte = IFNULL(Var_FechaCorte, FechaVacia);

        DROP TABLE IF EXISTS TMPPERIODOSLINEA;
		CREATE TEMPORARY TABLE TMPPERIODOSLINEA(
			Pagos 				DECIMAL(16,2),
            Cargos 				DECIMAL(16,2),
            Intereses			DECIMAL(16,2),
            Comisiones			DECIMAL(16,2),
            SaldoFecha			DECIMAL(16,2),
            SaldoFavor			DECIMAL(16,2),
            SaldoCorte			DECIMAL(16,2),
            MontoLinea			DECIMAL(16,2),
            MontoDisponible		DECIMAL(16,2),
            PagoNoGenInteres	DECIMAL(16,2),
            PagoMinimo			DECIMAL(16,2),
            FechaExigible		DATE,
            FechaProxCorte		DATE
		);

        INSERT INTO TMPPERIODOSLINEA (Pagos,		Cargos,				Intereses,			Comisiones, 		SaldoCorte,
									  MontoLinea, 	MontoDisponible, 	FechaExigible,	    FechaProxCorte, PagoNoGenInteres,
                                      PagoMinimo, 	SaldoFecha, 	SaldoFavor)

        SELECT
			SUM(CASE WHEN TLC.NatMovimiento= Var_EstatusPago THEN IFNULL(TLC.CantidadMov,Entero_Cero) ELSE Entero_Cero END) AS Pagos,
			SUM(CASE WHEN TLC.NatMovimiento = Var_EstatusCargo AND TLC.TipoMovLinID IN(1,2,3,51,52) THEN IFNULL(TLC.CantidadMov,Entero_Cero) ELSE Entero_Cero END) AS Cargos,
			SUM(CASE WHEN TLC.NatMovimiento = Var_EstatusCargo AND TLC.TipoMovLinID IN(10,11,12,20,21,14,15,16) THEN IFNULL(TLC.CantidadMov,Entero_Cero) ELSE Entero_Cero END) AS Interes,
			SUM(CASE WHEN TLC.NatMovimiento = Var_EstatusCargo AND TLC.TipoMovLinID IN(22,23,40,41,42) THEN IFNULL(CantidadMov,Entero_Cero)ELSE Entero_Cero END) AS Comisiones,
			IFNULL(MAX(TPL.SaldoCorte), DecimalCero ) AS SaldoCorte,
			MAX(LT.MontoLinea) AS MontoLinea,
			MAX(LT.MontoDisponible) AS MontoDisponible,
			IFNULL(MAX(TPL.FechaExigible), FechaVacia) AS FechaExigible,
			IFNULL(MAX(TPL.FechaProxCorte),LT.FechaProxCorte) AS FechaProxCorte,
            IFNULL(MAX(CASE WHEN TPL.PagoNoGenInteres-TPL.MontoPagado < 0 THEN 0 ELSE TPL.PagoNoGenInteres-TPL.MontoPagado  END ),DecimalCero) AS PagoNoGenInteres,
            IFNULL(MAX(CASE WHEN TPL.PagoMinimo-TPL.MontoPagado < 0 THEN 0 ELSE TPL.PagoMinimo-TPL.MontoPagado END),DecimalCero) AS PagoMinimo,
			DecimalCero,
			DecimalCero
		FROM LINEATARJETACRED LT
			LEFT OUTER JOIN TC_LINEACREDITOMOVS TLC ON LT.LineaTarCredID=TLC.LineaTarCredID
            AND TLC.FechaConsumo > Var_FechaCorte AND TLC.FechaConsumo <= Par_FechaConsulta
			LEFT OUTER JOIN TC_PERIODOSLINEA TPL ON LT.LineaTarCredID=TPL.LineaTarCredID
            AND TPL.FechaCorte = Var_FechaCorte
		WHERE LT.LineaTarCredID= Par_LineaTarCredID
			GROUP BY LT.LineaTarCredID;

		UPDATE TMPPERIODOSLINEA
				SET SaldoFecha = CASE WHEN (SaldoCorte+Cargos+Intereses+Comisiones-Pagos) < Entero_Cero
								THEN Entero_Cero ELSE (SaldoCorte+Cargos+Intereses+Comisiones-Pagos) END,
					SaldoFavor = CASE WHEN (SaldoCorte+Cargos+Intereses+Comisiones-Pagos) < Entero_Cero
                                THEN ABS(SaldoCorte+Cargos+Intereses+Comisiones-Pagos) ELSE Entero_Cero END,
                    MontoDisponible = MontoLinea - (SaldoCorte+Cargos+Intereses+Comisiones-Pagos);

        SELECT PagoNoGenInteres,	PagoMinimo,			SaldoCorte,		FechaProxCorte,		FechaExigible,
				Pagos,				Cargos,	 			Intereses,		Comisiones,			SaldoFecha,
                SaldoFavor,			MontoDisponible,	MontoLinea
		FROM TMPPERIODOSLINEA;

	END IF;


END TerminaStore$$
