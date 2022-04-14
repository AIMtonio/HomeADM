-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INTEGRAGRUPONOSOLALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `INTEGRAGRUPONOSOLALT`;DELIMITER $$

CREATE PROCEDURE `INTEGRAGRUPONOSOLALT`(
    Par_GrupoID         BIGINT(12),
    Par_ClienteID       INT,
    Par_NumIntegrantes  INT,
    Par_TipoIntegrantes INT,

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
DECLARE Var_ExistClien  INT;
DECLARE Var_TipoInt     INT;
DECLARE Var_DescTipo    VARCHAR(30);


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
                                         'esto le ocasiona. Ref: SP-INTEGRAGRUPONOSOLALT');
                SET Var_Control = 'sqlException' ;
            END;
SET Var_ExistClien := (SELECT GrupoID
                            FROM INTEGRAGRUPONOSOL WHERE ClienteID= Par_ClienteID
                               LIMIT 1);
SET Var_TipoInt := (SELECT TipoIntegrantes
                                FROM INTEGRAGRUPONOSOL
                                    WHERE GrupoID=Par_GrupoID
                                        AND TipoIntegrantes=Par_TipoIntegrantes
                                        AND TipoIntegrantes !=4);
IF (IFNULL( Par_ClienteID  , Entero_Cero)) = Entero_Cero THEN
      SET Par_NumErr  := 001;
      SET Par_ErrMen  := 'El safilocale.cliente no Puede Estar Vacio';
      SET Var_Control := 'clienteID';
      LEAVE ManejoErrores;
END IF;

IF (IFNULL( Var_ExistClien  , Entero_Cero)) != Entero_Cero THEN
      SET Par_NumErr  := 002;
      SET Par_ErrMen  := CONCAT("El safilocale.cliente ",CONVERT(Par_ClienteID, CHAR) ," ya Pertenece al Grupo ",CONVERT(Var_ExistClien, CHAR));
      SET Var_Control := 'clienteID';
      LEAVE ManejoErrores;
END IF;

IF (IFNULL(Par_TipoIntegrantes, Entero_Cero)) = Entero_Cero THEN
      SET Par_NumErr  := 003;
      SET Par_ErrMen  := 'Se Requiere Tipo de Integrante';
      SET Var_Control := 'tipoIntegrantes';
      LEAVE ManejoErrores;
END IF;
IF (IFNULL(Var_TipoInt, Entero_Cero)) != Entero_Cero THEN
    CASE
        WHEN Var_TipoInt= 1 THEN SET Var_DescTipo:= 'Presidente';
        WHEN Var_TipoInt= 2 THEN SET Var_DescTipo:= 'Tesorero';
        WHEN Var_TipoInt= 2 THEN SET Var_DescTipo:= 'Vocal';
    END CASE;
      SET Par_NumErr  := 004;
      SET Par_ErrMen  := CONCAT("Solo un ",CONVERT(Var_DescTipo, CHAR), " Por Grupo");
      SET Var_Control := 'tipoIntegrantes';
      LEAVE ManejoErrores;
END IF;

SET Aud_FechaActual:= NOW();
INSERT INTO INTEGRAGRUPONOSOL(GrupoID,       ClienteID,      TipoIntegrantes,      EmpresaID,      Usuario,
                                FechaActual,    DireccionIP,    ProgramaID,           Sucursal,       NumTransaccion)
                        VALUES( Par_GrupoID,    Par_ClienteID,  Par_TipoIntegrantes,  Par_EmpresaID,  Aud_Usuario,
                                Aud_FechaActual,Aud_DireccionIP,Aud_ProgramaID,      Aud_Sucursal,    Aud_NumTransaccion);

SELECT COUNT(*) INTO Par_NumIntegrantes FROM INTEGRAGRUPONOSOL WHERE GrupoID=Par_GrupoID;
SET Par_NumIntegrantes  :=IFNULL(Par_NumIntegrantes,Entero_Cero );
UPDATE GRUPOSNOSOLIDARIOS SET
        NumIntegrantes = Par_NumIntegrantes
    WHERE GrupoID=Par_GrupoID;


SET Par_NumErr  := 000;
SET Par_ErrMen  :='Integrante(s) Grabado(s) Exitosamente';
SET Var_Control := 'grupoID';

END ManejoErrores;
IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            IFNULL(Par_GrupoID,Entero_Cero) AS consecutivo;
END IF;

END TerminaStore$$