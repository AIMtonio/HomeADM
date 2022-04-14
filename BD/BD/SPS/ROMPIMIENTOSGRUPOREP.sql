-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ROMPIMIENTOSGRUPOREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `ROMPIMIENTOSGRUPOREP`;DELIMITER $$

CREATE PROCEDURE `ROMPIMIENTOSGRUPOREP`(
	Par_FechaInicio			date,
	Par_FechaFin 			date,
	Par_GrupoID             int(11),
    	Par_SucursalID          int(11),
	Par_UsuarioID			int(11),

    Par_EmpresaID           int(11),
    Aud_Usuario             int(11),
    Aud_FechaActual         DateTime,
    Aud_DireccionIP         varchar(15),
    Aud_ProgramaID          varchar(50),
    Aud_Sucursal            int(11),
    Aud_NumTransaccion      bigint(20)

	)
TerminaStore: BEGIN


DECLARE Var_Sentencia       varchar(6000);
DECLARE FechaSistema        date;


DECLARE Cadena_Vacia		char(1);
DECLARE Entero_Cero         int;


Set Cadena_Vacia          := '';
Set	Entero_Cero           := 0;


set FechaSistema := (Select FechaSistema from PARAMETROSSIS);
	set Var_Sentencia :='select Rmp.SucursalID,Suc.NombreSucurs, Rmp.UsuarioID,Usu.NombreCompleto as NombreUsuario,Rmp.GrupoID,Gpo.NombreGrupo, ';
	set Var_Sentencia :=CONCAT(Var_Sentencia, 'Rmp.ClienteID, Cli.NombreCompleto as NombreCliente, Rmp.SolicitudCreditoID, ');
    set Var_Sentencia :=CONCAT(Var_Sentencia, 'case when Rmp.EstatusSolicitud = "C" THEN "CANCELADO" ');
	set Var_Sentencia :=CONCAT(Var_Sentencia, 'when Rmp.EstatusSolicitud = "I" then "INACTIVA" ');
	set Var_Sentencia :=CONCAT(Var_Sentencia, 'when Rmp.EstatusSolicitud = "L" then "LIBERADA" ');
	set Var_Sentencia :=CONCAT(Var_Sentencia, 'when Rmp.EstatusSolicitud = "A" then "AUTORIZADA" ');
	set Var_Sentencia :=CONCAT(Var_Sentencia, 'when Rmp.EstatusSolicitud = "C" then "CANCELADA" ');
	set Var_Sentencia :=CONCAT(Var_Sentencia, 'when Rmp.EstatusSolicitud = "R" then "RECHAZADA" ');
	set Var_Sentencia :=CONCAT(Var_Sentencia, 'when Rmp.EstatusSolicitud = "D" then "DESEMBOLSADA" ELSE "" end as EstatusSolicitud, Rmp.CreditoID, ');
    set Var_Sentencia :=CONCAT(Var_Sentencia, 'case when Rmp.EstatusCredito = "C" THEN "CANCELADO" ');
	set Var_Sentencia :=CONCAT(Var_Sentencia, 'when Rmp.EstatusCredito = "I" then "INACTIVO" ');
	set Var_Sentencia :=CONCAT(Var_Sentencia, 'when Rmp.EstatusCredito = "A" then "AUTORIZADO" ');
	set Var_Sentencia :=CONCAT(Var_Sentencia, 'when Rmp.EstatusCredito = "V" then "VIGENTE" ');
	set Var_Sentencia :=CONCAT(Var_Sentencia, 'when Rmp.EstatusCredito = "P" then "PAGADO" ');
	set Var_Sentencia :=CONCAT(Var_Sentencia, 'when Rmp.EstatusCredito = "C" then "CANCELADO" ');
	set Var_Sentencia :=CONCAT(Var_Sentencia, 'when Rmp.EstatusCredito = "B" then "VENCIDO" ');
	set Var_Sentencia :=CONCAT(Var_Sentencia, 'when Rmp.EstatusCredito = "K" then "CASTIGADO" ELSE "" end as EstatusCredito, ');
    set Var_Sentencia :=CONCAT(Var_Sentencia, 'Rmp.ProductoCredito, Pro.Descripcion, Rmp.Motivo, Rmp.Fecha ');
    set Var_Sentencia :=CONCAT(Var_Sentencia, 'from ROMPIMIENTOSGRUPO Rmp ');
    set Var_Sentencia :=CONCAT(Var_Sentencia, 'inner join CLIENTES Cli on Rmp.ClienteID=Cli.ClienteID ');
    set Var_Sentencia :=CONCAT(Var_Sentencia, 'inner join SUCURSALES Suc on Rmp.SucursalID=Suc.SucursalID ');
    set Var_Sentencia :=CONCAT(Var_Sentencia, 'inner join PRODUCTOSCREDITO Pro on Rmp.ProductoCredito=Pro.ProducCreditoID ');
	set Var_Sentencia :=CONCAT(Var_Sentencia, 'inner join USUARIOS Usu on Rmp.UsuarioID=Usu.UsuarioID ');
	set Var_Sentencia :=CONCAT(Var_Sentencia, 'inner join GRUPOSCREDITO Gpo on Rmp.GrupoID=Gpo.GrupoID ');
    set Var_Sentencia :=CONCAT(Var_Sentencia, 'where Rmp.Fecha BETWEEN ? AND ? ');

	if(ifnull(Par_GrupoID, Entero_Cero) != Entero_Cero) then
        set Var_Sentencia :=CONCAT(Var_Sentencia, ' and Rmp.GrupoID = ', Par_GrupoID);
    end if;

    if(ifnull(Par_SucursalID, Entero_Cero) != Entero_Cero) then
        set Var_Sentencia :=CONCAT(Var_Sentencia, ' and Rmp.SucursalID = ', Par_SucursalID);
    end if;

    if(ifnull(Par_UsuarioID, Entero_Cero) != Entero_Cero) then
        set Var_Sentencia :=CONCAT(Var_Sentencia, ' and Rmp.UsuarioID = ', Par_UsuarioID);
    end if;
	set Var_Sentencia := 	CONCAT(Var_Sentencia,' order by Rmp.SucursalID,Rmp.UsuarioID,Rmp.GrupoID; ');


    SET @Sentencia	= (Var_Sentencia);
    SET @FechaInicio	= Par_FechaInicio;
    SET @FechaFin		= Par_FechaFin;


    PREPARE ROMPIMIENTOSGRUPOREP FROM @Sentencia;
    EXECUTE ROMPIMIENTOSGRUPOREP USING @FechaInicio, @FechaFin;
    DEALLOCATE PREPARE ROMPIMIENTOSGRUPOREP;

END TerminaStore$$