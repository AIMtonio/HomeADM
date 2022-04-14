-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOPROVEEDORESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOPROVEEDORESLIS`;DELIMITER $$

CREATE PROCEDURE `TIPOPROVEEDORESLIS`(
	Par_TipoProveedorID	varchar(10),
	Par_Descripcion		varchar(50),

	Aud_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN

DECLARE		Cadena_Vacia	char(1);
DECLARE		Fecha_Vacia		date;
DECLARE		Entero_Cero		int;
DECLARE		Lis_Principal	int;
DECLARE		EstatusActivo	char(1);

Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Lis_Principal	:= 1;
Set EstatusActivo	:='A';

select DISTINCT TipoProveedorID, Descripcion
from TIPOPROVEEDORES
where Descripcion LIKE concat("%", Par_Descripcion, "%")	limit 0, 15;

END TerminaStore$$