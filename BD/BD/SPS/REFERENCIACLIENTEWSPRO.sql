-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REFERENCIACLIENTEWSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `REFERENCIACLIENTEWSPRO`;
DELIMITER $$

CREATE PROCEDURE `REFERENCIACLIENTEWSPRO`(
    -- SP PARA DAR DE ALTA LAS REFERENCIAS DE LA SOLICITUD DE CREDITO
    Par_SolicitudCreditoID  BIGINT(20),         -- Numero de solicitud de credito
    Par_PrimerNombre        VARCHAR(50),        -- Primer Nombre
    Par_SegundoNombre       VARCHAR(50),        -- Segundo Nombre
    Par_TercerNombre        VARCHAR(50),        -- Tercer Nombre
    Par_ApellidoPaterno     VARCHAR(50),        -- Apellido paterno

    Par_ApellidoMaterno     VARCHAR(50),        -- Apellido materno
    Par_Telefono            VARCHAR(20),        -- Numero de telefono de la referencia
    Par_ExtTelefonoPart     VARCHAR(7),         -- Extension del telefono
    Par_TipoRelacionID      INT(11),            -- ID de la tabla de TIPORELACIONES
    Par_EstadoID            INT(11),            -- Estado ID de la tabla ESTADOSREPUB

    Par_MunicipioID         INT(11),            -- Municipio ID de la tabla MUNICIPIOSREPUB
    Par_LocalidadID         INT(11),            -- Localidad ID de la tabla LOCALIDADREPUB
    Par_ColoniaID           INT(11),            -- Colonia ID de la tabla COLONIASREPUB
    Par_Calle               VARCHAR(50),        -- Calle de la direccion de la referencia
    Par_NumeroCasa          VARCHAR(10),        -- Numero de la casa

    Par_NumInterior         VARCHAR(10),        -- Numero Interior
    Par_Piso                VARCHAR(50),        -- Numero dePiso
    Par_CP                  VARCHAR(5),         -- Codigo Postal
    Par_NumOpe              TINYINT UNSIGNED,   -- TIPO DE OPERACION 1 = Alta, 2 = Modificación
    Par_ReferenciaID        INT(11),            -- ID DE REFERENCIA

    Par_Consecutivo         INT(11),            -- CONSECUTIVO DE REFERENCIA
    Par_Usuario             VARCHAR(400),       -- USUARIO
    Par_Clave               VARCHAR(400),       -- CLAVE
    Par_Salida              CHAR(1),            -- Indica si hay una salida o no
    INOUT Par_NumErr        INT(11),            -- NUMERO DE ERROR

    INOUT Par_ErrMen        VARCHAR(400),       -- MENSAJE DE ERROR
    Aud_EmpresaID           INT(11),            -- Parametro de Auditoria
    Aud_Usuario             INT(11),            -- Parametro de Auditoria
    Aud_FechaActual         DATETIME,           -- Parametro de Auditoria
    Aud_DireccionIP         VARCHAR(15),        -- Parametro de Auditoria

    Aud_ProgramaID          VARCHAR(50),        -- Parametro de Auditoria
    Aud_Sucursal            INT(11),            -- Parametro de Auditoria
    Aud_NumTransaccion      BIGINT(20)          -- Parametro de Auditoria
)
TerminaStore: BEGIN

-- DECLARACION DE VARIABLES
DECLARE Var_Control             VARCHAR(50);    -- CONTROL
DECLARE Var_Consecutivo         VARCHAR(50);    -- CONSECUTIVO
DECLARE Var_SolicitudCreditoID  BIGINT(20);     -- Variable para validacion de que existe la solicitud de credito
DECLARE Var_PerfilWsVbc			INT(11);        -- PERFIL OPERACIONES VBC


