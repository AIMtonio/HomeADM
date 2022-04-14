-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASCONTABLESWSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASCONTABLESWSALT`;
DELIMITER $$


CREATE PROCEDURE `CUENTASCONTABLESWSALT`(
 # ===== SP PARA DAR DE ALTA CUENTAS CONTABLES A TRAVES DE WS REST =======
	Par_CuentaCompleta	CHAR(25),		-- Cuenta contable completa
	Par_CuentaMayor		CHAR(4),		-- Cuenta contable mayor
	Par_Descripcion		VARCHAR(250),	-- Descripcion completa de la cuenta contable
	Par_DescriCorta		VARCHAR(250),	-- Descripcion corta de la cuenta contable
	Par_Naturaleza		CHAR(1),		-- Naturaleza de la cuenta contable A - Acreedora D - Deudora

	Par_Grupo			CHAR(1),		-- Grupo de la cuenta contable E - Encabezado D - Detalle
	Par_TipoCuenta		CHAR(1),		-- 1 Activo,2 Pasivo,3 ComplementariaActivo,4 CapitalyReserva,5 Resul(Ingresos),6 Resul(Gastos),7 Deudora, 8 Acreedora
	Par_MonedaID		INT(11),		-- Tipo de moneda
	Par_Restringida		CHAR(1),		-- S- Es restringida, N - No es restringida
    Par_CodigoAgrupador	CHAR(10),		-- Codigo agrupador

    Par_Nivel			INT(11),		-- Nivel de la cuenta
	Par_FechaCreaCta 	DATE,			-- Fecha de creación de la cuenta

	Par_Salida          CHAR(1),      	-- Parametro de salida
	INOUT Par_NumErr    INT(11),        -- Numero de error
	INOUT Par_ErrMen    VARCHAR(400),   -- Mensaje de error

	Aud_EmpresaID		INT(11),		-- Parametro de auditoria
	Aud_Usuario			INT(11),		-- Parametro de auditoria
	Aud_FechaActual		DATETIME,		-- Parametro de auditoria
	Aud_DireccionIP		VARCHAR(15),	-- Parametro de auditoria
	Aud_ProgramaID		VARCHAR(50),	-- Parametro de auditoria
	Aud_Sucursal		INT(11),		-- Parametro de auditoria
	Aud_NumTransaccion	BIGINT(20)		-- Parametro de auditoria
)

TerminaStore: BEGIN
	-- Declaracion de constantes
	DECLARE	Cadena_Vacia	CHAR(1);		-- Constante Cadena_Vacia
	DECLARE	Entero_Cero		INT(3);			-- Constante Entero_Cero
	DECLARE	Decimal_Cero	DECIMAL(14,2);	-- Constante Decimal_Cero
    DECLARE Salida_SI		CHAR(1);		-- Constante Salida_SI
    DECLARE Salida_NO		CHAR(1);		-- Constante Salida_NO
    DECLARE Fecha_Vacia		DATE;			-- Constante Fecha_Vacia


    -- Declaracion de variables
    DECLARE Var_Control		VARCHAR(15);	-- Variable de control
    DECLARE Var_Consecutivo	CHAR(25);		-- Variable Valor Consecutivo

	-- Asignacion de constantes
	SET	Cadena_Vacia		:= '';
	SET	Entero_Cero			:= 0;
	SET	Decimal_Cero		:= 0.0;
    SET Salida_SI			:= 'S';
	SET Salida_NO			:= 'N';
    SET Fecha_Vacia         := '1900-01-01';

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr   := 999;
			SET Par_ErrMen   := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-CUENTASCONTABLESWSALT');
			SET Var_Control  := 'SQLEXCEPTION';
		END;

		IF(IFNULL(Par_CuentaCompleta,Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 001;
			SET Par_ErrMen := 'La Cuenta Completa esta Vacia.';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_CuentaMayor,Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 001;
			SET Par_ErrMen := 'La Cuenta Mayor esta Vacia.';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Descripcion,Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 002;
			SET Par_ErrMen := 'La Descripcion esta vacia.';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_DescriCorta,Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 003;
			SET Par_ErrMen := 'La Descripcion Corta esta vacia.';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Naturaleza,Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 004;
			SET Par_ErrMen := 'La Naturaleza esta vacia.';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Grupo,Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 005;
			SET Par_ErrMen :=  'El Grupo esta Vacio.';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_TipoCuenta,Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 006;
			SET Par_ErrMen :=  'El Tipo de Cuenta esta Vacio.';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_MonedaID,Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr := 007;
			SET Par_ErrMen :=   'El tipo de Moneda esta Vacio.';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Restringida,Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 008;
			SET Par_ErrMen :=  'Opcion Restringida esta Vacio.';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_CodigoAgrupador,Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 009;
			SET Par_ErrMen :=  'El Codigo Agrupador esta Vacio.';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Nivel,Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr := 010;
			SET Par_ErrMen :=  'El Nivel esta Vacio.';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_FechaCreaCta,Fecha_Vacia)) = Fecha_Vacia THEN
			SET Par_NumErr := 011;
			SET Par_ErrMen :=  'La Fecha de Creacion de la Cuenta esta Vacia.';
			LEAVE ManejoErrores;
		END IF;

		IF EXISTS(SELECT CuentaCompleta FROM CUENTASCONTABLES WHERE CuentaCompleta = Par_CuentaCompleta) THEN
			SET Par_NumErr	:= 012;
			SET Par_ErrMen 	:= 'La Cuenta Contable ya esta Registrada.';
			LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual := NOW();

		CALL CUENTASCONTABLESALT(
			Par_CuentaCompleta,		Par_CuentaMayor,		Par_Descripcion,	Par_DescriCorta,	Par_Naturaleza,
			Par_Grupo,				Par_TipoCuenta,			Par_MonedaID,		Par_Restringida,	Par_CodigoAgrupador,
			Par_Nivel,				Par_FechaCreaCta,		Salida_NO,			Par_NumErr,         Par_ErrMen,
            Aud_EmpresaID,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
            Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
        END IF;

		SET Par_NumErr  := 000;
		SET Par_ErrMen  := 'Cuentas Contables Agregadas Exitosamente';
		SET Var_Control	:= '';
        SET Var_Consecutivo := Par_CuentaMayor;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr 		AS NumErr,
				Par_ErrMen		AS ErrMen,
                Var_Control 	AS Control,
                Var_Consecutivo AS Consecutivo;
	END IF;
END TerminaStore$$