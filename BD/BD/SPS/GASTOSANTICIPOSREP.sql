-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GASTOSANTICIPOSREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `GASTOSANTICIPOSREP`;DELIMITER $$

CREATE PROCEDURE `GASTOSANTICIPOSREP`(
	Par_FechaInicio			DATE,
	Par_FechaFin			DATE,
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATE,

	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT(20)		)
TerminaStore: BEGIN

-- DECLARACION DE VARIABLES --
DECLARE Var_Sentencia	TEXT(80000);
DECLARE Var_SentenUnion	TEXT(80000);

-- DECLARACION DE CONSTANTES --
DECLARE TIPO_INSTEMPLEADO INT(11);
DECLARE Entero_Cero 	  INT(11);

-- ASIGNACION DE CONSTANTES --
SET TIPO_INSTEMPLEADO :=5; -- Tipo Instrumento Empleado
SET Entero_Cero := 0;


DROP TABLE IF EXISTS TMPGASTOSANTISALIDA;
CREATE TEMPORARY TABLE TMPGASTOSANTISALIDA ( 	Sucoperacion		VARCHAR(100),
												CCostoOperacionSuc	INT(11),
												MovEmpleadoSuc		VARCHAR(100),
												CCostoEmpleado		INT(11),
												Salida				DECIMAL(16,2),
												Entrada				DECIMAL(16,2),
												Descripcion			VARCHAR(100),
												TipoInstrumentoID	INT(11),
												Fecha				DATE,
												TipoRegistro		VARCHAR(60),
												NumTransaccion		BIGINT
														);

INSERT INTO TMPGASTOSANTISALIDA (
	Sucoperacion,	CCostoOperacionSuc,	MovEmpleadoSuc,		CCostoEmpleado,	Salida,
    Entrada,		Descripcion, 		TipoInstrumentoID,	Fecha, 			TipoRegistro,
    NumTransaccion)

-- SALIDAS --
SELECT	cen.Descripcion AS SucOperacion,	mo.SucursalID AS CCostoOperacionSuc,	ce.Descripcion AS MovEmpleadoSuc,	de.CentroCostoID AS CCostoEmpleado, sum(de.Cargos) AS Salida,
		0.0,								de.Descripcion, 						de.TipoInstrumentoID, 				de.Fecha, 							"Empleado" AS TipoRegistro,
        MAX(de.NumTransaccion)
	FROM DETALLEPOLIZA de
		INNER JOIN CENTROCOSTOS ce
		ON ce.CentroCostoID = de.CentroCostoID
		INNER JOIN MOVSANTGASTOS mo
		ON mo.NumTransaccion = de.NumTransaccion
		INNER JOIN CENTROCOSTOS cen
		ON cen.CentroCostoID = mo.SucursalID
		WHERE de.Descripcion = "SALIDA DE EFECTIVO GASTOS POR COMPROBAR"
		AND de.TipoInstrumentoID = TIPO_INSTEMPLEADO
		AND mo.SucursalID <> de.CentroCostoID
		AND mo.Fecha BETWEEN Par_FechaInicio AND Par_FechaFin
		GROUP BY mo.SucursalID,de.CentroCostoID,de.Fecha;



-- ENTRADAS --
DROP TABLE IF EXISTS TMPGASTOSANTIENTRADA;
CREATE TEMPORARY TABLE TMPGASTOSANTIENTRADA ( 	Sucoperacion		VARCHAR(100),
												CCostoOperacionSuc	INT(11),
												MovEmpleadoSuc		VARCHAR(100),
												CCostoEmpleado		INT(11),
												Salida				DECIMAL(16,2),
												Entrada				DECIMAL(16,2),
												Descripcion			VARCHAR(100),
												TipoInstrumentoID	INT(11),
												Fecha				DATE,
												TipoRegistro		VARCHAR(60),
												NumTransaccion      BIGINT
														);

INSERT INTO TMPGASTOSANTIENTRADA (Sucoperacion,	CCostoOperacionSuc,	MovEmpleadoSuc,
								CCostoEmpleado,	Salida, Entrada, Descripcion, TipoInstrumentoID, Fecha,
								TipoRegistro,NumTransaccion)

