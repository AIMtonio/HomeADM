-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCUENTASAHOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TMPCUENTASAHOALT`;DELIMITER $$

CREATE PROCEDURE `TMPCUENTASAHOALT`(
	Par_SucursalID 	int(11),
	Par_ClienteID 	int(11),
	Par_Clabe 		varchar(18),
	Par_MonedaID 		int(11),
	Par_TipoCuentaID int(11),
	Par_FechaReg 		date,
	Par_Etiqueta 		varchar(50),
	Par_EdoCta 		char(1),

	Aud_EmpresaID		int,
	Aud_Usuario		int,
	Aud_FechaActual	DateTime,
	Aud_DireccionIP	varchar(15),
	Aud_ProgramaID	varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint,

	out NumCuentaAhoID	char(11),
	out NumErr			int,
	out ErrMen			varchar(100)
		)
TerminaStore: BEGIN


DECLARE		NumCuentaAho		char(10);
DECLARE		Estatus_Registrada	char(1);
DECLARE		Cadena_Vacia		char(1);
DECLARE		Entero_Cero			int;
DECLARE		Fecha_Vacia			date;
DECLARE		Fecha				date;
DECLARE		Verifica			int;
DECLARE		i					int;
DECLARE		j					int;
DECLARE		Modulo2				int;
DECLARE		consecutivo			int;
DECLARE 	NumVerificador		CHAR(1);

Set	NumCuentaAho		:= '';
Set	NumCuentaAhoID		:= 0;
Set	Estatus_Registrada	:= 'R';
Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia			:= '1900-01-01';
Set	Fecha				:= '1900-01-01';
Set	Entero_Cero			:= 0;
Set	Verifica			:= 0;
Set	i					:= 1;
Set	j					:= 5;
Set	consecutivo			:= 0;
Set	Modulo2				:= 1;

if(ifnull(Par_SucursalID, Entero_Cero))= Entero_Cero then
	Set NumErr:= 1;
	Set ErrMen := 'El numero de Sucursal esta Vacio.';
	LEAVE TerminaStore;

end if;

if(ifnull(Par_ClienteID, Entero_Cero))= Entero_Cero then
	Set NumErr:= 2;
	Set ErrMen := 'El numero de Cliente esta Vacio.';
	LEAVE TerminaStore;
end if;

if(ifnull(Par_MonedaID, Entero_Cero))= Entero_Cero then
	Set NumErr:= 3;
	Set ErrMen := 'La Moneda esta Vacia.';
	LEAVE TerminaStore;
end if;

if(ifnull(Par_TipoCuentaID, Entero_Cero))= Entero_Cero then
	Set NumErr:= 4;
	Set ErrMen := 'El Tipo de Cuenta esta Vacio.';
	LEAVE TerminaStore;
end if;

if(Par_FechaReg=Fecha_Vacia)then
		set Par_FechaReg := Fecha;
end if;

if(ifnull(Par_FechaReg,Fecha_Vacia)) = Fecha_Vacia then
	Set NumErr:= 5;
	Set ErrMen := 'El numero de Cliente esta Vacio.';
	LEAVE TerminaStore;
end if;

if(ifnull(Par_Etiqueta,Cadena_Vacia)) = Cadena_Vacia then
	Set NumErr:= 6;
	Set ErrMen := 'La Etiqueta esta Vacia.';
	LEAVE TerminaStore;
end if;

call FOLIOSSUCAPLICACT(
    'CUENTASAHO', Par_SucursalID, consecutivo);

set NumCuentaAho := CONCAT((SELECT LPAD(Par_SucursalID,3,0)),(SELECT LPAD(consecutivo,7,0)));

WHILE i <= 10 DO
	set Verifica :=  Verifica +  (convert((substring(NumCuentaAho,i,1)),UNSIGNED INT) * j);
	set j := j - 1;
      set i := i + 1;
	IF (j = 1) then
		set j := 7;
	END IF;
END WHILE;

set Modulo2 := Verifica % 11;

if (Modulo2 = 0)then
	set Verifica = 1;
else
	if (Modulo2 = 1) then
		set Verifica = 0;
	else
		set Verifica = 11 - Modulo2;
	END IF;
END IF;

set NumVerificador := ltrim(rtrim(convert(Verifica, char)));

set NumCuentaAhoID := CONCAT(NumCuentaAho,NumVerificador);

Set Aud_FechaActual := CURRENT_TIMESTAMP();


insert into CUENTASAHO (CuentaAhoID,	SucursalID, 		ClienteID ,
						Clabe,			MonedaID,		TipoCuentaID,
						FechaReg,		Etiqueta,		Estatus,
						SaldoDispon,	SaldoIniMes,		CargosMes,
						AbonosMes,		Comisiones,		SaldoProm,
						TasaInteres,	InteresesGen,		ISR,
						TasaISR,		SaldoIniDia,		CargosDia,
						AbonosDia,		EstadoCta,
						EmpresaID,		Usuario,			FechaActual,
						DireccionIP,	ProgramaID,		Sucursal,
						NumTransaccion
				)
	values ( NumCuentaAhoID,	Par_SucursalID, 		Par_ClienteID ,
			' ',				Par_MonedaID,		Par_TipoCuentaID,
			Par_FechaReg,		Par_Etiqueta,		Estatus_Registrada,
			0,				0,				0,
			0,				0,				0,
			0,				0,				0,
			0,				0,				0,
			0,				Par_EdoCta,
			Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion
			);

	Set NumErr	:= 0;
	Set ErrMen 	:= concat("Cuenta de Ahorro Agregada: ", convert(NumCuentaAhoID, CHAR));


END TerminaStore$$