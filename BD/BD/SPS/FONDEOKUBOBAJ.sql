-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FONDEOKUBOBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `FONDEOKUBOBAJ`;



  Par_FondeoKuboID       int,

  Par_EmpresaID          int(11),
  Aud_Usuario			       int,
  Aud_FechaActual	      	DateTime,
  Aud_DireccionIP	      	varchar(15),
  Aud_ProgramaID	      	varchar(50),
  Aud_Sucursal		       int,
  Aud_NumTransaccion	    bigint
	)


delete
	from FONDEOKUBO
	where FondeoKuboID = Par_FondeoKuboID;

select '000' as NumErr ,
	  'Fondeo Eliminado' as ErrMen,
	  'FondeoKuboID' as control;

END TerminaStore$$