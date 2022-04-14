-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEISOLDESREMLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEISOLDESREMLIS`;DELIMITER $$

CREATE PROCEDURE `SPEISOLDESREMLIS`(
# =====================================================================================
# ------- STORE PARA LISTAR LAS SOLICITUDES DE DESCARGA DE REMESAS SPEI ---------
# =====================================================================================
	Par_SpeiSolDesID   		bigint(20),
	Par_NumLis				tinyint unsigned,

	Par_EmpresaID			int,
	Aud_Usuario				int(11),
	Aud_FechaActual			datetime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int(11),
	Aud_NumTransaccion		bigint(20)
		)
TerminaStore: BEGIN

DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Lis_Principal	int;
DECLARE	Lis_Descargas	int;
DECLARE EstatusPendi    char(1);
DECLARE EstatusProc     char(1);
DECLARE EstatusEnviado  char(1);
DECLARE DesEstatusPendi varchar(15);
DECLARE DesEstatusProc  varchar(15);
DECLARE NumUno          int;
DECLARE Var_FechaSistema 	date;


Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Lis_Principal	:= 1;
SEt Lis_Descargas   := 2;
Set EstatusPendi    :='P';
Set EstatusProc     :='R';
Set EstatusEnviado  :='E';
Set DesEstatusPendi :='PENDIENTE';
Set DesEstatusProc  :='PROCESADO';
Set NumUno          := 1;

if(Par_NumLis = Lis_Principal) then
	select  SpeiSolDesID, case Estatus
							when EstatusPendi then DesEstatusPendi
							when EstatusProc  then DesEstatusProc
							else Cadena_Vacia end as Estatus,
		date(FechaRegistro)
	  from 	SPEISOLDESREM
	 limit 0, 15;
end if;


if(Par_NumLis = Lis_Descargas) then

	set Var_FechaSistema :=(select FechaSistema from PARAMETROSSIS);

	select ssd.SpeiSolDesID,TIME(ssd.FechaProceso) as Hora, COUNT(sdr.Estatus) as Descargas,
		SUM(case sr.Estatus when EstatusPendi then NumUno
			else Entero_Cero end) as Pendientes,
		SUM(case sr.Estatus when EstatusEnviado then NumUno
			else Entero_Cero end) as Enviados
	  from SPEISOLDESREM as ssd
	  left join SPEIDESCARGASREM as sdr on ssd.SpeiSolDesID = sdr.SpeiSolDesID
      left join SPEIREMESAS as  sr on  ssd.SpeiSolDesID = sr.SpeiSolDesID and  sdr.SpeiDetSolDesID = sr.SpeiDetSolDesID
	  where DATE(ssd.FechaRegistro) = Var_FechaSistema
  group by ssd.SpeiSolDesID, ssd.FechaProceso;
end if;

END TerminaStore$$