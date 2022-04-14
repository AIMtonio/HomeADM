-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HIS-TASASBASEALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `HIS-TASASBASEALT`;
DELIMITER $$


CREATE PROCEDURE `HIS-TASASBASEALT`(
	Par_FechaOpe		datetime,
	Par_TasaBaseID	int,
	Par_Valor		decimal(12,4),
	Aud_Empresa			int(11),

	Aud_Usuario			int(11),
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
	)

TerminaStore: BEGIN

DECLARE		Cadena_Vacia	char(1);
DECLARE		Entero_Cero		int;
DECLARE		Float_Cero		float;
DECLARE		consecutivo		int;


Set	Cadena_Vacia		:= '';
Set	Entero_Cero		:= 0;
Set	Float_Cero		:= 0.0;
Set Aud_FechaActual := CURRENT_TIMESTAMP();


INSERT INTO `HIS-TASASBASE` (
				`Fecha`,					`TasaBaseID`,					`Valor`,					`EmpresaID`,					`Usuario`,
				`FechaActual`,				`DireccionIP`,					`ProgramaID`,				`Sucursal`,						`NumTransaccion`)
    VALUES      (
		Par_FechaOpe,	Par_TasaBaseID,	Par_Valor,
		Aud_Empresa,		Aud_Usuario,		Aud_FechaActual,
		Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal	,
		Aud_NumTransaccion
);

END TerminaStore$$
