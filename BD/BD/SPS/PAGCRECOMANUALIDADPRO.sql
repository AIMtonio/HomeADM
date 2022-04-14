-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGCRECOMANUALIDADPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGCRECOMANUALIDADPRO`;
DELIMITER $$

CREATE PROCEDURE `PAGCRECOMANUALIDADPRO`(
	-- SP para realizar las afectaciones contables de comision por anualidad de credito
	Par_CreditoID			BIGINT(12),
	Par_AmortiCreID			INT(4),
	Par_FechaInicio			DATE,
	Par_FechaVencim			DATE,
	Par_CuentaAhoID			BIGINT(12),

	Par_ClienteID			BIGINT,
	Par_FechaOperacion		DATE,
	Par_FechaAplicacion		DATE,
	Par_Monto				DECIMAL(12,2),
	Par_IVAMonto			DECIMAL(12,2),

	Par_MonedaID			INT,
	Par_ProdCreditoID		INT,
	Par_Clasificacion		CHAR(1),
	Par_SubClasifID			INT,
	Par_SucCliente			INT,

	Par_Descripcion			VARCHAR(100),
	Par_Referencia			VARCHAR(50),
	Par_Poliza				BIGINT,
	Par_OrigenPago			CHAR(1),			# Origen de Pago S: SPEI, V: Ventanilla, C: Cargo A Cta, N: Nomina, D: Domiciliado, R: Depositos Referenciados, W: WebService, O: Otros, Cadena Vacia en caso que no sea un op de pago mov operativos
	Par_Salida				CHAR(1),

	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),
	INOUT Par_Consecutivo	BIGINT,
	Par_EmpresaID			INT(11),
	Par_ModoPago			CHAR(1),

	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),

	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control			CHAR(100);

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia			CHAR(1);
	DECLARE	Fecha_Vacia				DATE;
	DECLARE	Entero_Cero				INT;
	DECLARE	Decimal_Cero			DECIMAL(12, 2);
	DECLARE	AltaPoliza_NO			CHAR(1);
	DECLARE	Cons_SI					CHAR(1);
	DECLARE	Cons_No					CHAR(1);
	DECLARE	AltaPolCre_SI			CHAR(1);
	DECLARE	AltaMovCre_SI			CHAR(1);
	DECLARE	AltaMovCre_NO			CHAR(1);
	DECLARE	AltaMovAho_NO			CHAR(1);
	DECLARE	Nat_Cargo				CHAR(1);

	DECLARE	Nat_Abono				CHAR(1);
	DECLARE	Mov_ComisionAnual		INT;
	DECLARE	Mov_ComisionAnualIVA	INT;
	DECLARE Con_IngComisionAnual 	INT;
	DECLARE Con_ComisionAnualIVA 	INT;


	-- Asignacion de constantes
	SET	Cadena_Vacia	  	:= '';				-- Cadena vacia
	SET	Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia
	SET	Entero_Cero			:= 0;				-- Entero cero
	SET	Decimal_Cero		:= 0.00;			-- Decimal cero
	SET	AltaPoliza_NO		:= 'N';				-- Alta Poliza: NO

	SET	Cons_SI				:= 'S';				-- Salida SI
	SET	Cons_No				:= 'N';				-- Salida No
	SET	AltaPolCre_SI		:= 'S';				-- Alta Poliza Credito: SI
	SET	AltaMovCre_SI		:= 'S';				-- Alta Movimiento de Credito: SI
	SET	AltaMovCre_NO		:= 'N';				-- Alta Movimiento de Credito: NO
	SET	AltaMovAho_NO		:= 'N';				-- Alta de Movimiento Ahorro: NO
	SET Nat_Cargo			:= 'C';				-- Naturaleza de Movimiento: Cargo

	SET Nat_Abono			:= 'A';					-- Naturaleza de Movimiento: Abono
	SET	Mov_ComisionAnual		:= 51;		 		-- TIPOSMOVSCRE: 51 Comision por Anualidad
	SET	Mov_ComisionAnualIVA	:= 52;		 		-- TIPOSMOVSCRE: 52 IVA Comision por Anualidad
	SET Con_IngComisionAnual	:= 56;		 		-- CONCEPTOSCARTERA: 56 Ingreso Comision por Anualidad
	SET Con_ComisionAnualIVA 	:= 57;		 		-- CONCEPTOSCARTERA: 57 IVA Comision por Anualidad

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGCRECOMANUALIDADPRO');
				SET Var_Control = 'SQLEXCEPTION';
		END;

		-- Ingreso Comision por Anualidad
		IF (Par_Monto > Decimal_Cero) THEN
			CALL CONTACREDITOSPRO (
				Par_CreditoID,			Par_AmortiCreID,        Par_CuentaAhoID,    	Par_ClienteID,			Par_FechaOperacion,
				Par_FechaAplicacion,    Par_Monto,         		Par_MonedaID,			Par_ProdCreditoID,		Par_Clasificacion,
				Par_SubClasifID,    	Par_SucCliente,			Par_Descripcion,    	Par_Referencia,         AltaPoliza_NO,
				Entero_Cero,			Par_Poliza,         	AltaPolCre_SI,      	AltaMovCre_SI,      	Con_IngComisionAnual,
				Mov_ComisionAnual,    	Nat_Abono,              AltaMovAho_NO,      	Cadena_Vacia,			Cadena_Vacia,
				Par_OrigenPago,			Cons_No,
				Par_NumErr,             Par_ErrMen,         	Par_Consecutivo,		Par_EmpresaID,      	Par_ModoPago,
				Aud_Usuario,        	Aud_FechaActual,   		Aud_DireccionIP,
				Aud_ProgramaID,     	Aud_Sucursal,			Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;

		-- IVA comision por anualidad
		IF (Par_IVAMonto > Decimal_Cero) THEN
			CALL CONTACREDITOSPRO (
				Par_CreditoID,      	Par_AmortiCreID,        Par_CuentaAhoID,    	Par_ClienteID,			Par_FechaOperacion,
				Par_FechaAplicacion,    Par_IVAMonto,       	Par_MonedaID,			Par_ProdCreditoID, 	 	Par_Clasificacion,
				Par_SubClasifID,    	Par_SucCliente,			Par_Descripcion,    	Par_Referencia,         AltaPoliza_NO,
				Entero_Cero,			Par_Poliza,         	AltaPolCre_SI,     	 	AltaMovCre_SI,      	Con_ComisionAnualIVA,
				Mov_ComisionAnualIVA, 	Nat_Abono,              AltaMovAho_NO,      	Cadena_Vacia,			Cadena_Vacia,
				Par_OrigenPago,			Cons_No,
				Par_NumErr,             Par_ErrMen,         	Par_Consecutivo,		Par_EmpresaID,      	Par_ModoPago,
				Aud_Usuario,        	Aud_FechaActual,    	Aud_DireccionIP,
				Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SET Par_NumErr	:= 0;
		SET Par_ErrMen	:= 'Pago de Comision Anual realizado Exitosamente.';
		SET Var_Control := 'creditoID';
		SET Par_Consecutivo := IFNULL(Par_Consecutivo,Entero_Cero);

	END ManejoErrores;

	IF (Par_Salida = Cons_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_Consecutivo AS Consecutivo;
	END IF;


END TerminaStore$$