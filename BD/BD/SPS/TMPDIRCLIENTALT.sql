-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPDIRCLIENTALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TMPDIRCLIENTALT`;DELIMITER $$

CREATE PROCEDURE `TMPDIRCLIENTALT`(
	Par_ClienteID			int(11),
	Par_TipoDirecID		int(11),
	Par_EstadoID			int(11),
	Par_MunicipioID		int(11),
	Par_Calle			varchar(50),
	Par_NumeroCasa		char(10),
	Par_NumInterior		char(10),
	Par_Piso				char(10),
	Par_PrimECalle		varchar(50),
	Par_SegECalle 		varchar(50),
	Par_Colonia 			varchar(50),
	Par_CP 				int(11),
	Par_Descripcion		varchar(500),
	Par_Latitud			varchar(45),
	Par_Longitud			varchar(45),
	Par_Oficial			char(1),
	Par_EmpresaID			int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint,
	out DirecCompleta		varchar(500),
	out NumErr	int,
	out ErrMen	varchar(50)

	)
TerminaStore: BEGIN

DECLARE	NumeroDireccion	int;
DECLARE	Estatus_Activo	char(1);
DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;

DECLARE	NombEstado		varchar(50);
DECLARE	NombMunicipio	varchar(50);
DECLARE	Doficial		char(1);
DECLARE	SinN			char(5);
DECLARE 	SiOficial	char(1);

Set	NumeroDireccion	:= 0;
Set	Estatus_Activo	:= 'A';
Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	DirecCompleta	:= '';
Set	NombEstado		:= '';
Set	NombMunicipio	:= '';
set 	SinN			:='s/n';


if(exists(select TipoDireccionID from DIRECCLIENTE
            where ClienteID = Par_ClienteID and TipoDireccionID = Par_TipoDirecID)) then
		set	NumErr := 1;
		set	ErrMen := 'El cliente ya cuenta con el tipo de direccion';

	LEAVE TerminaStore;
end if;

if(ifnull(Par_EstadoID,Entero_Cero)) = Entero_Cero then
		set	NumErr := 2;
		set	ErrMen := 'El estado esta Vacio.';

	LEAVE TerminaStore;
end if;


if(ifnull(Par_MunicipioID, Entero_Cero)) = Entero_Cero then
		set	NumErr := 3;
		set	ErrMen := 'El Municipio esta Vacio.';

	LEAVE TerminaStore;
end if;

if(ifnull(Par_Calle, Cadena_Vacia)) = Cadena_Vacia then
		set	NumErr := 4;
		set	ErrMen := 'La calle esta Vacia.';

	LEAVE TerminaStore;
end if;

if(ifnull(Par_NumeroCasa, Cadena_Vacia)) = Cadena_Vacia then
		set	NumErr := 5;
		set	ErrMen := 'El numero esta Vacio.';

	LEAVE TerminaStore;
end if;

if(ifnull(Par_PrimECalle, Cadena_Vacia)) = Cadena_Vacia then
		set	NumErr := 6;
		set	ErrMen := 'La primer Entre calle esta Vacia.';

	LEAVE TerminaStore;
end if;
if(ifnull(Par_SegECalle, Cadena_Vacia)) = Cadena_Vacia then
		set	NumErr := 7;
		set	ErrMen := 'La Segunda Entre calle esta Vacia.';

	LEAVE TerminaStore;
end if;

if(ifnull(Par_Colonia, Cadena_Vacia)) = Cadena_Vacia then
		set	NumErr := 8;
		set	ErrMen := 'El Nombre de la colonia esta Vacio.';

	LEAVE TerminaStore;
end if;

if(ifnull(Par_CP, Entero_Cero)) = Entero_Cero then
		set	NumErr := 9;
		set	ErrMen := 'El Codigo Postal esta Vacio.';
	LEAVE TerminaStore;
end if;

set	Doficial := (select Oficial from DIRECCLIENTE where clienteID= Par_ClienteID and Oficial='S');


if( exists(select Oficial from DIRECCLIENTE where clienteID= Par_ClienteID and Oficial='S' and Par_Oficial='S')) then
		set	NumErr := 10;
		set	ErrMen := 'El cliente ya tiene una Direccion Oficial.';

	LEAVE TerminaStore;
end if;



SET Par_NumInterior = ifnull(Par_NumInterior, SinN);
SET Par_Piso = ifnull(Par_Piso, SinN);

set NombEstado := (SELECT Nombre
			  from ESTADOSREPUB
			  where EstadoID=Par_EstadoID);

set NombMunicipio := (SELECT M.Nombre
			     from MUNICIPIOSREPUB M,ESTADOSREPUB E
			     where E.EstadoID=M.EstadoID and E.EstadoID=Par_EstadoID and M.MunicipioID=Par_MunicipioID);

set DirecCompleta := CONCAT (Par_Calle,", No. ",Par_NumeroCasa,",Interior ",Par_NumInterior,",Piso ",Par_Piso,",Col. ",Par_Colonia,", C.P ",Par_CP,", ",NombMunicipio,", ",NombEstado);


set NumeroDireccion := (select ifnull(Max(DireccionID),Entero_Cero)+1
from DIRECCLIENTE
where ClienteID=Par_ClienteID );
Set Aud_FechaActual := CURRENT_TIMESTAMP();
insert into DIRECCLIENTE values (	Par_ClienteID,		NumeroDireccion, 	Par_EmpresaID,
								Par_TipoDirecID, 		Par_EstadoID, 	Par_MunicipioID,
								Par_Calle, 			Par_NumeroCasa, 	Par_NumInterior,
								Par_Piso,			Par_PrimECalle,	Par_SegECalle,
								Par_Colonia,			Par_CP,			DirecCompleta,
								Par_Descripcion,		Par_Latitud,		Par_Longitud,
								Par_Oficial,			Aud_Usuario,		Aud_FechaActual,
								Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,
			Aud_NumTransaccion);


set NumErr:= 0;
set ErrMen :=	  concat("Direccion del Cliente Agregada: ", convert(NumeroDireccion, CHAR))  ;
END TerminaStore$$