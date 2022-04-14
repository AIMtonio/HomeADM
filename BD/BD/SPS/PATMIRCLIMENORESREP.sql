-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PATMIRCLIMENORESREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `PATMIRCLIMENORESREP`;DELIMITER $$

CREATE PROCEDURE `PATMIRCLIMENORESREP`(
		Par_TipoReporte	int(2),
		Par_FechaCorte	date,

		Par_EmpresaID		int,
		Aud_Usuario			int,
		Aud_FechaActual		datetime,
		Aud_DireccionIP		varchar(15),
		Aud_ProgramaID		varchar(50),
		Aud_Sucursal		int,
		Aud_NumTransaccion	bigint
	)
TerminaStore:BEGIN

-- Declaracion de constantes --
Declare Cadena_Vacia		char(1);
Declare Cadena_Si			char(1);
Declare Entero_Cero			int(11);
Declare Entero_Uno			int(11);
Declare Entero_Dos			int(11);
Declare Soltero				char(1);
Declare EdoSoltero			char(2);
Declare Femenino			char(1);
Declare Inactivo			char(1);
Declare Activo				char(1);
Declare SociosMen			int(11);
Declare AltasMen			int(11);
Declare CuentasMen			int(11);
Declare BajasMen			int(11);
Declare Var_InicioPeriodo	date;
Declare Valor_SI			char(1);
Declare InicioSocioPatmir	int(11);
Declare ClavePatmir			varchar(10);
Declare Var_ClienteInstitucion int(11);
Declare FechaVacia			date;

-- Asignacion de constantes --
Set Cadena_Vacia		:='';
Set Cadena_Si			:='S';
Set Entero_Cero			:=0;
Set Entero_uno			:=1;
Set Entero_Dos			:=2;
Set Soltero				:='S';
Set EdoSoltero			:='SE';
Set Femenino			:='F';	-- Sexo Femenino
Set Inactivo			:='I';	-- Socio Activo
Set Activo				:='A'; 	-- Socio Inactivo
Set SociosMen 			:=6;	-- Reporte Socios Menores
Set AltasMen			:=7; 	-- Reporte de Altas de Socios Menores
Set CuentasMen			:=8; 	-- Reporte Cuentas de Ahorro
Set BajasMen			:=9;  	-- Reporte Bajas de Socios Menores

Set Valor_SI			:='S';
set InicioSocioPatmir	:=4075;	-- Este valor se deberia de obtener en un campo parametrizado a nivel empresa "Fecha Ingreso Patmir"  validarse contra la fecha de alta de los Socios.
								-- Actualmente tomamos como referencia, el ID del primer socio patmir, lo mismo ocurre con la clave PATMIR.
set ClavePatmir			:='019301';
set FechaVacia			:='1900-01-01';

select ClienteInstitucion
	into  Var_ClienteInstitucion
	from PARAMETROSSIS;

set Var_InicioPeriodo	:= DATE_FORMAT(Par_FechaCorte, '%Y-%m-01');

 -- Reporte de Socios Menores --
 IF (Par_TipoReporte=SociosMen) THEN
			drop table IF EXISTS tmpREPORTE1;
			drop table if EXISTS tmpCATESTUDIOS;
			create   table tmpCATESTUDIOS  ( IdNivel int, Nivel varchar(100),idNivelSAFI  varchar(10));
			/*Deberia haber una equivalencia en las tablas del SAFI*/
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

