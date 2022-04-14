-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONCEPTOSDISPERSIONMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONCEPTOSDISPERSIONMOD`;
DELIMITER $$

CREATE PROCEDURE `CONCEPTOSDISPERSIONMOD`(
-- =====================================================================================
-- ----------- SP PARA MODIFICAR EL CATALOGO DE CONCEPTOS DE DISPERSION---------------
-- =====================================================================================
    Par_ConceptoID          INT(11),
    Par_Nombre              VARCHAR(100),
    Par_Estatus             CHAR(1),
    Par_Descripcion         VARCHAR(200),

    Par_Salida			    CHAR(1),
	INOUT Par_NumErr	    INT(11),
	INOUT Par_ErrMen	    VARCHAR(400),
    -- Parametros de Auditoria
	Aud_EmpresaID		    INT(11),
	Aud_Usuario			    INT(11),
	Aud_FechaActual		    DATETIME,
	Aud_DireccionIP		    VARCHAR(15),
	Aud_ProgramaID		    VARCHAR(50),
	Aud_Sucursal		    INT(11),
	Aud_NumTransaccion	    BIGINT(20)
    )
TerminaStore: BEGIN

    -- Declaracion de Variables
    DECLARE Var_Control	    VARCHAR(45);
    DECLARE Var_ConceptoID  INT(11);
    -- Declaracion de Constantes
    DECLARE SalidaSI		CHAR(1);
	DECLARE Cadena_Vacia	CHAR;
    DECLARE Entero_Cero		INT;
    DECLARE Entero_Uno		INT;
    DECLARE Var_Activo      CHAR(1);
    DECLARE Var_Inactivo    CHAR(1);

    -- Seteo de Constantes
    SET SalidaSI			:= 'S';
	SET Cadena_Vacia		:= '';
    SET Entero_Cero			:= 0;
    SET Entero_Uno			:= 1;
   	SET Var_Activo		    := 'A';
	SET Var_Inactivo		:= 'I';



    ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CONCEPTOSDISPERSIONMOD');
				SET Var_Control = 'SQLEXCEPTION';
			END;

        SET Var_ConceptoID := (SELECT ConceptoDispersionID FROM CATCONCEPTOSDISPERSION WHERE ConceptoDispersionID = Par_ConceptoID );
        SET Var_ConceptoID := IFNULL(Var_ConceptoID,Entero_Cero);

        IF(Var_ConceptoID = Entero_Cero)THEN
            SET Par_NumErr  := 001;
			SET Par_ErrMen  := 'El Concepto de Dispersion no Existe';
			SET Var_Control := 'conceptoID';
			LEAVE ManejoErrores;
        END IF;

         IF(Par_Nombre = Cadena_Vacia)THEN
            SET Par_NumErr  := 001;
			SET Par_ErrMen  := 'Indique Nombre para el Concepto';
			SET Var_Control := 'nombre';
			LEAVE ManejoErrores;
        END IF;

        IF(Par_Estatus NOT IN (Var_Activo,Var_Inactivo ))THEN
            SET Par_NumErr  := 002;
			SET Par_ErrMen  := 'El Estatus es Incorrecto';
			SET Var_Control := 'estatus';
			LEAVE ManejoErrores;
        END IF;

        IF(Par_Descripcion = Cadena_Vacia )THEN
            SET Par_NumErr  := 003;
			SET Par_ErrMen  := 'Indique Descripcion del Concepto';
			SET Var_Control := 'descripcion';
			LEAVE ManejoErrores;
        END IF;

        UPDATE CATCONCEPTOSDISPERSION SET
            NombreConcepto  =   Par_Nombre,
            Descripcion     =   Par_Descripcion,
            Estatus         =   Par_Estatus,

            Usuario 		= 	Aud_Usuario,
			FechaActual 	= 	Aud_FechaActual,
			DireccionIP 	= 	Aud_DireccionIP,
			ProgramaID 		= 	Aud_ProgramaID,
			Sucursal 		= 	Aud_Sucursal,
			NumTransaccion 		= 	Aud_NumTransaccion
        WHERE ConceptoDispersionID = Par_ConceptoID;


        SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= CONCAT("Concepto de Dispersion Modificado Exitosamente: ",CONVERT(Par_ConceptoID,CHAR));
		SET Var_Control	:= 'conceptoID';

    END ManejoErrores;

    IF (Par_Salida = SalidaSI) THEN
        SELECT	Par_NumErr AS NumErr,
                Par_ErrMen AS ErrMen,
                Var_Control AS control,
                Par_ConceptoID AS	consecutivo;
    END IF;

END TerminaStore$$