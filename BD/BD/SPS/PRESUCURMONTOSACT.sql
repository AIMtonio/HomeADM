-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PRESUCURMONTOSACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PRESUCURMONTOSACT`;DELIMITER $$

CREATE PROCEDURE `PRESUCURMONTOSACT`(
	Par_FolEnca	int(11),
	Par_Monto	decimal(18,2),
	Par_Estatus	char(1),
	Par_Sucursal	int (11),

	Aud_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN

DECLARE		Cadena_Vacia	char(1);
DECLARE		Fecha_Vacia		date;
DECLARE		Entero_Cero		int;
DECLARE		Esta_Auto		char(1);
DECLARE		Esta_Sol			char(1);
DECLARE		Esta_Cancel		char(1);
DECLARE		Var_Folio		int (11);
DECLARE		Var_Monto		decimal(18,2);

Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia	:= '1900-01-01';
Set	Entero_Cero	:= 0;
Set	Esta_Auto := 'A';
Set	Esta_Sol	:='S';
Set	Esta_Cancel:='C';

Set Aud_FechaActual := CURRENT_TIMESTAMP();

if(Par_Estatus = Esta_Auto) then
	Set Var_Monto := (select MontoAuto from PRESUCURMONTOS where EncabezadoID = Par_FolEnca);
end if;

if(Par_Estatus = Esta_Sol) then
Set Var_Monto := (select MontoAuto from PRESUCURMONTOS where EncabezadoID = Par_FolEnca);
	update  PRESUCURMONTOS set
				MontoSoli = Par_Monto,
				MontoAuto = Entero_Cero,
				MontoPendi = Entero_Cero,
				SucursalOrigen = Par_Sucursal,

				EmpresaID = Aud_EmpresaID,
				Usuario = Aud_Usuario,
				FechaActual = Aud_FechaActual,
				DireccionIP = Aud_DireccionIP,
				ProgramaID = Aud_ProgramaID,
				Sucursal = Aud_Sucursal,
				NumTransaccion = Aud_NumTransaccion

				where EncabezadoID = Par_FolEnca;


	end if;

END TerminaStore$$