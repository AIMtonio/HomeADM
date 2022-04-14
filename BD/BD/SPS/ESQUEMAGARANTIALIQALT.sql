-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMAGARANTIALIQALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMAGARANTIALIQALT`;DELIMITER $$

CREATE PROCEDURE `ESQUEMAGARANTIALIQALT`(
-- --------------------------------------------------------------------------------
-- Procedimiento para dar de alta un esquema de garantia liquida para un Producto de Credito
-- --------------------------------------------------------------------------------
  /* Declaracion de parametros */
  Par_ProducCreditoID   INT(11),    # Id del producto de credito
  Par_Clasificacion   CHAR(1),    # Clasificacion del cliente, A,B,C,N
  Par_LimiteInferior    DECIMAL(14,2),  # Lmimite inferior del rango para el esquema
  Par_LimiteSuperior    DECIMAL(14,2),  # Lmimite superior del rango para el esquema
  Par_Porcentaje      DECIMAL(14,2),  # Porcentaje
    Par_PorcBonifFOGA   DECIMAL(14,2),  # Porcentaje de Bonificacion FOGA



  Par_EsPrimero     CHAR(1),    # indica si es el primer registro del grid para q elimine todos los existentes

  Par_Salida        CHAR(1), --
  INOUT Par_NumErr    INT,
  INOUT Par_ErrMen    VARCHAR(400),

  /* parametros de auditoria */
  Par_EmpresaID     INT,
  Aud_Usuario       INT,
  Aud_FechaActual     DATETIME,
  Aud_DireccionIP     VARCHAR(15),
  Aud_ProgramaID      VARCHAR(50),
  Aud_Sucursal      INT,
  Aud_NumTransaccion    BIGINT
  )
TerminaStore:BEGIN  #bloque main del sp

  /* declaracion de variables*/
  DECLARE varControl        VARCHAR(100); # almacena el elmento que es incorrecto
  DECLARE Var_ConsecutivoID INT(10);
  DECLARE Var_BonificacionFOGA CHAR(1);     # Indica si aplica o no bonificación


  /* declaracion de constantes*/
  DECLARE Entero_Cero     INT;      # entero cero
  DECLARE Decimal_Cero    DECIMAL;    # decimal cero
  DECLARE Cadena_Vacia    CHAR(1);    # cadena vacia
  DECLARE Salida_SI     CHAR(1);    # salida SI
  DECLARE EliminarExistentes  CHAR(1);    # Indica si elimina los registros existente para el tipo de producto de credito indicado


  /* asignacion de constantes*/
  SET Entero_Cero     :=0;
  SET Decimal_Cero    :=0.0;
  SET Cadena_Vacia    :='';
  SET Salida_SI     :='S';
  SET EliminarExistentes  :='S';

  /* Asignacion de Variables */
  SET Par_NumErr    := 0;
  SET Par_ErrMen    := '';



  ManejoErrores:BEGIN   #bloque para manejar los posibles errores
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
      BEGIN
        SET Par_NumErr = '999';
        SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                  'Disculpe las molestias que esto le ocasiona. Ref: SP-ESQUEMAGARANTIALIQALT');
        SET varControl = 'SQLEXCEPTION' ;
    END;



  # Verifica si eliminara los registros existentes para el producto de credito indicado
  IF (Par_EsPrimero = EliminarExistentes) THEN
    DELETE FROM ESQUEMAGARANTIALIQ
      WHERE ProducCreditoID = Par_ProducCreditoID;
  END IF;

    IF(IFNULL(Par_ProducCreditoID,Entero_Cero))= Entero_Cero THEN
      SET Par_NumErr  := '002';
      SET Par_ErrMen  := 'El Producto de Credito esta vacio.';
      SET varControl  := 'producCreditoID' ;
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_Clasificacion,Cadena_Vacia))= Cadena_Vacia THEN
      SET Par_NumErr  := '003';
      SET Par_ErrMen  := 'La Clasificacion esta vacia.';
      SET varControl  := 'agregar' ;
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_LimiteSuperior,Decimal_Cero))= Cadena_Vacia THEN
      SET Par_NumErr  := '004';
      SET Par_ErrMen  := 'El Monto Superior esta vacio.';
      SET varControl  := 'agregar' ;
      LEAVE ManejoErrores;
    END IF;

    IF EXISTS(SELECT EsquemaGarantiaLiqID
          FROM ESQUEMAGARANTIALIQ
          WHERE ProducCreditoID = Par_ProducCreditoID
            AND Clasificacion = Par_Clasificacion
            AND ((Par_LimiteInferior >= LimiteInferior AND Par_LimiteSuperior <= LimiteSuperior)
              OR  (Par_LimiteInferior <= LimiteSuperior AND Par_LimiteSuperior >= LimiteSuperior)
              OR  (Par_LimiteInferior <= LimiteInferior AND Par_LimiteSuperior >= LimiteInferior))
              LIMIT 1)THEN
        SET Par_NumErr  := '005';
        SET Par_ErrMen  := 'Existe un Esquema FOGA para el Producto de Credito, Clasificacion Y Montos indicados.';
        SET varControl  := 'agregar' ;
        LEAVE ManejoErrores;
    END IF;

    IF(Par_LimiteInferior > Par_LimiteSuperior)THEN
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

    IF(IFNULL(Par_Porcentaje,Entero_Cero)=Entero_Cero)THEN
    SET Par_NumErr  := '008';
    SET Par_ErrMen  := 'El Porcentaje de Garantia FOGA es Incorrecto.';
    SET varControl  := 'agregar' ;
    LEAVE ManejoErrores;
    END IF;

    SELECT BonificacionFOGA INTO Var_BonificacionFOGA
    FROM PRODUCTOSCREDITO
  WHERE ProducCreditoID = Par_ProducCreditoID;

    IF(IFNULL(Var_BonificacionFOGA,Cadena_Vacia)='S' AND IFNULL(Par_PorcBonifFOGA,Entero_Cero)=Entero_Cero)THEN
    SET Par_NumErr  := '009';
    SET Par_ErrMen  := 'El Porcentaje de Bonificacion FOGA es Incorrecto.';
    SET varControl  := 'agregar' ;
    LEAVE ManejoErrores;
    END IF;

  /* efectuamos la insercion del nuevo esquema */
  SET Aud_FechaActual := NOW();
  CALL FOLIOSAPLICAACT('ESQUEMAGARANTIALIQ', Var_ConsecutivoID);

   INSERT INTO ESQUEMAGARANTIALIQ(EsquemaGarantiaLiqID,   ProducCreditoID,    Clasificacion,    LimiteInferior,     LimiteSuperior,
                  Porcentaje,         BonificacionFOGA,   EmpresaID,      Usuario,        FechaActual,
                                    DireccionIP,        ProgramaID,       Sucursal,     NumTransaccion)
            VALUES(   Var_ConsecutivoID,      Par_ProducCreditoID,  Par_Clasificacion,  Par_LimiteInferior,   Par_LimiteSuperior,
                  Par_Porcentaje,       Par_PorcBonifFOGA,    Par_EmpresaID,    Aud_Usuario,      Aud_FechaActual,
                                    Aud_DireccionIP,      Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion);

  SET Par_NumErr  := '000';
  SET Par_ErrMen  := 'Esquema(s) de Garantia Liquida Grabado(s) exitosamente.';
  SET varControl  := 'producCreditoID' ;
  LEAVE ManejoErrores;


END ManejoErrores; /*fin del manejador de errores*/



  IF (Par_Salida = Salida_SI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
        Par_ErrMen     AS ErrMen,
        varControl     AS control,
        Par_ProducCreditoID  AS consecutivo;
  END IF;

END TerminaStore$$