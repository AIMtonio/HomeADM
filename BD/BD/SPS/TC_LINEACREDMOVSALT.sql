-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_LINEACREDMOVSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TC_LINEACREDMOVSALT`;

DELIMITER $$
CREATE PROCEDURE `TC_LINEACREDMOVSALT`(
	-- ---------------------------------------------------------------------------------
	-- SP para dar de alta los movimientos de la linea de creditos
	-- ---------------------------------------------------------------------------------
	Par_LineaTarCredID      BIGINT(12),         -- Linea de credito
	Par_TarjetaCredID       VARCHAR(16),        -- Numero de tarjeta
	Par_NumAutorizacion     BIGINT,             -- Numero de Autorizacion
	Par_Transaccion         BIGINT(20),         -- Transaccion
	Par_FechaOperacion      DATE,               -- Fecha de Operacion
	Par_FechaAplicacion     DATE,               -- Fecha de Aplicacion

	Par_TipoMovLinID        INT(4),             -- Tipo de movimiento de linea
	Par_NatMovimiento       CHAR(1),            -- Naturaleza
	Par_MonedaID            INT(11),            -- Codigo de moneda
	Par_Cantidad            DECIMAL(14,4),      -- Cantidad - Monto operacion
	Par_Descripcion         VARCHAR(100),       -- Descripcion

	Par_Referencia          VARCHAR(50),        -- Referencia del movimiento
	Par_Poliza              BIGINT(20),         -- Numero de poliza
	Par_Salida              CHAR(1),            -- Salida
OUT Par_NumErr              INT(11),            -- Salida
OUT Par_ErrMen              VARCHAR(400),       -- Salida
OUT Par_Consecutivo         BIGINT,             -- Salida

	Par_EmpresaID           INT(11),            -- Auditoria
	Aud_Usuario             INT(11),            -- Auditoria
	Aud_FechaActual         DATETIME,           -- Auditoria
	Aud_DireccionIP         VARCHAR(15),        -- Auditoria

	Aud_ProgramaID          VARCHAR(50),        -- Auditoria
	Aud_Sucursal            INT(11),            -- Auditoria
	Aud_NumTransaccion      BIGINT(20)          -- Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Mov_Cantidad        DECIMAL(14,4);
	DECLARE Var_CreStatus       CHAR(1);
	DECLARE Var_Control         VARCHAR(50);

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia        CHAR(1);
	DECLARE Fecha_Vacia         DATE;
	DECLARE Entero_Cero         INT;
	DECLARE Float_Cero          FLOAT;
	DECLARE EstatusActivo       CHAR(1);
	DECLARE Nat_Cargo           CHAR(1);
	DECLARE Nat_Abono           CHAR(1);
	DECLARE Mov_CapOrd          INT;
	DECLARE Mov_CapAtr          INT;
	DECLARE Mov_CapVen          INT;
	DECLARE Mov_CapVNE          INT;
	DECLARE Mov_IntOrd          INT;
	DECLARE Mov_IntAtr          INT;
	DECLARE Mov_IntVen          INT;
	DECLARE Mov_IntPro          INT;
	DECLARE Mov_IntCalNoCon     INT;
	DECLARE Mov_IntMor          INT;
	DECLARE Mov_IVAInt          INT;
	DECLARE Mov_IVAMor          INT;
	DECLARE Mov_IVAFalPag       INT;
	DECLARE Mov_IVAComApe       INT;
	DECLARE Mov_ComFalPag       INT;
	DECLARE Mov_ComApeCre       INT;
	DECLARE Mov_ComLiqAnt       INT;
	DECLARE Mov_IVAComLiqAnt    INT;
	DECLARE Mov_IntMoratoVen    INT;
	DECLARE Mov_IntMoraCarVen   INT;
	DECLARE Mov_SegCuota        INT;
	DECLARE Mov_IVASegCuota     INT;
	#COMISION ANUALIDAD
	DECLARE Mov_ComAnual        INT;
	DECLARE Mov_ComAnualIVA     INT;

	DECLARE Mov_ComDispo        INT;
	DECLARE Mov_ComDispoIVA     INT;

	DECLARE Pro_GenInt          VARCHAR(50);
	DECLARE Pro_PagCre          VARCHAR(50);
	DECLARE Pro_Bonifi          VARCHAR(50);
	DECLARE Des_PagoCred        VARCHAR(50);
	DECLARE Salida_NO           CHAR(1);	-- Constante NO
	DECLARE Salida_SI			CHAR(1);	-- Constante SI

	-- Asignacion de Constantes
	SET Cadena_Vacia        := '';
	SET Fecha_Vacia         := '1900-01-01';
	SET Entero_Cero         := 0;
	SET Float_Cero          := 0.0;
	SET EstatusActivo       := 'A';
	SET Nat_Cargo           := 'C';
	SET Nat_Abono           := 'A';
	-- Movimientos de la tabla
	SET Mov_CapOrd          := 1;           -- Capital
	SET Mov_CapAtr          := 2;           -- Cap Atrasado
	SET Mov_CapVen          := 3;           -- Cap Vencido
	SET Mov_CapVNE          := 4;           -- Cap Vencido No Exigible
	SET Mov_IntOrd          := 10;          -- Interes ordinario
	SET Mov_IntAtr          := 11;          -- Interes atrasado
	SET Mov_IntVen          := 12;          -- Interes vencido
	SET Mov_IntCalNoCon     := 13;          -- Interes no contabilizado
	SET Mov_IntPro          := 14;          -- Interes provisionado
	SET Mov_IntMor          := 15;          -- Interes Moratorio
	SET Mov_IVAInt          := 20;          -- IVA de interes
	SET Mov_IVAMor          := 21;          -- IVA de interes mora
	SET Mov_IVAFalPag       := 22;          -- IVA de Com Falta de pago
	SET Mov_IVAComApe       := 23;          -- IVA Com por apertura
	SET Mov_IVAComLiqAnt    := 24;          -- IVA Comision por Administracion: Liquidacion Anticipada
	SET Mov_ComFalPag       := 40;          -- Comision por falta de pago
	SET Mov_ComApeCre       := 41;          -- Comision por apertura de credito
	SET Mov_ComLiqAnt       := 42;          -- Comision por Administracion: Liquidacion Anticipada
	SET Mov_IntMoratoVen    := 16;          -- Tipo de Movimiento: Interes Moratorio Vencido
	SET Mov_IntMoraCarVen   := 17;          -- Tipo de Movimiento: Interes Moratorio de Cartera Vencida
	SET Mov_SegCuota        := 50;          -- Tipo de Movimiento TCTIPOSMOVS: Seguro por Cuota
	SET Mov_IVASegCuota     := 25;          -- Tipo de Movimiento TCTIPOSMOVS: IVA Seguro por Cuota
	#COMISION ANUALIDAD
	SET Mov_ComAnual        := 51;              -- TCTIPOSMOVS: 51 Comision por Anualidad
	SET Mov_ComAnualIVA     := 52;              -- TCTIPOSMOVS: 52 IVA Comision por Anualidad
	-- TCTIPOSMOVS
	SET Mov_ComDispo        := 53;
	SET Mov_ComDispoIVA     := 54;

	SET Salida_NO           := 'N';
	SET Salida_SI           := 'S';

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-TC_LINEACREDMOVSALT');
			SET Var_Control := 'SQLEXCEPTION';
		END;

		IF( IFNULL(Par_LineaTarCredID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr  := '001';
			SET Par_ErrMen  := 'El Numero de Credito esta vacio.';
			SET Var_Control := 'LineaTarCredID' ;
			LEAVE ManejoErrores;
		END IF;

		SELECT Estatus
		INTO   Var_CreStatus
		FROM LINEATARJETACRED
		WHERE LineaTarCredID = Par_LineaTarCredID;

		SET Var_CreStatus = IFNULL(Var_CreStatus, Cadena_Vacia);

		IF( Var_CreStatus= Cadena_Vacia ) THEN
			SET Par_NumErr  := '002';
			SET Par_ErrMen  := 'El Credito no Existe.';
			SET Var_Control := 'LineaTarCredID' ;
			LEAVE ManejoErrores;
		END IF;

		IF( IFNULL(Par_Transaccion, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr  := '004';
			SET Par_ErrMen  := 'El numero de Movimiento esta vacio.';
			SET Var_Control := 'LineaTarCredID' ;
			LEAVE ManejoErrores;
		END IF;

		IF( IFNULL(Par_FechaOperacion, Fecha_Vacia) = Fecha_Vacia ) THEN
			SET Par_NumErr  := '005';
			SET Par_ErrMen  := 'La Fecha Op. esta Vacia.';
			SET Var_Control := 'fecha' ;
			LEAVE ManejoErrores;
		END IF;

		IF( IFNULL(Par_FechaAplicacion, Fecha_Vacia) = Fecha_Vacia ) THEN
			SET Par_NumErr  := '006';
			SET Par_ErrMen  := 'La Fecha Apl. esta Vacia.';
			SET Var_Control := 'fecha' ;

			LEAVE ManejoErrores;
		END IF;

		IF( IFNULL(Par_NatMovimiento, Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr  := '007';
			SET Par_ErrMen  := 'La naturaleza del Movimiento esta vacia.';
			SET Var_Control := 'natMovimiento' ;
			LEAVE ManejoErrores;
		END IF;

		IF( Par_NatMovimiento <> Nat_Cargo ) THEN
			IF( Par_NatMovimiento<> Nat_Abono ) THEN
				SET Par_NumErr  := '008';
				SET Par_ErrMen  := 'La naturaleza del Movimiento no es correcta.';
				SET Var_Control := 'natMovimiento' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF( Par_NatMovimiento <> Nat_Abono ) THEN
			IF( Par_NatMovimiento <> Nat_Cargo ) THEN
				SET Par_NumErr  := '009';
				SET Par_ErrMen  := 'La naturaleza del Movimiento no es correcta.';
				SET Var_Control := 'natMovimiento' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF( IFNULL(Par_Cantidad, Float_Cero) <= Float_Cero ) THEN
			SET Par_NumErr  := '010';
			SET Par_ErrMen  := 'Cantidad del Movimiento de Credito Incorrecta';
			SET Var_Control := 'cantidad';
			LEAVE ManejoErrores;
		END IF;

		IF( IFNULL(Par_Descripcion, Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr  := '011';
			SET Par_ErrMen  := 'La Descripcion del Movimiento esta vacia.';
			SET Var_Control := 'descripcion' ;
			LEAVE ManejoErrores;
		END IF;

		IF( IFNULL(Par_Referencia, Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr  := '012';
			SET Par_ErrMen  := 'La Referencia esta vacia.';
			SET Var_Control := 'referencia' ;
			LEAVE ManejoErrores;
		END IF;

		IF( IFNULL(Par_TipoMovLinID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr  := '013';
			SET Par_ErrMen  := 'El Tipo de Movimiento esta vacio.';
			SET Var_Control := 'tipoMovCreID' ;
			LEAVE ManejoErrores;
		END IF;

		SET Mov_Cantidad = Par_Cantidad;

		IF (Par_NatMovimiento = Nat_Abono) THEN
			SET Mov_Cantidad := Mov_Cantidad * -1;
		END IF;

		-- Intereses ordinarios
		IF (Par_TipoMovLinID = Mov_IntOrd OR Par_TipoMovLinID = Mov_IntPro) THEN
			UPDATE LINEATARJETACRED SET
				SaldoInteres    = SaldoInteres + Mov_Cantidad,
				MontoDisponible = MontoDisponible - Mov_Cantidad
			WHERE LineaTarCredID = Par_LineaTarCredID;

		-- Iva de Interes Ordinario
		ELSEIF (Par_TipoMovLinID = Mov_IVAInt) THEN
			UPDATE LINEATARJETACRED SET
				SaldoIVAInteres = SaldoIVAInteres + Mov_Cantidad,
				MontoDisponible = MontoDisponible - Mov_Cantidad
			WHERE LineaTarCredID = Par_LineaTarCredID;

		-- Capital Ordinario
		ELSEIF (Par_TipoMovLinID = Mov_CapOrd) THEN
			UPDATE LINEATARJETACRED SET
				SaldoCapVigente = SaldoCapVigente + Mov_Cantidad,
				MontoDisponible = MontoDisponible - Mov_Cantidad
			WHERE LineaTarCredID = Par_LineaTarCredID;

		-- Capital Vencido
		ELSEIF (Par_TipoMovLinID = Mov_CapVen) THEN
			UPDATE LINEATARJETACRED SET
				SaldoCapVencido = SaldoCapVencido + Mov_Cantidad,
				MontoDisponible = MontoDisponible - Mov_Cantidad
			WHERE LineaTarCredID = Par_LineaTarCredID;

		-- Interes Moratorio
		ELSEIF (Par_TipoMovLinID = Mov_IntMor) THEN
			UPDATE LINEATARJETACRED SET
				SaldoMoratorios = SaldoMoratorios + Mov_Cantidad,
				MontoDisponible = MontoDisponible - Mov_Cantidad
			WHERE LineaTarCredID = Par_LineaTarCredID;

		-- IVA de Interes Moratorio
		ELSEIF (Par_TipoMovLinID = Mov_IVAMor) THEN
			UPDATE LINEATARJETACRED SET
				SaldoIVAMoratorios  = SaldoIVAMoratorios + Mov_Cantidad,
				MontoDisponible = MontoDisponible - Mov_Cantidad
			WHERE LineaTarCredID = Par_LineaTarCredID;

		-- Comision por Falta de pago
		ELSEIF (Par_TipoMovLinID = Mov_ComFalPag) THEN
			UPDATE LINEATARJETACRED SET
				SalComFaltaPag  = SalComFaltaPag + Mov_Cantidad,
				MontoDisponible = MontoDisponible - Mov_Cantidad
			WHERE LineaTarCredID = Par_LineaTarCredID;

		-- IVA de Comision por falta de pago
		ELSEIF (Par_TipoMovLinID = Mov_IVAFalPag) THEN
			UPDATE LINEATARJETACRED SET
				SalIVAComFaltaPag   = SalIVAComFaltaPag + Mov_Cantidad,
				MontoDisponible = MontoDisponible - Mov_Cantidad
			WHERE LineaTarCredID = Par_LineaTarCredID;

		-- Comision Anual
		ELSEIF (Par_TipoMovLinID = Mov_ComAnual) THEN/*COMISION ANUAL*/

			UPDATE LINEATARJETACRED SET
				SalOrtrasComis = SalOrtrasComis + Mov_Cantidad,
				MontoDisponible = MontoDisponible - Mov_Cantidad
			WHERE LineaTarCredID  = Par_LineaTarCredID;

		-- Iva de Comision Anual
		ELSEIF (Par_TipoMovLinID = Mov_ComAnualIVA) THEN/*COMISION ANUAL*/

			UPDATE LINEATARJETACRED SET
				SalIVAOrtrasComis = SalIVAOrtrasComis + Mov_Cantidad,
				MontoDisponible = MontoDisponible - Mov_Cantidad
			WHERE LineaTarCredID  = Par_LineaTarCredID;

		-- Comision por disposicion
		ELSEIF (Par_TipoMovLinID = Mov_ComDispo) THEN

			UPDATE LINEATARJETACRED SET
				SalOrtrasComis = SalOrtrasComis + Mov_Cantidad,
				MontoDisponible = MontoDisponible - Mov_Cantidad
			WHERE LineaTarCredID  = Par_LineaTarCredID;

		-- IVA Comision por disposicion
		ELSEIF (Par_TipoMovLinID = Mov_ComDispoIVA) THEN

			UPDATE LINEATARJETACRED SET
				SalIVAOrtrasComis = SalIVAOrtrasComis + Mov_Cantidad,
				MontoDisponible = MontoDisponible - Mov_Cantidad
			WHERE LineaTarCredID  = Par_LineaTarCredID;

		-- Comision por Apertura
		ELSEIF (Par_TipoMovLinID = Mov_ComApeCre) THEN

			UPDATE LINEATARJETACRED SET
				SalOrtrasComis = SalOrtrasComis + Mov_Cantidad,
				MontoDisponible = MontoDisponible - Mov_Cantidad
			WHERE LineaTarCredID  = Par_LineaTarCredID;

		-- Comision por IVA de Com Apertura
		ELSEIF (Par_TipoMovLinID = Mov_IVAComApe) THEN

			UPDATE LINEATARJETACRED SET
				SalIVAOrtrasComis = SalIVAOrtrasComis + Mov_Cantidad,
				MontoDisponible = MontoDisponible - Mov_Cantidad
			WHERE LineaTarCredID  = Par_LineaTarCredID;
		END IF;


		-- Registro del movimiento en la tabla
		INSERT INTO TC_LINEACREDITOMOVS (
			LineaTarCredID,		TarjetaCredID,		NumeroMov,				FechaConsumo,		FechaAplicacion,
			NatMovimiento,		CantidadMov,		DescripcionMov,			ReferenciaMov,		MonedaID,
			TipoMovLinID,		PolizaID,
			EmpresaID,			Usuario,			FechaActual,			DireccionIP,		ProgramaID,
			Sucursal,			NumTransaccion)
		VALUES (
			Par_LineaTarCredID,	Par_TarjetaCredID,	Par_NumAutorizacion,	Par_FechaOperacion,	Par_FechaAplicacion,
			Par_NatMovimiento,	Par_Cantidad,		Par_Descripcion,		Par_Referencia,		Par_MonedaID,
			Par_TipoMovLinID,	Par_Poliza,
			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion);

		SET Par_NumErr := 0;
		SET Par_ErrMen := 'Movimiento Registrado Exitosamente';

	END ManejoErrores;

	IF( Par_Salida = Salida_SI ) THEN
		SELECT Par_NumErr AS NumErr,
			   Par_ErrMen AS ErrMen;
	END IF;

END TerminaStore$$