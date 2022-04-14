-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REPPATMIR
DELIMITER ;
DROP PROCEDURE IF EXISTS `REPPATMIR`;DELIMITER $$

CREATE PROCEDURE `REPPATMIR`(
		IN Par_TipoReporte int(2),
		IN Par_FechaCorte date
	)
TerminaStore: BEGIN
declare Socios int;
declare ParteSocial int;
declare Creditos int;
declare Cuentas int;
declare Bajas int;
declare Var_InicioPeriodo date;
declare Valor_SI char(1);
declare InicioSocioPatmir int;
declare ClavePatmir varchar(10);
declare Var_ClienteInstitucion int(11);
declare Baja char(2);


set Socios 					:=1;
set ParteSocial					:=2;
set Creditos 					:=3 ;
set Cuentas					:=4;
set Bajas 					:=5;

set Valor_SI					:='S';
set Baja					:='D';
set InicioSocioPatmir	:=4075;

set ClavePatmir			:='019301';

select ClienteInstitucion  into  Var_ClienteInstitucion  from PARAMETROSSIS;

set Var_InicioPeriodo	:= DATE_FORMAT(Par_FechaCorte, '%Y-%m-01');

 IF (Par_TipoReporte=Socios) THEN
			drop table IF EXISTS tmpREPORTE1;
			drop table if EXISTS tmpCATESTUDIOS;
			create   table tmpCATESTUDIOS  ( IdNivel int, Nivel varchar(100),idNivelSAFI  varchar(10));

			insert into tmpCATESTUDIOS  values ( 01, 'No sabe leer ni escribir','0,1'),
											(02,'Sabe leer y escribir','-'),
											(03,'Primaria Incompleta','-'),
											(04,'Primaria','2'),
											(05,'Secundaria Incompleta','-'),
											(06,'Secundaria','3'),
											(07,'Bachillerato Incompleto','-'),
											(08,'Bachillerato','4'),
											(09,'Carrera Técnica','-'),
											(10,'Estudios Superiores Incompletos','-'),
											(11,'Estudios Superiores ','5,6,7');
		create   table tmpREPORTE1 (
				select
											CLIENTES.ClienteID ,									CLIENTES.CURP,																					(concat(COALESCE(concat(PrimerNombre,' '),'') ,
																																																														COALESCE(concat(SegundoNombre,' '),' ') ,
																																																														COALESCE(TercerNombre,''	) ) )as Nombre,
											ApellidoPaterno,																ApellidoMaterno,																				(case when APORTASOCIOMOV.Tipo='A' then
																																																														date_format(APORTASOCIOMOV.Fecha,'%d/%m/%Y')
																																																														else null end)as FechaRegistro,
											(case when APORTASOCIOMOV.Tipo='D'
											then APORTASOCIOMOV.Fecha else null end)
											as FechaBaja,
																																	DATE_FORMAT(CLIENTES.FechaNacimiento,'%d/%m/%Y')
																																	as FechaNacimiento,																					ESTADOSREPUB.Clave as EstadoNacimiento,

											(case when Sexo='F'	then 1 else 0 end)as Genero,LOCALIDADREPUB.NombreLocalidad as NombreLocalidad,												DIRECCLIENTE.Calle as Calle,
											0 as LengInd,
																																(case 	when EstadoCivil='S' then 1
																																		when EstadoCivil='CS' then 3
																																		when EstadoCivil='CM' then 3
																																		when EstadoCivil='CC' then 3
																																		when EstadoCivil='V'  then 5
																																		when EstadoCivil='D'  then  4
																																		when EstadoCivil='SE' then 1
																																		else 2   end) as EdoCivil,
																																																																COLONIASREPUB.Asentamiento as Colonia,
											1 as RecibeServVent,													0 as idNivEstudios,																							''  as idNivIngresos

							from
										ESTADOSREPUB inner join  (
										PAISES inner join (
										COLONIASREPUB inner join(
										LOCALIDADREPUB inner join(
										DIRECCLIENTE inner join (
										APORTASOCIOMOV inner join(
										CLIENTES left outer join EQU_CLIENTES
															on CLIENTES.ClienteID=EQU_CLIENTES.ClienteIDSAFI)
															on APORTASOCIOMOV.ClienteID=CLIENTES.ClienteID)
															on DIRECCLIENTE.ClienteID=CLIENTES.ClienteID  )
															on LOCALIDADREPUB.LocalidadID=DIRECCLIENTE.LocalidadID  and LOCALIDADREPUB.MunicipioID=DIRECCLIENTE.MunicipioID and LOCALIDADREPUB.EstadoID=DIRECCLIENTE.EstadoID )
															on COLONIASREPUB.ColoniaID=DIRECCLIENTE.ColoniaID and COLONIASREPUB.MunicipioID=DIRECCLIENTE.MunicipioID and COLONIASREPUB.EstadoID=DIRECCLIENTE.EstadoID   )

															on PAISES.PaisID=CLIENTES.LugarNacimiento)
															on ESTADOSREPUB.EstadoID=CLIENTES.EstadoID
							where
										(APORTASOCIOMOV.Fecha>=Var_InicioPeriodo and  APORTASOCIOMOV.Fecha<=Par_FechaCorte)
										and DIRECCLIENTE.Oficial='S'
										and (coalesce(EQU_CLIENTES.ClienteIDCte,0)>=InicioSocioPatmir or coalesce(EQU_CLIENTES.ClienteIDCte,0)=0)
										and APORTASOCIOMOV.Tipo='A'
									 	and ifnull(CLIENTES.EsMenorEdad,'N') ='N'
										);

					update tmpREPORTE1,tmpCATESTUDIOS,SOCIODEMOGRAL
									set  tmpREPORTE1.idNivEstudios=tmpCATESTUDIOS.IdNivel
					where tmpREPORTE1.ClienteID=SOCIODEMOGRAL.ClienteID
					and SOCIODEMOGRAL.GradoEscolarID like tmpCATESTUDIOS.idNivelSAFI;

