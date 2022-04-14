-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICITUDINGRESOMENORREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLICITUDINGRESOMENORREP`;DELIMITER $$

CREATE PROCEDURE `SOLICITUDINGRESOMENORREP`(
	Par_SocioMenorID    int(11),
    Par_Sucursal    	int,
	Par_TipoReporte		int,

    Par_EmpresaID       int,
    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int(11),
    Aud_NumTransaccion  bigint
	)
TerminaStore:Begin

DECLARE Var_NombreTutor		varchar(200);
DECLARE Var_FechaSistema	Date;

DECLARE CadenaVacia	   		char(1);
DECLARE DatosGenerales 		int;
DECLARE Beneficiarios  		int;
DECLARE EsBeneficiario		char(1);
DECLARE CuentaActiva		char(1);
DECLARE TipoDireccion		int;
DECLARE Est_Vigente			char(1);


set CadenaVacia		:=	'';
set DatosGenerales  :=	1;
set Beneficiarios   :=	2;
set EsBeneficiario	:= 'S';
set CuentaActiva 	:= 'A';
set TipoDireccion	:=  1;
Set Est_Vigente		:= 'V';

set Var_FechaSistema=(Select FechaSistema
						from PARAMETROSSIS
							LIMIT 1);

if(Par_TipoReporte=DatosGenerales) then

	Set Var_NombreTutor     := (select c.NombreCompleto as NombreTutor
								from SOCIOMENOR sm
								inner join CLIENTES c on c.ClienteID=sm.ClienteTutorID
								where sm.SocioMenorID=Par_SocioMenorID);

	set Var_NombreTutor :=ifnull(Var_NombreTutor,CadenaVacia);

	if(Var_NombreTutor = CadenaVacia) then

		Set Var_NombreTutor		:=(select sm.NombreTutor as NombreTutor
								from SOCIOMENOR sm
								where sm.SocioMenorID=Par_SocioMenorID);
	END if;


	select sm.SocioMenorID as NumSocio,ctes.NombreCompleto as NombreMenor,edo.Nombre as Estado,
			ctes.FechaNacimiento,year(Var_FechaSistema) - year(ctes.FechaNacimiento) as Edad,
			tr.Descripcion as Parentesco,concat(dc.Calle," No.",dc.NumeroCasa,", Lote ",dc.Lote,", MANZANA ",dc.Manzana,", ",dc.Colonia,", C.P ",dc.CP) as Direccion,
			dc.Descripcion  as Ubicacion,Var_NombreTutor as NombreTutor,suc.NombreSucurs,mun.Nombre as Municipio,
			p.Nombre as PaisNacimiento,ctes.Telefono,dc.CP as CodigoPostal,Var_FechaSistema as Fecha

	from SOCIOMENOR sm
		inner join CLIENTES ctes on sm.SocioMenorID=ctes.ClienteID
		left join ESTADOSREPUB as edo on ctes.EstadoID=edo.EstadoID
		left join TIPORELACIONES as tr on sm.TipoRelacionID=tr.TipoRelacionID
		inner join SUCURSALES suc on suc.SucursalID=ctes.SucursalOrigen
		left join PAISES as p on ctes.LugarNacimiento=p.PaisID
		left  join DIRECCLIENTE as dc on ctes.ClienteID=dc.ClienteID and dc.TipoDireccionID=TipoDireccion
		left  join MUNICIPIOSREPUB as mun on dc.MunicipioID=mun.MunicipioID  and mun.EstadoID = dc.EstadoID
	where sm.SocioMenorID=Par_SocioMenorID and ctes.SucursalOrigen=Par_Sucursal;
END if;

if(Par_TipoReporte=Beneficiarios) then


set @Numero	:=0;

Select  concat(@Numero:=@Numero + 1,')') as Numero,ca.CuentaAhoID,cp.EsBeneficiario,cp.NombreCompleto,cp.Porcentaje, Tip.Descripcion,tc.Descripcion as TipoCuenta
	from CLIENTES ctes
	inner join CUENTASAHO ca on ctes.ClienteID=ca.ClienteID	and ca.Estatus=CuentaActiva
	inner join CUENTASPERSONA cp on ca.CuentaAhoID=cp.CuentaAhoID  and cp.EsBeneficiario=EsBeneficiario and cp.EstatusRelacion = Est_Vigente
	inner join TIPORELACIONES Tip on Tip.TipoRelacionID = cp.ParentescoID
	inner join TIPOSCUENTAS tc on ca.TipoCuentaID=tc.TipoCuentaID
	where ctes.ClienteID=Par_SocioMenorID;


END if;

END TerminaStore$$