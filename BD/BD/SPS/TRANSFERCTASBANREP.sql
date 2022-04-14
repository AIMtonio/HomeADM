-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TRANSFERCTASBANREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `TRANSFERCTASBANREP`;DELIMITER $$

CREATE PROCEDURE `TRANSFERCTASBANREP`(
	Par_FechaInicio			DATE,
	Par_FechaFin			DATE,
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT,
	Aud_FechaActual			DATE,

    Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT(20)
		)
TerminaStore: BEGIN

DECLARE	Var_Sentencia	TEXT(80000);
DECLARE	Var_SentenUnion	TEXT(80000);

-- DECLARACION DE CONSTANTES --
DECLARE Entero_Cero		INT(11);
DECLARE Cadena_Vacia	CHAR(1);
DECLARE Transferencia	INT(11);

-- ASIGNACION DE CONSTANTES --
SET Entero_Cero	:= 0;
SET Cadena_vacia	:='';
SET Transferencia :=100; -- TIPO MOV MOVIMIENTO TRANSFERENCIA ENTRE CUENTAS


DROP TABLE IF EXISTS TMPTRANSFERCTASBAN;
CREATE TEMPORARY TABLE TMPTRANSFERCTASBAN ( CencostoDestino		INT(11),
											MontoTransferido	DECIMAL(16,2),
											Fecha				DATE,
											DesSucDestino		VARCHAR(80),
											NumTransaccion		VARCHAR(80)
														);
INSERT INTO TMPTRANSFERCTASBAN (CencostoDestino,	MontoTransferido,	Fecha,	DesSucDestino,	NumTransaccion)

				SELECT de.CentroCostoID AS CCostosDestino, de.Cargos AS Monto,
					de.Fecha AS Fecha, ce.Descripcion AS SucursalDestino, de.NumTransaccion
					FROM DETALLEPOLIZA de
					INNER JOIN CENTROCOSTOS ce
					ON ce.CentroCostoID = de.CentroCostoID
					INNER JOIN TESORERIAMOVS tes
					ON tes.NumTransaccion = de.NumTransaccion
					WHERE de.Abonos = Entero_Cero
					AND tes.TipoMov = Transferencia
					AND de.Fecha BETWEEN Par_FechaInicio AND Par_FechaFin;
SET Var_Sentencia :='( SELECT de.CentroCostoID as CCostosOrigen,ce.Descripcion as SucursalOrigen, ';
SET Var_Sentencia :=CONCAT(Var_Sentencia,' tmpRec.CencostoDestino as CCostosDestino, tmpRec.DesSucDestino as SucursalDestino, ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' sum(tmpRec.MontoTransferido) as Monto, tmpRec.Fecha as Fecha, '"'Empleado'"' as TipoRegistro ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' from DETALLEPOLIZA de ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' INNER JOIN CENTROCOSTOS ce 	on ce.CentroCostoID = de.CentroCostoID ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' INNER JOIN TESORERIAMOVS tes ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' on tes.NumTransaccion = de.NumTransaccion ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' left  outer join ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' TMPTRANSFERCTASBAN as tmpRec on tmpRec.NumTransaccion = de.NumTransaccion ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' where de.CARGOS = ',Entero_Cero);
SET Var_Sentencia :=CONCAT(Var_Sentencia,' and tes.TipoMov = ',Transferencia);
SET Var_Sentencia :=CONCAT(Var_Sentencia,' and de.Fecha between ? and ? ');
SET Var_Sentencia :=CONCAT(Var_sentencia,' and de.CentroCostoID <> tmpRec.CencostoDestino ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' GROUP BY de.CentroCostoID, de.Fecha, ce.Descripcion, tmpRec.CencostoDestino, tmpRec.DesSucDestino, tmpRec.Fecha ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' Order by  de.Fecha,de.CentroCostoID )');

