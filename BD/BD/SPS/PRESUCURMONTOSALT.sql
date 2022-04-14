-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PRESUCURMONTOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PRESUCURMONTOSALT`;DELIMITER $$

CREATE PROCEDURE `PRESUCURMONTOSALT`(
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
	if not exists( select MontoSoli from PRESUCURMONTOS where EncabezadoID = Par_FolEnca)then
			Set Var_Monto := (select MontoSoli from PRESUCURMONTOS where EncabezadoID = Par_FolEnca);
			Set Var_Folio = (select ifnull(MAX(PresupuestoID), Entero_Cero) + 1 from PRESUCURMONTOS);

			insert into PRESUCURMONTOS values(	Var_Folio, Par_FolEnca, Par_Monto, Entero_Cero, Entero_Cero,
											Par_Sucursal, Aud_EmpresaID,	Aud_Usuario,
								Aud_FechaActual,	Aud_DireccionIP, 	Aud_ProgramaID,	Aud_Sucursal,Aud_NumTransaccion );

		else call PRESUCURMONTOSACT(Par_FolEnca,Par_Monto,Par_Estatus,Par_Sucursal,
								Aud_EmpresaID, Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,
								Aud_ProgramaID,Aud_Sucursal,	Aud_NumTransaccion);
	end if;


end if;



END TerminaStore$$