Select cli.ClienteID, cli.CURP, concat(cli.PrimerNombre,' ',cli.SegundoNombre,' ',cli.TercerNombre) as Nombre, cli.ApellidoPaterno,
		cli.ApellidoMaterno, cli.FechaAlta as FechaRegistro, cli.FechaBaja,    cli.FechaNacimiento, edo.Clave as EstadoNacimiento,
		(case when cli.Sexo=Femenino	then Entero_Uno else Entero_Cero end)  as Genero, loc.NombreLocalidad as NombreLocalidad,dir.Calle, Entero_Cero as LenguaInd,
		(case 	when cli.EstadoCivil=Soltero then Entero_Uno -- Soltero
		when EstadoCivil=EdoSoltero then Entero_Uno  -- Soltero
		else Entero_Dos  end) as EstadoCivil, col.Asentamiento as Colonia, Entero_Uno as RecibeServVent, Entero_Cero as idNivEstudios, '' as idNivIngresos
	from CLIENTES cli
		inner join DIRECCLIENTE dir
			on dir.ClienteID = cli.ClienteID
		inner join  ESTADOSREPUB edo
			on dir.EstadoID = edo.EstadoID
		inner join MUNICIPIOSREPUB mun
			on dir.EstadoID = mun.EstadoID
			and dir.MunicipioID = mun.MunicipioID
		inner join LOCALIDADREPUB loc
			on dir.EstadoID = loc.EstadoID
			and dir.MunicipioID = loc.MunicipioID
			and dir.LocalidadID = loc.LocalidadID
		inner join COLONIASREPUB col
			on dir.EstadoID = col.EstadoID
			and dir.MunicipioID = col.MunicipioID
			and dir.ColoniaID = col.ColoniaID
		left outer join EQU_CLIENTES equ
			on cli.ClienteID=equ.ClienteIDSAFI
	where (cli.FechaAlta>=Var_InicioPeriodo and  cli.FechaAlta<=Par_FechaCorte)
		and cli.EsMenorEdad = Cadena_Si
		and (ifnull(equ.ClienteIDCte,Entero_Cero)>=InicioSocioPatmir or ifnull(equ.ClienteIDCte,Entero_Cero)=Entero_Cero));

	update tmpREPORTE1,tmpCATESTUDIOS,SOCIODEMOGRAL
									set  tmpREPORTE1.idNivEstudios=tmpCATESTUDIOS.IdNivel
					where tmpREPORTE1.ClienteID=SOCIODEMOGRAL.ClienteID
					and SOCIODEMOGRAL.GradoEscolarID like tmpCATESTUDIOS.idNivelSAFI;

END IF;
-- Reporte de Cuentas de Ahorro de Socios Menores --
IF (Par_TipoReporte=CuentasMen) THEN
									drop table IF EXISTS tmpREPORTE4;
									CREATE   TABLE tmpREPORTE4(
									SELECT ClavePatmir as ClavePA,
										max(cli.ClienteID) as Socio,
										sum(his.Saldo) as Ahorro
									FROM
									EQU_CLIENTES equ right outer join (
									CLIENTES cli  right  outer join
									`HIS-CUENTASAHO` his on cli.ClienteID=his.ClienteID )
									on equ.ClienteIDSAFI=cli.ClienteID
									where cli.FechaAlta=Par_FechaCorte
									and cli.EsMenorEdad= Cadena_Si
									and (ifnull(equ.ClienteIDCte,Entero_Cero)>=InicioSocioPatmir or ifnull(equ.ClienteIDCte,Entero_Cero)=Entero_Cero)
									and cli.ClienteID !=Var_ClienteInstitucion
									GROUP BY his.ClienteID
									order by his.ClienteID
						);


END IF;

-- Reporte de altas de Socios Menores --
IF (Par_TipoReporte=AltasMen) THEN
						drop table IF EXISTS tmpREPORTE2;
						CREATE   TABLE tmpREPORTE2
					(
						select    cli.ClienteID as Socio, date_format(cli.FechaAlta,'%d/%m/%Y') as FechaAlta
						from CLIENTES cli
						where cli.Estatus = Activo
						and cli.EsMenorEdad = Cadena_Si
						and cli.FechaAlta != FechaVacia
						and cli.FechaAlta <=Par_FechaCorte and cli.FechaAlta>=Var_InicioPeriodo
					);
END IF;
-- Reporte de bajas de Socios Menores --
IF (Par_TipoReporte=BajasMen) THEN
						drop table IF EXISTS tmpREPORTE5;
						CREATE   TABLE tmpREPORTE5
					(
						select    cli.ClienteID as Socio, date_format(cli.FechaBaja,'%d/%m/%Y') as FechaBaja
						from CLIENTES cli
						where cli.Estatus = Inactivo
						and cli.EsMenorEdad = Cadena_Si
						and cli.FechaBaja != FechaVacia
						and cli.FechaBaja <=Par_FechaCorte and cli.FechaBaja>=Var_InicioPeriodo
					);
END IF;

IF(Par_TipoReporte not in (SociosMen,AltasMen,CuentasMen,BajasMen)) then
select "Tipo de Reporte no Valido." as Err;
end IF;


 IF (Par_TipoReporte=SociosMen) THEN
			select * from tmpREPORTE1;
			drop table if exists  tmpREPORTE1;
END IF;

 IF (Par_TipoReporte=AltasMen) THEN
			select * from tmpREPORTE2;
			drop table if exists  tmpREPORTE2;
END IF;

IF (Par_TipoReporte=CuentasMen) THEN
			select * from tmpREPORTE4;
			drop table if exists  tmpREPORTE4;
END IF;

IF (Par_TipoReporte=BajasMen) THEN
			select * from tmpREPORTE5;
			drop table if exists  tmpREPORTE5;
END IF;
END TerminaStore$$