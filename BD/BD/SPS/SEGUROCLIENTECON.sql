-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGUROCLIENTECON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGUROCLIENTECON`;DELIMITER $$

CREATE PROCEDURE `SEGUROCLIENTECON`(
	Par_SeguroClienteID     int(11),
	Par_ClienteID			int(11),
	Par_NumCon              tinyint unsigned,

	Par_EmpresaID           int(11),
	Aud_Usuario             int(11),
	Aud_FechaActual         DateTime,
	Aud_DireccionIP         varchar(15),
	Aud_ProgramaID          varchar(50),
	Aud_Sucursal            int,
	Aud_NumTransaccion      bigint
	)
TerminaStore: BEGIN


DECLARE Var_FechaSistema 	date;

DECLARE Con_Principal    	int;
DECLARE Con_Cliente		int;
DECLARE ConAplicacionSeguro	int;
DECLARE EstatusInactivo	char(1);
DECLARE EstatusVigente		char(1);
DECLARE Fecha_Vacia		date;
DECLARE Var_SegClienteID	int(11);
DECLARE ConCertSeguroVida  int;
DECLARE Con_CanSegVid	int;


set Con_Principal		:= 1;
set Con_Cliente		:= 2;
set ConAplicacionSeguro	:= 3;
set ConCertSeguroVida	:= 4;
set Con_CanSegVid		:= 5;
set EstatusInactivo		:='I';
set EstatusVigente		:='V';
set Fecha_Vacia		:='1900-01-01';

    if(Par_NumCon = Con_Principal) then
        select  SeguroClienteID,	ClienteID,	Estatus,	MontoSegPagado
        from SEGUROCLIENTE
        where SeguroClienteID = Par_SeguroClienteID;
    end if;

if(Par_NumCon = Con_Cliente) then
        select  seg.SeguroClienteID,seg.ClienteID,			seg.Estatus,	seg.MontoSegPagado,
				seg.FechaInicio,	seg.FechaVencimiento,	seg.MontoSeguro,seg.MontoSegAyuda
        from SEGUROCLIENTE seg
        where seg.ClienteID = Par_ClienteID
			and Estatus =EstatusInactivo;
end if;

if(Par_NumCon = ConAplicacionSeguro) then
select FechaSistema into Var_FechaSistema
		from PARAMETROSSIS
			where Par_EmpresaID=EmpresaID;
		set Var_FechaSistema :=ifnull(Var_FechaSistema,Fecha_Vacia);

        select  seg.SeguroClienteID,seg.ClienteID,			seg.Estatus,	seg.MontoSegPagado,
				seg.FechaInicio,	seg.FechaVencimiento,	seg.MontoSeguro,seg.MontoSegAyuda
        from SEGUROCLIENTE seg
        where seg.ClienteID = Par_ClienteID
			 and SeguroClienteID =Par_SeguroClienteID;
end if;

if(Par_NumCon = ConCertSeguroVida) then

SELECT max(SeguroClienteID) INTO Var_SegClienteID
       FROM SEGUROCLIENTE
       where ClienteID = Par_ClienteID
       and Estatus  =  EstatusVigente;

        select  SeguroClienteID,        ClienteID,          Estatus,            MontoSegPagado,
				    FechaInicio,            FechaVencimiento,   MontoSeguro,        MontoSegAyuda
        from SEGUROCLIENTE
        where ClienteID = Par_ClienteID
        AND SeguroClienteID = Var_SegClienteID;

end if;
if(Par_NumCon = Con_CanSegVid) then
	select Sucursal, FechaInicio, ClienteID, Estatus, MotivoCamEst, Observacion, ClaveAutoriza
	from SEGUROCLIENTE
	where SeguroClienteID = Par_SeguroClienteID;
end if;


END TerminaStore$$