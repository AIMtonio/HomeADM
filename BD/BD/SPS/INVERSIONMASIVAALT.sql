-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INVERSIONMASIVAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `INVERSIONMASIVAALT`;DELIMITER $$

CREATE PROCEDURE `INVERSIONMASIVAALT`(
	Par_InversionOriginal		int,
  	Par_CuentaAhoID			varchar(50),
  	Par_TipoInversionID		int,
  	Par_FechaInicio			date,

	Par_MontoOriginal		float,
  	Par_PlazoOrigina		int,
  	Par_TasaOriginal		float,
  	Par_TasaISROriginal		float,
  	Par_TasaNetaOriginal		float,
  	Par_InteresGeneradoOriginal	float,
  	Par_InteresRecibirOriginal	float,
  	Par_InteresRetenerOriginal	float,


  	Par_NuevoPlazo			int,
  	Par_FechaVencimiento		date,
  	Par_MontoReinvertir		float,
  	Par_NuevaTasa			float,
  	Par_NuevaTasaISR		float,
  	Par_NuevaTasaNeta		float,
  	Par_NuevoInteresGenerado	float,
  	Par_NuevoInteresRetener		float,
  	Par_NuevoInteresRecibir		float,
  	Par_Reinvertir			varchar(5),
	Par_FechaSistema		date



	)
BEGIN


DECLARE Entero_Cero			int;
DECLARE Var_InversionID		int;
DECLARE Var_GatInfo			decimal(12,2);


Set Entero_Cero	:= 0;

set Var_InversionID := (select ifnull(Max(InversionID), Entero_Cero) + 1 from INVERSIONES);


set Var_GatInfo := (select ifnull(TAS.GatInformativo, Entero_Cero) from TASASINVERSION TAS
INNER JOIN DIASINVERSION  DIA ON DIA.TipoInversionID = TAS.TipoInversionID and TAS.DiaInversionID =DIA.DiaInversionID
INNER JOIN MONTOINVERSION MON ON  MON.TipoInversionID =TAS.TipoInversionID and TAS.MontoInversionID = MON.MontoInversionID
	WHERE TAS.TipoInversionID = Par_TipoInversionID
	AND (Par_PlazoOrigina >= DIA.PlazoInferior and Par_PlazoOrigina <= DIA.PlazoSuperior)
	AND (Par_MontoOriginal >= MON.PlazoInferior and Par_MontoOriginal <= MON.PlazoSuperior)
	limit 1);


	update INVERSIONES set Estatus = 'P' where InversionID = Par_InversionOriginal;

	insert into INVERSIONES(
		InversionID,		CuentaAhoID,		TipoInversionID,
		FechaInicio,		FechaVencimiento,	Monto,
		Plazo,				Tasa,				TasaISR,
		TasaNeta,			InteresGenerado,	InteresRecibir,
		InteresRetener,		Estatus,			Reinvertir,
		InversionRenovada, 	GatInformativo)
	values (
		Var_InversionID,	Par_CuentaAhoID,		Par_TipoInversionID,
		Par_FechaInicio,	Par_FechaVencimiento,		Par_MontoReinvertir,
		Par_NuevoPlazo,		Par_NuevaTasa,			Par_NuevaTasaISR,
		Par_NuevaTasaNeta,	Par_NuevoInteresGenerado,	Par_NuevoInteresRecibir,
		Par_NuevoInteresRetener, 'N',				Par_Reinvertir,
		Par_InversionOriginal, Var_GatInfo);


END$$