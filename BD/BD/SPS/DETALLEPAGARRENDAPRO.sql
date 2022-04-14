-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEPAGARRENDAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `DETALLEPAGARRENDAPRO`;DELIMITER $$

CREATE PROCEDURE `DETALLEPAGARRENDAPRO`(
	-- SP para el detalle de pago
	Par_ArrendaAmortiID		INT(4),				-- Numero de la amortizacion o la cuota
	Par_ArrendaID			BIGINT(12),			-- Llave principal del Arrendamiento
	Par_FechaPago			DATE,				-- Fecha del pago de la amortizacion
	Par_Transaccion			BIGINT(20),			-- Numero de transaccion
	Par_ClienteID			INT(11),			-- Numero del cliente del arrendamiento
	Par_MontoPago			DECIMAL(14,4),		-- Monto a Pagar
	Par_TipoMovArrendaID	INT(4),				-- Tipo de movimiento del arrendamiento

	Par_Salida 				CHAR(1),			-- Indica si el sp tendra salida
	INOUT Par_NumErr		INT(11),			-- Numero de salida que retorna el sp
	INOUT Par_ErrMen		VARCHAR(400),		-- Mensaje de salida

	Par_ModoPago			CHAR(1),			-- Forma de pago

	Aud_EmpresaID       	INT(11),			-- Id de la empresa
	Aud_Usuario         	INT(11),			-- Usuario
	Aud_FechaActual     	DATETIME,			-- Fecha actual
	Aud_DireccionIP     	VARCHAR(15),		-- Direccion IP
	Aud_ProgramaID      	VARCHAR(20),		-- Id del programa
	Aud_Sucursal        	INT(11),			-- Número de sucursal
	Aud_NumTransaccion  	BIGINT(20)			-- Número de transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Transaccion			BIGINT;			-- Numero de transaccion
	DECLARE Var_IVASucurs			DECIMAL(8, 4);	-- IVA de sucursal
	DECLARE Var_MontoCapVig			DECIMAL(14,4);	-- Monto del capital vigente
	DECLARE Var_MontoCapAtr			DECIMAL(14,4);	-- Monto del capital atrasado
	DECLARE Var_MontoCapVen			DECIMAL(14,4);	-- Monto del capital vencido
	DECLARE Var_MontoIntVig			DECIMAL(14,4);	-- Interes vigente
	DECLARE Var_MontoIntAtr			DECIMAL(14,4);	-- Interes atrasado
	DECLARE Var_MontoIntVen			DECIMAL(14,4);	-- Interes vencido
	DECLARE Var_MontoIVAInteres		DECIMAL(14,4);	-- IVA del Interes
	DECLARE Var_MontoIVACapital		DECIMAL(14,4);	-- IVA del capital
	DECLARE Var_MontoMoratorios		DECIMAL(14,4);	-- Monto moratorio
	DECLARE Var_MontoIVAMora		DECIMAL(14,4);	-- IVA de la mora
	DECLARE Var_MontoComision		DECIMAL(14,4);	-- Monto de Otras comisiones
	DECLARE Var_MontoIVAComi		DECIMAL(14,4);	-- IVA de Otras comisiones
	DECLARE Var_MontoComFaltPago	DECIMAL(14,4);	-- Monto por falta de pago
	DECLARE Var_MonIVAComFalPag		DECIMAL(14,4);	-- IVA por falta de pago
	DECLARE Var_MontoSeguro			DECIMAL(14,4);	-- Monto del seguro
	DECLARE Var_MontoIVASeguro		DECIMAL(14,4);	-- IVA del seguro
	DECLARE Var_MonSegVida			DECIMAL(14,4);	-- Monto del seguro de vida
	DECLARE Var_MonIVASegVida		DECIMAL(14,4);	-- IVA del seguro de vida
	DECLARE	Var_CapitalRenta		DECIMAL(14,4);	-- Capital de la renta
	DECLARE	Var_InteresRenta		DECIMAL(14,4);	-- Interes de la renta
	DECLARE	Var_Renta				DECIMAL(14,4);	-- IVA de la renta
	DECLARE	Var_IVARenta			DECIMAL(14,4);	-- Renta
	DECLARE Var_SucCliente			INT(11);		-- Numero de sucursal del cliente

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia			CHAR(1);		-- Cadena vacia
	DECLARE	Fecha_Vacia				DATE;			-- Fecha vacia
	DECLARE	Entero_Cero				INT(11);		-- Entero cero
	DECLARE	Decimal_Cero			DECIMAL(12,2);	-- Decimal cero
	DECLARE	Salida_SI				CHAR(1);		-- Salida si
	DECLARE Mov_CapVigente  		INT(11);		-- Monto del capital vigente segun TIPOSMOVSARRENDA
	DECLARE Mov_CapAtrasado 		INT(11);		-- Monto del capital atrasado segun TIPOSMOVSARRENDA
	DECLARE Mov_CapVencido  		INT(11);		-- Monto del capital vencido segun TIPOSMOVSARRENDA
	DECLARE Mov_IntVigente			INT(11);		-- Interes vigente segun TIPOSMOVSARRENDA
	DECLARE Mov_IntAtrasado			INT(11);		-- Interes atrasado segun TIPOSMOVSARRENDA
	DECLARE Mov_IntVencido			INT(11);		-- Interes vencido segun TIPOSMOVSARRENDA
	DECLARE Mov_Moratorio			INT(11);		-- Monto moratorio segun TIPOSMOVSARRENDA
	DECLARE Mov_IVACapital			INT(11);		-- IVA del capital segun TIPOSMOVSARRENDA
	DECLARE Mov_IVAInteres			INT(11);		-- IVA del Interes segun TIPOSMOVSARRENDA
	DECLARE Mov_IVAIntMora			INT(11);		-- IVA de la mora segun TIPOSMOVSARRENDA
	DECLARE Mov_IVAComFaPag			INT(11);		-- IVA por falta de pago segun TIPOSMOVSARRENDA
	DECLARE Mov_IVASeguroVida		INT(11);		-- IVA del seguro de vida segun TIPOSMOVSARRENDA
	DECLARE Mov_IVASeguroInmob		INT(11);		-- IVA del seguro segun TIPOSMOVSARRENDA
	DECLARE Mov_IVAOtrasComis		INT(11);		-- IVA de Otras comisiones segun TIPOSMOVSARRENDA
	DECLARE Mov_ComFalPag			INT(11);		-- Monto por falta de pago segun TIPOSMOVSARRENDA
	DECLARE Mov_OtrasComis			INT(11);		-- Monto de Otras comisiones segun TIPOSMOVSARRENDA
	DECLARE Mov_SegInmobiliario		INT(11);		-- Monto del seguro segun TIPOSMOVSARRENDA
	DECLARE Mov_SegVida				INT(11);		-- Monto del seguro de vida segun TIPOSMOVSARRENDA
	DECLARE	Mov_CapitalRenta		INT(11);		-- Capital de la renta
	DECLARE	Mov_InteresRenta		INT(11);		-- Interes de la renta
	DECLARE	Mov_Renta				INT(11);		-- Renta
	DECLARE	Mov_IVARenta			INT(11);		-- IVA de la renta

	-- Asignacion de Constantes
	SET Cadena_Vacia		:= '';					-- Valor de cadena vacia
	SET Fecha_Vacia			:= '1900-01-01';		-- Valor para la Fecha vacia
	SET Entero_Cero			:= 0;					-- Valor del entero cero
	SET Decimal_Cero		:= 0.00;				-- Valor del decimal cero
	SET Salida_SI			:= 'S';					-- Valor salida si

	SET Mov_CapVigente		:= 1;					-- Valor del capital vigente
	SET Mov_CapAtrasado		:= 2;					-- Valor del capital atrasado
	SET Mov_CapVencido		:= 3;					-- Valor del capital vencido
	SET Mov_IntVigente		:= 10;					-- Valor del Interes vigente
	SET Mov_IntAtrasado	 	:= 11;					-- Valor del Interes atrasado
	SET Mov_IntVencido	  	:= 12;					-- Valor del Interes vencido
	SET Mov_Moratorio 	  	:= 15;					-- Valor del moratorio
	SET Mov_IVACapital	  	:= 19;					-- Valor del IVA del capital
	SET Mov_IVAInteres	  	:= 20;					-- Valor del IVA del Interes
	SET Mov_IVAIntMora  	:= 21;					-- Valor del IVA moratorio
	SET Mov_IVAComFaPag 	:= 22;					-- Valor del IVA por falta de pago
	SET Mov_IVASeguroVida	:= 23;					-- Valor del IVA del seguro de vida
	SET Mov_IVASeguroInmob	:= 24;					-- Valor del IVA del seguro
	SET Mov_IVAOtrasComis	:= 25;					-- Valor del IVA de otras comisiones
	SET Mov_ComFalPag		:= 40;					-- Valor de comision por falta de pago
	SET Mov_OtrasComis   	:= 41;					-- Valor de otras comisiones
	SET Mov_SegInmobiliario	:= 49;					-- Valor del seguro
	SET Mov_SegVida			:= 50;					-- Valor del seguro de vida


	-- Inicializaciones
	SET	Par_NumErr	:= Entero_Cero;
	SET	Par_ErrMen	:= Cadena_Vacia;

	SET	Aud_FechaActual	:= NOW();

	SELECT	cli.SucursalOrigen
		INTO	Var_SucCliente
		FROM	ARRENDAMIENTOS	arrenda
		INNER JOIN CLIENTES	cli
		ON		arrenda.ClienteID	= cli.ClienteID
		WHERE	arrenda.ArrendaID	= Par_ArrendaID;

	SELECT		IVA
		INTO	Var_IVASucurs
		FROM	SUCURSALES
		WHERE	SucursalID	= Var_SucCliente;

	SET Var_IVASucurs	:= IFNULL(Var_IVASucurs, Decimal_Cero);

	BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET	Par_NumErr := 999;
				SET	Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-DETALLEPAGARRENDAPRO');
			END;

			SET	Var_MontoCapVig			:= Decimal_Cero;
			SET	Var_MontoCapAtr			:= Decimal_Cero;
			SET	Var_MontoCapVen			:= Decimal_Cero;
			SET	Var_MontoIntVig			:= Decimal_Cero;
			SET	Var_MontoIntAtr			:= Decimal_Cero;
			SET	Var_MontoIntVen			:= Decimal_Cero;
			SET	Var_MontoIVAInteres		:= Decimal_Cero;
			SET	Var_MontoIVACapital		:= Decimal_Cero;
			SET	Var_MontoMoratorios		:= Decimal_Cero;
			SET	Var_MontoIVAMora		:= Decimal_Cero;
			SET	Var_MontoComision		:= Decimal_Cero;
			SET	Var_MontoIVAComi		:= Decimal_Cero;
			SET	Var_MontoComFaltPago	:= Decimal_Cero;
			SET	Var_MonIVAComFalPag		:= Decimal_Cero;
			SET	Var_MontoSeguro			:= Decimal_Cero;
			SET	Var_MontoIVASeguro		:= Decimal_Cero;
			SET	Var_MonSegVida			:= Decimal_Cero;
			SET	Var_MonIVASegVida		:= Decimal_Cero;

			IF (Par_TipoMovArrendaID = Mov_CapVigente) THEN
				SET	Var_MontoCapVig	:= Par_MontoPago;

			ELSEIF (Par_TipoMovArrendaID = Mov_CapAtrasado) THEN
				SET	Var_MontoCapAtr	:= Par_MontoPago;

			ELSEIF (Par_TipoMovArrendaID = Mov_CapVencido) THEN
				SET	Var_MontoCapVen	:= Par_MontoPago;

			ELSEIF (Par_TipoMovArrendaID = Mov_IntVigente) THEN
				SET	Var_MontoIntVig := Par_MontoPago;

			ELSEIF (Par_TipoMovArrendaID = Mov_IntAtrasado) THEN
				SET	Var_MontoIntAtr	:= Par_MontoPago;

			ELSEIF (Par_TipoMovArrendaID = Mov_IntVencido) THEN
				SET	Var_MontoIntVen	:= Par_MontoPago;

			ELSEIF (Par_TipoMovArrendaID = Mov_IVAInteres) THEN
				SET	Var_MontoIVAInteres	:= Par_MontoPago;

			ELSEIF (Par_TipoMovArrendaID = Mov_IVACapital) THEN
				SET	Var_MontoIVACapital	:= Par_MontoPago;

			ELSEIF (Par_TipoMovArrendaID = Mov_Moratorio) THEN
				SET	Var_MontoMoratorios	:= Par_MontoPago;

			ELSEIF (Par_TipoMovArrendaID = Mov_IVAIntMora) THEN
				SET	Var_MontoIVAMora	:= Par_MontoPago;

			ELSEIF(Par_TipoMovArrendaID = Mov_OtrasComis) THEN
				SET	Var_MontoComision	:= Par_MontoPago;

			ELSEIF(Par_TipoMovArrendaID = Mov_IVAOtrasComis) THEN
				SET	Var_MontoIVAComi	:= Par_MontoPago;

			ELSEIF(Par_TipoMovArrendaID = Mov_ComFalPag) THEN
				SET	Var_MontoComFaltPago	:= Par_MontoPago;

			ELSEIF(Par_TipoMovArrendaID = Mov_IVAComFaPag) THEN
				SET	Var_MonIVAComFalPag	:= Par_MontoPago;

			ELSEIF(Par_TipoMovArrendaID = Mov_SegInmobiliario) THEN
				SET	Var_MontoSeguro	:= Par_MontoPago;

			ELSEIF(Par_TipoMovArrendaID = Mov_IVASeguroInmob) THEN
				SET	Var_MontoIVASeguro	:= Par_MontoPago;

			ELSEIF(Par_TipoMovArrendaID = Mov_SegVida) THEN
				SET	Var_MonSegVida	:= Par_MontoPago;

			ELSEIF(Par_TipoMovArrendaID = Mov_IVASeguroVida) THEN
				SET	Var_MonIVASegVida	:= Par_MontoPago;
			END IF;

			SET	Var_CapitalRenta	:= Var_MontoCapVig + Var_MontoCapAtr + Var_MontoCapVen;
			SET	Var_InteresRenta	:= Var_MontoIntVig + Var_MontoIntAtr + Var_MontoIntVen;
			SET	Var_Renta			:= Var_CapitalRenta + Var_InteresRenta;
			SET	Var_IVARenta		:= ROUND((Var_Renta *  Var_IVASucurs), 4);

			SELECT	Transaccion
				INTO	Var_Transaccion
				FROM	DETALLEPAGARRENDA
				WHERE	ArrendaAmortiID	= Par_ArrendaAmortiID
				  AND	ArrendaID		= Par_ArrendaID
				  AND	FechaPago		= Par_FechaPago
				  AND	Transaccion		= Par_Transaccion;

			SET	Var_Transaccion	= IFNULL(Var_Transaccion, Entero_Cero);

			IF	(Var_Transaccion = Entero_Cero) THEN

				INSERT	INTO	DETALLEPAGARRENDA(
					ArrendaAmortiID,		ArrendaID,				FechaPago,				Transaccion,			ClienteID,
					MontoTotPago,			CapitalRenta,			InteresRenta,			Renta,					IVARenta,
					MontoCapVig,			MontoCapAtr,			MontoCapVen,			MontoIntVig,			MontoIntAtr,
					MontoIntVen,			MontoIVAInteres,		MontoIVACapital,		MontoMoratorios,		MontoIVAMora,
					MontoComision,			MontoIVAComi,			MontoComFaltPago,		MontoIVAComFalPag,		MontoSeguro,
					MontoIVASeguro,			MontoSeguroVida,		MontoIVASeguroVida,		FormaPago,				EmpresaID,
					Usuario,				FechaActual,			DireccionIP,			ProgramaID,				Sucursal,
					NumTransaccion)
				VALUES(
					Par_ArrendaAmortiID,	Par_ArrendaID,			Par_FechaPago,			Par_Transaccion,		Par_ClienteID,
					Par_MontoPago,			Var_CapitalRenta,		Var_InteresRenta,		Var_Renta,				Var_IVARenta,
					Var_MontoCapVig,		Var_MontoCapAtr,		Var_MontoCapVen,		Var_MontoIntVig,		Var_MontoIntAtr,
					Var_MontoIntVen,		Var_MontoIVAInteres,	Var_MontoIVACapital,	Var_MontoMoratorios,	Var_MontoIVAMora,
					Var_MontoComision,		Var_MontoIVAComi,		Var_MontoComFaltPago,	Var_MonIVAComFalPag,	Var_MontoSeguro,
					Var_MontoIVASeguro,		Var_MonSegVida,			Var_MonIVASegVida,		Par_ModoPago,			Aud_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
					Aud_NumTransaccion);
			ELSE
				UPDATE DETALLEPAGARRENDA SET
					MontoTotPago		= MontoTotPago + Par_MontoPago,
					CapitalRenta		= CapitalRenta + Var_CapitalRenta,
					InteresRenta		= InteresRenta + Var_InteresRenta,
					Renta				= Renta + Var_Renta,
					IVARenta			= IVARenta + Var_IVARenta,
					MontoCapVig			= MontoCapVig + Var_MontoCapVig,
					MontoCapAtr			= MontoCapAtr + Var_MontoCapAtr,
					MontoCapVen			= MontoCapVen + Var_MontoCapVen,
					MontoIntVig			= MontoIntVig + Var_MontoIntVig,
					MontoIntAtr			= MontoIntAtr + Var_MontoIntAtr,
					MontoIntVen			= MontoIntVen + Var_MontoIntVen,
					MontoMoratorios		= MontoMoratorios + Var_MontoMoratorios,
					MontoIVAInteres		= MontoIVAInteres + Var_MontoIVAInteres,
					MontoIVACapital		= MontoIVACapital + Var_MontoIVACapital,
					MontoIVAMora		= MontoIVAMora + Var_MontoIVAMora,
					MontoComision		= MontoComision + Var_MontoComision,
					MontoIVAComi		= MontoIVAComi + Var_MontoIVAComi,
					MontoComFaltPago	= MontoComFaltPago + Var_MontoComFaltPago,
					MontoIVAComFalPag	= MontoIVAComFalPag + Var_MonIVAComFalPag,
					MontoSeguro			= MontoSeguro + Var_MontoSeguro,
					MontoIVASeguro		= MontoIVASeguro + Var_MontoIVASeguro,
					MontoSeguroVida		= MontoSeguroVida + Var_MonSegVida,
					MontoIVASeguroVida	= MontoIVASeguroVida + Var_MonIVASegVida,

					EmpresaID			= Aud_EmpresaID,
					Usuario				= Aud_Usuario,
					FechaActual			= Aud_FechaActual,
					DireccionIP			= Aud_DireccionIP,
					ProgramaID			= Aud_ProgramaID,
					Sucursal			= Aud_Sucursal,
					NumTransaccion		= Aud_NumTransaccion

					WHERE	ArrendaAmortiID	= Par_ArrendaAmortiID
					  AND	ArrendaID		= Par_ArrendaID
					  AND	FechaPago		= Par_FechaPago
					  AND	Transaccion		= Par_Transaccion;
			END IF;

	END;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  CONVERT(Par_NumErr, CHAR(10)) AS NumErr,
				Par_ErrMen AS ErrMen;
	END IF;

END TerminaStore$$