-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNCALCULASALDOSARRENDAMIENTOS
DELIMITER ;
DROP FUNCTION IF EXISTS `FNCALCULASALDOSARRENDAMIENTOS`;DELIMITER $$

CREATE FUNCTION `FNCALCULASALDOSARRENDAMIENTOS`(
-- Función para calcular montos de arrendamientos
	Par_ArrendaID			BIGINT(12),			-- Id del arrendamiento
    Par_ConceptoArrenda		VARCHAR(30)			-- Concepto arrendamiento
) RETURNS decimal(14,2)
    DETERMINISTIC
BEGIN

	DECLARE Var_MontoConcepto		DECIMAL(14,2);		-- Monto arrendamiento

	DECLARE	Con_IVAFaltaPag			VARCHAR(30);		-- Concepto IVA por falta de pago
	DECLARE	Con_FaltaPag			VARCHAR(30);		-- Concepto de comisión por falta de pago
	DECLARE	Con_IVAComi				VARCHAR(30);		-- Concepto IVA por otras comisiones
	DECLARE	Con_OtrasComi			VARCHAR(30);		-- Concepto otras comisiones
	DECLARE	Con_MontoIVAMora	    VARCHAR(30);		-- Concepto IVA de la mora
	DECLARE	Con_SaldoMoratorios	    VARCHAR(30);		-- Concepto de saldo moratorio
	DECLARE	Con_MontoIVASeguro	    VARCHAR(30);		-- Concepto IVA de seguro
	DECLARE	Con_SaldoSeguro		    VARCHAR(30);		-- Concepto por el seguro
	DECLARE	Con_MontoIVASeguroVida  VARCHAR(30);		-- Concepto IVA del seguro de vida
	DECLARE	Con_SaldoSeguroVida		VARCHAR(30);		-- Concepto del seguro de vida
	DECLARE	Con_MontoIVAInteres		VARCHAR(30);		-- Concepto IVA del interés
	DECLARE	Con_SaldoInteresVen		VARCHAR(30);		-- Concepto de interés vencido
	DECLARE	Con_SaldoInteresAtras	VARCHAR(30);		-- Concepto de interés atrasado
	DECLARE	Con_SaldoInteresVigente	VARCHAR(30);		-- Concepto de interés vigente
	DECLARE	Con_SaldoCapVencido		VARCHAR(30);		-- Concepto del saldo de capital vencido
	DECLARE	Con_SaldoCapAtrasad		VARCHAR(30);		-- Concepto del saldo de capital atrasado
	DECLARE	Con_MontoIVACapital		VARCHAR(30);		-- Concepto del IVA del capital
	DECLARE	Con_SaldoCapVigente		VARCHAR(30);		-- Concepto del saldo de capital vigente

	DECLARE	Decimal_Cero			DECIMAL(14,2);			-- Decimal cero
	DECLARE	Est_Vigente				CHAR(1);				-- Estatus vigente
	DECLARE	Est_Vencido				CHAR(1);				-- Estatus vencido
	DECLARE	Est_Atrasado			CHAR(1);				-- Estatus atrasado
	DECLARE	Est_Pagado				CHAR(1);				-- Estatus pagado

	SET	Con_IVAFaltaPag			:= 'MontoIVAComFalPag';		-- Valor del concepto IVA por falta de pago
	SET	Con_FaltaPag			:= 'SaldComFaltPago';		-- Valor del concepto de comisión por falta de pago
	SET	Con_IVAComi				:= 'MontoIVAComisi';		-- Valor del concepto IVA por otras comisiones
	SET	Con_OtrasComi			:= 'SaldoOtrasComis';		-- Valor del concepto otras comisiones
	SET	Con_MontoIVAMora	    := 'MontoIVAMora';			-- Valor del concepto IVA de la mora
	SET	Con_SaldoMoratorios	    := 'SaldoMoratorios';		-- Valor del concepto de saldo moratorio
	SET	Con_MontoIVASeguro	    := 'MontoIVASeguro';		-- Valor del concepto IVA de seguro
	SET	Con_SaldoSeguro		    := 'SaldoSeguro';			-- Valor del concepto por el seguro
	SET	Con_MontoIVASeguroVida	:= 'MontoIVASeguroVida';	-- Valor del concepto IVA del seguro de vida
	SET	Con_SaldoSeguroVida		:= 'SaldoSeguroVida';		-- Valor del concepto del seguro de vida
	SET	Con_SaldoInteresVen		:= 'SaldoInteresVen';		-- Valor del concepto de interés vencido
	SET	Con_SaldoInteresAtras   := 'SaldoInteresAtras';		-- Valor del concepto de interés atrasado
	SET	Con_MontoIVAInteres		:= 'MontoIVAInteres';		-- Valor del concepto IVA del interés
	SET	Con_SaldoInteresVigente := 'SaldoInteresVigente';	-- Valor del concepto de interés vigente
	SET	Con_SaldoCapVencido		:= 'SaldoCapVencido';		-- Valor del concepto del saldo de capital vencido
	SET	Con_MontoIVACapital		:= 'MontoIVACapital';		-- Valor del concepto del IVA del capital
	SET	Con_SaldoCapAtrasad		:= 'SaldoCapAtrasad';		-- Valor del concepto del saldo de capital atrasado
	SET	Con_SaldoCapVigente		:= 'SaldoCapVigente';		-- Valor del concepto del saldo de capital vigente

	SET	Decimal_Cero	:= 0.00;		-- Decimal cero
	SET	Est_Vigente		:= 'V';			-- Valor del estatus Vigente
	SET	Est_Vencido		:= 'B';			-- Valor del estatus Vencido
	SET	Est_Atrasado	:= 'A';			-- Valor del estatus Atrasado
	SET	Est_Pagado		:= 'P';			-- Valor del estatus Pagado

	IF(Par_ConceptoArrenda	= Con_FaltaPag)THEN
		SELECT	IFNULL(SUM(SaldComFaltPago),Decimal_Cero)
			INTO	Var_MontoConcepto
			FROM	ARRENDAAMORTI
			WHERE	ArrendaID	=Par_ArrendaID
			  AND	(Estatus	= Est_Vigente
			  OR	 Estatus	= Est_Vencido
			  OR	 Estatus	= Est_Atrasado);
	END IF;

	IF(Par_ConceptoArrenda	= Con_IVAFaltaPag)THEN
		SELECT	IFNULL(SUM(MontoIVAComFalPag),Decimal_Cero)
			INTO	Var_MontoConcepto
			FROM	ARRENDAAMORTI
			WHERE	ArrendaID	=Par_ArrendaID
			  AND	(Estatus	= Est_Vigente
			  OR	 Estatus	= Est_Vencido
			  OR	 Estatus	= Est_Atrasado
			  OR	 Estatus	= Est_Pagado);
	END IF;

	IF(Par_ConceptoArrenda = Con_OtrasComi)THEN
		SELECT	IFNULL(SUM(SaldoOtrasComis),Decimal_Cero)
			INTO	Var_MontoConcepto
			FROM	ARRENDAAMORTI
			WHERE	ArrendaID	=Par_ArrendaID
			  AND	(Estatus	= Est_Vigente
			  OR	 Estatus	= Est_Vencido
			  OR	 Estatus	= Est_Atrasado);
	END IF;

	IF(Par_ConceptoArrenda = Con_IVAComi)THEN
		SELECT	IFNULL(SUM(MontoIVAComisi),Decimal_Cero)
			INTO	Var_MontoConcepto
			FROM	ARRENDAAMORTI
			WHERE	ArrendaID	=Par_ArrendaID
			  AND	(Estatus	= Est_Vigente
			  OR	 Estatus	= Est_Vencido
			  OR	 Estatus	= Est_Atrasado
			  OR	 Estatus	= Est_Pagado);
	END IF;

	IF(Par_ConceptoArrenda = Con_MontoIVAMora)THEN
		SELECT	IFNULL(SUM(MontoIVAMora),Decimal_Cero)
			INTO	Var_MontoConcepto
			FROM	ARRENDAAMORTI
			WHERE	ArrendaID	=Par_ArrendaID
			  AND	(Estatus	= Est_Vigente
			  OR	 Estatus	= Est_Vencido
			  OR	 Estatus	= Est_Atrasado
			  OR	 Estatus	= Est_Pagado);
	END IF;

	IF(Par_ConceptoArrenda = Con_SaldoMoratorios)THEN
		SELECT	IFNULL(SUM(SaldoMoratorios),Decimal_Cero)
			INTO	Var_MontoConcepto
			FROM	ARRENDAAMORTI
			WHERE	ArrendaID	=Par_ArrendaID
			  AND	(Estatus	= Est_Vigente
			  OR	 Estatus	= Est_Vencido
			  OR	 Estatus	= Est_Atrasado);
	END IF;

	IF(Par_ConceptoArrenda = Con_MontoIVASeguro)THEN
			SELECT	IFNULL(SUM(MontoIVASeguro),Decimal_Cero)
			INTO	Var_MontoConcepto
			FROM	ARRENDAAMORTI
			WHERE	ArrendaID	=Par_ArrendaID
			  AND	(Estatus	= Est_Vigente
			  OR	 Estatus	= Est_Vencido
			  OR	 Estatus	= Est_Atrasado
			  OR	 Estatus	= Est_Pagado);
	END IF;

	IF(Par_ConceptoArrenda = Con_SaldoSeguro)THEN
			SELECT	IFNULL(SUM(SaldoSeguro),Decimal_Cero)
			INTO	Var_MontoConcepto
			FROM	ARRENDAAMORTI
			WHERE	ArrendaID	=Par_ArrendaID
			  AND	(Estatus	= Est_Vigente
			  OR	 Estatus	= Est_Vencido
			  OR	 Estatus	= Est_Atrasado);
	END IF;

	IF(Par_ConceptoArrenda = Con_MontoIVASeguroVida)THEN
			SELECT	IFNULL(SUM(MontoIVASeguroVida),Decimal_Cero)
			INTO	Var_MontoConcepto
			FROM	ARRENDAAMORTI
			WHERE	ArrendaID	=Par_ArrendaID
			  AND	(Estatus	= Est_Vigente
			  OR	 Estatus	= Est_Vencido
			  OR	 Estatus	= Est_Atrasado
			  OR	 Estatus	= Est_Pagado);
	END IF;

	IF(Par_ConceptoArrenda = Con_SaldoSeguroVida)THEN
			SELECT	IFNULL(SUM(SaldoSeguroVida),Decimal_Cero)
			INTO	Var_MontoConcepto
			FROM	ARRENDAAMORTI
			WHERE	ArrendaID	=Par_ArrendaID
			  AND	(Estatus	= Est_Vigente
			  OR	 Estatus	= Est_Vencido
			  OR	 Estatus	= Est_Atrasado);
	END IF;

	IF(Par_ConceptoArrenda = Con_SaldoInteresVen)THEN
			SELECT	IFNULL(SUM(SaldoInteresVen),Decimal_Cero)
			INTO	Var_MontoConcepto
			FROM	ARRENDAAMORTI
			WHERE	ArrendaID	=Par_ArrendaID
			  AND	(Estatus	= Est_Vigente
			  OR	 Estatus	= Est_Vencido
			  OR	 Estatus	= Est_Atrasado);
	END IF;

	IF(Par_ConceptoArrenda = Con_SaldoInteresAtras)THEN
			SELECT	IFNULL(SUM(SaldoInteresAtras),Decimal_Cero)
			INTO	Var_MontoConcepto
			FROM	ARRENDAAMORTI
			WHERE	ArrendaID	= Par_ArrendaID
			  AND	(Estatus	= Est_Vigente
			  OR	 Estatus	= Est_Vencido
			  OR	 Estatus	= Est_Atrasado);
	END IF;

	IF(Par_ConceptoArrenda = Con_SaldoInteresVigente)THEN
			SELECT	IFNULL(SUM(SaldoInteresVigente),Decimal_Cero)
			INTO	Var_MontoConcepto
			FROM	ARRENDAAMORTI
			WHERE	ArrendaID	=Par_ArrendaID
			  AND	(Estatus	= Est_Vigente
			  OR	 Estatus	= Est_Vencido
			  OR	 Estatus	= Est_Atrasado);
	END IF;

	IF(Par_ConceptoArrenda = Con_MontoIVAInteres)THEN
			SELECT	IFNULL(SUM(MontoIVAInteres),Decimal_Cero)
			INTO	Var_MontoConcepto
			FROM	ARRENDAAMORTI
			WHERE	ArrendaID	=Par_ArrendaID
			  AND	(Estatus	= Est_Vigente
			  OR	 Estatus	= Est_Vencido
			  OR	 Estatus	= Est_Atrasado
			  OR	 Estatus	= Est_Pagado);
	END IF;

	IF(Par_ConceptoArrenda = Con_SaldoCapVencido)THEN
			SELECT	IFNULL(SUM(SaldoCapVencido),Decimal_Cero)
			INTO	Var_MontoConcepto
			FROM	ARRENDAAMORTI
			WHERE	ArrendaID	=Par_ArrendaID
			  AND	(Estatus	= Est_Vigente
			  OR	 Estatus	= Est_Vencido
			  OR	 Estatus	= Est_Atrasado);
	END IF;

	IF(Par_ConceptoArrenda = Con_SaldoCapAtrasad)THEN
			SELECT	IFNULL(SUM(SaldoCapAtrasad),Decimal_Cero)
			INTO	Var_MontoConcepto
			FROM	ARRENDAAMORTI
			WHERE	ArrendaID	=Par_ArrendaID
			  AND	(Estatus	= Est_Vigente
			  OR	 Estatus	= Est_Vencido
			  OR	 Estatus	= Est_Atrasado);
	END IF;

	IF(Par_ConceptoArrenda = Con_SaldoCapVigente)THEN
			SELECT	IFNULL(SUM(SaldoCapVigent),Decimal_Cero)
			INTO	Var_MontoConcepto
			FROM	ARRENDAAMORTI
			WHERE	ArrendaID	=Par_ArrendaID
			  AND	(Estatus	= Est_Vigente
			  OR	 Estatus	= Est_Vencido
			  OR	 Estatus	= Est_Atrasado);
	END IF;


	IF(Par_ConceptoArrenda = Con_MontoIVACapital)THEN
			SELECT	IFNULL(SUM(MontoIVACapital),Decimal_Cero)
			INTO	Var_MontoConcepto
			FROM	ARRENDAAMORTI
			WHERE	ArrendaID	=Par_ArrendaID
			  AND	(Estatus	= Est_Vigente
			  OR	 Estatus	= Est_Vencido
			  OR	 Estatus	= Est_Atrasado
			  OR	 Estatus	= Est_Pagado);
	END IF;


	RETURN Var_MontoConcepto;
END$$