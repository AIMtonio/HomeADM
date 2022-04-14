-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROVTIPOGASTOBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `PROVTIPOGASTOBAJ`;DELIMITER $$

CREATE PROCEDURE `PROVTIPOGASTOBAJ`(

Par_ProveedorID	int(11),
Par_TipoGastoID	int(11),
Par_SucursalID	int(11),
Par_TipoBaja int,

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
DECLARE Baja_conGasto int;
DECLARE Baja_DeProbeedor int;

Set Entero_Cero :=0;
Set Salida_SI:='S';
Set Baja_conGasto:=1;
Set Baja_DeProbeedor:=2;

BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            set Par_NumErr = 999;
            set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
                                     "estamos trabajando para resolverla. Disculpe las molestias que ",
                                     "esto le ocasiona. Ref: SP-BITACORACOBAUTALT");
        END;



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

	if(Baja_conGasto = Par_TipoBaja) then
		delete from PROVTIPOGASTO where ProveedorID=Par_ProveedorID
      and TipoGastoID=Par_TipoGastoID and SucursalID=Par_SucursalID;
	end if;

	if(Baja_DeProbeedor = Par_TipoBaja) then
		delete from PROVTIPOGASTO where ProveedorID=Par_ProveedorID;
	end if;

   Set	Par_NumErr := 0;
   Set	Par_ErrMen := "Se ha Desenlazado el tipo de gasto con el proveedor";
   Set Var_FolioSalida	:=Par_ProveedorID;


END;

if(Par_Salida = Salida_SI)then
select '000' as NumErr,
	  "Se ha Desenlazado el tipo de gasto con el proveedor"  as ErrMen,
	  'ProveedorID' as control,
		Par_ProveedorID as consecutivo;
end if;

END TerminaStore$$