-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEPAGCRECONTPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `DETALLEPAGCRECONTPRO`;DELIMITER $$

CREATE PROCEDURE `DETALLEPAGCRECONTPRO`(
    Par_AmortizacionID  	INT(4),
    Par_CreditoID       	BIGINT(12),
    Par_FechaPago       	DATE,
    Par_Transaccion     	BIGINT(20),
    Par_ClienteID       	INT(11),
    Par_MontoPago       	DECIMAL(14,4),
    Par_TipoMovCreID    	INT(4),

	Par_Salida 				CHAR(1),
	OUT	Par_NumErr			INT(11),
	OUT	Par_ErrMen			VARCHAR(400),

    Par_ModoPago        	CHAR(1),
    Aud_EmpresaID       	INT(11),
    Aud_Usuario         	INT(11),
    Aud_FechaActual     	DATETIME,
    Aud_DireccionIP     	VARCHAR(15),
    Aud_ProgramaID      	VARCHAR(20),
    Aud_Sucursal        	INT(11),
    Aud_NumTransaccion  	BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Transaccion 	BIGINT;
	DECLARE Var_MontoCapOrd     DECIMAL(12,2);
	DECLARE Var_MontoCapAtr     DECIMAL(12,2);
	DECLARE Var_MontoCapVen     DECIMAL(12,2);
	DECLARE Var_MontoIntOrd     DECIMAL(14,4);
	DECLARE Var_MontoIntAtr     DECIMAL(14,4);
	DECLARE Var_MontoIntVen     DECIMAL(14,4);
	DECLARE Var_MontoIntMora    DECIMAL(12,2);
	DECLARE Var_MontoIVA        DECIMAL(12,2);
	DECLARE Var_MontoComision	DECIMAL(12,2);
	DECLARE Var_MontoGasAdmon   DECIMAL(12,2);
	-- COMISION ANUALIDAD
	DECLARE Var_MontoSeguroCuota 		DECIMAL(14,2);
	DECLARE Var_MontoIVASeguroCuota		DECIMAL(14,2);
	-- COMISION ANUALIDAD
	DECLARE Var_MontoComAnual 			DECIMAL(14,2);
	DECLARE Var_MontoComAnualIVA		DECIMAL(14,2);

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia    	CHAR(1);
	DECLARE Fecha_Vacia     	DATE;
	DECLARE Entero_Cero     	INT;
	DECLARE Decimal_Cero    	DECIMAL(12,2);
	DECLARE Salida_SI       	CHAR(1);
	DECLARE Mov_CapOrd      	INT;
	DECLARE Mov_CapAtr      	INT;
	DECLARE Mov_CapVen      	INT;
	DECLARE Mov_CapVNE      	INT;
	DECLARE Mov_IntOrd      	INT;
	DECLARE Mov_IntAtr      	INT;
	DECLARE Mov_IntVen      	INT;
	DECLARE Mov_IntPro      	INT;
	DECLARE Mov_IntCalNoCon 	INT;
	DECLARE Mov_IntMor      	INT;
	DECLARE Mov_IVAInt      	INT;
	DECLARE Mov_IVAMor      	INT;
	DECLARE Mov_IVAFalPag   	INT;
	DECLARE Mov_IVAComApe   	INT;
	DECLARE Mov_ComFalPag   	INT;
	DECLARE Mov_ComApeCre   	INT;
	DECLARE Mov_ComLiqAnt   	INT;
	DECLARE Mov_IVAComLiqAnt    INT;
	DECLARE Mov_IntMoratoVen	INT;
	DECLARE Mov_IntMoraCarVen	INT;
	DECLARE Mov_SeguroCuota	    INT;
	DECLARE Mov_IVASegCuota		INT;
	#COMISION ANUALIDAD
	DECLARE Mov_ComAnual		INT;
	DECLARE Mov_ComAnualIVA		INT;
	-- Asignacion de Constantes
	SET Cadena_Vacia    	:= '';
	SET Fecha_Vacia     	:= '1900-01-01';
	SET Entero_Cero     	:= 0;
	SET Decimal_Cero    	:= 0.00;
	SET Salida_SI       	:= 'S';

	SET Mov_CapOrd      	:= 1;
	SET Mov_CapAtr      	:= 2;
	SET Mov_CapVen      	:= 3;
	SET Mov_CapVNE      	:= 4;
	SET Mov_IntOrd      	:= 10;
	SET Mov_IntAtr      	:= 11;
	SET Mov_IntVen      	:= 12;
	SET Mov_IntCalNoCon 	:= 13;
	SET Mov_IntPro      	:= 14;
	SET Mov_IntMor      	:= 15;
	SET Mov_IVAInt      	:= 20;
	SET Mov_IVAMor      	:= 21;
	SET Mov_IVAFalPag   	:= 22;
	SET Mov_IVAComApe   	:= 23;
	SET Mov_ComFalPag   	:= 40;
	SET Mov_ComApeCre   	:= 41;
	SET Mov_ComLiqAnt       := 42;          -- Comision por Administracion: Liquidacion Anticipada
	SET Mov_IVAComLiqAnt    := 24;          -- IVA Comision por Administracion: Liquidacion Anticipada
	SET Mov_IntMoratoVen	:= 16;			-- Tipo de Movimiento: Interes Moratorio Vencido
	SET Mov_IntMoraCarVen	:= 17;          -- Tipo de Movimiento: Interes Moratorio de Cartera Vencida
	#SEGURO
	SET Mov_SeguroCuota 	:= 50;			-- Tipo de Movimiento TIPOSMOVSCRE: Seguro por Cuota
	SET Mov_IVASegCuota		:= 25; 			-- Tipo de Movimiento TIPOSMOVSCRE: IVA Seguro por Cuota
	#COMISION ANUALIDAD
	SET Mov_ComAnual		:= 51;				-- TIPOSMOVSCRE: 51 Comision por Anualidad
	SET Mov_ComAnualIVA		:= 52;				-- TIPOSMOVSCRE: 52 IVA Comision por Anualida
	SET Aud_FechaActual 	:= NOW();

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
											'esto le ocasiona. Ref: SP-DETALLEPAGCRECONTPRO');
		END;

        SET Var_MontoCapOrd     := Decimal_Cero;
        SET Var_MontoCapAtr     := Decimal_Cero;
        SET Var_MontoCapVen     := Decimal_Cero;
        SET Var_MontoIntOrd     := Decimal_Cero;
        SET Var_MontoIntAtr     := Decimal_Cero;
        SET Var_MontoIntVen     := Decimal_Cero;
        SET Var_MontoIntMora    := Decimal_Cero;
        SET Var_MontoIVA        := Decimal_Cero;
        SET Var_MontoComision   := Decimal_Cero;
        SET Var_MontoGasAdmon   := Decimal_Cero;
        SET Var_MontoSeguroCuota := Decimal_Cero;
        SET Var_MontoIVASeguroCuota := Decimal_Cero;
        /*COMISION ANUAL*/
        SET Var_MontoComAnual 		:= Decimal_Cero;
        SET Var_MontoComAnualIVA	:= Decimal_Cero;

        IF (Par_TipoMovCreID = Mov_IntOrd OR
            Par_TipoMovCreID = Mov_IntCalNoCon OR
            Par_TipoMovCreID = Mov_IntPro) THEN
            SET Var_MontoIntOrd	:= Par_MontoPago;

        ELSEIF (Par_TipoMovCreID = Mov_CapOrd OR
                Par_TipoMovCreID = Mov_CapVNE) THEN
            SET Var_MontoCapOrd	:= Par_MontoPago;

        ELSEIF (Par_TipoMovCreID = Mov_CapAtr) THEN
            SET Var_MontoCapAtr	:= Par_MontoPago;

        ELSEIF (Par_TipoMovCreID = Mov_CapVen) THEN
            SET Var_MontoCapVen := Par_MontoPago;

        ELSEIF (Par_TipoMovCreID = Mov_IntAtr) THEN
            SET Var_MontoIntAtr	:= Par_MontoPago;

        ELSEIF (Par_TipoMovCreID = Mov_IntVen) THEN
            SET Var_MontoIntVen	:= Par_MontoPago;

        ELSEIF (Par_TipoMovCreID = Mov_IntMor OR
				Par_TipoMovCreID = Mov_IntMoratoVen OR
				Par_TipoMovCreID = Mov_IntMoraCarVen ) THEN

            SET Var_MontoIntMora    := Par_MontoPago;

        ELSEIF (Par_TipoMovCreID = Mov_IVAInt OR
                Par_TipoMovCreID = Mov_IVAMor OR
                Par_TipoMovCreID = Mov_IVAComApe OR
                Par_TipoMovCreID = Mov_IVAFalPag OR
                Par_TipoMovCreID = Mov_IVAComLiqAnt ) THEN
            SET Var_MontoIVA    := Par_MontoPago;

        ELSEIF (Par_TipoMovCreID = Mov_ComFalPag OR Par_TipoMovCreID = Mov_ComApeCre) THEN
            SET Var_MontoComision	:= Par_MontoPago;

        ELSEIF (Par_TipoMovCreID = Mov_ComLiqAnt) THEN
            SET Var_MontoGasAdmon	:= Par_MontoPago;
        ELSEIF(Par_TipoMovCreID = Mov_SeguroCuota) THEN
            SET Var_MontoSeguroCuota := Par_MontoPago;
		ELSEIF(Par_TipoMovCreID = Mov_IVASegCuota) THEN
            SET Var_MontoIVASeguroCuota := Par_MontoPago;
        ELSEIF(Par_TipoMovCreID = Mov_ComAnual) THEN
            SET Var_MontoComAnual := Par_MontoPago;
        ELSEIF(Par_TipoMovCreID = Mov_ComAnualIVA) THEN
            SET Var_MontoComAnualIVA := Par_MontoPago;
        END IF;

        SELECT  Transaccion INTO Var_Transaccion
            FROM DETALLEPAGCRECONT
            WHERE AmortizacionID    = Par_AmortizacionID
              AND CreditoID         = Par_CreditoID
              AND FechaPago         = Par_FechaPago
              AND Transaccion       = Par_Transaccion;

        SET Var_Transaccion := IFNULL(Var_Transaccion, Entero_Cero);

        IF (Var_Transaccion = Entero_Cero) THEN
            INSERT INTO DETALLEPAGCRECONT(
                AmortizacionID,     CreditoID,          FechaPago,          	Transaccion,        	ClienteID,
                MontoTotPago,       MontoCapOrd,        MontoCapAtr,        	MontoCapVen,        	MontoIntOrd,
                MontoIntAtr,        MontoIntVen,        MontoIntMora,       	MontoIVA,           	MontoComision,
                MontoGastoAdmon,    FormaPago,          MontoSeguroCuota,   	MontoIVASeguroCuota,	MontoComAnual,
                MontoComAnualIVA,   EmpresaID,          Usuario,            	FechaActual,			DireccionIP,
                ProgramaID,         Sucursal,           NumTransaccion)
			VALUES(

                Par_AmortizacionID, Par_CreditoID,      Par_FechaPago,      	Par_Transaccion,    		Par_ClienteID,
                Par_MontoPago,      Var_MontoCapOrd,    Var_MontoCapAtr,    	Var_MontoCapVen,    		Var_MontoIntOrd,
                Var_MontoIntAtr,    Var_MontoIntVen,    Var_MontoIntMora,   	Var_MontoIVA,       		Var_MontoComision,
                Var_MontoGasAdmon,  Par_ModoPago,       Var_MontoSeguroCuota, 	Var_MontoIVASeguroCuota,	Var_MontoComAnual,
                Var_MontoComAnualIVA, Aud_EmpresaID,    Aud_Usuario,        	Aud_FechaActual,			Aud_DireccionIP,
                Aud_ProgramaID,     	Aud_Sucursal,	Aud_NumTransaccion);
        ELSE
            UPDATE DETALLEPAGCRECONT SET
                MontoTotPago    	= MontoTotPago + Par_MontoPago,
                MontoCapOrd     	= MontoCapOrd + Var_MontoCapOrd,
                MontoCapAtr     	= MontoCapAtr + Var_MontoCapAtr,
                MontoCapVen     	= MontoCapVen + Var_MontoCapVen,
                MontoIntOrd     	= MontoIntOrd + Var_MontoIntOrd,
                MontoIntAtr     	= MontoIntAtr + Var_MontoIntAtr,
                MontoIntVen     	= MontoIntVen + Var_MontoIntVen,
                MontoIntMora   	 	= MontoIntMora + Var_MontoIntMora,
                MontoIVA        	= MontoIVA + Var_MontoIVA,
                MontoComision   	= MontoComision + Var_MontoComision,
                MontoGastoAdmon 	= MontoGastoAdmon + Var_MontoGasAdmon,
                MontoSeguroCuota 	= MontoSeguroCuota + Var_MontoSeguroCuota,
                MontoIVASeguroCuota = MontoIVASeguroCuota + Var_MontoIVASeguroCuota,
                MontoComAnual 		= MontoComAnual + Var_MontoComAnual,
                MontoComAnualIVA 	= MontoComAnualIVA + Var_MontoComAnualIVA,

                EmpresaID       	= Aud_EmpresaID,
                Usuario         	= Aud_Usuario,
                FechaActual     	= Aud_FechaActual,
                DireccionIP     	= Aud_DireccionIP,
                ProgramaID      	= Aud_ProgramaID,
                Sucursal       	 	= Aud_Sucursal,
                NumTransaccion  	= Aud_NumTransaccion

			WHERE AmortizacionID    = Par_AmortizacionID
			  AND CreditoID         = Par_CreditoID
			  AND FechaPago         = Par_FechaPago
			  AND Transaccion       = Par_Transaccion;
        END IF;

  		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= CONCAT('Movimiento de Credito Agregado Exitosamente.');

END ManejoErrores;

 IF (Par_Salida = Salida_SI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(10)) AS NumErr,
            Par_ErrMen AS ErrMen;
END IF;

END TerminaStore$$