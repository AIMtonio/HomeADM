-- PRODUCTOSCREDITOBEBAJ

DELIMITER ;

DROP PROCEDURE IF EXISTS PRODUCTOSCREDITOBEBAJ;

DELIMITER $$

CREATE PROCEDURE `PRODUCTOSCREDITOBEBAJ`(
-- STORED PROCEDURE PARA DAR DE BAJA PRODUCTOS DE CREDITOS DE LAS BANCAS
	Par_ProdCreditoID				INT(11),			-- ID del producto de credito
	Par_NumBaj						TINYINT UNSIGNED,	-- Numero de baja

	Par_Salida						CHAR(1),			-- Parametro que indica si el procedimiento devuelve una salida
	INOUT Par_NumErr				INT(11),			-- Parametro que corresponde a un numero de exito o error
	INOUT Par_ErrMen				VARCHAR(400),		-- Parametro que corresponde a un mensaje de exito o error

	Par_EmpresaID					INT(11),			-- Auditoria
	Aud_Usuario						INT(11),			-- Auditoria
	Aud_FechaActual					DATETIME,			-- Auditoria
	Aud_DireccionIP					VARCHAR(15),		-- Auditoria
	Aud_ProgramaID					VARCHAR(50),		-- Auditoria
	Aud_Sucursal					INT(11),			-- Auditoria
	Aud_NumTransaccion				BIGINT(20)			-- Auditoria
)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Control			VARCHAR(50);		-- Variable de Control

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);		-- Cadena Vacia
	DECLARE	Entero_Cero			INT(11);		-- Entero cero
	DECLARE Salida_Si			CHAR(1);		-- Indica retorno de un mensaje de salida
	DECLARE Baj_NumProd			INT(11);		-- Baja por numero de producto
	DECLARE Baj_Todo			INT(11);		-- Limpia la tabla

	-- Asignacion de Constantes
	SET	Cadena_Vacia		:= '';				-- Valor de cadena vacia
	SET	Entero_Cero			:= 0;				-- Valor de entero cero.
	SET Salida_Si			:= 'S';      		-- Salida si
    SET Baj_NumProd			:= 1;				-- Baja por numero de producto
    SET Baj_Todo			:= 2;				-- Limpia la tabla

	-- Valores por default
	SET Par_ProdCreditoID	:= IFNULL(Par_ProdCreditoID,Entero_Cero);
	SET Par_NumBaj			:= IFNULL(Par_NumBaj,Entero_Cero);

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen 	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										 'Disculpe las molestias que esto le ocasiona. Ref: PRODUCTOSCREDITOBEBAJ');
				SET Var_Control	= 'SQLEXCEPTION';
			END;

		SET Aud_FechaActual	:= NOW(); -- Fecha actual del sistema

		IF(Par_NumBaj	= Baj_NumProd) THEN

			IF(Par_ProdCreditoID	= Entero_Cero) THEN
				SET Par_NumErr	:= 001;
				SET Par_ErrMen	:= 'El numero de producto de credito esta vacio.';
				SET Var_Control	:= 'Par_ProdCreditoID';
				LEAVE ManejoErrores;
			END IF;

			DELETE FROM PRODUCTOSCREDITOBE
			WHERE	ProductoCreditoID	= Par_ProdCreditoID;

			SET Par_NumErr	:= 000;
			SET Par_ErrMen	:= 'Producto de credito eliminado exitosamente.';
			SET Var_Control	:= 'Par_ProdCreditoID';
		END IF;

		IF(Par_NumBaj = Baj_Todo) THEN

			DELETE FROM PRODUCTOSCREDITOBE;

			SET Par_NumErr	:= 000;
			SET Par_ErrMen	:= 'Productos de credito eliminados exitosamente.';
			SET Var_Control	:= 'Par_ProdCreditoID';
		END IF;

	END ManejoErrores;

	IF (Par_Salida = Salida_Si) THEN
		SELECT  Par_NumErr	AS NumErr,
				Par_ErrMen	AS ErrMen,
				Var_Control	AS control;
	END IF;

END TerminaStore$$
