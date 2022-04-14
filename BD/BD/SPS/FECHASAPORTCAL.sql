-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FECHASAPORTCAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `FECHASAPORTCAL`;DELIMITER $$

CREATE PROCEDURE `FECHASAPORTCAL`(
-- =================================================================================
-- ---------- SP PARA REALIZAR CALCULO DE FECHAS APORTACIONES ----------
-- =================================================================================
	Par_PriFecha	DATE,
	Par_SegFecha	DATE,
	Par_NumDias		INT(11),
    Par_DiaInhabil	VARCHAR(10),
    Par_DiaPago		INT(11),
	Par_TipCalculo	INT(11)
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE	Var_NumDias		INT(11);
	DECLARE	Var_FechaRes	DATE;
    DECLARE Var_FechaHabil  DATE;
	DECLARE Var_EsHabil     CHAR(1);
    DECLARE Var_FechaDiaPago	DATE;		-- Fecha de pago de la aportacion
    DECLARE Tip_AlVencimiento	INT(11);	-- Tipo de calculo al vencimiento
    DECLARE Var_FechaUno		VARCHAR(10);-- Anio y mes de la fecha inicial
    DECLARE Var_FechaDos		VARCHAR(10);-- Anio y mes de la fecha de pago

	-- Declaracion de constantes
	DECLARE Fecha_Vacia			DATE;
	DECLARE Entero_Cero			INT(11);
    DECLARE Tip_VenDiaPago  	INT(11);    	-- CALCULA FECHA DE VENCIMIENTO Y DIFERENCIA ENTRE DIAS CON DIA INHABIL DOMINGO
    DECLARE Cons_DiaInhabilD 	VARCHAR(10);	-- Constante para dia inhabil domingo
    DECLARE Cons_DiaInhabilSD	VARCHAR(10);	-- Constante para dia inhabil sabado y domingo

	-- Asignacion de constantes
	SET Fecha_Vacia			:= '1900-01-01';
	SET Entero_Cero			:= 0;
	SET Tip_VenDiaPago  	:= 5;
    SET Tip_AlVencimiento  	:= 6;
    SET Var_FechaHabil  	:= '1900-01-01';
    SET Cons_DiaInhabilD  	:= 'D';
    SET Cons_DiaInhabilSD  	:= 'SD';


    IF(Par_TipCalculo = Tip_VenDiaPago)THEN
		-- CALCULA FECHA DE VENCIMIENTO

			SET Var_FechaRes 		:= ADDDATE(Par_PriFecha, Par_NumDias);
			SET Var_FechaDiaPago    := DATE(CONCAT(YEAR(Var_FechaRes), '-',MONTH(Var_FechaRes),'-',Par_DiaPago));

			SET Var_FechaUno:=CONCAT(YEAR(Par_PriFecha), '-',MONTH(Par_PriFecha));
			SET Var_FechaDos:=CONCAT(YEAR(Var_FechaDiaPago), '-',MONTH(Var_FechaDiaPago));

			IF(Var_FechaDiaPago < Var_FechaRes OR (Var_FechaUno = Var_FechaDos))THEN
				SET Var_FechaDiaPago    := DATE_ADD(Var_FechaDiaPago, INTERVAL 1 MONTH);
			END IF;


            SELECT  Var_FechaDiaPago AS FechaCalculada,
					Var_FechaDiaPago AS FechaHabil,
					DATEDIFF(Var_FechaDiaPago, Par_PriFecha)  AS DiasEntreFechas,
					'S' AS EsDiaHabil;
	END IF;

    IF(Par_TipCalculo = Tip_AlVencimiento)THEN
		SET Var_FechaRes := ADDDATE(Par_PriFecha, Par_NumDias);

		SELECT  Var_FechaRes AS FechaCalculada,
				Var_FechaRes AS FechaHabil,
				DATEDIFF(Var_FechaRes, Par_PriFecha)  AS DiasEntreFechas,
				'S' AS EsDiaHabil;
    END IF;

END TerminaStore$$