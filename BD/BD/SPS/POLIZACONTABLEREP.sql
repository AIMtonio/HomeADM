-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- POLIZACONTABLEREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `POLIZACONTABLEREP`;DELIMITER $$

CREATE PROCEDURE `POLIZACONTABLEREP`(
	Par_FechaInicial	date,
	Par_FechaFinal		date,
	Par_Poliza			bigint,
	Par_Transaccion		bigint,
 	Par_Sucursal		bigint,
	Par_Moneda			bigint,
	Par_PrimerRango		varchar(20),
	Par_SegundoRango	varchar(20),
	Par_PrimerCentro	bigint,
	Par_SegundoCentro	bigint,
 	Par_TipoInstrumento	bigint,
	Par_UsuarioID		int(11)
)
TerminaStore: BEGIN

DECLARE	Var_Sentencia	varchar(65535);
DECLARE	Var_SentenUnion	varchar(65535);

DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Cuenta_Vacia	char(25);
DECLARE TipoCliente		int(11);
DECLARE TipoCuenta		int(11);
DECLARE TipoCredito		int(11);
DECLARE TipoInversion	int(11);
DECLARE Var_FechaSis	date;

Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia			:= '1900-01-01';
Set	Cuenta_Vacia		:= '0000000000000000000000000';
Set	Entero_Cero			:= 0;
Set TipoCliente			:= 4;
Set TipoCuenta			:= 2;
Set TipoCredito			:= 11;
Set TipoInversion		:= 13;
Set Var_FechaSis		:=(select FechaSistema from PARAMETROSSIS limit 1);

set Par_Poliza  := ifnull(Par_Poliza, Entero_Cero);

