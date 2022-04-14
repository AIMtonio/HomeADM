-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FUNCIONTASA
DELIMITER ;
DROP FUNCTION IF EXISTS `FUNCIONTASA`;
DELIMITER $$

CREATE FUNCTION `FUNCIONTASA`(

	Par_TipoInversionID		int,
	Par_DiaInversionID		int,
	Par_MontoInversionID	decimal(12,2)
) RETURNS decimal(8,4)
	DETERMINISTIC
BEGIN


DECLARE	VarDiaInversionID		int;
DECLARE	VarMontoInversionID		int;
DECLARE Entero_Cero				int;
DECLARE VarTasaInversionID		int;
DECLARE Var_ValorTasa			DECIMAL(12,2);


Set VarDiaInversionID		:= 0;
Set VarMontoInversionID		:= 0;
Set Entero_Cero				:= 0;
Set VarTasaInversionID		:= 0;
Set Var_ValorTasa			:= 0;


Set VarDiaInversionID	:=	(select	DiaInversionID
								from	DIASINVERSION
								where	PlazoInferior	<= Par_DiaInversionID
									and	PlazoSuperior	>= Par_DiaInversionID
									and	TipoInversionID = Par_TipoInversionID);
set VarDiaInversionID	:=	ifnull(VarDiaInversionID, Entero_Cero);


Set VarMontoInversionID	:=	(select	MontoInversionID
								from	MONTOINVERSION
								where	PlazoInferior	<= Par_MontoInversionID
									and	PlazoSuperior	>= Par_MontoInversionID
									and	TipoInversionID = Par_TipoInversionID);
Set VarMontoInversionID	:=	ifnull(VarMontoInversionID, Entero_Cero);


set Var_ValorTasa		:=	(select	ConceptoInversion
								from	TASASINVERSION
								where	TipoInversionID		=	Par_TipoInversionID
									and	DiaInversionID		=	VarDiaInversionID
									and	MontoInversionID	=	VarMontoInversionID);


Set Var_ValorTasa		:=	ifnull(Var_ValorTasa, Entero_Cero);


return Var_ValorTasa;
END$$