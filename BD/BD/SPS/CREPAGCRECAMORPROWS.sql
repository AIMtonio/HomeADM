-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREPAGCRECAMORPROWS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREPAGCRECAMORPROWS`;
DELIMITER $$


CREATE PROCEDURE `CREPAGCRECAMORPROWS`(
-- SP que simula cuotas de pagos crecientes de capital
	Par_Monto				DECIMAL(14,2),	-- Monto a prestar
	Par_Tasa				DECIMAL(14,2),	-- Tasa Anualizada
	Par_Frecu				INT,				-- Frecuencia del pago en Dias (si el pago es Periodo)
	Par_PagoCuota			CHAR(1),			-- Pago de la cuota (Semanal (S), Catorcenal(C) , Quincenal (Q), Mensual(M), P .- Periodo B.-Bimestral T.-Trimestral R.-TetraMestral E.-Semestral A.-Anual)
	Par_FechaInicio			DATE	,			-- fecha en que empiezan los pagos
	Par_NumeroCuotas		INT,				-- Numero de Cuotas que se simularan
	Par_ProdCredID			INT,				-- identificador de PRODUCTOSCREDITO para obtener dias de gracia y margen para pag iguales
	Par_ClienteID			INT,				-- identificador de CLIENTES para obtener el valor PagaIVA


	Par_ComAper				DECIMAL(14,2), 	-- Monto de la comision por apertura
	Par_Salida    			CHAR(1),			-- Indica si hay una salida o no
    INOUT	Par_NumErr 		INT,
    INOUT	Par_ErrMen  	VARCHAR(350),
    INOUT	Par_NumTran		BIGINT(20),		-- Numero de transaccion con el que se genero el calendario de pagos
    INOUT 	Par_Cuotas		INT,
    INOUT	Par_Cat			DECIMAL(14,4),	-- cat que corresponde con lo generado
    INOUT	Par_MontoCuo	DECIMAL(14,4),	-- corresponde con la cuota promedio a pagar
	INOUT	Par_FechaVen 	DATE,			-- corresponde con la fecha final que genere el cotizador

	Par_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
		)

TerminaStore: BEGIN
	-- DECLARACION DE CONSTANTES
	DECLARE Var_FinAni			CHAR(1); -- solo si el Pago es Mensual indica si es fin de mes (F) o por aniversario (A)
	DECLARE Var_DiaHabilSig		CHAR(1); -- Indica si toma el dia habil siguiente (S - si) o el anterior (N - no)
	DECLARE Var_AjustaFecAmo	CHAR(1); -- Indica si se ajusta a fecha de vencimiento  (S- Si) ultima amortizacion(N - no)
	DECLARE Var_AjusFecExiVen	CHAR(1); -- Indica si se ajusta la fecha  de vencimiento a fecha de exigibilidad  (S- si se ajusta N- no se ajusta)
	DECLARE Entero_Cero			INT;
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Decimal_Cero		DECIMAL(14,2);
	DECLARE SalidaSI			CHAR(1);

	-- DECLARACION DE VARIABLES
	DECLARE Var_Control			VARCHAR(100);		-- Control id
	#SEGUROS -------------------------------------------------------------------------------
	DECLARE Var_CobraSeguroCuota CHAR(1);			-- Cobra Seguro por cuota
	DECLARE Var_CobraIVASeguroCuota CHAR(1);		-- Cobra IVA seguro por cuota
	DECLARE Var_MontoSeguroCuota DECIMAL(12,2);		-- Cobra seguro por cuota el credito

	-- ASIGNACION DE CONSTANTES
	SET Entero_Cero			:= 0 ;
	SET Decimal_Cero		:= 0.00;
	SET Cadena_Vacia		:= '';
	SET Var_FinAni			:='F';
	SET Var_DiaHabilSig		:='S';
	SET Var_AjustaFecAmo	:='S';
	SET Var_AjusFecExiVen	:='N';
	SET SalidaSI			:= 'S';
    ManejoErrores:BEGIN     #bloque para manejar los posibles errores no controlados del codigo
        DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
            SET Par_NumErr    := 999;
            SET Par_ErrMen    := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
            'Disculpe las molestias que esto le ocasiona. Ref: SP-CREPAGCRECAMORPROWS');
            SET Var_Control := 'SQLEXCEPTION';
        END;
        SELECT CobraSeguroCuota, CobraIVASeguroCuota INTO Var_CobraSeguroCuota, Var_CobraIVASeguroCuota
            FROM PRODUCTOSCREDITO
                WHERE ProducCreditoID = Par_ProdCredID;

        # El monto a cobrar de la cuota solo nacera de la frecuencia de capital para este caso
        SET Var_MontoSeguroCuota := (SELECT Monto
										FROM ESQUEMASEGUROCUOTA AS Esq INNER JOIN
											CATFRECUENCIAS AS Cat ON Esq.Frecuencia=Cat.FrecuenciaID
											WHERE ProducCreditoID = Par_ProdCredID
											AND Frecuencia = Par_PagoCuota ORDER BY Dias ASC LIMIT 1);
		#SEGUROS
		SET Var_CobraSeguroCuota 	:= IFNULL(Var_CobraSeguroCuota, 'N');
		SET Var_CobraIVASeguroCuota := IFNULL(Var_CobraIVASeguroCuota, 'N');
		SET Var_MontoSeguroCuota 	:= IFNULL(Var_MontoSeguroCuota, Entero_Cero);

		CALL CREPAGCRECAMORPRO(
			Entero_Cero,
			Par_Monto,				Par_Tasa,		  			Par_Frecu, 	    		Par_PagoCuota,		Var_FinAni,
			Entero_Cero,			Par_FechaInicio,  			Par_NumeroCuotas,		Par_ProdCredID,		Par_ClienteID,
			Var_DiaHabilSig, 		Var_AjustaFecAmo, 			Var_AjustaFecAmo, 		Par_ComAper,		Decimal_Cero,
			Var_CobraSeguroCuota,	Var_CobraIVASeguroCuota, 	Var_MontoSeguroCuota,	Entero_Cero,	Par_Salida,
            Par_NumErr,		  		Par_ErrMen,       			Par_NumTran,	   		Par_Cuotas,	   		Par_Cat,
            Par_MontoCuo,     		Par_FechaVen,     			Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
            Aud_DireccionIP,  		Aud_ProgramaID,				Aud_Sucursal,	   		Aud_NumTransaccion);

			SET Par_NumErr := Entero_Cero;
			SET Par_ErrMen := CONCAT('Cuotas generadas Exitosamente.');
			SET Var_Control := 'simula';

	END ManejoErrores;

	 IF(Par_Salida = SalidaSI) THEN
		SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen 		AS ErrMen,
				Var_Control 	AS control,
				Aud_NumTransaccion 	AS consecutivo;
	END IF;

END TerminaStore$$