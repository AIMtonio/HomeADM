-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LINEATARJETACREDPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `LINEATARJETACREDPRO`;DELIMITER $$

CREATE PROCEDURE `LINEATARJETACREDPRO`(
	-- SP PARA ASIGNAR LA CUENTA CLABE A LA LINEA Y TARJETA DE CREDITO

    Par_TarjetaCredID		CHAR(16), 		-- ID DE LA TARJETA
    Par_ClienteID			INT(11), 		-- ID DEL CLINETE
   	Par_CuentaClabe			CHAR(18),		-- CUENTA CLABE

    Par_Salida          	CHAR(1),		-- Salida
	OUT Par_NumErr          INT,			-- Salida
	OUT Par_ErrMen          VARCHAR(200),	-- Salida

    Aud_EmpresaID			INT(11),		-- Auditoria
    Aud_Usuario         	INT,			-- Auditoria
    Aud_FechaActual     	DATETIME,		-- Auditoria
    Aud_DireccionIP     	VARCHAR(15),	-- Auditoria
    Aud_ProgramaID      	VARCHAR(50),	-- Auditoria
    Aud_Sucursal        	INT,			-- Auditoria
    Aud_NumTransaccion  	BIGINT			-- Auditoria
    )
TerminaStore: BEGIN
	/* 	variables*/
	DECLARE Var_Control	    	 VARCHAR(100);
    DECLARE Var_ProductoCredID	 INT(11);		#ID DEL PRODUCTO
	DECLARE Var_LineaTarCredID 	 INT;		    #ID DE LA LINEA
    DECLARE Var_FechaSistema     DATETIME;		#FECHA DEL SISTEMA

	-- DECLARACION DE CONSTANTES
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
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
							  concretar la operacion.Disculpe las molestias que', 'esto le ocasiona. Ref: SP-LINEATARJETACREDPRO');
			SET Var_Control = 'SQLEXCEPTION';
		END;

	SET Aud_FechaActual := CURRENT_TIMESTAMP();
	SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS);
	SET Var_LineaTarCredID :=(SELECT LineaTarCredID FROM TARJETACREDITO WHERE TarjetaCredID = Par_TarjetaCredID AND ClienteID= Par_ClienteID);


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

     IF(IFNULL(Par_CuentaClabe, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr  := 2;
		SET Par_ErrMen  := 'La cuenta clabe esta vacia';
		LEAVE ManejoErrores;
        SET Var_Control := 'CuentaClabe';
	END IF;
    IF(CHARACTER_LENGTH(Par_CuentaClabe)<18) THEN
		SET Par_NumErr  := 3;
		SET Par_ErrMen  := 'La cuenta clabe debe de tener 18 caracteres';
		LEAVE ManejoErrores;
        SET Var_Control := 'CuentaClabe';
	END IF;

UPDATE LINEATARJETACRED SET
                          CuentaClabe    = Par_CuentaClabe
					WHERE LineaTarCredID =Var_LineaTarCredID AND ClienteID= Par_ClienteID;

UPDATE TARJETACREDITO SET
                          CuentaClabe    = Par_CuentaClabe
					WHERE LineaTarCredID =Var_LineaTarCredID AND ClienteID= Par_ClienteID;

SET Par_NumErr  := 000;
SET Par_ErrMen  := CONCAT('Tarjeta de Credito Modificada Exitosamente: ', Par_CuentaClabe);
SET Var_Control := 'ExitoAsociaTarCredito';


END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
            'cuentaClabe' AS control,
            Entero_Cero AS consecutivo;
END IF;

END TerminaStore$$