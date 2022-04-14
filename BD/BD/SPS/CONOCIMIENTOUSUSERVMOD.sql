-- SP CONOCIMIENTOUSUSERVMOD

DELIMITER ;
DROP PROCEDURE IF EXISTS `CONOCIMIENTOUSUSERVMOD`;

DELIMITER $$
CREATE PROCEDURE `CONOCIMIENTOUSUSERVMOD`(
    -- Stored procedure para modificar conocimientos del usuario de servicios.
    -- Pantalla: Prevencion LD > Registro > Conocimiento Usuario Servicios.
    Par_UsuarioServicioID       BIGINT(11),         -- Identificador del usuario de servicios.
    Par_NombreGrupo             VARCHAR(100),       -- Grupo o filial - Nombre de persona.
    Par_RFC                     VARCHAR(13),        -- Grupo o filial - RFC de persona.
    Par_Participacion           DECIMAL(14, 2),     -- Grupo o filial - Porcentaje de participacion.
    Par_Nacionalidad            VARCHAR(45),        -- Grupo o filial - Nacionalidad de persona.

    Par_RazonSocial             VARCHAR(150),       -- Actividad empresarial - Razon social.
    Par_Giro                    VARCHAR(150),       -- Actividad empresarial - Giro de la empresa.
    Par_AniosOperacion          INT(11),            -- Actividad empresarial - Años de operación.
    Par_AniosGiro               INT(11),            -- Actividad empresarial - Años de giro.
    Par_PEPs                    CHAR,               -- Actividad empresarial - Confirmación persona expuesta politicamente S=si, N=no.

    Par_FuncionID               INT(11),            -- Actividad empresarial - Identificador de la función.
    Par_FechaNombramiento       DATE,               -- Actividad empresarial - Fecha de nombramiento en caso de PEPs.
    Par_PorcentajeAcciones      DECIMAL(12, 2),     -- Actividad empresarial - Porcentaje de Acciones en caso de PEPs.
    Par_PeriodoCargo            VARCHAR(100),       -- Actividad empresarial - Periodo del cargo en caso de PEPs.
    Par_MontoAcciones           DECIMAL(14, 2),     -- Actividad empresarial - Monto de las acciones en caso de PEPs.

    Par_ParentescoPEP           CHAR(1),            -- Actividad empresarial - Confirmación de parentesco con PEP S=si, N=no.
    Par_NombreFamiliar          VARCHAR(50),        -- Actividad empresarial - Nombre del familiar.
    Par_APaternoFamiliar        VARCHAR(50),        -- Actividad empresarial - Apellido paterno del familiar.
    Par_AMaternoFamiliar        VARCHAR(50),        -- Actividad empresarial - Apellido materno del familiar.
    Par_NumeroEmpleados         INT(11),            -- Actividad empresarial - Número de empleados de la empresa.

    Par_ServiciosProductos      VARCHAR(50),        -- Actividad empresarial - Principales productos o servicios.
    Par_CoberturaGeografica     CHAR(1),            -- Actividad empresarial - L=local, E=estatal, R=regional, N=nacional, I=internacional.
    Par_EstadosPresencia        INT(11),            -- Actividad empresarial - En cuantos estados se tiene presencia.
    Par_ImporteVentas           DECIMAL(14, 2),     -- Actividad empresarial - Importes de ventas.
    Par_Activos                 DECIMAL(14, 2),     -- Actividad empresarial - Importe activos.

    Par_Pasivos                 DECIMAL(14, 2),     -- Actividad empresarial - Importe de pasivos.
    Par_CapitalContable         DECIMAL(14, 2),     -- Actividad empresarial - Capital contable de la empresa.
    Par_CapitalNeto             DECIMAL(14, 2),     -- Actividad empresarial - Capital neto de la empresa.
    Par_Importa                 CHAR(1),            -- Actividad empresarial - Confirmación de importacion S=si, N=no.
    Par_DolaresImporta          VARCHAR(10),        -- Actividad empresarial - DImp1=menos1000,DImp2=1001-5000,DImp3=5001-10000,DImp4=mayor10001

    Par_PaisesImporta1          VARCHAR(50),        -- Actividad empresarial - Paises a los que se importa (DImp1=menos1000).
    Par_PaisesImporta2          VARCHAR(50),        -- Actividad empresarial - Paises a los que se importa (DImp2=1001-5000).
    Par_PaisesImporta3          VARCHAR(50),        -- Actividad empresarial - Paises a los que se importa (DImp3=5001-10000).
    Par_Exporta                 CHAR(1),            -- Actividad empresarial - Confirmación de exportación S=si, N=no.
    Par_DolaresExporta          VARCHAR(10),        -- Actividad empresarial - DExp1=menos1000,DExp2=1001-5000,DExp3=5001-10000,DExp4=mayor10001

    Par_PaisesExporta1          VARCHAR(50),        -- Actividad empresarial - Paises a los que se exporta (DExp1=menos1000).
    Par_PaisesExporta2          VARCHAR(50),        -- Actividad empresarial - Paises a los que se exporta (DExp2=1001-5000).
    Par_PaisesExporta3          VARCHAR(50),        -- Actividad empresarial - Paises a los que se exporta (DExp3=5001-10000).
    Par_TiposClientes           CHAR(1),            -- Actividad empresarial - F=persona fisica, M=persona moral.
    Par_InstrMonetarios         CHAR(1),            -- Actividad empresarial - Instrumentos monetarios: E=efectivo, C=cheque, T=transferencia.

    Par_NombreRefCom1           VARCHAR(150),       -- Primera referencia comercial - Nombre completo.
    Par_NoCuentaRefCom1         VARCHAR(30),        -- Primera referencia comercial - Número de cuenta.
    Par_DireccionRefCom1        VARCHAR(500),       -- Primera referencia comercial - Dirección completa.
    Par_TelefonoRefCom1         VARCHAR(20),        -- Primera referencia comercial - Número telefonico.
    Par_ExtTelefonoRefCom1      VARCHAR(6),         -- Primera referencia comercial - Número de extención del númumero telefonico.

    Par_NombreRefCom2           VARCHAR(150),       -- Segunda referencia comercial - Nombre completo.
    Par_NoCuentaRefCom2         VARCHAR(30),        -- Segunda referencia comercial - Número de cuenta.
    Par_DireccionRefCom2        VARCHAR(500),       -- Segunda referencia comercial - Dirección completa.
    Par_TelefonoRefCom2         VARCHAR(20),        -- Segunda referencia comercial - Número telefonico.
    Par_ExtTelefonoRefCom2      VARCHAR(6),         -- Segunda referencia comercial - Númuero de extención del número telefonico.

    Par_BancoRefBanc1           VARCHAR(50),        -- Primera referencia bancaria - Nombre del banco.
    Par_TipoCuentaRefBanc1      VARCHAR(50),        -- Primera referencia bancaria - Tipo de cuenta.
    Par_NoCuentaRefBanc1        VARCHAR(30),        -- Primera referencia bancaria - Número de cuenta.
    Par_SucursalRefBanc1        VARCHAR(50),        -- Primera referencia bancaria - Sucursal del banco.
    Par_NoTarjetaRefBanc1       VARCHAR(20),        -- Primera referencia bancaria - Número de tarjeta del banco.

    Par_InstitucionRefBanc1     VARCHAR(50),        -- Primera referencia bancaria - Institución bancaria de la tarjeta.
    Par_CredOtraEntRefBanc1     CHAR(1),            -- Primera referencia bancaria - Confirmación de crédito en otra entidad S=si, N=no.
    Par_InstitucionEntRefBanc1  VARCHAR(50),        -- Primera referencia bancaria - Institución del crédito en otra entidad.
    Par_BancoRefBanc2           VARCHAR(50),        -- Segunda referencia bancaria - Nombre del banco.
    Par_TipoCuentaRefBanc2      VARCHAR(50),        -- Segunda referencia bancaria - Tipo de cuenta.

    Par_NoCuentaRefBanc2        VARCHAR(30),        -- Segunda referencia bancaria - Número de cuenta.
    Par_SucursalRefBanc2        VARCHAR(50),        -- Segunda referencia bancaria - Sucursal del banco.
    Par_NoTarjetaRefBanc2       VARCHAR(20),        -- Segunda referencia bancaria - Número de tarjeta del banco.
    Par_InstitucionRefBanc2     VARCHAR(50),        -- Segunda referencia bancaria - Institución bancaria de la tarjeta.
    Par_CredOtraEntRefBanc2     CHAR(1),            -- Segunda referencia bancaria - Confirmación de crédito en otra entidad S=si, N=no.

    Par_InstitucionEntRefBanc2  VARCHAR(50),        -- Segunda referencia bancaria - Institución del crédito en otra entidad.
    Par_NombreRefPers1          VARCHAR(150),       -- Referencia (1) que no viva en su domicilio - Nombre de la persona.
    Par_DomicilioRefPers1       VARCHAR(500),       -- Referencia (1) que no viva en su domicilio - Domicilio de la persona.
    Par_TelefonoRefPers1        VARCHAR(20),        -- Referencia (1) que no viva en su domicilio - Número telefonico de la persona.
    Par_ExtTelefonoRefPers1     VARCHAR(6),         -- Referencia (1) que no viva en su domicilio - Núm. de extención del núm. telefonico.

    Par_TipoRelacionRefPers1    INT(11),            -- Referencia (1) que no viva en su domicilio - ID tipo de relación con la persona.
    Par_NombreRefPers2          VARCHAR(150),       -- Referencia (2) que no viva en su domicilio - Nombre de la persona.
    Par_DomicilioRefPers2       VARCHAR(500),       -- Referencia (2) que no viva en su domicilio - Domicilio de la persona.
    Par_TelefonoRefPers2        VARCHAR(20),        -- Referencia (2) que no viva en su domicilio - Número telefonico de la persona.
    Par_ExtTelefonoRefPers2     VARCHAR(6),         -- Referencia (2) que no viva en su domicilio - Núm. de extención del núm. telefonico.

    Par_TipoRelacionRefPers2    INT(11),            -- Referencia (2) que no viva en su domicilio - ID tipo de relación con la persona.
    Par_PreguntaUsuario1        VARCHAR(100),       -- Usuario de servicios de riesgo alto - Primera pregunta.
    Par_RespuestaUsuario1       VARCHAR(200),       -- Usuario de servicios de riesgo alto - Primera respuesta.
    Par_PreguntaUsuario2        VARCHAR(100),       -- Usuario de servicios de riesgo alto - Segunda pregunta.
    Par_RespuestaUsuario2       VARCHAR(200),       -- Usuario de servicios de riesgo alto - Segunda respuesta.

    Par_PreguntaUsuario3        VARCHAR(100),       -- Usuario de servicios de riesgo alto - Tercera pregunta.
    Par_RespuestaUsuario3       VARCHAR(200),       -- Usuario de servicios de riesgo alto - Tercera respuesta.
    Par_PreguntaUsuario4        VARCHAR(100),       -- Usuario de servicios de riesgo alto - Cuarta pregunta.
    Par_RespuestaUsuario4       VARCHAR(200),       -- Usuario de servicios de riesgo alto - Cuarta respuesta.
    Par_PrincipalFuenteIng      VARCHAR(100),       -- Principal fuente de ingresos.

    Par_IngAproxPorMes          VARCHAR(10),        -- Ing1=menos20,000, Ing2=20,001-50,000, Ing3=50,001-100,000, Ing4=mayor100,000.
    Par_NivelRiesgo             CHAR(1),            -- Nivel de riesgo del usuario de servicios A=alto, M=medio, B=bajo.
    Par_EvaluaXMatriz           CHAR(1),            -- Confirmación evalua o no la matriz de riesgo S=si, N=no.
    Par_ComentarioNivel         VARCHAR(200),       -- Comentario si el el OC cambió el nivel de riesgo.

    Par_Salida				    CHAR(1),		    -- Parametro de confirmación para salida de datos S=si, N=no.
	INOUT Par_NumErr		    INT(11),            -- Parametro de entrada/salida de numero de error.
	INOUT Par_ErrMen		    VARCHAR(400),	    -- Parametro de entrada/salida de mensaje de control de respuesta.

    Aud_EmpresaID               INT(11),            -- Parámetro de auditoría ID de la empresa.
    Aud_Usuario                 INT(11),            -- Parámetro de auditoría ID del usuario.
    Aud_FechaActual             DATETIME,           -- Parámetro de auditoría fecha actual.
    Aud_DireccionIP             VARCHAR(15),        -- Parámetro de auditoría direccion IP.
    Aud_ProgramaID              VARCHAR(50),        -- Parámetro de auditoría programa.
    Aud_Sucursal                INT(11),            -- Parámetro de auditoría ID de la sucursal.
    Aud_NumTransaccion          BIGINT(20)          -- Parámetro de auditoría numero de transaccion.
)

