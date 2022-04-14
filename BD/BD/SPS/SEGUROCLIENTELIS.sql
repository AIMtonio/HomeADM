-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGUROCLIENTELIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGUROCLIENTELIS`;
DELIMITER $$


CREATE PROCEDURE `SEGUROCLIENTELIS`(
    Par_ClienteID			int(11),
    Par_NombreCliente       varchar(20),
    Par_NumLis              int,

    Par_EmpresaID           int,
    Aud_Usuario             int,
    Aud_FechaActual         DateTime,
    Aud_DireccionIP         varchar(15),
    Aud_ProgramaID          varchar(50),
    Aud_Sucursal            int,
    Aud_NumTransaccion      bigint

	)

TerminaStore: BEGIN
-- Declaracion de Variables
DECLARE Var_Fecha			date;
-- Declaracion de constantes
DECLARE Entero_Cero         int;
DECLARE Lis_Principal       int;
DECLARE Estatus_Vigente		char(1);
DECLARE Lis_SegCliente		int;
DECLARE Fecha_Vacia			date;
DECLARE Lis_SegPorCli			int;
DECLARE Lis_Sucursal		int(11);
DECLARE Lis_PrincipalVen		int(11);
DECLARE Lis_SucVacia		char(1);

-- Asignacion de constantes
set Entero_Cero             := 0;				-- Entero Cero
set Lis_Principal           := 1;				-- Lista Principal
set Estatus_Vigente			:='V';				-- Estatus vigente
set Lis_SegCliente			:=2;				-- Lista de Seguros por cliente
set Fecha_Vacia				:='1900-01-01';		-- Fecha Vacia
set Lis_SegPorCli			:=3;				-- Lista de Seguros pero filtra por nombre de cliente
set Lis_Sucursal			:=4;
set Lis_PrincipalVen		:=5;
set Lis_SucVacia			:='';

-- 1. Lista todos los seguros de un cliente con estatus Vigente
if(Par_NumLis = Lis_Principal) then
            select	Cli.ClienteID, Cli.NombreCompleto,SC.FechaInicio,SC.FechaVencimiento,Lis_SucVacia
            from SEGUROCLIENTE SC,
				CLIENTES Cli
            where  Cli.NombreCompleto like concat("%", Par_NombreCliente, "%")
				and Cli.ClienteID=  SC.ClienteID
				and SC.Estatus=Estatus_Vigente
				and Cli.SucursalOrigen=Aud_Sucursal
				limit 0, 15;
end if;

if(Par_NumLis = Lis_PrincipalVen) then
            select	Cli.ClienteID,Cli.NombreCompleto,SC.FechaInicio,SC.FechaVencimiento,suc.NombreSucurs
            from SEGUROCLIENTE SC,
				CLIENTES Cli,
				SUCURSALES suc
            where  Cli.NombreCompleto like concat("%", Par_NombreCliente, "%")
				and Cli.ClienteID=  SC.ClienteID
				and SC.Estatus=Estatus_Vigente
				and Cli.SucursalOrigen=suc.SucursalID
				limit 0, 50;
end if;

if(Par_NumLis = Lis_Sucursal) then
            select	Cli.ClienteID,Cli.NombreCompleto,SC.FechaInicio,SC.FechaVencimiento,Lis_SucVacia
            from SEGUROCLIENTE SC,
				CLIENTES Cli
            where  Cli.NombreCompleto like concat("%", Par_NombreCliente, "%")
				and Cli.ClienteID=  SC.ClienteID
				and SC.Estatus=Estatus_Vigente
				and Cli.SucursalOrigen=Aud_Sucursal
				limit 0, 25;
end if;

if(Par_NumLis = Lis_SegCliente) then
select FechaSistema into Var_Fecha
	from PARAMETROSSIS;
set Var_Fecha :=ifnull(Var_Fecha,Fecha_Vacia);

            select	SC.SeguroClienteID,concat(convert(SC.FechaInicio,char)," ",convert(SC.FechaVencimiento,char)," ",
					case when (SC.Estatus= 'V') then
						'VIGENTE'
					else 'COBRADO' end) as Estatus
            from SEGUROCLIENTE SC
            where  SC.ClienteID= Par_ClienteID
				and SC.Estatus = Estatus_Vigente
				and SC.FechaVencimiento >= Var_Fecha;
end if;

IF (Par_NumLis = Lis_SegPorCli) THEN
	 select	SC.SeguroClienteID, Cli.ClienteID,Cli.NombreCompleto,SC.FechaInicio,SC.FechaVencimiento
            from SEGUROCLIENTE SC,
				CLIENTES Cli
            where  Cli.NombreCompleto like concat("%", Par_NombreCliente, "%")
				and Cli.ClienteID=  SC.ClienteID
				and SC.Estatus=Estatus_Vigente
				group by SC.SeguroClienteID, Cli.ClienteID, Cli.NombreCompleto, SC.FechaInicio, SC.FechaVencimiento
				order by SC.SeguroClienteID DESC
				limit 0, 15;
END IF;

END TerminaStore$$