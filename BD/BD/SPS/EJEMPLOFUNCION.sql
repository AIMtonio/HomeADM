-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EJEMPLOFUNCION
DELIMITER ;
DROP PROCEDURE IF EXISTS `EJEMPLOFUNCION`;DELIMITER $$

CREATE PROCEDURE `EJEMPLOFUNCION`(
	Par_TipoInversionID	int,
	Par_DiaInversionID	int,
	Par_MontoInversionID	float
	)
BEGIN

DECLARE	VarDiaInversionID		int;
DECLARE	VarMontoInversionID		int;
DECLARE Var_Cero			int;
DECLARE VariableControl			int;
DECLARE VarTasaInversionID		int;
DECLARE VarConceptoInversion		float;

Set VarDiaInversionID	= 0;
Set VarMontoInversionID	= 0;
Set Var_Cero		= 0;
Set VariableControl	= 0;
Set VarTasaInversionID	= 0;
Set VarConceptoInversion	:=0;


select DiaInversionID
			from DIASINVERSION
			where PlazoInferior <= Par_DiaInversionID
			and PlazoSuperior >= Par_DiaInversionID
			and TipoInversionID = Par_TipoInversionID;

select MontoInversionID from MONTOINVERSION
					where PlazoSuperior = (
						select max(PlazoSuperior)as PlazoSuperior
						from MONTOINVERSION
						where Par_MontoInversionID >= PlazoInferior
						and TipoInversionID= Par_TipoInversionID )
					and Par_MontoInversionID >= PlazoInferior
					and TipoInversionID= Par_TipoInversionID;

select TasaInversionID
			from TASASINVERSION
			where TipoInversionID = Par_TipoInversionID
			and  DiaInversionID = VarDiaInversionID
			and MontoInversionID = VarMontoInversionID;



END$$