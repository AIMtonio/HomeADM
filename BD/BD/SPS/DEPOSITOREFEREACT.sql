-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DEPOSITOREFEREACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `DEPOSITOREFEREACT`;DELIMITER $$

CREATE PROCEDURE `DEPOSITOREFEREACT`(

     Par_FolioCargaID    bigint(17),
     Par_CuentaAhoID     bigint(12),
     Par_InstitucionID   int(11),
     Par_Status          char(2),
     Par_ReferenciaNoIden varchar(35),
     Par_DescripcionNoIden varchar(150),
     Par_TipoCanal       int(11),

     Aud_EmpresaID        int,
	Aud_Usuario          int,
	Aud_FechaActual      Datetime,
	Aud_DireccionIP      varchar(20),
	Aud_ProgramaID       varchar(50),
	Aud_Sucursal         int,
	Aud_NumTransaccion   bigint(20)
			)
TerminaStore: BEGIN
DECLARE ctaAhoID bigint(12);
DECLARE Cad_Vacia varchar(1);
DECLARE Var_Cancelado varchar(1);

set Cad_Vacia := '';
set Var_Cancelado := 'C';

if (Par_Status = Var_Cancelado) then

	if(ifnull(Par_ReferenciaNoIden, Cad_Vacia))= Cad_Vacia then
		select '001' as NumErr,
			'La Referencia por confirmar esta vacia.' as ErrMen,
			'ReferenciaNoIden' as control;
		LEAVE TerminaStore;

	end if;

	if(ifnull(Par_DescripcionNoIden, Cad_Vacia))= Cad_Vacia then
		select '001' as NumErr,
			'La Descripcion  esta vacia.' as ErrMen,
			'DescripcionNoIden' as control;
		LEAVE TerminaStore;

	end if;

end if;

Set ctaAhoID:= (SELECT NumCtaInstit from CUENTASAHOTESO WHERE CuentaAhoID = Par_CuentaAhoID and InstitucionID = Par_InstitucionID LIMIT 1);

  update DEPOSITOREFERE set

  Status        = Par_Status,
  TipoCanal     = Par_TipoCanal,
  ReferenciaNoIden = Par_ReferenciaNoIden,
  DescripcionNoIden  = Par_DescripcionNoIden,

  EmpresaID     = Aud_EmpresaID,
  Usuario       = Aud_Usuario,
  FechaActual   = Aud_FechaActual,
  DireccionIP   = Aud_DireccionIP,
  ProgramaID    = Aud_ProgramaID,
  Sucursal      = Aud_Sucursal,
  NumTransaccion= Aud_NumTransaccion

where FolioCargaID  = Par_FolioCargaID  and
      CuentaAhoID   = ctaAhoID   and
      InstitucionID = Par_InstitucionID;

select '000' as NumErr,
	  concat("", convert(Par_CuentaAhoID, CHAR))  as ErrMen,
	  'cuentaAhoID' as control;


END TerminaStore$$