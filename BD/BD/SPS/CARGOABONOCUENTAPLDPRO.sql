-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CARGOABONOCUENTAPLDPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CARGOABONOCUENTAPLDPRO`;DELIMITER $$

CREATE PROCEDURE `CARGOABONOCUENTAPLDPRO`(
	-- Procedimiento almacenado para realizar cargos o abonos a cuentas
	Par_CuentaAhoIDClie				VARCHAR(20),		-- Identificador del cliente externo
	Par_ClienteID					BIGINT,				-- Numero de Cliente
	Par_Fecha						DATE,				-- Fecha
	Par_NatMovimiento				CHAR(1),			-- Naturaleza del movimiento

	Par_CantidadMov					DECIMAL(12,2),		-- Cantidad Movimiento
	Par_DescripcionMov				VARCHAR(150),		-- Descripcion del movimiento
	Par_ReferenciaMov				VARCHAR(50),		-- Referencia del movimiento
	Par_TipoMovAhoID				CHAR(4),			-- Tipo de movimiento de ahorro

	Par_Salida						CHAR(1),			-- Parametro indicador si el SP devolvera una respuesta o no
	INOUT	Par_NumErr				INT(11),			-- Parametro indicador del número de error
	INOUT	Par_ErrMen				VARCHAR(400),		-- Parametro indicador del mensaje de error

	Aud_EmpresaID					INT(11),			-- Parametro de auditoria
	Aud_Usuario						INT(11),			-- Parametro de auditoria
	Aud_FechaActual					DATETIME,			-- Parametro de auditoria
	Aud_DireccionIP					VARCHAR(15),		-- Parametro de auditoria
	Aud_ProgramaID					VARCHAR(50),		-- Parametro de auditoria
	Aud_Sucursal					INT(11),			-- Parametro de auditoria
	Aud_NumTransaccion				BIGINT(20)			-- Parametro de auditoria
)
TerminaStore: BEGIN
	-- Declaracion de constantes
	DECLARE Var_Control					VARCHAR(100);	-- Variable de control
	DECLARE Var_Consecutivo				BIGINT(20);		-- Variable consecutiva
	DECLARE Var_EstatusCliente			CHAR(1);		-- Variable contenedora del estatus del cliente
	DECLARE EstatusInactivo				CHAR(1);		-- Variable indicadora de estatus inactivo
	DECLARE Decimal_Cero				DECIMAL(12,2);	-- Constante decimal cero
	DECLARE Entero_Cero					INT(11);		-- Constante entero cero
	DECLARE Fecha_Vacia					DATE;			-- Constante fecha vacia
	DECLARE Cadena_Vacia				CHAR(1);		-- Constante cadena vacia
	DECLARE Salida_NO					CHAR(1);		-- Constante de salida no
	DECLARE Salida_SI					CHAR(1);		-- Constante de salida si
	DECLARE Var_Si						CHAR(1);		-- Variable si
	DECLARE	Nat_Cargo					CHAR(1);		-- Variable contenedora de la naturaleza del cargo
	DECLARE	Nat_Abono					CHAR(1);		-- Variable contenedora de la naturaleza del abono
	DECLARE Var_SaldoDispon				DECIMAL(12,2);	-- Variable del saldo disponible del cliente
	DECLARE Var_MonedaID				INT(11);		-- Variable contenedora del identificador de la moneda
	DECLARE Var_EstatusDes				VARCHAR(50);	-- Variable indicadora del estatus des

	DECLARE Var_EstatusA				CHAR(1);		-- Variable contendora del estatus activa
	DECLARE Var_EstatusB				CHAR(1);		-- Variable contendora del estatus bloqueada
	DECLARE Var_EstatusC				CHAR(1);		-- Variable contendora del estatus cancelada
	DECLARE Var_EstatusI				CHAR(1);		-- Variable contendora del estatus inactiva
	DECLARE Var_EstatusR				CHAR(1);		-- Variable contendora del estatus registrada

	DECLARE Var_Activa					VARCHAR(15);	-- Variable contendora de la descripcion del estatus activa
	DECLARE Var_Bloqueada				VARCHAR(15);	-- Variable contendora de la descripcion del estatus bloqueada
	DECLARE Var_Cancelada				VARCHAR(15);	-- Variable contendora de la descripcion del estatus cancelada
	DECLARE Var_Inactiva				VARCHAR(15);	-- Variable contendora de la descripcion del estatus inactiva
	DECLARE Var_Registrada				VARCHAR(15);	-- Variable contendora de la descripcion del estatus registrada

	DECLARE Var_ClienteID				BIGINT(20);		-- Variable contenedora del identificador del cliente
	DECLARE Var_CuentaAhoID				BIGINT(12);		-- Variable contenedora del identificador de la cuenta
	DECLARE Var_NumeroMov				BIGINT(20);		-- Variable contenedora del numero de movimiento
	DECLARE	Var_TipoMovID				CHAR(4); 		-- Variable contenedora del identificador del tipo de movimiento

	-- Asignacion de constantes
	SET Decimal_Cero					:= 0.00;
	SET Entero_Cero						:= 0;
	SET Cadena_Vacia					:= '';
	SET Fecha_Vacia						:= '1900-01-01';
	SET Salida_NO						:= 'N';
	SET Salida_SI						:= 'S';
	SET Var_Si							:= 'S';
	SET EstatusInactivo					:= 'I';
	SET Nat_Cargo       				:= 'C';
	SET Nat_Abono       				:= 'A';

	SET Var_EstatusA					:= 'A';
	SET Var_EstatusB					:= 'B';
	SET Var_EstatusC					:= 'C';
	SET Var_EstatusI					:= 'I';
	SET Var_EstatusR					:= 'R';

	SET Var_Activa						:= 'ACTIVA';
	SET Var_Bloqueada					:= 'BLOQUEADA';
	SET Var_Cancelada					:= 'CANCELADA';
	SET Var_Inactiva					:= 'INACTIVA';
	SET Var_Registrada					:= 'REGISTRADA';

	ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CARGOABONOCUENTAPLDPRO');
				SET Var_Control = 'sqlException';
			END;

		SET Var_ClienteID				:= Entero_Cero;
		SET Par_CuentaAhoIDClie			:= RTRIM(LTRIM(IFNULL(Par_CuentaAhoIDClie, Cadena_Vacia)));
		SET Par_ClienteID				:= IFNULL(Par_ClienteID,Entero_Cero);
		SET Par_Fecha					:= IFNULL(Par_Fecha,Fecha_Vacia);
		SET Par_NatMovimiento			:= RTRIM(LTRIM(IFNULL(Par_NatMovimiento, Cadena_Vacia)));
		SET Par_CantidadMov				:= IFNULL(Par_CantidadMov,Decimal_Cero);
		SET Par_DescripcionMov			:= RTRIM(LTRIM(IFNULL(Par_DescripcionMov,Cadena_Vacia)));
		SET Par_ReferenciaMov			:= RTRIM(LTRIM(IFNULL(Par_ReferenciaMov,Cadena_Vacia)));
		SET Par_TipoMovAhoID			:= RTRIM(LTRIM(IFNULL(Par_TipoMovAhoID,Cadena_Vacia)));


		IF(Par_CuentaAhoIDClie = Cadena_Vacia) THEN
			SET Par_NumErr	:= 	001;
			SET Par_ErrMen	:=	'La Cuenta de Ahorro del Cliente Externo se encuentra vacia';
			SET Var_Control	:=  'CuentaAhoIDClie';
			LEAVE ManejoErrores;
		END IF;

		SELECT		Cli.ClienteID,		Cli.Estatus,			Cue.CuentaAhoID,	Cue.SaldoDispon,	Cue.MonedaID
		INTO		Var_ClienteID,		Var_EstatusCliente,		Var_CuentaAhoID,	Var_SaldoDispon,	Var_MonedaID
		FROM CLIENTES Cli INNER JOIN CUENTASAHO Cue
		ON Cue.ClienteID = Cli.ClienteID
		INNER JOIN PLDCUENTASAHO Pld
		ON Pld.CuentaAhoID = Cue.CuentaAhoID
		WHERE Pld.CuentaAhoIDClie = Par_CuentaAhoIDClie;

		SET Var_ClienteID		:= IFNULL(Var_ClienteID,Entero_Cero);
		SET Var_EstatusCliente	:= IFNULL(Var_EstatusCliente,Cadena_Vacia);
		SET Var_CuentaAhoID		:= IFNULL(Var_CuentaAhoID,Entero_Cero);

		IF(Var_EstatusCliente = Cadena_Vacia) THEN
			SET Par_NumErr	:= 	002;
			SET Par_ErrMen	:=	'El Estatus del Cliente se encuenta vacio';
			SET Var_Control	:=  'EstatusCliente';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_CuentaAhoID = Entero_Cero) THEN
			SET Par_NumErr	:= 	003;
			SET Par_ErrMen	:=	'El Cliente no cuenta con una Cuenta de Ahorro en el SAFI';
			SET Var_Control	:=  'CuentaAhoID';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_EstatusCliente = EstatusInactivo) THEN
			SET Par_NumErr	:= 	004;
			SET Par_ErrMen	:=	'El Cliente Indicado se Encuentra Inactivo.';
			SET Var_Control	:=  'cuentaAhoID' ;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_ClienteID = Entero_Cero) THEN
			SET Par_ClienteID := Var_ClienteID;
		END IF;

		SET Var_NumeroMov := Aud_NumTransaccion;

		IF(Par_Fecha = Fecha_Vacia) THEN
			SET Par_NumErr	:= 	005;
			SET Par_ErrMen	:=	'La Fecha se encuentra vacia';
			SET Var_Control	:=  'Fecha';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_NatMovimiento = Cadena_Vacia) THEN
			SET Par_NumErr	:= 	006;
			SET Par_ErrMen	:=	'La Naturaleza del Movimiento se encuentra vacia';
			SET Var_Control	:=  'NatMovimiento';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_NatMovimiento<>Nat_Cargo)THEN
			IF(Par_NatMovimiento<>Nat_Abono)THEN
				SET Par_NumErr	:=	007;
				SET Par_ErrMen	:=	'La Naturaleza del Movimiento no es correcta.';
				SET Var_Control	:=	'NatMovimiento' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_NatMovimiento<>Nat_Abono)THEN
			IF(Par_NatMovimiento<>Nat_Cargo)THEN
				SET Par_NumErr	:=	008;
				SET Par_ErrMen	:=	'La Naturaleza del Movimiento no es correcta.';
				SET Var_Control	:=	'NatMovimiento' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_CantidadMov = Decimal_Cero) THEN
			SET Par_NumErr	:= 	009;
			SET Par_ErrMen	:=	'La Cantidad del Movimiento se encuentra vacia';
			SET Var_Control	:=  'CantidadMov';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_DescripcionMov = Cadena_Vacia) THEN
			SET Par_NumErr	:= 	010;
			SET Par_ErrMen	:=	'La Descripcion del Movimiento se encuentra vacio';
			SET Var_Control	:=  'DescripcionMov';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_ReferenciaMov = Cadena_Vacia) THEN
			SET Par_NumErr	:= 	011;
			SET Par_ErrMen	:=	'La Referencia del Movimiento se encuentra vacio';
			SET Var_Control	:=  'ReferenciaMov';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_TipoMovAhoID = Cadena_Vacia) THEN
			SET Par_NumErr	:= 	012;
			SET Par_ErrMen	:=	'El Tipo de Movimiento se encuentra vacio';
			SET Var_Control	:=  'ReferenciaMov';
			LEAVE ManejoErrores;
		END IF;

		IF (Var_EstatusCliente = Var_EstatusR) THEN
			SET Var_EstatusDes := Var_Registrada;
		ELSEIF(Var_EstatusCliente = Var_EstatusA) THEN
			SET Var_EstatusDes := Var_Activa;
		ELSEIF(Var_EstatusCliente	= Var_EstatusB)	THEN
			SET Var_EstatusDes := Var_Bloqueada;
		ELSEIF(Var_EstatusCliente	= Var_EstatusI)THEN
			SET Var_EstatusDes := Var_Inactiva;
		ELSEIF( Var_EstatusCliente	= Var_EstatusC)THEN
			SET Var_EstatusDes := Var_Cancelada;
		END IF;

		IF(Par_NatMovimiento=Nat_Cargo) THEN

			IF(Var_EstatusCliente = Var_EstatusA) THEN

				IF(Var_SaldoDispon >= Par_CantidadMov) THEN

					CALL SALDOSAHOACT(
						Var_CuentaAhoID,	Par_NatMovimiento,	Par_CantidadMov,	Salida_NO,			Par_NumErr,
						Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
						Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;

				END IF;

				IF(Var_SaldoDispon < Par_CantidadMov) THEN
					SET Par_NumErr	:=	013;
					SET Par_ErrMen	:=	'Saldo de la Cuenta es insuficiente.';
					SET Var_Control	:=	'CuentaAhoID' ;
					LEAVE ManejoErrores;
				END IF;

			END IF;

			IF(Var_EstatusCliente <> Var_EstatusA) THEN
				SET Par_NumErr	:=	014;
				SET Par_ErrMen	:=	CONCAT('No se Puede hacer movimientos en esta Cuenta. Estatus',Var_EstatusDes, ' Cuenta: ', Var_CuentaAhoID);
				SET Var_Control	:=	'CuentaAhoID' ;
				LEAVE ManejoErrores;
			END IF;

		END IF;

		IF(Par_NatMovimiento=Nat_Abono) THEN

			IF(Var_EstatusCliente = Var_EstatusA) THEN

				CALL SALDOSAHOACT(
					Var_CuentaAhoID, 	Par_NatMovimiento,	Par_CantidadMov,	Salida_NO,			Par_NumErr,
					Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

			END IF;

			IF(Var_EstatusCliente <> Var_EstatusA) THEN
				SET Par_NumErr	:=	015;
				SET Par_ErrMen	:=	CONCAT('No se Puede hacer movimientos en esta Cuenta. Estatus: ',Var_EstatusDes, ' Cuenta: ', Var_CuentaAhoID);
				SET Var_Control	:=	'CuentaAhoID' ;
				LEAVE ManejoErrores;
			END IF;

		END IF;

		SET Aud_FechaActual := CURRENT_TIMESTAMP();
		SET Var_TipoMovID	:= (SELECT TipoMovAhoID
								FROM TIPOSMOVSAHO
								WHERE TipoMovAhoID = Par_TipoMovAhoID AND EsEfectivo = Var_Si);

		SET Var_TipoMovID	:= IFNULL(Var_TipoMovID, Cadena_Vacia);

		-- Proceso para Contar Numero Cargos | Numero de Abonos, se llevan realizando, para Proceso de Alertas Automaticas
		CALL PLDOPEINUALERTNUMPRO(
			Var_CuentaAhoID,	Var_NumeroMov,		Par_Fecha,			Par_NatMovimiento,	Par_CantidadMov,
			Par_DescripcionMov,	Par_ReferenciaMov,	Par_TipoMovAhoID,	Var_MonedaID,		Var_ClienteID,
			Salida_NO, 			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		IF(Var_TipoMovID != Cadena_Vacia) THEN

			CALL EFECTIVOMOVIMIALT(
				Var_CuentaAhoID,	Var_NumeroMov,		Par_Fecha,			Par_NatMovimiento,	Par_CantidadMov,
				Par_DescripcionMov,	Par_ReferenciaMov,	Par_TipoMovAhoID,	Var_MonedaID,		Var_ClienteID,
				Salida_NO, 			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;

		INSERT INTO CUENTASAHOMOV(
			CuentaAhoID,	NumeroMov,		Fecha,			NatMovimiento,	CantidadMov,
			DescripcionMov,	ReferenciaMov,	TipoMovAhoID,	MonedaID,	  	EmpresaID,
			Usuario,		FechaActual,	DireccionIP, 	ProgramaID,		Sucursal,
			NumTransaccion)
		 VALUES(
			Var_CuentaAhoID,	Var_NumeroMov,		Par_Fecha,			Par_NatMovimiento,	Par_CantidadMov,
			Par_DescripcionMov,	Par_ReferenciaMov,	Par_TipoMovAhoID,	Var_MonedaID,		Aud_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

		SET Par_NumErr		:= 000;
		SET Par_ErrMen		:= CONCAT("Movimiento Agregado Exitosamente: ", CONVERT(Var_NumeroMov, CHAR));
		SET Var_Control		:= 'CuentaAhoID' ;
		SET Var_Consecutivo	:= Var_NumeroMov;


	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr			AS	NumErr,
				Par_ErrMen			AS	ErrMen,
				Var_Control			AS	control,
				Var_Consecutivo		AS	consecutivo;
	END IF;

END TerminaStore$$