-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLAZOSPORPRODUCTOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLAZOSPORPRODUCTOALT`;DELIMITER $$

CREATE PROCEDURE `PLAZOSPORPRODUCTOALT`(
# =====================================================================================
# --- SP PARA REGISTRAR LOS PLAZOS DE APORTACIONES EN LA TABLA PLAZOS POR PRODUCTOS ---
# =====================================================================================
  Par_Plazo       INT(11),    -- Dias del plazo
  Par_TipoInstrumentoID INT(11),    -- Tipo de instrumento
  Par_TipoProductoID    INT(11),    -- Tipo de producto

  Par_Salida        CHAR(1),    -- especifica salida
    INOUT Par_NumErr    INT(11),    -- INOUT NumErr
    INOUT Par_ErrMen    VARCHAR(400), -- INOUT ErrMen

  Par_Empresa       INT(11),    -- Parametro de Auditoria
  Aud_Usuario       INT(11),    -- Parametro de Auditoria
  Aud_FechaActual     DATETIME,   -- Parametro de Auditoria
  Aud_DireccionIP     VARCHAR(15),  -- Parametro de Auditoria
  Aud_ProgramaID      VARCHAR(50),  -- Parametro de Auditoria
  Aud_Sucursal      INT(11),    -- Parametro de Auditoria
  Aud_NumTransaccion    BIGINT(20)    -- Parametro de Auditoria
)
TerminaStore: BEGIN

    -- Declaracion de variables
  DECLARE Var_Control   VARCHAR(50);    -- Valor de control
  DECLARE Var_Consecutivo INT(11);      -- Valor consecutivo

    -- Declaracion de constantes
  DECLARE Cadena_Vacia  CHAR(1);
  DECLARE Fecha_Vacia   DATE;
  DECLARE Entero_Cero   INT(11);
  DECLARE SalidaSI    CHAR(1);

    -- Asignacion de constantes
  SET Cadena_Vacia    := '';        -- Cadena vacia
  SET Fecha_Vacia     := '1900-01-01';  -- Fecha vacia
  SET Entero_Cero     := 0;       -- Constante entero cero
  SET Aud_FechaActual   := NOW();     -- Obtiene Fecha actual
  SET SalidaSI      := 'S';       -- Salida si

  ManejoErrores:BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
      BEGIN
        SET Par_NumErr = 999;
        SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                    'Disculpe las molestias que esto le ocasiona. Ref: SP-PLAZOSPORPRODUCTOALT');
      END;

    IF (IFNULL(Par_Plazo,Entero_Cero)) = Entero_Cero THEN
      SET Par_NumErr  := 1;
      SET Par_ErrMen  := 'El Plazo esta vacio.';
      SET Var_Control := 'plazoSuperior';
      LEAVE ManejoErrores;
    END IF;

        IF (IFNULL(Par_TipoInstrumentoID,Entero_Cero)) = Entero_Cero THEN
      SET Par_NumErr  := 2;
      SET Par_ErrMen  := 'El Tipo de Instrumento esta vacio.';
      SET Var_Control := 'tipoInstrumentoID';
      LEAVE ManejoErrores;
    END IF;

        IF (IFNULL(Par_TipoProductoID,Entero_Cero)) = Entero_Cero THEN
      SET Par_NumErr  := 3;
      SET Par_ErrMen  := 'El Tipo de Producto esta vacio.';
      SET Var_Control := 'tipoAportacionID';
      LEAVE ManejoErrores;
    END IF;

        SET Var_Consecutivo := (SELECT MAX(PlazoID) FROM PLAZOSPORPRODUCTOS);
        SET Var_Consecutivo := IFNULL(Var_Consecutivo,Entero_Cero)+1;

    INSERT PLAZOSPORPRODUCTOS (
        `PlazoID`,      `Plazo`,      `TipoInstrumentoID`,  `TipoProductoID`, `EmpresaID`,
        `Usuario`,      `FechaActual`,    `DireccionIP`,      `ProgramaID`,   `Sucursal`,
                `NumTransaccion`)
      VALUES (
        Var_Consecutivo,  Par_Plazo,      Par_TipoInstrumentoID,  Par_TipoProductoID, Par_Empresa,
        Aud_Usuario,    Aud_FechaActual,  Aud_DireccionIP,    Aud_ProgramaID,   Aud_Sucursal,
        Aud_NumTransaccion);

    SET Par_NumErr    := 000;
        SET Par_ErrMen    := "Plazo(s) Agregado(s) Exitosamente.";
    SET Var_Control   := 'tipoAportacionID';
    SET Var_Consecutivo := Entero_Cero;

  END ManejoErrores;

  IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
        Par_ErrMen AS ErrMen,
        Var_Control AS control,
        Var_Consecutivo AS consecutivo;
  END IF;

END TerminaStore$$