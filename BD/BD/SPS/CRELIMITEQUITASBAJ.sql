-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRELIMITEQUITASBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRELIMITEQUITASBAJ`;
DELIMITER $$

CREATE PROCEDURE `CRELIMITEQUITASBAJ`(
	Par_ProducCreditoID     INT(11),			-- Identificador del producto de credito

	Par_Salida              CHAR(1),			-- Parametro de salidad
	INOUT Par_NumErr		INT(11),			-- Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),		-- Mensaje de Error

	Aud_EmpresaID			INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),			-- Parametro de auditoria ID del usuario

	Aud_FechaActual			DATETIME,			-- Parametro de auditoria Fecha actual
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
	)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_DescriProd  	CHAR(150);		-- Descripcion del producto
	DECLARE Var_Control			VARCHAR(100);	-- Control de Retorno en Pantalla

	-- Declaracion de constantes
	DECLARE Cadena_Vacia    	CHAR(1);		-- Constante de cadena vacia
	DECLARE Entero_Cero     	INT(11);		-- Entero cero
	DECLARE SalidaNO        	CHAR(1);		-- Salidad no
	DECLARE SalidaSI        	CHAR(1);		-- Salidad si

	SET Cadena_Vacia    		:= '';
	SET Entero_Cero     		:= 0;
	SET SalidaNO        		:= 'N';
	SET SalidaSI        		:= 'S';

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
	   SET Par_NumErr  = 999;
	   SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
				  'Disculpe lAS molestiAS que esto le ocASiona. Ref: SP-CRELIMITEQUITASBAJ');
	   SET Var_Control = 'sqlException';
	END;

	SELECT  Descripcion into    Var_DescriProd
		FROM PRODUCTOSCREDITO
		WHERE    ProducCreditoID = Par_ProducCreditoID;

	SET Var_DescriProd  := IFNULL(Var_DescriProd, Cadena_Vacia);

	IF(Var_DescriProd = Cadena_Vacia) THEN
		IF(Par_Salida = SalidaSI) THEN
			SET Par_NumErr 	:= 1;
			SET Par_ErrMen	:= 'Producto de Credito Incorrecto';
			SET Var_Control := 'producCreditoID';

			SELECT 	Par_NumErr AS NumErr,
				   	Par_ErrMen AS ErrMen,
				   	Var_Control AS control,
					Entero_Cero AS consecutivo;
			LEAVE TerminaStore;
		END IF;

		IF(Par_Salida = SalidaNO) THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'Producto de Credito Incorrecto' ;
			LEAVE TerminaStore;
		END IF;
	END IF;

	DELETE FROM CRELIMITEQUITAS
		WHERE ProducCreditoID = Par_ProducCreditoID;

	SET Par_NumErr 	:= Entero_Cero;
	SET Par_ErrMen	:= 'Limite Eliminado Exitosamente';
	SET Var_Control := 'producCreditoID';

	END ManejoErrores;

	IF(Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Entero_Cero AS consecutivo;
	END IF;

	IF(Par_Salida = SalidaNO) THEN
			SET     Par_NumErr := 0;
			SET 	Par_ErrMen := "Limite Eliminado Exitosamente";
	END IF;

END$$