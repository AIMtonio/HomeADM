-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLAZOSAPORTACIONESBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLAZOSAPORTACIONESBAJ`;DELIMITER $$

CREATE PROCEDURE `PLAZOSAPORTACIONESBAJ`(
# ==================================================================
# ----------- SP PARA ELIMINAR LOS PLAZOS DE APORTACIONES ----------
# ==================================================================
  Par_TipoAportacionID  INT(11),    -- ID del tipo de aportacion

  Par_Salida        CHAR(1),    -- Especifica salida
  INOUT Par_NumErr    INT(11),    -- INOUT Par_NumErr
    INOUT Par_ErrMen    VARCHAR(400),   -- INOUT Par_ErrMen

  Par_Empresa       INT(11),    -- Parametro de auditoria
  Aud_Usuario       INT(11),    -- Parametro de auditoria
  Aud_FechaActual     DATETIME,   -- Parametro de auditoria
  Aud_DireccionIP     VARCHAR(15),  -- Parametro de auditoria
  Aud_ProgramaID      VARCHAR(50),  -- Parametro de auditoria
  Aud_Sucursal      INT(11),    -- Parametro de auditoria
  Aud_NumTransaccion    BIGINT(20)    -- Parametro de auditoria

)
TerminaStore: BEGIN

  -- Declaracion de variables
  DECLARE Var_Control   VARCHAR(200);   -- Valor de control
  DECLARE Var_Consecutivo INT(11);      -- Valor consecutivo

  -- Declaracion de constantes
  DECLARE Cadena_Vacia  CHAR(1);
  DECLARE Fecha_Vacia   DATE;
  DECLARE Entero_Cero   INT(11);
  DECLARE Salida_SI   CHAR(1);
    DECLARE Cons_InstAport  INT(11);
    DECLARE Salida_NO   CHAR(1);

  -- Asignacion de constantes
  SET Cadena_Vacia    := '';        -- Constante Cadena Vacia
  SET Fecha_Vacia     := '1900-01-01';  -- Constante fecha vacia
  SET Entero_Cero     := 0;       -- Constante entero cero
    SET Salida_SI     := 'S';       -- Constante Salida si
    SET Cons_InstAport    := 31;        -- Tipo instrumento Aportacion
    SET Salida_NO     := 'N';       -- Constante Salida no


  ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
      BEGIN
        SET Par_NumErr := '999';
        SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                     'esto le ocasiona. Ref: SP-PLAZOSAPORTACIONESBAJ');
        SET Var_Control := 'SQLEXCEPTION' ;
      END;


    DELETE  FROM PLAZOSAPORTACIONES
        WHERE TipoAportacionID  = Par_TipoAportacionID;

    -- eliminar plazos por productos
        CALL PLAZOSPORPRODUCTOBAJ(
              Par_TipoAportacionID, Cons_InstAport,   Salida_NO,      Par_NumErr,     Par_ErrMen,
                            Par_Empresa,      Aud_Usuario,    Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID,
                            Aud_Sucursal,     Aud_NumTransaccion);


    SET Par_NumErr  := 000;
    SET Par_ErrMen  := 'Plazos Eliminados Exitosamente.';
    SET Var_Control := 'tipoAportacionID';
    SET Var_Consecutivo := Entero_Cero;


END ManejoErrores;

  IF (Par_Salida = Salida_SI) THEN
    SELECT  Par_NumErr AS NumErr,
        Par_ErrMen AS ErrMen,
        Var_Control AS control,
        Var_Consecutivo AS consecutivo;
  END IF;

END TerminaStore$$