-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GENERACLABEPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `GENERACLABEPRO`;
DELIMITER $$

CREATE PROCEDURE `GENERACLABEPRO`(
# =====================================================================================
# ----- STORE PARA GENERAR CLABE INTERBANCARIA--
# =====================================================================================
    Par_TipoPersona         CHAR(1),                -- Tipo de personsa para armado de la clabe F - Persona Fisica, M - Persona moral
    INOUT   Par_CLABE       VARCHAR(18),            -- Clabe Interbancaria generada
    Par_Salida              CHAR(1),                -- indica una salida
    INOUT   Par_NumErr      INT(11),                -- parametro numero de error
    INOUT   Par_ErrMen      VARCHAR(400),           -- mensaje de error

    Aud_EmpresaID           INT(11),                -- parametros de auditoria
    Aud_Usuario             INT(11),                -- parametros de auditoria
    Aud_FechaActual         DATETIME ,              -- parametros de auditoria
    Aud_DireccionIP         VARCHAR(15),            -- parametros de auditoria
    Aud_ProgramaID          VARCHAR(70),            -- parametros de auditoria
    Aud_Sucursal            INT(11),                -- parametros de auditoria
    Aud_NumTransaccion      BIGINT(20)              -- parametros de auditoria
)
TerminaStore: BEGIN
    -- Declaracion de Variables
    DECLARE Var_Digito1Cuenta       INT(1);             -- Digito uno de la CLABE que forma parte de la clave del banco
    DECLARE Var_Digito2Cuenta       INT(1);             -- Digito dos de la CLABE que forma parte de la clave del banco
    DECLARE Var_Digito3Cuenta       INT(1);             -- Digito tres de la CLABE que forma parte de la clave del banco
    DECLARE Var_Digito4Cuenta       INT(1);             -- Digito cuatro de la CLABE que forma parte de la clave de la plaza
    DECLARE Var_Digito5Cuenta       INT(1);             -- Digito cinco de la CLABE que forma parte clave de la plaza
    DECLARE Var_Digito6Cuenta       INT(1);             -- Digito seis de la CLABE que forma parte clave de la plaza
    DECLARE Var_Digito7Cuenta       INT(1);             -- Digito siete de la CLABE que forma parte de la clave de la empresa
    DECLARE Var_Digito8Cuenta       INT(1);             -- Digito ocho de la CLABE que forma parte de la clave de la empresa
    DECLARE Var_Digito9Cuenta       INT(1);             -- Digito nueve de la CLABE que forma parte de la clave de la empresa
    DECLARE Var_Digito10Cuenta      INT(1);             -- Digito diez de la CLABE que forma parte de la clave de la empresa
    DECLARE Var_Digito11Cuenta      INT(1);             -- Digito once de la CLABE que forma parte de la clave de la entidad
    DECLARE Var_Digito12Cuenta      INT(1);             -- Digito doce de la CLABE que forma parte de la clave de la entidad
    DECLARE Var_Digito13Cuenta      INT(1);             -- Digito trece de la CLABE que forma parte de la clave del numero de cuenta
    DECLARE Var_Digito14Cuenta      INT(1);             -- Digito catorce de la CLABE que forma parte clave del numero de cuenta
    DECLARE Var_Digito15Cuenta      INT(1);             -- Digito quince de la CLABE que forma parte de la clave del numero de cuenta
    DECLARE Var_Digito16Cuenta      INT(1);             -- Digito dieciseis de la CLABE que forma parte de la clave del numero de cuenta
    DECLARE Var_Digito17Cuenta      INT(1);             -- Digito diecisiete de la CLABE que forma parte de la clave del numero de cuenta
    DECLARE Var_Digito18Cuenta      INT(1);             -- Digito dieciocho de la CLABE que es el digito verificador
    
    DECLARE Var_RestoModDigito1     INT(1);             -- Resto de aplicar modulo 10 al digito 1
    DECLARE Var_RestoModDigito2     INT(1);             -- Resto de aplicar modulo 10 al digito 2
    DECLARE Var_RestoModDigito3     INT(1);             -- Resto de aplicar modulo 10 al digito 3
    DECLARE Var_RestoModDigito4     INT(1);             -- Resto de aplicar modulo 10 al digito 4
    DECLARE Var_RestoModDigito5     INT(1);             -- Resto de aplicar modulo 10 al digito 5
    DECLARE Var_RestoModDigito6     INT(1);             -- Resto de aplicar modulo 10 al digito 6
    DECLARE Var_RestoModDigito7     INT(1);             -- Resto de aplicar modulo 10 al digito 7
    DECLARE Var_RestoModDigito8     INT(1);             -- Resto de aplicar modulo 10 al digito 8
    DECLARE Var_RestoModDigito9     INT(1);             -- Resto de aplicar modulo 10 al digito 9
    DECLARE Var_RestoModDigito10    INT(1);         -- Resto de aplicar modulo 10 al digito 10
    DECLARE Var_RestoModDigito11    INT(1);         -- Resto de aplicar modulo 10 al digito 11
    DECLARE Var_RestoModDigito12    INT(1);         -- Resto de aplicar modulo 10 al digito 12
    DECLARE Var_RestoModDigito13    INT(1);         -- Resto de aplicar modulo 10 al digito 13
    DECLARE Var_RestoModDigito14    INT(1);         -- Resto de aplicar modulo 10 al digito 14
    DECLARE Var_RestoModDigito15    INT(1);         -- Resto de aplicar modulo 10 al digito 15
    DECLARE Var_RestoModDigito16    INT(1);         -- Resto de aplicar modulo 10 al digito 16
    DECLARE Var_RestoModDigito17    INT(1);         -- Resto de aplicar modulo 10 al digito 17
    
    DECLARE Var_CuentaCompleta      VARCHAR(17);    -- Resultado de concatenar la clave del banco, plaza, empresa, entidad y numero de cuenta
    DECLARE Var_SumaRestos          INT(11);        -- Suma de todos los restos de aplicar modulo 10 a los digitos de la cuenta
    DECLARE Var_RestoSuma           INT(1);         -- Resto de aplicar modulo 10 a la suma
    DECLARE Var_ResultadoResta      INT(2);         -- Resultado de la diferencia 10 - resto de la suma


    -- DECLARACION DE CONSTANTES
    DECLARE Var_FactorPeso3         INT(1);     -- Factor peso 3;
    DECLARE Var_FactorPeso7         INT(1);     -- Factor peso 7;
    DECLARE Var_FactorPeso1         INT(1);     -- Factor peso 1;
    DECLARE Var_ClaveBanco          CHAR(3);    -- Clave del banco
    DECLARE Var_ClavePlaza          CHAR(3);    -- Clave de la plaza
   
    DECLARE Var_ClaveEmpresa        CHAR(4);    -- Clave de la empresa
    DECLARE Var_Consecutivo         INT(11);    -- Folio
    DECLARE Var_NumeroCuenta        VARCHAR(7); -- Numero de cuenta
    DECLARE Var_Modulo10            INT(2);     -- Modulo 10
    DECLARE Var_EnteroDiez          INT(2);     -- Entero 10
    
    DECLARE CadenaVacia             CHAR(1);    -- Cadena Vacia
    DECLARE CentroCosto             CHAR(3);    -- Centro de Costo default
    DECLARE Var_ClienteEspecifico   INT(11);    -- Numero de cliente especifico
    DECLARE Var_CentroCostoSPEISTP  CHAR(3);    -- Centgro de Costo que le Corresponde
    
    DECLARE ConstanteSI             CHAR(1);    -- Constante SI
    DECLARE ConstanteNO             CHAR(1);    -- Constante NO
    DECLARE ClienteEspecifico       VARCHAR(20);-- Cliente Especifico
    DECLARE Var_CentroCostoNuevo    CHAR(3);    -- Centro de costo nuevo
    DECLARE Var_CentroCostoVal      CHAR(3);    -- Centro de Costro para validar
    
    DECLARE Num_MaxCC               INT(11);    -- Centro de Costo Maximo
    DECLARE EnteroCero              INT(11);    -- Entero cero
    DECLARE Var_CLABE               VARCHAR(18);-- Clabe que se retornará
    DECLARE Var_EstatusProceso      CHAR(1);    -- Estatus del proceso A = Activo I = Inactivo
    DECLARE Var_Activo              CHAR(1);    -- Activo
    
    DECLARE Var_Inactivo            CHAR(1);    -- Inactivo
    DECLARE Var_NumCentroCostos     INT(11);    -- Numero de Centro de Costos
    DECLARE EnteroUno               INT(11);    -- Entero Uno
    DECLARE Var_FechaActual         DATETIME;
    DECLARE Var_Control             VARCHAR(50);
    DECLARE Var_ParametroID         INT(11);
    DECLARE Var_NParametroID        INT(11);
    DECLARE Var_Terminado           char(1);

    -- ASIGNACION DE CONSTANTES
    SET Var_FactorPeso3         := 3;       -- Factor peso 3;
    SET Var_FactorPeso7         := 7;       -- Factor peso 7;
    SET Var_FactorPeso1         := 1;       -- Factor peso 1;
    SET Var_NumeroCuenta        := 0;       -- Numero de cuenta
    SET Var_Modulo10            := 10;      -- Modulo 10
    
    SET Var_EnteroDiez          := 10;      -- Entero 10
    SET CadenaVacia             := '';      -- Constante Cadena Vacia
    SET ConstanteSI             := 'S';     -- Constante SI
    SET ConstanteNO             := 'N';     -- Constate NO 
    SET CentroCosto             := '00';
    
    SET ClienteEspecifico       := 'CliProcEspecifico'; -- Llave parametro
    SET Num_MaxCC               := 100000;   -- Numero Maximo con Centro de Costo
    SET EnteroCero              := 0;
    SET Var_Activo              := 'A';
    SET Var_Inactivo            := 'I'; 
    
    SET EnteroUno               := 1;
    SET Var_Terminado           := 'T';

    ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr := 999;
            SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operación. Disculpe las molestias que ',
                                                     'esto le ocasiona. Ref: SP-GENERACLABEPRO');
            SET Var_Control := 'SQLEXCEPTION';
        END; 

        -- VERIFICAR SI ESTA OCUPADO EL PROCESO
        SELECT EstatusProceso 
            INTO  Var_EstatusProceso
        FROM TMPGENERACLABEINTER;

        -- SI ESTA OCUPADO DEVOLVEMOS LA CLABE VACIA
        IF(Var_EstatusProceso = Var_Activo) THEN 
                SET Par_NumErr      := 01;
                SET Par_ErrMen      := CONCAT('El Proceso se encuentra Activo');
                SET Var_Consecutivo := EnteroCero;
                SET Var_Control     := CadenaVacia;
                SET Par_CLABE       := CadenaVacia;
            LEAVE TerminaStore;
        END IF;

        -- SI ESTA INACTIVO ACTUALIZAMOS EL ESTATUS
        UPDATE   TMPGENERACLABEINTER
            SET EstatusProceso = Var_Activo;

         -- INICIO : OBTENCION DEL CONSECUTIVO DE NUMERO DE CUENTA
        SELECT FolioClabeID
            INTO Var_Consecutivo
        FROM FOLIOSCUENTASCLABES
            FOR UPDATE;

        SET Var_Consecutivo := IFNULL(Var_Consecutivo,-1);

        IF (Var_Consecutivo = -1) THEN
            SET Var_Consecutivo := 1;
            INSERT INTO FOLIOSCUENTASCLABES(FolioClabeID)
                                    VALUES (Var_Consecutivo);
        ELSE
            UPDATE FOLIOSCUENTASCLABES SET
                FolioClabeID = FolioClabeID + 1;
        END IF;

        SELECT FolioClabeID
            INTO Var_Consecutivo
            FROM FOLIOSCUENTASCLABES;

        -- VALORES PARAMETRIZADOS PARA STP
        SELECT ClienteBanxico,      PlazaBanxico,       ClienteSTP
         INTO   Var_ClaveBanco,      Var_ClavePlaza,     Var_ClaveEmpresa
        FROM PARAMETROSSPEI LIMIT 1; 

        -- VALORES DEFAULT
        SET Var_ClaveBanco := IFNULL(Var_ClaveBanco,CadenaVacia);
          IF(Var_ClaveBanco = CadenaVacia) THEN 
                SET Par_NumErr      := 01;
                SET Par_ErrMen      := CONCAT('No se encuentra el parametro para generar la cuenta CLABE.[PARAMETROSSPEI-ClienteBanxico]');
                SET Var_Consecutivo := EnteroCero;
                SET Var_Control     := CadenaVacia;
                SET Var_CLABE       := CadenaVacia;
            LEAVE ManejoErrores;
        END IF;

        SET Var_ClavePlaza := IFNULL(Var_ClavePlaza,CadenaVacia);
 
       IF(Var_ClavePlaza = CadenaVacia) THEN 
                SET Par_NumErr      := 02;
                SET Par_ErrMen      := CONCAT('No se encuentra el parametro para generar la cuenta CLABE.[PARAMETROSSPEI-PlazaBanxico]');
                SET Var_Consecutivo := EnteroCero;
                SET Var_Control     := CadenaVacia;
                SET Var_CLABE       := CadenaVacia;
            LEAVE ManejoErrores;
        END IF;


        SET Var_ClaveEmpresa := IFNULL(Var_ClaveEmpresa,CadenaVacia);

         IF(Var_ClaveEmpresa = CadenaVacia) THEN 
                SET Par_NumErr      := 03;
                SET Par_ErrMen      := CONCAT('No se encuentra el parametro para generar la cuenta CLABE.[PARAMETROSSPEI-ClienteSTP]');
                SET Var_Consecutivo := EnteroCero;
                SET Var_Control     := CadenaVacia;
                SET Var_CLABE       := CadenaVacia;
            LEAVE ManejoErrores;
        END IF;
        
        SET Var_NumeroCuenta := LPAD(CONVERT(Var_Consecutivo, CHAR(7)),7,0);
        SET Var_CuentaCompleta := CONCAT(Var_ClaveBanco, Var_ClavePlaza, Var_ClaveEmpresa,Var_NumeroCuenta);
        -- FIN : OBTENCION DEL CONSECUTIVO DE NUMERO DE CUENTA

        -- SE OBTIENE LOS DIGITOS
        SET Var_Digito1Cuenta := SUBSTRING(Var_CuentaCompleta,1,1);
        SET Var_Digito2Cuenta := SUBSTRING(Var_CuentaCompleta,2,1);
        SET Var_Digito3Cuenta := SUBSTRING(Var_CuentaCompleta,3,1);
        SET Var_Digito4Cuenta := SUBSTRING(Var_CuentaCompleta,4,1);
        SET Var_Digito5Cuenta := SUBSTRING(Var_CuentaCompleta,5,1);
        SET Var_Digito6Cuenta := SUBSTRING(Var_CuentaCompleta,6,1);
        SET Var_Digito7Cuenta := SUBSTRING(Var_CuentaCompleta,7,1);
        SET Var_Digito8Cuenta := SUBSTRING(Var_CuentaCompleta,8,1);
        SET Var_Digito9Cuenta := SUBSTRING(Var_CuentaCompleta,9,1);
        SET Var_Digito10Cuenta := SUBSTRING(Var_CuentaCompleta,10,1);
        SET Var_Digito11Cuenta := SUBSTRING(Var_CuentaCompleta,11,1);
        SET Var_Digito12Cuenta := SUBSTRING(Var_CuentaCompleta,12,1);
        SET Var_Digito13Cuenta := SUBSTRING(Var_CuentaCompleta,13,1);
        SET Var_Digito14Cuenta := SUBSTRING(Var_CuentaCompleta,14,1);   
        SET Var_Digito15Cuenta := SUBSTRING(Var_CuentaCompleta,15,1);
        SET Var_Digito16Cuenta := SUBSTRING(Var_CuentaCompleta,16,1);
        SET Var_Digito17Cuenta := SUBSTRING(Var_CuentaCompleta,17,1);

        SET Var_RestoModDigito1 := (Var_Digito1Cuenta * Var_FactorPeso3) % Var_Modulo10;
        SET Var_RestoModDigito2 := (Var_Digito2Cuenta * Var_FactorPeso7) % Var_Modulo10;
        SET Var_RestoModDigito3 := (Var_Digito3Cuenta * Var_FactorPeso1) % Var_Modulo10;
        SET Var_RestoModDigito4 := (Var_Digito4Cuenta * Var_FactorPeso3) % Var_Modulo10;
        SET Var_RestoModDigito5 := (Var_Digito5Cuenta * Var_FactorPeso7) % Var_Modulo10;
        SET Var_RestoModDigito6 := (Var_Digito6Cuenta * Var_FactorPeso1) % Var_Modulo10;
        SET Var_RestoModDigito7 := (Var_Digito7Cuenta * Var_FactorPeso3) % Var_Modulo10;
        SET Var_RestoModDigito8 := (Var_Digito8Cuenta * Var_FactorPeso7) % Var_Modulo10;
        SET Var_RestoModDigito9 := (Var_Digito9Cuenta * Var_FactorPeso1) % Var_Modulo10;
        SET Var_RestoModDigito10 := (Var_Digito10Cuenta * Var_FactorPeso3) % Var_Modulo10;
        SET Var_RestoModDigito11 := (Var_Digito11Cuenta * Var_FactorPeso7) % Var_Modulo10;
        SET Var_RestoModDigito12 := (Var_Digito12Cuenta * Var_FactorPeso1) % Var_Modulo10;
        SET Var_RestoModDigito13 := (Var_Digito13Cuenta * Var_FactorPeso3) % Var_Modulo10;
        SET Var_RestoModDigito14 := (Var_Digito14Cuenta * Var_FactorPeso7) % Var_Modulo10;
        SET Var_RestoModDigito15 := (Var_Digito15Cuenta * Var_FactorPeso1) % Var_Modulo10;
        SET Var_RestoModDigito16 := (Var_Digito16Cuenta * Var_FactorPeso3) % Var_Modulo10;
        SET Var_RestoModDigito17 := (Var_Digito17Cuenta * Var_FactorPeso7) % Var_Modulo10;

        SET Var_SumaRestos := Var_RestoModDigito1 + Var_RestoModDigito2 + Var_RestoModDigito3 + Var_RestoModDigito4 + Var_RestoModDigito5 + Var_RestoModDigito6 + Var_RestoModDigito7 +
                                Var_RestoModDigito8 + Var_RestoModDigito9 + Var_RestoModDigito10 + Var_RestoModDigito11 + Var_RestoModDigito12 + Var_RestoModDigito13 +
                                Var_RestoModDigito14 + Var_RestoModDigito15 + Var_RestoModDigito16 + Var_RestoModDigito17;

        SET Var_RestoSuma := Var_SumaRestos % Var_Modulo10;

        SET Var_ResultadoResta := (Var_EnteroDiez - Var_RestoSuma);

        SET Var_Digito18Cuenta := Var_ResultadoResta % Var_Modulo10;

        SET Var_CLABE := CONCAT(Var_CuentaCompleta, CONVERT(Var_Digito18Cuenta, CHAR(1)));
        SET Var_FechaActual := NOW();

        -- CREAR BITACORA DE CUENTA CLABE
        CALL BITACORACTACLABEALT(Aud_NumTransaccion,    Var_CLABE,          Var_FechaActual,    ConstanteNO,         Par_NumErr, 
                                 Par_ErrMen,            Aud_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP, 
                                 Aud_ProgramaID,        Aud_Sucursal,       Aud_NumTransaccion);

        SET Par_NumErr      := EnteroCero;
        SET Par_ErrMen      := CONCAT('Cuenta Generada Exitosamente.');
        SET Var_Consecutivo := EnteroCero;
        SET Var_Control     := CadenaVacia;
        SET Par_CLABE       := Var_CLABE;

END ManejoErrores;
        -- UNA VEZ QUE LA CUENTA CLABE SE GENERE SE ACTUALIZA EL REGISTRO.
        UPDATE   TMPGENERACLABEINTER
            SET EstatusProceso = Var_Inactivo;

        IF(Par_Salida = ConstanteSI)THEN 
            SELECT  Par_NumErr AS NumErr,
                    Par_ErrMen AS ErrMen,
                    Var_Control AS Control,
                    Var_CLABE AS CLABE;
        END IF;

END TerminaStore$$