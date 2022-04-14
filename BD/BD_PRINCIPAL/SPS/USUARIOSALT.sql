-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- USUARIOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `USUARIOSALT`;DELIMITER $$

CREATE PROCEDURE `USUARIOSALT`(
	Par_Clave			varchar(50),
	Par_RolID			int,
	Par_OrigenDatos		varchar(45),
    Par_RutaReportes    varchar(100),
    Par_RutaImgReportes varchar(100),
    Par_LogoCtePantalla varchar(100),
	Par_EmpresaID		int,


	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint

)
TerminaStore: BEGIN




DECLARE	Estatus_Activo	char(1);
DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Est_SesInactivo	char(1);


Set	Estatus_Activo	:= 'A';
Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set Est_SesInactivo := 'I';

Set Aud_FechaActual := CURRENT_TIMESTAMP();

insert into USUARIOS (
    Clave,          RolID,          Estatus,	    LoginsFallidos,	 EstatusSesion,
	Semilla,		OrigenDatos,    RutaReportes,   RutaImgReportes, LogoCtePantalla,
     EmpresaID,		Usuario,	    FechaActual,	DireccionIP,
    ProgramaID,     Sucursal,		NumTransaccion	)
	values(
    Par_Clave,			Par_RolID,          Estatus_Activo,	    Entero_Cero,		 Est_SesInactivo,
	Par_Clave,			Par_OrigenDatos,	Par_RutaReportes,   Par_RutaImgReportes, Par_LogoCtePantalla,
		Par_EmpresaID,      Aud_Usuario,	    Aud_FechaActual,    Aud_DireccionIP,
    Aud_ProgramaID,		Aud_Sucursal,       Aud_NumTransaccion );

select	'000' as NumErr,
		"Usuario Agregado Exitosamente" as ErrMen,
		'usuarioID' as control,
		Entero_Cero as Consecutivo;

END TerminaStore$$