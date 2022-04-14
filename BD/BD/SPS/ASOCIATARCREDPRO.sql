-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ASOCIATARCREDPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `ASOCIATARCREDPRO`;DELIMITER $$

CREATE PROCEDURE `ASOCIATARCREDPRO`(
	-- SP PARA ASOCIAR LA TARJETA DE CREDITO A LA LINEA DE CREDITO
    Par_TarjetaCredID		CHAR(16),		-- Tarjeta de credito
    Par_ClienteID			INT(11), 		-- Cliente
    Par_NombreUsuario		VARCHAR(250),   -- Nombre del usuario
	Par_LineaTarCredID		INT(11), 		-- Linea de credito
	Par_Estatus				CHAR(2), 		-- Estatus
	Par_Relacion			CHAR(1),
	Par_CuentaClabe			CHAR(18),		-- Cuenta clabe

    Par_Salida          	CHAR(1), 		-- Salida
	OUT Par_NumErr          INT, 			-- Salida
	OUT Par_ErrMen          VARCHAR(200),	-- Salida

    Aud_EmpresaID			INT(11),		-- Auditoria
    Aud_Usuario         	INT, 			-- Auditoria
    Aud_FechaActual     	DATETIME, 		-- Auditoria
    Aud_DireccionIP     	VARCHAR(15), 	-- Auditoria
    Aud_ProgramaID      	VARCHAR(50), 	-- Auditoria
    Aud_Sucursal        	INT, 			-- Auditoria
    Aud_NumTransaccion  	BIGINT 			-- Auditoria
    )
TerminaStore: BEGIN
	/* 	variables*/
	DECLARE Var_Control	    	VARCHAR(100);
	DECLARE Var_TasaFija		DECIMAL(8,4);	-- TASA
    DECLARE Var_CobraMora		CHAR(1);	    -- SI COBRA MORA O NO
    DECLARE Var_TipoCobMora		CHAR(1);        -- TIPO DE COBRO MORA
    DECLARE Var_FactorMora		DECIMAL(8,4);   -- MONTO DE MORA
    DECLARE Var_MontoLinea		DECIMAL(16,2);	-- MONTO DE LA LINEA
    DECLARE Var_TipoPagMin		CHAR(1);		-- TIPO DE PAGO MINIMO
    DECLARE Var_FactorPagMin	DECIMAL(8,4);	-- MONTO DEL PAGO MINIMO
    DECLARE Var_ProductoCredID	INT(11);		-- PRODUCTO DE CREDITO
	DECLARE Var_LineaTarCredID  INT;			-- ID DE LA LINEA
    DECLARE Var_FechaSistema    DATETIME;       -- FECHA DEL SISTEMA

    -- DECALRACION DE CONSTANTES
	DECLARE Entero_Cero        INT;
	DECLARE Decimal_Cero       DECIMAL(2,2);
	DECLARE Cadena_Vacia       CHAR(1);
	DECLARE Fecha_Vacia        DATE;
	DECLARE SalidaSI           CHAR(1);
	DECLARE SalidaNO           CHAR(1);



	-- ASIGNACION DE CONSTANTES
	SET Entero_Cero     := 0;
	SET Decimal_Cero    := '0.00';
	SET Cadena_Vacia    := '';
	SET Fecha_Vacia     := '1900-01-01';
	SET SalidaSI        := 'S';
	SET SalidaNO        := 'N';




ManejoErrores: BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-ASOCIATARCREDPRO');
		END;

	SET Aud_FechaActual := CURRENT_TIMESTAMP();
	SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS);



	IF(IFNULL(Par_TarjetaCredID, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr  := 1;
		SET Par_ErrMen  := 'La tarjeta esta vacia';
        SET Var_Control := 'TarjetaCredID';
		LEAVE ManejoErrores;
	END IF;
    IF(IFNULL(Par_ClienteID, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr  := 2;
		SET Par_ErrMen  := 'El cliente esta vacio';
		LEAVE ManejoErrores;
        SET Var_Control := 'ClienteID';
	END IF;
      IF(IFNULL(Par_NombreUsuario, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr  := 3;
		SET Par_ErrMen  := 'El nombre del usuario esta vacio';
        SET Var_Control := 'NombreUsuario';
		LEAVE ManejoErrores;
	END IF;
    IF(IFNULL(Par_LineaTarCredID, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr  := 4;
		SET Par_ErrMen  := 'La Linea de credito esta vacia';
		LEAVE ManejoErrores;
        SET Var_Control := 'LineaTarCredID';
	END IF;
    IF(IFNULL(Par_Estatus, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr  := 5;
		SET Par_ErrMen  := 'El estatus esta vacio';
        SET Var_Control := 'Estatus';
		LEAVE ManejoErrores;
	END IF;
    IF(IFNULL(Par_Relacion, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr  := 6;
		SET Par_ErrMen  := 'La relacion de la tarjeta esta vacia';
        SET Var_Control := 'Relacion';
		LEAVE ManejoErrores;
	END IF;

UPDATE TARJETACREDITO SET ClienteID      = Par_ClienteID,
                          Nombretarjeta  = Par_NombreUsuario,
                          LineaTarCredID = Par_LineaTarCredID,
                          Estatus		 = Par_Estatus,
                          Relacion		 = Par_Relacion,
                          CuentaClabe    = IFNULL(Par_CuentaClabe,Cadena_Vacia)
					WHERE TarjetaCredID  = Par_TarjetaCredID;

SET Par_NumErr  := 000;
SET Par_ErrMen  := CONCAT('Tarjeta Asociada Exitosamente: ', Par_TarjetaCredID);
SET Var_Control := 'clienteID';

END ManejoErrores;
 IF (Par_Salida = SalidaSI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Entero_Cero AS consecutivo;
END IF;

END TerminaStore$$