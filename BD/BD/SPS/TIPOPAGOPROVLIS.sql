-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOPAGOPROVLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOPAGOPROVLIS`;DELIMITER $$

CREATE PROCEDURE `TIPOPAGOPROVLIS`(
	Par_TipoPagoProvID	int,
	Par_NumLis			tinyint unsigned,

	Par_EmpresaID   	int(11),
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore:BEGIN


DECLARE	Entero_Cero			int;
DECLARE	Lis_ComboTipoPago	int;


Set	Entero_Cero			:= 0;
Set	Lis_ComboTipoPago	:= 1;

if(Par_NumLis = Lis_ComboTipoPago) then
	select	TipoPagoProvID,	Descripcion,CuentaContable
		from TIPOPAGOPROV;
end if;

END TerminaStore$$