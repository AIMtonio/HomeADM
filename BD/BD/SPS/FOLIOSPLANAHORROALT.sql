-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FOLIOSPLANAHORROALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `FOLIOSPLANAHORROALT`;
DELIMITER $$

CREATE PROCEDURE `FOLIOSPLANAHORROALT`(
-- ======================================================================
-- SP PARA EL ALTA DE FOLIOS POR CLIENTE DE ACUERDO AL PLAN DE AHORRO
-- ======================================================================
	Par_ClienteID			INT(11),		-- Identificador del Cliente
	Par_CuentaAhoID			BIGINT,			-- Identificador de la Cuenta del cliente
	Par_PlanID				INT(11),		-- Identificador del Plan de Ahorro
	Par_Serie				INT(11),		-- Serie del Folio
	Par_Monto				DECIMAL(12,2),	-- Monto del Folio

	Par_Fecha 				DATE,			-- Fecha de Registro
	Par_Estatus				CHAR(1),		-- Estatus del Folio
	Par_FechaCancela 		DATE,			-- Fecha de Cancelacion del folio
	Par_UsuarioCancela 		VARCHAR(25),	-- Usuario que cancela folio

	Par_Salida			CHAR(1),			-- Tipo de Salida S.- Si N.- No
	INOUT Par_NumErr	INT(11),			-- Numero de Error
	INOUT Par_ErrMen	VARCHAR(400),		-- Mensaje de Error

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

	/*Declaracion de constantes*/
	DECLARE Entero_Cero 	INT(11);
	DECLARE	Decimal_Cero	DECIMAL(12,2);
	DECLARE Cadena_Vacia	VARCHAR(100);
	DECLARE Fecha_Vacia		DATE;
	DECLARE SalidaSI		CHAR(1);
	DECLARE Var_Control		VARCHAR(100);
	DECLARE Entero_Uno		INT(11);

	/*Delcarión de variables*/
	DECLARE Var_FechaVenc	DATE;
	DECLARE Var_FechaLibe	DATE;
	DECLARE Var_DiasDes		INT(11);

	/*Asignacion de constantes*/
	SET Entero_Cero 	:= 0;
	SET Decimal_Cero	:= 0.0;
	SET Cadena_Vacia	:= '';
	SET Fecha_Vacia		:= '1900-01-01';
	SET SalidaSI		:= 'S';
	SET Entero_Uno		:= 1;

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
							'Disculpe las molestias que esto le ocasiona. Ref: SP-FOLIOSPLANAHORROALT');
			SET Var_Control	:='sqlException';
		END;

		IF(IFNULL(Par_ClienteID,Entero_Cero)=Entero_Cero)THEN
			SET Par_NumErr	:=	01;
			SET Par_ErrMen	:=	'El cliente esta vacio.';
			SET Var_Control	:=	'clienteID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_CuentaAhoID,Entero_Cero)=Entero_Cero)THEN
			SET Par_NumErr	:=	02;
			SET Par_ErrMen	:=	'La cuenta esta vacia.';
			SET Var_Control	:=	'clienteID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_PlanID,Entero_Cero)=Entero_Cero)THEN
			SET Par_NumErr	:=	03;
			SET Par_ErrMen	:=	'El Plan de Ahorro esta vacio.';
			SET Var_Control	:=	'planID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Serie,Entero_Cero)=Entero_Cero)THEN
			SET Par_NumErr	:=	04;
			SET Par_ErrMen	:=	'La serie del folio esta vacia.';
			SET Var_Control	:=	'serie';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Monto,Decimal_Cero)=Decimal_Cero)THEN
			SET Par_NumErr	:=	05;
			SET Par_ErrMen	:=	'El monto base esta vacio.';
			SET Var_Control	:=	'montoBase';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Fecha,Fecha_Vacia)=Fecha_Vacia)THEN
			SET Par_NumErr	:=	06;
			SET Par_ErrMen	:=	'La Fecha de registro esta vacia.';
			SET Var_Control	:=	'fecha';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Estatus,Fecha_Vacia)=Fecha_Vacia)THEN
			SET Par_NumErr	:=	07;
			SET Par_ErrMen	:=	'El estatus esta vacio.';
			SET Var_Control	:=	'estatus';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_FechaCancela,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_NumErr	:=	08;
			SET Par_ErrMen	:=	'La fecha de cancelacion esta vacia.';
			SET Var_Control	:=	'fechaCancela';
			LEAVE ManejoErrores;
		END IF;

		/*Fecha vencimiento*/
		SELECT Tp.DiasDesbloqueo
			INTO Var_DiasDes
		FROM TIPOSPLANAHORRO Tp
		WHERE Tp.PlanID = Par_PlanID
		LIMIT Entero_Uno;

		IF(IFNULL(Par_FechaCancela,Entero_Cero)=Entero_Cero)THEN
			SET Par_NumErr	:=	09;
			SET Par_ErrMen	:=	'El Plan de Ahorro no tiene días de desboqueo';
			SET Var_Control	:=	'PlanID';
			LEAVE ManejoErrores;
		END IF;

		SET Var_FechaVenc := DATE_ADD(Par_Fecha, INTERVAL Var_DiasDes DAY);

		SET Var_FechaLibe := FUNCIONDIAHABIL(Var_FechaVenc, Entero_Cero, Entero_Uno);

		INSERT INTO FOLIOSPLANAHORRO (
			ClienteID,			CuentaAhoID,		PlanID,				Serie,				Monto,
			Fecha,				Estatus,			FechaCancela,		UsuarioCancela,		EmpresaID,
			FechaVencimiento,	FechaLiberacion,	Usuario,			FechaActual,		DireccionIP,
			ProgramaID,			Sucursal,			NumTransaccion)
		VALUES(
			Par_ClienteID,	Par_CuentaAhoID,	Par_PlanID,			Par_Serie,			Par_Monto,
			Par_Fecha,		Par_Estatus,		Par_FechaCancela,	Par_UsuarioCancela,	Aud_EmpresaID,
			Var_FechaVenc,	Var_FechaLibe,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= CONCAT("Folios Agregados Exitosamente.");
		SET Var_Control	:= 'planID';

	END ManejoErrores;

	IF(Par_Salida =SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen  AS ErrMen,
				Var_Control AS control;
	END IF;

END TerminaStore$$