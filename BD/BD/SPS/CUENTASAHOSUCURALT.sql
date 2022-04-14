-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASAHOSUCURALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASAHOSUCURALT`;DELIMITER $$

CREATE PROCEDURE `CUENTASAHOSUCURALT`(

	Par_SucursalID       int(11),
	Par_InstitucionID    int(11),
	Par_CueClave         char(18),
	Par_EsPrincipal      char(1),
	Par_Estatus          char(1),

	Par_Salida 				char(1),
	inout	Par_NumErr	 	int,
	inout	Par_ErrMen	 	varchar(100),
	inout	Var_FolioSalida	int,

	Aud_EmpresaID        int(11),
	Aud_Usuario          int(11),
	Aud_FechaActual      datetime,
	Aud_DireccionIP      varchar(20),
	Aud_ProgramaID       varchar(70),
	Aud_Sucursal         int(11),
	Aud_NumTransaccion   bigint(20)

	)
TerminaStore : BEGIN


DECLARE Entero_Cero int;
DECLARE Salida_SI char(1);
DECLARE Par_CuentaSucurID int(11);
DECLARE Var_Principal char(1);
DECLARE Var_NoPrincipal char(1);
DECLARE Var_CtaPrincipalID int(11);


Set Entero_Cero :=0;
Set Salida_SI:='S';
Set Var_Principal :='S';
Set Var_NoPrincipal:='N';
Set Var_CtaPrincipalID:=0;

BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            set Par_NumErr = 999;
            set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
                                     "estamos trabajando para resolverla. Disculpe las molestias que ",
                                     "esto le ocasiona. Ref: SP-BITACORACOBAUTALT");
        END;


	if(ifnull(Par_SucursalID, Entero_Cero)) = Entero_Cero then
		if (Par_Salida = Salida_SI) then
		     select '001' as NumErr,
			 'La sucursal esta Vacia.' as ErrMen,
			 'SucursalID' as control,
			 0 as consecutivo;
		else
			set	Par_NumErr := 1;
			set	Par_ErrMen := 'La sucursal esta Vacia.' ;
		end if;
		LEAVE TerminaStore;
	end if;

	if(ifnull(Par_InstitucionID, Entero_Cero)) = Entero_Cero then
		if (Par_Salida = Salida_SI) then
		     select '002' as NumErr,
			 'La sucursal esta Vacia.' as ErrMen,
			 'InstitucionID' as control,
			 0 as consecutivo;
		else
			set	Par_NumErr := 2;
			set	Par_ErrMen := 'La Institucion esta Vacia.' ;
		end if;
		LEAVE TerminaStore;
	end if;

	if(ifnull(Par_CueClave, Entero_Cero)) = Entero_Cero then
		if (Par_Salida = Salida_SI) then
		     select '003' as NumErr,
			 'La cuenta clabe esta Vacia.' as ErrMen,
			 'CueClave' as control,
			 0 as consecutivo;
		else
			set	Par_NumErr := 2;
			set	Par_ErrMen := 'La cuenta clabe esta Vacia.' ;
		end if;
		LEAVE TerminaStore;
	end if;

if(Par_EsPrincipal = Var_Principal )then

	select  CuentaSucurID into Var_CtaPrincipalID FROM CUENTASAHOSUCUR WHERE InstitucionID=Par_InstitucionID
	and SucursalID=Par_SucursalID and EsPrincipal=Par_EsPrincipal;


	if((Var_CtaPrincipalID <> Entero_Cero)=1) then



		update CUENTASAHOSUCUR

			 Set EsPrincipal=Var_NoPrincipal,

   		      Usuario =   Aud_Usuario,
			  FechaActual=Aud_FechaActual,
			  DireccionIP=Aud_DireccionIP,
			  EmpresaID  =Aud_EmpresaID,
		      ProgramaID =Aud_ProgramaID,
		      Sucursal   =Aud_Sucursal,
			  NumTransaccion= Aud_NumTransaccion

        where InstitucionID=Par_InstitucionID
          	  and SucursalID=Par_SucursalID
              and CuentaSucurID = Var_CtaPrincipalID;

	end if;

end if;


 call FOLIOSAPLICAACT('CUENTASAHOSUCUR', Par_CuentaSucurID);

	Insert into CUENTASAHOSUCUR(
      CuentaSucurID,
		SucursalID, InstitucionID, CueClave,
		EsPrincipal,   Estatus,
		EmpresaID,  Usuario, FechaActual,
		DireccionIP,ProgramaID,  Sucursal,
		NumTransaccion
	)
	Values(
		Par_CuentaSucurID,
		Par_SucursalID,Par_InstitucionID, Par_CueClave,
		Par_EsPrincipal, Par_Estatus,
		Aud_EmpresaID,   Aud_Usuario,   Aud_FechaActual,
		Aud_DireccionIP, Aud_ProgramaID,  Aud_Sucursal,
		Aud_NumTransaccion

	);

   Set	Par_NumErr := 0;
   Set	Par_ErrMen := concat("Cuenta Bancaria agregada de la Sucursal : ", convert(Par_SucursalID, CHAR)) ;
   Set Var_FolioSalida	:=Par_CuentaSucurID;

END;

if(Par_Salida = Salida_SI)then
select '000' as NumErr,
	  concat("Cuenta Bancaria agregada de la Sucursal : ", convert(Par_SucursalID, CHAR))  as ErrMen,
	  'cuentaAhoID' as control,
		Par_SucursalID as consecutivo;
end if;

END TerminaStore$$