-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CARGACONFIGURACIONUNICAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CARGACONFIGURACIONUNICAPRO`;DELIMITER $$

CREATE PROCEDURE `CARGACONFIGURACIONUNICAPRO`(
    ParCompaniaID           VARCHAR(100),
    Par_Salida              CHAR(1),
    INOUT Par_NumErr        INT(11),
    INOUT Par_ErrMen        VARCHAR(400),
    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),

    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
)
TerminaStore : BEGIN

    DECLARE Var_OrigenDatos     VARCHAR(50);
    DECLARE Var_Sentencia       VARCHAR(65535);
    DECLARE Var_Prefijo         VARCHAR(3);
    DECLARE Var_EmpresaID       INT(1);
    DECLARE Var_Control         VARCHAR(100);
    DECLARE VarBD               VARCHAR(100);

    DECLARE SalidaSi            CHAR(1);


    SET SalidaSi                :=  'S';



    SET Var_EmpresaID = ParCompaniaID;
        SELECT OrigenDatos, Prefijo
            INTO Var_OrigenDatos, Var_Prefijo
             FROM COMPANIA WHERE CompaniaID = Var_EmpresaID;

ManejoErrores:BEGIN

        DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
                SET Par_NumErr  = 999;
                SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al
                                        concretar la operacion.Disculpe las molestias que','' 'esto le ocasiona. Ref: SP-CARGACONFIGURACIONUNICAPRO');
                SET Var_Control = 'sqlException';
            END;




            SET Var_Sentencia   :=  CONCAT('UPDATE ',Var_OrigenDatos,'.ROLES
                                                SET Descripcion = CONCAT("',Var_Prefijo,'",Descripcion);');

            SET @Sentencia  :=  Var_Sentencia;

            PREPARE STMODROLES FROM @Sentencia;

            EXECUTE STMODROLES;


            SET Var_Sentencia   :=  CONCAT('UPDATE ',Var_OrigenDatos,'.USUARIOS
                                                SET Clave = CONCAT("',Var_Prefijo,'",Clave);');

            SET @Sentencia  :=  Var_Sentencia;

            PREPARE STMODUSUARIOS FROM @Sentencia;

            EXECUTE STMODUSUARIOS;


            SET Var_Sentencia   :=  CONCAT('INSERT INTO ROLES(
                                            RolID,              EmpresaID,          NombreRol,          Descripcion,        Usuario,
                                            FechaActual,        DireccionIP,        ProgramaID,         Sucursal,           NumTransaccion)
                                    SELECT  origen.RolID,       ',
    CAST(Var_EmpresaID AS CHAR),',  origen.NombreRol,   origen.Descripcion, origen.Usuario,
                                            origen.FechaActual, origen.DireccionIP, origen.ProgramaID,  origen.Sucursal,    origen.NumTransaccion
                                        FROM ',Var_OrigenDatos,'.ROLES as origen;');

            SET @Sentencia  :=  Var_Sentencia;

            PREPARE STCARGAROLES FROM @Sentencia;

            EXECUTE STCARGAROLES;


            SET Var_Sentencia   :=  CONCAT('INSERT INTO OPCIONESROL(
                                            Empresa,            RolID,              OpcionMenuID,           EmpresaID,          Usuario,
                                            FechaActual,        DireccionIP,        ProgramaID,             Sucursal,           NumTransaccion)
                                    SELECT ',CAST(Var_EmpresaID AS CHAR),', origen.RolID,       origen.OpcionMenuID,    origen.EmpresaID,   origen.Usuario,
                                            origen.FechaActual, origen.DireccionIP, origen.ProgramaID,      origen.Sucursal,    origen.NumTransaccion
                                        FROM ',Var_OrigenDatos,'.OPCIONESROL as origen;');

            SET @Sentencia  :=  Var_Sentencia;

            PREPARE STCARGAOPCIONESROL FROM @Sentencia;

            EXECUTE STCARGAOPCIONESROL;


    SET Par_NumErr  :=  0;
    SET Par_ErrMen  :=  'Configuracion Terminada Exitosamente.';

END ManejoErrores;


    IF(Par_Salida = SalidaSi) THEN
        SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen;
    END IF;

END TerminaStore$$