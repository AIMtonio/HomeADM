-- SP BANDETALLEPOLIZAVAL

DELIMITER ;

DROP PROCEDURE IF EXISTS BANDETALLEPOLIZAVAL;

DELIMITER $$

CREATE PROCEDURE `BANDETALLEPOLIZAVAL`(
	Par_PolizaID					INT(11),						-- Numero de la poliza
	Par_CentroCostoID				INT(11),						-- Numero de Centro Costo
	Par_CuentaContable				VARCHAR(50),					-- Cuenta Contable completa
	Par_Cargos						DECIMAL(14,4),					-- Total de Cargo
	Par_Abonos						DECIMAL(14,4),					-- Total de Abono

	Par_TipoInstrumentoID			INT(11),						-- Numero de Instrumento
	Par_Moneda						INT (11),						-- Numero de Moneda

	Par_TipoValidacion				INT(11),						-- Tipo de validacion

	Par_Salida						CHAR(1),						-- Variable para la salida del SP
	INOUT Par_NumErr				INT(11),						-- Variable para mostrar el numero de error
	INOUT Par_ErrMen				VARCHAR(400),					-- Variable para mostrar el mensaje de error

	-- Parametros de Auditoria
	Aud_EmpresaID					INT(11),						-- ID de la Empresa
	Aud_Usuario						INT(11),						-- ID del Usuario que creo el Registro
	Aud_FechaActual					DATETIME,						-- Fecha Actual de la creacion del Registro
	Aud_DireccionIP					VARCHAR(15),					-- Direccion IP de la computadora
	Aud_ProgramaID					VARCHAR(50),					-- Identificador del Programa
	Aud_Sucursal					INT(11),						-- Identificador de la Sucursal
	Aud_NumTransaccion				BIGINT(20)						-- Numero de Transaccion
	)
TerminaStore: BEGIN

	-- declaracion de constantes
	DECLARE	Cadena_Vacia			CHAR(1);						-- Cadena vacia
	DECLARE	Entero_Cero				INT(11);						-- Entero vacio
	DECLARE Entero_Uno				INT(1);							-- Variable para autoincrementar en uno;
	DECLARE	Decimal_Cero			DECIMAL(14,2);					-- Decimal Vacio
	DECLARE	Fecha_Vacia				DATE;							-- Fecha Vacia
	DECLARE	Salida_NO				CHAR(1);						-- Salida No
	DECLARE	Salida_SI				CHAR(1);						-- Salida Si
	DECLARE Var_Control				VARCHAR(100);					-- Variable con el ID del control de Pantalla
	DECLARE Var_CargosPoliza		DECIMAL(14,4);
	DECLARE Var_AbonosPoliza		DECIMAL(14,4);
	DECLARE LimiteDifPoliza			DECIMAL;
	DECLARE GrupoCuentaConta		CHAR(1);						-- Grupo que pertenece a la cuenta Contable

	DECLARE Cons_ValPoliza			INT(11);						-- Constante Para validar la poliza que no se encuentre descuadrada
	DECLARE Cons_ValParamWS			INT(11);						-- Constante Para validar los parametros de entradas al registrar el asineto contavle por WS

	-- Declaracion de variables
	DECLARE Var_PolizaID			INT(11);						-- Variable de poliza
	DECLARE Var_CuentaCompleta		VARCHAR(50);					-- Variable de cuenta completa
	DECLARE Var_CentroCostoID		INT(11);						-- Variable de centro de costo
	DECLARE Var_TipoInstrumentoID	INT(11);						-- Variable de Instrumento
	DECLARE Var_MonedaID			INT(11);						-- Variable de  moneda
	DECLARE Var_GrupoCuentaCon		CHAR(1);						-- Variable de grupo que pertenece la cuenta contable

	-- asignacion de valores
	SET LimiteDifPoliza				:=0.01;
	SET	Cadena_Vacia				:= '';							-- Asignacion de Cadena Vacia
	SET	Fecha_Vacia					:= '1900-01-01';				-- Asignacion de Fecha Vacia
	SET	Entero_Cero					:= 0;							-- Asignacion de Entero Vacio
	SET	Decimal_Cero				:= 0.0;							-- Asignacion de Decimal Vacio
	SET	Salida_NO					:= 'N';							-- Asignacion de Salida NO
	SET Salida_SI					:= 'S';							-- Asignacion de Salida SI
	SET Entero_Uno					:= 1;							-- asignacion de variable con valor numero u
	SET GrupoCuentaConta			:= 'E';							-- Grupo que pertenece a la cuenta Contable  E= Encabezado


	SET Cons_ValPoliza				:= 1;							-- Constante Para validar la poliza que no se encuentre descuadrada
	SET Cons_ValParamWS				:= 2;							-- Constante Para validar los parametros de entradas al registrar el asineto contavle por WS

	-- Declaracion de Valores Default
	SET Par_PolizaID				:= IFNULL(Par_PolizaID, Entero_Cero);
	SET Par_CentroCostoID			:= IFNULL(Par_CentroCostoID, Entero_Cero);
	SET Par_CuentaContable			:= IFNULL(Par_CuentaContable, Cadena_Vacia);
	SET Par_Cargos					:= IFNULL(Par_Cargos, Decimal_Cero);
	SET Par_Abonos					:= IFNULL(Par_Abonos, Decimal_Cero);
	SET Par_TipoInstrumentoID		:= IFNULL(Par_TipoInstrumentoID, Entero_Cero);
	SET Par_Moneda					:= IFNULL(Par_Moneda, Entero_Cero);

