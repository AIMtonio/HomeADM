-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CHEQUESCANCELADOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CHEQUESCANCELADOSALT`;DELIMITER $$

CREATE PROCEDURE `CHEQUESCANCELADOSALT`(
# ===========================================================
# -------- SP PARA REGISTRAR LOS CHEQUES CANCELADOS----------
# ===========================================================
	Par_ChequeCanID			INT(11), 		-- Consecutivo --
	Par_NumTransaccion		BIGINT(20),
	Par_CajaID				INT(11),
	Par_SucursaID			INT(11),
	Par_Fecha				DATE,			-- Fecha de cancelacion --

	Par_MotivoCancela		VARCHAR(200),
	Par_NumeroCheque		INT(10),		-- Numero de cheque cancelado --
	Par_UsuarioAutoriza		VARCHAR(45), 	-- Clave de usuario que autoriza la cancelacion del cheque --
	Par_Password			VARCHAR(45),
	Par_EmitidoEn			CHAR(1),

	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore:BEGIN

	-- Declaracion de constantes
	DECLARE Entero_Cero 		INT(11);
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Salida_SI			CHAR(1);
	DECLARE EnVentanilla		CHAR(1);

	-- Declaracion de Variables
	DECLARE VarControl			VARCHAR(45);
	DECLARE Var_UsuarioAutoID	INT(11); -- ID de usuario registrado en tabla USUARIOS --
	DECLARE Var_Password		VARCHAR(45);
	DECLARE Var_RolCancelaCheq	INT(11); -- Rol para Autorizar la Cancelacion del Cheque --
	DECLARE Var_RolID			INT(11); -- Rol del Usuario que intenta Autorizar la cancelacion--

	-- Asignacion de constantes
	SET Entero_Cero		:=0;	-- Constante Cero --
	SET Cadena_Vacia	:='';	-- Cadena Vacia --
	SET Salida_SI		:='S';	-- Constante S --
	SET EnVentanilla	:='V'; 	-- Cheque emitido en ventanilla --

	ManejoErrores : BEGIN 	#bloque para manejar los posibles errores
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = '999';
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion.' ,
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CHEQUESCANCELADOSALT.');
			SET VarControl = 'sqlException' ;
		END;


		SELECT UsuarioID, Contrasenia, RolID
			INTO Var_UsuarioAutoID, Var_Password, Var_RolID
			FROM USUARIOS
			WHERE Clave = Par_UsuarioAutoriza;

		SET Var_UsuarioAutoID 	:=IFNULL(Var_UsuarioAutoID,Entero_Cero);
		SET Var_Password 		:=IFNULL(Var_Password,Cadena_Vacia);
		SET Var_RolID			:=IFNULL(Var_RolID,Entero_Cero);

		SELECT RolCancelaCheque 	INTO Var_RolCancelaCheq
			FROM PARAMETROSCAJA;

		SET Var_RolCancelaCheq := IFNULL(Var_RolCancelaCheq, Entero_Cero);

		IF(IFNULL(Par_NumTransaccion,Entero_Cero)=Entero_Cero)THEN
			SET Par_NumErr  :=01;
			SET Par_ErrMen	:='El Numero de Transaccion Esta Vacio';
			SET VarControl	:='cancelarCheque';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_NumeroCheque,Entero_Cero)=Entero_Cero)THEN
			SET Par_NumErr	:=02;
			SET Par_ErrMen	:='El Numero de Cheque Esta Vacio';
			SET Varcontrol	:='numCheque';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_EmitidoEn = EnVentanilla)THEN
			IF(IFNULL(Par_UsuarioAutoriza,Cadena_Vacia)=Cadena_Vacia)THEN
				SET Par_NumErr	:=03;
				SET Par_ErrMen	:='El Usuario Esta Vacio';
				SET VarControl	:='usuarioAutoriza';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_Password,Cadena_Vacia)=Cadena_Vacia)THEN
				SET Par_NumErr	:=04;
				SET Par_ErrMen	:='La Contrasenia Esta Vacia';
				SET VarControl	:='passwdAutoriza';
				LEAVE ManejoErrores;
			END IF;

			IF (Var_RolCancelaCheq <> Var_RolID) THEN
				SET Par_NumErr	:=14;
				SET Par_ErrMen	:='El Usuario que Autoriza no Tiene el Rol Para la Cancelacion';
				SET VarControl	:='usuarioAutoriza';
				LEAVE ManejoErrores;
			END IF;

			IF(Var_UsuarioAutoID = Entero_Cero)THEN
				SET Par_NumErr	:=16;
				SET Par_ErrMen	:='El Usuario es Incorrecto';
				SET VarControl	:='usuarioAutoriza';
				LEAVE ManejoErrores;
			END IF;

			IF(Var_UsuarioAutoID != Entero_Cero)THEN
				IF( Par_Password !=  Var_Password)THEN
					SET Par_NumErr	:=17;
					SET Par_ErrMen	:='La Contrasenia es Incorrecta';
					SET VarControl	:='passwdAutoriza';
					LEAVE ManejoErrores;
					END IF;
			END IF;
		END IF;
		SET Aud_FechaActual := NOW();

		INSERT INTO CHEQUESCANCELADOS(
			ChequeCanceladoID,	 	TransaccionID,		CajaID,					Sucursal,			Fecha,
			UsuarioID, 				MotivoCancelacion,	NumeroCheque,			EmpresaID,			Usuario,
			FechaActual,			DireccionIp,		ProgramaID,				SucursalID,			NumTransaccion)
		VALUES(
			Par_ChequeCanID,		Par_NumTransaccion, Par_CajaID, 			Par_SucursaID,		Par_Fecha,
			Var_UsuarioAutoID,		Par_MotivoCancela, 	Par_NumeroCheque,		Par_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

		SET Par_NumErr  := 000;
		SET Par_ErrMen  := CONCAT('El Cheque ',Par_NumeroCheque,' fue  Cancelado Exitosamente.');
		SET varControl	:= 'institucionIDCan';

	END ManejoErrores ; #fin del manejador de errores

	IF(Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr  AS NumErr,
				Par_ErrMen	 AS ErrMen,
				varControl	 AS control,
				Entero_Cero	 AS consecutivo;
	END IF;

END TerminaStore$$