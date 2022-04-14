-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CIRCULOCREEMPLEALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CIRCULOCREEMPLEALT`;DELIMITER $$

CREATE PROCEDURE `CIRCULOCREEMPLEALT`(
    Par_SolicitudID         varchar(10),
	Par_Consecutivo			int(11),
	Par_NombreEmpresa		varchar(45),
	Par_Direccion			varchar(100),
	Par_ColPoblacion		varchar(100),
	Par_DelMunicipio		varchar(100),
	Par_Ciudad				varchar(45),
	Par_Estado				varchar(45),
	Par_CP					varchar(5),
	Par_NumTelefono			varchar(10),

	Par_Extension			varchar(10),
	Par_Fax					varchar(45),
	Par_Puesto				varchar(45),
	Par_FecContratacion		date,
	Par_ClaveMoneda			varchar(45),
	Par_SalarioMensual		decimal(14,2),
	Par_FecUltEmpleo		date,
	Par_FechaVerEmpleo		date,

	Par_Salida				char(1),
    inout	Par_NumErr		int,
    inout	Par_ErrMen		varchar(350)


	)
TerminaStore: BEGIN

DECLARE varControl		varchar(50);
DECLARE varConsecutivo	int(11);


DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Fecha_Alta		date;
DECLARE	Salida_SI       char(1);
DECLARE	Var_NO			char(1);


Set Cadena_Vacia		:= '';
Set Fecha_Vacia			:= '1900-01-01';
Set Entero_Cero			:= 0;


set Salida_SI			:='S';
set Var_NO				:='N';
set varConsecutivo		:= 0;




set varConsecutivo := (select ifnull(Max(Consecutivo),Entero_Cero) + 1 from CIRCULOCREEMPLE where fk_SolicitudID = Par_SolicitudID);

insert into CIRCULOCREEMPLE(
	fk_SolicitudID,		Consecutivo,		NombreEmpresa,		Direccion,			ColPoblacion,
	DelMunicipio,		Ciudad,				Estado,				CP,					NumTelefono,
	Extension,			Fax,				Puesto,				FecContratacion,	ClaveMoneda,
	SalarioMensual,		FecUltEmpleo,		FechaVerEmpleo)
values (
	Par_SolicitudID,    varConsecutivo,		Par_NombreEmpresa,	Par_Direccion,	     Par_ColPoblacion,
	Par_DelMunicipio,   Par_Ciudad,			Par_Estado,			Par_CP,		  		 Par_NumTelefono,
	Par_Extension,	    Par_Fax,			Par_Puesto,			Par_FecContratacion, Par_ClaveMoneda,
	Par_SalarioMensual,	Par_FecUltEmpleo,	Par_FechaVerEmpleo);

set Par_NumErr  := 000;
set Par_ErrMen  := concat('La Cadena de empleos se ha insertado correctamente: ',Par_SolicitudID);
set varControl	:= 'fk_SolicitudID';

IF (Par_Salida = Salida_SI) THEN
	SELECT  convert(Par_NumErr, CHAR(3)) AS NumErr,
			Par_ErrMen	 AS ErrMen,
			varControl	 AS control,
			Entero_Cero	 AS consecutivo;
end IF;

END TerminaStore$$