ManejoErrores: begin

DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET Par_NumErr = '999';
		SET Par_ErrMen = concat('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
						'esto le ocasiona. Ref: SP-BANDETALLEPOLIZAVAL');
		SET Var_Control = 'sqlException' ;
	END;

	-- 1.- Numero de proceso Para validar la poliza que no se encuentre descuadrada
	IF(Par_TipoValidacion = Cons_ValPoliza) THEN
		SELECT round(sum(Cargos),2), round(sum(Abonos),2) INTO Var_CargosPoliza, Var_AbonosPoliza
			FROM DETALLEPOLIZA
			WHERE PolizaID = Par_PolizaID;

		SET	Var_CargosPoliza	:= IFNULL(Var_CargosPoliza,Entero_Cero);
		SET	Var_AbonosPoliza	:= IFNULL(Var_AbonosPoliza,Entero_Cero);

		IF(ABS((Var_CargosPoliza - Var_AbonosPoliza)) > LimiteDifPoliza or (Var_CargosPoliza + Var_AbonosPoliza)=Entero_Cero)THEN
			SET Par_ErrMen:="1.- Poliza Descuadrada";
			SET Par_NumErr:= 9;
			LEAVE ManejoErrores;
		END IF;
	END IF;

	-- 2.-Numero de Proceso Para validar los parametros de entradas al registrar el asineto contavle por WS
	IF(Par_TipoValidacion = Cons_ValParamWS) THEN

		IF(Par_PolizaID = Entero_Cero) THEN
			SET Par_NumErr	:= 1;
			SET Par_ErrMen	:= 'Especifique el Numero de Poliza Contable.';
			SET Var_Control	:= 'polizaID';
			LEAVE ManejoErrores;
		END IF;

		SELECT PolizaID 
			INTO Var_PolizaID
			FROM POLIZACONTABLE
			WHERE PolizaID = Par_PolizaID;

		IF(IFNULL(Var_PolizaID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr	:= 2;
			SET Par_ErrMen	:= 'El Numero de Poliza Contable no Existe.';
			SET Var_Control	:= 'polizaID';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_CuentaContable = Cadena_Vacia) THEN
			SET Par_NumErr	:= 3;
			SET Par_ErrMen	:= 'Especifique la Cuenta Contable.';
			SET Var_Control	:= 'cuentaCompleta';
			LEAVE ManejoErrores;
		END IF;

		SELECT CuentaCompleta,		Grupo
			INTO Var_CuentaCompleta,	Var_GrupoCuentaCon
			FROM CUENTASCONTABLES
			WHERE CuentaCompleta = Par_CuentaContable;

		SET Var_GrupoCuentaCon	:= IFNULL(Var_GrupoCuentaCon,Cadena_Vacia);

		IF(IFNULL(Var_CuentaCompleta, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr	:= 4;
			SET Par_ErrMen	:= CONCAT('La Cuenta Contable : ', Par_CuentaContable ,' no Existe.');
			SET Var_Control	:= 'cuentaCompleta';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_GrupoCuentaCon = GrupoCuentaConta) THEN
			SET Par_NumErr	:= 6;
			SET Par_ErrMen	:= CONCAT('La Cuenta Contable ', Par_CuentaContable,' es de Encabezado y no es de Detalle.');
			SET Var_Control	:= 'cuentaCompleta';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_CentroCostoID = Entero_Cero) THEN
			SET Par_NumErr	:= 7;
			SET Par_ErrMen	:= CONCAT('Especifique el Centro de Costo Para la Cuenta Contable: ',Par_CuentaContable, '.');
			SET Var_Control	:= 'centroCostoID';
			LEAVE ManejoErrores;
		END IF;

		SELECT CentroCostoID
			INTO Var_CentroCostoID
			FROM CENTROCOSTOS
			WHERE CentroCostoID = Par_CentroCostoID;

		IF(IFNULL(Var_CentroCostoID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr	:= 8;
			SET Par_ErrMen	:= CONCAT('El Centro de Costo: ',Par_CentroCostoID,' no Existe.');
			SET Var_Control	:= 'centroCostoID';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_Cargos = Decimal_Cero AND Par_Abonos = Decimal_Cero) THEN
			SET Par_NumErr	:= 9;
			SET Par_ErrMen	:= CONCAT('Especifique el Monto de Cargo o Abono Para el Asiento Contable de la Cuenta Contable' ,Par_CuentaContable,'.');
			SET Var_Control	:= 'cargosAbonos';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_Cargos > Decimal_Cero AND Par_Abonos > Decimal_Cero) THEN
			SET Par_NumErr	:= 10;
			SET Par_ErrMen	:= CONCAT('El Registro de la Cuenta Contable: ',Par_CuentaContable ,' no puede Tener Monto de Cargo $',Par_Cargos,' y Monto de Abonos $',Par_Abonos,' en el Mismo Registro.');
			SET Var_Control	:= 'cargosAbonos';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_TipoInstrumentoID = Entero_Cero) THEN
			SET Par_NumErr	:= 11;
			SET Par_ErrMen	:= CONCAT('Especifique el tipo de Instrumento para la Cuenta Contable: ',Par_CuentaContable,'.');
			SET Var_Control	:= 'instrumentoID';
			LEAVE ManejoErrores;
		END IF;

		SELECT TipoInstrumentoID
			INTO Var_TipoInstrumentoID
			FROM TIPOINSTRUMENTOS
			WHERE TipoInstrumentoID = Par_TipoInstrumentoID;

		IF(IFNULL(Var_TipoInstrumentoID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr	:= 12;
			SET Par_ErrMen	:= CONCAT('El Tipo de Instrumento : ',Par_TipoInstrumentoID, ' no Existe.');
			SET Var_Control	:= 'instrumentoID';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_Moneda = Entero_Cero) THEN
			SET Par_NumErr	:= 13;
			SET Par_ErrMen	:= CONCAT('Especifique el tipo de Moneda para la Cuenta Contable: ',Par_CuentaContable,'.');
			SET Var_Control	:= 'monedaID';
			LEAVE ManejoErrores;
		END IF;

		SELECT MonedaId
			INTO Var_MonedaID
			FROM MONEDAS
			WHERE MonedaId = Par_Moneda;

		IF(IFNULL(Var_MonedaID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr	:= 14;
			SET Par_ErrMen	:= CONCAT('El Tipo de Moneda : ',Par_Moneda, ' no Existe.');
			SET Var_Control	:= 'monedaID';
			LEAVE ManejoErrores;
		END IF;

	END IF;

	SET Par_NumErr	:= 0;
	SET Par_ErrMen	:= 'Validacion Realizada Exitosamente';
	SET Var_Control	:= 'cuentaAhoID' ;

END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr	AS NumErr,
				Par_ErrMen	AS ErrMen,
				Var_Control	AS control;
	END IF;

END TerminaStore$$
