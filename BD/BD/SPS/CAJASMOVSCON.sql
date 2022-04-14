-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAJASMOVSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CAJASMOVSCON`;DELIMITER $$

CREATE PROCEDURE `CAJASMOVSCON`(
	Par_Transaccion		int(20),
	Par_SucursalID		int(11),
	Par_CajaID			int(11),
	Par_Fecha			date,
	Par_TipoOpe			int(11),

	Par_Instrumento		bigint,
	Par_Referencia		varchar(200),
	Par_NumCon			tinyint unsigned,
	Par_EmpresaID		int(11),
	Aud_Usuario			int(11),

	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int(11),
	Aud_NumTransaccion	bigint(20)
)
TerminaStore: BEGIN

DECLARE Var_esEfectivo 				char(1);


DECLARE Con_ReversaTransaccion		int;
DECLARE Con_OpeSalEfecRevCobroSV	int;
DECLARE Con_General					int;
DECLARE TipoOperacionCaja			int;
DECLARE Rev_PagoCredito				int;
DECLARE TipoOperCajaPrepagCred		int;
DECLARE EsEfectivoNO				char(1);
DECLARE EsEfectivoSI				char(1);


set Con_ReversaTransaccion  	:= 1;
set Rev_PagoCredito				:= 2;
set Con_General					:= 3;

set Con_OpeSalEfecRevCobroSV	:= 46;
set TipoOperacionCaja			:= 28;
set TipoOperCajaPrepagCred		:= 79;
set EsEfectivoNO				:= 'N';
set EsEfectivoSI				:= 'S';

if(Par_NumCon = Con_ReversaTransaccion) then

	set Var_esEfectivo := ifnull((select CTP.EsEfectivo
										from CAJASMOVS CMV
										inner join CAJATIPOSOPERA CTP
											on CTP.Numero=CMV.TipoOperacion
										WHERE CMV.Transaccion=Par_Transaccion
										and CTP.EsEfectivo != EsEfectivoNO limit 1) ,EsEfectivoNO);

		SELECT 	c.Transaccion,	c.Referencia,c.Instrumento, format(c.MontoEnFirme,2) as  MontoEnFirme,
				c.CajaID, Var_esEfectivo
		FROM CAJASMOVS  c
			WHERE  c.SucursalID = Par_SucursalID
				AND c.CajaID = Par_CajaID
				AND c.Fecha = Par_Fecha
				AND c.TipoOperacion = Par_TipoOpe
				AND c.Transaccion = Par_Transaccion;

end if;


if(Par_NumCon = Rev_PagoCredito) then
	set Var_esEfectivo	:=EsEfectivoSI;
	select c.Transaccion,	c.Referencia,c.Instrumento, format(c.MontoEnFirme,2) as  MontoEnFirme, CajaID,
					Var_esEfectivo
		from CAJASMOVS c
		where Transaccion		=Par_Transaccion
			and Fecha			= Par_Fecha
			and (TipoOperacion		=TipoOperacionCaja
				or c.TipoOperacion	=TipoOperCajaPrepagCred);

end if;

if(Par_NumCon = Con_General) then
	select c.Transaccion,	c.Referencia,c.Instrumento, format(c.MontoEnFirme,2) as  MontoEnFirme
		from CAJASMOVS c
		where Transaccion		=Par_Transaccion
			and Fecha			= Par_Fecha
			and TipoOperacion	=Par_TipoOpe
			and Instrumento		=Par_Instrumento;
end if;

END TerminaStore$$