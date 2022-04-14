-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BENEFICIARIOSINVERALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BENEFICIARIOSINVERALT`;DELIMITER $$

CREATE PROCEDURE `BENEFICIARIOSINVERALT`(
    Par_BeneInverID         INT(11),
    Par_InversionID         INT(11),
    Par_ClienteID           INT(11),
    Par_Titulo              VARCHAR(10),
    Par_PrimerNombre        VARCHAR(50),
    Par_SegundoNombre       VARCHAR(50),
    Par_TercerNombre        VARCHAR(50),
    Par_PrimerApellido      VARCHAR(50),
    Par_SegundoApellido     VARCHAR(50),
    Par_FechaNacimiento     DATE,
    Par_PaisID              INT(5),
    Par_EstadoID            INT(5),
    Par_EstadoCivil         CHAR(2),
    Par_Sexo                CHAR(1),
    Par_CURP                CHAR(18),
    Par_RFC                 CHAR(13),
    Par_OcupacionID         INT(11),
    Par_ClavePuestoID       VARCHAR(200),
    Par_TipoIdentiID        INT(11),
    Par_NumIdentific        VARCHAR(30),
    Par_FecExIden           DATE,
    Par_FecVenIden          DATE    ,
    Par_TelefonoCasa        VARCHAR(20),
    Par_TelefonoCelular     VARCHAR(20),
    Par_Correo              VARCHAR(50),
    Par_Domicilio           VARCHAR(500),
    Par_TipoRelacionID      INT(11),
    Par_Porcentaje          DECIMAL(12,2),
    Par_TipoBene            CHAR(1),

    Par_Salida              CHAR(1),
    INOUT Par_NumErr        INT,
    INOUT Par_ErrMen        VARCHAR(400),

    Par_EmpresaID           INT,
    Aud_Usuario             INT,
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT,
    Aud_NumTransaccion      BIGINT
            )
TerminaStore: BEGIN


DECLARE varControl              VARCHAR(50);
DECLARE Var_BeneInverID         INT(11);
DECLARE Var_NombreCompleto      CHAR(200);
DECLARE Var_Porcentaje          DECIMAL(12,2);
DECLARE Var_Total_Porcentaje    DECIMAL(12,2);
DECLARE Var_EstatusInver        CHAR(1);
DECLARE Var_TipoBene            CHAR(1);
DECLARE varCtaInver             BIGINT(12);
DECLARE Var_CtaOrdinaria        BIGINT(12);
DECLARE Var_CtaVista            BIGINT(12);
DECLARE Var_consecutivo         VARCHAR(100);


DECLARE Entero_Cero         INT;
DECLARE Decimal_Cero        DECIMAL(14,2);
DECLARE Cadena_Vacia        CHAR(1);
DECLARE Fecha_Vacia         DATE;
DECLARE Salida_SI           CHAR(1);
DECLARE TotalPorcentaje     DECIMAL(12,2);
DECLARE Est_Alta            CHAR(1);
DECLARE Est_Vencida         CHAR(1);
DECLARE Est_Pagada          CHAR(1);
DECLARE Est_Cancelada       CHAR(1);
DECLARE Ben_CtaSocio        CHAR(1);
DECLARE Ben_PropioInver     CHAR(1);
DECLARE EsBenef_SI          CHAR(1);
DECLARE MenorEdad           CHAR(1);
DECLARE TipoCtaOrd          INT(11);
DECLARE TipoCtaVista        INT(11);
DECLARE Var_Vigente         CHAR(1);
DECLARE Var_NomCompleto     VARCHAR(120);
DECLARE Var_ClienteID       INT(11);

SET varControl          :='';


SET Entero_Cero     := 0;
SET Decimal_Cero    := 0.0;
SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Salida_SI       :='S';
SET TotalPorcentaje := 100.0;
SET Est_Alta        :='A';
SET Est_Vencida     :='V';
SET Est_Pagada      :='P';
SET Est_Cancelada   :='C';
SET Ben_CtaSocio    :='S';
SET Ben_PropioInver :='I';
SET EsBenef_SI      :='S';
SET @Var_BeneInverID :=0;
SET MenorEdad       := 'S';
SET Var_Vigente     := 'V';


ManejoErrores:BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr = '999';
            SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ','esto le ocasiona. para resolverla. Disculpe las molestias que ',
                                     'esto le ocasiona. Ref: SP-BENEFICIARIOSINVERALT');
            SET varControl = 'sqlException' ;
        END;
    SELECT Beneficiario, ClienteID INTO Var_TipoBene, Var_ClienteID
        FROM INVERSIONES
        WHERE InversionID = Par_InversionID;

    SET Var_TipoBene    :=IFNULL(Var_TipoBene, Cadena_Vacia);
    SET Var_ClienteID   := IFNULL(Var_ClienteID,Entero_Cero );

    SET Aud_FechaActual :=NOW();

    IF (Par_ClienteID != Entero_Cero) THEN
        IF EXISTS(SELECT ClienteID FROM BENEFICIARIOSINVER
                    WHERE InversionID =Par_InversionID AND ClienteID =  Par_ClienteID)THEN
            SET Par_NumErr  := '001';
            SET Par_ErrMen  := 'El Beneficiario Especificado ya se Encuentra Registrado.';
            SET varControl  := 'numeroCte' ;
            LEAVE ManejoErrores;
        END IF;
    ELSE

        SET Par_PrimerNombre    := LTRIM(RTRIM(IFNULL(Par_PrimerNombre,Cadena_Vacia)));
        SET Par_SegundoNombre   := LTRIM(RTRIM(IFNULL(Par_SegundoNombre,Cadena_Vacia)));
        SET Par_TercerNombre    := LTRIM(RTRIM(IFNULL(Par_TercerNombre,Cadena_Vacia)));
        SET Par_PrimerApellido  := LTRIM(RTRIM(IFNULL(Par_PrimerApellido,Cadena_Vacia)));
        SET Par_SegundoApellido := LTRIM(RTRIM(IFNULL(Par_SegundoApellido,Cadena_Vacia)));

        SET Var_NomCompleto := CONCAT(RTRIM(LTRIM(IFNULL(Par_PrimerNombre, '')))
            ,CASE WHEN CHAR_LENGTH(RTRIM(LTRIM(IFNULL(Par_SegundoNombre, '')))) > 0 THEN CONCAT(" ", RTRIM(LTRIM(IFNULL(Par_SegundoNombre, '')))) ELSE '' END
            ,CASE WHEN CHAR_LENGTH(RTRIM(LTRIM(IFNULL(Par_TercerNombre, '')))) > 0 THEN CONCAT(" ", RTRIM(LTRIM(IFNULL(Par_TercerNombre, '')))) ELSE '' END
            ,CASE WHEN CHAR_LENGTH(RTRIM(LTRIM(IFNULL(Par_PrimerApellido, '')))) > 0 THEN CONCAT(" ", RTRIM(LTRIM(IFNULL(Par_PrimerApellido, '')))) ELSE '' END
            ,CASE WHEN CHAR_LENGTH(RTRIM(LTRIM(IFNULL(Par_SegundoApellido, '')))) > 0 THEN CONCAT(" ", RTRIM(LTRIM(IFNULL(Par_SegundoApellido, '')))) ELSE '' END );

        IF EXISTS(SELECT NombreCompleto FROM BENEFICIARIOSINVER
                    WHERE TRIM(NombreCompleto) = Var_NomCompleto
                    AND InversionID = Par_InversionID)THEN

            SET Par_NumErr  := '002';
            SET Par_ErrMen  := 'El Beneficiario Especificado ya se Encuentra Registrado.';
            SET varControl  := 'numeroCte' ;
            LEAVE ManejoErrores;
        END IF;

    END IF;

    IF(Par_TipoBene = Ben_PropioInver)THEN
        IF(IFNULL(Par_PrimerNombre,Cadena_Vacia))= Cadena_Vacia THEN
            SET Par_NumErr  := '001';
            SET Par_ErrMen  := 'El Primer Nombre esta vacio.';
            SET varControl  := 'primerNombre' ;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_PrimerApellido, Cadena_Vacia))= Cadena_Vacia THEN
            SET Par_NumErr  := '002';
            SET Par_ErrMen  := 'El Primer Apellido esta vacio.';
            SET varControl  := 'primerApellido' ;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_Sexo,Cadena_Vacia))= Cadena_Vacia THEN
            SET Par_NumErr  := '003';
            SET Par_ErrMen  := 'El Sexo esta vacio.';
            SET varControl  := 'sexo' ;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_CURP,Cadena_Vacia))= Cadena_Vacia THEN
            SET Par_NumErr  := '004';
            SET Par_ErrMen  := 'El CURP esta vacio.';
            SET varControl  := 'curp' ;
            LEAVE ManejoErrores;
        END IF;

        IF EXISTS (SELECT ClienteID
                    FROM CLIENTES
                    WHERE ClienteID = Par_ClienteID
                    AND EsMenorEdad != MenorEdad) THEN
                        IF(IFNULL(Par_RFC,Cadena_Vacia))= Cadena_Vacia THEN
                            SET Par_NumErr  := '005';
                            SET Par_ErrMen  := 'El RFC esta vacio.';
                            SET varControl  := 'rfc' ;
                            LEAVE ManejoErrores;
                        END IF;

                        IF(IFNULL(Par_NumIdentific,Cadena_Vacia))= Cadena_Vacia THEN
                            SET Par_NumErr  := '007';
                            SET Par_ErrMen  := 'El Numero de Identificacion esta vacio.';
                            SET varControl  := 'numIdentific' ;
                            LEAVE ManejoErrores;
                        END IF;
        END IF;

        IF(IFNULL(Par_Domicilio,Cadena_Vacia))= Cadena_Vacia THEN
            SET Par_NumErr  := '008';
            SET Par_ErrMen  := 'El Domicilio esta vacio.';
            SET varControl  := 'domicilio' ;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_TipoRelacionID,Entero_Cero))= Entero_cero THEN
            SET Par_NumErr  := '009';
            SET Par_ErrMen  := 'El Parenteco esta vacio.';
            SET varControl  := 'tipoRelacionID' ;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_Porcentaje,Entero_Cero))= Entero_cero THEN
            SET Par_NumErr  := '010';
            SET Par_ErrMen  := 'El Porcentaje esta vacio.';
            SET varControl  := 'porcentaje' ;
            LEAVE ManejoErrores;
        END IF;



        SET Var_EstatusInver    := IFNULL((SELECT Estatus
                                FROM INVERSIONES
                                WHERE InversionID = Par_InversionID), Cadena_Vacia);

        IF(Var_EstatusInver = Est_Pagada) THEN
                SET Par_NumErr  := '013';
                SET Par_ErrMen  := 'La Inversion esta Pagada ';
                SET varControl  := 'inversionID';
                LEAVE ManejoErrores;
        END IF;

        IF(Var_EstatusInver = Est_Cancelada) THEN
                SET Par_NumErr  :=  '014';
                SET Par_ErrMen  := 'La Inversion esta Cancelada';
                SET varControl  := 'inversionID';
                LEAVE ManejoErrores;
        END IF;

        IF(Var_EstatusInver = Est_Vencida) THEN
            SET Par_NumErr  := '015';
            SET Par_ErrMen  :=  'La Inversion esta vencida';
            SET varControl  := 'inversionID';
            LEAVE ManejoErrores;
        END IF;

        SET Var_BeneInverID := IFNULL((SELECT MAX(BenefInverID)
                                                FROM BENEFICIARIOSINVER
                                                 WHERE InversionID= Par_InversionID),Entero_Cero)+1;

        IF( Var_TipoBene = Ben_CtaSocio)THEN

            DELETE FROM BENEFICIARIOSINVER WHERE InversionID = Par_InversionID;
            UPDATE INVERSIONES SET
                Beneficiario =Ben_PropioInver
                WHERE InversionID = Par_InversionID;

            SET Var_BeneInverID := IFNULL((SELECT MAX(BenefInverID)
                                        FROM BENEFICIARIOSINVER
                                         WHERE InversionID= Par_InversionID),Entero_Cero)+1;
        END IF;

        SET Var_Porcentaje  := IFNULL((SELECT SUM(Porcentaje)
                                    FROM BENEFICIARIOSINVER
                                    WHERE InversionID = Par_InversionID),Entero_Cero);

        SET Var_Total_Porcentaje :=Var_Porcentaje+Par_Porcentaje;
        IF(Var_Total_Porcentaje > TotalPorcentaje)THEN
            SET Par_NumErr  := '012';
            SET Par_ErrMen  := 'El Porcentaje Indicado Excede el Total a Otorgar ';
            SET varControl  := 'porcentaje';
            LEAVE ManejoErrores;
        END IF;
        IF(Var_ClienteID = Par_ClienteID)THEN
            SET Par_NumErr  := '013';
            SET Par_ErrMen  := 'El Beneficiario de la Inversion no puede ser el mismo Inversionista ';
            SET varControl  := 'porcentaje';
            LEAVE ManejoErrores;
        END IF;
       SET Var_NombreCompleto := CONCAT(RTRIM(LTRIM(IFNULL(Par_PrimerNombre, '')))
                                ,CASE WHEN CHAR_LENGTH(RTRIM(LTRIM(IFNULL(Par_SegundoNombre, '')))) > 0 THEN CONCAT(" ", RTRIM(LTRIM(IFNULL(Par_SegundoNombre, '')))) ELSE '' END
                                ,CASE WHEN CHAR_LENGTH(RTRIM(LTRIM(IFNULL(Par_TercerNombre, '')))) > 0 THEN CONCAT(" ", RTRIM(LTRIM(IFNULL(Par_TercerNombre, '')))) ELSE '' END
                                ,CASE WHEN CHAR_LENGTH(RTRIM(LTRIM(IFNULL(Par_PrimerApellido, '')))) > 0 THEN CONCAT(" ", RTRIM(LTRIM(IFNULL(Par_PrimerApellido, '')))) ELSE '' END
                                ,CASE WHEN CHAR_LENGTH(RTRIM(LTRIM(IFNULL(Par_SegundoApellido, '')))) > 0 THEN CONCAT(" ", RTRIM(LTRIM(IFNULL(Par_SegundoApellido, '')))) ELSE '' END
                                );

        IF(Par_ClienteID = Entero_Cero) THEN
            INSERT INTO BENEFICIARIOSINVER(
                    BenefInverID,       InversionID,        ClienteID,          Titulo,             PrimerNombre,
                    SegundoNombre,      TercerNombre,       PrimerApellido,     SegundoApellido,    FechaNacimiento,
                    PaisID,             EstadoID,           EstadoCivil,        Sexo,               CURP,
                    RFC,                OcupacionID,        ClavePuestoID,      TipoIdentiID,       NumIdentific,
                    FecExIden,          FecVenIden,         TelefonoCasa,       TelefonoCelular,    Correo,
                    Domicilio,          TipoRelacionID,     Porcentaje,         NombreCompleto,         EmpresaID,          Usuario,
                    FechaActual,        DireccionIP,        ProgramaID,         Sucursal,           NumTransaccion)
            VALUES (Var_BeneInverID,    Par_InversionID,    Par_ClienteID,      Par_Titulo,         Par_PrimerNombre,
                    Par_SegundoNombre,  Par_TercerNombre,   Par_PrimerApellido, Par_SegundoApellido,Par_FechaNacimiento,
                    Par_PaisID,         Par_EstadoID,       Par_EstadoCivil,    Par_Sexo,           Par_CURP,
                    Par_RFC,            Par_OcupacionID,    Par_ClavePuestoID,  Par_TipoIdentiID,   Par_NumIdentific,
                    Par_FecExIden,      Par_FecVenIden,     Par_TelefonoCasa,   Par_TelefonoCelular,Par_Correo,
                    Par_Domicilio,      Par_TipoRelacionID, Par_Porcentaje,     Var_NombreCompleto,     Par_EmpresaID,      Aud_Usuario,
                    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

                SET Par_NumErr  := '000';
                SET Par_ErrMen  := CONCAT('Beneficiario Agregado Exitosamente: ', Var_BeneInverID );
                SET varControl  := 'beneInverID' ;

        ELSE
            INSERT INTO BENEFICIARIOSINVER(
                    BenefInverID,    InversionID,    ClienteID,          TipoRelacionID,     Porcentaje,
                    EmpresaID,       Usuario,        FechaActual,        DireccionIP,        ProgramaID,
                    Sucursal,        NumTransaccion)
            VALUES(Var_BeneInverID, Par_InversionID,    Par_ClienteID,  Par_TipoRelacionID, Par_Porcentaje,
                    Par_EmpresaID,   Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                   Aud_Sucursal,    Aud_NumTransaccion);

            SET Par_NumErr  := '000';
            SET Par_ErrMen  := CONCAT('Beneficiario Agregado Exitosamente: ', Var_BeneInverID );
            SET varControl  := 'beneInverID' ;
        END IF;
    END IF;

    IF(Par_TipoBene = Ben_CtaSocio)THEN
        IF( Var_TipoBene = Ben_PropioInver)THEN

            DELETE FROM BENEFICIARIOSINVER WHERE InversionID =Par_InversionID;
            UPDATE INVERSIONES SET
                Beneficiario =Ben_CtaSocio
                WHERE InversionID = Par_InversionID;

        END IF;

        SET varCtaInver := (SELECT CuentaAhoID
                            FROM INVERSIONES
                                WHERE InversionID = Par_InversionID);

        SELECT CtaOrdinaria, CuentaVista
            INTO TipoCtaOrd, TipoCtaVista
        FROM PARAMETROSCAJA;

        SET TipoCtaOrd          := IFNULL(TipoCtaOrd, 0);
        SET TipoCtaVista        := IFNULL(TipoCtaVista, 0);

        SET Var_CtaOrdinaria    := (SELECT CuentaAhoID FROM CUENTASAHO WHERE ClienteID = Par_ClienteID AND TipoCuentaID = TipoCtaOrd AND Estatus ='A' LIMIT 1);
        SET Var_CtaVista        := (SELECT CuentaAhoID FROM CUENTASAHO WHERE ClienteID = Par_ClienteID AND TipoCuentaID = TipoCtaVista AND Estatus ='A' LIMIT 1);

        SET Var_CtaOrdinaria    := IFNULL(Var_CtaOrdinaria, 0);
        SET Var_CtaVista        := IFNULL(Var_CtaVista, 0);

        IF Var_CtaOrdinaria = 0 AND Var_CtaVista = 0 THEN
            SET Var_CtaOrdinaria    := varCtaInver;
        END IF;



        INSERT INTO BENEFICIARIOSINVER(
                    BenefInverID,       InversionID,        ClienteID,          Titulo,             PrimerNombre,
                    SegundoNombre,      TercerNombre,       PrimerApellido,     SegundoApellido,    FechaNacimiento,
                    PaisID,             EstadoID,           EstadoCivil,        Sexo,               CURP,
                    RFC,                OcupacionID,        ClavePuestoID,      TipoIdentiID,       NumIdentific,
                    FecExIden,          FecVenIden,         TelefonoCasa,       TelefonoCelular,    Correo,
                    Domicilio,          TipoRelacionID,     Porcentaje,         NombreCompleto,     EmpresaID,
                    Usuario,            FechaActual,        DireccionIP,        ProgramaID,         Sucursal,
                    NumTransaccion)
            SELECT   @Var_BeneInverID := @Var_BeneInverID+1 AS Consecutivo,         Par_InversionID,    ClienteID,
            Titulo,             PrimerNombre,
                    SegundoNombre,      TercerNombre,       ApellidoPaterno,    ApellidoMaterno,    FechaNac,
                    PaisResidencia,     EstadoID,           EstadoCivil,        Sexo,               CURP,
                    RFC,                OcupacionID,        PuestoA,            TipoIdentiID,       NumIdentific,
                    FecExIden,          FecVenIden,         TelefonoCasa,       TelefonoCelular,    Correo,
                    Domicilio,          ParentescoID,       Porcentaje,         NombreCompleto,     Par_EmpresaID,
                    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
                    Aud_NumTransaccion

                FROM    CUENTASPERSONA
                WHERE   CuentaAhoID = varCtaInver
                AND EstatusRelacion = Var_Vigente
                AND EsBeneficiario = EsBenef_SI;



        IF NOT EXISTS(SELECT 1 FROM BENEFICIARIOSINVER WHERE InversionID =  Par_InversionID) THEN
            IF Var_CtaOrdinaria = varCtaInver THEN
                INSERT INTO BENEFICIARIOSINVER(
                        BenefInverID,       InversionID,        ClienteID,          Titulo,             PrimerNombre,
                        SegundoNombre,      TercerNombre,       PrimerApellido,     SegundoApellido,    FechaNacimiento,
                        PaisID,             EstadoID,           EstadoCivil,        Sexo,               CURP,
                        RFC,                OcupacionID,        ClavePuestoID,      TipoIdentiID,       NumIdentific,
                        FecExIden,          FecVenIden,         TelefonoCasa,       TelefonoCelular,    Correo,
                        Domicilio,          TipoRelacionID,     Porcentaje,         NombreCompleto,     EmpresaID,
                        Usuario,            FechaActual,        DireccionIP,        ProgramaID,         Sucursal,
                        NumTransaccion)
                SELECT   @Var_BeneInverID := @Var_BeneInverID+1 AS Consecutivo,         Par_InversionID,    ClienteID,
                Titulo,             PrimerNombre,
                        SegundoNombre,      TercerNombre,       ApellidoPaterno,    ApellidoMaterno,    FechaNac,
                        PaisResidencia,     EstadoID,           EstadoCivil,        Sexo,               CURP,
                        RFC,                OcupacionID,        PuestoA,            TipoIdentiID,       NumIdentific,
                        FecExIden,          FecVenIden,         TelefonoCasa,       TelefonoCelular,    Correo,
                        Domicilio,          ParentescoID,       Porcentaje,         NombreCompleto,     Par_EmpresaID,
                        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
                        Aud_NumTransaccion

                    FROM    CUENTASPERSONA
                    WHERE   CuentaAhoID = Var_CtaVista
                    AND EstatusRelacion = Var_Vigente
                    AND EsBeneficiario = EsBenef_SI;
            ELSE
                INSERT INTO BENEFICIARIOSINVER(
                        BenefInverID,       InversionID,        ClienteID,          Titulo,             PrimerNombre,
                        SegundoNombre,      TercerNombre,       PrimerApellido,     SegundoApellido,    FechaNacimiento,
                        PaisID,             EstadoID,           EstadoCivil,        Sexo,               CURP,
                        RFC,                OcupacionID,        ClavePuestoID,      TipoIdentiID,       NumIdentific,
                        FecExIden,          FecVenIden,         TelefonoCasa,       TelefonoCelular,    Correo,
                        Domicilio,          TipoRelacionID,     Porcentaje,         NombreCompleto,     EmpresaID,
                        Usuario,            FechaActual,        DireccionIP,        ProgramaID,         Sucursal,
                        NumTransaccion)
                SELECT   @Var_BeneInverID := @Var_BeneInverID+1 AS Consecutivo,         Par_InversionID,    ClienteID,
                        Titulo,             PrimerNombre,
                        SegundoNombre,      TercerNombre,       ApellidoPaterno,    ApellidoMaterno,    FechaNac,
                        PaisResidencia,     EstadoID,           EstadoCivil,        Sexo,               CURP,
                        RFC,                OcupacionID,        PuestoA,            TipoIdentiID,       NumIdentific,
                        FecExIden,          FecVenIden,         TelefonoCasa,       TelefonoCelular,    Correo,
                        Domicilio,          ParentescoID,       Porcentaje,         NombreCompleto,     Par_EmpresaID,
                        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
                        Aud_NumTransaccion

                    FROM    CUENTASPERSONA
                    WHERE   CuentaAhoID = Var_CtaOrdinaria
                    AND EstatusRelacion = Var_Vigente
                    AND EsBeneficiario = EsBenef_SI;

            END IF;
        END IF;

        SET Par_NumErr  := 0;
        SET Par_ErrMen  := CONCAT('Beneficiario Agregado Exitosamente: ', Var_BeneInverID );
        SET varControl  := 'beneInverID' ;
    END IF;

  END ManejoErrores;

        IF (Par_Salida = Salida_SI) THEN
            IF(Par_NumErr =0)THEN
                SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
                Par_ErrMen          AS ErrMen,
                varControl          AS control,
                Var_BeneInverID     AS consecutivo;
            ELSE
                 SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
                    Par_ErrMen          AS ErrMen,
                    varControl          AS control,
                    Cadena_Vacia        AS consecutivo;
            END IF;
        END IF;

END TerminaStore$$