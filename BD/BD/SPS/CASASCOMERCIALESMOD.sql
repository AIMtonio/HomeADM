-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CASASCOMERCIALESMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `CASASCOMERCIALESMOD`;
DELIMITER $$

CREATE PROCEDURE `CASASCOMERCIALESMOD`(
    -- =====================================================================================
    -- ----------------- SP PARA MODIFICAR LAS CASAS COMERCIALES  ---------------------
    -- =====================================================================================
    Par_CasaID              INT(11),            -- ID de la Casa Comercial
    Par_NombreCasa          VARCHAR(200),       -- Nombre de Casa Comercial
    Par_TipoDispersion      CHAR(1),            -- Tipo Dispersion de la Casa
    Par_InstitucionID       INT(11),            -- ID de la Institucion de la Cuenta Bancaria
    Par_CuentaClabe         CHAR(18),           -- Cuenta CLABE de la Casa Comercial
    Par_Estatus             CHAR(1),            -- Estatus de la Casa Comercial
    Par_RFC                 CHAR(13),           -- RFC de la Casa Comercial

    Par_Salida			    CHAR(1),            -- Tipo de Salida
	INOUT Par_NumErr	    INT(11),            -- Numero de Error
	INOUT Par_ErrMen	    VARCHAR(400),       -- Mensaje de Error
    -- Parametros de Auditoria
	Aud_EmpresaID		    INT(11),            -- Parametros de Auditoria
	Aud_Usuario			    INT(11),            -- Parametros de Auditoria
	Aud_FechaActual		    DATETIME,           -- Parametros de Auditoria
	Aud_DireccionIP		    VARCHAR(15),        -- Parametros de Auditoria
	Aud_ProgramaID		    VARCHAR(50),        -- Parametros de Auditoria
	Aud_Sucursal		    INT(11),            -- Parametros de Auditoria
	Aud_NumTransaccion	    BIGINT(20)          -- Parametros de Auditoria
    )
