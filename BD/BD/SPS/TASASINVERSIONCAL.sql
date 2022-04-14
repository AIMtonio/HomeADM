-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TASASINVERSIONCAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `TASASINVERSIONCAL`;DELIMITER $$

CREATE PROCEDURE `TASASINVERSIONCAL`(
	Par_TipoInversionID		int,
	Par_DiaInversionID		int,
	Par_MontoInversionID	float
)
TerminaStore: BEGIN

DECLARE Fecha_Vacia		date;


DECLARE InversionID 		int;
DECLARE DiaInversionID		int;
DECLARE MontoInversionID	float;
DECLARE TasaAnualizada		decimal(12,4);
DECLARE ValorGat			decimal(12,4);
DECLARE ValorGatReal		decimal(12,4);
DECLARE Var_Inflacion		decimal(12,4);

set InversionID 		:=	Par_TipoInversionID;
set DiaInversionID		:=	Par_DiaInversionID;
set MontoInversionID	:=	Par_MontoInversionID;
set Fecha_Vacia			:=	'1900-01-01';
set TasaAnualizada		:=	0.0;
set ValorGat			:=	0.0;

Set Var_Inflacion	:=	(select InflacionProy
							from INFLACIONACTUAL
								where FechaActualizacion =
									(select max(FechaActualizacion)
											from INFLACIONACTUAL));

set TasaAnualizada	:= 	format(FUNCIONTASA(InversionID , DiaInversionID , MontoInversionID),4);
set ValorGat		:=	FUNCIONCALCTAGATINV(Fecha_Vacia,Fecha_Vacia,TasaAnualizada);
set ValorGatReal	:=	FUNCIONCALCGATREAL(ValorGat,Var_Inflacion);

select TasaAnualizada,ValorGat, ValorGatReal;


END TerminaStore$$