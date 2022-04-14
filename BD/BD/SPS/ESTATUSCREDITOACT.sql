-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESTATUSCREDITOACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESTATUSCREDITOACT`;
DELIMITER $$

CREATE PROCEDURE `ESTATUSCREDITOACT`(

/* SP que realiza validaciones para asignar el estatus con el que nace un Credito

    Renovado o Reestructurado */
    Par_CreditoAnteri    	BIGINT(12),		-- ID Credito anterior
    Par_EstatusCredAnt      CHAR(1),		-- Estatus Credito Anterior
    OUT	Par_EstatusCreacion CHAR(1),		-- Estatus que sera asignado

    Par_Salida              CHAR(1),
	INOUT Par_NumErr          INT(11),
	INOUT Par_ErrMen          VARCHAR(400),

	# Parametros de Auditoria
    Aud_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de variables
    DECLARE Tipo_PagCap			CHAR(1);		-- Tipo de Pago de Capital
    DECLARE Var_TotalInteres	DECIMAL(12,2);	-- Total Adeudo de Intereses
    DECLARE Res_SaldoExigi      DECIMAL(12,2);	-- Saldo Exigible del Credito a Reestructurar
    DECLARE Var_PorcTrans		DECIMAL(12,2);	-- Porcentaje del Plazo Transcurrido
    DECLARE Var_MontoPag		DECIMAL(12,2);	-- Monto del Capital Cubierto
    DECLARE Var_MontoPorc		DECIMAL(12,2);	-- Porcentaje de Capital Cubierto
    DECLARE Var_TipoCredito		CHAR(1);		-- Tipo de Credito


	-- Declaracion de constantes
	DECLARE Cadena_Vacia    CHAR(1);
	DECLARE Entero_Cero     INT;
    DECLARE Decimal_Cero	DECIMAL(12,2);
	DECLARE Fecha_Vacia     DATE;
	DECLARE Var_SI          CHAR(1);
	DECLARE Var_NO          CHAR(1);
	DECLARE Est_Vencido    	CHAR(1);			-- Estatus Vencido
    DECLARE Salida_SI		CHAR(1);
    DECLARE Est_Vigente		CHAR(1);			-- Estatus Vigente
    DECLARE Pago_Unico		CHAR(1);			-- Pago Unico
    DECLARE Origen_Nuevo	ChAR(1);			-- Origen del Credito: N (Nuevo)

	DECLARE Esta_Pagado		CHAR(1);			-- Estatus Pagado
	DECLARE Var_FechaSistema DATE;				-- Fecha del Sistema

	-- Asignacion de Constantes
	SET Cadena_Vacia    := '';              -- Cadena o String Vacio
	SET Fecha_Vacia     := '1900-01-01';    -- Fecha vacia
	SET Entero_Cero     := 0;               -- Entero en Cero
    SET Decimal_Cero	:= 0.00;			-- Decimal Cero
	SET Var_SI          := 'S';             -- Valor para Si
	SET Var_NO          := 'N';             -- Valor para Si
	SET Est_Vencido    := 'B';	            -- Estatus del Credito: Vencido
	SET Esta_Pagado		:= 'P';				-- Estatus Pagado
    SET	Est_Vigente		:= 'V';				-- Estatus Vigente
    SET Pago_Unico		:= 'U';				-- Pago Unico de Capital
    SET Origen_Nuevo	:= 'N';				-- Origen del Credito Anterior: Nuevo


	SELECT FechaSistema INTO Var_FechaSistema
		FROM PARAMETROSSIS;

     -- Se Obtiene el Tipo de Pago del Capital
		SET Tipo_PagCap := (SELECT FrecuenciaCap FROM CREDITOS WHERE CreditoID = Par_CreditoAnteri);

   -- Se obtiene el porcentaje Transcurrido del Plazo del Credito
	SET Var_PorcTrans := (SELECT IF(IFNULL(CP.Dias, Entero_Cero) > Entero_Cero, ((DATEDIFF(Var_FechaSistema,C.FechaInicio)*100)/CP.Dias), Entero_Cero)
		FROM CREDITOSPLAZOS CP
		INNER JOIN CREDITOS C
		ON CP.PlazoID = C.PlazoID
		WHERE CreditoID = Par_CreditoAnteri);

	-- Se obtiene el Total de Adeudo de Intereses
	SET Var_TotalInteres := (SELECT FNTOTALINTERESCREDITO(Par_CreditoAnteri));

	SET Var_TotalInteres := IFNULL(Var_TotalInteres, Decimal_Cero);
			-- Se obtiene el Monto Exigible del Capital del Credito
	SET Res_SaldoExigi 	 := (SELECT FUNCIONEXIGIBLE(Par_CreditoAnteri));


	 -- Se obtiene el monto de Capital Cubierto
    SET Var_MontoPag := (SELECT SUM(Capital)
										FROM AMORTICREDITO
										WHERE Estatus = Esta_Pagado
										AND CreditoID = Par_CreditoAnteri);

	SET Var_MontoPag := IFNULL(Var_MontoPag, Decimal_Cero);

				-- Se obtiene el porcentaje de Capital Cubierto
	SET Var_MontoPorc := (SELECT ROUND(((Var_MontoPag * 100)/MontoCredito),2)
									FROM CREDITOS
									WHERE CreditoID = Par_CreditoAnteri);
			-- Se obtiene el Origen del Credito
    SET Var_TipoCredito := (SELECT TipoCredito FROM CREDITOS WHERE CreditoID = Par_CreditoAnteri);
    -- Se valida si el Crédito a Renovar o Reestructurar esta vencido, su estatus es vencido
	IF(Par_EstatusCredAnt = Est_Vencido) THEN
		SET Par_EstatusCreacion := Est_Vencido;
	ELSE -- Si el Credito a Renovar o Reestructurar no es Vencido

        -- Si el tipo de Pago de Capital es no es Pago Unico
	IF(Tipo_PagCap = Pago_Unico) THEN
		SET Par_EstatusCreacion := Est_Vencido;
	ELSE -- Si el tipo de Pago de Capital es Pago Unico

            -- Si el porcentaje es menor al 80 %
	IF(Var_PorcTrans < 80.00) THEN
				/* Si los intereses devengados a la fecha de renovacion estan cubiertos y
					el Monto del Capital del Credito a la fecha de renovacion ha sido cubierto y
					el Credito original no ha sido renovado o reestructurado previamente.*/

		IF(Var_TotalInteres = Decimal_Cero AND Res_SaldoExigi= Decimal_Cero AND Var_TipoCredito = Origen_Nuevo) THEN
			-- Se cumple la condicion el Estatus del Credito sera vigente
			SET Par_EstatusCreacion := Est_Vigente;

		ELSE
			-- No se cumple la condicion, el estatus del Credito sera Vencido
			SET Par_EstatusCreacion := Est_Vencido;
		END IF;

	ELSE

		IF(Var_TotalInteres = Decimal_Cero AND Res_SaldoExigi= Decimal_Cero AND Var_MontoPorc>60) THEN
			-- Se cumple la condicion el Estatus del Credito sera vigente
			SET Par_EstatusCreacion := Est_Vigente;
		ELSE
			-- No se cumple la condicion, el estatus del Credito sera Vencido
			SET Par_EstatusCreacion := Est_Vencido;
		END IF;

	END IF;
END IF;
END IF;

	SET Par_NumErr			:= 000;
	SET Par_ErrMen			:= 'Valor Asignado Correctamente.';

     IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_EstatusCreacion,
        CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen 		AS ErrMen;
	END IF;

END TerminaStore$$