-- DECLARACION DE CONSTANTES
DECLARE Cadena_Vacia        CHAR(1);            -- CADENA VACIA
DECLARE Fecha_Vacia         DATE;               -- FECHA VACIA
DECLARE Entero_Cero         INT;                -- ENTERO CERO
DECLARE Var_SI              CHAR(1);            -- VALOR SI
DECLARE Var_NO              CHAR(1);            -- VALOR NO
DECLARE Var_Interesado      CHAR(1);            -- S: Si esta interesando en ser referencia N:No esta interesado
DECLARE Var_Validado        CHAR(1);            -- S:Si esta validada la referencia N: Default Si no ha sido validado
DECLARE Var_OpAlta          INT;                -- OPERACION DE ALTA
DECLARE Var_OpMod           INT;                -- OPERACION DE MODIFICA
DECLARE Est_Activo          CHAR(1);            -- ESTATUS ACTIVO
DECLARE Var_ClienteID			INT(11);			-- Clave del Cliente
DECLARE Var_Clasificacion		CHAR(1);			-- Clasificacion del cliente
DECLARE Clasif_Emp_Nomina		CHAR(1);			-- Clasificacion del empleado de nomina

-- ASIGNACION DE CONSTANTES
SET Cadena_Vacia            := '';                  -- Cadena Vacia
SET Fecha_Vacia             := '1900-01-01';        -- Fecha Vacia
SET Entero_Cero             := 0;                   -- Entero en Cero
SET Var_SI                  := 'S';                 -- Permite Salida SI
SET Var_NO                  := 'N';                 -- Permite Salida NO
SET Var_Interesado          := Var_NO;              -- S: Si esta interesando en ser referencia N:No esta interesado
SET Var_Validado            := Var_NO;              -- S:Si esta validada la referencia N: Default Si no ha sido validado
SET Var_OpAlta              := 1;                   -- OPERACION DE ALTA
SET Var_OpMod               := 2;                   -- OPERACION DE MODIFICA
SET Est_Activo              := 'A';                 -- ESTATUS ACTIVO
SET Clasif_Emp_Nomina		:= 'M';					-- Clasificacion del empleado de nomina


-- ASIGNACION DE VARIABLES
SET Aud_FechaActual         := NOW();               -- FECHA ACTUAL

