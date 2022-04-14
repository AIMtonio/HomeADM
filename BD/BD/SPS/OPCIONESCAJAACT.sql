-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- OPCIONESCAJAACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `OPCIONESCAJAACT`;
DELIMITER $$

CREATE PROCEDURE `OPCIONESCAJAACT`(
/* SP QUE ACTUALIZA LAS OPCIONES DE CAJA */
    Par_OpcionCajaID            INT(11),    -- ID de la Opcion de la Caja
    Par_SujetoPLDEscala         CHAR(1),    -- Indica si la opcion es sujeta de escalamiento interno
    Par_SujetoPLDIdenti         CHAR(1),    -- Indica si la opcion es sujeta de identificacion del cte
    Par_TipoActualizacion       TINYINT,    -- Tipo de Actualizacion
    Par_Salida                  CHAR(1),    -- Indica si el sp genera una salida

    INOUT Par_NumErr            INT,        -- Numero de Error
    INOUT Par_ErrMen            VARCHAR(400),-- Mensaje de Error
    /* Parametros de Auditoria */
    Aud_EmpresaID               INT(11),
    Aud_Usuario                 INT(11),
    Aud_FechaActual             DATETIME,

    Aud_DireccionIP             VARCHAR(15),
    Aud_ProgramaID              VARCHAR(50),
    Aud_Sucursal                INT(11),
    Aud_NumTransaccion          BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_Control             VARCHAR(50);
DECLARE Var_EvaluaPLD           CHAR(1);

-- Declaracion de Constantes
DECLARE Cadena_Vacia            CHAR(1);
DECLARE Entero_Cero             INT;
DECLARE TipoActOpcionesPLD      INT;
DECLARE SalidaSI                CHAR(1);
DECLARE ConsSI                  CHAR(1);
DECLARE ConsNO                  CHAR(1);

-- Asignacion de constantes
SET Cadena_Vacia        := '';              -- Cadena o string vacio
SET Entero_Cero         := 0;               -- Entero en cero
SET TipoActOpcionesPLD  := 1;               -- Tipo de actualizacuion para las opciones de PLD
SET SalidaSI            := 'S';             -- El Store SI genera una Salida
SET ConsSI              := 'S';             -- Constante SI
SET ConsNO              := 'N';             -- Constante NO

/* Obtiene Fecha de Base de Datos */
SET Aud_FechaActual := NOW();

ManejoErrores: BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr := 999;
            SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                'Disculpe las molestias que esto le ocasiona. Ref: SP-OPCIONESCAJAACT');
        END;

    IF(IFNULL(Par_TipoActualizacion,Entero_Cero)=TipoActOpcionesPLD)THEN
        IF NOT EXISTS(SELECT OpcionCajaID
                    FROM OPCIONESCAJA
                    WHERE OpcionCajaID=Par_OpcionCajaID)THEN
            SET Par_NumErr  := 1;
            SET Par_ErrMen  := CONCAT("La Opcion de Caja ",Par_OpcionCajaID,  " No Existe.");
            SET Var_Control := 'tipoOperacion' ;
            LEAVE ManejoErrores;
        END IF;

        IF (IFNULL(Par_SujetoPLDEscala,Cadena_Vacia) = Cadena_Vacia)THEN
            SET Par_NumErr  := 2;
            SET Par_ErrMen  := CONCAT('El Parametro Sujeto de Escalamiento esta vacio.');
            SET Var_Control := 'tipoOperacion' ;
            LEAVE ManejoErrores;
        END IF;

        IF (IFNULL(Par_SujetoPLDIdenti,Cadena_Vacia) = Cadena_Vacia)THEN
            SET Par_NumErr  := 3;
            SET Par_ErrMen  := CONCAT('El Parametro Identificacion Simplificada esta vacio.');
            SET Var_Control := 'tipoOperacion' ;
            LEAVE ManejoErrores;
        END IF;

        SET Var_EvaluaPLD := (SELECT EvaluaPLD FROM OPCIONESCAJA WHERE OpcionCajaID=Par_OpcionCajaID);

        IF (IFNULL(Var_EvaluaPLD,ConsNO) = ConsNO)THEN
            SET Par_NumErr  := 4;
            SET Par_ErrMen  := CONCAT("La Opcion de Caja ",Par_OpcionCajaID," No Requiere Ser Evaluada por PLD.");
            SET Var_Control := 'tipoOperacion' ;
            LEAVE ManejoErrores;
        END IF;

        UPDATE OPCIONESCAJA SET
            SujetoPLDEscala = Par_SujetoPLDEscala,
            SujetoPLDIdenti = Par_SujetoPLDIdenti,
            EmpresaID       = Aud_EmpresaID,
            Usuario         = Aud_Usuario,
            FechaActual     = Aud_FechaActual,

            DireccionIP     = Aud_DireccionIP,
            ProgramaID      = Aud_ProgramaID,
            Sucursal        = Aud_Sucursal,
            NumTransaccion  = Aud_NumTransaccion
            WHERE OpcionCajaID=Par_OpcionCajaID;

        SET Par_NumErr  := 0;
        SET Par_ErrMen  := CONCAT('Opcion de Caja Actualizada Exitosamente: ', CONVERT(Par_OpcionCajaID,CHAR(2)));
        LEAVE ManejoErrores;
    END IF;

END ManejoErrores;  -- End del Handler de Errores

IF(Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            'opcionCajaID' AS control,
             Entero_Cero AS consecutivo;
END IF;

END TerminaStore$$