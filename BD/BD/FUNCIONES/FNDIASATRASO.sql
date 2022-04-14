-- FNDIASATRASO
DELIMITER ;
DROP FUNCTION IF EXISTS `FNDIASATRASO`;

DELIMITER $$
CREATE FUNCTION `FNDIASATRASO`(
	-- Funcion para calcular los Dias de Atraso de un Credito
	Par_CreditoID	BIGINT(12),	-- Numero de Credito
	Par_Fecha		DATE		-- Fecha de Consulta
) RETURNS INT(11)
	DETERMINISTIC
BEGIN

	-- Declaracion de Variables
	DECLARE Var_DiaAtraso		INT(11);	-- Numero de Dias de Atraso
	DECLARE Var_DiasAtrDifer	INT(11);	-- Numero de Dias de Atraso por Diferimiento
	DECLARE Var_DiasAtrConsol	INT(11);	-- Numero de Dias de Atraso por Consolidacion
	DECLARE Var_Regularizado	CHAR(1);	-- Si esta Regularizado el Credito de Consolidacion
	DECLARE Var_FechaLimiteReporte	DATE;	-- Fecha Limite de Reporte de un credito Consolidado

	-- Declaracion de Constantes
	DECLARE Entero_Cero			INT(11);	-- Constante Entero Cero
	DECLARE Entero_Uno			INT(11);	-- Constante Entero Uno
	DECLARE Est_Pagado			CHAR(1);	-- Constante Estatus Pagado
	DECLARE Est_Vigente			CHAR(1);	-- Constante Estatus Vigente
	DECLARE Est_Atrasado		CHAR(1);	-- Constante Estatus Atrasado

	DECLARE Est_Vencido			CHAR(1);	-- Constante Estatus Vencido
	DECLARE Con_NO				CHAR(1);	-- Constante NO

	-- Asignacion de Constantes
	SET Entero_Cero				:= 0;
	SET Entero_Uno				:= 1;
	SET Est_Pagado				:= 'P';
	SET Est_Vigente				:= 'V';
	SET Est_Atrasado			:= 'A';

	SET Est_Vencido				:= 'B';
	SET Con_NO					:= 'N';

	SET Var_DiaAtraso	:= (DATEDIFF(Par_Fecha,(SELECT IFNULL(MIN(FechaExigible),Par_Fecha)
												FROM AMORTICREDITO
												WHERE CreditoID     = Par_CreditoID
												  AND FechaExigible < Par_Fecha
												  AND Estatus       != Est_Pagado)));

	-- Dias de Atraso de Creditos Diferidos
	IF EXISTS( SELECT CreditoID FROM CREDITOSDIFERIDOS WHERE CreditoID = Par_CreditoID ) THEN
		SET Var_DiasAtrDifer := (SELECT MAX(DATEDIFF(Dif.FechaCorte,Amd.FechaExigible)+1)
								 FROM CREDITOSDIFERIDOS Dif,
									  AMORTICREDITODIFER Amd,
									  AMORTICREDITO Amo
								 WHERE Dif.CreditoID = Amd.CreditoID
								   AND Dif.CreditoID = Amo.CreditoID
								   AND Amd.CreditoID = Amo.CreditoID
								   AND Amd.AmortizacionID = Amo.AmortizacionID
								   AND Amo.Estatus IN(Est_Vigente, Est_Atrasado, Est_Vencido)
								   AND Amd.FechaExigible <= Dif.FechaCorte
								   AND Dif.CreditoID = Par_CreditoID);

		SET Var_DiasAtrDifer := IFNULL(Var_DiasAtrDifer, Entero_Cero);

		IF( Var_DiasAtrDifer < Entero_Cero ) THEN
			SET Var_DiasAtrDifer := Entero_Cero;
		END IF;

		SET Var_DiaAtraso := Var_DiaAtraso + Var_DiasAtrDifer;
	END IF;

	-- Dias de Atraso de Creditos Consolidados
	IF EXISTS( SELECT CreditoID FROM REGCRECONSOLIDADOS WHERE CreditoID = Par_CreditoID ) THEN

		SELECT Reg.FechaLimiteReporte,	Reg.Regularizado,	Reg.NumDiasAtraso
		INTO Var_FechaLimiteReporte,	Var_Regularizado,	Var_DiasAtrConsol
		FROM REGCRECONSOLIDADOS Reg
		WHERE Reg.CreditoID = Par_CreditoID;

		SET Var_DiasAtrConsol := IFNULL(Var_DiasAtrConsol, Entero_Cero);
		IF( Var_DiasAtrConsol < Entero_Cero ) THEN
			SET Var_DiasAtrConsol := Entero_Cero;
		END IF;

		IF( Var_Regularizado = Con_NO ) THEN
			IF( Par_Fecha > Var_FechaLimiteReporte ) THEN
				SET Var_DiaAtraso := Var_DiaAtraso + Var_DiasAtrConsol;
			ELSE
				SET Var_DiaAtraso := Var_DiasAtrConsol;
			END IF;
		END IF;

	END IF;

	RETURN Var_DiaAtraso;
END$$