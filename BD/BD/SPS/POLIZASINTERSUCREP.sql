-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- POLIZASINTERSUCREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `POLIZASINTERSUCREP`;DELIMITER $$

CREATE PROCEDURE `POLIZASINTERSUCREP`(
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
-- DECLARACIONDE VARIABLES --
DECLARE	Var_Sentencia	TEXT(80000);
DECLARE Var_SentenUnion	TEXT(80000);
-- DECLARACION DE CONSTANTES --
DECLARE Entero_Cero 	INT(11);
DECLARE Cadena_Vacia 	VARCHAR(1);
-- ASIGNACION DE CONSTANTES --
SET Entero_Cero 	:=0;
SET Cadena_vacia	:='';


DROP TABLE IF EXISTS TMPPOLIZASINTERORI;
CREATE TEMPORARY TABLE TMPPOLIZASINTERORI ( CencostoOrigen		INT(11),
											CencostoDestino 	INT(11),
											MontoTransferido	DECIMAL(16,2),
											Fecha				DATE,
											DesSucOrigen		VARCHAR(80),
											DesSucDestino		VARCHAR(80),
											NumTransaccion		VARCHAR(80),
											PolizaID			INT(11),
											Consecutivo			INT(11),
												INDEX (Consecutivo)
														);
SET @consecutivo := 0;
INSERT INTO TMPPOLIZASINTERORI (CencostoOrigen,CencostoDestino,	MontoTransferido,Fecha,	DesSucOrigen,
						DesSucDestino,	NumTransaccion, PolizaID, Consecutivo)
				-- CENTRO DE COSTOS QUE ENVIA (ABONO) --
				SELECT de.CentroCostoID AS CCostosOrigen,Entero_Cero, de.Abonos AS Monto,
					de.Fecha AS Fecha, ce.Descripcion AS SucursalOrigen,Cadena_Vacia, de.NumTransaccion, de.PolizaID,
					@consecutivo := @consecutivo+1
					FROM DETALLEPOLIZA de
					INNER JOIN CENTROCOSTOS ce
					ON ce.CentroCostoID = de.CentroCostoID
					WHERE  de.DESCRIPCION = 'POLIZAS INTERSUCURSALES'
					AND de.Cargos = Entero_Cero
					AND de.Fecha BETWEEN Par_FechaInicio AND Par_FechaFin;


DROP TABLE IF EXISTS TMPPOLIZASINTERDES;
CREATE TEMPORARY TABLE TMPPOLIZASINTERDES ( CencostoOrigen 		INT(11),
											CencostoDestino		INT(11),
											MontoTransferido	DECIMAL(16,2),
											Fecha				DATE,
											DesSucOrigen    	VARCHAR(80),
											DesSucDestino		VARCHAR(80),
											NumTransaccion		VARCHAR(80),
											PolizaID			INT(11),
											Consecutivo			INT(11) ,
												INDEX (Consecutivo)
														);
SET @consecutivo := 0;

INSERT INTO TMPPOLIZASINTERDES (CencostoOrigen,CencostoDestino,	MontoTransferido,Fecha,DesSucOrigen,
				DesSucDestino,	NumTransaccion, PolizaID, Consecutivo)
				-- CENTRO DE COSTOS QUE RECIBE (CARGO) --
				SELECT Entero_Cero AS CencostoOrigen,de.CentroCostoID AS CCostosDestino, de.Cargos AS Monto,
					de.Fecha AS Fecha,Cadena_Vacia, ce.Descripcion as SucursalDestino, de.NumTransaccion, de.PolizaID,
					@consecutivo := @consecutivo+1
					FROM DETALLEPOLIZA de
					INNER JOIN CENTROCOSTOS ce
					ON ce.CentroCostoID = de.CentroCostoID
					WHERE  de.DESCRIPCION = 'POLIZAS INTERSUCURSALES'
					AND de.Abonos = Entero_Cero
					AND de.Fecha BETWEEN Par_FechaInicio AND Par_FechaFin;

DROP TABLE IF EXISTS TMPPOLIZASINTERFINAL;
CREATE TEMPORARY TABLE TMPPOLIZASINTERFINAL ( CencostoOrigen 	INT(11),
											SucursalOrigen 		VARCHAR(100),
											CCostoDestino		INT(11),
											SucursalDestino		VARCHAR(100),
											Monto 				DECIMAL(16,2),
											Fecha 				DATE,
											Consecutivo			INT(11)
														);
INSERT INTO TMPPOLIZASINTERFINAL (CencostoOrigen,SucursalOrigen,	CCostoDestino,SucursalDestino,	Monto,
						Fecha,	Consecutivo)
-- llena tabla final, agrupa por centro de costos y sumariza --
SELECT MAX(tmp.CencostoOrigen),MAX(tmp.DesSucOrigen), MAX(tmp.CencostoDestino),
		max(tmp.DesSucDestino),MAX(tmp.MontoTransferido),MAX(tmp.Fecha), tmp.Consecutivo
FROM
((SELECT * FROM TMPPOLIZASINTERORI tmpo)
UNION ALL
(SELECT * FROM TMPPOLIZASINTERDES tmpd)) AS tmp
GROUP BY tmp.Consecutivo;
-- *** resultado final ***--
SET Var_Sentencia :=' (SELECT CencostoOrigen as CCostosOrigen,SucursalOrigen as SucursalOrigen, CCostoDestino as CCostosDestino,SucursalDestino as SucursalDestino, ';
SET Var_Sentencia :=CONCAT(Var_Sentencia,' sum(Monto) as Monto,Fecha as Fecha, Consecutivo, "Poliza Contable Intersuc." as TipoRegistro ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' from TMPPOLIZASINTERFINAL ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' GROUP BY CencostoOrigen, SucursalOrigen, CCostoDestino, SucursalDestino, Fecha, Consecutivo ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' Order by Fecha,CencostoOrigen, CCostoDestino) ');

-- HISTORICO --
DROP TABLE IF EXISTS TMPPOLIZASINTERORI2;
CREATE TEMPORARY TABLE TMPPOLIZASINTERORI2 ( CencostoOrigen		INT(11),
											CencostoDestino  	INT(11),
											MontoTransferido	DECIMAL(16,2),
											Fecha				DATE,
											DesSucOrigen		VARCHAR(80),
											DesSucDestino		VARCHAR(80),
											NumTransaccion		VARCHAR(80),
											PolizaID			INT(11),
											Consecutivo			INT(11),
												INDEX (Consecutivo)
														);
SET @consecutivo := 0;
INSERT INTO TMPPOLIZASINTERORI2 (CencostoOrigen,CencostoDestino,	MontoTransferido,Fecha,	DesSucOrigen,
						DesSucDestino,	NumTransaccion, PolizaID, Consecutivo)
				-- CENTRO DE COSTOS QUE ENVIA (ABONO) --
				SELECT deh.CentroCostoID AS CCostosOrigen,Entero_Cero, deh.Abonos AS Monto,
					deh.Fecha AS Fecha, ce.Descripcion AS SucursalOrigen,Cadena_Vacia, deh.NumTransaccion, deh.PolizaID,
					@consecutivo := @consecutivo+1
					FROM `HIS-DETALLEPOL` deh
					INNER JOIN CENTROCOSTOS ce
					ON ce.CentroCostoID = deh.CentroCostoID
					WHERE  deh.DESCRIPCION = 'POLIZAS INTERSUCURSALES'
					AND deh.Cargos = Entero_Cero
					AND deh.Fecha BETWEEN Par_FechaInicio AND Par_FechaFin;


DROP TABLE IF EXISTS TMPPOLIZASINTERDES2;
CREATE TEMPORARY TABLE TMPPOLIZASINTERDES2 ( CencostoOrigen 	INT(11),
											CencostoDestino		INT(11),
											MontoTransferido	DECIMAL(16,2),
											Fecha				DATE,
											DesSucOrigen    	VARCHAR(80),
											DesSucDestino		VARCHAR(80),
											NumTransaccion		VARCHAR(80),
											PolizaID			INT(11),
											Consecutivo			INT(11) ,
												INDEX (Consecutivo)
														);
SET @consecutivo := 0;

INSERT INTO TMPPOLIZASINTERDES2 (CencostoOrigen,CencostoDestino,	MontoTransferido,Fecha,DesSucOrigen,
				DesSucDestino,	NumTransaccion, PolizaID, Consecutivo)
				-- CENTRO DE COSTOS QUE RECIBE (CARGO) --
				SELECT Entero_Cero AS CencostoOrigen,deh.CentroCostoID AS CCostosDestino, deh.Cargos as Monto,
					deh.Fecha AS Fecha,Cadena_Vacia, ce.Descripcion AS SucursalDestino, deh.NumTransaccion, deh.PolizaID,
					@consecutivo := @consecutivo+1
					FROM `HIS-DETALLEPOL` deh
					INNER JOIN CENTROCOSTOS ce
					ON ce.CentroCostoID = deh.CentroCostoID
					WHERE  deh.DESCRIPCION = 'POLIZAS INTERSUCURSALES'
					AND deh.Abonos = Entero_Cero
					AND deh.Fecha BETWEEN Par_FechaInicio AND Par_FechaFin;


DROP TABLE IF EXISTS TMPPOLIZASINTERFINAL2;
CREATE TEMPORARY TABLE TMPPOLIZASINTERFINAL2 (  CencostoOrigen 	INT(11),
												SucursalOrigen 	VARCHAR(100),
												CCostoDestino	INT(11),
												SucursalDestino	VARCHAR(100),
												Monto 			DECIMAL(16,2),
												Fecha 			DATE,
												Consecutivo		INT(11)
														);
INSERT INTO TMPPOLIZASINTERFINAL2 (CencostoOrigen,SucursalOrigen,	CCostoDestino,SucursalDestino,	Monto,
						Fecha,	Consecutivo)
-- llena tabla final, agrupa por centro de costos y sumariza --
SELECT MAX(tmp.CencostoOrigen),MAX(tmp.DesSucOrigen), MAX(tmp.CencostoDestino),
		MAX(tmp.DesSucDestino),MAX(tmp.MontoTransferido),MAX(tmp.Fecha), tmp.Consecutivo
FROM
((SELECT * FROM TMPPOLIZASINTERORI2 tmpo)
UNION ALL
(SELECT * FROM TMPPOLIZASINTERDES2 tmpd)) AS tmp
GROUP BY tmp.Consecutivo;
-- *** resultado final ***--
SET Var_SentenUnion :=' (SELECT CencostoOrigen as CCostosOrigen,SucursalOrigen as SucursalOrigen, CCostoDestino as CCostosDestino,SucursalDestino as SucursalDestino, ';
SET Var_SentenUnion :=CONCAT(Var_SentenUnion,' sum(Monto) as Monto,Fecha as Fecha, Consecutivo, "Poliza Contable Intersuc." as TipoRegistro ');
SET Var_SentenUnion :=CONCAT(Var_SentenUnion,' from TMPPOLIZASINTERFINAL2 ');
SET Var_SentenUnion :=CONCAT(Var_SentenUnion,' GROUP BY CencostoOrigen, SucursalOrigen, CCostoDestino, SucursalDestino, Fecha, Consecutivo ');
SET Var_SentenUnion :=CONCAT(Var_SentenUnion,' Order by Fecha,CencostoOrigen, CCostoDestino); ');

SET @Sentencia		= CONCAT(Var_Sentencia,' union all ',Var_SentenUnion);

PREPARE STPOLIZASINTERSREP FROM @Sentencia;
EXECUTE STPOLIZASINTERSREP;
DEALLOCATE PREPARE STPOLIZASINTERSREP;


END TerminaStore$$