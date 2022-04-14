-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLANAHORROPROALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLANAHORROPROALT`;
DELIMITER $$

CREATE PROCEDURE `PLANAHORROPROALT`(
-- ===================================================================================
-- SP PARA REGISTRAR LOS FOLIOS ADQUIRIDOS POR EL CLIENTE DE ACUERDO AL PLAN DE AHORRO
-- ===================================================================================
	Par_ClienteID 		INT(11),		-- Identificador del Cliente que adquiere los folios
	Par_CuentaAhoID		BIGINT,			-- Identificador de la cuenta del cliente
	Par_PlanID			INT(11),		-- Plan de Ahorro del que adquiere los folios
	Par_NumFolios		INT(11),		-- Numero de Folios a registar
	Par_MontoTotal		DECIMAL(12,2),	-- Monto Toral a registrar

	Par_Fecha 			DATE,			-- Fecha en la que se realiza el registro
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
	DECLARE Var_Control 	VARCHAR(50);
	DECLARE	Var_MontoBase	DECIMAL(12,2);
	DECLARE Var_SerieActual INT(11);
	DECLARE Var_Contador	INT(11);
	DECLARE Var_SaldoDipon	DECIMAL(12,2);


	DECLARE	Entero_Cero 	INT(11);
	DECLARE Decimal_Cero	DECIMAL(12,2);
	DECLARE Estatus_Activo	CHAR(1);
	DECLARE Fecha_Vacia		DATE;
	DECLARE SalidaSI		CHAR(1);
	DECLARE Cons_Bloqueo 	CHAR(1);
	DECLARE Cons_Referencia VARCHAR(100);
	DECLARE Cadena_Vacia	VARCHAR(100);
	DECLARE	Cons_Descripcion VARCHAR(100);
	DECLARE TipoBloqPlanAhorro INT(11);
    DECLARE SalidaNo			CHAR(1);

	/*Asignacion de Constantes*/
	SET Entero_Cero 	:= 0;
	SET Decimal_Cero 	:= 0.0;
	SET Estatus_Activo 	:= 'A';
	SET Fecha_Vacia		:= '1900-01-01';
	SET SalidaSI		:= 'S';
	SET Cons_Bloqueo 	:= 'B';
	SET Cadena_Vacia 	:= '';
	SET TipoBloqPlanAhorro := 19;
    SET SalidaNo 			:= 'N';

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
							'Disculpe las molestias que esto le ocasiona. Ref: SP-PLANAHORROPROALT');
			SET Var_Control	:='sqlException';
		END;

	IF(IFNULL(Par_ClienteID,Entero_Cero)=Entero_Cero)THEN
		SET Par_NumErr := 01;
		SET Par_ErrMen := 'El Numero de Cliente esta vacio.';
		SET Var_Control := 'clienteID';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_CuentaAhoID,Entero_Cero)=Entero_Cero)THEN
		SET Par_NumErr := 02;
		SET Par_ErrMen := 'La cuenta del cliente esta vacia.';
		SET Var_Control := 'cuentaAhoID';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_PlanID,Entero_Cero)=Entero_Cero)THEN
		SET Par_NumErr := 03;
		SET Par_ErrMen := 'El Plan de Ahorro esta vacio.';
		SET Var_Control := 'planID';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_NumFolios,Entero_Cero)=Entero_Cero)THEN
		SET Par_NumErr := 04;
		SET Par_ErrMen := 'El numero de folios esta vacio.';
		SET Var_Control := 'noFolios';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_MontoTotal,Decimal_Cero)=Decimal_Cero)THEN
		SET Par_NumErr := 05;
		SET Par_ErrMen := 'El Monto del Ahorro esta vacio.';
		SET Var_Control := 'montoTotal';
		LEAVE ManejoErrores;
	END IF;


	-- VALIDA
	SET Var_MontoBase = (SELECT DepositoBase FROM TIPOSPLANAHORRO WHERE PlanID=Par_PlanID);
	IF(MOD(Par_MontoTotal,Var_MontoBase)<>Entero_Cero AND (Par_MontoTotal/Par_NumFolios)<>Var_MontoBase)THEN
		SET Par_NumErr := 07;
		SET Par_ErrMen := 'El numero de folios no corresponde al monto especificado.';
		SET Var_Control := 'noFolios';
		LEAVE ManejoErrores;
	END IF;

	-- VALIDAR SALDO DISPONIBLE EN LA CUENTA DEL CLIENTE
	SET Var_SaldoDipon = (SELECT SaldoDispon FROM CUENTASAHO WHERE CuentaAhoID=Par_CuentaAhoID);
	IF(Var_SaldoDipon<Par_MontoTotal)THEN
		SET Par_NumErr := 08;
		SET Par_ErrMen := 'La cuenta ya no tiene saldo disponible suficiente.';
		SET Var_Control := 'noFolios';
		LEAVE ManejoErrores;
	END IF;

	SET Par_Fecha = (SELECT FechaSistema FROM PARAMETROSSIS);

	-- SERIE ACTUAL DE FOLIOS
	SET Var_SerieActual := (SELECT MAX(Serie) FROM FOLIOSPLANAHORRO WHERE PlanID=Par_PlanID);
	SET Var_SerieActual := IFNULL(Var_SerieActual,Entero_Cero);

    IF(Var_SerieActual=Entero_Cero)THEN
		SET Var_SerieActual := (SELECT Serie FROM TIPOSPLANAHORRO WHERE PlanID=Par_PlanID);
    END IF;

	SET Var_Contador := 1;
	-- ALTA DE FOLIOS
	WHILE(Var_Contador<=Par_NumFolios) DO
		SET Var_SerieActual := Var_SerieActual +1;

		CALL FOLIOSPLANAHORROALT(
			Par_ClienteID,		Par_CuentaAhoID, 	Par_PlanID,			Var_SerieActual,		Var_MontoBase,
			Par_Fecha,			Estatus_Activo,		Fecha_Vacia,		Cadena_Vacia,			SalidaNo,
			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,			Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,  		Aud_NumTransaccion);

		IF(Par_NumErr<>Entero_Cero)THEN
			SET Var_Control := 'serie';
			LEAVE ManejoErrores;
		END IF;

		SET Var_Contador := Var_Contador + 1;
	END WHILE;

	SET Cons_Descripcion = (SELECT LeyendaBloqueo FROM TIPOSPLANAHORRO WHERE PlanID = Par_PlanID);
	-- BLOQUEO DEL SALDO DEL CLIENTE
	CALL BLOQUEOSPRO(
		Entero_Cero,		Cons_Bloqueo,		Par_CuentaAhoID,	Par_Fecha,			Par_MontoTotal,
		Fecha_Vacia,		TipoBloqPlanAhorro,	Cons_Descripcion,	Par_NumFolios,			Cadena_Vacia,
		Cadena_Vacia,		SalidaNo,			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
		Aud_NumTransaccion);

	IF(Par_NumErr<>Entero_Cero)THEN
		SET Var_Control := 'serie';
		LEAVE ManejoErrores;
	END IF;

		SET Par_NumErr := 00;
		SET Par_ErrMen := 'Folios Registrados Correctamente';
		SET Var_Control := 'clienteID';

	END ManejoErrores;

	IF(Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen  AS ErrMen,
				Var_Control AS control;
	END IF;

END TerminaStore$$