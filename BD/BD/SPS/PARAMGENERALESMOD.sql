DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMGENERALESMOD`;

DELIMITER $$
CREATE PROCEDURE `PARAMGENERALESMOD`(

	Par_llaveParametro VARCHAR(50) ,            -- Llave de parametro
	Par_ValorParametro VARCHAR(200),            -- Llave de valor parametro

	Par_Salida				  CHAR(1),			-- Parametro de Salida
	INOUT Par_NumErr		  INT(11),			-- Numero de error
	INOUT Par_ErrMen		  VARCHAR(400),		-- Mensaje de Error

	-- Parametros de Auditoria
	Par_EmpresaID			INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
		)
TerminaStore: BEGIN


	DECLARE Var_ValorParametro   VARCHAR(50);
	DECLARE Var_LlaveParametro   VARCHAR(50);
	DECLARE Var_Control          VARCHAR(100);
	DECLARE Cadena_Vacia		 CHAR(1);      -- Cadena vacia
	DECLARE	Entero_Cero			 INT(11);      -- Valor entero cero
	DECLARE	Salida_SI			 CHAR(1);      -- variable de salida
	DECLARE Llave_UserEjecucionBalanzaContable	VARCHAR(50);-- Llave de Usuario que  Ejecuta la Balanza Contable


	SET Cadena_Vacia        	:= '';		  -- seteeo de cadena vacia
	SET	Entero_Cero				:= 0;		  -- seteo a valor cero
	SET	Salida_SI				:= 'S';		  -- seteo a valor S
	SET Llave_UserEjecucionBalanzaContable	:= 'UserEjecucionBalanzaContable';


	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PARAMGENERALESMOD');
				SET Var_Control = 'SQLEXCEPTION';
			END;

		IF(IFNULL(Par_llaveParametro, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr    := 001;
			SET Par_ErrMen    := 'Perfil Edicion Vacio.';
			SET Var_Control   := 'llaveParametro';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_llaveParametro <> Llave_UserEjecucionBalanzaContable ) THEN
			IF(IFNULL(Par_ValorParametro, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr    := 002;
				SET Par_ErrMen    := 'Perfil Edicion vacio.';
				SET Var_Control   := 'Perfil Vacio';
				LEAVE ManejoErrores;
			END IF;
		END IF;


		SELECT LlaveParametro INTO Var_LlaveParametro
			FROM 	PARAMGENERALES
			WHERE 	LlaveParametro	= Par_llaveParametro;


		IF(IFNULL(Var_LlaveParametro, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr      := 003;
			SET Par_ErrMen    := 'llave incorrecta.';
			SET Var_Control   := 'llaveParametro';
			LEAVE ManejoErrores;
		END IF;



		UPDATE PARAMGENERALES SET
			ValorParametro    = Par_ValorParametro
			WHERE LlaveParametro = Var_LlaveParametro;



		SET	Par_NumErr := Entero_Cero;
		SET	Par_ErrMen := 'Catalogo Grabado Exitosamente.';
		SET Var_Control:= 'llaveParametro' ;



	END ManejoErrores;


	IF (Par_Salida = Salida_SI) THEN
		SELECT	CONVERT(Par_NumErr, CHAR(10)) AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS control;
	END IF;

END TerminaStore$$