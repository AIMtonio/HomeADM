-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BLOQUEOSREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `BLOQUEOSREP`;DELIMITER $$

CREATE PROCEDURE `BLOQUEOSREP`(
	Par_SucursalID		int,
	Par_ClienteID		int,
	Par_CuentaAhoID		bigint(12),

    Par_EmpresaID       int,
    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint
		)
TerminaStore: BEGIN

DECLARE Var_Sentencia   varchar(3000);

DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;


Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;



  set Var_Sentencia := 'select Cue.CuentaAhoID, Cue.Etiqueta, Tip.Descripcion as Motivo, Blo.Descripcion,  Blo.Referencia,
							   Blo.MontoBloq,   date(Blo.FechaMov) as FechaMov, Usu.UsuarioID,   Usu.NombreCompleto,
							   Cli.ClienteID,Cli.NombreCompleto as NombreCliente,Suc.SucursalID,Suc.NombreSucurs,
							   case  when Blo.FolioBloq> 0 then
									"D" else "B" end as NatMovimiento,
							   case when  Blo.FolioBloq >0 then
										date(Blo.FechaDesbloq)
									else
										date("1900-01-01")
								end as FechaDesbloq,FORMAT(Cue.SaldoBloq,2)as SaldoBloq
									from CUENTASAHO Cue
									inner join BLOQUEOS Blo on Blo.CuentaAhoID=Cue.CuentaAhoID
									inner join TIPOSBLOQUEOS Tip On Tip.TiposBloqID=Blo.TiposBloqID
									inner join USUARIOS Usu on Usu.UsuarioID=Blo.Usuario
									inner join SUCURSALES Suc on Suc.SucursalID=Cue.SucursalID
									inner join CLIENTES Cli on Cli.ClienteID=Cue.ClienteID ';


  set Var_Sentencia :=  CONCAT( Var_Sentencia,' where Blo.NatMovimiento= "B" ');
  set Par_ClienteID := ifnull(Par_ClienteID,Entero_Cero);
	if(Par_ClienteID!=Entero_Cero)then
		set Var_Sentencia = CONCAT(Var_sentencia,' and Cue.ClienteID= ',Par_ClienteID);
	end if;

  set Par_CuentaAhoID := ifnull(Par_CuentaAhoID,Entero_Cero);
	if(Par_CuentaAhoID!=Entero_Cero)then
		set Var_Sentencia = CONCAT(Var_sentencia,' and Cue.CuentaAhoID=',Par_CuentaAhoID);
	end if;

  set Var_Sentencia :=  CONCAT(Var_Sentencia,' order by Cue.ClienteID,Cue.CuentaAhoID,Blo.FechaMov');

SET @Sentencia	= (Var_Sentencia);

PREPARE SPBLOQUEOSREP FROM @Sentencia;
EXECUTE SPBLOQUEOSREP;
DEALLOCATE PREPARE SPBLOQUEOSREP;
END TerminaStore$$