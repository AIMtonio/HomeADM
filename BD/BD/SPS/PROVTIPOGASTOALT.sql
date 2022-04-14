-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROVTIPOGASTOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PROVTIPOGASTOALT`;DELIMITER $$

CREATE PROCEDURE `PROVTIPOGASTOALT`(

Par_ProveedorID	int(11),
Par_TipoGastoID	int(11),
Par_SucursalID	int(11),

Par_Salida 				char(1),
	inout	Par_NumErr	 	int,
	inout	Par_ErrMen	 	varchar(100),
	inout	Var_FolioSalida	int,


Aud_Empresa	int(11),
Aud_Usuario	int(11),
Aud_FechaActual	datetime,
Aud_DireccionIP	varchar(50),
Aud_ProgramaID varchar(70),
Aud_Sucursal	int(11),
Aud_NumTransaccion	varchar(45)
	)
TerminaStore : BEGIN

DECLARE Entero_Cero int;
DECLARE Salida_SI char(1);
DECLARE Var_ProvID int(11);

Set Entero_Cero :=0;
Set Salida_SI:='S';
Set Var_ProvID :=0;

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

	if(ifnull(Par_ProveedorID, Entero_Cero)) = Entero_Cero then
		if (Par_Salida = Salida_SI) then
		     select '001' as NumErr,
			 'El proveedor esta vacio.' as ErrMen,
			 'ProveedorID' as control,
			 0 as consecutivo;
		else
			set	Par_NumErr := 1;
			set	Par_ErrMen := 'El proveedor esta vacio.' ;
		end if;
		LEAVE TerminaStore;
	end if;

   if(ifnull(Par_TipoGastoID, Entero_Cero)) = Entero_Cero then
		if ( Par_Salida = Salida_SI) then
		     select '001' as NumErr,
			 'El tipo de gasto esta vacio.' as ErrMen,
			 'ipoGastoID' as control,
			 0 as consecutivo;
		else
			set	Par_NumErr := 1;
			set	Par_ErrMen := 'Eltipo de gasto esta Vacio.' ;
		end if;
		LEAVE TerminaStore;
	end if;


if(exists(select ProveedorID  from PROVTIPOGASTO where TipoGastoID=Par_TipoGastoID
          and SucursalID=Par_SucursalID))then
  Set Var_ProvID :=( select ProveedorID  from PROVTIPOGASTO where TipoGastoID=Par_TipoGastoID
          and SucursalID=Par_SucursalID);

if ( Par_Salida = Salida_SI) then
		     select '004' as NumErr,
			 concat('El gasto ya se encuentra asignado para el proveedor:', convert(Var_ProvID, CHAR)) as ErrMen,
			 'TipoGastoID' as control,
			 Var_ProvID as consecutivo;
		else
			set	Par_NumErr := 4;
			set	Par_ErrMen :=   concat('El gasto ya se encuentra asignado para el proveedor:', convert(Var_ProvID, CHAR)) ;
		end if;
		LEAVE TerminaStore;
end if;


insert into PROVTIPOGASTO
	(
	ProveedorID,TipoGastoID	, SucursalID,
	Empresa	, Usuario,FechaActual,
	DireccionIP	, ProgramaID, Sucursal	, NumTransaccion )

	values (Par_ProveedorID,Par_TipoGastoID	, Par_SucursalID	,
			Aud_Empresa	,Aud_Usuario	,Aud_FechaActual	,
			Aud_DireccionIP	,Aud_ProgramaID, Aud_Sucursal	, Aud_NumTransaccion	);

   Set	Par_NumErr := 0;
   Set	Par_ErrMen := "Se ha enlazado el tipo de gasto con el proveedor";
   Set Var_FolioSalida	:=Par_ProveedorID;


END;

if(Par_Salida = Salida_SI)then
select '000' as NumErr,
	  "Se ha enlazado el tipo de gasto con el proveedor"  as ErrMen,
	  'ProveedorID' as control,
		Par_ProveedorID as consecutivo;
end if;

END TerminaStore$$