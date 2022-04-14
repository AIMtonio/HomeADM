-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FECHASCAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `FECHASCAL`;DELIMITER $$

CREATE PROCEDURE `FECHASCAL`(
# =======================================================
# ---------- SP PARA REALIZAR CALCULO DE FECHAS----------
# =======================================================
	Par_PriFecha	DATE,
	Par_SegFecha	DATE,
	Par_NumDias		INT(11),
	Par_TipCalculo	INT(11)
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE	Var_NumDias		INT(11);
	DECLARE	Var_FechaRes	DATE;
    DECLARE Var_FechaHabil  DATE;
	DECLARE Var_EsHabil     CHAR(1);

	-- Declaracion de constantes
	DECLARE Fecha_Vacia		DATE;
	DECLARE Entero_Cero		INT(11);
	DECLARE Tip_SumaDias	INT(11);
	DECLARE Tip_RestaFechas	INT(11);
	DECLARE Tip_VenDiasSig  INT(11);    -- CALCULA FECHA DE VENCIMIENTO Y DIFERENCIA ENTRE DIAS CON DIA INHABIL SABADO Y DOMINGO
    DECLARE Tip_VenDiasSab  INT(11);    -- CALCULA FECHA DE VENCIMIENTO Y DIFERENCIA ENTRE DIAS CON DIA INHABIL DOMINGO

	-- Asignacion de constantes
	SET Fecha_Vacia			:= '1900-01-01';
	SET Entero_Cero			:= 0;
	SET Tip_SumaDias		:= 1;
	SET Tip_RestaFechas		:= 2;
    SET Tip_VenDiasSig  	:= 3;
	SET Tip_VenDiasSab  	:= 4;
    SET Var_FechaHabil  	:= '1900-01-01';


	IF(Par_TipCalculo = Tip_SumaDias) THEN
		SET Var_FechaRes := ADDDATE(Par_PriFecha, Par_NumDias);

	END IF;

	IF(Par_TipCalculo = Tip_RestaFechas) THEN
		SET Var_NumDias := DATEDIFF(Par_PriFecha, Par_SegFecha);
	END IF;

	IF(Par_TipCalculo = Tip_RestaFechas OR Par_TipCalculo = Tip_SumaDias) THEN
		SET Var_FechaRes = IFNULL(Var_FechaRes, Fecha_Vacia);
		SET Var_NumDias = IFNULL(Var_NumDias, Entero_Cero);

		SELECT	Var_FechaRes AS FecResultado,
				Var_NumDias AS DiasResultado;
	END IF;



	/* CALCULA FECHA DE VENCIMIENTO Y DIFERENCIA ENTRE DIAS  CON DIA INHABIL SABADO Y DOMINGO*/
	IF(Par_TipCalculo = Tip_VenDiasSig) THEN
		SET Var_FechaRes := ADDDATE(Par_PriFecha, Par_NumDias);
		-- SI DIA INHABIL ES SABADO Y DOMINGO
		CALL DIASFESTIVOSABDOMCAL(
			Var_FechaRes,       Entero_Cero,        Var_FechaHabil,     Var_EsHabil,        1,
			1,        			NOW(),    			'',    				'',     			1,
			1  );
		SELECT  Var_FechaRes AS FechaCalculada, Var_FechaHabil AS FechaHabil, DATEDIFF(Var_FechaHabil, Par_PriFecha)  AS DiasEntreFechas, Var_EsHabil AS EsDiaHabil;
	END IF;

    /* CALCULA FECHA DE VENCIMIENTO Y DIFERENCIA ENTRE DIAS  CON DIA INHABIL  DOMINGO*/
	IF(Par_TipCalculo = Tip_VenDiasSab) THEN
		SET Var_FechaRes := ADDDATE(Par_PriFecha, Par_NumDias);
		-- SI DIA INHABIL ES SABADO Y DOMINGO
		CALL DIASFESTIVOSCAL(
			Var_FechaRes,       Entero_Cero,        Var_FechaHabil,     Var_EsHabil,        1,
			1,        			NOW(),    			'',    				'',     			1,
			1  );
		SELECT  Var_FechaRes AS FechaCalculada, Var_FechaHabil AS FechaHabil, DATEDIFF(Var_FechaHabil, Par_PriFecha)  AS DiasEntreFechas, Var_EsHabil AS EsDiaHabil;
	END IF;


END TerminaStore$$