-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ASIGSALDOCLIENTEACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ASIGSALDOCLIENTEACT`;
DELIMITER $$

CREATE PROCEDURE `ASIGSALDOCLIENTEACT`(
-- =======================================================================================================
-- --------------------- SP QUE ASIGNA EL SALDO DESIGNADO AL CLIENTE --------------------------------------
-- DICHO SALDO CORRESPONDE A LA DIFERENCIA DEL MONTO DEL CREDITO CON EL MONTO DE LAS CARTAS DE LIQUIDACION
-- ========================================================================================================
	Par_CreditoID 				BIGINT(12), 	-- ID del Credito
    INOUT Par_MontoCli       	DECIMAL(12,4),	-- Monto Correspondiente al Cliente

	Par_Salida           		CHAR(1),		-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr     		INT(11),		-- Numero de Error
	INOUT Par_ErrMen     		VARCHAR(400),	-- Mensaje de Error
    /* Parametros de Auditoria */
	Par_EmpresaID				INT(11),        -- Parametros de Auditoria
	Aud_Usuario					INT(11),        -- Parametros de Auditoria
	Aud_FechaActual				DATETIME,       -- Parametros de Auditoria
	Aud_DireccionIP				VARCHAR(15),    -- Parametros de Auditoria
	Aud_ProgramaID				VARCHAR(50),    -- Parametros de Auditoria
	Aud_Sucursal				INT(11),        -- Parametros de Auditoria
	Aud_NumTransaccion			BIGINT(20)      -- Parametros de Auditoria
)
TerminaStore: BEGIN

    -- Declaracion de Constantes
    DECLARE	Var_Control         CHAR(25);           -- Var Control del Manejo de Errores
    DECLARE Var_SolCreditoID    BIGINT(11);         -- Var ID de Solicitud del Credito
    DECLARE MontoCred           DECIMAL(14,2);      -- Var de Monto de Desembolso del Credito.
    DECLARE Var_ForComApe	    CHAR(1);            -- Cobra Comision por Apertura
    DECLARE Var_MontoComAp		DECIMAL(12,4);      -- Var Monto de Comision por Apertura
	DECLARE Var_IVAComAp		DECIMAL(12,4);      -- Var Monto de IVA de Comision de Apertura.
    DECLARE Var_MonPagadoComAp	DECIMAL(12,4);      -- Var Monto Pagado de Comision por Apertura
    DECLARE Var_MontoFinalComAp DECIMAL(12,4);      -- Var Monto Final de Comision por Apertura
    DECLARE Var_ForCobSeg	    CHAR(1);            -- Var Cobra Seguro de Vida
    DECLARE Var_MontoSegVida    DECIMAL(12,4);      -- Var Monto Seguro de Vida
    DECLARE Var_MonPagadoSegV   DECIMAL(12,4);      -- Var Monto Pagado de Seguro de Vida
    DECLARE Var_MontoFinalSegV  DECIMAL(12,4);      -- Var Monto Final de Pagado de Seguro de Vida
    DECLARE Var_MontoCartas     DECIMAL(18,2);      -- Monto de las Cartas de Liquidacion
    DECLARE MontoCliente        DECIMAL(12,4);      -- Monto correspondiente al Cliente
    DECLARE Var_ProductoCreditoID	INT(11);        -- Producto del Credito
	DECLARE Var_MontoCartasInt 	DECIMAL(18,2);		-- Monto de las Cartas de Liquidacion Interna

    -- Declaracion de Constantes
    DECLARE	Cadena_Vacia		VARCHAR(1);         -- Cadena vacia
    DECLARE	Fecha_Vacia			DATE;               -- Fecha vacia
    DECLARE	Entero_Cero			INT(11);			-- Entero Cero
    DECLARE	SalidaSI        	CHAR(1);			-- Salida Si
    DECLARE	SalidaNO        	CHAR(1);            -- Salida No
    DECLARE ForComApDeduc      	CHAR(1);            -- Cobra Comisión por Deduccion
	DECLARE ForComApFinanc     	CHAR(1);            -- Cobra Comision por Financiamiento
    DECLARE ForCobDeduc			CHAR(1);            -- Cobro de Deduccion
	DECLARE ForCobFinanc		CHAR(1);            -- Cobro Financiamiento
    DECLARE Var_IVA				DECIMAL(12,2);		-- IVA
    DECLARE Con_CartaInter		CHAR(1);			-- Tipo de Cartas Internas
    DECLARE Decimal_Cero		DECIMAL;			-- Decimal en Cero

    -- Asignacion de Constantes
    SET Cadena_Vacia			:= '';
    SET Fecha_Vacia				:= '1900-01-01';
    SET Entero_Cero				:= 0;
    SET	SalidaSI        		:= 'S';
    SET	SalidaNO        		:= 'N';
    SET ForComApDeduc           := 'D';
	SET ForComApFinanc          := 'F';
    SET ForCobDeduc			    := 'D';
	SET ForCobFinanc		    := 'F';
    SET Var_IVA					:= 0.16;
	SET Con_CartaInter			:= 'I'; 				-- Tipo de Carta de Liquidacion Interna
	SET Decimal_Cero			:=0.00;

    SET Aud_FechaActual 		:= NOW();

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-ASIGSALDOCLIENTEACT');
			SET Var_Control:= 'sqlException' ;
		END;

	SELECT  SolicitudCreditoID,     Cre.MontoCredito,       Pro.ForCobroComAper,   Cre.MontoComApert, 		Cre.IVAComApertura,
            Cre.ForCobroSegVida,    Cre.MontoSeguroVida,    Cre.SeguroVidaPagado,  Cre.ComAperPagado,       Cre.ProductoCreditoID
    INTO    Var_SolCreditoID,       MontoCred,              Var_ForComApe,         Var_MontoComAp, 		Var_IVAComAp,
            Var_ForCobSeg,          Var_MontoSegVida,       Var_MonPagadoSegV,     Var_MonPagadoComAp,      Var_ProductoCreditoID
    FROM CREDITOS  Cre,
        PRODUCTOSCREDITO Pro
    WHERE Cre.CreditoID = Par_CreditoID
            AND Cre.ProductoCreditoID = Pro.ProducCreditoID;

    SET Var_MontoComAp      := IFNULL(Var_MontoComAp, Entero_Cero);
	SET Var_IVAComAp        := IFNULL(Var_IVAComAp, Entero_Cero);
	SET Var_MontoSegVida    := IFNULL(Var_MontoSegVida, Entero_Cero);
    SET Var_MonPagadoComAp	:= IFNULL(Var_MonPagadoComAp, Entero_Cero);
    SET Var_MonPagadoSegV	:= IFNULL(Var_MonPagadoSegV, Entero_Cero);

    SET Var_MontoCartas := (SELECT SUM(Monto) FROM ASIGCARTASLIQUIDACION WHERE SolicitudCreditoID = Var_SolCreditoID);
    SET Var_MontoCartas := IFNULL(Var_MontoCartas, Decimal_Cero);

	SELECT SUM(CDET.MontoLiquidar)
	INTO Var_MontoCartasInt
	FROM CONSOLIDACIONCARTALIQ AS LIQ
		INNER JOIN CONSOLIDACARTALIQDET AS LDET
			ON LIQ.ConsolidaCartaID	= LDET.ConsolidaCartaID
			AND LDET.TIPOCARTA 		= Con_CartaInter
		INNER JOIN CARTALIQUIDACION AS Cliq	ON LDET.CartaLiquidaID	= Cliq.CartaLiquidaID
		INNER JOIN CARTALIQUIDACIONDET AS CDET ON Cliq.CartaLiquidaID	= CDET.CartaLiquidaID
		WHERE	LIQ.SolicitudCreditoID	= Var_SolCreditoID;

	SET Var_MontoCartas := Var_MontoCartas + IFNULL(Var_MontoCartasInt,Decimal_Cero);

	IF(Var_MontoCartas > MontoCred) THEN
		SET Par_NumErr := 001;
		SET Par_ErrMen := 'El Monto de las Cartas de Liquidacion supera  al Monto de la Solicitud';
		SET Var_Control:= 'creditoID' ;
		LEAVE ManejoErrores;
	END IF;

    /* Si el tipo de cobro de comision por apertura es Por deduccion o Financiamiento*/
    IF((Var_ForComApe = ForComApDeduc) OR (Var_ForComApe = ForComApFinanc))THEN
        SET Var_MontoFinalComAp := Var_MonPagadoComAp + (Var_MonPagadoComAp * Var_IVA);
    END IF;

    /* Si el tipo de cobro de cobro del seguro de vida es Por deduccion o Financiamiento*/
    IF((Var_ForCobSeg = ForCobDeduc) OR (Var_ForCobSeg = ForCobFinanc))THEN
        SET Var_MontoFinalSegV := Var_MonPagadoSegV;
    END IF;

    SET Var_MontoFinalComAp := IFNULL(Var_MontoFinalComAp, Decimal_Cero);
	SET Var_MontoFinalSegV := IFNULL(Var_MontoFinalSegV, Decimal_Cero);

    SET MontoCliente := MontoCred - (Var_MontoCartas + Var_MontoFinalComAp + Var_MontoFinalSegV);
    SET MontoCliente := IFNULL(MontoCliente, Decimal_Cero);

    IF(MontoCliente < Decimal_Cero) THEN
		SET Par_NumErr := 002;
		SET Par_ErrMen := 'El Monto de las Cartas de Liquidacion supera  al Monto de la Solicitud';
		SET Var_Control:= 'creditoID' ;
		LEAVE ManejoErrores;
	END IF;

    UPDATE CREDITOS SET
        MontoClienteCartas = MontoCliente
    WHERE CreditoID = Par_CreditoID;

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := 'Monto Asignado al Cliente Correctamente';
	SET Var_Control:= 'creditoID' ;
    SET Par_MontoCli := MontoCliente;
END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS Control,
			Par_CreditoID AS Consecutivo;
END IF;

END TerminaStore$$