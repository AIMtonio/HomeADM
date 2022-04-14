-- SP REGIFALTANTESOBRANTEALT
DELIMITER ;

DROP PROCEDURE IF EXISTS REGIFALTANTESOBRANTEALT;

DELIMITER $$

CREATE PROCEDURE REGIFALTANTESOBRANTEALT(
	-- Store Procedure para dar de Alta los datos de ajuste de sobrante y faltante de una ventanilla
	Par_Monto						DECIMAL(14,2),		-- Monto total de ajuste
	Par_SucursalID					INT(11),			-- Sucursal donde se encuentra la caja
	Par_NumCaja						INT(11),			-- Número de la caja que realiza la transacción
	Par_DescripcionCaja				VARCHAR(100),		-- Indica la descripción de la caja
	Par_UsuarioID					INT(11),			-- Usuario asignado a la caja

	Par_UsuarioAutoriza				VARCHAR(45),		-- Usuario que va autorizar el ajuste
	Par_TipoOperacion				CHAR(1),			-- Indica si es ajuste por faltante o por sobrante.F=Ajuste por Faltante, S=Ajuste por Sobrante
	Par_Salida						CHAR(1),			-- Parametro para salida de datos
	INOUT Par_NumErr				INT(11),			-- Numero de Error
	INOUT Par_ErrMen				VARCHAR(400),		-- Mensaje de Error

	Aud_EmpresaID					INT(11),			-- Parametros de Auditoria
	Aud_Usuario						INT(11),			-- Parametros de Auditoria
	Aud_FechaActual					DATETIME,			-- Parametros de Auditoria
	Aud_DireccionIP					VARCHAR(15),		-- Parametros de Auditoria
	Aud_ProgramaID					VARCHAR(50),		-- Parametros de Auditoria
	Aud_Sucursal					INT(11),			-- Parametros de Auditoria
	Aud_NumTransaccion				BIGINT(20)			-- Parametros de Auditoria

)TerminaStore:BEGIN
	-- Declaracion de Constantes
	DECLARE	Entero_Cero					INT(11);			-- Entero vacio
	DECLARE Cadena_Vacia				CHAR(1);			-- Cadena vacia
	DECLARE Fecha_Vacia					DATETIME;			-- Fecha Vacia
	DECLARE Decimal_Cero				DECIMAL(14,2);		-- Decimal Cero
	DECLARE SalidaSI					CHAR(1);			-- Salida Si
	DECLARE TipoOperaFaltante			CHAR(1);			-- Tipo de operacion de Ajuste por Faltante
	DECLARE TipoOperaSobrante			CHAR(1);			-- Tipo de operacion de Ajuste por Sobrante
	DECLARE EstatusPendiente			CHAR(1);			-- Estatus pendiente

	-- Declaracion de Variables
	DECLARE Var_Control					VARCHAR(50);		-- Variable para manejar el control del sql
	DECLARE	Var_Consecutivo				BIGINT(20);			-- Variable Consecutivo
	DECLARE Var_CajaID					INT(11);			-- Variable para guardar el numero de caja
	DECLARE Var_SucursalID				INT(11);			-- Variable para guardar el numero de la Sucursal
	DECLARE Var_UsuarioID				INT(11);			-- Variable para guardar el numero del Usuario
	DECLARE Var_UsuarioAutoriza			INT(11);			-- Variable para guardar el numero del Usuario que autoriza
	DECLARE Var_RegFaltanteSobranteID	INT(11);			-- Variable para guardar el ID de la tabla consultada
	DECLARE Var_MontoMaximoSobra		DECIMAL(12,2);		-- Monto maximo para el registro de sobrante
	DECLARE Var_MontoMaximoFalta		DECIMAL(12,2);		-- Monto maximo para el registro de faltante

	-- Asignacion de Constantes
	SET Entero_Cero						= 0;				-- Asignacion de Entero Vacio
	SET	Cadena_Vacia					= '';				-- Asignacion de Cadena Vacia
	SET Fecha_Vacia						= '1900-01-01';		-- Asignacion de Fecha Vacia
	SET Decimal_Cero					= 0.0;				-- Decimal Cero
	SET SalidaSI						= 'S';				-- Asignacion de Salida SI
	SET TipoOperaFaltante				= 'F';				-- Tipo de operacion de Ajuste por Faltante
	SET TipoOperaSobrante				= 'S';				-- Tipo de operacion de Ajuste por Sobrante
	SET EstatusPendiente				= 'P';				-- Estatus pendiente

	-- Declaracion de Valores Default
	SET Par_Monto						:= IFNULL(Par_Monto, Decimal_Cero);
	SET Par_SucursalID					:= IFNULL(Par_SucursalID, Entero_Cero);
	SET Par_NumCaja						:= IFNULL(Par_NumCaja, Entero_Cero);
	SET Par_DescripcionCaja				:= IFNULL(Par_DescripcionCaja, Cadena_Vacia);
	SET Par_UsuarioID					:= IFNULL(Par_UsuarioID, Entero_Cero);
	SET Par_UsuarioAutoriza				:= IFNULL(Par_UsuarioAutoriza, Cadena_Vacia);
	SET Par_TipoOperacion				:= IFNULL(Par_TipoOperacion, Cadena_Vacia);

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
								'esto le ocasiona. Ref: SP-REGIFALTANTESOBRANTEALT');
				SET Var_Control = 'SQLEXCEPTION';
			END;

		IF(Par_Monto <= Decimal_Cero) THEN
			SET Par_NumErr	:= 1;
			SET Par_ErrMen	:= 'Especifique el Monto mayor a cero.';
			SET Var_Control	:= 'monto';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_SucursalID = Entero_Cero) THEN
			SET Par_NumErr	:= 2;
			SET Par_ErrMen	:= 'Especifique el Numero de la Sucursal Asignada a la Caja.';
			SET Var_Control	:= 'sucursal';
			LEAVE ManejoErrores;
		END IF;

		SELECT SucursalID
			INTO Var_SucursalID
				FROM SUCURSALES
					WHERE SucursalID = Par_SucursalID;

		IF(IFNULL(Var_SucursalID,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr	:= 3;
			SET Par_ErrMen	:= 'El Numero de la Sucursal no Existe.';
			SET Var_Control	:= 'sucursal';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_NumCaja = Entero_Cero) THEN
			SET Par_NumErr	:= 4;
			SET Par_ErrMen	:= 'Especifique el Numero de Caja.';
			SET Var_Control	:= 'numCaja';
			LEAVE ManejoErrores;
		END IF;

		SELECT CajaID
			INTO Var_CajaID
				FROM CAJASVENTANILLA
					WHERE CajaID = Par_NumCaja
						AND SucursalID = Par_SucursalID;

		IF(IFNULL(Var_CajaID,Entero_Cero )= Entero_Cero) THEN
			SET Par_NumErr	:= 5;
			SET Par_ErrMen	:= 'El Numero de la Caja No existe o No se Encuentra Asignada a la Sucursal.';
			SET Var_Control	:= 'cajaID';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_DescripcionCaja = Cadena_Vacia) THEN
			SET Par_NumErr	:= 6;
			SET Par_ErrMen 	:= 'Especifique la Descripcion de la Caja.';
			SET Var_Control	:= 'descripcionCaja';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_UsuarioID = Entero_Cero) THEN
			SET Par_NumErr	:= 7;
			SET Par_ErrMen	:= 'Especifique el Numero de Usuario Asignada a la Caja.';
			SET Var_Control	:= 'usuarioID';
			LEAVE ManejoErrores;
		END IF;

		SELECT UsuarioID
			INTO Var_UsuarioID
				FROM USUARIOS
					WHERE UsuarioID = Par_UsuarioID;

		IF(IFNULL(Var_UsuarioID,Entero_Cero )= Entero_Cero) THEN
			SET Par_NumErr	:= 8;
			SET Par_ErrMen	:= 'El Numero Usuario no Existe.';
			SET Var_Control	:= 'usuarioID';
			LEAVE ManejoErrores;
		END IF;

		SET Var_UsuarioID := Entero_Cero;

		SELECT UsuarioID
			INTO Var_UsuarioID
				FROM CAJASVENTANILLA
					WHERE CajaID = Par_NumCaja
					AND UsuarioID = Par_UsuarioID;

		IF(IFNULL(Var_UsuarioID,Entero_Cero ) = Entero_Cero) THEN
			SET Par_NumErr	:= 9;
			SET Par_ErrMen	:= 'El Numero del Usuario No se Encuentra Asignada a la Caja.';
			SET Var_Control	:= 'usuarioID';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_UsuarioAutoriza = Cadena_Vacia) THEN
			SET Par_NumErr	:= 10;
			SET Par_ErrMen	:= 'Especifique el Numero de Usuario que Autoriza.';
			SET Var_Control	:= 'usuarioAutoriza';
			LEAVE ManejoErrores;
		END IF;

		SELECT UsuarioID
			INTO Var_UsuarioAutoriza
				FROM USUARIOS
					WHERE Clave = Par_UsuarioAutoriza;

		IF(IFNULL(Var_UsuarioAutoriza,Entero_Cero )= Entero_Cero) THEN
			SET Par_NumErr	:= 11;
			SET Par_ErrMen	:= 'La Clave del Usuario que Autoriza no Existe.';
			SET Var_Control	:= 'usuarioAutoriza';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_TipoOperacion = Cadena_Vacia) THEN
			SET Par_NumErr	:= 12;
			SET Par_ErrMen 	:= 'Especifique el Tipo de Operacion.';
			SET Var_Control	:= 'tipoOperacion';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_TipoOperacion NOT IN(TipoOperaFaltante,TipoOperaSobrante)) THEN
			SET Par_NumErr	:= 13;
			SET Par_ErrMen 	:= 'Especifique un Tipo de Operacion Valido: F=Ajuste por Faltante, S=Ajuste por Sobrante.';
			SET Var_Control	:= 'tipoOperacion';
			LEAVE ManejoErrores;
		END IF;
		
		SELECT  MontoMaximoSobra,			MontoMaximoFalta
			INTO Var_MontoMaximoSobra,		Var_MontoMaximoFalta
			FROM PARAMFALTASOBRA
            WHERE SucursalID = Par_SucursalID;
            
		IF(Par_TipoOperacion = TipoOperaFaltante AND Par_Monto > Var_MontoMaximoFalta) THEN
			SET Par_NumErr  := 5;
			SET Par_ErrMen  := CONCAT("Se Excede el Monto Maximo  por Fantante.");
			SET Var_Control := 'montoFaltante' ;
			LEAVE ManejoErrores;
		END IF;
		
		IF(Par_TipoOperacion = TipoOperaSobrante AND Par_Monto > Var_MontoMaximoSobra) THEN
			SET Par_NumErr  := 5;
			SET Par_ErrMen  := CONCAT("Se Excede el Monto Maximo  por Sobrante.");
			SET Var_Control := 'montoSobrante' ;
			LEAVE ManejoErrores;
		END IF;

		CALL FOLIOSAPLICAACT('REGISTROFALTANTESOBRANTE', Var_RegFaltanteSobranteID);

		INSERT INTO REGISTROFALTANTESOBRANTE (	RegFaltanteSobranteID,		Monto,					NumCaja,			DescripcionCaja,		UsuarioID,
												SucursalID,					UsuarioAutoriza,		TipoOperacion,		Estatus,				EmpresaID,
												Usuario,					FechaActual,			DireccionIP,		ProgramaID,				Sucursal,
												NumTransaccion)

									VALUES (	Var_RegFaltanteSobranteID,	Par_Monto,				Par_NumCaja,		Par_DescripcionCaja,	Par_UsuarioID,
												Par_SucursalID,				Par_UsuarioAutoriza,	Par_TipoOperacion,	EstatusPendiente,		Aud_EmpresaID,
												Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,
												Aud_NumTransaccion);

		-- El registro se inserto correctamente
		SET Par_NumErr	:= 0;
		SET Par_ErrMen	:= 'Informacion Registrada correctamente';
		SET Var_Consecutivo	:= Var_RegFaltanteSobranteID;
		SET Var_Control	:= 'registroCompleto';
	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida =SalidaSI) THEN
		SELECT 	Par_NumErr			AS 	NumErr,
				Par_ErrMen			AS	ErrMen,
				Var_Control			AS	control,
				Var_Consecutivo		AS	consecutivo;
	END IF;
END TerminaStore$$