SELECT  cen.Descripcion AS SucOperacion, mo.SucursalID AS CCostoOperacionSuc,ce.Descripcion AS MovEmpleadoSuc,
de.CentroCostoID AS CCostoEmpleado, 0.0, sum(de.Abonos) AS Entrada, de.Descripcion, de.TipoInstrumentoID, de.Fecha,
"Empleado" AS TipoRegistro, MAX(de.NumTransaccion)
		FROM DETALLEPOLIZA de
		INNER JOIN CENTROCOSTOS ce
		ON ce.CentroCostoID = de.CentroCostoID
		INNER JOIN MOVSANTGASTOS mo
		ON mo.NumTransaccion = de.NumTransaccion
		INNER JOIN CENTROCOSTOS cen
		ON cen.CentroCostoID = mo.SucursalID
		WHERE de.Descripcion = "ENTRADA DE EFECTIVO DEVOLUCIONES POR COMPROBAR"
		AND de.TipoInstrumentoID = TIPO_INSTEMPLEADO
		AND mo.SucursalID <> de.CentroCostoID
		AND mo.Fecha BETWEEN Par_FechaInicio AND Par_FechaFin
		GROUP BY mo.SucursalID,de.CentroCostoID,de.Fecha;
-- ********************************************************
SET Var_Sentencia :=' SELECT  MAX(tmp.Sucoperacion) as SucOperacion, tmp.CCostoOperacionSuc as CCostoOperacionSuc,tmp.MovEmpleadoSuc as MovEmpleadoSuc , ';
SET Var_Sentencia :=CONCAT(Var_Sentencia,' MAX(tmp.CCostoEmpleado) as CCostoEmpleado, sum(tmp.Entrada) as Entrada,  sum(tmp.Salida) as Salida, tmp.Fecha as Fecha, "Empleado" as TipoRegistro ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' from ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' (SELECT tmpe.Sucoperacion,tmpe.CCostoOperacionSuc,tmpe.MovEmpleadoSuc,tmpe.CCostoEmpleado, ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' tmpe.Salida,tmpe.Entrada,tmpe.Descripcion,tmpe.TipoInstrumentoID,tmpe.Fecha,tmpe.NumTransaccion ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' from TMPGASTOSANTIENTRADA tmpe ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' union all ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' SELECT tmps.Sucoperacion,tmps.CCostoOperacionSuc,tmps.MovEmpleadoSuc,tmps.CCostoEmpleado, ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' tmps.Salida,tmps.Entrada,tmps.Descripcion,tmps.TipoInstrumentoID,tmps.Fecha,tmps.NumTransaccion ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' from TMPGASTOSANTISALIDA tmps )  as tmp ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' GROUP BY tmp.Fecha, tmp.MovEmpleadoSuc,tmp.CCostoOperacionSuc ');

-- HISTORICO --
DROP TABLE IF EXISTS TMPGASTOSANTISALIDA2;
CREATE TEMPORARY TABLE TMPGASTOSANTISALIDA2 ( 	Sucoperacion		VARCHAR(100),
												CCostoOperacionSuc	INT(11),
												MovEmpleadoSuc		VARCHAR(100),
												CCostoEmpleado		INT(11),
												Salida				DECIMAL(16,2),
												Entrada				DECIMAL(16,2),
												Descripcion			VARCHAR(100),
												TipoInstrumentoID	INT(11),
												Fecha				DATE,
												TipoRegistro		VARCHAR(60),
												NumTransaccion		BIGINT
														);

INSERT INTO TMPGASTOSANTISALIDA2 (Sucoperacion,	CCostoOperacionSuc,	MovEmpleadoSuc,
								CCostoEmpleado,	Salida,Entrada,Descripcion, TipoInstrumentoID, Fecha,
								TipoRegistro, NumTransaccion)
-- SALIDAS --
		SELECT cen.Descripcion AS SucOperacion, mo.SucursalID AS CCostoOperacionSuc,
		 ce.Descripcion AS MovEmpleadoSuc,  deh.CentroCostoID AS CCostoEmpleado,
		SUM(deh.Cargos) AS Salida,0.0, deh.Descripcion, deh.TipoInstrumentoID, deh.Fecha,
		 "Empleado" AS TipoRegistro,MAX(deh.NumTransaccion)
		FROM `HIS-DETALLEPOL` deh
		INNER JOIN CENTROCOSTOS ce
		ON ce.CentroCostoID = deh.CentroCostoID
		INNER JOIN MOVSANTGASTOS mo
		ON mo.NumTransaccion = deh.NumTransaccion
		INNER JOIN CENTROCOSTOS cen
		ON cen.CentroCostoID = mo.SucursalID
		WHERE deh.Descripcion = "SALIDA DE EFECTIVO GASTOS POR COMPROBAR"
		AND deh.TipoInstrumentoID = TIPO_INSTEMPLEADO
		AND mo.SucursalID <> deh.CentroCostoID
		AND mo.Fecha BETWEEN Par_FechaInicio AND Par_FechaFin
		GROUP BY mo.SucursalID,deh.CentroCostoID,deh.Fecha;



-- ENTRADAS --
DROP TABLE IF EXISTS TMPGASTOSANTIENTRADA2;
CREATE TEMPORARY TABLE TMPGASTOSANTIENTRADA2 (
	Sucoperacion		VARCHAR(100),
	CCostoOperacionSuc	INT(11),
	MovEmpleadoSuc		VARCHAR(100),
	CCostoEmpleado		INT(11),
	Salida				DECIMAL(16,2),
	Entrada				DECIMAL(16,2),
	Descripcion			VARCHAR(100),
	TipoInstrumentoID	INT(11),
	Fecha				DATE,
	TipoRegistro		VARCHAR(60),
	NumTransaccion      BIGINT
														);

INSERT INTO TMPGASTOSANTIENTRADA2 (Sucoperacion,	CCostoOperacionSuc,	MovEmpleadoSuc,
								CCostoEmpleado,	Salida, Entrada, Descripcion, TipoInstrumentoID, Fecha,
								TipoRegistro,NumTransaccion)

SELECT  cen.Descripcion AS SucOperacion, mo.SucursalID AS CCostoOperacionSuc,ce.Descripcion AS MovEmpleadoSuc,
deh.CentroCostoID AS CCostoEmpleado, 0.0, sum(deh.Abonos) AS Entrada, deh.Descripcion, deh.TipoInstrumentoID, deh.Fecha,
"Empleado" AS TipoRegistro, MAX(deh.NumTransaccion)
		FROM `HIS-DETALLEPOL` deh
		INNER JOIN CENTROCOSTOS ce
		ON ce.CentroCostoID = deh.CentroCostoID
		INNER JOIN MOVSANTGASTOS mo
		ON mo.NumTransaccion = deh.NumTransaccion
		INNER JOIN CENTROCOSTOS cen
		ON cen.CentroCostoID = mo.SucursalID
		WHERE deh.Descripcion = "ENTRADA DE EFECTIVO DEVOLUCIONES POR COMPROBAR"
		AND deh.TipoInstrumentoID = TIPO_INSTEMPLEADO
		AND mo.SucursalID <> deh.CentroCostoID
		AND mo.Fecha between Par_FechaInicio AND Par_FechaFin
		GROUP BY mo.SucursalID,deh.CentroCostoID,deh.Fecha;
-- ********************************************************
SET Var_SentenUnion :=' SELECT  MAX(tmp2.Sucoperacion) as SucOperacion, tmp2.CCostoOperacionSuc as CCostoOperacionSuc,tmp2.MovEmpleadoSuc as MovEmpleadoSuc , ';
SET Var_SentenUnion :=CONCAT(Var_SentenUnion,' MAX(tmp2.CCostoEmpleado) as CCostoEmpleado, sum(tmp2.Entrada) as Entrada,  sum(tmp2.Salida) as Salida, tmp2.Fecha as Fecha, "Empleado" as TipoRegistro ');
SET Var_SentenUnion :=CONCAT(Var_SentenUnion,' from ');
SET Var_SentenUnion :=CONCAT(Var_SentenUnion,' (SELECT tmpeh.Sucoperacion,tmpeh.CCostoOperacionSuc,tmpeh.MovEmpleadoSuc,tmpeh.CCostoEmpleado, ');
SET Var_SentenUnion :=CONCAT(Var_SentenUnion,' tmpeh.Salida,tmpeh.Entrada,tmpeh.Descripcion,tmpeh.TipoInstrumentoID,tmpeh.Fecha,tmpeh.NumTransaccion ');
SET Var_SentenUnion :=CONCAT(Var_SentenUnion,' from TMPGASTOSANTIENTRADA2 tmpeh ');
SET Var_SentenUnion :=CONCAT(Var_SentenUnion,' union all ');
SET Var_SentenUnion :=CONCAT(Var_SentenUnion,' SELECT tmpsh.Sucoperacion,tmpsh.CCostoOperacionSuc,tmpsh.MovEmpleadoSuc,tmpsh.CCostoEmpleado, ');
SET Var_SentenUnion :=CONCAT(Var_SentenUnion,' tmpsh.Salida,tmpsh.Entrada,tmpsh.Descripcion,tmpsh.TipoInstrumentoID,tmpsh.Fecha,tmpsh.NumTransaccion ');
SET Var_SentenUnion :=CONCAT(Var_SentenUnion,' from TMPGASTOSANTISALIDA2 tmpsh )  as tmp2 ');
SET Var_SentenUnion :=CONCAT(Var_SentenUnion,' GROUP BY tmp2.Fecha, tmp2.MovEmpleadoSuc,tmp2.CCostoOperacionSuc ');


	SET @Sentencia		= CONCAT(Var_Sentencia,'union all',Var_SentenUnion);
	SET @FechaInicio	= Par_FechaInicio;
	SET @FechaFin		= Par_FechaFin;

   PREPARE STGASTOSANTICIPOSREP FROM @Sentencia;
   EXECUTE STGASTOSANTICIPOSREP;
   DEALLOCATE PREPARE STGASTOSANTICIPOSREP;

END TerminaStore$$