-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTDEPMENORREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTDEPMENORREP`;DELIMITER $$

CREATE PROCEDURE `CONTDEPMENORREP`(
	Par_CuentaAhoID     		bigint(12),
    Par_TipoReporte     		int,

    Par_EmpresaID       		int,
    Aud_Usuario         		int,
    Aud_FechaActual     		DateTime,
    Aud_DireccionIP     		varchar(15),
    Aud_ProgramaID      		varchar(50),
    Aud_Sucursal        		int(11),
    Aud_NumTransaccion  		bigint

		)
TerminaStore: BEGIN


DECLARE Var_NombrePromotor  	varchar(200);
DECLARE Var_ClienteID       	bigint;
DECLARE Var_ProspectoID     	bigint;
DECLARE Var_SucursalID      	int;
DECLARE Var_PersonaID      		int(11);
DECLARE Var_NombreSucurs    	varchar(200);
DECLARE Var_NombreCli       	varchar(200);
DECLARE Var_DescParentesco		varchar(200);
DECLARE Var_BenDomicilio		varchar(200);
DECLARE Var_NombreGerente		varchar(200);


DECLARE Fecha_Vacia     		date;
DECLARE Decimal_Cero    		decimal(12,2);
DECLARE Entero_Cero     		int(11);
DECLARE Cadena_Vacia    		char(1);
DECLARE Seccion_General 		int(11);
DECLARE Seccion_Benefi      	int(11);
DECLARE Seccion_PersonaFisica 	int(11);
DECLARE OficiaSI				char(1);
DECLARE PersonaID				int(11);

DECLARE CURSORBENEFICIARIOS CURSOR FOR
select Cup.PersonaID,Cup.NombreCompleto,Tip.Descripcion,Cup.Domicilio
			from CUENTASAHO	Cue
				inner join CUENTASPERSONA Cup on Cup.CuentaAhoID=Cue.CuentaAhoID
				inner join TIPORELACIONES Tip on Cup.ParentescoID=Tip.TipoRelacionID
				where Cue.CuentaAhoID=Par_CuentaAhoID
				and Cup.EstatusRelacion = "V" and Cup.EsBeneficiario="S" ;

Set Fecha_Vacia         	:= '1900-01-01';
Set Decimal_Cero        	:= 0.0;
Set Entero_Cero         	:= 0;
Set Cadena_Vacia        	:= '';
Set Seccion_General     	:= 1;
Set Seccion_Benefi			:= 2;
Set Seccion_PersonaFisica	:= 3;
Set OficiaSI				:='S';
Set @Contador 				:=0;
Set PersonaID				:=0;
 DROP TABLE IF EXISTS TMPBENEFICIARIO;
CREATE TEMPORARY TABLE TMPBENEFICIARIO(
    `Tmp_PersonaID`   	   	int(11),
    `Tmp_Nombre`     	   	varchar(100),
    `Tmp_Direccion`   	   	varchar(200),
    `Tmp_TipoParentesco`   	varchar(200)

);
if(Par_TipoReporte = Seccion_General) then


	set Var_SucursalID := (select SucursalID  from CUENTASAHO where CuentaAhoID = Par_CuentaAhoID);
	set Var_SucursalID := ifnull(Var_SucursalID, Entero_Cero);

	set Var_NombreGerente	:= (SELECT concat(SU.TituloGte,' ',US.NombreCompleto)
									FROM	SUCURSALES	SU,
											USUARIOS 	US
									WHERE US.UsuarioID = SU.NombreGerente
										and SU.SucursalID =  Var_SucursalID);

select Cli.SucursalOrigen,Suc.NombreSucurs,Suc.DirecCompleta,Cli.NombreCompleto,Cli.FechaNacimiento,
		Soc.ClienteTutorID,Tip.Descripcion,(select FORMAT(Tasa,2)
												from TASASAHORRO
													WHERE TipoCuentaID= Cue.TipoCuentaID
															and TipoPersona='F' limit 1) as Tasa,Mun.Nombre as NombreMuncipio,Est.Nombre as NombreEstado,
		(case when Soc.ClienteTutorID=Entero_Cero then
				(select NombreTutor
					from SOCIOMENOR
						where SocioMenorID=Cli.ClienteID)
			 when Soc.ClienteTutorID>Entero_Cero then
					(select NombreCompleto
						from CLIENTES
							where ClienteID=Soc.ClienteTutorID)end) as NombreTutor,
			(case when Soc.ClienteTutorID>Entero_Cero then
						(select ifnull(DireccionCompleta,'')
						from DIRECCLIENTE
							where ClienteID=Soc.ClienteTutorID
								and Oficial=OficiaSI)end) as DireccionTutor,count(Cup.PersonaID) as NumBeneficiario,
			Var_NombreGerente AS NombreGerente
	from CUENTASAHO Cue
		inner join CLIENTES Cli	on Cli.ClienteID =Cue.ClienteID
		inner join SUCURSALES Suc on Suc.SucursalID=Cli.SucursalOrigen
		inner join SOCIOMENOR Soc on Soc.SocioMenorID=Cli.ClienteID
		inner join TIPOSCUENTAS Tip on Tip.TipoCuentaID=Cue.TipoCuentaID
		inner join MUNICIPIOSREPUB Mun on Mun.MunicipioID=Suc.MunicipioID and Mun.EstadoID =Suc.EstadoID
		inner join ESTADOSREPUB Est on Est.EstadoID =Suc.EstadoID
		left outer join CUENTASPERSONA Cup on Cup.CuentaAhoID=Cue.CuentaAhoID and  Cup.EsBeneficiario="S" and Cup.EstatusRelacion = "V"
		where Cue.CuentaAhoID=Par_CuentaAhoID;


end if;
if(Par_TipoReporte=Seccion_Benefi)then
		OPEN CURSORBENEFICIARIOS;
BEGIN
	DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
	LOOP

    FETCH CURSORBENEFICIARIOS into
	Var_PersonaID,Var_NombreCli,Var_BenDomicilio,Var_DescParentesco;
	insert TMPBENEFICIARIO values(@Contador := @Contador+1,Var_NombreCli,Var_DescParentesco,Var_BenDomicilio);

	End LOOP;
END;
CLOSE CURSORBENEFICIARIOS;
select  Tmp_PersonaID,    Tmp_Nombre,   Tmp_Direccion, Tmp_TipoParentesco
    from TMPBENEFICIARIO;

drop table TMPBENEFICIARIO;
end if;

if(Par_TipoReporte=Seccion_PersonaFisica)then
	select Tip.Descripcion,(select FORMAT(Tasa,2)
								from TASASAHORRO
									WHERE TipoCuentaID= Cue.TipoCuentaID
										and TipoPersona='F' limit 1) as Tasa
		from CUENTASAHO Cue
			inner join TIPOSCUENTAS Tip on Tip.TipoCuentaID=Cue.TipoCuentaID
			where Cue.CuentaAhoID=Par_CuentaAhoID;
end if;
END TerminaStore$$