set Var_Sentencia := '(select Pol.Fecha, Pol.Tipo, Pol.PolizaID, Pol.Concepto, Det.Instrumento, Det.CuentaCompleta, Det.Descripcion as DetDescri, Det.Referencia, Det.TipoInstrumentoID, Det.CentroCostoID,  ';
set Var_Sentencia :=  CONCAT(Var_Sentencia, 'round(ifnull(Det.Cargos, 0.00), 2) as Cargos, round(ifnull(Det.Abonos, 0.00),2) as Abonos, Con.DescriCorta as CueDescri, ');
set Var_Sentencia :=  CONCAT(Var_Sentencia, 'Mon.MonedaID, Mon.Descripcion, Suc.SucursalID, Suc.NombreSucurs, Usu.NombreCompleto, ');
set Var_Sentencia :=  CONCAT(Var_Sentencia, ' case  WEEKDAY("',Var_FechaSis,'") when  0 then "Lunes"
													when 1 then "Martes"
													when 2 then "Miercoles"
													when 3 then "Jueves"
													when 4 then "Viernes"
													when 5 then "Sabado"
													when 6 then "Domingo"
												else ""	end as diaActual, TIME_FORMAT(now(),"%r") as formato, Usu.NombreCompleto as NomUsuario, Usu.UsuarioID ');
set Var_Sentencia :=  CONCAT(Var_Sentencia, 'from POLIZACONTABLE Pol ');
set Var_Sentencia :=  CONCAT(Var_Sentencia, 'LEFT OUTER JOIN DETALLEPOLIZA as Det ON Pol.PolizaID = Det.PolizaID ');
set Var_Sentencia :=  CONCAT(Var_Sentencia, 'LEFT OUTER JOIN CUENTASCONTABLES as Con ON Con.CuentaCompleta = Det.CuentaCompleta ');
set Var_Sentencia :=  CONCAT(Var_Sentencia, 'LEFT OUTER JOIN MONEDAS as Mon ON  Det.MonedaID = Mon.MonedaID ');
set Var_Sentencia :=  CONCAT(Var_Sentencia, 'LEFT OUTER JOIN SUCURSALES as Suc ON  Det.Sucursal = Suc.SucursalID ');
set Var_Sentencia :=  CONCAT(Var_Sentencia, 'LEFT OUTER JOIN USUARIOS as Usu ON Pol.Usuario = Usu.UsuarioID ');
if Par_TipoInstrumento != Entero_Cero then
	if Par_TipoInstrumento = TipoCliente then
		set Var_Sentencia :=  CONCAT(Var_Sentencia, 'LEFT OUTER JOIN CUENTASAHO as Cue ON Cue.CuentaAhoID = Det.Instrumento ');
		set Var_Sentencia :=  CONCAT(Var_Sentencia, 'LEFT OUTER JOIN INVERSIONES as Inv ON Inv.InversionID = Det.Instrumento  ');
		set Var_Sentencia :=  CONCAT(Var_Sentencia, 'LEFT OUTER JOIN CREDITOS as Cre ON Cre.CreditoID = Det.Instrumento  ');
	END IF;
END IF;

if Par_Poliza = 0 then
    set Var_Sentencia :=  CONCAT(Var_Sentencia, ' where Pol.Fecha >= ? and Pol.Fecha <= ?' );
	if (Par_UsuarioID != 0 ) then
		set Var_Sentencia := CONCAT(Var_Sentencia, ' and Pol.Usuario=',Par_UsuarioID,' ');
	end if;
end if;





set Var_SentenUnion := '(select Pol.Fecha, Pol.Tipo, Pol.PolizaID, Pol.Concepto, DetHis.Instrumento, DetHis.CuentaCompleta, DetHis.Descripcion as DetDescri, DetHis.Referencia, DetHis.TipoInstrumentoID, DetHis.CentroCostoID, ';
set Var_SentenUnion :=  CONCAT(Var_SentenUnion, 'round(ifnull(DetHis.Cargos, 0.00), 2)as Cargos, round(ifnull(DetHis.Abonos, 0.00), 2) as Abonos, Con.DescriCorta as CueDescri, ');
set Var_SentenUnion :=  CONCAT(Var_SentenUnion, 'Mon.MonedaID, Mon.Descripcion, Suc.SucursalID, Suc.NombreSucurs, Usu.NombreCompleto, ');
set Var_SentenUnion :=  CONCAT(Var_SentenUnion, ' case  WEEKDAY("',Var_FechaSis,'") when  0 then "Lunes"
													when 1 then "Martes"
													when 2 then "Miercoles"
													when 3 then "Jueves"
													when 4 then "Viernes"
													when 5 then "Sabado"
													when 6 then "Domingo"
												else ""	end as diaActual, TIME_FORMAT(now(),"%r") as formato, Usu.NombreCompleto as NomUsuario,Usu.UsuarioID ');
set Var_SentenUnion :=  CONCAT(Var_SentenUnion, 'from `HIS-POLIZACONTA` Pol ');
set Var_SentenUnion :=  CONCAT(Var_SentenUnion, 'LEFT OUTER JOIN `HIS-DETALLEPOL` as DetHis ON Pol.PolizaID = DetHis.PolizaID ');
set Var_SentenUnion :=  CONCAT(Var_SentenUnion, 'LEFT OUTER JOIN CUENTASCONTABLES as Con ON Con.CuentaCompleta = DetHis.CuentaCompleta ');
set Var_SentenUnion :=  CONCAT(Var_SentenUnion, 'LEFT OUTER JOIN MONEDAS as Mon ON  DetHis.MonedaID = Mon.MonedaID ');
set Var_SentenUnion :=  CONCAT(Var_SentenUnion, 'LEFT OUTER JOIN SUCURSALES as Suc ON  DetHis.Sucursal = Suc.SucursalID ');
set Var_SentenUnion :=  CONCAT(Var_SentenUnion, 'LEFT OUTER JOIN USUARIOS as Usu ON Pol.Usuario = Usu.UsuarioID ');
if Par_TipoInstrumento != Entero_Cero then
	if Par_TipoInstrumento = TipoCliente then
		set Var_SentenUnion :=  CONCAT(Var_SentenUnion, 'LEFT OUTER JOIN CUENTASAHO as Cue ON Cue.CuentaAhoID = DetHis.Instrumento  ');
		set Var_SentenUnion :=  CONCAT(Var_SentenUnion, 'LEFT OUTER JOIN INVERSIONES as Inv ON Inv.InversionID = DetHis.Instrumento  ');
		set Var_SentenUnion :=  CONCAT(Var_SentenUnion, 'LEFT OUTER JOIN CREDITOS as Cre ON Cre.CreditoID = DetHis.Instrumento  ');
	END IF;
END IF;


if Par_Poliza = 0 then
    set Var_SentenUnion :=  CONCAT(Var_SentenUnion, ' where Pol.Fecha >= ? and Pol.Fecha <= ?');

	if (Par_UsuarioID != 0 ) then
		set Var_SentenUnion := CONCAT(Var_SentenUnion, ' and Pol.Usuario=',Par_UsuarioID,' ');
	end if;

end if;



set Par_Poliza := ifnull(Par_Poliza, Entero_Cero);

if Par_Poliza != 0 then
	set Var_Sentencia = CONCAT(Var_Sentencia, ' where Pol.PolizaID = ', convert(Par_Poliza, char));
	set Var_SentenUnion :=  CONCAT(Var_SentenUnion, ' where Pol.PolizaID = ', convert(Par_Poliza, char));


end if;



	set Par_TipoInstrumento	:=ifnull(Par_TipoInstrumento, Entero_Cero);
	set Par_PrimerRango	:=ifnull(Par_PrimerRango, Entero_Cero);
	set Par_SegundoRango	:=ifnull(Par_SegundoRango, Entero_Cero);

if Par_TipoInstrumento != Entero_Cero then
	if Par_TipoInstrumento = TipoCliente then
		if cast(Par_PrimerRango as decimal) > Entero_Cero and cast(Par_SegundoRango as decimal) > Entero_Cero then
			if cast(Par_PrimerRango as decimal) = cast(Par_SegundoRango as decimal)  then

			Set Var_Sentencia = CONCAT(Var_Sentencia, ' and ((ifnull(Det.TipoInstrumentoID, ', Entero_Cero ,')= ', TipoCuenta , '  and Cue.ClienteID = ', Par_PrimerRango ,') ');
			Set Var_Sentencia = CONCAT(Var_Sentencia, ' or (ifnull(Det.TipoInstrumentoID, ', Entero_Cero, ')= ', TipoInversion, ' and Inv.ClienteID = ', Par_PrimerRango ,') ');
			Set Var_Sentencia = CONCAT(Var_Sentencia, ' or (ifnull(Det.TipoInstrumentoID, ', Entero_Cero,')= ', TipoCredito , ' and Cre.ClienteID = ', Par_PrimerRango,') ');
			Set Var_Sentencia = CONCAT(Var_Sentencia, ' or (ifnull(Det.TipoInstrumentoID,  ', Entero_Cero, ')= ',TipoCliente,' and Det.Instrumento = ', Par_PrimerRango, ' ) ) ');

		 	Set Var_SentenUnion = CONCAT(Var_SentenUnion, ' and ((ifnull(DetHis.TipoInstrumentoID, ',Entero_Cero, ')= ', TipoCuenta, ' and Cue.ClienteID = ', Par_PrimerRango ,') ');
			Set Var_SentenUnion = CONCAT(Var_SentenUnion, ' or (ifnull(DetHis.TipoInstrumentoID, ', Entero_Cero, ')= ', TipoInversion, ' and Inv.ClienteID = ', Par_PrimerRango ,') ');
			Set Var_SentenUnion = CONCAT(Var_SentenUnion, ' or (ifnull(DetHis.TipoInstrumentoID,  ', Entero_Cero, ')= ', TipoCredito, ' and Cre.ClienteID = ', Par_PrimerRango,') ');
		 	Set Var_SentenUnion = CONCAT(Var_SentenUnion, ' or (ifnull(DetHis.TipoInstrumentoID, ',Entero_Cero, ')= ', TipoCliente,' and DetHis.Instrumento = ', Par_PrimerRango, ' ) ) ');

			end if;
	end if;
	else

		if Par_TipoInstrumento != Entero_Cero then
			set Var_Sentencia = CONCAT(Var_Sentencia, ' and Det.TipoInstrumentoID= ', Par_TipoInstrumento);
			set Var_SentenUnion = CONCAT(Var_SentenUnion, ' and DetHis.TipoInstrumentoID = ', Par_TipoInstrumento);
		end if;
		if cast(Par_PrimerRango as decimal) != Entero_Cero then
			set Var_Sentencia = CONCAT(Var_Sentencia, ' and Det.Instrumento >= ', Par_PrimerRango);
			set Var_SentenUnion = CONCAT(Var_SentenUnion, ' and DetHis.Instrumento >= ', Par_PrimerRango);
		end if;
		if Par_SegundoRango != Entero_Cero then
			set Var_Sentencia = CONCAT(Var_Sentencia, ' and Det.Instrumento <= ', Par_SegundoRango);
			set Var_SentenUnion = CONCAT(Var_SentenUnion, ' and DetHis.Instrumento <= ', Par_SegundoRango);
		end if;
	end if;

end if;



set Par_Moneda := ifnull(Par_Moneda, Entero_Cero);
if Par_Moneda != 0 then
	set Var_Sentencia = CONCAT(Var_Sentencia, ' and Det.MonedaID = ', convert(Par_Moneda, char));
	set Var_SentenUnion = CONCAT(Var_SentenUnion, ' and DetHis.MonedaID = ', convert(Par_Moneda, char));
end if;

set Par_Transaccion := ifnull(Par_Transaccion, Entero_Cero);
if Par_Transaccion != 0 then
	set Var_Sentencia = CONCAT(Var_Sentencia, ' and Pol.NumTransaccion = ', convert(Par_Transaccion, char));
	set Var_SentenUnion = CONCAT(Var_SentenUnion, ' and Pol.NumTransaccion = ', convert(Par_Transaccion, char));
end if;

set Par_Sucursal := ifnull(Par_Sucursal, Entero_Cero);
if Par_Sucursal != 0 then
	set Var_Sentencia = CONCAT(Var_Sentencia, ' and Pol.Sucursal = ', convert(Par_Sucursal, char));
	set Var_SentenUnion = CONCAT(Var_SentenUnion, ' and Pol.Sucursal = ', convert(Par_Sucursal, char));
end if;



if Par_PrimerCentro != Entero_Cero then
	set Var_Sentencia = CONCAT(Var_Sentencia, ' and Det.CentroCostoID >= ', Par_PrimerCentro);
	set Var_SentenUnion = CONCAT(Var_SentenUnion, ' and DetHis.CentroCostoID >= ', Par_PrimerCentro);
end if;

if Par_SegundoCentro != Entero_Cero then
	set Var_Sentencia = CONCAT(Var_Sentencia, ' and Det.CentroCostoID <= ', Par_SegundoCentro);
	set Var_SentenUnion = CONCAT(Var_SentenUnion, ' and DetHis.CentroCostoID <= ', Par_SegundoCentro);
end if;



set Var_Sentencia :=  CONCAT(Var_Sentencia, ' order by Det.MonedaID, Pol.Fecha, Pol.Sucursal, Pol.PolizaID, Det.CuentaCompleta, Det.TipoInstrumentoID, Det.CentroCostoID )');
set Var_SentenUnion :=  CONCAT(Var_SentenUnion, ' order by DetHis.MonedaID, Pol.Fecha, Pol.Sucursal, Pol.PolizaID,DetHis.CuentaCompleta, DetHis.TipoInstrumentoID, DetHis.CentroCostoID)');

SET @Sentencia	= CONCAT(Var_SentenUnion,' UNION ALL ', Var_Sentencia);



SET @FechaIni	= Par_FechaInicial;
SET @FechaFin	= Par_FechaFinal;
PREPARE STPOLIZACONTABLEREP FROM @Sentencia;
if Par_Poliza = 0 then
    EXECUTE STPOLIZACONTABLEREP USING @FechaIni, @FechaFin,@FechaIni, @FechaFin;
else
    EXECUTE STPOLIZACONTABLEREP;
end if;

DEALLOCATE PREPARE STPOLIZACONTABLEREP;

END TerminaStore$$