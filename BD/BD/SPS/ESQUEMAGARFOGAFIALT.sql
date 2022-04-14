-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMAGARFOGAFIALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMAGARFOGAFIALT`;DELIMITER $$

CREATE PROCEDURE `ESQUEMAGARFOGAFIALT`(
-- ===========================================================================
-- SP PARA EL ALTA DE ESQUEMAS GRID DE LA GARANTÍA FINANCIADA POR PRODUCTO
-- ===========================================================================
  Par_ProducCreditoID     INT(11),      # Indica Número de Producto
  Par_ClasificacionFOGAFI   CHAR(1),      # Indica Clasificación de FOGAFI
  Par_LimiteInferiorFOGAFI  DECIMAL(14,2),    # Indica Límite Inferior del Ciclo
  Par_LimiteSuperiorFOGAFI  DECIMAL(14,2),    # Indica Límite Superior del Ciclo
  Par_PorcentajeFOGAFI    DECIMAL(14,2),    # Indica Porcentaje de  FOGAFI

    Par_PorcBonifFOGAFI     DECIMAL(14,2),    # Indica Porcentaje de Bonificación para FOGAFI
  Par_EsPrimero       CHAR(1),      # Indica la Perlacion de la Garantía

  Par_Salida        CHAR(1),
  INOUT Par_NumErr    INT,
  INOUT Par_ErrMen    VARCHAR(400),

  # Parametros de Auditoria
  Par_EmpresaID     INT,
  Aud_Usuario       INT,
  Aud_FechaActual     DATETIME,
  Aud_DireccionIP     VARCHAR(15),
  Aud_ProgramaID      VARCHAR(50),
  Aud_Sucursal      INT,
  Aud_NumTransaccion    BIGINT
  )
TerminaStore:BEGIN

  /* Declaración de Variables */
  DECLARE varControl        VARCHAR(100); # Indica el Control en Pantalla
  DECLARE Var_ConsecutivoID INT(10);    # Indica el Consecutivo
  DECLARE Var_BonificacionFOGAFI CHAR(1);     # Indica si aplica bonificación o no


  /* Declaracion de Constantes */
  DECLARE Entero_Cero     INT;      # Constante: Entero Cero
  DECLARE Decimal_Cero    DECIMAL;    # Constante: Decimal Cero
  DECLARE Cadena_Vacia    CHAR(1);    # Constante: Cadena Vacía
  DECLARE Salida_SI     CHAR(1);    # Constante: Salida Si
  DECLARE EliminarExistentes  CHAR(1);    # Constante: Elimina Existentes

  /* Asignación de Constantes */
  SET Entero_Cero     :=0;    # Constante: Entero Cero
  SET Decimal_Cero    :=0.0;    # Constante: Decimal Cero
  SET Cadena_Vacia    :='';   # Constante: Cadena Vacía
  SET Salida_SI     :='S';    # Constante: Salida Si
  SET EliminarExistentes  :='S';    # Constante: Elimar Existentes S


  ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
      SET Par_NumErr := 999;
      SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                    'Disculpe las molestias que esto le ocasiona. Ref: SP-ESQUEMAGARFOGAFIALT');
      SET varControl := 'SQLEXCEPTIOS';
    END;

    # Verifica si eliminara los registros existentes para el producto de credito indicado
    IF (Par_EsPrimero = EliminarExistentes) THEN

      DELETE FROM ESQUEMAGARFOGAFI
        WHERE ProducCreditoID = Par_ProducCreditoID;

    END IF;

    IF(IFNULL(Par_ProducCreditoID,Entero_Cero))= Entero_Cero THEN
      SET Par_NumErr  := '002';
      SET Par_ErrMen  := 'El Producto de Credito esta vacio.';
      SET varControl  := 'producCreditoID' ;
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_ClasificacionFOGAFI,Cadena_Vacia))= Cadena_Vacia THEN
      SET Par_NumErr  := '003';
      SET Par_ErrMen  := 'La Clasificacion esta vacia.';
      SET varControl  := 'agregar' ;
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_LimiteSuperiorFOGAFI,Decimal_Cero))= Cadena_Vacia THEN
      SET Par_NumErr  := '004';
      SET Par_ErrMen  := 'El Monto Superior esta vacio.';
      SET varControl  := 'agregar' ;
      LEAVE ManejoErrores;
    END IF;

    IF EXISTS(SELECT EsquemaGarFogafiID
          FROM ESQUEMAGARFOGAFI
          WHERE ProducCreditoID = Par_ProducCreditoID
            AND Clasificacion = Par_ClasificacionFOGAFI
            AND ((Par_LimiteInferiorFOGAFI >= LimiteInferior AND Par_LimiteSuperiorFOGAFI <= LimiteSuperior)
              OR  (Par_LimiteInferiorFOGAFI <= LimiteSuperior AND Par_LimiteSuperiorFOGAFI >= LimiteSuperior)
              OR  (Par_LimiteInferiorFOGAFI <= LimiteInferior AND Par_LimiteSuperiorFOGAFI >= LimiteInferior))
              LIMIT 1)THEN
        SET Par_NumErr  := '005';
        SET Par_ErrMen  := 'Existe un Esquema FOGAFI para el Producto de Credito, Clasificacion Y Montos indicados.';
        SET varControl  := 'agregar' ;
        LEAVE ManejoErrores;
    END IF;

    IF(Par_LimiteInferiorFOGAFI > Par_LimiteSuperiorFOGAFI)THEN
      SET Par_NumErr  := '006';
      SET Par_ErrMen  := 'El Monto Inferior no debe ser mayor al Limite Superior.';
      SET varControl  := 'agregar' ;
      LEAVE ManejoErrores;
    END IF;


    IF NOT EXISTS(SELECT ProducCreditoID
          FROM PRODUCTOSCREDITO
          WHERE ProducCreditoID = Par_ProducCreditoID)THEN
        SET Par_NumErr  := '007';
        SET Par_ErrMen  := 'No existe el Producto de Credito.';
        SET varControl  := 'agregar' ;
        LEAVE ManejoErrores;
    END IF;

        IF(IFNULL(Par_PorcentajeFOGAFI,Entero_Cero)=Entero_Cero)THEN
      SET Par_NumErr  := '008';
      SET Par_ErrMen  := 'El Porcentaje de Garantia FOGAFI es Incorrecto.';
      SET varControl  := 'agregar' ;
      LEAVE ManejoErrores;
        END IF;

        SELECT BonificacionFOGAFI INTO Var_BonificacionFOGAFI
    FROM PRODUCTOSCREDITO
    WHERE ProducCreditoID = Par_ProducCreditoID;

        IF(IFNULL(Var_BonificacionFOGAFI,Cadena_Vacia)='S' AND IFNULL(Par_PorcBonifFOGAFI,Entero_Cero)=Entero_Cero)THEN
      SET Par_NumErr  := '009';
      SET Par_ErrMen  := 'El Porcentaje de Bonificacion FOGAFI es Incorrecto.';
      SET varControl  := 'agregar' ;
      LEAVE ManejoErrores;
    END IF;

    SET Aud_FechaActual := NOW();

    CALL FOLIOSAPLICAACT('ESQUEMAGARFOGAFI', Var_ConsecutivoID);

     INSERT INTO ESQUEMAGARFOGAFI(
          EsquemaGarFogafiID,     ProducCreditoID,    Clasificacion,        LimiteInferior,       LimiteSuperior,
          Porcentaje,         BonificacionFOGAFI,   EmpresaID,          Usuario,          FechaActual,
          DireccionIP,        ProgramaID,       Sucursal,         NumTransaccion)
      VALUES( Var_ConsecutivoID,      Par_ProducCreditoID,  Par_ClasificacionFOGAFI,  Par_LimiteInferiorFOGAFI, Par_LimiteSuperiorFOGAFI,
          Par_PorcentajeFOGAFI,   Par_PorcBonifFOGAFI,  Par_EmpresaID,        Aud_Usuario,        Aud_FechaActual,
          Aud_DireccionIP,      Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

    SET Par_NumErr  := '000';
    SET Par_ErrMen  := 'Esquema(s) de Garantia FOGAFI Grabado(s) exitosamente.';
    SET varControl  := 'producCreditoID' ;

  END ManejoErrores;

  IF (Par_Salida = Salida_SI) THEN
    SELECT  convert(Par_NumErr, CHAR(3)) AS NumErr,
        Par_ErrMen     AS ErrMen,
        varControl     AS control,
        Par_ProducCreditoID  AS consecutivo;
  end IF;

END TerminaStore$$