TerminaStore: BEGIN

    -- Declaracion de Variables
    DECLARE Var_Control	    VARCHAR(45);        -- Control de Manejo de Error
    DECLARE Var_Inst        INT(11);            -- ID de la Institucion Bancaria
    DECLARE Var_CasaID      INT(11);            -- ID de la Casa Comercial
    DECLARE Var_CodInst     CHAR(3);            -- Folio de la Clabe de Institucion
    DECLARE Var_TamCodInst  INT(11);            -- Tamanio del Folio de la Clabe de Institucion
    DECLARE Var_FolioCta    CHAR(3);            -- Inicio de la Cuenta Clabe

    DECLARE Var_Suma                DECIMAL(14,2);
    DECLARE Var_ResulTotal          DECIMAL(14,2);
    DECLARE Var_Resta               DECIMAL(14,2);
    DECLARE Var_DigVerificador      DECIMAL(14,2);
    DECLARE Var_SubstClabeDieOch    INT(11);

    DECLARE Var_ResModUno           DECIMAL(14,2);
    DECLARE Var_ResModDos           DECIMAL(14,2);
    DECLARE Var_ResModTres          DECIMAL(14,2);
    DECLARE Var_ResModCuatro        DECIMAL(14,2);
    DECLARE Var_ResModCinco         DECIMAL(14,2);
    DECLARE Var_ResModSeis          DECIMAL(14,2);
    DECLARE Var_ResModSiete         DECIMAL(14,2);
    DECLARE Var_ResModOcho          DECIMAL(14,2);
    DECLARE Var_ResModNueve         DECIMAL(14,2);
    DECLARE Var_ResModDiez          DECIMAL(14,2);
    DECLARE Var_ResModOnce          DECIMAL(14,2);
    DECLARE Var_ResModDoce          DECIMAL(14,2);
    DECLARE Var_ResModTrece         DECIMAL(14,2);
    DECLARE Var_ResModCatorce       DECIMAL(14,2);
    DECLARE Var_ResModQuince        DECIMAL(14,2);
    DECLARE Var_ResModDieSeis       DECIMAL(14,2);
    DECLARE Var_ResModDieSiete      DECIMAL(14,2);

    -- Declaracion de Constantes
    DECLARE SalidaSI		CHAR(1);            -- Constante Salida SI
	DECLARE Cadena_Vacia	CHAR;               -- Constante Cadena Vacia
    DECLARE Entero_Cero		INT;                -- Constante Entero Cero
    DECLARE Entero_Uno		INT;                -- Constante Entero Uno
    DECLARE Entero_Tres     INT;                -- Constante Entero Uno
    DECLARE Con_Activo      CHAR(1);            -- Constante Estatus Activo
    DECLARE Con_Inactivo    CHAR(1);            -- Constante Estatus Inactivo
    DECLARE Con_TamCuenta   INT(11);            -- Tamanio de la Cuenta Clabe
    DECLARE Con_SPEI        CHAR(1);            -- Constante SPEI 'S'

    DECLARE Con_PondeTres    INT(11);
    DECLARE Con_PondeSiete   INT(11);
    DECLARE Con_PondeUno     INT(11);
    DECLARE Con_Dies         INT(11);


    -- Seteo de Constantes
    SET SalidaSI			:= 'S';
	SET Cadena_Vacia		:= '';
    SET Entero_Cero			:= 0;
    SET Entero_Uno			:= 1;
    SET Entero_Tres         := 3;
   	SET Con_Activo		    := 'A';
	SET Con_Inactivo		:= 'I';
    SET Con_TamCuenta       := 18;
    SET Con_SPEI            := 'S';

    -- Factores de ponderación
    SET Con_PondeTres       := 3;
    SET Con_PondeSiete      := 7;
    SET Con_PondeUno        := 1;

    SET Con_Dies            := 10;


    ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CASASCOMERCIALESMOD');
				SET Var_Control = 'SQLEXCEPTION';
			END;

        SET Var_CasaID := (SELECT CasaComercialID FROM CASASCOMERCIALES WHERE CasaComercialID = Par_CasaID );
        SET Var_CasaID := IFNULL(Var_CasaID,Entero_Cero);

        IF(Var_CasaID = Entero_Cero)THEN
            SET Par_NumErr  := 001;
            SET Par_ErrMen  := 'El ID de la Casa Comercial no Existe';
            SET Var_Control := 'casaID';
            LEAVE ManejoErrores;
        END IF;

        IF(Par_NombreCasa = Cadena_Vacia)THEN
            SET Par_NumErr  := 002;
			SET Par_ErrMen  := 'Indique Nombre de la Casa Comercial';
			SET Var_Control := 'nombreCasa';
			LEAVE ManejoErrores;
        END IF;

        IF(Par_TipoDispersion = Cadena_Vacia )THEN
            SET Par_NumErr  := 003;
            SET Par_ErrMen  := 'Indique el Tipo de Dispersion';
            SET Var_Control := 'tipoDispersion';
            LEAVE ManejoErrores;
        END IF;

        IF(Par_TipoDispersion = Con_SPEI) THEN

            IF(IFNULL(Par_InstitucionID,Entero_Cero) = Entero_Cero )THEN
                SET Par_NumErr  := 004;
                SET Par_ErrMen  := 'Indique la Institucion';
                SET Var_Control := 'institucionID';
                LEAVE ManejoErrores;
            END IF;

            SET Var_Inst := (SELECT InstitucionID FROM INSTITUCIONES WHERE InstitucionID = Par_InstitucionID);
            SET Var_Inst := IFNULL(Var_Inst, Entero_Cero);

            IF(Var_Inst = Entero_Cero )THEN
                SET Par_NumErr  := 005;
                SET Par_ErrMen  := 'La Institucion Bancaria No Existe';
                SET Var_Control := 'institucionID';
                LEAVE ManejoErrores;
            END IF;

            IF(IFNULL(Par_CuentaClabe,Cadena_Vacia) = Cadena_Vacia )THEN
                SET Par_NumErr  := 006;
                SET Par_ErrMen  := 'Indique la Cuenta Bancaria';
                SET Var_Control := 'cuentaClabe';
                LEAVE ManejoErrores;
            END IF;

            IF(CHARACTER_LENGTH(Par_CuentaClabe)<>18) THEN
                SET Par_NumErr  := 007;
                SET Par_ErrMen  := 'La Cuenta Clabe debe de tener 18 caracteres';
                SET Var_Control := 'cuentaClabe';
                LEAVE ManejoErrores;
            END IF;

             SET Var_CodInst := ( SELECT Folio FROM INSTITUCIONES WHERE InstitucionID = Par_InstitucionID);
            SET Var_CodInst := IFNULL(Var_CodInst, Cadena_Vacia);

            IF(Var_CodInst = Cadena_Vacia) THEN
                SET Par_NumErr  := 006;
                SET Par_ErrMen  := 'No Existe Folio para la Institucion Bancaria';
                SET Var_Control := 'institucionID';
                LEAVE ManejoErrores;
            END IF;

            SET Var_TamCodInst := LENGTH(Var_CodInst);
            SET Var_TamCodInst := IFNULL(Var_TamCodInst, Entero_Cero);

            IF(Var_TamCodInst <> Entero_Tres) THEN
                SET Par_NumErr  := 007;
                SET Par_ErrMen  := 'El Folio para la Institucion Bancaria no es Correcto';
                SET Var_Control := 'institucionID';
                LEAVE ManejoErrores;
            END IF;

            IF(CHARACTER_LENGTH(Par_CuentaClabe)<>Con_TamCuenta) THEN
                SET Par_NumErr  := 008;
                SET Par_ErrMen  := 'La Cuenta Clabe debe de tener 18 caracteres';
                SET Var_Control := 'cuentaClabe';
                LEAVE ManejoErrores;
            END IF;

            SET Var_FolioCta := SUBSTRING(Par_CuentaClabe,1,3);
            IF(Var_FolioCta <> Var_CodInst) THEN
                SET Par_NumErr  := 009;
                SET Par_ErrMen  := 'La Nomenclatura de la Cuenta Clabe es Incorrecta';
                SET Var_Control := 'cuentaClabe';
                LEAVE ManejoErrores;
            END IF;

            -- resultados de multiplicacion de factor de ponderacion por los de numero de la CLABE
            -- resultados de residuo de la division del resultado de la multiplicacion entre 10
            SET Var_ResModUno        := MOD(((SUBSTRING(Par_CuentaClabe, 1,  Entero_Uno)) * Con_PondeTres)  , Con_Dies);
            SET Var_ResModDos        := MOD(((SUBSTRING(Par_CuentaClabe, 2,  Entero_Uno)) * Con_PondeSiete) , Con_Dies);
            SET Var_ResModTres       := MOD(((SUBSTRING(Par_CuentaClabe, 3,  Entero_Uno)) * Con_PondeUno)   , Con_Dies);
            SET Var_ResModCuatro     := MOD(((SUBSTRING(Par_CuentaClabe, 4,  Entero_Uno)) * Con_PondeTres)  , Con_Dies);
            SET Var_ResModCinco      := MOD(((SUBSTRING(Par_CuentaClabe, 5,  Entero_Uno)) * Con_PondeSiete) , Con_Dies);
            SET Var_ResModSeis       := MOD(((SUBSTRING(Par_CuentaClabe, 6,  Entero_Uno)) * Con_PondeUno)   , Con_Dies);
            SET Var_ResModSiete      := MOD(((SUBSTRING(Par_CuentaClabe, 7,  Entero_Uno)) * Con_PondeTres)  , Con_Dies);
            SET Var_ResModOcho       := MOD(((SUBSTRING(Par_CuentaClabe, 8,  Entero_Uno)) * Con_PondeSiete) , Con_Dies);
            SET Var_ResModNueve      := MOD(((SUBSTRING(Par_CuentaClabe, 9,  Entero_Uno)) * Con_PondeUno)   , Con_Dies);
            SET Var_ResModDiez       := MOD(((SUBSTRING(Par_CuentaClabe, 10, Entero_Uno)) * Con_PondeTres)  , Con_Dies);
            SET Var_ResModOnce       := MOD(((SUBSTRING(Par_CuentaClabe, 11, Entero_Uno)) * Con_PondeSiete) , Con_Dies);
            SET Var_ResModDoce       := MOD(((SUBSTRING(Par_CuentaClabe, 12, Entero_Uno)) * Con_PondeUno)   , Con_Dies);
            SET Var_ResModTrece      := MOD(((SUBSTRING(Par_CuentaClabe, 13, Entero_Uno)) * Con_PondeTres)  , Con_Dies);
            SET Var_ResModCatorce    := MOD(((SUBSTRING(Par_CuentaClabe, 14, Entero_Uno)) * Con_PondeSiete) , Con_Dies);
            SET Var_ResModQuince     := MOD(((SUBSTRING(Par_CuentaClabe, 15, Entero_Uno)) * Con_PondeUno)   , Con_Dies);
            SET Var_ResModDieSeis    := MOD(((SUBSTRING(Par_CuentaClabe, 16, Entero_Uno)) * Con_PondeTres)  , Con_Dies);
            SET Var_ResModDieSiete   := MOD(((SUBSTRING(Par_CuentaClabe, 17, Entero_Uno)) * Con_PondeSiete) , Con_Dies);
            SET Var_SubstClabeDieOch := SUBSTRING(Par_CuentaClabe, 18, Entero_Uno);


            -- suma total del resultado de los residuos de cada division
            SET Var_Suma := (Var_ResModUno   + Var_ResModDos     + Var_ResModTres    + Var_ResModCuatro +
                             Var_ResModCinco + Var_ResModSeis    + Var_ResModSiete   + Var_ResModOcho +
                             Var_ResModNueve + Var_ResModDiez    + Var_ResModOnce    + Var_ResModDoce +
                             Var_ResModTrece + Var_ResModCatorce + Var_ResModQuince  + Var_ResModDieSeis +
                             Var_ResModDieSiete );

            -- residuo de la suma total entre 10
            SET Var_ResulTotal := MOD(Var_Suma,Con_Dies);

            -- se resta a 10 el resultado del residuo
            SET Var_Resta := (Con_Dies-Var_ResulTotal);

            -- el digito verificador es el residuo de  dividir el resultado de la resta entre 10
            SET Var_DigVerificador = MOD(Var_Resta,Con_Dies);

            IF( Var_SubstClabeDieOch != Var_DigVerificador ) THEN
                SET Par_NumErr  := 010;
                SET Par_ErrMen  := 'El Digito verificador es incorrecto.';
                SET Var_Control := 'cuentaClabe';
                LEAVE ManejoErrores;
            END IF;

            IF(Par_RFC = Cadena_Vacia) THEN
                SET Par_NumErr  := 009;
                SET Par_ErrMen  := 'El RFC esta Vacio';
                SET Var_Control := 'rfc';
                LEAVE ManejoErrores;
            END IF;

            IF(IFNULL(Par_RFC, Cadena_Vacia)) <> Cadena_Vacia THEN
                IF(CHARACTER_LENGTH(Par_RFC) != 12 AND CHARACTER_LENGTH(Par_RFC) != 13)THEN
                    SET Par_NumErr  := 011;
                    SET Par_ErrMen  := 'La Longitud del RFC es incorrecta';
                    SET Var_Control := 'rfc';
                    LEAVE ManejoErrores;
                END IF;
            END IF;

        END IF;

        IF(Par_Estatus NOT IN (Con_Activo,Con_Inactivo ))THEN
            SET Par_NumErr  := 008;
			SET Par_ErrMen  := 'El Estatus es Incorrecto';
			SET Var_Control := 'estatus';
			LEAVE ManejoErrores;
        END IF;



        UPDATE CASASCOMERCIALES SET
            NombreCasaCom   =   Par_NombreCasa,
            TipoDispersionCasa =    Par_TipoDispersion,
            InstitucionID   =   Par_InstitucionID,
            CuentaCLABE     =   Par_CuentaClabe,
            Estatus         =   Par_Estatus,
            RFC             =   Par_RFC,

            Usuario         =   Aud_Usuario,
            FechaActual     =   Aud_FechaActual,
            DireccionIP     =   Aud_DireccionIP,
            ProgramaID      =   Aud_ProgramaID,
            Sucursal        =   Aud_Sucursal,
            NumTransaccion  =   Aud_NumTransaccion
        WHERE CasaComercialID = Par_CasaID;

        SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= CONCAT("Casa Comercial Modificada Exitosamente: ",CONVERT(Par_CasaID,CHAR));
		SET Var_Control	:= 'casaID';

    END ManejoErrores;

    IF (Par_Salida = SalidaSI) THEN
        SELECT	Par_NumErr AS NumErr,
                Par_ErrMen AS ErrMen,
                Var_Control AS control,
                Par_CasaID AS	consecutivo;
    END IF;

END TerminaStore$$