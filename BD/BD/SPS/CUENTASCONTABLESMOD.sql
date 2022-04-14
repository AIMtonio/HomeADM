-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASCONTABLESMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASCONTABLESMOD`;
DELIMITER $$

CREATE PROCEDURE `CUENTASCONTABLESMOD`(
	-- Store Procedure para dar alta las Cuentas Contables en SAFI
	-- Modulo: Contabilidad --> Catalogos --> Maestro Cuentas
	Par_CuentaCompleta		CHAR(25),		-- Cuenta Contable
	Par_CuentaMayor			CHAR(4),		-- Cuenta Contable de Mayor
	Par_Descripcion			VARCHAR(250),	-- Descripcion de la Cuenta Contable
	Par_DescriCorta			VARCHAR(250),	-- Descripcion Corta de la cuenta Contable
	Par_Naturaleza			CHAR(1),		-- Naturaleza de la cuenta contalbe

	Par_Grupo				CHAR(1),		-- Grupo de la cuenta contable
	Par_TipoCuenta			CHAR(1),		-- Tipo de Cuenta
	Par_MonedaID			INT(11),		-- Moneda ID
	Par_Restringida			CHAR(1),		-- Nivel de Restringido de la cuenta
	Par_CodigoAgrupador		VARCHAR(50),	-- Codigo Agrupador de la cuenta

	Par_Nivel				INT(11),		-- Nivel de la cuenta
	Par_FechaCreacionCta	DATE,			-- Fecha de Creacion

	Par_Salida				CHAR(1),		-- Parametro de salida S= si, N= no
	INOUT Par_NumErr		INT(11),		-- Parametro de salida numero de error
	INOUT Par_ErrMen		VARCHAR(400),	-- Parametro de salida mensaje de error

	Aud_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Fecha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control		VARCHAR(50);	-- Retorno de Control a Pantalla

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia	CHAR(1);		-- Constante Cadena Vacia
	DECLARE Salida_SI		CHAR(1);		-- Constante Cadena Vacia
	DECLARE Entero_Cero		INT(11);		-- Constante Entero Cero
	DECLARE Decimal_Cero	DECIMAL(14,2);	-- Constante DECIMAL Cero

	-- Asignacion de Constantes
	SET	Cadena_Vacia		:= '';
	SET	Salida_SI			:= 'S';
	SET	Entero_Cero			:= 0;
	SET	Decimal_Cero		:= 0.00;

	-- Bloque de Manejo de Errores
	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									 'esto le ocasiona. Ref: SP-CUENTASCONTABLESALT');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

		SET Par_CuentaCompleta	:= IFNULL(Par_CuentaCompleta,Cadena_Vacia);
		SET Par_Descripcion		:= IFNULL(Par_Descripcion,Cadena_Vacia);
		SET Par_DescriCorta		:= IFNULL(Par_DescriCorta,Cadena_Vacia);
		SET Par_Naturaleza		:= IFNULL(Par_Naturaleza,Cadena_Vacia);
		SET Par_Grupo			:= IFNULL(Par_Grupo,Cadena_Vacia);
		SET Par_TipoCuenta		:= IFNULL(Par_TipoCuenta,Cadena_Vacia);
		SET Par_MonedaID		:= IFNULL(Par_MonedaID, Entero_Cero);
		SET Par_Restringida		:= IFNULL(Par_Restringida,Cadena_Vacia);

		IF( Par_CuentaCompleta = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:= 'La Cuenta Completa esta Vacia.';
			SET Var_Control	:= 'cuentaCompleta';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_Descripcion = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 002;
			SET Par_ErrMen	:= 'La Descripcion esta Vacia.';
			SET Var_Control	:= 'descripcion';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_DescriCorta = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 003;
			SET Par_ErrMen	:= 'La Descripcion Corta esta Vacia.';
			SET Var_Control	:= 'descriCorta';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_Naturaleza = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 004;
			SET Par_ErrMen	:= 'La Naturaleza esta Vacia.';
			SET Var_Control	:= 'naturaleza';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_Grupo = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 005;
			SET Par_ErrMen	:= 'El Grupo esta Vacio.';
			SET Var_Control	:= 'grupo';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_TipoCuenta = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 006;
			SET Par_ErrMen	:= 'El Tipo de Cuenta esta Vacio.';
			SET Var_Control	:= 'tipoCuenta';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_MonedaID = Entero_Cero ) THEN
			SET Par_NumErr	:= 007;
			SET Par_ErrMen	:= 'El tipo de Moneda esta Vacio.';
			SET Var_Control	:= 'monedaID';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_Restringida = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 008;
			SET Par_ErrMen	:= 'Opcion Restringida esta Vacio.';
			SET Var_Control	:= 'restringida';
			LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual := CURRENT_TIMESTAMP();
		UPDATE CUENTASCONTABLES SET
			CuentaCompleta	= Par_CuentaCompleta,
			CuentaMayor		= Par_CuentaMayor,
			Descripcion		= Par_Descripcion,
			DescriCorta		= Par_DescriCorta,
			Naturaleza		= Par_Naturaleza,

			Grupo			= Par_Grupo,
			TipoCuenta		= Par_TipoCuenta,
			MonedaID		= Par_MonedaID,
			Restringida		= Par_Restringida,
			CodigoAgrupador	= Par_CodigoAgrupador,
			Nivel 			= Par_Nivel,

			FechaCreacionCta= Par_FechaCreacionCta,

			EmpresaID		= Aud_EmpresaID,
			Usuario			= Aud_Usuario,
			FechaActual		= Aud_FechaActual,
			DireccionIP		= Aud_DireccionIP,
			ProgramaID		= Aud_ProgramaID,
			Sucursal		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion
			WHERE CuentaCompleta = Par_CuentaCompleta;

		SET Par_NumErr 	:= Entero_Cero;
		SET Par_ErrMen 	:= CONCAT('Cuenta Contable Modificada Exitosamente: ',CONVERT(Par_CuentaCompleta, CHAR));
		SET Var_Control	:= 'cuentaCompleta';

	END ManejoErrores;

	IF( Par_Salida = Salida_SI ) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control;

	END IF;

END TerminaStore$$