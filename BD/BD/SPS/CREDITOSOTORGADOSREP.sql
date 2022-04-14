-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOSOTORGADOSREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOSOTORGADOSREP`;
DELIMITER $$

CREATE PROCEDURE `CREDITOSOTORGADOSREP`(
    Par_Fecha			date,
	Par_SucursalID		int,
	Par_UsuarioID		int,
	Par_ProducCreditoID	int,
	Par_TipoCredito		char(1),

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
/* Declaracion de Constantes */
DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE Nuevo			char(1);
DECLARE Todos			char(1);
/* Asignacion de Constantes */
Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set Nuevo			:="N";
Set Todos			:= "0";
set Par_Fecha=ifnull(Par_Fecha,'1900-01-01');
--  ================================================================
-- Desembolsos Por dia de Cada sucursal por Asesor de Credito
--  ================================================================
 set Var_Sentencia := 'select  Suc.SucursalID as NumSucursal, Suc.NombreSucurs as NombreSucursal, Usu.UsuarioID as AsesorID, Usu.NombreCompleto as AsesorCredito, Cli.ClienteID as SocioID,
							   Cli.NombreCompleto as NombreSocio,ifnull(Sol.SolicitudCreditoID, 0) as Solicitud, Cre.CreditoID, Cre.FechaInicio, Cre.FechaVencimien,
							   Cre.MontoCredito, Cre.ProductoCreditoID, Pro.Descripcion as NombreProducto,
							   case when Cre.Relacionado = 0 then "NUEVO"
									when Cre.Relacionado > 0 then "RENOVADO O REESTRUCTURA"
							   end as TipoDeCredito,
							   Case Cre.Estatus  when "I" then "INACTIVO"
												 when "A" then "AUTORIZADO"
												 when "P" then "PAGADO"
												 when "V" then "VIGENTE"
												 when "B" then "VENCIDO"
												 when "K" then "CASTIGADO"
												 when "S" then "SUSPENDIDO"
							   end as Estatus,Cre.TasaFija as Tasa,
								case when Cre.Relacionado = 0 then 1
								 end as Nuevo,
								case when Cre.Relacionado > 0 then 1
								 end as Reestructura
							from CREDITOS Cre
								left join SOLICITUDCREDITO Sol on Sol.CreditoID = Cre.CreditoID
								inner join AMORTICREDITO Amo on Amo.CreditoID = Cre.CreditoID and Amo.AmortizacionID = 1
								inner join USUARIOS Usu on Usu.UsuarioID = Amo.Usuario
								inner join PRODUCTOSCREDITO Pro on Pro.ProducCreditoID = Cre.ProductoCreditoID
								inner join CLIENTES Cli on Cli.ClienteID = Cre.ClienteID
								inner join SUCURSALES Suc on Suc.SucursalID = Amo.Sucursal ';
  set Var_Sentencia :=  CONCAT( Var_Sentencia,'	where Cre.FechaInicio ="',  Par_Fecha,'"
												and Amo.AmortizacionID = 1
												and Cre.estatus in ("V", "B", "K", "P","S") ');

  set Par_SucursalID := ifnull(Par_SucursalID,Entero_Cero);
	if(Par_SucursalID!=Entero_Cero)then
		set Var_Sentencia = CONCAT(Var_sentencia,' and Suc.SucursalID= ',Par_SucursalID);
	end if;

  set Par_UsuarioID := ifnull(Par_UsuarioID,Entero_Cero);
	if(Par_UsuarioID!=Entero_Cero)then
		set Var_Sentencia = CONCAT(Var_sentencia,' and Usu.UsuarioID= ',Par_UsuarioID);
	end if;

  set Par_ProducCreditoID := ifnull(Par_ProducCreditoID,Entero_Cero);
	if(Par_ProducCreditoID!=Entero_Cero)then
		set Var_Sentencia = CONCAT(Var_sentencia,' and Pro.ProducCreditoID= ',Par_ProducCreditoID);
	end if;

  set Par_TipoCredito := ifnull(Par_TipoCredito,Cadena_Vacia);
	if(Par_TipoCredito!=Cadena_Vacia)then
		if(Par_TipoCredito != Todos) then
			if(Par_TipoCredito=Nuevo)then
				set Var_Sentencia = CONCAT(Var_sentencia,' and Cre.Relacionado =0 ');
			else
				set Var_Sentencia = CONCAT(Var_sentencia,' and  Cre.Relacionado >0 and Sol.TipoCredito = "R" ');
			end if;
		end if;
	end if;
  set Var_Sentencia :=  CONCAT(Var_Sentencia,' order by Suc.SucursalID, Usu.UsuarioID,  Cli.ClienteID ');

SET @Sentencia	= (Var_Sentencia);

PREPARE SPCREDOTORGADOSREP FROM @Sentencia;
EXECUTE SPCREDOTORGADOSREP;
DEALLOCATE PREPARE SPCREDOTORGADOSREP;
END TerminaStore$$