ManejoErrores:BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr  = 999;
            SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                                    'Disculpe las molestias que esto le ocasiona. Ref: SP-REFERENCIACLIENTEWSPRO');
            SET Var_Control = 'sqlException';
        END;


    -- **************************************************************************************
    -- SE VALIDA EL USUARIO   *******************
    -- **************************************************************************************
	SET Var_PerfilWsVbc		:= (SELECT PerfilWsVbc FROM PARAMETROSSIS LIMIT 1);
    SET Var_PerfilWsVbc		:= IFNULL(Var_PerfilWsVbc,Entero_Cero);

	SELECT ClienteID
		INTO Var_ClienteID
		FROM SOLICITUDCREDITO
		WHERE SolicitudCreditoID=Par_SolicitudCreditoID;

	SET Var_ClienteID := IFNULL(Var_ClienteID, Entero_Cero);

	IF(Var_ClienteID <> Entero_Cero) THEN
		SELECT Clasificacion
			INTO Var_Clasificacion
			FROM CLIENTES
			WHERE ClienteID = Var_ClienteID;
	END IF;

	SET Var_Clasificacion := IFNULL(Var_Clasificacion, Cadena_Vacia);

    IF(Var_PerfilWsVbc = Entero_Cero)THEN
    	SET Par_NumErr		:= '60';
		SET Par_ErrMen		:= 'No existe perfil definido para el usuario.';
		LEAVE ManejoErrores;
    END IF;

    SET Aud_Usuario := (SELECT UsuarioID
                            FROM USUARIOS
                            WHERE Clave = Par_Usuario
                                AND Contrasenia = Par_Clave
                                AND Estatus = Est_Activo  AND RolID = Var_PerfilWsVbc);

    SET Aud_Usuario := IFNULL(Aud_Usuario, Entero_Cero);
    IF(Aud_Usuario = Entero_Cero)THEN
        SET Par_NumErr      := 7;
        SET Par_ErrMen      := "Usuario o Password no valido";
        LEAVE ManejoErrores;
    END IF;

    SET Aud_DireccionIP := '127.0.0.1';
    SET Aud_ProgramaID  := 'REFERENCIACLIENTEWSPRO';

    -- **************************************************************************************
    -- SE VALIDA LA OPERACION A REALIZAR   *******************
    -- **************************************************************************************
    IF(Par_NumOpe = Entero_Cero)THEN
        SET Par_NumErr      := 7;
        SET Par_ErrMen      := "Especifique la Operacion a Realizar";
        LEAVE ManejoErrores;
    END IF;

    -- **************************************************************************************
    IF(Par_NumOpe != 1)THEN
        IF(Par_NumOpe != 2)THEN
            SET Par_NumErr      := 7;
            SET Par_ErrMen      := "Especifique una Operacion a Realizar Valida";
            LEAVE ManejoErrores;
        END IF;
    END IF;


    /** VALIDACIONES *************************************************************/
    IF(IFNULL(Par_SolicitudCreditoID, Entero_Cero)) = Entero_Cero THEN
        SET Par_NumErr  := 001;
        SET Par_ErrMen  := 'El Numero de Solicitud de Credito Esta Vacio.';
        SET Var_Control := 'solicitudCreditoID';
        SET Var_Consecutivo := Entero_Cero;
        LEAVE ManejoErrores;
    END IF;

    SET Var_SolicitudCreditoID  := (SELECT SolicitudCreditoID FROM SOLICITUDCREDITO WHERE SolicitudCreditoID=Par_SolicitudCreditoID);


    IF(IFNULL(Var_SolicitudCreditoID, Entero_Cero)) = Entero_Cero THEN
        SET Par_NumErr  := 002;
        SET Par_ErrMen  := 'El Numero de Solicitud de Credito No Existe.';
        SET Var_Control := 'solicitudCreditoID';
        SET Var_Consecutivo := Entero_Cero;
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_PrimerNombre, Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr  := 003;
        SET Par_ErrMen  := 'El Nombre esta Vacio.';
        SET Var_Control := 'primerNombre';
        SET Var_Consecutivo := Cadena_Vacia;
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_ApellidoPaterno, Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr  := 004;
        SET Par_ErrMen  := 'El Apellido Paterno esta Vacio.';
        SET Var_Control := 'apellidoPaterno';
        SET Var_Consecutivo := Cadena_Vacia;
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_EstadoID,Entero_Cero)) = Entero_Cero AND Var_Clasificacion <> Clasif_Emp_Nomina THEN
        SET Par_NumErr  := 005;
        SET Par_ErrMen  := 'El Estado esta Vacio.' ;
        SET Var_Control := 'estadoID';
        SET Var_Consecutivo := Entero_Cero;
        LEAVE ManejoErrores;
    ELSE
        IF NOT EXISTS(SELECT EstadoID FROM ESTADOSREPUB
                    WHERE EstadoID = Par_EstadoID
                        LIMIT 1) AND IFNULL(Par_EstadoID , Entero_Cero) <> Entero_Cero THEN
            SET Par_NumErr := 006;
            SET Par_ErrMen := 'El Valor Indicado del Estado No Existe.';
            SET Var_Control := 'estadoID';
            SET Var_Consecutivo := Entero_Cero;
            LEAVE ManejoErrores;
        END IF;
    END IF;

    IF(IFNULL(Par_MunicipioID , Entero_Cero)) = Entero_Cero AND Var_Clasificacion <> Clasif_Emp_Nomina THEN
        SET Par_NumErr := 007;
        SET Par_ErrMen := 'El Municipio esta vacio.';
        SET Var_Control := 'municipioID';
        SET Var_Consecutivo := Entero_Cero;
        LEAVE ManejoErrores;
      ELSE
            IF NOT EXISTS(SELECT MunicipioID FROM MUNICIPIOSREPUB
               WHERE MunicipioID = Par_MunicipioID
               AND EstadoID = Par_EstadoID
               LIMIT 1) AND IFNULL(Par_MunicipioID , Entero_Cero) <> Entero_Cero THEN
                SET Par_NumErr := 008;
                SET Par_ErrMen := 'El Municipio Indicado No Existe.';
                SET Var_Control := 'municipioID';
                SET Var_Consecutivo := Entero_Cero;
                LEAVE ManejoErrores;
            END IF;
    END IF;

    IF(IFNULL(Par_LocalidadID, Entero_Cero)) = Entero_Cero AND Var_Clasificacion <> Clasif_Emp_Nomina THEN
        SET Par_NumErr := 009;
        SET Par_ErrMen := 'La Localidad esta Vacia.';
        SET Var_Control := 'localidadID';
        SET Var_Consecutivo := Entero_Cero;
        LEAVE ManejoErrores;
    ELSE
        IF NOT EXISTS(SELECT LocalidadID FROM LOCALIDADREPUB
                    WHERE LocalidadID = Par_LocalidadID
                        AND EstadoID = Par_EstadoID
                        AND MunicipioID = Par_MunicipioID
                        LIMIT 1) AND IFNULL(Par_LocalidadID , Entero_Cero) <> Entero_Cero THEN
            SET Par_NumErr := 010;
            SET Par_ErrMen := 'El Valor Indicado para la Localidad No Existe.';
            SET Var_Control := 'localidadID';
            SET Var_Consecutivo := Entero_Cero;
            LEAVE ManejoErrores;
        END IF;
    END IF;

    IF(IFNULL(Par_ColoniaID, Entero_Cero)) = Entero_Cero AND Var_Clasificacion <> Clasif_Emp_Nomina THEN
        SET Par_NumErr := 011;
        SET Par_ErrMen := 'La Colonia esta Vacia.';
        SET Var_Control := 'colonia';
        SET Var_Consecutivo := Entero_Cero;
        LEAVE ManejoErrores;
    ELSE
        IF NOT EXISTS(SELECT ColoniaID FROM COLONIASREPUB
               WHERE EstadoID = Par_EstadoID
               AND MunicipioID = Par_MunicipioID
               AND ColoniaID = Par_ColoniaID
               LIMIT 1) AND IFNULL(Par_MunicipioID , Entero_Cero) <> Entero_Cero THEN
            SET Par_NumErr  := 012;
            SET Par_ErrMen  := 'El Valor Indicado para la Colonia No Existe.';
            SET Var_Control := 'coloniaID';
            SET Var_Consecutivo := Entero_Cero;
            LEAVE ManejoErrores;
        END IF;
    END IF;

    IF(IFNULL(Par_Calle, Cadena_Vacia)) = Cadena_Vacia AND Var_Clasificacion <> Clasif_Emp_Nomina THEN
        SET Par_NumErr := 014;
        SET Par_ErrMen := 'La Calle esta Vacia.';
        SET Var_Control := 'calle';
        SET Var_Consecutivo := Cadena_Vacia;
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_NumeroCasa, Cadena_Vacia)) = Cadena_Vacia AND Var_Clasificacion <> Clasif_Emp_Nomina THEN
        SET Par_NumErr := 015;
        SET Par_ErrMen := 'El Numero esta Vacio.' ;
        SET Var_Control := 'numeroCasa';
        SET Var_Consecutivo := Cadena_Vacia;
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_CP , Cadena_Vacia)) = Cadena_Vacia AND Var_Clasificacion <> Clasif_Emp_Nomina THEN
        SET Par_NumErr := 015;
        SET Par_ErrMen := 'El Codigo postal esta Vacio.';
        SET Var_Control := 'cp';
        SET Var_Consecutivo := Cadena_Vacia;
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_Telefono,Cadena_Vacia) = Cadena_Vacia)THEN
        SET Par_NumErr := 016;
        SET Par_ErrMen := 'El Telefono esta Vacio.';
        SET Var_Control := 'telefono';
        SET Var_Consecutivo := Cadena_Vacia;
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_Telefono,Cadena_Vacia) = Cadena_Vacia)THEN
        SET Par_NumErr := 017;
        SET Par_ErrMen := 'El Telefono esta Vacio.';
        SET Var_Control := 'telefono';
        SET Var_Consecutivo := Cadena_Vacia;
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_TipoRelacionID,Entero_Cero) = Entero_Cero) AND Var_Clasificacion <> Clasif_Emp_Nomina THEN
        SET Par_NumErr := 018;
        SET Par_ErrMen := 'El Tipo de Relacion Esta Vacio.';
        SET Var_Control := 'tipoRelacionID';
        SET Var_Consecutivo := Cadena_Vacia;
        LEAVE ManejoErrores;
     ELSE
         IF NOT EXISTS(SELECT TipoRelacionID FROM TIPORELACIONES
                   WHERE TipoRelacionID = Par_TipoRelacionID
                   LIMIT 1) AND IFNULL(Par_TipoRelacionID , Entero_Cero) <> Entero_Cero THEN
            SET Par_NumErr  := 019;
            SET Par_ErrMen  := 'El Valor Indicado para el tipo de relacion No Existe.';
            SET Var_Control := 'tipoRelacionID';
            SET Var_Consecutivo := Entero_Cero;
            LEAVE ManejoErrores;
        END IF;
    END IF;


    CASE Par_NumOpe
        WHEN Var_OpAlta THEN
            -- SP PARA DAR DE ALTA LAS REFERENCIAS DE LA SOLICITUD DE CREDITO
            CALL REFERENCIACLIENTEALT(
                Par_SolicitudCreditoID,     Par_PrimerNombre,   Par_SegundoNombre,      Par_TercerNombre,       Par_ApellidoPaterno,
                Par_ApellidoMaterno,        Par_Telefono,       Par_ExtTelefonoPart,    Var_Validado,           Var_Interesado,
                Par_TipoRelacionID,         Par_EstadoID,       Par_MunicipioID,        Par_LocalidadID,        Par_ColoniaID,
                Par_Calle,                  Par_NumeroCasa,     Par_NumInterior,        Par_Piso,               Par_CP,
                Var_NO,                     Par_NumErr,         Par_ErrMen,             Aud_Usuario,            Aud_EmpresaID,
                Aud_FechaActual,            Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion
            );

            IF(Par_NumErr != Entero_Cero )THEN
                LEAVE ManejoErrores;
            ELSE
                SET Par_ErrMen := CONCAT('Referencia Grabada Exitosamente para la Solicitud de Credito: ',Par_SolicitudCreditoID);
            END IF;
        WHEN Var_OpMod THEN
            -- SP PARA MODIFICAR LAS REFERENCIAS DE LA SOLICITUD DE CREDITO
            CALL REFERENCIACLIENTEMOD(
                Par_SolicitudCreditoID,     Par_PrimerNombre,   Par_SegundoNombre,      Par_TercerNombre,       Par_ApellidoPaterno,
                Par_ApellidoMaterno,        Par_Telefono,       Par_ExtTelefonoPart,    Par_TipoRelacionID,     Par_EstadoID,
                Par_MunicipioID,            Par_LocalidadID,    Par_ColoniaID,          Par_Calle,              Par_NumeroCasa,
                Par_NumInterior,            Par_Piso,           Par_CP,                 Par_ReferenciaID,       Par_Consecutivo,
                Var_NO,                     Par_NumErr,         Par_ErrMen,             Aud_Usuario,            Aud_EmpresaID,
                Aud_FechaActual,            Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion
            );

            IF(Par_NumErr != Entero_Cero )THEN
                LEAVE ManejoErrores;
            END IF;
        ELSE
            SET Par_NumErr      := 0;
            SET Par_ErrMen      := CONCAT('Especifique una Operacion a Realizar Valida');
            LEAVE ManejoErrores;
    END CASE;

    SET Par_NumErr      := 0;
    SET Par_ErrMen      := CONCAT(Par_ErrMen);

END ManejoErrores;

IF(Par_Salida = Var_SI)THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen;
END IF;

END TerminaStore$$
