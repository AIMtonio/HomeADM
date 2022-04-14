-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BAMCUENTASORIGENBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `BAMCUENTASORIGENBAJ`;DELIMITER $$

CREATE PROCEDURE `BAMCUENTASORIGENBAJ`(
-- SP Para eliminar las cuentas cargo de un usuario de banca movil
	Par_ClienteID			INT(11),			-- Cliente del cual se eliminaran sus cuentas
    Par_CuentaAhoID			BIGINT(12),			-- CuentaID que se eliminara
	Par_NumBaja				TINYINT UNSIGNED,	-- Tipo de baja a ejecutar
    Par_Salida              CHAR(1),			-- Salida
    INOUT Par_NumErr        INT(11),			-- Numero de Error

    INOUT Par_ErrMen        VARCHAR(400),		-- Mensaje Error
	Par_EmpresaID			INT,				-- Auditoria
	Aud_Usuario				INT,				-- Auditoria
	Aud_FechaActual			DATETIME,			-- Auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Auditoria

	Aud_ProgramaID			VARCHAR(50),		-- Auditoria
	Aud_Sucursal			INT,				-- Auditoria
	Aud_NumTransaccion		BIGINT				-- Auditoria

	)
TerminaStore: BEGIN

-- Declaracion de variables
	DECLARE Var_Control     VARCHAR(50);	-- Variable de control

	/* Declaracion de Constantes */
    DECLARE Baj_NumCuenta	INT(1);
	DECLARE Baj_NumCliente	INT(1);
    DECLARE SalidaSI        CHAR(1);
    DECLARE Entero_Cero     	INT;

     /* Asignacion de Constantes */
    SET Baj_NumCuenta		:= 1;				-- Baja por numero de cuenta
    SET Baj_NumCliente		:= 2;				-- Baja por numero de cliente
    SET SalidaSI       		:= 'S';				-- Salida SI
    SET Entero_Cero     	:= 0;

    ManejoErrores: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									  'Disculpe las molestias que esto le ocasiona. Ref: SP-BAMCUENTASORIGENBAJ');
				SET Var_Control = 'SQLEXCEPTION';
			END;

	IF(Par_NumBaja = Baj_NumCuenta) THEN
			IF(IFNULL(Par_CuentaAhoID, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 002;
		SET Par_ErrMen := 'La Cuenta Ahorro ID esta vacio.';
		SET Var_Control := 'clienteID';
		LEAVE ManejoErrores;
	 END IF;

		DELETE FROM BAMCUENTASORIGEN
			WHERE CuentaAhoID	= Par_CuentaAhoID;
            SET Var_Control := 'clienteID';
    END IF;

    IF(Par_NumBaja = Baj_NumCliente)THEN
    IF(IFNULL(Par_ClienteID, Entero_Cero))= Entero_Cero THEN
		SET Par_NumErr := 001;
		SET Par_ErrMen := 'El ID del Cliente esta vacia.';
		SET Var_Control := 'clienteID';
		LEAVE ManejoErrores;
	 END IF;
		DELETE FROM BAMCUENTASORIGEN
			WHERE ClienteID = Par_ClienteID;
            SET Var_Control := 'clienteID';

     END IF;

		SET Par_NumErr  := 000;
		SET Par_ErrMen  := 'Cuenta de Origen eliminada correctamente';
        SET Var_Control := 'clienteID';


END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
			SELECT  Par_NumErr  AS NumErr,
					Par_ErrMen  AS ErrMen,
					Var_Control AS control;
	END IF;

END TerminaStore$$