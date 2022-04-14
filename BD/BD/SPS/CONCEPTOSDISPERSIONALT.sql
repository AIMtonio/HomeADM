-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONCEPTOSDISPERSIONALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONCEPTOSDISPERSIONALT`;
DELIMITER $$

CREATE PROCEDURE `CONCEPTOSDISPERSIONALT`(
-- =====================================================================================
-- ----------- SP PARA DAR DE ALTA EL CATALOGO DE CONCEPTOS DE DISPERSION---------------
-- =====================================================================================

    Par_Nombre              VARCHAR(100),       -- Nombre de Concepto de Dispersion
    Par_Estatus             CHAR(1),            -- Estatus del Concepto de Dispersion
    Par_Descripcion         VARCHAR(200),       -- Descripcion del Concepto de Dispersion

    Par_Salida			    CHAR(1),            -- Tipo de Salida
	INOUT Par_NumErr	    INT(11),            -- Numero de Error
	INOUT Par_ErrMen	    VARCHAR(400),       -- Mensaje de Error
    -- Parametros de Auditoria
	Aud_EmpresaID		    INT(11),            -- Parametros de Auditoria
	Aud_Usuario			    INT(11),            -- Parametros de Auditoria
	Aud_FechaActual		    DATETIME,           -- Parametros de Auditoria
	Aud_DireccionIP		    VARCHAR(15),        -- Parametros de Auditoria
	Aud_ProgramaID		    VARCHAR(50),        -- Parametros de Auditoria
	Aud_Sucursal		    INT(11),            -- Parametros de Auditoria
	Aud_NumTransaccion	    BIGINT(20)          -- Parametros de Auditoria
    )
TerminaStore: BEGIN

    -- Declaracion de Variables
    DECLARE Var_Control	    VARCHAR(45);        -- Control de Manejo de Error
    DECLARE Var_ConceptoID  INT(11);            -- ID del Concepto
    -- Declaracion de Constantes
    DECLARE SalidaSI		CHAR(1);            -- Constante Salida SI
	DECLARE Cadena_Vacia	CHAR;               -- Constante Cadena Vacia
    DECLARE Entero_Cero		INT;                -- Constante Entero Cero
    DECLARE Entero_Uno		INT;                -- Constante Entero Uno
    DECLARE Con_Activo      CHAR(1);            -- Constante Estatus Activo
    DECLARE Con_Inactivo    CHAR(1);            -- Constante Estatus Inactivo

    -- Seteo de Constantes
    SET SalidaSI			:= 'S';
	SET Cadena_Vacia		:= '';
    SET Entero_Cero			:= 0;
    SET Entero_Uno			:= 1;
   	SET Con_Activo		    := 'A';
	SET Con_Inactivo		:= 'I';



    ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CONCEPTOSDISPERSIONALT');
				SET Var_Control = 'SQLEXCEPTION';
			END;

        IF(Par_Nombre = Cadena_Vacia)THEN
            SET Par_NumErr  := 001;
			SET Par_ErrMen  := 'Indique Nombre para el Concepto';
			SET Var_Control := 'nombre';
			LEAVE ManejoErrores;
        END IF;

        IF(Par_Estatus NOT IN (Con_Activo,Con_Inactivo ))THEN
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

        SET Var_ConceptoID := (SELECT MAX(ConceptoDispersionID) FROM CATCONCEPTOSDISPERSION);
        SET Var_ConceptoID := IFNULL(Var_ConceptoID,Entero_Cero) + Entero_Uno;

        INSERT INTO CATCONCEPTOSDISPERSION (
            ConceptoDispersionID,   NombreConcepto,     Descripcion,        Estatus,            EmpresaID,
            Usuario,                FechaActual ,       DireccionIP,        ProgramaID,         Sucursal,
            NumTransaccion
        )VALUES(
            Var_ConceptoID,         Par_Nombre,         Par_Descripcion,    Par_Estatus,        Aud_EmpresaID,
            Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
            Aud_NumTransaccion
        );

        SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= CONCAT("Concepto de Dispersion Agregado Exitosamente: ",CONVERT(Var_ConceptoID,CHAR));
		SET Var_Control	:= 'conceptoID';

    END ManejoErrores;

    IF (Par_Salida = SalidaSI) THEN
        SELECT	Par_NumErr AS NumErr,
                Par_ErrMen AS ErrMen,
                Var_Control AS control,
                Var_ConceptoID AS	consecutivo;
    END IF;

END TerminaStore$$