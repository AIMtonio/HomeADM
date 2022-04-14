-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ACTUALIZAPOLIZA
DELIMITER ;
DROP PROCEDURE IF EXISTS `ACTUALIZAPOLIZA`;DELIMITER $$

CREATE PROCEDURE `ACTUALIZAPOLIZA`(
# ====================================================================
# -------SP ENCARGADO DE ACTUALIZAR LAS POLIZAS REPETIDAS--------
# ====================================================================
    Par_Salida              CHAR(1),            -- Tipo de Salida.
    INOUT Par_NumErr        INT(11),            -- Numero de Error.
    INOUT Par_ErrMen        VARCHAR(400),       -- Mensaje de Error.

    Par_EmpresaID           INT(11),            -- Parametro de Auditoria
    Aud_Usuario             INT(11),            -- Parametro de Auditoria
    Aud_FechaActual         DATETIME,           -- Parametro de Auditoria
    Aud_DireccionIP         VARCHAR(15),        -- Parametro de Auditoria
    Aud_ProgramaID          VARCHAR(50),        -- Parametro de Auditoria
    Aud_Sucursal            INT(11),            -- Parametro de Auditoria
    Aud_NumTransaccion      BIGINT(20)          -- Parametro de Auditoria
)
TerminaStored : BEGIN

-- Declaracion de Constantes
DECLARE PolizaRepetida      BIGINT(12);
DECLARE PolizaAct           BIGINT(12);
DECLARE SalidaSI            CHAR(1);

-- Declaracion de Variables
DECLARE Var_Control         VARCHAR(50);        -- Control ID

-- Declaracion de cursor
DECLARE CursorActualiaPoliza CURSOR FOR
SELECT  PolizaID
    FROM POLIZACONTABLE
    WHERE PolizaID IN(SELECT PolizaID
                    FROM `HIS-POLIZACONTA`);

-- Asignacion de Constantes
SET SalidaSI            := 'S'; -- El Store si regresa una Salida

ManejoErrores:BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
                BEGIN
                    SET Par_NumErr  := 999;
                    SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                            'Disculpe las molestias que esto le ocasiona. Ref: SP-ACTUALIZAPOLIZA');
                    SET Var_Control := 'SQLEXCEPTION';
        END;

                /*Se insertan las Polizas que se encuentran repetidas */
                INSERT INTO POLIZASMODIFICADAS( PolizaID,       EmpresaID,      Fecha,          Tipo,           ConceptoID,
                                                Concepto,       Usuario,        FechaActual,    DireccionIP,    ProgramaID,
                                                Sucursal,       NumTransaccion)
                                        SELECT  PolizaID,       EmpresaID,      Fecha,          Tipo,           ConceptoID,
                                                Concepto,       Usuario,        FechaActual,    DireccionIP,    ProgramaID,
                                                Sucursal,       NumTransaccion
                                        FROM POLIZACONTABLE
                                        WHERE PolizaID IN(SELECT PolizaID FROM `HIS-POLIZACONTA`);

                       OPEN CursorActualiaPoliza;
                            BEGIN
                                DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
                                CICLO:LOOP
                                    FETCH CursorActualiaPoliza INTO PolizaRepetida;

                                    SELECT MAX(PolizaID)+1 INTO PolizaAct FROM POLIZACONTABLE;

                                            UPDATE POLIZACONTABLE SET
                                            PolizaID = PolizaAct
                                            WHERE PolizaID=PolizaRepetida;

                                            UPDATE DETALLEPOLIZA SET
                                            PolizaID = PolizaAct
                                            WHERE PolizaID=PolizaRepetida;

                                            UPDATE POLIZASMODIFICADAS SET
                                            PolizaActual = PolizaAct
                                            WHERE PolizaID=PolizaRepetida;

                                END LOOP CICLO;
                            END;
                        CLOSE CursorActualiaPoliza;

        SET Par_NumErr  := 0;
        SET Par_ErrMen  := 'Polizas Actualizadas Correctamente';
        SET Var_Control := 'PolizaID';
END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
        SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
                        Par_ErrMen           AS ErrMen,
                        Var_Control          AS Control;
END IF;

END TerminaStored$$