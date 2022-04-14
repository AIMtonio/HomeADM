-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REQGASTOSREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REQGASTOSREP`;DELIMITER $$

CREATE PROCEDURE `REQGASTOSREP`(

	Par_FechaInicio			date,
	Par_FechaFin 			date,
	Par_EstatusEnc 			char(1),
	Par_EstatusMov 			char(1),
	Par_Sucursal			int,

	Par_EmpresaID			int,
	Aud_Usuario				int,
	Aud_FechaActual			date,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint
	)
TerminaStore: BEGIN


DECLARE Var_Sentencia 	varchar(6000);
DECLARE Entero_Cero INT;
DECLARE Cadena_Vacia char(1);


Set Entero_Cero :=0;
Set Cadena_Vacia :='';


set Par_Sucursal    := ifnull(Par_Sucursal,Entero_Cero);
set Par_EstatusEnc 	:= ifnull(Par_EstatusEnc,Cadena_Vacia);
set Par_EstatusMov 	:= ifnull(Par_EstatusMov,Cadena_Vacia);


    set Var_Sentencia := 	'select  convert(LPAD(Enc.NumReqGasID, 6,"0"), char)  as FolioReq,Enc.FechRequisicion ';
	set Var_Sentencia := 	CONCAT(Var_Sentencia,' 		as FechaCaptura ,case when Enc.EstatusReq="P" then "PROCESADA" ');
	set Var_Sentencia := 	CONCAT(Var_Sentencia,' 									when Enc.EstatusReq="F" then "FINALIZADA" ');
	set Var_Sentencia := 	CONCAT(Var_Sentencia,' 									when Enc.EstatusReq="C" then "CANCELADA" ');
	set Var_Sentencia := 	CONCAT(Var_Sentencia,' 							 end as EstatusReq, ');
	set Var_Sentencia := 	CONCAT(Var_Sentencia,' 			Usu.NombreCompleto as UsuarioRegistro , ');
	set Var_Sentencia := 	CONCAT(Var_Sentencia,' 			case 	when Enc.FormaPago="S" then "SPEI" ');
	set Var_Sentencia := 	CONCAT(Var_Sentencia,' 					when Enc.FormaPago="C" then "CHEQUE" ');
	set Var_Sentencia := 	CONCAT(Var_Sentencia,' 					when Enc.FormaPago="E" then "EFECTIVO" ');
	set Var_Sentencia := 	CONCAT(Var_Sentencia,' 			end as FormaPago,Enc.SucursalID,Suc.NombreSucurs, ');
	set Var_Sentencia := 	CONCAT(Var_Sentencia,' 		Mov.MontPresupuest,Mov.NoPresupuestado,Mov.MontoAutorizado, ');
	set Var_Sentencia := 	CONCAT(Var_Sentencia,' 			convert(LPAD(Mov.ClaveDispMov,5,"0"), char)  as ClaveDispMov, case when Mov.TipoDeposito="C" then "CHEQUE" ');
	set Var_Sentencia := 	CONCAT(Var_Sentencia,' 								when Mov.TipoDeposito="S" then "SPEI" ');
	set Var_Sentencia := 	CONCAT(Var_Sentencia,' 								when Mov.TipoDeposito="B" then "BANCA ELECTRONICA" ');
	set Var_Sentencia := 	CONCAT(Var_Sentencia,' 								when Mov.TipoDeposito="T" then "TARJETA EMPRESARIAL" ');
	set Var_Sentencia := 	CONCAT(Var_Sentencia,' 						  end as TipoDeposito, ');
	set Var_Sentencia := 	CONCAT(Var_Sentencia,' 		Mov.NoFactura, Tgas.Descripcion as TipoDeGasto ,Mov.Observaciones, ');
	set Var_Sentencia := 	CONCAT(Var_Sentencia,' 		case when Prov.TipoPersona="M" then Prov.RazonSocial  ');
	set Var_Sentencia := 	CONCAT(Var_Sentencia,' 			  when  Prov.TipoPersona="F" then  ');
	set Var_Sentencia := 	CONCAT(Var_Sentencia,' 		concat(Prov.PrimerNombre," ",Prov.SegundoNombre," ", ');
	set Var_Sentencia := 	CONCAT(Var_Sentencia,' 		Prov.ApellidoPaterno," ",Prov.ApellidoMaterno)  ');
	set Var_Sentencia := 	CONCAT(Var_Sentencia,' 		end as Proveedor, ');
	set Var_Sentencia := 	CONCAT(Var_Sentencia,' 	case when 	Mov.Estatus="A" or Mov.Estatus="C" then	');
	set Var_Sentencia := 	CONCAT(Var_Sentencia,'  UsuMov.NombreCompleto ');
	set Var_Sentencia := 	CONCAT(Var_Sentencia,' 	 when 	Mov.Estatus="P" then "" end as UsuarioTesoteria,');
	set Var_Sentencia := 	CONCAT(Var_Sentencia,' 		case when Mov.Estatus="A" then "AUTORIZADO" ');
	set Var_Sentencia := 	CONCAT(Var_Sentencia,' 			when Mov.Estatus="P" then "PENDIENTE" ');
	set Var_Sentencia := 	CONCAT(Var_Sentencia,' 			when Mov.Estatus="C" then "CANCELADO" ');
	set Var_Sentencia := 	CONCAT(Var_Sentencia,' 		end as EstatusMov ');
 	set Var_Sentencia := 	CONCAT(Var_Sentencia,' 		 from REQGASTOSUCUR Enc ');
	set Var_Sentencia := 	CONCAT(Var_Sentencia,' 		inner join REQGASTOSUCURMOV Mov on Mov.NumReqGasID = Enc.NumReqGasID ');
	set Var_Sentencia := 	CONCAT(Var_Sentencia,' 		inner join USUARIOS  Usu on Usu.UsuarioID=Enc.UsuarioID ');
	set Var_Sentencia := 	CONCAT(Var_Sentencia,' 		left outer join USUARIOS  UsuMov on UsuMov.UsuarioID=Mov.UsuarioAutoID ');
	set Var_Sentencia := 	CONCAT(Var_Sentencia,' 		inner join TESOCATTIPGAS Tgas on  Mov.TipoGastoID= Tgas.TipoGastoID ');
	set Var_Sentencia := 	CONCAT(Var_Sentencia,' 		inner join PROVEEDORES Prov on Prov.ProveedorID=Mov.ProveedorID  ');
	set Var_Sentencia := 	CONCAT(Var_Sentencia,' 		inner join SUCURSALES Suc on Suc.SucursalID=Enc.SucursalID  ');
	set Var_Sentencia := 	CONCAT(Var_Sentencia,' 		where Enc.FechRequisicion >=? and Enc.FechRequisicion <=? ');

	if(Par_EstatusEnc!=Cadena_Vacia)then
		set Var_Sentencia := 	CONCAT(Var_Sentencia,' 		and Enc.EstatusReq =  "',convert(Par_EstatusEnc,char),'"');
	end if;

	if(Par_EstatusMov!=Cadena_Vacia)then
		set Var_Sentencia := 	CONCAT(Var_Sentencia,' 		and Mov.Estatus =  "',convert(Par_EstatusMov,char),'"');
	end if;

	if(Par_Sucursal!=Entero_Cero)then
		set Var_Sentencia := 	CONCAT(Var_Sentencia,' 		and Enc.SucursalID=', convert(Par_Sucursal,char));
	end if;
	set Var_Sentencia := 	CONCAT(Var_Sentencia,' 		order by  Enc.SucursalID,Enc.FechRequisicion,Enc.NumReqGasID ');

SET @Sentencia	= (Var_Sentencia);
	SET @FechaInicio	= Par_FechaInicio;
	SET @FechaFin		= Par_FechaFin;

   PREPARE STREQUGASTOSREP FROM @Sentencia;
   EXECUTE STREQUGASTOSREP USING @FechaInicio, @FechaFin;
   DEALLOCATE PREPARE STREQUGASTOSREP;

END TerminaStore$$