END IF;

 IF (Par_TipoReporte=ParteSocial) THEN

						drop table IF EXISTS tmpREPORTE2;
						drop table if EXISTS tmpAPORTACIONES;
						create   table tmpAPORTACIONES (
										select APORTACIONSOCIO.ClienteID,NombreCompleto,000.00 SaldoInicial,000.00 as Cargos, 000.00 as Abonos,000.00 as SaldoCorte ,Saldo,FechaRegistro as FechaUltMov
										from CLIENTES,APORTACIONSOCIO
										where CLIENTES.ClienteID=APORTACIONSOCIO.ClienteID );

						update APORTASOCIOMOV,tmpAPORTACIONES
						set tmpAPORTACIONES.Cargos=APORTASOCIOMOV.Monto,
								tmpAPORTACIONES.FechaUltMov=(case when APORTASOCIOMOV.Fecha>tmpAPORTACIONES.FechaUltMov then APORTASOCIOMOV.Fecha else tmpAPORTACIONES.FechaUltMov end)
						where
						APORTASOCIOMOV.ClienteID=tmpAPORTACIONES.ClienteID and Tipo='D' and Fecha<=Par_FechaCorte ;

						update APORTASOCIOMOV,tmpAPORTACIONES
						set tmpAPORTACIONES.Abonos=APORTASOCIOMOV.Monto,
								tmpAPORTACIONES.FechaUltMov=(case when APORTASOCIOMOV.Fecha>tmpAPORTACIONES.FechaUltMov then APORTASOCIOMOV.Fecha else tmpAPORTACIONES.FechaUltMov end)
						where
						APORTASOCIOMOV.ClienteID=tmpAPORTACIONES.ClienteID and Tipo='A' and Fecha<=Par_FechaCorte  ;


						update APORTASOCIOMOV,tmpAPORTACIONES
						set tmpAPORTACIONES.SaldoInicial=APORTASOCIOMOV.Monto
						where
						APORTASOCIOMOV.ClienteID=tmpAPORTACIONES.ClienteID and
						Tipo='D' and Fecha>Par_FechaCorte  and Abonos=0  and Cargos=0;


						update
						tmpAPORTACIONES
						set SaldoInicial=Saldo
						where Cargos=0 and Abonos=0  and Saldo>0 and ClienteID not in (select ClienteID
						from APORTASOCIOMOV where Tipo='A' and Fecha>Par_FechaCorte );


						update 	tmpAPORTACIONES  set SaldoCorte=SaldoInicial - Cargos+Abonos;
						update tmpAPORTACIONES set SaldoInicial=Cargos where Cargos>0;
						update tmpAPORTACIONES set SaldoCorte=SaldoInicial-Cargos+Abonos;


						create   table tmpREPORTE2(
										select    ClavePatmir ,
											ClienteID ,
											SaldoCorte as ParteSocial
										 from
										EQU_CLIENTES right outer join
										tmpAPORTACIONES  on EQU_CLIENTES.ClienteIDSAFI=tmpAPORTACIONES.ClienteID
										where FechaUltMov<=Par_FechaCorte
										and (coalesce(EQU_CLIENTES.ClienteIDCte,0)>=InicioSocioPatmir or coalesce(EQU_CLIENTES.ClienteIDCte,0)=0)
										and SaldoCorte>0
										order by ClienteID);




END IF;

