-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMSRESERVCASTIGMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMSRESERVCASTIGMOD`;DELIMITER $$

CREATE PROCEDURE `PARAMSRESERVCASTIGMOD`(
   Par_EmpresaID                int,
   Par_RegContaEPRC             char(1),
   Par_EPRCIntMorato            char(1),
   Par_DivideEPRCCapitaInteres  char(1),
   Par_CondonaIntereCarVen      char(1),
   Par_CondonaMoratoCarVen      char(1),
   Par_CondonaAccesorios        char(1),
   Par_divideCastigo			char(1),
   Par_EPRCAdicional			char(1),
   Par_IVARecuperacion			char(1),

   Par_Salida                   char(1),
   inout	Par_NumErr 			    int,
   inout	Par_ErrMen  		       varchar(350),

   Aud_Usuario				        int,
	Aud_FechaActual			        DateTime,
	Aud_DireccionIP			        varchar(15),
	Aud_ProgramaID			        varchar(50),
	Aud_Sucursal			           int,
	Aud_NumTransaccion		        bigint

	)
TerminaStore: BEGIN

Declare Var_Control     varchar(200);


Declare Entero_Cero     int;
Declare SalidaSI        char(1);


Set Entero_Cero := 0;
Set SalidaSI    :='S';

ManejoErrores: BEGIN

Update PARAMSRESERVCASTIG Set

   RegContaEPRC           = Par_RegContaEPRC,
   EPRCIntMorato          = Par_EPRCIntMorato,
   DivideEPRCCapitaInteres= Par_DivideEPRCCapitaInteres,
   CondonaIntereCarVen    = Par_CondonaIntereCarVen,
   CondonaMoratoCarVen    = Par_CondonaMoratoCarVen,
   CondonaAccesorios      = Par_CondonaAccesorios,
   DivideCastigo		  = Par_divideCastigo,
   EPRCAdicional 	  	  = Par_EPRCAdicional,
   IVARecuperacion		  = Par_IVARecuperacion,


    Usuario         = Aud_Usuario,
	FechaActual     = Aud_FechaActual,
	DireccionIP     = Aud_DireccionIP,
	ProgramaID      = Aud_ProgramaID,
	Sucursal        = Aud_Sucursal,
	NumTransaccion  = Aud_NumTransaccion

   where EmpresaID        = Par_EmpresaID;

   set Par_NumErr  := 000;
   set Par_ErrMen  := concat("Parámetros Modificados Exitosamente:", convert(Par_EmpresaID, char));
   set Var_Control := 'empresaID';
	set Entero_Cero := Par_EmpresaID;
END ManejoErrores;

if (Par_Salida = SalidaSI) then
    select  Par_NumErr as NumErr,
            Par_ErrMen as ErrMen,
            Var_Control as control,
            Entero_Cero as consecutivo;
end if;

END TerminaStore$$