-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INCONSISTENCIASALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `INCONSISTENCIASALT`;DELIMITER $$

CREATE PROCEDURE `INCONSISTENCIASALT`(
-- ============================================================================================================
-- SP PARA REGISTRAR LAS INCONSISTENCIAS QUE EXISTEN EN LOS NOMBRES DE CLIENTES, PROSPECTOS, AVALES Y GARANTES
-- ============================================================================================================

	Par_ClienteID			INT(11),		-- ID del Cliente
	Par_ProspectoID			BIGINT(20),		-- ID del Prospecto
	Par_AvalID				BIGINT(20),		-- ID del Aval
	Par_GaranteID			INT(11),		-- ID del Garante
    Par_NombreCompleto		VARCHAR(200),	-- Inconsistencia

    Par_Comentario			VARCHAR(200),	-- Comentario acerca de la Inconsistencia

	Par_Salida				CHAR(1),		# Tipo de Salida S.- Si N.- No
	INOUT Par_NumErr		INT(11),		# Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	# Mensaje de Error

	/* Parametros de Auditoria */
	Aud_EmpresaID 			INT(11),
	Aud_Usuario 			INT(11),
  	Aud_FechaActual 		DATETIME,
  	Aud_DireccionIP 		VARCHAR(15),
  	Aud_ProgramaID 			VARCHAR(50),
  	Aud_Sucursal 			INT(11),
  	Aud_NumTransaccion 		BIGINT(20)

)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE Cadena_Vacia	CHAR(1);
    DECLARE Entero_Cero		INT(11);
	DECLARE Cons_SI			CHAR(1);

	-- Declaracion de variables
	DECLARE Var_Control 		VARCHAR(50); 		-- Variable Control Pantalla
    DECLARE	Var_Consecutivo 	INT(11); 			-- Variable Consecutivo
    DECLARE Var_NombreCampo		VARCHAR(20);		-- Nombre del campo en el que se posicionara el foco en caso de un mensaje de exito



	-- Asignacion  de constantes
	SET Cadena_Vacia 		:= '';		-- Constante: Cadena Vacia
    SET Entero_Cero			:= 0;		-- Constante: Entero Cero
	SET Cons_SI				:= 'S';		-- Constante: SI


	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
							'Disculpe las molestias que esto le ocasiona. Ref: SP-INCONSISTENCIASALT');
			SET Var_Control	:='SQLEXCEPTION';
		END;

    IF(IFNULL(Par_ClienteID,Entero_Cero) = Entero_Cero AND IFNULL(Par_ProspectoID,Entero_Cero) = Entero_Cero
		AND IFNULL(Par_AvalID,Entero_Cero) = Entero_Cero AND IFNULL(Par_GaranteID,Entero_Cero) = Entero_Cero) THEN
		SET Par_NumErr := 01;
        SET Par_ErrMen := 'Especifique un valor.';
        SET Var_Control := 'clienteID';
        LEAVE ManejoErrores;
    END IF;


    IF(IFNULL(Par_NombreCompleto,Cadena_Vacia)=Cadena_Vacia)THEN
		SET Par_NumErr := 02;
		SET Par_ErrMen := 'El Nombre esta Vacio.';
		SET Var_Control := 'nombreCompleto';
		LEAVE ManejoErrores;
	END IF;

	 IF(IFNULL(Par_Comentario,Cadena_Vacia)=Cadena_Vacia)THEN
		SET Par_NumErr := 03;
		SET Par_ErrMen := 'El Comentario esta Vacio.';
		SET Var_Control := 'comentario';
		LEAVE ManejoErrores;
	END IF;

    IF EXISTS((
		SELECT * FROM INCONSISTENCIAS
			WHERE ClienteID	= Par_ClienteID
			AND 	ProspectoID	= Par_ProspectoID
			AND		AvalID 		= Par_AvalID
			AND		GaranteID 	= Par_GaranteID))THEN

		SET Par_NumErr := 04;
        SET Par_ErrMen := 'Ya existe una inconsistencia para la Persona Consultada';
        SET Var_Control := 'clienteID';
        LEAVE ManejoErrores;

    END IF;

    /* Se evalua el valor que traen los parametros para definir si se esta evaluando un CLIENTE, PROSPECTO, AVAL o GARANTE
    y asi determinar en donde se regresara el foco y el valor que se mostrara en el campo en caso de un mensaje de exito
    */
    IF(Par_ClienteID > Entero_Cero) THEN
		SET Var_NombreCampo := 'clienteID';
        SET Var_Consecutivo := Par_ClienteID;
    END IF;

    IF(Par_ProspectoID > Entero_Cero) THEN
		SET Var_NombreCampo := 'prospectoID';
         SET Var_Consecutivo := Par_ProspectoID;
    END IF;

    IF(Par_AvalID > Entero_Cero) THEN
		SET Var_NombreCampo := 'avalID';
         SET Var_Consecutivo := Par_AvalID;
    END IF;

    IF(Par_GaranteID > Entero_Cero) THEN
		SET Var_NombreCampo := 'garanteID';
         SET Var_Consecutivo := Par_GaranteID;
    END IF;


	-- Se insertan los registros
	INSERT INTO INCONSISTENCIAS VALUES(
		Par_ClienteID,			Par_ProspectoID,		Par_AvalID,			Par_GaranteID,		Par_NombreCompleto,
        Par_Comentario,			Aud_EmpresaID,			Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

	IF(Par_NumErr<>Entero_Cero)THEN
		SET Var_Control := 'nombreCompleto';
		LEAVE ManejoErrores;
	END IF;


	SET Par_NumErr := Entero_Cero;
	SET Par_ErrMen := 'Registro Agregado Exitosamente';
	SET Var_Control := Var_NombreCampo;

	END ManejoErrores;

     IF(Par_Salida = Cons_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen  AS ErrMen,
				Var_Control AS control,
                Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$