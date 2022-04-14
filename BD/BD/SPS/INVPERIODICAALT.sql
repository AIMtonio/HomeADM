-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INVPERIODICAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `INVPERIODICAALT`;
DELIMITER $$


CREATE PROCEDURE `INVPERIODICAALT`(
-- =====================================================================================
--        STORED PARA LA ALTA DE LAS INVERSIONES CON PAGO PERIODICO
-- =====================================================================================
   Par_InversionID        INT,            -- Numero de inversion
   Par_Salida           CHAR(1),          -- Salida S: Si N: No
   INOUT  Par_NumErr        INT,            -- Numero de error
   INOUT  Par_ErrMen        VARCHAR(350),       -- Mensaje de Error

     -- Parametros de Auditoria
   Par_EmpresaID          INT,            -- Numero de Empresa
   Aud_Usuario          INT(11),          -- Parametro de Auditoria
   Aud_FechaActual        DATETIME,         -- Parametro de Auditoria
   Aud_DireccionIP        VARCHAR(15),        -- Parametro de Auditoria
   Aud_ProgramaID         VARCHAR(50),        -- Parametro de Auditoria
   Aud_Sucursal         INT(11),          -- Parametro de Auditoria
   Aud_NumTransaccion       BIGINT(20)          -- Parametro de Auditoria

          )

TerminaStore: BEGIN

  -- Declaracion de Variables
  DECLARE VarControl          CHAR(15);   -- variable de control
  DECLARE Var_TipoInv         INT(11);    -- variable del Tipo de Inversion
    DECLARE Var_Periocidad        INT(11);    -- variable No de Dias que se realizara el Pago Periodico
    DECLARE Var_FechaInicio             DATE;           -- variable de Fecha de Inicio de la Inversion
    DECLARE Var_FechaProxPag            DATE;           -- variable de Fecha del Proximo Pago
    DECLARE Var_InvPagoPeriodico        CHAR(1);        -- variable Si paga o no Periodicamente las Inversiones

  -- Declaracion de Constantes
  DECLARE Cadena_Vacia        CHAR(1);
  DECLARE Entero_Cero         INT(11);
  DECLARE Entero_Uno          INT(11);
  DECLARE Decimal_Cero        DECIMAL(12,2);
  DECLARE Entero_Treinta        INT(11);

  DECLARE SalidaNO          CHAR(1);
  DECLARE SalidaSI          CHAR(1);
    DECLARE Cons_NO           CHAR(1);
  DECLARE Cons_SI           CHAR(1);

  -- Asignacion de constantes

  SET Cadena_Vacia        := '';  -- valor para settear una cadena vacia
  SET Entero_Cero         := 0; -- valor para settear el valor de cero
  SET Entero_Uno          := 1; -- valor para settear el valor de uno
  SET Entero_Treinta        := 30;  -- valor para settear el valor de treinta
  SET Decimal_Cero        := 0.00;-- valor para settear el valor de cero con decimales

  SET SalidaSI          := 'S'; -- constante para saber si tendra una salida
  SET SalidaNO          := 'N'; -- constante para saber si tendra una salida
    SET Cons_SI           := 'S'; -- constante SI
  SET Cons_NO           := 'N'; -- constante NO

  ManejoErrores:BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
      BEGIN
        SET Par_NumErr = 999;
        SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
          concretar la operacion. Disculpe las molestias que', 'esto le ocasiona. Ref: SP-INVPERIODICAALT');
        SET VarControl = 'SQLEXCEPTION' ;
      END;

        SELECT TipoInversionID, FechaInicio
        INTO Var_TipoInv, Var_FechaInicio
            FROM INVERSIONES
                WHERE InversionID = Par_InversionID;

        SET Var_InvPagoPeriodico := (SELECT PagoPeriodico
                    FROM CATINVERSION
                      WHERE TipoInversionID = Var_TipoInv);

        IF(Var_InvPagoPeriodico = Cons_SI) THEN

      SET Var_Periocidad := (SELECT PeriodicidadPago
                    FROM CATDIASPAGINV
                      WHERE TipoInversionID = Var_TipoInv);

      SET Var_Periocidad := IFNULL(Var_Periocidad, Entero_Treinta);

      SET Var_FechaProxPag := DATE_ADD(Var_FechaInicio,interval Var_Periocidad day);
      SET Var_FechaProxPag :=  (FUNCIONDIAHABIL(Var_FechaProxPag, 0, Entero_Uno));

      INSERT INTO INVERSIONESDIAPAG
      SELECT Par_InversionID,     Var_FechaInicio,       Var_FechaProxPag,       Var_Periocidad,      Par_EmpresaID,
          Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,       Aud_ProgramaID,      Aud_Sucursal,
          Aud_NumTransaccion;
        END IF;

    SET Par_NumErr  := 000;
    SET Par_ErrMen  := CONCAT('Inversion Periodica Agregada Exitosamente: ',Par_InversionID);
    SET varControl  := 'inversionID';


  END ManejoErrores;

  IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr    AS NumErr,
        Par_ErrMen    AS ErrMen,
        varControl    AS control,
        Par_InversionID AS consecutivo;
  END IF;

END TerminaStore$$