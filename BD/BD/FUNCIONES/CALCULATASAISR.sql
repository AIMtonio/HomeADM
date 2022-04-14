-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALCULATASAISR
DELIMITER ;
DROP FUNCTION IF EXISTS `CALCULATASAISR`;DELIMITER $$

CREATE FUNCTION `CALCULATASAISR`(
# ====================================================================
# -------FUNCION PARA OBTENER LA TASA ISR--------
# ====================================================================
	Par_Fecha 		DATE,			-- Fecha de Operacion
	Par_TasaGene	DECIMAL(12,2)   -- Tasa ISR
) RETURNS decimal(12,2)
    DETERMINISTIC
BEGIN

DECLARE Var_MaxFecha		DATE ;
DECLARE Var_SigAntFecha		DATE ;
DECLARE Var_TasaISR			DECIMAL(12,2);
DECLARE Decimal_Cero		DECIMAL(12,2);
DECLARE Var_NumTrans		BIGINT(20);
DECLARE Var_SAntNumTrans	BIGINT(20);


DECLARE TasaISRID			INT;
DECLARE EnteroUno			INT;

SET  TasaISRID				:= 1;
SET  Var_TasaISR			:= 0.00;
SET  Decimal_Cero			:= 0.00;
SET  EnteroUno				:= 1;


  SET Var_TasaISR	:=Par_TasaGene;

 SELECT MAX(Fecha),MAX(NumTransaccion)
	INTO 	Var_MaxFecha,Var_NumTrans
		FROM `HIS-TASASIMPUESTOS` WHERE TasaImpuestoID=TasaISRID;


	IF  Var_MaxFecha<=Par_Fecha THEN

		 SELECT	Valor
					INTO Var_TasaISR
						FROM `HIS-TASASIMPUESTOS`
							WHERE Fecha=Var_MaxFecha AND TasaImpuestoID=TasaISRID AND NumTransaccion=Var_NumTrans;
	ELSE
		 SELECT
			MAX(Fecha),MAX(NumTransaccion)
				INTO Var_SigAntFecha,Var_SAntNumTrans
					FROM `HIS-TASASIMPUESTOS`
						WHERE Fecha<Var_MaxFecha
								AND Fecha<=Par_Fecha AND TasaImpuestoID=TasaISRID

							LIMIT EnteroUno;

		   SELECT	Valor
					INTO Var_TasaISR
						FROM `HIS-TASASIMPUESTOS`
							WHERE Fecha=Var_SigAntFecha
								AND TasaImpuestoID=TasaISRID
								AND NumTransaccion=Var_SAntNumTrans
								LIMIT EnteroUno;

	END IF ;

  SET Var_TasaISR	:=IFNULL(Var_TasaISR,Decimal_Cero);
  RETURN Var_TasaISR;
END$$