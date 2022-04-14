-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEISOLDESREMACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEISOLDESREMACT`;DELIMITER $$

CREATE PROCEDURE `SPEISOLDESREMACT`(



  Par_SpeiSolDesID    bigint(20),
  Par_NumAct        tinyint unsigned,

  Par_Salida      char(1),
  inout Par_NumErr  int,
  inout Par_ErrMen  varchar(350),

  Par_EmpresaID   int(11),
  Aud_Usuario     int(11),
  Aud_FechaActual   datetime,
  Aud_DireccionIP   varchar(15),
  Aud_ProgramaID    varchar(50),
  Aud_Sucursal    int(11),
  Aud_NumTransaccion  bigint(20)

	)
TerminaStore: BEGIN


DECLARE Var_Control         varchar(200);

DECLARE Cadena_Vacia    char(1);
DECLARE Entero_Cero     int;
DECLARE SalidaSI      char(1);
DECLARE SalidaNO      char(1);
DECLARE Act_SoltAct         int;
DECLARE EstatusSolR     char(1);


Set Cadena_Vacia    :='';
Set Entero_Cero     :=0;
Set SalidaSI      :='S';
Set SalidaNO      :='N';
Set Par_NumErr      := 0;
Set Par_ErrMen      := '';
Set Act_SoltAct         :=1;
Set EstatusSolR     :='R';


ManejoErrores:BEGIN

  if(Par_NumAct = Act_SoltAct)then

  update SPEISOLDESREM set
       Estatus          = EstatusSolR,
             FechaProceso   = CURRENT_TIMESTAMP(),

       Usuario          = Aud_Usuario,
       FechaActual      = Aud_FechaActual,
       DireccionIP      = Aud_DireccionIP,
       ProgramaID       = Aud_ProgramaID,
       Sucursal       = Aud_Sucursal,
       NumTransaccion   = Aud_NumTransaccion
    where SpeiSolDesID      = Par_SpeiSolDesID;

      set Par_NumErr  := 000;
      set Par_ErrMen  := concat("Estatus Actualizado Exitosamente");
      set Var_Control := 'numero' ;

  end if;

END ManejoErrores;
  if (Par_Salida = SalidaSI) then
    select  Par_NumErr as NumErr,
        Par_ErrMen as ErrMen,
        Var_Control as control,
        Entero_Cero as consecutivo;
  end if;
END  TerminaStore$$