-- historico --
DROP TABLE IF EXISTS TMPTRANSFERCTASBAN2;
CREATE TEMPORARY TABLE TMPTRANSFERCTASBAN2 (
	CencostoDestino		INT(11),
	MontoTransferido	DECIMAL(16,2),
    Fecha				DATE,
	DesSucDestino		VARCHAR(80),
	NumTransaccion		VARCHAR(80)
														);
INSERT INTO TMPTRANSFERCTASBAN2 (CencostoDestino,	MontoTransferido,	Fecha,	DesSucDestino,	NumTransaccion)

				SELECT deh.CentroCostoID AS CCostosDestino, deh.Cargos AS Monto,
					deh.Fecha AS Fecha, ce.Descripcion AS SucursalDestino, deh.NumTransaccion
					FROM `HIS-DETALLEPOL` deh
					INNER JOIN CENTROCOSTOS ce
					ON ce.CentroCostoID = deh.CentroCostoID
					INNER JOIN TESORERIAMOVS tes
					ON tes.NumTransaccion = deh.NumTransaccion
					WHERE deh.Abonos = Entero_Cero
					AND tes.TipoMov = Transferencia
					AND deh.Fecha BETWEEN Par_FechaInicio AND Par_FechaFin;
SET Var_SentenUnion :='( SELECT deh.CentroCostoID as CCostosOrigen,ce.Descripcion as SucursalOrigen, ';
SET Var_SentenUnion :=CONCAT(Var_SentenUnion,' tmpRec2.CencostoDestino as CCostosDestino, tmpRec2.DesSucDestino as SucursalDestino, ');
SET Var_SentenUnion :=CONCAT(Var_SentenUnion,' sum(tmpRec2.MontoTransferido) as Monto, tmpRec2.Fecha as Fecha, '"'Empleado'"' as TipoRegistro ');
SET Var_SentenUnion :=CONCAT(Var_SentenUnion,' from `HIS-DETALLEPOL` deh ');
SET Var_SentenUnion :=CONCAT(Var_SentenUnion,' INNER JOIN CENTROCOSTOS ce 	on ce.CentroCostoID = deh.CentroCostoID ');
SET Var_SentenUnion :=CONCAT(Var_SentenUnion,' INNER JOIN TESORERIAMOVS tes ');
SET Var_SentenUnion :=CONCAT(Var_SentenUnion,' on tes.NumTransaccion = deh.NumTransaccion ');
SET Var_SentenUnion :=CONCAT(Var_SentenUnion,' left  outer join ');
SET Var_SentenUnion :=CONCAT(Var_SentenUnion,' TMPTRANSFERCTASBAN2 as tmpRec2 on tmpRec2.NumTransaccion = deh.NumTransaccion ');
SET Var_SentenUnion :=CONCAT(Var_SentenUnion,' where deh.CARGOS = ',Entero_Cero);
SET Var_SentenUnion :=CONCAT(Var_SentenUnion,' and tes.TipoMov = ',Transferencia);
SET Var_SentenUnion :=CONCAT(Var_SentenUnion,' and deh.Fecha between ? and ? ');
SET Var_sentenUnion :=CONCAT(Var_SentenUnion,' and deh.CentroCostoID <> tmpRec2.CencostoDestino ');
SET Var_SentenUnion :=CONCAT(Var_SentenUnion,' GROUP BY deh.CentroCostoID, deh.Fecha, ce.Descripcion, tmpRec2.CencostoDestino, tmpRec2.DesSucDestino, tmpRec2.Fecha ');
SET Var_SentenUnion :=CONCAT(Var_SentenUnion,' Order by  deh.Fecha,deh.CentroCostoID )');

SET @Sentencia		= CONCAT(Var_Sentencia,' union all',Var_SentenUnion);
SET @FechaInicio	= Par_FechaInicio;
SET @FechaFin		= Par_FechaFin;

PREPARE STTRANSFCTABANREP FROM @Sentencia;
EXECUTE STTRANSFCTABANREP  USING @FechaInicio, @FechaFin,@FechaInicio, @FechaFin;
DEALLOCATE PREPARE STTRANSFCTABANREP;


END TerminaStore$$