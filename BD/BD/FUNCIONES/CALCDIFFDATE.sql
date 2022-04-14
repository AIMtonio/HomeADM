-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALCDIFFDATE
DELIMITER ;
DROP FUNCTION IF EXISTS `CALCDIFFDATE`;DELIMITER $$

CREATE FUNCTION `CALCDIFFDATE`(
	Par_FechaInicial 	DATE,
	Par_FechaFinal		DATE,
	Par_Tipo			INT
) RETURNS varchar(200) CHARSET latin1
    DETERMINISTIC
BEGIN

	DECLARE Resultado		VARCHAR(200);
	DECLARE	TotalMes		BIGINT;
	DECLARE	TotalAnios		BIGINT;

	DECLARE	DiasFalInic		INT;
	DECLARE	DiasFinal		INT;
	DECLARE DiasIni			INT;

	DECLARE	Tipo_SoloDias	INT;
	DECLARE	Tipo_SoloMeses	INT;
	DECLARE Tipo_SoloAnios	INT;
	DECLARE Tipo_AnioMes	INT;
	DECLARE Tipo_AnioMesDia	INT;
	DECLARE	TotalDias		BIGINT;

	SET 	Tipo_SoloDias 	:= 1;
	SET		Tipo_SoloMeses	:= 2;
	SET		Tipo_SoloAnios	:= 3;
	SET		Tipo_AnioMes	:= 4;
	SET		Tipo_AnioMesDia	:= 5;
	SET		TotalDias 		:= datediff(Par_FechaFinal,Par_FechaInicial);


	CASE Par_Tipo
		WHEN Tipo_SoloDias
			THEN
				SET Resultado 		:= CONCAT(TotalDias, ' día(s).');

		WHEN Tipo_SoloMeses
			THEN
				SET TotalMes		:= TotalDias/30;
				SET Resultado 		:= CONCAT(TotalMes, ' Mes(es).');

		WHEN Tipo_SoloAnios
			THEN
				SET TotalAnios		:= TotalDias/365;
				SET Resultado 		:= CONCAT(TotalAnios, ' Año(s).');

		WHEN Tipo_AnioMes
			THEN
				SET TotalAnios		:= 	FLOOR(TotalDias/365);
				SET TotalDias		:=	(TotalDias-TotalAnios*365);
				SET TotalMes		:= 	FLOOR(TotalDias/30);
				SET Resultado 		:= 	CONCAT(TotalAnios, ' Año(s) y ',TotalMes,' Mes(es).');

		WHEN Tipo_AnioMesDia
			THEN
				SET DiasIni			:=	day(Par_FechaInicial);
				SET DiasFinal		:=	day(Par_FechaFinal);

				SET TotalAnios		:= 	year(Par_FechaFinal)	-year(Par_FechaInicial) +
										IF(date_format(Par_FechaFinal,'%m%d') < date_format(Par_FechaInicial,'%m%d'),
												-1,0
										);
				SET TotalMes		:= 	month(Par_FechaFinal)	-month(Par_FechaInicial)
										+ IF(month(Par_FechaFinal) < month(Par_FechaInicial),
												12,0
										)
										+IF(day(Par_FechaFinal) < day(Par_FechaInicial),
												-1,0
										);

				SET DiasFalInic		:=	day(Last_day(Par_FechaInicial))-day(Par_FechaInicial);
				SET TotalDias		:=	IF(	day(Par_FechaFinal) >= day(Par_FechaInicial),
											day(Par_FechaFinal) - day(Par_FechaInicial),
											DiasFalInic+DiasFinal);

				IF(Par_FechaFinal < Par_FechaInicial) THEN
					SET Resultado 		:= 'El año de inicio es mayor a la fecha actual';
				ELSE
					SET Resultado 		:= 	CONCAT(TotalAnios, ' Año(s) ',TotalMes,' Mes(es) y ',TotalDias,' Día(s).');
				END IF;
			ELSE
				SET Resultado := '';
	END CASE;

RETURN Resultado;
END$$