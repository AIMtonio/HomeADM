-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAJASMOVSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CAJASMOVSLIS`;DELIMITER $$

CREATE PROCEDURE `CAJASMOVSLIS`(
	Par_SucursalID		int(11),
	Par_CajaID			int(11),
	Par_Fecha			date,
	Par_TipoOpe			int(11),

	Par_NumLis			tinyint unsigned,


	Par_EmpresaID		int(11),
	Aud_Usuario			int(11),
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int(11),
	Aud_NumTransaccion	bigint(20)
	)
TerminaStore: BEGIN


DECLARE Entero_Cero     int;
DECLARE Cadena_Vacia    char(1);
DECLARE Fecha_Vacia     date;
DECLARE Lis_ReversaTran int;
DECLARE Ope_CargoCta    int;
DECLARE Ope_AbonoCta    int;
DECLARE Ope_PagoCred    int;
DECLARE Ope_DepGarLiq   int;
DECLARE Ope_ComApeCre   int;
DECLARE Ope_DesemCred   int;
DECLARE Ope_CobSegVida  int;
DECLARE Ope_AplSegVida  int;
DECLARE EstatusCredInactivo	char(1);


set Entero_Cero     := 0;
set Cadena_Vacia    := '';
set Fecha_Vacia     := '1900-01-01';

set Ope_CargoCta    := 11;
set Ope_AbonoCta    := 21;
set Ope_PagoCred    := 28;
set Ope_DepGarLiq   := 22;
set Ope_ComApeCre   := 23;
set Ope_DesemCred   := 10;
set Ope_CobSegVida  := 38;
set Ope_AplSegVida  := 17;
set EstatusCredInactivo	:='I';

set Lis_ReversaTran := 1;


if(Par_NumLis = Lis_ReversaTran) then

    case Par_TipoOpe
        when Ope_AbonoCta then
            SELECT Mov.Transaccion,	format(Mov.MontoEnFirme,2) as MontoEnFirme,
                   Mov.Referencia as Instrumento,
                   Cli.NombreCompleto as Cliente
                from CAJASMOVS Mov,
                     CLIENTES Cli,
                     CUENTASAHO Cue
                where Mov.SucursalID = Par_SucursalID
                  and Mov.CajaID = Par_CajaID
                  and Mov.Fecha =Par_Fecha
                  and Mov.TipoOperacion = Par_TipoOpe
                  and Mov.Instrumento = Cue.CuentaAhoID
                  and Cue.ClienteID = Cli.ClienteID
                  and Mov.Transaccion not in
                        (select TransaccionID from REVERSASOPER
                            where CajaID  = Par_CajaID
                                and SucursalID = Par_SucursalID)
                order by Transaccion desc
            limit 0, 15;
        when Ope_CargoCta then
            SELECT Mov.Transaccion,	format(Mov.MontoEnFirme,2) as MontoEnFirme,
                   Mov.Referencia as Instrumento,
                   Cli.NombreCompleto as Cliente
                from CAJASMOVS Mov,
                     CLIENTES Cli,
                     CUENTASAHO Cue
                where Mov.SucursalID = Par_SucursalID
                  and Mov.CajaID = Par_CajaID
                  and Mov.Fecha =Par_Fecha
                  and Mov.TipoOperacion = Par_TipoOpe
                  and Mov.Instrumento = Cue.CuentaAhoID
                  and Cue.ClienteID = Cli.ClienteID
                  and Mov.Transaccion not in
                        (select TransaccionID from REVERSASOPER
                            where CajaID  = Par_CajaID
                                and SucursalID = Par_SucursalID)
                order by Transaccion desc
            limit 0, 15;

        when Ope_DepGarLiq then
            SELECT Mov.Transaccion,	format(Mov.MontoEnFirme,2) as MontoEnFirme,
                   Mov.Referencia as Instrumento,
                   Cli.NombreCompleto as Cliente
                from CAJASMOVS Mov,
                     CLIENTES Cli,
                     CUENTASAHO Cue,
					 CREDITOS Cre
                where Mov.SucursalID = Par_SucursalID
                  and Mov.CajaID = Par_CajaID
                  and Mov.Fecha =Par_Fecha
                  and Mov.TipoOperacion = Par_TipoOpe
                  and Mov.Instrumento = Cue.CuentaAhoID
                  and Cue.ClienteID = Cli.ClienteID
                  and Mov.Transaccion not in
                        (select TransaccionID from REVERSASOPER
                            where CajaID  = Par_CajaID
                                and SucursalID = Par_SucursalID)
				and Cre.CuentaID= Cue.CuentaAhoID
				and Cre.CreditoID= Mov.Referencia
				and Cre.Estatus=EstatusCredInactivo
                order by Transaccion desc
            limit 0, 15;

        when Ope_ComApeCre then
            SELECT Mov.Transaccion,	format(Mov.MontoEnFirme,2) as MontoEnFirme,
                   Mov.Referencia as Instrumento,
                   Cli.NombreCompleto as Cliente
                from CAJASMOVS Mov,
                     CLIENTES Cli,
                     CUENTASAHO Cue,
					 CREDITOS Cre
                where Mov.SucursalID = Par_SucursalID
                  and Mov.CajaID = Par_CajaID
                  and Mov.Fecha =Par_Fecha
                  and Mov.TipoOperacion = Par_TipoOpe
                  and Mov.Instrumento = Cue.CuentaAhoID
                  and Cue.ClienteID = Cli.ClienteID
                  and Mov.Transaccion not in
                        (select TransaccionID from REVERSASOPER
                            where CajaID  = Par_CajaID
                                and SucursalID = Par_SucursalID)
				and Cre.CuentaID= Cue.CuentaAhoID
				and Cre.CreditoID= Mov.Referencia
				and Cre.Estatus=EstatusCredInactivo
                order by Transaccion desc
            limit 0, 15;

        when Ope_DesemCred then
            SELECT Mov.Transaccion,	format(Mov.MontoEnFirme,2) as MontoEnFirme,
                   Mov.Referencia as Instrumento,
                   Cli.NombreCompleto as Cliente
                from CAJASMOVS Mov,
                     CLIENTES Cli,
                     CUENTASAHO Cue
                where Mov.SucursalID = Par_SucursalID
                  and Mov.CajaID = Par_CajaID
                  and Mov.Fecha =Par_Fecha
                  and Mov.TipoOperacion = Par_TipoOpe
                  and Mov.Instrumento = Cue.CuentaAhoID
                  and Cue.ClienteID = Cli.ClienteID
                  and Mov.Transaccion not in
                        (select TransaccionID from REVERSASOPER
                            where CajaID  = Par_CajaID
                                and SucursalID = Par_SucursalID)
                order by Transaccion desc
            limit 0, 15;

        when Ope_CobSegVida then
            SELECT Mov.Transaccion,	format(Mov.MontoEnFirme,2) as MontoEnFirme,
                   Mov.Referencia as Instrumento,
                   Cli.NombreCompleto as Cliente
                from CAJASMOVS Mov,
                     CLIENTES Cli,
                     SEGUROVIDA Seg,
					CREDITOS Cre
                where Mov.SucursalID = Par_SucursalID
                  and Mov.CajaID = Par_CajaID
                  and Mov.Fecha =Par_Fecha
                  and Mov.TipoOperacion = Par_TipoOpe
                  and Mov.Instrumento = Seg.SeguroVidaID
                  and Seg.ClienteID = Cli.ClienteID
                  and Mov.Transaccion not in
                        (select TransaccionID from REVERSASOPER
                            where CajaID  = Par_CajaID
                                and SucursalID = Par_SucursalID)
				and Cre.CreditoID= Mov.Referencia
				and Cre.Estatus=EstatusCredInactivo
                order by Transaccion desc
            limit 0, 15;

        when Ope_AplSegVida then
            SELECT Mov.Transaccion,	format(Mov.MontoEnFirme,2) as MontoEnFirme,
                   Mov.Referencia as Instrumento,
                   Cli.NombreCompleto as Cliente
                from CAJASMOVS Mov,
                     CLIENTES Cli,
                     SEGUROVIDA Seg
                where Mov.SucursalID = Par_SucursalID
                  and Mov.CajaID = Par_CajaID
                  and Mov.Fecha =Par_Fecha
                  and Mov.TipoOperacion = Par_TipoOpe
                  and Mov.Instrumento = Seg.SeguroVidaID
                  and Seg.ClienteID = Cli.ClienteID
                  and Mov.Transaccion not in
                        (select TransaccionID from REVERSASOPER
                            where CajaID  = Par_CajaID
                                and SucursalID = Par_SucursalID)
                order by Transaccion desc
            limit 0, 15;


    end case;
end if;




END TerminaStore$$