-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INTEGRAGRUPOSBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `INTEGRAGRUPOSBAJ`;DELIMITER $$

CREATE PROCEDURE `INTEGRAGRUPOSBAJ`(

	Par_grupoID			int,

	Aud_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint

	)
TerminaStore: BEGIN


DECLARE Var_EstatusCiclo    char(1);


DECLARE Entero_Cero     int;
DECLARE Decimal_Cero    decimal(12,2);
DECLARE Cadena_Vacia    char(1);
DECLARE Gru_Cerrado     char(1);


set Entero_Cero     := 0;
Set Cadena_Vacia    := '';
set Decimal_Cero    := 0.00;
set Gru_Cerrado     := 'C';

select EstatusCiclo into Var_EstatusCiclo
    from GRUPOSCREDITO
    where GrupoID	=	Par_grupoID;

set Var_EstatusCiclo    := ifnull(Var_EstatusCiclo, Cadena_Vacia);

if(Var_EstatusCiclo = Cadena_Vacia)then
	select '001' as NumErr,
		 'El Grupo no Existe.' as ErrMen,
		 'grupoID' as control;
	LEAVE TerminaStore;
end if;

if(Var_EstatusCiclo = Gru_Cerrado)then
	select '002' as NumErr,
		 'El Grupo se Encuentra Cerrado.' as ErrMen,
		 'grupoID' as control;
	LEAVE TerminaStore;
end if;

set Aud_FechaActual := CURRENT_TIMESTAMP();


update SOLICITUDCREDITO Sol, INTEGRAGRUPOSCRE Ing, GRUPOSCREDITO Gru set
    Sol.GrupoID = Entero_Cero,
    Sol.CicloGrupo = Entero_Cero
    where Gru.GrupoID	= Par_GrupoID
      and Ing.GrupoID   = Gru.GrupoID
      and Sol.SolicitudCreditoID = Ing.SolicitudCreditoID;

delete from  INTEGRAGRUPOSCRE
    where GrupoID = Par_grupoID;

select '000' as NumErr ,
		  'Integrantes del Grupo Eliminado(s) Correctamente.' as ErrMen,
		  'grupoID' as control;

END TerminaStore$$