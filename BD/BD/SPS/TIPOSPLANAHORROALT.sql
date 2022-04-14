-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSPLANAHORROALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSPLANAHORROALT`;
DELIMITER $$

CREATE PROCEDURE `TIPOSPLANAHORROALT`(
-- ==================================================
-- STORE PARA DAR DE ALTA LOS TIPOS DE PLAN DE AHORRO
-- ==================================================
	Par_Nombre 				VARCHAR(100),	-- Nombre del Plan de Ahorro
	Par_FechaInicio 		DATE,			-- Fecha de Inicio del Plan de Ahorro
	Par_FechaVencimiento 	DATE,			-- Fecha Vencimiento del Plan de Ahorro
	Par_FechaLiberacion 	DATE,			-- Fecha de Liberacion del Plan de Ahorro
	Par_DepositoBase 		DECIMAL(12,2),	-- Monto del Deposito Base del Plan de Ahorro

	Par_MaxDep 				INT(11),		-- Numero Maximo de depositos generados por Cuenta-Cliente
	Par_Prefijo				VARCHAR(25),	-- Prefijo del plan de Ahorro
	Par_Serie				INT(11),		-- Numero Maximo de folios generados por Plan de Ahorro
	Par_LeyendaBloqueo 		VARCHAR(100),	-- Descripcion de la leyenda para los Bloqueos de Saldo
	Par_LeyendaTicket 		VARCHAR(250),	-- Descripcion de la leyenda para la impresion de tickets

	Par_TiposCuentas		VARCHAR(100),	-- String con los tipos de cuentas aceptados por Plan de Ahorro
	Par_Salida				CHAR(1),		-- Tipo de Salida S.- Si N.- No
	INOUT Par_NumErr		INT(11),		-- Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Mensaje de Error

	Par_DiasDesbloqueo		INT,			-- Indica dias para el desbloqueo

	/* Parametros de Auditoria */
	Aud_EmpresaID 			INT(11),
	Aud_Usuario 			INT(11),
  	Aud_FechaActual 		DATETIME,
  	Aud_DireccionIP 		VARCHAR(15),
  	Aud_ProgramaID 			VARCHAR(50),
  	Aud_Sucursal 			INT(11),
  	Aud_NumTransaccion 		BIGINT(20)
)
TerminaStore:BEGIN

	/*Declaracion de Constantes*/
	DECLARE Entero_Cero		INT(11);
	DECLARE Entero_Uno		INT(11);
	DECLARE Cadena_Vacia	VARCHAR(250);
	DECLARE Fecha_Vacia		DATE;
	DECLARE Decimal_Cero	DECIMAL(12,2);
	DECLARE Var_PlanID		INT(11);
	DECLARE SalidaSI		CHAR(1);
    DECLARE	Var_TipoCuentaID VARCHAR(10);
    DECLARE Negativo_Uno 	INT(11);
    DECLARE Separador		CHAR(1);


	DECLARE	Var_Control		VARCHAR(50);

	/*Asignacion de Constantes*/
	SET Entero_Cero		:= 0;
	SET Entero_Uno		:= 1;
	SET Cadena_Vacia	:= '';
	SET Fecha_Vacia		:= '1900-01-01';
	SET Decimal_Cero	:= 0.0;
	SET SalidaSI		:= 'S';
    SET Var_TipoCuentaID := '';
    SET Negativo_Uno	:= -1;
    SET Separador		:= ',';

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
							'Disculpe las molestias que esto le ocasiona. Ref: SP-TIPOSPLANAHORROALT');
			SET Var_Control	:='sqlException';
		END;

		IF(IFNULL(Par_Nombre,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_NumErr	:= 01;
			SET Par_ErrMen	:= 'El nombre del Plan de Ahorro esta vacio.';
			SET Var_Control := 'nombre';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_FechaInicio,Fecha_Vacia)=Fecha_Vacia)THEN
			SET Par_NumErr	:= 02;
			SET Par_ErrMen	:= 'La Fecha de Inicio esta vacia.';
			SET Var_Control := 'fechaInicio';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_FechaVencimiento,Fecha_Vacia)=Fecha_Vacia)THEN
			SET Par_NumErr	:= 03;
			SET Par_ErrMen	:= 'La Fecha de Vencimiento esta vacia.';
			SET Var_Control := 'fechaVencimiento';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_FechaLiberacion,Fecha_Vacia)=Fecha_Vacia)THEN
			SET Par_NumErr	:= 04;
			SET Par_ErrMen	:= 'La Fecha de Liberacion esta vacia.';
			SET Var_Control := 'fechaLiberacion';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_DepositoBase,Entero_Cero)=Entero_Cero)THEN
			SET Par_NumErr	:= 05;
			SET Par_ErrMen	:= 'El Monto del Deposito Base esta vacio.';
			SET Var_Control := 'depositoBase';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_MaxDep,Entero_Cero)=Entero_Cero)THEN
			SET Par_NumErr	:= 06;
			SET Par_ErrMen	:= 'El numero maximo de Depositos por cliente esta vacio.';
			SET Var_Control := 'maxDep';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Prefijo,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_NumErr	:= 07;
			SET Par_ErrMen	:= 'El Prefijo del Plan de Ahorro esta vacio.';
			SET Var_Control := 'prefijo';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Serie,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_NumErr	:= 08;
			SET Par_ErrMen	:= 'La serie del Plan de Ahorro esta vacia.';
			SET Var_Control := 'serie';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_LeyendaBloqueo,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_NumErr	:= 09;
			SET Par_ErrMen	:= 'La Leyenda de Bloqueos esta vacia.';
			SET Var_Control := 'leyendaBloqueo';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_LeyendaTicket,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_NumErr	:= 10;
			SET Par_ErrMen	:= 'La Leyenda de Tickets esta vacia.';
			SET Var_Control := 'leyendaTicket';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_TiposCuentas,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_NumErr	:= 11;
			SET Par_ErrMen	:= 'El tipo de cuenta para el Plan de Ahorro esta vacio.';
			SET Var_Control := 'tiposCuentas';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_DiasDesbloqueo,Entero_Cero)=Entero_Cero) THEN
			SET Par_NumErr	:= 12;
			SET Par_ErrMen	:= 'El numero de Dias de Desbloqueo no es valido.';
			SET Var_Control := 'diasDesbloqueo';
			LEAVE ManejoErrores;
		END IF;

		INSERT INTO TIPOSPLANAHORRO(
			Nombre,			FechaInicio,		FechaVencimiento,		FechaLiberacion,		DepositoBase,
			MaxDep,			Prefijo,			Serie,					LeyendaBloqueo,			LeyendaTicket,
			EmpresaID,		Usuario,			FechaActual,			DireccionIP,			ProgramaID,
			Sucursal,		NumTransaccion, 	DiasDesbloqueo)
		VALUES
			(Par_Nombre,		Par_FechaInicio,	Par_FechaVencimiento,	Par_FechaLiberacion,	Par_DepositoBase,
			Par_MaxDep,			Par_Prefijo,		Par_Serie,				Par_LeyendaBloqueo,		Par_LeyendaTicket,
			Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion,	Par_DiasDesbloqueo);

		SET Var_PlanID := (SELECT MAX(planID) FROM TIPOSPLANAHORRO);

		-- Insertar tipos cuentas por plan de ahorro
        WHILE(Var_TipoCuentaID<>Par_TiposCuentas)DO

            SET Var_TipoCuentaID := (SELECT substring_index(Par_TiposCuentas,Separador,Entero_Uno));
            SET Par_TiposCuentas := (select substring_index(Par_TiposCuentas,concat(Var_TipoCuentaID,Separador),Negativo_Uno));

            INSERT INTO TIPOSCUEPLANAHORRO VALUES(
				Var_PlanID , 		Var_TipoCuentaID, 	Aud_EmpresaID, 	Aud_Usuario, 		Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

		END WHILE;

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= CONCAT("Plan de Ahorro Agregado Exitosamente: ",CONVERT(Var_PlanID,CHAR));
		SET Var_Control	:= 'planID';

	END ManejoErrores;

	IF(Par_Salida =SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen  AS ErrMen,
				Var_Control AS control,
				CONVERT(Var_PlanID,CHAR) AS Consecutivo;
	END IF;

END TerminaStore$$