IF (Par_TipoReporte=Creditos) THEN
					drop table IF EXISTS tmpREPORTE3;
					drop table if EXISTS tmpSALDOSCREDITOS;
					CREATE   TABLE tmpSALDOSCREDITOS (select * from SALDOSCREDITOS where FechaCorte=Par_FechaCorte);

					CREATE   TABLE tmpREPORTE3
					(
					select  max(ClavePatmir) as ClavePA, max(CLIENTES.ClienteID) as SocioID, Sum(coalesce((tmpSALDOSCREDITOS.SalCapAtrasado+ tmpSALDOSCREDITOS.SalCapVenNoExi+ tmpSALDOSCREDITOS.SalCapVencido+tmpSALDOSCREDITOS.SalCapVigente),0) )as Prestamo
					from
					EQU_CLIENTES right outer join
					(CLIENTES left outer join
					(CREDITOS right outer join
					tmpSALDOSCREDITOS on CREDITOS.CreditoID=tmpSALDOSCREDITOS.CreditoID)
					on CLIENTES.ClienteID=CREDITOS.ClienteID)
					on EQU_CLIENTES.ClienteIDSAFI=CLIENTES.ClienteID
					where  coalesce(tmpSALDOSCREDITOS.FechaCorte,Par_FechaCorte)=Par_FechaCorte
					and (coalesce(EQU_CLIENTES.ClienteIDCte,0)>=InicioSocioPatmir or coalesce(EQU_CLIENTES.ClienteIDCte,0)=0)
					and CLIENTES.ClienteID !=Var_ClienteInstitucion
					group by CLIENTES.ClienteID order by CLIENTES.ClienteID
					);


END IF;



IF (Par_TipoReporte=Cuentas) THEN
		drop table IF EXISTS tmpREPORTE4;
		CREATE   TABLE tmpREPORTE4(
		SELECT max(ClavePatmir) as ClavePA,
			max(CLIENTES.ClienteID) as Socio,
			sum(Saldo) as Ahorro,
		(SELECT ifnull(sum(Monto),0) FROM INVERSIONES Inv where CLIENTES.ClienteID=ClienteID
															and ((Inv.FechaInicio <= Par_FechaCorte
																AND Inv.FechaVencimiento > Par_FechaCorte
																AND (Inv.Estatus = 'N' OR Inv.Estatus = 'P'))
																	OR
																(Inv.FechaInicio <= Par_FechaCorte
																 AND Inv.Estatus = 'C'
																 AND Inv.FechaVenAnt > Par_FechaCorte
																))
		) as MontoInv,
		round((SELECT ifnull(sum(Monto),0) FROM INVERSIONES Inv where CLIENTES.ClienteID=ClienteID
															and  ((Inv.FechaInicio <= Par_FechaCorte
																AND Inv.FechaVencimiento > Par_FechaCorte
																AND (Inv.Estatus = 'N' OR Inv.Estatus = 'P'))
																OR
																(Inv.FechaInicio <= Par_FechaCorte
																 AND Inv.Estatus = 'C'
																 AND Inv.FechaVenAnt > Par_FechaCorte
																)))+sum(Saldo),2) as Total
		FROM
		EQU_CLIENTES right outer join (	CLIENTES  right  outer join
		`HIS-CUENTASAHO` on CLIENTES.ClienteID=`HIS-CUENTASAHO`.ClienteID )
		on EQU_CLIENTES.ClienteIDSAFI=CLIENTES.ClienteID
		where
		 Fecha=Par_FechaCorte
		and (coalesce(EQU_CLIENTES.ClienteIDCte,0)>=InicioSocioPatmir or coalesce(EQU_CLIENTES.ClienteIDCte,0)=0)
		and CLIENTES.ClienteID !=Var_ClienteInstitucion
		and ifnull(CLIENTES.EsMenorEdad,'N') ='N'
		GROUP BY `HIS-CUENTASAHO`.ClienteID
		order by `HIS-CUENTASAHO`.ClienteID
		);


END IF;


IF (Par_TipoReporte=Bajas) THEN
						drop table IF EXISTS tmpREPORTE5;
						CREATE   TABLE tmpREPORTE5
					(
						select    ClienteID as Socio, date_format (Fecha,'%d/%m/%Y') as FechaBaja
						from APORTASOCIOMOV
						where Tipo=Baja
						and Fecha <=Par_FechaCorte and Fecha>=Var_InicioPeriodo
					);


END IF;

IF(Par_TipoReporte not in (Creditos,ParteSocial,Socios,Cuentas,Bajas)) then
select "Tipo de Reporte no Valido." as Err;
end IF;


 IF (Par_TipoReporte=Socios) THEN
			select * from tmpREPORTE1;
			drop table if exists  tmpREPORTE1;
END IF;

 IF (Par_TipoReporte=ParteSocial) THEN
			select * from tmpREPORTE2;
			drop table if exists  tmpREPORTE2;
END IF;

IF (Par_TipoReporte=Creditos) THEN
			select * from tmpREPORTE3;
			drop table if exists  tmpREPORTE3;
END IF;

IF (Par_TipoReporte=Cuentas) THEN
			select * from tmpREPORTE4;
			drop table if exists  tmpREPORTE4;
END IF;

IF (Par_TipoReporte=Bajas) THEN
			select * from tmpREPORTE5;
			drop table if exists  tmpREPORTE5;
END IF;
END TerminaStore$$