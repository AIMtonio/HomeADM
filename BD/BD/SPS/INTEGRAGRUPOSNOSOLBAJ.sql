-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INTEGRAGRUPOSNOSOLBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `INTEGRAGRUPOSNOSOLBAJ`;DELIMITER $$

CREATE PROCEDURE `INTEGRAGRUPOSNOSOLBAJ`(
    Par_GrupoID         BIGINT(12),
    Par_ClienteID       INT(11),
    Par_TipoBaj         INT,

    Par_Salida          CHAR(1),
    INOUT   Par_NumErr     INT(11),
    INOUT   Par_ErrMen     VARCHAR(400),

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)

        )
TerminaStore: BEGIN

DECLARE Elimina     INT;
DECLARE SalidaSI    CHAR(1);
DECLARE Entero_Cero INT;


DECLARE Var_Control VARCHAR(200);


SET Elimina     :=3;
SET SalidaSI    :='S';
SET Entero_Cero :=0;

ManejoErrores: BEGIN

IF(Par_TipoBaj = Elimina)THEN

    DELETE FROM INTEGRAGRUPONOSOL
        WHERE GrupoID=Par_GrupoID;

    UPDATE GRUPOSNOSOLIDARIOS SET
        NumIntegrantes = 0
    WHERE GrupoID=Par_GrupoID;

    SET Par_NumErr  := 000;
    SET Par_ErrMen  :='Integrante(s) Eliminado(s) Exitosamente';
    SET Var_Control := 'grupoID';
END IF;


END ManejoErrores;
IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Par_GrupoID AS consecutivo;
END IF;

END TerminaStore$$