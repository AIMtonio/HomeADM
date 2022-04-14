-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TRANSEFECTIVOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TRANSEFECTIVOPRO`;
DELIMITER $$

CREATE PROCEDURE `TRANSEFECTIVOPRO`(
	Par_InstitucionID		int(11)	,
	Par_NumCtaInstit		varchar(20),
	Par_Cantidad			varchar(20),
	Par_SucursalID			int(11),
	Par_CajaID				int(11),
	Par_TipoTransaccion		int(11),
	Par_Referencia			varchar(50),
	Par_CentroCostos		int(11),
	Par_PolizaID			int(11),
	Par_Salida 				char(1),
	inout	Par_NumErr		int(11),
	inout	Par_ErrMen		varchar(400),

	Aud_EmpresaID        	int(11),
	Aud_Usuario          	int(11),
	Aud_FechaActual      	datetime,
	Aud_DireccionIP      	varchar(20),
	Aud_ProgramaID       	varchar(50),
	Aud_Sucursal         	int(11),
	Aud_NumTransaccion   	bigint(20)

	)
TerminaStore: BEGIN


DECLARE Entero_Cero 			int;
DECLARE Cadena_Vacia			char(1);
DECLARE Fecha_Vacia             date;
DECLARE Salida_SI		  		char(1);
DECLARE Salida_NO		  		char(1);
DECLARE Par_NatMovimiento		char(1);
DECLARE Par_DescripcionMov		varchar(100);
DECLARE Var_Automatico  		char(1);
DECLARE Var_EnteroUno          	int;
DECLARE EmitePoliza            	char(1);
DECLARE Var_MsgError           	varchar(400);
DECLARE Var_TipoMovID			int;
DECLARE Var_AltaMovAho			char(1);
DECLARE CtaAhoID				bigint(12);
DECLARE Fecha_Sistema			date;
DECLARE Fecha_Valida           	date;
DECLARE DiaHabil               	char(1);
DECLARE Var_ConceptoCon			int;
DECLARE Par_NatConta			char(1);
DECLARE Var_Poliza				bigint;
DECLARE Par_Consecutivo			bigint;
DECLARE Var_Refere				varchar(150);
DECLARE Pol_Automatica char(1);
DECLARE Recepcion		int(11);
DECLARE Var_SucursalCC			int(11);

Set Entero_Cero   		:= 0;
Set Fecha_Vacia			:= '1900-01-01';
Set Salida_SI      		:= 'S';
Set Salida_NO      		:= 'N';
Set Recepcion			:=2;

Set Cadena_Vacia 		:= '';
Set	Pol_Automatica 		:= 'A';
set Var_SucursalCC		:= 0;

if(ifnull(Par_InstitucionID, Entero_Cero)) = Entero_Cero then
    if (Par_Salida = Salida_SI) then
		select 1 as NumErr,
        'La Institucion Esta Vacia.' as ErrMen,
        'institucionID' as control;
    else
        Set Par_NumErr      := 1;
        Set Par_ErrMen      := 'La Institucion Esta Vacia.';

    end if;
    LEAVE TerminaStore;
end if;

if(ifnull(Par_NumCtaInstit, Cadena_Vacia)) = Cadena_Vacia then
    if (Par_Salida = Salida_SI) then
		select 2 as NumErr,
        'El Numero de Cuenta Bancaria Esta Vacio.' as ErrMen,
        'numCtaInstit' as control;
    else
        Set Par_NumErr      := 2;
        Set Par_ErrMen      := 'El Numero de Cuenta Bancaria Esta Vacio.' ;
    end if;
    LEAVE TerminaStore;
end if;

if(ifnull(Par_Cantidad, Entero_Cero)) = Entero_Cero then
    if (Par_Salida = Salida_SI) then
		select 3 as NumErr,
        'La Cantidad Esta Vacia.' as ErrMen,
        'cantidad' as control;
    else
        Set Par_NumErr      := 3;
        Set Par_ErrMen      := 'La Cantidad Esta Vacia.';
    end if;
    LEAVE TerminaStore;
end if;

	if(Par_TipoTransaccion = Recepcion)then
		if(ifnull(Par_CentroCostos,Entero_Cero)) = Entero_Cero then
			if(Par_Salida = Salida_SI) then
				select 4 as NumErr,
				'El Centro de Costos Esta Vacio.' as ErrMen,
				'cCostos' as control;
			else
				Set Par_NumErr	:= 4;
				Set Par_ErrMen	:='El Centro de Costos esta Vacio.';
			end if;
			LEAVE TerminaStore;
		End if;
	end if;

	Set Var_Automatico 		:= 'P';
	Set Var_EnteroUno 		:= 1;
	Set EmitePoliza			:= 'S';
	Set Var_MsgError       	:= 'MsgError';
	Set Var_AltaMovAho 		:= 'N';

	if (Par_TipoTransaccion = 1)then
		Set Var_ConceptoCon	:= 80;
		Set Var_TipoMovID	:= 13;
		Set Par_NatMovimiento	:= 'A';
		Set Par_NatConta		:= 'C';
		Set Par_DescripcionMov	:= 'ENVIO DE EFECTIVO A BANCOS';
	else
		Set Var_ConceptoCon	:= 81;
		Set Var_TipoMovID	:= 14;
		Set Par_NatMovimiento	:= 'C';
		Set Par_NatConta		:= 'A';
		Set Par_DescripcionMov	:= 'RECEPCION DE EFECTIVO DE BANCO';
	end if;

	Set Var_Refere := concat(Par_Referencia, '; TRAN: ', convert(Aud_NumTransaccion,char),', SUC:',
								convert(Par_SucursalID,char) , ', CAJA: ', convert(Par_CajaID,char));

Set CtaAhoID := (select CuentaAhoID  from CUENTASAHOTESO where NumCtaInstit = Par_NumCtaInstit AND InstitucionID = Par_InstitucionID);

	select FechaSistema  into Fecha_Sistema  from PARAMETROSSIS;

	call DIASFESTIVOSCAL(Fecha_Sistema, Entero_Cero,        Fecha_Valida,       DiaHabil,       Aud_EmpresaID,
                        Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
                        Aud_NumTransaccion);


	call TESORERIAMOVSALT(
	CtaAhoID,           Fecha_Sistema,  		Par_Cantidad,       Par_DescripcionMov, Var_Refere,
	Cadena_Vacia,     	Par_NatMovimiento,      Var_Automatico,     Var_TipoMovID,       Entero_Cero,
	Salida_NO,         Par_NumErr,             Par_ErrMen,         Par_Consecutivo,    Aud_EmpresaID,
	Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
	Aud_NumTransaccion);

	set Var_Poliza:=Par_PolizaID;

	/* Se realiza este procedimiento ya que se tiene que enviar la Sucursal como Parametro al SP CONTATESORERIAPRO de la variable
		Par_CentroCostos en caso de que no este ligado a una Sucursal se asigna Par_CentroCostos y en el proceso de Generacion
		de movimientos Contables valida la Funcion FNCENTROCOSTOS si el Parametro es Sucursal o Centro de Costos*/
	IF (Par_CentroCostos = Entero_Cero) THEN
		SET Var_SucursalCC := Aud_Sucursal;
	END IF;

	IF (Par_CentroCostos != Entero_Cero) THEN
		SELECT SucursalID
		INTO Var_SucursalCC
			FROM SUCURSALES
			WHERE CentroCostoID = Par_CentroCostos;

		SET Var_SucursalCC := IFNULL(Var_SucursalCC, Entero_Cero);

		IF(Var_SucursalCC = Entero_Cero) THEN
			SET Var_SucursalCC = Par_CentroCostos;
		END IF;
	END IF;

	call CONTATESORERIAPRO (Var_SucursalCC,        Var_EnteroUno,      Par_InstitucionID,   Par_NumCtaInstit,   Entero_Cero,
							Entero_Cero,        Entero_Cero,   		Fecha_Sistema,       Fecha_Valida,       Par_Cantidad,
							Par_DescripcionMov, convert(Par_CajaID,char), 		Par_NumCtaInstit, 	 'N',   			 Var_Poliza,
							Var_ConceptoCon,    Entero_Cero,    	Par_NatConta,        Var_AltaMovAho,     Entero_Cero,
							Entero_Cero,      	Cadena_Vacia,   	Cadena_Vacia,        Entero_Cero,        Var_MsgError, 		Entero_Cero,
							Aud_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,     Aud_ProgramaID,
							Aud_Sucursal,       Aud_NumTransaccion);

	call SALDOSCTATESOACT(	Par_NumCtaInstit,		Par_InstitucionID, 	Par_Cantidad,		Par_NatMovimiento,		Salida_NO,
							Par_NumErr,       		Par_ErrMen,     		Par_Consecutivo, 	Aud_EmpresaID,	Aud_Usuario,
							Aud_FechaActual,			Aud_DireccionIP,   	Aud_ProgramaID, 	Aud_Sucursal,     Aud_NumTransaccion);

if (Par_Salida = Salida_SI) then
    select 0 as NumErr,
		concat("La Transferencia ha sido realizada")  as ErrMen,
        'institucionID' as control,
        Var_Poliza as consecutivo;
else
    Set Par_NumErr      := 0;
    Set Par_ErrMen      := concat("La Transferencia ha sido realizada");
	Set Par_Consecutivo := Var_Poliza;
end if;

END TerminaStore$$