-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- POLIZACHEQUEREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `POLIZACHEQUEREP`;DELIMITER $$

CREATE PROCEDURE `POLIZACHEQUEREP`(
	Par_NumCheque		BIGINT,
	Par_Poliza			BIGINT,
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT,
	Aud_FechaActual		DATE,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT(20)
			)
TerminaStore: BEGIN

DECLARE	Var_Sentencia	TEXT(80000);
DECLARE	Var_SentenciaH	TEXT(80000);
DECLARE Var_FechaSis	DATE;
DECLARE Var_Monto       DECIMAL(16,2);  -- monto del cheque
DECLARE Var_MontoLetras VARCHAR(250);   -- monto con letras

SET Var_FechaSis		:=(SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

SET Var_Monto           :=(SELECT ce.Monto
						FROM CHEQUESEMITIDOS ce,
							 POLIZACONTABLE pc
						WHERE ce.NumTransaccion = pc.NumTransaccion
						  AND ce.NumeroCheque = Par_NumCheque
						  AND pc.PolizaID = Par_Poliza);

SET Var_MontoLetras := FUNCIONNUMLETRAS(Var_Monto);
SET Var_MontoLetras	:= CONCAT(Var_MontoLetras, ' M.N.');

SET Var_Sentencia 	:=' (SELECT Pol.Fecha, Pol.Tipo, Pol.PolizaID, Pol.Concepto, Det.Instrumento, Det.CuentaCompleta, Det.Descripcion as DetDescri, Det.Referencia, Det.TipoInstrumentoID, Det.CentroCostoID, ';
SET Var_Sentencia 	:=CONCAT(Var_Sentencia,' round(ifnull(Det.Cargos, 0.00), 2) as Cargos, round(ifnull(Det.Abonos, 0.00),2) as Abonos, Con.DescriCorta as CueDescri, ');
SET Var_Sentencia 	:=CONCAT(Var_Sentencia,' Mon.MonedaID, Mon.Descripcion, Suc.SucursalID, Suc.NombreSucurs, Usu.NombreCompleto, ');
SET Var_Sentencia 	:=CONCAT(Var_Sentencia,' case  WEEKDAY("',Var_FechaSis,'") when  0 then "Lunes" ');
SET Var_Sentencia 	:=CONCAT(Var_Sentencia,' when 1 then "Martes" ');
SET Var_Sentencia 	:=CONCAT(Var_Sentencia,' when 2 then "Miercoles" ');
SET Var_Sentencia 	:=CONCAT(Var_Sentencia,' when 3 then "Jueves" ');
SET Var_Sentencia 	:=CONCAT(Var_Sentencia,' when 4 then "Viernes" ');
SET Var_Sentencia 	:=CONCAT(Var_Sentencia,' when 5 then "Sabado" ');
SET Var_Sentencia 	:=CONCAT(Var_Sentencia,' when 6 then "Domingo" ');
SET Var_Sentencia 	:=CONCAT(Var_Sentencia,' else ""	end as diaActual, TIME_FORMAT(now(),"%r") as formato, ');
SET Var_Sentencia 	:=CONCAT(Var_Sentencia,' mun.Nombre as NomMun, est.Nombre as NomEst,');
SET Var_Sentencia 	:=CONCAT(Var_Sentencia,' "',Var_Monto,'" as Monto,');
SET Var_Sentencia 	:=CONCAT(Var_Sentencia,' "',Var_MontoLetras,'" as MontoLetras ');
SET Var_Sentencia 	:=CONCAT(Var_Sentencia,' from POLIZACONTABLE Pol ');
SET Var_Sentencia 	:=CONCAT(Var_Sentencia,' LEFT OUTER JOIN DETALLEPOLIZA as Det ON Pol.PolizaID = Det.PolizaID ');
SET Var_Sentencia 	:=CONCAT(Var_Sentencia,' LEFT OUTER JOIN CUENTASCONTABLES as Con ON Con.CuentaCompleta = Det.CuentaCompleta ');
SET Var_Sentencia 	:=CONCAT(Var_Sentencia,' LEFT OUTER JOIN MONEDAS as Mon ON  Det.MonedaID = Mon.MonedaID ');
SET Var_sentencia 	:=CONCAT(Var_Sentencia,' LEFT OUTER JOIN SUCURSALES as Suc ON  Det.Sucursal = Suc.SucursalID ');
SET Var_sentencia 	:=CONCAT(Var_Sentencia,' LEFT OUTER JOIN MUNICIPIOSREPUB as mun ON Suc.MunicipioID  = mun.MunicipioID');
SET Var_sentencia 	:=CONCAT(Var_Sentencia,' LEFT OUTER JOIN ESTADOSREPUB as est ON mun.EstadoID = est.EstadoID ');
SET Var_Sentencia 	:=CONCAT(Var_Sentencia,' LEFT OUTER JOIN USUARIOS as Usu ON Pol.Usuario = Usu.UsuarioID ');
SET Var_Sentencia 	:=CONCAT(Var_Sentencia,' where Det.Referencia =',Par_NumCheque);
SET Var_Sentencia 	:=CONCAT(Var_Sentencia,' and Det.PolizaID =',Par_Poliza);
SET Var_Sentencia 	:=CONCAT(Var_Sentencia,' and mun.MunicipioID =  Suc.MunicipioID');
SET Var_Sentencia 	:=CONCAT(Var_Sentencia,' and est.EstadoID  = Suc.EstadoID)');

-- HISTORICO --
SET Var_SentenciaH :=' (SELECT Pol.Fecha, Pol.Tipo, Pol.PolizaID, Pol.Concepto, Deth.Instrumento, Deth.CuentaCompleta, Deth.Descripcion as DetDescri, Deth.Referencia, Deth.TipoInstrumentoID, Deth.CentroCostoID, ';
SET Var_SentenciaH :=CONCAT(Var_SentenciaH,' round(ifnull(Deth.Cargos, 0.00), 2) as Cargos, round(ifnull(Deth.Abonos, 0.00),2) as Abonos, Con.DescriCorta as CueDescri, ');
SET Var_SentenciaH :=CONCAT(Var_SentenciaH,' Mon.MonedaID, Mon.Descripcion, Suc.SucursalID, Suc.NombreSucurs, Usu.NombreCompleto, ');
SET Var_SentenciaH :=CONCAT(Var_SentenciaH,' case  WEEKDAY("',Var_FechaSis,'") when  0 then "Lunes" ');
SET Var_SentenciaH :=CONCAT(Var_SentenciaH,' when 1 then "Martes" ');
SET Var_SentenciaH :=CONCAT(Var_SentenciaH,' when 2 then "Miercoles" ');
SET Var_SentenciaH :=CONCAT(Var_SentenciaH,' when 3 then "Jueves" ');
SET Var_SentenciaH :=CONCAT(Var_SentenciaH,' when 4 then "Viernes" ');
SET Var_SentenciaH :=CONCAT(Var_SentenciaH,' when 5 then "Sabado" ');
SET Var_SentenciaH :=CONCAT(Var_SentenciaH,' when 6 then "Domingo" ');
SET Var_SentenciaH :=CONCAT(Var_SentenciaH,' else ""	end as diaActual, TIME_FORMAT(now(),"%r") as formato, ');
SET Var_SentenciaH :=CONCAT(Var_SentenciaH,' mun.Nombre as NomMun, est.Nombre as NomEst,');
SET Var_SentenciaH :=CONCAT(Var_SentenciaH,' "',Var_Monto,'" as Monto,');
SET Var_SentenciaH :=CONCAT(Var_SentenciaH,' "',Var_MontoLetras,'" as MontoLetras ');
SET Var_SentenciaH :=CONCAT(Var_SentenciaH,' from POLIZACONTABLE Pol ');
SET Var_SentenciaH :=CONCAT(Var_SentenciaH,' LEFT OUTER JOIN `HIS-DETALLEPOL` as Deth ON Pol.PolizaID = Deth.PolizaID ');
SET Var_SentenciaH :=CONCAT(Var_SentenciaH,' LEFT OUTER JOIN CUENTASCONTABLES as Con ON Con.CuentaCompleta = Deth.CuentaCompleta ');
SET Var_SentenciaH :=CONCAT(Var_SentenciaH,' LEFT OUTER JOIN MONEDAS as Mon ON  Deth.MonedaID = Mon.MonedaID ');
SET Var_SentenciaH :=CONCAT(Var_SentenciaH,' LEFT OUTER JOIN SUCURSALES as Suc ON  Deth.Sucursal = Suc.SucursalID ');
SET Var_SentenciaH :=CONCAT(Var_SentenciaH,' LEFT OUTER JOIN MUNICIPIOSREPUB as mun ON Suc.MunicipioID  = mun.MunicipioID');
SET Var_SentenciaH :=CONCAT(Var_SentenciaH,' LEFT OUTER JOIN ESTADOSREPUB as est ON mun.EstadoID = est.EstadoID ');
SET Var_SentenciaH :=CONCAT(Var_SentenciaH,' LEFT OUTER JOIN USUARIOS as Usu ON Pol.Usuario = Usu.UsuarioID ');
SET Var_SentenciaH :=CONCAT(Var_SentenciaH,' where Deth.Referencia =',Par_NumCheque);
SET Var_SentenciaH :=CONCAT(Var_SentenciaH,' and Deth.PolizaID =',Par_Poliza);
SET Var_SentenciaH :=CONCAT(Var_SentenciaH,' and mun.MunicipioID =  Suc.MunicipioID');
SET Var_SentenciaH :=CONCAT(Var_SentenciaH,' and est.EstadoID  = Suc.EstadoID)');

SET @Sentencia = CONCAT(Var_Sentencia,' UNION ALL ', Var_SentenciaH);
PREPARE POLIZACHEQUEREP FROM @Sentencia;
EXECUTE POLIZACHEQUEREP;
DEALLOCATE PREPARE POLIZACHEQUEREP;
END TerminaStore$$