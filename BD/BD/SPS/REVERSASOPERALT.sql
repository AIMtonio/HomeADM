-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REVERSASOPERALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `REVERSASOPERALT`;DELIMITER $$

CREATE PROCEDURE `REVERSASOPERALT`(
	/*SP PARA DAR DE ALTA EL MOVIMIENTO OPERATIVO DE LA REVERSA DE LAS OP DE INGRESO DE OPE*/
	Par_TransaccionID 		INT(11),
	Par_Motivo				VARCHAR(200),
	Par_DescripcionOper		VARCHAR(100),
	Par_TipoOperacion		INT(11),
	Par_Referencia			VARCHAR(50),

	Par_Monto				DECIMAL(14,2),
	Par_CajaID				INT(11),
	Par_SucursalID			INT(11),
	Par_Fecha				DATE,
	Par_ClaveUsuarioAut		VARCHAR(45),

	Par_ContraseniaAut		VARCHAR(45),
	Par_UsuarioID			INT(11),
	Par_Cambio				DECIMAL(14,2),
	Par_Efectivo			DECIMAL(14,2),
	Par_Salida				CHAR(1),

	INOUT Par_NumErr		INT,
	INOUT Par_ErrMen		VARCHAR(400),
	/*Parametros de Auditoria*/
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,

	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore:BEGIN
	-- Declaración de Constantes
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Entero_Cero			INT(11);
	DECLARE Str_SI				CHAR(1);
	DECLARE Str_NO				CHAR(1);
	DECLARE OpeCajSalDepCta		INT;
	DECLARE OpeCajDepGarLiq		INT;
	DECLARE TipoMovAhoIDGL		INT;

	-- Declaracion de variables
	DECLARE	Var_Clave		VARCHAR(45);
	DECLARE Var_Contrasenia VARCHAR(45);
	DECLARE Var_Control		VARCHAR(50);
	DECLARE Var_Transaccion	INT(11);
	DECLARE Var_UsuarioID	INT(11);

	-- Asignación de Constantes

	SET Cadena_Vacia        := '';              -- Cadena Vacia
	SET Entero_Cero         := 0;  				-- Entero Cero
	SET Str_SI              := 'S';				-- String Si
	SET Str_NO              := 'N';				-- String No
	SET OpeCajSalDepCta		:=21;				-- Corresponde con CAJATIPOSOPERA  deposito de efectivo
	SET OpeCajDepGarLiq		:=22;				-- Corresponde con CAJATIPOSOPERA deposito de garantia Liquida
	SET TipoMovAhoIDGL		:=102;				-- Corresponde con TIPOSMOVSAHO deposito de Garantia Líquida

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-REVERSASOPERALT');
		END;

		SELECT TransaccionID INTO Var_Transaccion
			FROM REVERSASOPER
				WHERE Par_TransaccionID=TransaccionID;


		SET Var_Transaccion	:=IFNULL(Var_Transaccion,Entero_Cero);
		IF(Var_Transaccion !=Entero_Cero)THEN
				SET	Par_NumErr 	:= 1;
				SET	Par_ErrMen	:= CONCAT("La Reversa del folio ",Par_TransaccionID," ya Existe");
				SET Var_Control := 'tipoOperacion' ;
				LEAVE ManejoErrores;
		END IF;


		IF EXISTS(SELECT  TransaccionID
			FROM REVERSASOPER
			WHERE  SucursalID=Par_SucursalID
				AND CajaID= Par_CajaID
				AND Fecha=Par_Fecha
				AND TipoOperacion =Par_TipoOperacion
				AND TransaccionID= Par_TransaccionID)THEN

				SET	Par_NumErr 		:= 2;
				SET	Par_ErrMen	:= CONCAT("La Transaccion ",Par_TransaccionID," ya fue reversada");
				SET Var_Control  := 'tipoOperacion' ;
				LEAVE ManejoErrores;
		END IF;

		SELECT  Clave, Contrasenia, UsuarioID  INTO  Var_Clave, Var_Contrasenia, Var_UsuarioID
			FROM USUARIOS
			WHERE Clave = Par_ClaveUsuarioAut;

		SET Var_Clave		:=IFNULL(Var_Clave,Cadena_Vacia);
		SET Var_Contrasenia	:=IFNULL(Var_Contrasenia,Cadena_Vacia);
		SET Var_UsuarioID	:=IFNULL(Var_UsuarioID,Entero_Cero);

		IF(Var_Contrasenia != Par_ContraseniaAut)THEN
			SET	Par_NumErr 	:= 3;
			SET	Par_ErrMen	:= CONCAT("La Contraseña no Coincide con el Usuario Indicado ");
			SET Var_Control  := 'tipoOperacion' ;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_UsuarioID=Var_UsuarioID)THEN
			SET	Par_NumErr 	:= 4;
				SET	Par_ErrMen	:= CONCAT("El usuario que realiza la Transaccion no puede ser el mismo que  Autoriza");
				SET Var_Control := 'tipoOperacion' ;
				LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS(SELECT Numero
						FROM CAJATIPOSOPERA
						WHERE Par_TipoOperacion=Numero)THEN

				SET	Par_NumErr 	:= 5;
				SET	Par_ErrMen	:= CONCAT("El tipo de Operacion ",Par_TipoOperacion," no existe");
				SET Var_Control := 'tipoOperacion' ;
				LEAVE ManejoErrores;
		END IF;
		IF NOT EXISTS(SELECT SucursalID
						FROM SUCURSALES
						WHERE SucursalID=Par_SucursalID)THEN
				SET	Par_NumErr 	:= 6;
				SET	Par_ErrMen	:= CONCAT("La sucursal indicada no Existe");
				SET Var_Control := 'tipoOperacion' ;
				LEAVE ManejoErrores;
		END IF;

		/*  se valida si la reversa es de un deposito a cuenta, Garantia liquida  para eliminar los registros insertados en.
			EFECTIVOMOVS*/
		IF((Par_TipoOperacion = OpeCajSalDepCta) )THEN
			DELETE FROM EFECTIVOMOVS
					WHERE NumeroMov = Par_TransaccionID
						AND Fecha = Par_Fecha;
		  ELSEIF(Par_TipoOperacion = OpeCajDepGarLiq)THEN
			DELETE FROM EFECTIVOMOVS
					WHERE NumeroMov = Par_TransaccionID
						AND Fecha = Par_Fecha
						AND TipoMovAhoID=TipoMovAhoIDGL;
		END IF;

		SET Aud_FechaActual:=NOW();

		INSERT INTO REVERSASOPER (
				TransaccionID,		Motivo,				DescripcionOper,		TipoOperacion,		Referencia,
				Monto,				CajaID,				SucursalID,				Fecha,				ClaveUsuarioAut,
				ContraseniaAut,		UsuarioID,			Efectivo,				Cambio,				Hora,
				EmpresaID,			Usuario,			FechaActual,			DireccionIP,		ProgramaID,
				Sucursal,			NumTransaccion)
			VALUES(
				Par_TransaccionID,	Par_Motivo,			Par_DescripcionOper,	Par_TipoOperacion,	Par_Referencia,
				Par_Monto,			Par_CajaID,			Par_SucursalID,			Par_Fecha,			Par_ClaveUsuarioAut,
				Par_ContraseniaAut,	Par_UsuarioID,		Par_Efectivo,			Par_Cambio,			CURRENT_TIME(),
				Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,		Aud_NumTransaccion);

		SET Par_NumErr := 0;
		SET Par_ErrMen := "Reversa Agregada con Exito";
		SET Var_Control  := 'tipoOperacion' ;

	END ManejoErrores;  -- End del Handler de Errores
	IF (Par_Salida = Str_SI) THEN
		 SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Entero_Cero AS consecutivo;
	END IF;

END TerminaStore$$