TerminaStore: BEGIN

    -- Declaración de variables.
    DECLARE Var_Control	    	VARCHAR(100);  	    -- Variable de control.
	DECLARE Var_Consecutivo		INT(11);            -- Variable consecutivo.
    DECLARE Var_UsuarioID       BIGINT(11);         -- Variable para ID del usuario de servicios.
    DECLARE Var_FuncionID       INT(11);            -- Variable para ID de la funcion publica.
    DECLARE Var_TipoRelacion    INT(11);            -- Variable para el tipo de relación.

    DECLARE Var_Nacionalidad    CHAR(1);            -- Variable para nacionalidad del usuario de servicios.
    DECLARE Var_OficialCumID    INT(11);            -- Varibla para ID del OC.
    DECLARE Var_NivelRiesgo     CHAR(1);            -- Variable para el nivel de riesgo del usuario de servicios.

    -- Declaración de constantes.
    DECLARE Entero_Cero         INT(11);            -- Constante número cero (0).
    DECLARE Decimal_Cero        DECIMAL(12,2);      -- Constante decimal cero 0.00
    DECLARE Cadena_Vacia        CHAR(1);            -- Constante cadena vacia ''.
    DECLARE Cons_Si             CHAR(1);            -- Constante si 'S'.
    DECLARE Cons_No             CHAR(1);            -- Constante no 'N'.

    DECLARE Cob_Local           CHAR(1);            -- Cobertura geografica local 'L'.
    DECLARE Cob_Estatal         CHAR(1);            -- Cobertura geografica estatal 'E'.
    DECLARE Cob_Regional        CHAR(1);            -- Cobertura geografica regional 'R'.
    DECLARE Cob_Nacional        CHAR(1);            -- Cobertura geografica nacional 'N'.
    DECLARE Cob_Intl            CHAR(1);            -- Cobertura geografica internacional 'I'.

    DECLARE Decimal_Cien        DECIMAL(12,2);      -- Constante decimal cien 100.00.
    DECLARE Act_EvaluaXMatriz   INT(11);            -- Actualizacion valor para evaluación de la matriz de riesgo a CONOCIMIENTOUSUSERV.
    DECLARE Act_NivelRiesgo     INT(11);            -- Actualizacion del nivel de riego a USUARIOSERVICIO.
    DECLARE Niv_Alto            CHAR(1);            -- Constante nivel de riesgo alto 'A'.
    DECLARE Nac_Extranjera      CHAR(1);            -- Constante nacionalidad extranjera 'E'.

    DECLARE Alt_ConocUsrServ    INT(11);           -- Constante Alta de conocimiento del usuario de servicios (en tabla historica).

    -- Asignación de constantes.
    SET Entero_Cero         := 0;
    SET Decimal_Cero        := 0.00;
    SET Cadena_Vacia        := '';
    SET Cons_Si             := 'S';
    SET Cons_No             := 'N';

    SET Cob_Local           := 'L';
    SET Cob_Estatal         := 'E';
    SET Cob_Regional        := 'R';
    SET Cob_Nacional        := 'N';
    SET Cob_Intl            := 'I';

    SET Decimal_Cien        := 100.00;
    SET Act_EvaluaXMatriz   := 1;
    SET Act_NivelRiesgo     := 3;
    SET Niv_Alto            := 'A';
    SET Nac_Extranjera      := 'E';

    SET Alt_ConocUsrServ    := 7;


    ManejoErrores: BEGIN

        DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			GET DIAGNOSTICS condition 1
			@Var_SQLState = RETURNED_SQLSTATE, @Var_SQLMessage = MESSAGE_TEXT;
			SET Par_NumErr := 999;
			SET Par_ErrMen := LEFT(CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
				'esto le ocasiona. Ref: SP-CONOCIMIENTOUSUSERVMOD','[',@Var_SQLState,'-' , @Var_SQLMessage,']'), 400);
			SET Var_Control := 'SQLEXCEPTION';
		END;

        -- Reasignación de valor a parámetros en caso de venir con valor NULL
        SET Par_UsuarioServicioID = IFNULL(Par_UsuarioServicioID, Entero_Cero);
        SET Par_AniosOperacion := IFNULL(Par_AniosOperacion, Entero_Cero);
        SET Par_AniosGiro := IFNULL(Par_AniosGiro, Entero_Cero);
        SET Par_PorcentajeAcciones := IFNULL(Par_PorcentajeAcciones, Decimal_Cero);
        SET Par_MontoAcciones := IFNULL(Par_MontoAcciones, Decimal_Cero);
        SET Par_DolaresImporta := IFNULL(Par_DolaresImporta, Cadena_Vacia);
        SET Par_DolaresExporta := IFNULL(Par_DolaresExporta, Cadena_Vacia);
        SET Par_CredOtraEntRefBanc1 := IFNULL(Par_CredOtraEntRefBanc1, Cadena_Vacia);
        SET Par_CredOtraEntRefBanc2 := IFNULL(Par_CredOtraEntRefBanc2, Cadena_Vacia);

        IF (Par_UsuarioServicioID = Entero_Cero) THEN
            SET Par_NumErr  := 1;
            SET Par_ErrMen  := 'El numero de usuario de servicios esta vacio.';
            SET Var_Control := 'UsuarioID';
            LEAVE ManejoErrores;
        END IF;

        SELECT  UsuarioServicioID,  Nacionalidad,       NivelRiesgo
        INTO    Var_UsuarioID,      Var_Nacionalidad,   Var_NivelRiesgo
        FROM USUARIOSERVICIO
        WHERE UsuarioServicioID = Par_UsuarioServicioID;

        IF (IFNULL(Var_UsuarioID, Entero_Cero) = Entero_Cero) THEN
            SET Par_NumErr  := 2;
            SET Par_ErrMen  := 'El numero usuario de servicios no existe.';
            SET Var_Control := 'UsuarioID';
            LEAVE ManejoErrores;
        END IF;

        SET Var_UsuarioID := Entero_Cero;
        SET Var_UsuarioID := (SELECT UsuarioServicioID FROM CONOCIMIENTOUSUSERV WHERE UsuarioServicioID = Par_UsuarioServicioID);

        IF(IFNULL(Var_UsuarioID, Entero_Cero) = Entero_Cero) THEN
            SET Par_NumErr  := 3;
            SET Par_ErrMen  := 'Los conocimientos del usuario de servicios no existen.';
            SET Var_Control := 'UsuarioID';
            LEAVE ManejoErrores;
        END IF;

        IF (Par_AniosOperacion < Entero_Cero) THEN
            SET Par_NumErr  := 4;
            SET Par_ErrMen  := 'Los años de operacion deben ser mayor o igual a cero (0).';
            SET Var_Control := 'AniosOperacion';
            LEAVE ManejoErrores;
        END IF;

        IF (Par_AniosGiro < Entero_Cero) THEN
            SET Par_NumErr  := 5;
            SET Par_ErrMen  := 'Los años de giro deben ser mayor o igual a cero (0).';
            SET Var_Control := 'AniosGiro';
            LEAVE ManejoErrores;
        END IF;

        IF (Par_PEPs NOT IN (Cons_Si, Cons_No)) THEN
            SET Par_NumErr  := 6;
            SET Par_ErrMen  := 'El valor de PEPs no es valido.';
            SET Var_Control := 'PEPsNO';
            LEAVE ManejoErrores;
        END IF;

        IF (IFNULL(Par_FuncionID, Entero_Cero) > Entero_Cero) THEN
            SET Var_FuncionID := (SELECT FuncionID FROM FUNCIONESPUB WHERE FuncionID = Par_FuncionID);

            IF (IFNULL(Var_FuncionID, Entero_Cero) = Entero_Cero) THEN
                SET Par_NumErr  := 7;
                SET Par_ErrMen  := 'La funcion publica no existe.';
                SET Var_Control := 'funcionID';
                LEAVE ManejoErrores;
            END IF;
        END IF;

        IF (Par_PorcentajeAcciones < Decimal_Cero) THEN
            SET Par_NumErr  := 8;
            SET Par_ErrMen  := 'El porcentaje de acciones debe ser mayor o igual a cero (0).';
            SET Var_Control := 'porcentajeAcciones';
            LEAVE ManejoErrores;
        END IF;

        IF (Par_PorcentajeAcciones > Decimal_Cien) THEN
            SET Par_NumErr  := 9;
            SET Par_ErrMen  := 'El porcentaje de acciones no puede ser mayor a 100.';
            SET Var_Control := 'porcentajeAcciones';
            LEAVE ManejoErrores;
        END IF;

        IF (Par_MontoAcciones < Decimal_Cero) THEN
            SET Par_NumErr  := 10;
            SET Par_ErrMen  := 'El monto de las acciones debe ser mayor o igual a cero (0).';
            SET Var_Control := 'montoAcciones';
            LEAVE ManejoErrores;
        END IF;

        IF (Par_ParentescoPEP NOT IN (Cons_Si, Cons_No)) THEN
            SET Par_NumErr  := 11;
            SET Par_ErrMen  := 'El valor parentesco con PEPs no es valido.';
            SET Var_Control := 'parentescoPEPNO';
            LEAVE ManejoErrores;
        END IF;

        IF (Par_CoberturaGeografica NOT IN (Cob_Local, Cob_Estatal, Cob_Regional, Cob_Nacional, Cob_Intl)) THEN
            SET Par_NumErr  := 12;
            SET Par_ErrMen  := 'El valor cobertura geografica no es valido.';
            SET Var_Control := 'coberturaGeografica1';
            LEAVE ManejoErrores;
        END IF;

        IF (Par_Importa NOT IN (Cons_No, Cons_Si)) THEN
            SET Par_NumErr  := 13;
            SET Par_ErrMen  := 'El valor importa no es valido.';
            SET Var_Control := 'importaNO';
            LEAVE ManejoErrores;
        END IF;

        IF (Par_Exporta NOT IN (Cons_No, Cons_Si)) THEN
            SET Par_NumErr  := 14;
            SET Par_ErrMen  := 'El valor exporta no es valido.';
            SET Var_Control := 'exportaNO';
            LEAVE ManejoErrores;
        END IF;

        IF (IFNULL(Par_TipoRelacionRefPers1, Entero_Cero) > Entero_Cero) THEN
            SET Var_TipoRelacion := (SELECT TipoRelacionID FROM TIPORELACIONES WHERE TipoRelacionID = Par_TipoRelacionRefPers1);

            IF (IFNULL(Var_TipoRelacion, Entero_Cero) = Entero_Cero) THEN
                SET Par_NumErr  := 15;
                SET Par_ErrMen  := 'El tipo de relacion de la primera referencia no existe.';
                SET Var_Control := 'tipoRelacionRefPers1';
                LEAVE ManejoErrores;
            END IF;
        END IF;

        IF (IFNULL(Par_TipoRelacionRefPers2, Entero_Cero) > Entero_Cero) THEN
            SET Var_TipoRelacion := Entero_Cero;
            SET Var_TipoRelacion := (SELECT TipoRelacionID FROM TIPORELACIONES WHERE TipoRelacionID = Par_TipoRelacionRefPers2);

            IF (IFNULL(Var_TipoRelacion, Entero_Cero) = Entero_Cero) THEN
                SET Par_NumErr  := 16;
                SET Par_ErrMen  := 'El tipo de relacion de la segunda referencia no existe.';
                SET Var_Control := 'tipoRelacionRefPers2';
                LEAVE ManejoErrores;
            END IF;
        END IF;

        IF (Var_Nacionalidad = Nac_Extranjera AND Par_PEPs = Cons_Si AND Var_NivelRiesgo <> Niv_Alto) THEN
            -- Si el usuario de servicios es extranjero y es PEP se concidera como de Nivel de Alto Riesgo.
            CALL USUARIOSERVICIOACT (
                Par_UsuarioServicioID,  Entero_Cero,        Niv_Alto,       Act_NivelRiesgo,    Cons_No,
                Par_NumErr,             Par_ErrMen,         Aud_EmpresaID,  Aud_Usuario,        Aud_FechaActual,
                Aud_DireccionIP,        Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion
            );

            IF (Par_NumErr <> Entero_Cero) THEN
                LEAVE ManejoErrores;
            END IF;
        END IF;

        UPDATE CONOCIMIENTOUSUSERV SET
            NombreGrupo             = Par_NombreGrupo,
            RFC                     = Par_RFC,
            Participacion           = Par_Participacion,
            Nacionalidad            = Par_Nacionalidad,
            RazonSocial             = Par_RazonSocial,

            Giro                    = Par_Giro,
            AniosOperacion          = Par_AniosOperacion,
            AniosGiro               = Par_AniosGiro,
            PEPs                    = Par_PEPs,
            FuncionID               = Par_FuncionID,

            FechaNombramiento       = Par_FechaNombramiento,
            PorcentajeAcciones      = Par_PorcentajeAcciones,
            PeriodoCargo            = Par_PeriodoCargo,
            MontoAcciones           = Par_MontoAcciones,
            ParentescoPEP           = Par_ParentescoPEP,

            NombreFamiliar          = Par_NombreFamiliar,
            APaternoFamiliar        = Par_APaternoFamiliar,
            AMaternoFamiliar        = Par_AMaternoFamiliar,
            NumeroEmpleados         = Par_NumeroEmpleados,
            ServiciosProductos      = Par_ServiciosProductos,

            CoberturaGeografica     = Par_CoberturaGeografica,
            EstadosPresencia        = Par_EstadosPresencia,
            ImporteVentas           = Par_ImporteVentas,
            Activos                 = Par_Activos,
            Pasivos                 = Par_Pasivos,

            CapitalContable         = Par_CapitalContable,
            CapitalNeto             = Par_CapitalNeto,
            Importa                 = Par_Importa,
            DolaresImporta          = Par_DolaresImporta,
            PaisesImporta1          = Par_PaisesImporta1,

            PaisesImporta2          = Par_PaisesImporta2,
            PaisesImporta3          = Par_PaisesImporta3,
            Exporta                 = Par_Exporta,
            DolaresExporta          = Par_DolaresExporta,
            PaisesExporta1          = Par_PaisesExporta1,

            PaisesExporta2          = Par_PaisesExporta2,
            PaisesExporta3          = Par_PaisesExporta3,
            TiposClientes           = Par_TiposClientes,
            InstrMonetarios         = Par_InstrMonetarios,
            NombreRefCom1           = Par_NombreRefCom1,

            NoCuentaRefCom1         = Par_NoCuentaRefCom1,
            DireccionRefCom1        = Par_DireccionRefCom1,
            TelefonoRefCom1         = Par_TelefonoRefCom1,
            ExtTelefonoRefCom1      = Par_ExtTelefonoRefCom1,
            NombreRefCom2           = Par_NombreRefCom2,

            NoCuentaRefCom2         = Par_NoCuentaRefCom2,
            DireccionRefCom2        = Par_DireccionRefCom2,
            TelefonoRefCom2         = Par_TelefonoRefCom2,
            ExtTelefonoRefCom2      = Par_ExtTelefonoRefCom2,
            BancoRefBanc1           = Par_BancoRefBanc1,

            TipoCuentaRefBanc1      = Par_TipoCuentaRefBanc1,
            NoCuentaRefBanc1        = Par_NoCuentaRefBanc1,
            SucursalRefBanc1        = Par_SucursalRefBanc1,
            NoTarjetaRefBanc1       = Par_NoTarjetaRefBanc1,
            InstitucionRefBanc1     = Par_InstitucionRefBanc1,

            CredOtraEntRefBanc1     = Par_CredOtraEntRefBanc1,
            InstitucionEntRefBanc1  = Par_InstitucionEntRefBanc1,
            BancoRefBanc2           = Par_BancoRefBanc2,
            TipoCuentaRefBanc2      = Par_TipoCuentaRefBanc2,
            NoCuentaRefBanc2        = Par_NoCuentaRefBanc2,

            SucursalRefBanc2        = Par_SucursalRefBanc2,
            NoTarjetaRefBanc2       = Par_NoTarjetaRefBanc2,
            InstitucionRefBanc2     = Par_InstitucionRefBanc2,
            CredOtraEntRefBanc2     = Par_CredOtraEntRefBanc2,
            InstitucionEntRefBanc2  = Par_InstitucionEntRefBanc2,

            NombreRefPers1          = Par_NombreRefPers1,
            DomicilioRefPers1       = Par_DomicilioRefPers1,
            TelefonoRefPers1        = Par_TelefonoRefPers1,
            ExtTelefonoRefPers1     = Par_ExtTelefonoRefPers1,
            TipoRelacionRefPers1    = Par_TipoRelacionRefPers1,

            NombreRefPers2          = Par_NombreRefPers2,
            DomicilioRefPers2       = Par_DomicilioRefPers2,
            TelefonoRefPers2        = Par_TelefonoRefPers2,
            ExtTelefonoRefPers2     = Par_ExtTelefonoRefPers2,
            TipoRelacionRefPers2    = Par_TipoRelacionRefPers2,

            PreguntaUsuario1        = Par_PreguntaUsuario1,
            RespuestaUsuario1       = Par_RespuestaUsuario1,
            PreguntaUsuario2        = Par_PreguntaUsuario2,
            RespuestaUsuario2       = Par_RespuestaUsuario2,
            PreguntaUsuario3        = Par_PreguntaUsuario3,

            RespuestaUsuario3       = Par_RespuestaUsuario3,
            PreguntaUsuario4        = Par_PreguntaUsuario4,
            RespuestaUsuario4       = Par_RespuestaUsuario4,
            PrincipalFuenteIng      = Par_PrincipalFuenteIng,
            IngAproxPorMes          = Par_IngAproxPorMes,

            EvaluaXMatriz           = Cons_Si,
            ComentarioNivel         = Cadena_Vacia,
            EmpresaID               = Aud_EmpresaID,
            Usuario                 = Aud_Usuario,
            FechaActual             = Aud_FechaActual,

            DireccionIP             = Aud_DireccionIP,
            ProgramaID              = Aud_ProgramaID,
            Sucursal                = Aud_Sucursal,
            NumTransaccion          = Aud_NumTransaccion
        WHERE UsuarioServicioID = Par_UsuarioServicioID;

        SET Var_OficialCumID := (SELECT OficialCumID FROM PARAMETROSSIS PS WHERE PS.OficialCumID = Aud_Usuario LIMIT 1);

        IF (Var_OficialCumID = Aud_Usuario) THEN

            IF (IFNULL(Par_EvaluaXMatriz, Cadena_Vacia) = Cadena_Vacia) THEN
                SET Par_EvaluaXMatriz := Cons_Si;
            END IF;

            CALL CONOCIMIENTOUSUSERVACT (
                Par_UsuarioServicioID,  Par_EvaluaXMatriz,  Par_ComentarioNivel,    Act_EvaluaXMatriz,  Cons_No,
                Par_NumErr,             Par_ErrMen,         Aud_EmpresaID,          Aud_Usuario,        Aud_FechaActual,
                Aud_DireccionIP,        Aud_ProgramaID,     Aud_Sucursal,           Aud_NumTransaccion
            );

            IF (Par_NumErr <> Entero_Cero) THEN
                LEAVE ManejoErrores;
            END IF;

            IF (IFNULL(Par_NivelRiesgo, Cadena_Vacia) = Cadena_Vacia) THEN
                SET Par_NivelRiesgo := Var_NivelRiesgo;
            END IF;

            CALL USUARIOSERVICIOACT (
                Par_UsuarioServicioID,  Entero_Cero,        Par_NivelRiesgo,    Act_NivelRiesgo,    Cons_No,
                Par_NumErr,             Par_ErrMen,         Aud_EmpresaID,      Aud_Usuario,        Aud_FechaActual,
                Aud_DireccionIP,        Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion
            );

            IF (Par_NumErr <> Entero_Cero) THEN
                LEAVE ManejoErrores;
            END IF;
        END IF;

        -- Se almacena la Información en la Bitacora Historica.
	    CALL BITACORAHISTPERSALT(
		    Aud_NumTransaccion,     Alt_ConocUsrServ,   Par_UsuarioServicioID,  Entero_Cero,        Entero_Cero,
		    Entero_Cero,			Cons_No,			Par_NumErr,             Par_ErrMen,			Aud_EmpresaID,
		    Aud_Usuario,			Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,		Aud_Sucursal,
		    Aud_NumTransaccion
        );

	    IF (Par_NumErr <> Entero_Cero) THEN
            LEAVE ManejoErrores;
        END IF;

        SET Par_NumErr  := 0;
	    SET Par_ErrMen  := CONCAT("Conocimiento del usuario de servicios modificado exitosamente: ", CONVERT(Par_UsuarioServicioID, CHAR));
	    SET Var_Control := 'usuarioID';
        SET Var_Consecutivo := Entero_Cero;

    END ManejoErrores;

    IF (Par_Salida = Cons_Si) THEN
		SELECT
			Par_NumErr  AS  NumErr,
		    Par_ErrMen  AS  ErrMen,
			Var_Control AS  Control,
			Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$