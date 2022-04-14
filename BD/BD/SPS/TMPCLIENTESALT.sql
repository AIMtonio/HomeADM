-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCLIENTESALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TMPCLIENTESALT`;DELIMITER $$

CREATE PROCEDURE `TMPCLIENTESALT`(
	Par_SucursalOri	int,
	Par_TipoPersona	char(1),
	Par_Titulo		varchar(10),
	Par_PrimerNom		varchar(50),
	Par_SegundoNom		varchar(50),
	Par_TercerNom		varchar(50),
	Par_ApellidoPat	varchar(50),
	Par_ApellidoMat	varchar(50),
	Par_FechaNac		varchar(50),
	Par_LugarNac		varchar(100),
	Par_estadoID	 	int,
	Par_Nacion		char(1),
	Par_PaisResi 		int,
	Par_Sexo 			char(1),
	Par_CURP			char(17),
	Par_RFC			char(13),
	Par_EstadoCivil 	char(2),
	Par_TelefonoCel	varchar(20) ,
	Par_Telefono 		varchar(20) ,
	Par_Correo		varchar(50),
	Par_RazonSocial	varchar(150),
	Par_TipoSocID		int,
	Par_RFCpm			char(13),
	Par_GrupoEmp	  	int,
	Par_Fax 			varchar(20),
	Par_OcupacionID 	int,
	Par_Puesto 		varchar(100),
	Par_LugardeTrab	 varchar(100),
	Par_AntTra 		float,
	Par_TelTrabajo 	varchar(20),
	Par_Clasific	 	char(1),
	Par_MotivoApert	 char(1),
	Par_PagaISR 		char(1),
	Par_PagaIVA 		char(1),
	Par_PagaIDE 		char(1),
	Par_NivelRiesgo 	char(1),
	Par_SecGeneral		int,
	Par_ActBancoMX		varchar(15),
	Par_ActINEGI		int,
	Par_SecEconomic	int,
	Par_PromotorIni	int,
	Par_PromotorActual 	int,
	Par_NomConyuge 	varchar(150),
	Par_RFCConyuge 	varchar(13),
	Par_EmpresaID		int,

	Aud_Usuario		int,
	Aud_FechaActual	DateTime,
	Aud_DireccionIP	varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint,
	out NumeroCliente	int,
	out NumErr	int,
	out ErrMen	varchar(50),
	out NombreComplet	varchar(200)
	)
TerminaStore: BEGIN



DECLARE		Estatus_Activo	char(1);
DECLARE		Cadena_Vacia	char(1);
DECLARE		Fecha_Vacia	date;
DECLARE		Entero_Cero	int;
DECLARE		Fecha_Alta	date;
DECLARE		PaisMex		int;




Set	NumeroCliente	:= 0;
Set	NombreComplet	:= '';
Set	Estatus_Activo	:= 'A';
Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set 	PaisMex	:= 700;

set NumErr:= 49;

if(ifnull(Par_SucursalOri, Entero_Cero))= Entero_Cero then
	set NumErr:= 1;
	set ErrMen:='La sucursal esta Vacia.' ;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_TipoPersona, Cadena_Vacia)) = Cadena_Vacia then
	set NumErr:= 2;
	set ErrMen:='El Tipo de Persona esta Vacio.' ;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_Titulo, Cadena_Vacia)) = Cadena_Vacia then
	set NumErr:=3;
	set ErrMen:='El Titulo esta Vacio.' ;
	LEAVE TerminaStore;
end if;


if(ifnull(Par_PrimerNom, Cadena_Vacia)) = Cadena_Vacia then
	set  NumErr:=4;
	set ErrMen:='El Primer Nombre esta Vacio.' ;
	LEAVE TerminaStore;
end if;


if(ifnull(Par_ApellidoPat, Cadena_Vacia)) = Cadena_Vacia then
	set NumErr:=5;
	set ErrMen:= 'El Apellido Paterno esta Vacio.';
	LEAVE TerminaStore;
end if;

if(ifnull(Par_LugarNac, Cadena_Vacia)) = Cadena_Vacia then
	set NumErr:= 6;
	set ErrMen :=	 'El Lugar de Nacimiento esta Vacio.' ;
	LEAVE TerminaStore;
end if;

if(Par_LugarNac = PaisMex) then
if(ifnull(Par_estadoID, Entero_Cero))= Entero_Cero then
	set  NumErr:=7;
	set ErrMen:= 'El Estado esta Vacio.' ;
	LEAVE TerminaStore;
end if; end if;

if(ifnull(Par_Nacion, Cadena_Vacia)) = Cadena_Vacia then
	set NumErr:= 8;
	set ErrMen:= 'La Nacionalidad esta Vacia.' ;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_PaisResi, Entero_Cero)) = Entero_Cero then
	set NumErr:= 9;
	set ErrMen:= 'El pais de Residencia esta Vacio.' ;
	LEAVE TerminaStore;
end if;


if(ifnull(Par_Sexo, Cadena_Vacia)) = Cadena_Vacia then
	set NumErr:= 10;
	set ErrMen:= 'El Sexo esta Vacio.' ;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_CURP, Cadena_Vacia)) = Cadena_Vacia then
	set NumErr:=11;
	set  ErrMen:='La CURP esta Vacia.' ;
	LEAVE TerminaStore;
end if;


if(ifnull(Par_RFC, Cadena_Vacia)) = Cadena_Vacia then
	set NumErr:=12;
	set ErrMen:= 'El RFC esta Vacio.' ;
	LEAVE TerminaStore;
end if;


if(ifnull(Par_Telefono , Cadena_Vacia))= Cadena_Vacia then
	set NumErr:=13;
	set ErrMen:= 'El Telefono  esta Vacia.' ;
	LEAVE TerminaStore;
end if;

if(Par_TipoPersona='F') then
if(ifnull(Par_Puesto, Cadena_Vacia)) = Cadena_Vacia then
	set NumErr:= 14;
	set ErrMen:='El Puesto esta Vacio.' ;
	LEAVE TerminaStore;
end if;end if;

if(Par_TipoPersona='F') then
if(ifnull(Par_LugardeTrab, Cadena_Vacia)) = Cadena_Vacia then
	set NumErr :=15;
	set ErrMen:= 'El lugar de Trabajo esta Vacio.' ;
	LEAVE TerminaStore;
end if;end if;

if(Par_TipoPersona='F') then
if(ifnull(Par_AntTra, Entero_Cero)) = Entero_Cero then
	set NumErr:=16;
	set ErrMen:='La antiguedad de Trabajo esta Vacia.' ;
	LEAVE TerminaStore;
end if;end if;



if(Par_TipoPersona='M') then
if(ifnull(Par_RazonSocial, Cadena_Vacia))= Cadena_Vacia then
	set NumErr:= 17;
	set ErrMen:='La razon Social  está Vacia.' ;
	LEAVE TerminaStore;
end if;end if;


if(Par_TipoPersona='M') then
if(ifnull(Par_Fax, Cadena_Vacia))= Cadena_Vacia then
	set NumErr:=18;
	set ErrMen:='El Fax  esta Vacio.' ;
	LEAVE TerminaStore;
end if;end if;



if(ifnull(Par_Clasific, Cadena_Vacia)) = Cadena_Vacia then
	set NumErr:=19;
	set ErrMen:='La Clasificacion esta Vacia.' ;
	LEAVE TerminaStore;
end if;


if(ifnull(Par_MotivoApert, Cadena_Vacia)) = Cadena_Vacia then
	set NumErr:=20;
	set ErrMen:='EL motivo de Apertura esta Vacio.' ;
	LEAVE TerminaStore;
end if;


if(ifnull(Par_PagaISR, Cadena_Vacia)) = Cadena_Vacia then
	set NumErr:=21;
	set  ErrMen := 'El ISR esta Vacio.' ;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_PagaIVA, Cadena_Vacia)) = Cadena_Vacia then
	set NumErr:= 22;
	set ErrMen :='El IVA esta Vacio.' ;
	LEAVE TerminaStore;
end if;


if(ifnull(Par_PagaIDE, Cadena_Vacia)) = Cadena_Vacia then
	set NumErr :=23;
	set  ErrMen:='El IDE esta Vacio.' ;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_NivelRiesgo, Cadena_Vacia)) = Cadena_Vacia then
	set  NumErr:= 24;
	set ErrMen:='El Nivel de Riesgo esta Vacio.' ;
	LEAVE TerminaStore;

end if;

SET Par_GrupoEmp = ifnull(Par_GrupoEmp, Entero_Cero);

SET 	Par_OcupacionID = ifnull(	Par_OcupacionID, Entero_Cero);

if(ifnull(Par_SecGeneral, Entero_Cero)) = Entero_Cero then
	set NumErr:= 25;
	set ErrMen:= 'El sector General esta Vacio.' ;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_ActBancoMX, Cadena_Vacia)) = Cadena_Vacia then
	set NumErr:=26;
	set ErrMen:= 'La Actividad BMX esta Vacia.' ;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_PromotorIni, Entero_Cero)) = Entero_Cero then
	set NumErr:=27;
	set ErrMen:='El Promotor Inicial esta Vacio.' ;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_PromotorActual, Entero_Cero)) = Entero_Cero then
	set NumErr:=28;
	set ErrMen:= 'El Promotor Actual esta Vacio.' ;
	LEAVE TerminaStore;
end if;


if(Par_TipoPersona='F') then
set NombreComplet := CONCAT (Par_PrimerNom," ",Par_SegundoNom," ",Par_TercerNom," ",Par_ApellidoPat," ",Par_ApellidoMat);
end if;
if(Par_TipoPersona='M') then
set NombreComplet := Par_RazonSocial;
end if;

set NumeroCliente := (select ifnull(Max(ClienteID),Entero_Cero) + 1
from CLIENTES);

Set Aud_FechaActual := CURRENT_TIMESTAMP();
set Fecha_Alta:= CURDATE();
insert into CLIENTES values (NumeroCliente,		Par_EmpresaID,		Par_SucursalOri, 		Par_TipoPersona,
						Par_Titulo,			Par_PrimerNom,		Par_SegundoNom,		Par_TercerNom,
						Par_ApellidoPat,		Par_ApellidoMat,		Par_FechaNac,			Par_CURP,
						Par_Nacion,			Par_PaisResi,			Par_GrupoEmp,			Par_RazonSocial,
						Par_TipoSocID,		Par_Fax,				Par_Correo,			Par_RFC,
						Par_RFCpm,			Par_SecGeneral,		Par_ActBancoMX,		Par_ActINEGI,
						Par_SecEconomic,		Par_Sexo,			Par_EstadoCivil,		Par_LugarNac,
						Par_estadoID,			Par_OcupacionID,		Par_LugardeTrab,		Par_Puesto,
						Par_TelTrabajo,		Par_AntTra,			Par_TelefonoCel,		Par_Telefono,
						Par_Clasific,			Par_MotivoApert,		Par_PagaISR,			Par_PagaIVA,
						Par_PagaIDE,			Par_NivelRiesgo,		Par_PromotorIni,		Par_PromotorActual,
						Fecha_Alta,			Estatus_Activo,		NombreComplet,			Par_NomConyuge,
						Par_RFCConyuge,		Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
						Aud_ProgramaID,		Aud_Sucursal,
						Aud_NumTransaccion);



set NumErr:=0;
set ErrMen:=	  concat("Cliente Agregado: ", convert(NumeroCliente, CHAR))  ;

END TerminaStore$$