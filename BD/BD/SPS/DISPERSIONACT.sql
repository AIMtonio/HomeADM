-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DISPERSIONACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `DISPERSIONACT`;
DELIMITER $$


CREATE PROCEDURE `DISPERSIONACT`(
	Par_FolioOperacion   	int(11),
	Par_FechaOperacion		DateTime,
	Par_Institucion			int(11),
	Par_CuentaAhoID			bigint(12),
	Par_NumCtaInstit 		varchar(20),
	Par_NumAct				int,

    Par_Salida 				char(1),
    inout	Par_NumErr	 	int,
    inout	Par_ErrMen	 	varchar(400),
    inout Var_FolioSalida	int,

	Aud_EmpresaID        	int(11),
	Aud_Usuario          	int(11),
	Aud_FechaActual      	datetime,
	Aud_DireccionIP      	varchar(20),
	Aud_ProgramaID       	varchar(50),
	Aud_Sucursal         	int(11),
	Aud_NumTransaccion  	 bigint(20)
			)

TerminaStore: BEGIN

DECLARE Var_Enviados 		char(1);
DECLARE	Cadena_Vacia			char(1);
DECLARE Entero_Cero  int;


DECLARE Var_Total			int;
DECLARE Var_TotalEnviado	int;
DECLARE Var_Monto			decimal(12,2);
DECLARE Var_MontoEnviado	decimal(12,2);
DECLARE Var_Estatus		char(2);
DECLARE Var_ActCuentas		int;
DECLARE Var_ActCierre		int;
DECLARE SalidaSi			char(1);
DECLARE SalidaNo			char(1);


Set Var_Enviados 		:= 'A';
Set	Cadena_Vacia		:= '';
Set Var_ActCuentas		:= 1;
Set Var_ActCierre		:= 3;
Set SalidaSi			:= 'S';
Set SalidaNo			:= 'N';
Set Entero_Cero := 0;
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            set Par_NumErr = 999;
            set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
                                     "estamos trabajando para resolverla. Disculpe las molestias que ",
                                     "esto le ocasiona. Ref: SP-DISPERSIONACT");
        END;
if(Par_NumAct = Var_ActCuentas) then


	if(ifnull(Par_Institucion, Entero_Cero))= Entero_Cero then

         if(Par_Salida = SalidaSi)then
            select '003' as NumErr,
                 'El numero de institucion esta vacio.' as ErrMen,
                 'institucionID' as control,
				 0 as consecutivo;
            LEAVE TerminaStore;
        end if;

        if(Par_Salida = SalidaNo)then
            set Par_NumErr := 2;
            set Par_ErrMen := 'El numero de institucion esta vacio.';
        end if;

	end if;


	if(ifnull(Par_NumCtaInstit,Cadena_Vacia)) = Cadena_Vacia then
		if(Par_Salida = SalidaSi)then
			select '002' as NumErr,
				concat("La Cuenta Bancaria esta vacia: ",
				convert(Var_CtaInstitu, CHAR))  as ErrMen,
			    'numCtaInstit' as control,
			    0 as consecutivo;

		else
			set Par_NumErr := 2;
			set Par_ErrMen := 'La Cuenta Bancaria especificada no Existe.';
		end if;
		LEAVE TerminaStore;
	end if;


	Set Par_CuentaAhoID:= ifnull((select CuentaAhoID
							from CUENTASAHOTESO
							where InstitucionID= Par_Institucion
							and NumCtaInstit= Par_NumCtaInstit),Cadena_Vacia);

	if(ifnull(Par_CuentaAhoID, Entero_Cero))= Entero_Cero then

		if(Par_Salida = SalidaSi)then
            select '001' as NumErr,
                 'El numero de Cuenta esta vacio.' as ErrMen,
                 'cuentaAhoID' as control,
				Entero_Cero as consecutivo;
            LEAVE TerminaStore;
		end if;

		if(Par_Salida = SalidaNo)then
			set Par_NumErr := 1;
			set Par_ErrMen := 'El numero de Cuenta esta vacio.';
			LEAVE TerminaStore;
		end if;

	end if;







UPDATE DISPERSION SET

	FechaOperacion 		= Par_FechaOperacion,
	InstitucionID 		= Par_Institucion,
	CuentaAhoID			= Par_CuentaAhoID,
	NumCtaInstit		= Par_NumCtaInstit,

	EmpresaID			= Aud_EmpresaID,
	Usuario 			= Aud_Usuario,
	FechaActual 		= Aud_FechaActual,
	DireccionIP 		= Aud_DireccionIP,
	ProgramaID 			= Aud_ProgramaID,
	Sucursal 			= Aud_Sucursal,
	NumTransaccion		= Aud_NumTransaccion

where FolioOperacion = Par_FolioOperacion;

	set Par_NumErr := 0;
	set Par_ErrMen := concat("Dispersion Autorizada: ", convert(Par_FolioOperacion, CHAR));
	set Var_FolioSalida := Par_FolioOperacion;

end if;


if(Par_NumAct = Var_ActCierre) then

	select
		count(ClaveDispMov)as canTotal,
		(select count(ClaveDispMov) from DISPERSIONMOV where Estatus = Var_Enviados and mov.DispersionID = DispersionID)as cantEnviados,
		sum(Monto)as montoTotal,
		(select sum(Monto) from DISPERSIONMOV where Estatus = Var_Enviados and mov.DispersionID = DispersionID)as montoEnviados
	into Var_Total, Var_TotalEnviado, Var_Monto, Var_MontoEnviado

	from DISPERSIONMOV mov where DispersionID = Par_FolioOperacion;

if(Var_Total = Var_TotalEnviado)then
	set Var_Estatus := 'C';
	else
	set Var_Estatus := 'A';
end if;


UPDATE DISPERSION SET

	CantRegistros 		= Var_Total,
	CantEnviados 		= Var_TotalEnviado,
	MontoTotal 			= Var_Monto,
	MontoEnviado 		= Var_MontoEnviado,
	Estatus 			= Var_Estatus,

	EmpresaID			= Aud_EmpresaID,
	Usuario 			= Aud_Usuario,
	FechaActual 		= Aud_FechaActual,
	DireccionIP 		= Aud_DireccionIP,
	ProgramaID 			= Aud_ProgramaID,
	Sucursal 			= Aud_Sucursal,
	NumTransaccion		= Aud_NumTransaccion

where FolioOperacion = Par_FolioOperacion;

	set Par_NumErr := 0;
	set Par_ErrMen := concat("Dispersion Autorizada: ", convert(Par_FolioOperacion, CHAR));
	set Var_FolioSalida := Par_FolioOperacion;

end IF;

END;

if(Par_Salida = SalidaSi)then

	select '000' as NumErr,
		case when Par_NumAct = Var_ActCuentas then
						concat("Dispersion Auctualizada: ", convert(Par_FolioOperacion, CHAR))
			  when Par_NumAct = Var_ActCierre then
						concat("Dispersion Autorizada: ", convert(Par_FolioOperacion, CHAR))
						end
	    as ErrMen,
		'folioOperacion' as control,
		Par_FolioOperacion as consecutivo;
end if;

END TerminaStore$$