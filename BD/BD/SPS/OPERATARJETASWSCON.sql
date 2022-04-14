-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- OPERATARJETASWSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `OPERATARJETASWSCON`;DELIMITER $$

CREATE PROCEDURE `OPERATARJETASWSCON`(

	Par_TarDebID			char(16),
	Par_NIP				varchar(256),

	Par_NumCon			tinyint unsigned,

	Par_EmpresaID			int(11),
	Aud_Usuario			int(11),
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int(11),
	Aud_NumTransaccion	bigint(20)

	)
TerminaStore:BEGIN


DECLARE	Cadena_Vacia	char(1);
DECLARE	Entero_Cero	int;
DECLARE	DecimalCero	decimal(12,2);
declare Salida_NO 		char(1);
declare	Var_Si	 	char(1);
DECLARE	EstatusActivo	char(1);
DECLARE	Con_SaldoDis	int(11);
DECLARE	EstatusAsigna	int(11);


DECLARE	Var_SaldoDisp		decimal(12,2);
DECLARE	Var_CuentaAhoID	bigint(12);
DECLARE	Var_EstatusTar		int(11);
DECLARE	Var_NIP			varchar(256);
DECLARE	Var_FechaVencim	char(5);
DECLARE	Var_Anio 			char(5);
DECLARE	Var_Mes			char(5);
DECLARE	Var_AnioTar		char(5);
DECLARE	Var_MesTar		char(5);
DECLARE	EstatusExpira		int(11);


Set	Cadena_Vacia			:= '';
Set	Entero_Cero			:= 0;
Set	DecimalCero			:= 0.00;
Set	Salida_NO				:= 'N';
Set	Var_Si				:= 'S';
Set	Con_SaldoDis			:= 3;
Set	EstatusAsigna			:= 6;
Set	EstatusExpira		:= 10;

select Estatus, NIP ,CuentaAhoID, FechaVencimiento into Var_EstatusTar , Var_NIP, Var_CuentaAhoID,Var_FechaVencim
	from TARJETADEBITO
	where TarjetaDebID =  Par_TarDebID;


if(ifnull(Var_EstatusTar, Entero_Cero) <> EstatusAsigna ) then
	if(ifnull(Var_EstatusTar, Entero_Cero) = EstatusExpira ) then
		select '33' as CodigoRespuesta,
				'Tarjeta Expirada.' as MensajeRespuesta,
				Entero_Cero  as SaldoActualizado,
				Entero_Cero  as NumeroTransaccion;
	else
		select '14' as CodigoRespuesta,
				'Numero de Tarjeta Invalido.' as MensajeRespuesta,
				Entero_Cero  as SaldoActualizado,
				Entero_Cero  as NumeroTransaccion;
	end if;
	LEAVE TerminaStore;
end if;


set Var_NIP := ifnull(Var_NIP,Cadena_Vacia);
if(ifnull(Par_NIP, Cadena_Vacia) <> Var_NIP) then
	select '55' as CodigoRespuesta,
			'Numero de Identificacion incorrecto' as MensajeRespuesta,
			Entero_Cero  as SaldoActualizado,
			Entero_Cero  as NumeroTransaccion;
	LEAVE TerminaStore;
end if;

set Var_MesTar	:= SUBSTRING(Var_FechaVencim, 1,2);
set Var_AnioTar	:= SUBSTRING(Var_FechaVencim, 4,2);
select SUBSTRING(FechaSistema, 6,2), SUBSTRING(FechaSistema, 3,2)
	into Var_Mes, Var_Anio
	from PARAMETROSSIS;


if( cast(Var_AnioTar as signed ) < cast(Var_Anio as signed ) ) then
	select '33' as CodigoRespuesta,
			'Tarjeta Expirada.' as MensajeRespuesta,
			Entero_Cero  as SaldoActualizado,
			Entero_Cero  as NumeroTransaccion;
	LEAVE TerminaStore;
else
	if( cast(Var_MesTar as signed ) < cast(Var_Mes as signed ) ) then
		select '33' as CodigoRespuesta,
			'Tarjeta Expirada.' as MensajeRespuesta,
			Entero_Cero  as SaldoActualizado,
			Entero_Cero  as NumeroTransaccion;
		LEAVE TerminaStore;
	end if;
end if;


if(Par_NumCon = Con_SaldoDis) then
	select '00' as CodigoRespuesta,
			'Consulta Realizada.' as MensajeRespuesta,
			ifnull(SaldoDispon,Entero_Cero) as SaldoActualizado,
			Entero_Cero  as NumeroTransaccion
		from CUENTASAHO
		where CuentaAhoID = Var_CuentaAhoID;
end if;

END TerminaStore$$