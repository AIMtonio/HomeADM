-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNCREDAFECTAGARAGRO
DELIMITER ;
DROP FUNCTION IF EXISTS `FNCREDAFECTAGARAGRO`;

DELIMITER $$
CREATE FUNCTION `FNCREDAFECTAGARAGRO`(
	-- Funcion que retorna el monto de Capital o Interes pagado en un rango de fechas por un credito pasivo
	-- o contigente
	-- Modulo: Cartera Agro --> Reportes --> Creditos con Afectacion de Garantia Periodico

	Par_CreditoID 			BIGINT(20),			-- ID de Credito
	Par_FechaInicio			DATE,				-- Fecha de Inicio del Ccalculo
	Par_FechaFinal 			DATE,				-- Fecha de Fin del Calculo
	Par_TipoCalculo			CHAR(1),			-- Tipo de Calculo "C".- Capital, "I".- Interes
	Par_TipoCredito			TINYINT UNSIGNED	-- Tipo de Crédito 1.- Activo Residual 2.- Contigente
) RETURNS DECIMAL(16,4)
	DETERMINISTIC
BEGIN

	-- Declaracion de Variables
	DECLARE Var_Saldo			DECIMAL(16,4);		-- Saldo
	DECLARE Var_SaldoCreMovs	DECIMAL(16,4);		-- Saldo
	DECLARE Var_FechaSistema	DATE;				-- Fecha de Sistema
	DECLARE Var_FechaCorte		DATE;				-- Fecha Corte del Credito
	DECLARE Var_FechaCorteCont	DATE;				-- Fecha Corte del Credito Contigente

	-- Declaracion de Constantes
	DECLARE Tip_Activo			TINYINT UNSIGNED;	-- Creditos de Tipo Activo Residual
	DECLARE Tip_Contigente		TINYINT UNSIGNED;	-- Creditos de Tipo contigente
	DECLARE Cal_Capital			CHAR(1);			-- Creditos de Tipo Activo Residual
	DECLARE Cal_Interes			CHAR(1);			-- Creditos de Tipo contigente
	DECLARE Entero_Cero 		INT(11);			-- Constante Entero Cero
	DECLARE Cadena_Vacia 		CHAR(1);			-- Constante Cadena Vacia
	DECLARE Nat_Abono			CHAR(1);			-- Naturaleza de Abono
	DECLARE Decimal_Cero		DECIMAL(16,2);		-- Constante Decimal Cero
	DECLARE Fecha_Vacia			DATE;				-- Constante Fecha Vacia

	-- Asignacion de Constantes
	SET Tip_Activo		 		:= 1;
	SET Tip_Contigente	 		:= 2;
	SET Cal_Capital				:= 'C';
	SET Cal_Interes				:= 'I';
	SET Entero_Cero 			:= 0;
	SET Cadena_Vacia			:= '';
	SET Nat_Abono 				:= 'A';
	SET Decimal_Cero 			:= 0.00;
	SET Fecha_Vacia				:= '1900-01-01';
	SET Var_Saldo 				:= Decimal_Cero;
	SET Var_SaldoCreMovs		:= Decimal_Cero;

	-- Creditos Activo / Residual
	IF( Par_TipoCredito = Tip_Activo ) THEN

		--  Se obtiene el capital pagado del credito de la fecha corte a la generación del reporte
		IF( Par_TipoCalculo = Cal_Capital) THEN

			SELECT IFNULL(SUM(MontoCapOrd),Decimal_Cero) + IFNULL(SUM(MontoCapAtr),Decimal_Cero) + IFNULL(SUM(MontoCapVen),Decimal_Cero)
			INTO Var_SaldoCreMovs
			FROM DETALLEPAGCRE
			WHERE CreditoID = Par_CreditoID
			  AND FechaPago BETWEEN Par_FechaInicio AND Par_FechaFinal;

			SET Var_Saldo := Var_SaldoCreMovs;
		END IF;

		--  Se obtiene el Interes pagado del credito de la fecha corte a la generación del reporte
		IF( Par_TipoCalculo = Cal_Interes) THEN

			SELECT IFNULL(SUM(MontoIntOrd),Decimal_Cero) + IFNULL(SUM(MontoIntAtr),Decimal_Cero) +
				   IFNULL(SUM(MontoIntVen),Decimal_Cero) + IFNULL(SUM(MontoIntMora),Decimal_Cero)
			INTO Var_SaldoCreMovs
			FROM DETALLEPAGCRE
			WHERE CreditoID = Par_CreditoID
			  AND FechaPago BETWEEN Par_FechaInicio AND Par_FechaFinal;

			SET Var_Saldo := Var_SaldoCreMovs;
		END IF;
	END IF;

	-- Creditos Contigente
	IF( Par_TipoCredito = Tip_Contigente ) THEN

		--  Se obtiene el capital pagado del credito de la fecha corte a la generación del reporte
		IF( Par_TipoCalculo = Cal_Capital) THEN

			SELECT IFNULL(SUM(MontoCapOrd),Decimal_Cero) + IFNULL(SUM(MontoCapAtr),Decimal_Cero) + IFNULL(SUM(MontoCapVen),Decimal_Cero)
			INTO Var_SaldoCreMovs
			FROM DETALLEPAGCRECONT
			WHERE CreditoID = Par_CreditoID
			  AND FechaPago BETWEEN Par_FechaInicio AND Par_FechaFinal;

			SET Var_Saldo := Var_SaldoCreMovs;
		END IF;

		--  Se obtiene el Interes pagado del credito de la fecha corte a la generación del reporte
		IF( Par_TipoCalculo = Cal_Interes) THEN

			SELECT IFNULL(SUM(MontoIntOrd),Decimal_Cero) + IFNULL(SUM(MontoIntAtr),Decimal_Cero) +
				   IFNULL(SUM(MontoIntVen),Decimal_Cero) + IFNULL(SUM(MontoIntMora),Decimal_Cero)
			INTO Var_SaldoCreMovs
			FROM DETALLEPAGCRECONT
			WHERE CreditoID = Par_CreditoID
			  AND FechaPago BETWEEN Par_FechaInicio AND Par_FechaFinal;

			SET Var_Saldo := Var_SaldoCreMovs;
		END IF;
	END IF;

	SET Var_Saldo := IFNULL(Var_Saldo, Decimal_Cero);

	RETURN Var_Saldo;

END$$
