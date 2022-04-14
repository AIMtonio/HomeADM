-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GRUPOSNOSOLIDARIOSMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `GRUPOSNOSOLIDARIOSMOD`;DELIMITER $$

CREATE PROCEDURE `GRUPOSNOSOLIDARIOSMOD`(

    Par_GrupoID         BIGINT(12),
    Par_NombreGrupo     VARCHAR(200),
    Par_SucursalID      INT(11),
    Par_NumIntegrantes  INT(10),
    Par_PromotorID      INT(11),
    Par_LugarReunion    VARCHAR(200),

    Par_DiaReunion      VARCHAR(30),
    Par_HoraReunion     VARCHAR(50),
    Par_AhoObligatorio  DECIMAL(14,2),
    Par_PlazoCredito    VARCHAR(15),
    Par_CostoAusencia   DECIMAL(14,2),

    Par_AhorroCompro    DECIMAL(14,2),
    Par_MoraCredito     DECIMAL(14,2),
    Par_EstadoID        INT(11),
    Par_MunicipioID     INT(11),
    Par_Ubicacion       VARCHAR(800),


    Par_Salida              CHAR(1),
    INOUT   Par_NumErr      INT(11),
    INOUT   Par_ErrMen      VARCHAR(400),

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion BIGINT(20)
        )
TerminaStore: BEGIN

DECLARE Var_Control VARCHAR(200);



DECLARE SalidaSI        CHAR(1);
DECLARE Cadena_Vacia    CHAR(1);
DECLARE Entero_Cero     INT;


SET SalidaSI    := 'S';
SET Entero_Cero := 0;
SET Cadena_Vacia:='';


ManejoErrores: BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
                SET Par_NumErr = 999;
                SET Par_ErrMen = CONCAT('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
                                         'estamos trabajando para resolverla. Disculpe las molestias que ',
                                         'esto le ocasiona. Ref: SP-GRUPOSNOSOLIDARIOSMOD');
                SET Var_Control = 'sqlException' ;
            END;


IF (IFNULL(Par_PromotorID, Entero_Cero)) = Entero_Cero THEN
      SET Par_NumErr  := 001;
      SET Par_ErrMen  := 'Se Requiere el Promotor';
      SET Var_Control := 'promotorID';
      LEAVE ManejoErrores;
END IF;

IF (IFNULL(Par_NombreGrupo, Cadena_Vacia)) = Cadena_Vacia THEN
      SET Par_NumErr  := 002;
      SET Par_ErrMen  := 'Se Requiere Nombre del Grupo';
      SET Var_Control := 'nombreGrupo';
      LEAVE ManejoErrores;
END IF;

IF (IFNULL(Par_EstadoID, Entero_Cero)) > Entero_Cero THEN
        IF (IFNULL(Par_MunicipioID, Entero_Cero)) = Entero_Cero THEN
              SET Par_NumErr  := 003;
              SET Par_ErrMen  := 'Se Requiere el Municipio';
              SET Var_Control := 'municipioID';
              LEAVE ManejoErrores;
        END IF;
END IF;

SET Par_NombreGrupo     := IFNULL(Par_NombreGrupo, Cadena_Vacia);
SET Par_SucursalID      := IFNULL(Par_SucursalID, Entero_Cero);
SET Par_NumIntegrantes  := IFNULL(Par_NumIntegrantes, Entero_Cero);
SET Par_LugarReunion    := IFNULL(Par_LugarReunion, Cadena_Vacia);
SET Par_DiaReunion      := IFNULL(Par_DiaReunion, Cadena_Vacia);
SET Par_HoraReunion     := IFNULL(Par_HoraReunion, Cadena_Vacia);
SET Par_AhoObligatorio  := IFNULL(Par_AhoObligatorio, Entero_Cero);
SET Par_PlazoCredito    := IFNULL(Par_PlazoCredito, Cadena_Vacia);
SET Par_CostoAusencia   := IFNULL(Par_CostoAusencia, Entero_Cero);
SET Par_AhorroCompro    := IFNULL(Par_AhorroCompro, Entero_Cero);
SET Par_MoraCredito     := IFNULL(Par_MoraCredito, Entero_Cero);
SET Par_EstadoID        := IFNULL(Par_EstadoID, Entero_Cero);
SET Par_MunicipioID     := IFNULL(Par_MunicipioID, Entero_Cero);
SET Par_Ubicacion       := IFNULL(Par_Ubicacion, Cadena_Vacia);





UPDATE GRUPOSNOSOLIDARIOS SET

         NombreGrupo     = Par_NombreGrupo,
         SucursalID      = Par_SucursalID,
         NumIntegrantes  = NumIntegrantes,

         PromotorID          = Par_PromotorID,
         LugarReunion    = Par_LugarReunion,
         DiaReunion      = Par_DiaReunion,
         HoraReunion     = Par_HoraReunion,
         AhoObligatorio  = Par_AhoObligatorio,

         PlazoCredito    = Par_PlazoCredito,
         CostoAusencia   = Par_CostoAusencia,
         AhorroCompro    = Par_AhorroCompro,
         MoraCredito     = Par_MoraCredito,
         EstadoID        = Par_EstadoID,

         MunicipioID     = Par_MunicipioID,
         Ubicacion       = Par_Ubicacion,
         EmpresaID       = Par_EmpresaID,
         Usuario         = Aud_Usuario,

        FechaActual      = Aud_FechaActual,
        DireccionIP      = Aud_DireccionIP,
        ProgramaID       = Aud_ProgramaID,
        Sucursal         = Aud_Sucursal,
         NumTransaccion  = Aud_NumTransaccion
WHERE GrupoID = Par_GrupoID;


SET Par_NumErr  := 000;
SET Par_ErrMen  :=CONCAT("Grupo No Solidario Modificado Exitosamente: ", CONVERT(Par_GrupoID, CHAR));
SET Var_Control := 'grupoID';

END ManejoErrores;
IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            IFNULL(Par_GrupoID,Entero_Cero) AS consecutivo;
END IF;

END TerminaStore$$