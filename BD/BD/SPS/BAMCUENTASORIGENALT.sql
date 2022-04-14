-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BAMCUENTASORIGENALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BAMCUENTASORIGENALT`;
DELIMITER $$


CREATE PROCEDURE `BAMCUENTASORIGENALT`(
-- SP para dar de alta una cuenta de ahorro para cargos en la banca electronica
	Par_ClienteID	    INT(11),		-- ID del cliente usuario de BE
	Par_CuentaAhoID 	BIGINT(12),		-- ID de la cuenta de ahorro para dar de alta
    Par_Estatus			CHAR(1),		-- Estatus de la cuenta cargo

    Par_Salida          CHAR(1),		-- Especifica si el SP genera una salida o no
    INOUT Par_NumErr    INT(11),				-- Parametro de salida con numero de error
    INOUT Par_ErrMen    VARCHAR(400),		-- Parametro de salida con el mensaje de error

    Par_EmpresaID       INT(11),		-- Auditoria
    Aud_Usuario         INT(11),		-- Auditoria
    Aud_FechaActual     DATETIME,		-- Auditoria
    Aud_DireccionIP     VARCHAR(15),	-- Auditoria
    Aud_ProgramaID      VARCHAR(50),	-- Auditoria
    Aud_Sucursal        INT(11),		-- Auditoria
    Aud_NumTransaccion  BIGINT(20)		-- Auditoria
	)

TerminaStore: BEGIN

	-- Declaracion de Variables
    DECLARE Var_Control     	VARCHAR(50);

    -- Declaracion de Constantes
    DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Entero_Cero     	INT;
	DECLARE SalidaSI        	CHAR(1);

    -- Asignacion  de constantes
	SET Cadena_Vacia    := '';              -- Cadena o string vacio
	SET Entero_Cero     := 0;               -- Entero en cero
	SET SalidaSI        := 'S';             -- El Store SI genera una Salida

    ManejoErrores: BEGIN
     DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			 SET Par_NumErr = 999;
			 SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									   'Disculpe las molestias que esto le ocasiona. Ref: SP-BAMCUENTASORIGENALT');
			 SET Var_Control = 'SQLEXCEPTION';
		END;

		IF(IFNULL(Par_ClienteID, Cadena_Vacia)) = Cadena_Vacia THEN
				SET	Par_NumErr 	:= 001;
				SET	Par_ErrMen	:= 'El ClienteID esta Vacio';
				SET Var_Control := 'clienteID';
				LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Par_CuentaAhoID, Cadena_Vacia)) = Cadena_Vacia THEN
				SET	Par_NumErr 	:= 002;
				SET	Par_ErrMen	:= 'La cuentaAhoID esta Vacia';
				SET Var_Control := 'cuentaAhoID';
				LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Par_Estatus, Cadena_Vacia)) = Cadena_Vacia THEN
				SET	Par_NumErr 	:= 003;
				SET	Par_ErrMen	:= 'El Estatus esta Vacio';
				SET Var_Control := 'estatus';
				LEAVE ManejoErrores;
		END IF;

        IF NOT EXISTS(SELECT ClienteID
				FROM BAMUSUARIOS
					WHERE ClienteID = Par_ClienteID) THEN
			SET	Par_NumErr 	:= 004;
			SET	Par_ErrMen	:= 'El Cliente no Existe en la Tabla USUARIOS';
			SET Var_Control := 'clienteID';
			LEAVE ManejoErrores;
		END IF;

        IF NOT EXISTS(SELECT CuentaAhoID
				FROM CUENTASAHO
					WHERE CuentaAhoID = Par_CuentaAhoID) THEN
			SET	Par_NumErr 	:= 005;
			SET	Par_ErrMen	:= 'La Cuenta no Existe en la Tabla CUENTASAHO ';
			SET Var_Control := 'cuentaAhoID';
			LEAVE ManejoErrores;
		END IF;


        INSERT INTO BAMCUENTASORIGEN (
			ClienteID,			CuentaAhoID,		Estatus,			EmpresaID,		Usuario,
            FechaActual,		DireccionIP,		ProgramaID,			Sucursal,		NumTransaccion
        )VALUES(
			Par_ClienteID,		Par_CuentaAhoID,	Par_Estatus,		Par_EmpresaID,	Aud_Usuario,
            Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID, 	Aud_Sucursal,   Aud_NumTransaccion
        );

        SET Par_NumErr  := 000;
		SET Par_ErrMen  := 'Cuenta Cargo Agregada Exitosamente';
		SET Var_Control := 'clienteID';

    END ManejoErrores;

   IF (Par_Salida = SalidaSI) THEN
			SELECT  Par_NumErr  AS NumErr,
					Par_ErrMen  AS ErrMen,
					Var_Control AS control;
	END IF;

END TerminaStore$$