-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FOLIOSPLANAHORROMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `FOLIOSPLANAHORROMOD`;DELIMITER $$

CREATE PROCEDURE `FOLIOSPLANAHORROMOD`(
-- ==================================================
-- SP PARA ACTUALIZAR LOS REGISTROS DE LOS FOLIOS
-- ==================================================
	Par_FolioID			INT(11),		-- Identificador del Folio
	Par_ClienteID		INT(11),		-- Identificador del Cliente
	Par_CuentaAhoID		BIGINT,			-- Identificador de la Cuenta del cliente
	Par_PlanID			INT(11),		-- Identificador del Plan de Ahorro
	Par_Serie			INT(11),		-- Serie del Folio

	Par_Monto			DECIMAL(12,2),	-- Monto del Folio
	Par_Fecha 			DATE,			-- Fecha de Registro
	Par_Estatus			CHAR(1),		-- Estatus del Folio
	Par_FechaCancela 	DATE,			-- Fecha de Cancelacion del folio
	Par_UsuarioCancela 	VARCHAR(25),	-- Usuario que cancela folio

	Par_NumModif		INT(11),		-- Numero de actualizacion
	Par_Salida			CHAR(1),		-- Tipo de Salida S.- Si N.- No
	INOUT Par_NumErr	INT(11),		-- Numero de Error
	INOUT Par_ErrMen	VARCHAR(400),	-- Mensaje de Error

	/* Parametros de Auditoria */
	Aud_EmpresaID 		INT(11),
	Aud_Usuario 		INT(11),
  	Aud_FechaActual 	DATETIME,
  	Aud_DireccionIP 	VARCHAR(15),
  	Aud_ProgramaID 		VARCHAR(50),
  	Aud_Sucursal 		INT(11),
  	Aud_NumTransaccion 	BIGINT(20)
)
TerminaStore:BEGIN

	/*Declaracion de Variables*/
	DECLARE Var_Control		VARCHAR(50);

	/*Declaracion de constantes*/
	DECLARE Entero_Cero 	INT(11);
	DECLARE	Decimal_Cero	DECIMAL(12,2);
	DECLARE Cadena_Vacia	VARCHAR(100);
	DECLARE Fecha_Vacia		DATE;
	DECLARE SalidaSI		CHAR(1);
	DECLARE ModPrincipal	INT(11);
	DECLARE ModCancela		INT(11);
    DECLARE Estatus_Cancela CHAR(1);
    DECLARE Estatus_Vence	CHAR(1);
    DECLARE ModVence		INT(11);

	/*Asignacion de constantes*/
	SET Entero_Cero 	:= 0;
	SET Decimal_Cero	:= 0.0;
	SET Cadena_Vacia	:= '';
	SET Fecha_Vacia		:= '1900-01-01';
	SET SalidaSI		:= 'S';
	SET ModPrincipal 	:= 1;
	SET ModCancela		:= 2;
    SET Estatus_Cancela := 'C';
    SET Estatus_Vence 	:= 'V';
    SET ModVence		:= 3;

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
							'Disculpe las molestias que esto le ocasiona. Ref: SP-FOLIOSPLANAHORROMOD');
			SET Var_Control	:='sqlException';
		END;

		IF(IFNULL(Par_NumModif,Entero_Cero)=Entero_Cero)THEN
			SET Par_NumErr	:=	01;
			SET Par_ErrMen	:=	'El tipo de modificacion esta vacio.';
			SET Var_Control	:=	'usuarioCancela';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_NumModif=ModPrincipal)THEN
			IF(IFNULL(Par_FolioID,Entero_Cero)=Entero_Cero)THEN
				SET Par_NumErr	:=	02;
				SET Par_ErrMen	:=	'El Folio esta vacio.';
				SET Var_Control	:=	'clienteID';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_ClienteID,Entero_Cero)=Entero_Cero)THEN
				SET Par_NumErr	:=	03;
				SET Par_ErrMen	:=	'El cliente esta vacio.';
				SET Var_Control	:=	'clienteID';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_CuentaAhoID,Entero_Cero)=Entero_Cero)THEN
				SET Par_NumErr	:=	04;
				SET Par_ErrMen	:=	'La cuenta esta vacia.';
				SET Var_Control	:=	'clienteID';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_PlanID,Entero_Cero)=Entero_Cero)THEN
				SET Par_NumErr	:=	05;
				SET Par_ErrMen	:=	'El Plan de Ahorro esta vacio.';
				SET Var_Control	:=	'planID';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_Serie,Entero_Cero)=Entero_Cero)THEN
				SET Par_NumErr	:=	06;
				SET Par_ErrMen	:=	'La serie del folio esta vacia.';
				SET Var_Control	:=	'serie';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_Monto,Decimal_Cero)=Decimal_Cero)THEN
				SET Par_NumErr	:=	07;
				SET Par_ErrMen	:=	'El monto base esta vacio.';
				SET Var_Control	:=	'montoBase';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_Fecha,Fecha_Vacia)=Fecha_Vacia)THEN
				SET Par_NumErr	:=	08;
				SET Par_ErrMen	:=	'La Fecha de registro esta vacia.';
				SET Var_Control	:=	'fecha';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_Estatus,Fecha_Vacia)=Fecha_Vacia)THEN
				SET Par_NumErr	:=	09;
				SET Par_ErrMen	:=	'El estatus esta vacio.';
				SET Var_Control	:=	'estatus';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_FechaCancela,Fecha_Vacia)=Fecha_Vacia)THEN
				SET Par_NumErr	:=	10;
				SET Par_ErrMen	:=	'La fecha de cancelacion esta vacia.';
				SET Var_Control	:=	'fechaCancela';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_UsuarioCancela,Fecha_Vacia)=Fecha_Vacia)THEN
				SET Par_NumErr	:=	11;
				SET Par_ErrMen	:=	'El usuario de cancelacion esta vacio.';
				SET Var_Control	:=	'usuarioCancela';
				LEAVE ManejoErrores;
			END IF;

			UPDATE FOLIOSPLANAHORRO SET
				ClienteID 		= Par_ClienteID,
				CuentaAhoID 	= Par_CuentaAhoID,
				PlanID 			= Par_PlanID,
				Serie 			= Par_Serie,
				Monto 			= Par_Monto,
				Fecha 			= Par_Fecha,
				Estatus 		= Par_Estatus,
				FechaCancela 	= Par_FechaCancela,
				UsuarioCancela 	= Par_UsuarioCancela,
				EmpresaID 		= Aud_EmpresaID,
				Usuario 		= Aud_Usuario,
				FechaActual 	= Aud_FechaActual,
				DireccionIP 	= Aud_DireccionIP,
				ProgramaID 		= Aud_ProgramaID,
				Sucursal 		= Aud_Sucursal,
				NumTransaccion 	= Aud_NumTransaccion
			WHERE FolioID=Par_FolioID;

		ELSEIF(Par_NumModif=ModCancela)THEN
			IF(IFNULL(Par_CuentaAhoID,Entero_Cero)=Entero_Cero)THEN
				SET Par_NumErr	:=	04;
				SET Par_ErrMen	:=	'La cuenta esta vacia.';
				SET Var_Control	:=	'clienteID';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_Monto,Decimal_Cero)=Decimal_Cero)THEN
				SET Par_NumErr	:=	07;
				SET Par_ErrMen	:=	'El monto base esta vacio.';
				SET Var_Control	:=	'montoBase';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_Fecha,Fecha_Vacia)=Fecha_Vacia)THEN
				SET Par_NumErr	:=	08;
				SET Par_ErrMen	:=	'La Fecha de registro esta vacia.';
				SET Var_Control	:=	'fecha';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_Estatus,Fecha_Vacia)=Fecha_Vacia)THEN
				SET Par_NumErr	:=	09;
				SET Par_ErrMen	:=	'El estatus esta vacio.';
				SET Var_Control	:=	'estatus';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_FechaCancela,Fecha_Vacia)=Fecha_Vacia)THEN
				SET Par_NumErr	:=	10;
				SET Par_ErrMen	:=	'La fecha de cancelacion esta vacia.';
				SET Var_Control	:=	'fechaCancela';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_UsuarioCancela,Fecha_Vacia)=Fecha_Vacia)THEN
				SET Par_NumErr	:=	11;
				SET Par_ErrMen	:=	'El usuario de cancelacion esta vacio.';
				SET Var_Control	:=	'usuarioCancela';
				LEAVE ManejoErrores;
			END IF;

			UPDATE FOLIOSPLANAHORRO SET
				Estatus 		= Estatus_Cancela,
				FechaCancela 	= Par_FechaCancela,
				UsuarioCancela 	= Par_UsuarioCancela,
				FechaActual 	= Aud_FechaActual
			WHERE CuentaAhoID = Par_CuentaAhoID
			AND Fecha=Par_Fecha
            AND NumTransaccion = Aud_NumTransaccion;
		ELSEIF(Par_NumModif=ModVence)THEN
			UPDATE FOLIOSPLANAHORRO SET
				Estatus 		= Estatus_Vence,
				FechaActual 	= Aud_FechaActual
			WHERE CuentaAhoID = Par_CuentaAhoID
			AND Fecha=Par_Fecha
            AND NumTransaccion = Aud_NumTransaccion;
        END IF;

	END ManejoErrores;

	IF(Par_Salida =SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen  AS ErrMen,
				Var_Control AS control;
	END IF;

END TerminaStore$$