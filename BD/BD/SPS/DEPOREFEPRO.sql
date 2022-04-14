-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DEPOREFEPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `DEPOREFEPRO`;DELIMITER $$

CREATE PROCEDURE `DEPOREFEPRO`(

Par_FechaActual	datetime
	)
TerminaStore: BEGIN




DECLARE	TmpTipoCambio				double;
DECLARE	TmpConversionPeso			decimal(12,2);
DECLARE	TmpConversionDolar		decimal(12,2);
DECLARE	TmpDolares				double;
DECLARE	TmpFolioCar				bigint(17);
DECLARE	TmpCuenAho				int(12);
DECLARE	TmpFechaCar				date;
DECLARE	TmpMonMov				decimal(12,2);
DECLARE	TmpTipDep				char(1);
DECLARE	TmpMonedaTip				int(11);
DECLARE  TmpMonedaExtrangera				int;
DECLARE FecHisPesos				datetime;
DECLARE FecHisDll					datetime;
DECLARE TmpTipoCambioBase			double;
DECLARE TmpTipoCambioExt			double;
DECLARE	TmpMonedaBase				int;

DECLARE  CursorTmpDepoRef  CURSOR FOR
		select 	DR.FolioCargaID, 	 DR.CuentaAhoID,	DR.FechaCarga,	DR.MontoMov,		DR.TipoDeposito,		DR.MonedaID
		from DEPOSITOREFERE DR
where DR.FechaCarga=Par_FechaActual
and DR.TipoDeposito='E';


set TmpMonedaBase		:=(SELECT MonedaBaseID
									from PARAMETROSSIS);


			set TmpMonedaExtrangera :=(SELECT MonedaExtrangeraID
									from PARAMETROSSIS);


			select 	max(FechaActual)
			into		FecHisPesos
					from `HIS-MONEDAS`
					where MonedaID=TmpMonedaBase
					group by MonedaID;

			select 	max(FechaActual)
			into		FecHisDll
					from `HIS-MONEDAS`
					where MonedaID=TmpMonedaExtrangera
					group by MonedaID;

			set TmpTipoCambioBase := (SELECT H.TipCamDof
									FROM`HIS-MONEDAS`H
									where H.MonedaId=TmpMonedaBase
									and H.FechaActual=FecHisPesos);

			set TmpTipoCambioExt := (SELECT H.TipCamDof
									FROM`HIS-MONEDAS`H
									where H.MonedaId=TmpMonedaExtrangera
									and H.FechaActual=FecHisDll);




Open  CursorTmpDepoRef;
BEGIN
		DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
		Loop
			Fetch CursorTmpDepoRef  Into TmpFolioCar, TmpCuenAho, TmpFechaCar, TmpMonMov, TmpTipDep, TmpMonedaTip;

			if(TmpMonedaTip=TmpTipoCambioBase)then
				set TmpConversionPeso :=(TmpTipoCambioBase*TmpMonMov);
				set	TmpTipoCambio := TmpTipoCambioBase;
			end if;

			if(TmpMonedaTip=TmpTipoCambioExt)then
				set TmpConversionPeso :=(TmpTipoCambioExt*TmpMonMov);
				set	TmpTipoCambio := TmpTipoCambioExt;
			end if;

			if (TmpMonedaTip<>TmpTipoCambioBase and TmpMonedaTip<>TmpTipoCambioExt)then
				set TmpTipoCambio := (SELECT H.TipCamDof
								FROM`HIS-MONEDAS`H
								where H.MonedaId=TmpMonedaTip
								order by H.FechaActual DESC limit 1 );

				set TmpConversionPeso :=(TmpTipoCambio*TmpMonMov);
			end if;

			set TmpConversionDolar := (TmpConversionPeso/TmpTipoCambioExt);


INSERT INTO `microfin`.`TMPDEPOSITOREFE`
(`FolioCargaID`,`CuentaAhoID`,`FechaCarga`,`MontoMov`,`MonedaId`,
`TipCamDof`,`TipoDeposito`,`CambioPeso`,`CambioDolar`)
VALUES
(TmpFolioCar, TmpCuenAho, TmpFechaCar, TmpMonMov,TmpMonedaTip,TmpTipoCambio,TmpTipDep,TmpConversionPeso,TmpConversionDolar);


		End Loop;
	END;
	Close CursorTmpDepoRef;

END TerminaStore$$