
-- GENERATARJETAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `GENERATARJETAPRO`;
DELIMITER $$

CREATE PROCEDURE `GENERATARJETAPRO`(
# =====================================================================================
# ----- STORE PARA GENERAR TARJETAS -----
# =====================================================================================
    INOUT   Par_CLABE       VARCHAR(18),            -- Numero de Tarjeta Generada
    Par_TipoTarjetaDebID    INT(11),                -- Llave primaria de la tabla TIPOTARJETADEB
    Par_TipoTarjeta         TINYINT,                -- Tipo de Tarjeta - 1-Titular,2-Adicional

    Par_Salida              CHAR(1),                -- Indica una Salida
    INOUT   Par_NumErr      INT(11),                -- Parametro Numero de Error
    INOUT   Par_ErrMen      VARCHAR(400),           -- Pensaje de Error

    Aud_EmpresaID           INT(11),                -- Parametros de Auditoria
    Aud_Usuario             INT(11),                -- Parametros de Auditoria
    Aud_FechaActual         DATETIME ,              -- Parametros de Auditoria
    Aud_DireccionIP         VARCHAR(15),            -- Parametros de Auditoria
    Aud_ProgramaID          VARCHAR(70),            -- Parametros de Auditoria
    Aud_Sucursal            INT(11),                -- Parametros de Auditoria
    Aud_NumTransaccion      BIGINT(20)              -- Parametros de Auditoria
)
TerminaStore: BEGIN
    -- Declaracion de Variables
    DECLARE Var_Digito16Cuenta      INT(1);         -- Digito dieciseis verificador
    DECLARE Var_TarjetaCompleta     VARCHAR(17);    -- Resultado de concatenar la clave del banco, plaza, empresa, entidad y numero de cuenta
    DECLARE Var_Bin                 CHAR(6);    -- Clave del banco
    DECLARE Var_Consecutivo         INT(11);    -- Folio
    DECLARE Var_FolioTar            BIGINT(12); -- Folio de Tarjetas
    DECLARE Var_NumConsetivoDesc    VARCHAR(7); -- Numero de cuenta

    -- DECLARACION DE CONSTANTES
    DECLARE CadenaVacia             CHAR(1);    -- Cadena Vacia
    DECLARE FechaVacia				DATE;		-- Fecha vacia
    DECLARE ConstanteSI             CHAR(1);    -- Constante SI
    DECLARE ConstanteNO             CHAR(1);    -- Constante NO
    DECLARE Posicion78              CHAR(2);    -- Posición en la tarjeta 7 al 8

    DECLARE EnteroCero              INT(11);    -- Entero cero
    DECLARE Var_Tarjeta             VARCHAR(18);-- Clabe que se retornará
    DECLARE Var_EstatusProceso      CHAR(1);    -- Estatus del proceso A = Activo I = Inactivo
    DECLARE Var_Activo              CHAR(1);    -- Activo

    DECLARE Var_Inactivo            CHAR(1);    -- Inactivo
    DECLARE Var_FechaActual         DATETIME;
    DECLARE Var_Control             VARCHAR(50);
    DECLARE Var_ConsecutivoDef      INT(11);
    DECLARE Var_Subbin              CHAR(2);
    DECLARE SubBINDefault           CHAR(2);    -- Valor de subBIN default
    DECLARE Var_BINCompleto         CHAR(8);    -- Valor completo del BIN

    -- ASIGNACION DE CONSTANTES
    SET Var_NumConsetivoDesc    := 0;               -- Numero de cuenta
    SET Var_ConsecutivoDef      := 99999;           -- Valor default de consecutivo

    SET CadenaVacia             := '';              -- Constante Cadena Vacia
    SET FechaVacia				:= '1900-01-01';
    SET ConstanteSI             := 'S';             -- Constante SI
    SET ConstanteNO             := 'N';             -- Constate NO
    SET SubBINDefault           := '00';            -- Valor SuBIN default cuando no permite la conf. SubBIN

    SET EnteroCero              := 0;
    SET Var_Activo              := 'A';
    SET Var_Inactivo            := 'I';
    SET Posicion78              := '01';

    ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr := 999;
            SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operación. Disculpe las molestias que ',
                                                     'esto le ocasiona. Ref: SP-GENERATARJETAPRO');
            SET Var_Control := 'SQLEXCEPTION';
        END;

        -- VERIFICAR SI ESTA OCUPADO EL PROCESO
        SELECT EstatusProceso
            INTO  Var_EstatusProceso
        FROM TMPGENERATARJETA;

        -- SI ESTA OCUPADO DEVOLVEMOS LA CLABE VACIA
        IF(Var_EstatusProceso = Var_Activo) THEN
                SET Par_NumErr      := 01;
                SET Par_ErrMen      := CONCAT('El Proceso se encuentra Activo');
                SET Var_Consecutivo := EnteroCero;
                SET Var_Control     := CadenaVacia;
                SET Var_Tarjeta     := CadenaVacia;
            LEAVE TerminaStore;
        END IF;

        -- VALORES CONFIGURADOS PARA TARJETA EN SAFI
        SELECT TB.NumBIN, CASE TB.EsSubBin
                            WHEN ConstanteSI
                        THEN TT.NumSubBIN ELSE
                        SubBINDefault END AS NumSubBIN
            INTO   Var_Bin,    Var_Subbin
        FROM TIPOTARJETADEB TT
            INNER JOIN TARBINPARAMS TB
                ON TT.TarBinParamsID = TB.TarBinParamsID
                WHERE TipoTarjetaDebID = Par_TipoTarjetaDebID;

        -- VALIDA CONFIGURACIÓN
        SET Var_Bin := IFNULL(Var_Bin,CadenaVacia);
          IF(Var_Bin = CadenaVacia) THEN
                SET Par_NumErr      := 02;
                SET Par_ErrMen      := CONCAT('No se encuentra configurado el valor Bin.[TARBINPARAMS-NumBIN]');
                SET Var_Consecutivo := EnteroCero;
                SET Var_Control     := CadenaVacia;
                SET Var_Tarjeta     := CadenaVacia;
            LEAVE ManejoErrores;
        END IF;

        SET Var_Subbin := IFNULL(Var_Subbin,CadenaVacia);
          IF(Var_Subbin = CadenaVacia) THEN
                SET Par_NumErr      := 03;
                SET Par_ErrMen      := CONCAT('No se encuentra configurado el valor Subbin.[TIPOTARJETADEB-NumSubBIN]');
                SET Var_Consecutivo := EnteroCero;
                SET Var_Control     := CadenaVacia;
                SET Var_Tarjeta     := CadenaVacia;
            LEAVE ManejoErrores;
        END IF;

        -- SI ESTA INACTIVO ACTUALIZAMOS EL ESTATUS
        UPDATE   TMPGENERATARJETA
            SET EstatusProceso = Var_Activo;

        -- INICIO : OBTENCION DEL CONSECUTIVO DE LA TARJETA
        SET Var_FolioTar := EnteroCero;
        SET Var_BINCompleto := CONCAT(Var_Bin,Var_Subbin);
        CALL FOLIOSTARJETAACT(Var_BINCompleto, Var_FolioTar);

        -- VALIDA QUE LEGUE EL VALOR DEL FOLIO
        IF (Var_FolioTar = EnteroCero) THEN
            SET Par_NumErr := 04;
            SET Par_ErrMen := 'Error al registrar el folio.';
            SET Var_Control := EnteroCero;
            LEAVE ManejoErrores;
        END IF;

        SET Var_NumConsetivoDesc := LPAD(CONVERT(Var_FolioTar, CHAR(5)),5,0);
        SET Var_TarjetaCompleta := CONCAT(Var_Bin, Posicion78, Var_Subbin, Var_NumConsetivoDesc);

        SET Var_Digito16Cuenta := FNGENERADIGVERI(Var_TarjetaCompleta);

        SET Var_Tarjeta= CONCAT(Var_TarjetaCompleta, CONVERT(Var_Digito16Cuenta, CHAR(1)));
        SET Var_FechaActual := NOW();

        -- CREAR BITACORA DE CUENTA CLABE
        CALL BITACORATARJETAALT(Aud_NumTransaccion,     Var_Tarjeta,        CadenaVacia,    FechaVacia,     Var_FechaActual,
                                ConstanteNO,            Par_NumErr,         Par_ErrMen,     Aud_EmpresaID,  Aud_Usuario,
                                 Aud_FechaActual,       Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);

        -- VALIDA QUE NO FALLE EL INSERT EN LA BITACORA
        IF (Par_NumErr > EnteroCero) THEN
            SET Par_NumErr  := 05;
            SET Par_ErrMen  := 'Error al registrar en la bitacora de tarjetas.';
            SET Var_Control := EnteroCero;
            LEAVE ManejoErrores;
        END IF;

        SET Par_NumErr      := EnteroCero;
        SET Par_ErrMen      := CONCAT('Tarjeta Generada Exitosamente.');
        SET Var_Consecutivo := EnteroCero;
        SET Var_Control     := CadenaVacia;
        SET Par_CLABE       := Var_Tarjeta;

    END ManejoErrores;
        -- UNA VEZ QUE LA TARJETA SE GENERE SE ACTUALIZA EL REGISTRO.
        UPDATE   TMPGENERATARJETA
            SET EstatusProceso = Var_Inactivo;

        IF(Par_Salida = ConstanteSI)THEN
            SELECT  Par_NumErr AS NumErr,
                    Par_ErrMen AS ErrMen,
                    Var_Control AS Control,
                    Var_Tarjeta AS Tarjeta;
        END IF;

END TerminaStore$$
