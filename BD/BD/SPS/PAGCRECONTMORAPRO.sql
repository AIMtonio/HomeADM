-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGCRECONTMORAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGCRECONTMORAPRO`;DELIMITER $$

CREATE PROCEDURE `PAGCRECONTMORAPRO`(
    /* no cambiar las  asignaciones ya que este  se manda a llamar dentro de un CURSOR
		y no puede tener ninguna asignacion con INTO, de lo contrario podria no concluir con exito
		el procedimiento */
	Par_CreditoID			BIGINT,
	Par_AmortiCreID			INT(4),
	Par_FechaInicio			DATE,
	Par_FechaVencim			DATE,
	Par_CuentaAhoID			BIGINT,

	Par_ClienteID			BIGINT,
	Par_FechaOperacion		DATE,
	Par_FechaAplicacion		DATE,
	Par_Monto				DECIMAL(14,2),
	Par_IVAMonto			DECIMAL(14,2),

	Par_MonedaID			INT,
	Par_ProdCreditoID		INT,
	Par_Clasificacion		CHAR(1),
	Par_SubClasifID			INT,
	Par_SucCliente			INT,

	Par_Descripcion			VARCHAR(100),
	Par_Referencia			VARCHAR(50),
	Par_Poliza				BIGINT,

    Par_Salida              CHAR(1),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),
	INOUT Par_Consecutivo	BIGINT,

	Par_EmpresaID			INT,
	Par_ModoPago			CHAR(1),
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE	Var_TipoContaMora	CHAR(1);

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT;
	DECLARE	Decimal_Cero		DECIMAL(16, 2);
	DECLARE	AltaPoliza_NO		CHAR(1);
	DECLARE	AltaPolCre_SI		CHAR(1);
	DECLARE	AltaMovCre_SI		CHAR(1);
	DECLARE	AltaMovCre_NO		CHAR(1);
	DECLARE	AltaMovAho_NO		CHAR(1);
	DECLARE	Nat_Cargo			CHAR(1);
	DECLARE	Nat_Abono			CHAR(1);
	DECLARE Salida_SI           CHAR(1);
	DECLARE	Mov_Moratorio		INT;
	DECLARE	Mov_IVAIntMora		INT;
	DECLARE	Con_IngIntMora		INT;
	DECLARE	Con_IVAMora			INT;
	DECLARE	Con_CtaOrdMor 		INT;
	DECLARE	Con_CorIntMor 		INT;
	DECLARE Mora_CtaOrden		CHAR(1);

	-- Asignacion de Constantes
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Decimal_Cero		:= 0.00;
	SET	AltaPoliza_NO		:= 'N';
	SET	AltaPolCre_SI		:= 'S';
	SET	AltaMovCre_SI		:= 'S';
	SET	AltaMovCre_NO		:= 'N';
	SET	AltaMovAho_NO		:= 'N';
	SET Nat_Cargo			:= 'C';
	SET Nat_Abono			:= 'A';
    SET Salida_SI			:= 'S';
	SET	Mov_Moratorio		:= 15;		-- Movimiento Operativo de Credito: Interes Moratorio
	SET	Mov_IVAIntMora		:= 21;		-- Movimiento Operativo de Credito: IVA de Interes Moratorio

	SET	Con_IngIntMora		:= 79;		-- Concepto Contable: Ingreso por Interes Moratorio
	SET	Con_IVAMora			:= 81;		-- Concepto Contable: IVA de Interes Moratorio
	SET	Con_CtaOrdMor		:= 74;		-- Concepto Contable: Cuenta de Orden de Interes Moratorio
	SET	Con_CorIntMor		:= 75;		-- Concepto Contable: Correlativa Cuenta de Orden de Interes Moratorio

	SET Mora_CtaOrden		:= 'C';		-- Tipo de Contabilizacion de los Intereses Moratorios: En Cuentas de Orden

	SET Var_TipoContaMora	:= (SELECT TipoContaMora FROM PARAMETROSSIS);
	SET	Var_TipoContaMora	:= IFNULL(Var_TipoContaMora, Cadena_Vacia);

	ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr := 999;
            SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al
                concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-PAGCRECONTCOMFALPRO');
        END;

		IF(Par_Monto > Decimal_Cero) THEN

			-- Verificamos como Registrar Operativa y Contablemente los moratorios, dependiendo lo que especifique en la parametrizacion
			-- Si se contabiliza en cuentas de orden o en cuentas de ingresos
				CALL CONTACREDITOSCONTPRO (
					Par_CreditoID,			Par_AmortiCreID,        Par_CuentaAhoID,    	Par_ClienteID,			Par_FechaOperacion,
					Par_FechaAplicacion,    Par_Monto,          	Par_MonedaID,			Par_ProdCreditoID,		Par_Clasificacion,
					Par_SubClasifID,    	Par_SucCliente,			Par_Descripcion,    	Par_Referencia,         AltaPoliza_NO,
					Entero_Cero,			Par_Poliza,         	AltaPolCre_SI,          AltaMovCre_SI,			Con_IngIntMora,
					Mov_Moratorio,      	Nat_Abono,              AltaMovAho_NO,			Cadena_Vacia,			Cadena_Vacia,
					AltaMovCre_NO,			Par_NumErr,             Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,
					Par_ModoPago,			Aud_Usuario,        	Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
					Aud_Sucursal,       	Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;


				CALL  CONTACREDITOSCONTPRO (
					Par_CreditoID,			Par_AmortiCreID,        Par_CuentaAhoID,    	Par_ClienteID,			Par_FechaOperacion,
					Par_FechaAplicacion,    Par_Monto,          	Par_MonedaID,			Par_ProdCreditoID,		Par_Clasificacion,
					Par_SubClasifID,    	Par_SucCliente,			Par_Descripcion,    	Par_Referencia,         AltaPoliza_NO,
					Entero_Cero,			Par_Poliza,         	AltaPolCre_SI,          AltaMovCre_NO,      	Con_CtaOrdMor,
					Mov_Moratorio,      	Nat_Abono,              AltaMovAho_NO,      	Cadena_Vacia,			Cadena_Vacia,
					AltaMovCre_NO,			Par_NumErr,             Par_ErrMen,         	Par_Consecutivo,		Par_EmpresaID,
					Par_ModoPago,			Aud_Usuario,        	Aud_FechaActual,    	Aud_DireccionIP,		Aud_ProgramaID,
					Aud_Sucursal,           Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;


				CALL  CONTACREDITOSCONTPRO (
					Par_CreditoID,      	Par_AmortiCreID,        Par_CuentaAhoID,    	Par_ClienteID,			Par_FechaOperacion,
					Par_FechaAplicacion,    Par_Monto,          	Par_MonedaID,			Par_ProdCreditoID,		Par_Clasificacion,
					Par_SubClasifID,    	Par_SucCliente,			Par_Descripcion,    	Par_Referencia,         AltaPoliza_NO,
					Entero_Cero,			Par_Poliza,         	AltaPolCre_SI,          AltaMovCre_NO,      	Con_CorIntMor,
					Mov_Moratorio,      	Nat_Cargo,              AltaMovAho_NO,      	Cadena_Vacia,			Cadena_Vacia,
					AltaMovCre_NO,	       	Par_NumErr,             Par_ErrMen,         	Par_Consecutivo,		Par_EmpresaID,
					Par_ModoPago,			Aud_Usuario,        	Aud_FechaActual,    	Aud_DireccionIP,		Aud_ProgramaID,
					Aud_Sucursal,       	Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

		END IF;


		IF (Par_IVAMonto > Decimal_Cero) THEN
			CALL  CONTACREDITOSCONTPRO (
				Par_CreditoID,      		Par_AmortiCreID,        Par_CuentaAhoID,    	Par_ClienteID,			Par_FechaOperacion,
				Par_FechaAplicacion,    	Par_IVAMonto,       	Par_MonedaID,			Par_ProdCreditoID,		Par_Clasificacion,
				Par_SubClasifID,    		Par_SucCliente,			Par_Descripcion,    	Par_Referencia,         AltaPoliza_NO,
				Entero_Cero,				Par_Poliza,         	AltaPolCre_SI,          AltaMovCre_SI,      	Con_IVAMora,
				Mov_IVAIntMora,     		Nat_Abono,              AltaMovAho_NO,      	Cadena_Vacia,			Cadena_Vacia,
				AltaMovCre_NO,				Par_NumErr,             Par_ErrMen,         	Par_Consecutivo,		Par_EmpresaID,
				Par_ModoPago,				Aud_Usuario,        	Aud_FechaActual,  		Aud_DireccionIP,		Aud_ProgramaID,
				Aud_Sucursal,       		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;

         SET Par_NumErr      := Entero_Cero;
		 SET Par_ErrMen      := 'Operacion Realizada Exitosamente';

END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN
        SELECT
            Par_NumErr          AS NumErr,
            Par_ErrMen          AS ErrMen;

    END IF;

END TerminaStore$$