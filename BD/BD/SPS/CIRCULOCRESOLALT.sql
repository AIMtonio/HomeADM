-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CIRCULOCRESOLALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CIRCULOCRESOLALT`;DELIMITER $$

CREATE PROCEDURE `CIRCULOCRESOLALT`(
    Par_SolicitudID     	varchar(10),
	Par_Status				varchar(5),
	Par_Fecha				datetime,
	Par_FolConOtorgan		varchar(45),
	Par_ClaveOtorgante		varchar(45),
	Par_ExpEncontrado		varchar(45),
	Par_FolioConsulta		varchar(45),

    Par_Salida				char(1),
    inout	Par_NumErr		int,
    inout	Par_ErrMen		varchar(350)


	)
TerminaStore: BEGIN

DECLARE varControl		varchar(50);


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



set Par_Fecha := now();

insert into CIRCULOCRESOL(
	SolicitudID,		Status,			Fecha,		FolConOtorgan,		ClaveOtorgante,
	ExpEncontrado,		FolioConsulta	)
values (
	Par_SolicitudID,	Par_Status,		Par_Fecha,	Par_FolConOtorgan,	Par_ClaveOtorgante,
	Par_ExpEncontrado,	Par_FolioConsulta);

set Par_NumErr  := 000;
set Par_ErrMen  := concat('La Cadena de solicitudes se ha insertado correctamente: ',Par_SolicitudID);
set varControl	:= 'fk_SolicitudID';

IF (Par_Salida = Salida_SI) THEN
	SELECT  convert(Par_NumErr, CHAR(3)) AS NumErr,
			Par_ErrMen	 AS ErrMen,
			varControl	 AS control,
			Entero_Cero	 AS consecutivo;
end IF;

END TerminaStore$$