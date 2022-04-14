-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DESTINOSCREDPRODALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `DESTINOSCREDPRODALT`;
DELIMITER $$

CREATE PROCEDURE `DESTINOSCREDPRODALT`(
    Par_ProductoCreditoID   INT(11),
    Par_DestinoCreID        INT(11),
    Par_Salida              CHAR(1),
    INOUT   Par_NumErr      INT,
    INOUT   Par_ErrMen      VARCHAR(400),

    Aud_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),

    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
    )
TerminaStore :BEGIN

	-- DECLARACION DE VARIABLES
	DECLARE Var_Estatus         CHAR(2);        -- Almacena el estatus del producto de credito
	DECLARE Var_Descripcion     VARCHAR(100);   -- Almacena la descripcion del producto de credito

	-- DECLARACION DE CONSTANTES
	DECLARE Entero_Cero     INT(11);
	DECLARE Cadena_Vacia    CHAR(1);
	DECLARE Var_Control     VARCHAR(50);
	DECLARE Salida_SI       CHAR(1);
	DECLARE Estatus_Inactivo    CHAR(1);    -- Estatus Inactivo

	-- ASIGNACION DE CONSTANTES
	SET Entero_Cero         := 0;
	SET Cadena_Vacia        := '';
	SET Var_Control         := '';
	SET Salida_SI           := 'S';
	SET Estatus_Inactivo    := 'I';      -- Estatus Inactivo

	SET Aud_FechaActual     := NOW();

	ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operación. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-DESTINOSCREDPRODALT');
			SET Var_Control = 'sqlException';
		END;

	SELECT  Estatus,        Descripcion
	INTO    Var_Estatus,    Var_Descripcion
	FROM PRODUCTOSCREDITO
	WHERE ProducCreditoID = Par_ProductoCreditoID;

	IF(IFNULL(Par_ProductoCreditoID,Entero_Cero) = Entero_Cero) THEN
		SET Par_NumErr  := 1;
		SET Par_ErrMen  := 'El producto de credito esta vacio';
		SET Var_Control := 'productoCreditoID';
		LEAVE ManejoErrores;
	END IF;

	SET Par_ProductoCreditoID := (SELECT ProducCreditoID FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Par_ProductoCreditoID);
	IF (IFNULL(Par_ProductoCreditoID,Entero_Cero) = Entero_Cero)THEN
		SET Par_NumErr  := 2;
		SET Par_ErrMen  := 'El producto de credito no existe ';
		SET Var_Control := 'productoCreditoID';
		LEAVE ManejoErrores;
	END IF;

	IF(Var_Estatus = Estatus_Inactivo) THEN
		SET Par_NumErr 	:= 049;
		SET Par_ErrMen 	:= CONCAT('El Producto ',Var_Descripcion,' se encuentra Inactivo, por favor comunicarse con el Administrador para mas informacion.');
		SET Var_Control	:= 'productoCreditoID';
		LEAVE ManejoErrores;
	END IF;

	INSERT INTO DESTINOSCREDPROD (
		ProductoCreditoID,      DestinoCreID,       EmpresaID,      Usuario,            FechaActual,
		DireccionIP,            ProgramaID,         Sucursal,       NumTransaccion
	)
	VALUES (
		Par_ProductoCreditoID,  Par_DestinoCreID,   Aud_EmpresaID,  Aud_Usuario,        Aud_FechaActual,
		Aud_DireccionIP,        Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion
	);

	SET Par_NumErr  := 0;
	SET Par_ErrMen  := 'Destinos de Credito Grabados Exitosamente';
	SET Var_Control := 'productoCreditoID';

END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS Control,
            Entero_Cero as Consecutivo;
END IF;


END TerminaStore$$