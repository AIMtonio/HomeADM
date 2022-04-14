-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATTIPOINGRESOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATTIPOINGRESOSALT`;DELIMITER $$

CREATE PROCEDURE `CATTIPOINGRESOSALT`(
	/*SP para dar de alta los registros de Ingresos para el CATALOGO INGRESOS*/
	Par_Tipo				VARCHAR(45),		# Tipo
    Par_Numero				INT(11),			# Consecutivo
	Par_Descripcion			VARCHAR(100),		# Descripcion
	Par_Estatus				CHAR(1),			# Estatus  A: Activo I: Inactivo
	Par_Salida				CHAR(1),			# Tipo de Salida S.- Si N.- No
	INOUT Par_NumErr		INT(11),			# Numero de Error

	INOUT Par_ErrMen		VARCHAR(400),		# Mensaje de Error
	/* Parametros de Auditoria */
	Aud_EmpresaID			INT(11) ,
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),

	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
	)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE Salida_SI 			CHAR(1);
    DECLARE Entero_Cero			INT(11);

	-- Declaracion de Variables
	DECLARE Var_Control			VARCHAR(20);
	DECLARE Var_Consecutivo		VARCHAR(50);

	-- Asignacion de constantes
	SET	Cadena_Vacia			:= '';
	SET Salida_SI				:= 'S';
    SET Entero_Cero 			:= 0;

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-CATTIPOINGRESOSALT');
			SET Var_Control	:= 'sqlException';
		END;

        SET Par_Tipo			:= IFNULL(Par_Tipo, Cadena_Vacia);
		SET Par_Numero			:= IFNULL(Par_Numero, Entero_Cero);
		SET Par_Descripcion		:= IFNULL(Par_Descripcion, Cadena_Vacia);
		SET Par_Estatus			:= IFNULL(Par_Estatus, Cadena_Vacia);

		IF(Par_Tipo	 =	Cadena_Vacia) THEN
			SET Par_NumErr		:= 001;
			SET Par_ErrMen		:= 'El Tipo No Puede Estar Vacio.';
			SET Var_Consecutivo	:= Cadena_Vacia;
			SET Var_Control		:= 'tipo';
            LEAVE ManejoErrores;
		END IF;

		IF(Par_Descripcion = Cadena_Vacia) THEN
			SET Par_NumErr		:= 003;
			SET Par_ErrMen		:= 'La Descripcion No Puede Estar Vacia.';
			SET Var_Consecutivo	:= Cadena_Vacia;
			SET Var_Control		:= 'descripcion';
            LEAVE ManejoErrores;
		END IF;

		IF(Par_Estatus = Cadena_Vacia) THEN
			SET Par_NumErr		:= 004;
			SET Par_ErrMen		:= 'El Estatus No Puede Estar Vacio.';
			SET Var_Consecutivo	:= Cadena_Vacia;
			SET Var_Control		:= 'estatus';
            LEAVE ManejoErrores;
		END IF;

        IF EXISTS(SELECT Numero FROM CATTIPOINGRESOS WHERE Numero = Par_Numero) THEN
			SET Par_NumErr		:= 005;
			SET Par_ErrMen		:= 'El Tipo ya Existe.';
			SET Var_Consecutivo	:= Cadena_Vacia;
			SET Var_Control		:= 'numero';
            LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual := NOW();

        SET Par_Numero:= (SELECT IFNULL(MAX(Numero),Entero_Cero) + 1
                            FROM CATTIPOINGRESOS);


		INSERT INTO CATTIPOINGRESOS(
			Numero,				Tipo,				Descripcion,		Estatus,		EmpresaID,
            Usuario,			FechaActual,		DireccionIP,		ProgramaID,		Sucursal,
            NumTransaccion)
		VALUES (
			Par_Numero,			Par_Tipo,			Par_Descripcion,	Par_Estatus,	Aud_EmpresaID,
            Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
            Aud_NumTransaccion);

		SET	Par_NumErr			:= 0;
		SET	Par_ErrMen			:= CONCAT('Ingreso Agregado Exitosamente: ', CONVERT(Par_Numero,CHAR));
		SET Var_Control			:= 'tipo';
		SET Var_Consecutivo		:= Par_Numero;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$