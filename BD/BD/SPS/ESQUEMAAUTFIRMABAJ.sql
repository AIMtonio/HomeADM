-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMAAUTFIRMABAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMAAUTFIRMABAJ`;DELIMITER $$

CREATE PROCEDURE `ESQUEMAAUTFIRMABAJ`(
    Par_Solicitud       INT(11),
    Par_Esquema         INT(11),
    Par_NumFirma        INT(11),
    Par_Organo          INT(11),
    Par_TipoBaja        INT(11),

    Par_Salida          CHAR(1),
    INOUT Par_NumErr    INT,
    INOUT Par_ErrMen    VARCHAR(400),

    Aud_Empresa         INT(11) ,
    Aud_Usuario         INT(11) ,
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_SucursalID      INT(11) ,
    Aud_NumTransaccion  BIGINT(20)

    	)
TerminaStore:BEGIN

            -- Declaracion de variables
DECLARE Var_FechaSistema        DATE;
DECLARE Var_OrganoDescri        VARCHAR(100);
DECLARE Var_NumFirmaOto         INT(11);
DECLARE Var_NumTransaccion      BIGINT(20);
DECLARE Var_EstatusSolici       CHAR(1);
DECLARE Var_CicloActual         INT(11);
DECLARE Var_Cliente             INT(11);
DECLARE Var_Esquema             INT(11);
DECLARE Var_MontoSolicitado     DECIMAL(18,2);
DECLARE Var_MontoMaximo         DECIMAL(18,2);
DECLARE Var_EsGrupal            CHAR(1);
DECLARE Var_NumGrupo            INT(11);
DECLARE Var_SucursalSolici      INT(11);
DECLARE Var_SucursalUsuario     INT(11);
DECLARE Var_EstatusUsuario      CHAR(1);
DECLARE Var_CantFirmasReq       INT(11);
DECLARE Var_CantFirmasOto       INT(11);
DECLARE Var_PuestoUsuario       VARCHAR(10);
DECLARE Var_EstatusPuesto       CHAR(1);
DECLARE Var_AtiendeSucursales   CHAR(1);


            --  Declaracion de   Constantes
DECLARE Cadena_Vacia            CHAR(1);
DECLARE Fecha_Vacia             DATETIME;
DECLARE Entero_Cero             INT(11);
DECLARE Str_SI                  CHAR(1);
DECLARE Str_NO                  CHAR(1);
DECLARE Sol_StaInactiva         CHAR(1);
DECLARE Sol_StaLiberada         CHAR(1);
DECLARE Sol_StaAutorizada       CHAR(1);
DECLARE Cre_StaPagado           CHAR(1);
DECLARE Cre_StaVigente          CHAR(1);
DECLARE Cre_StaVencido          CHAR(1);
DECLARE Cre_StaCastigado        CHAR(1);
DECLARE Usu_StaActivo           CHAR(1);
DECLARE Usu_PuestoVigente       CHAR(1);
DECLARE Baj_PorSolicitud        INT(11);


            -- Asignacion de Constantes
SET Cadena_Vacia            := '';
SET Fecha_Vacia             := '1900-01-01';
SET Entero_Cero             := 0;
SET Str_SI                  := 'S';
SET Str_NO                  := 'N';
SET Sol_StaInactiva         := 'I';     -- Estatus de Solicitud Inactiva
SET Sol_StaLiberada         := 'L';     -- Estatus de Solicitud Liberada
SET Sol_StaAutorizada       := 'A';     -- Estatus de Solicitud Autorizada
SET Cre_StaPagado           := 'P';     -- Estatus de Credito Liquidado
SET Cre_StaVigente          := 'V';     -- Estatus de Credito Vigente
SET Cre_StaVencido          := 'B';     -- Estatus de Credito Vencido
SET Cre_StaCastigado        := 'K';     -- Estatus de Credito Castigado
SET Usu_StaActivo           := 'A';     -- Estatus de Usuario Activo
SET Usu_PuestoVigente       := 'V';     -- Estatus de Puesto Vigente
SET Baj_PorSolicitud        := 1;       -- Baja por Solicitud


-- Fecha de Base de Datos
SET Aud_FechaActual         := CURRENT_TIMESTAMP();

/* Inicializar parametros de salida */
SET     Par_NumErr  := 1;
SET     Par_ErrMen  := Cadena_Vacia;


ManejoErrores: BEGIN
            DECLARE EXIT HANDLER FOR SQLEXCEPTION
                BEGIN
                    SET Par_NumErr = 999;
                    SET Par_ErrMen = CONCAT("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
                                 "estamos trabajando para resolverla. Disculpe las molestias que ",
                                 "esto le ocasiona. Ref: SP-ESQUEMAAUTFIRMABAJ");
                END;

    /*   1.- Baja por Solicitud   */
    IF Par_TipoBaja = Baj_PorSolicitud THEN

        -- Fecha del Sistema
        SET Var_FechaSistema        := (SELECT FechaSistema FROM PARAMETROSSIS);

        --  Set Var_EstatusSolici   := (select Estatus from SOLICITUDCREDITO where SolicitudCreditoID = Par_Solicitud);

         -- obtenemos datos basicos de la solicitud
        SELECT Gru.GrupoID, Sol.Estatus, Sol.SucursalID
        INTO Var_NumGrupo, Var_EstatusSolici, Var_SucursalSolici
        FROM SOLICITUDCREDITO Sol
        LEFT JOIN INTEGRAGRUPOSCRE Gru ON Sol.SolicitudCreditoID = Gru.SolicitudCreditoID
        WHERE Sol.SolicitudCreditoID = Par_Solicitud;



        SET Var_EstatusSolici   := IFNULL(Var_EstatusSolici, Cadena_Vacia);
        SET Var_NumGrupo        := IFNULL(Var_NumGrupo, Entero_Cero);
        SET Var_SucursalSolici  := IFNULL(Var_SucursalSolici, Entero_Cero);

        IF IFNULL(Var_EstatusSolici, Cadena_Vacia) = Cadena_Vacia THEN
            SET Par_ErrMen  := 'La solicitud no existe.';
            IF(Par_Salida = Str_SI) THEN
                SELECT  '001' AS NumErr,
                         Par_ErrMen AS ErrMen,
                         'solicitudCreditoID' AS control,
                         Entero_Cero AS consecutivo;
            END IF;
            LEAVE ManejoErrores;
        END IF;


        IF IFNULL(Var_EstatusSolici, Cadena_Vacia) = Sol_StaAutorizada THEN
            SET Par_ErrMen  := 'La solicitud ya se encuentra Autorizada.';
            IF(Par_Salida = Str_SI) THEN
                SELECT  '002' AS NumErr,
                         Par_ErrMen AS ErrMen,
                         'solicitudCreditoID' AS control,
                         Entero_Cero AS consecutivo;
            END IF;
            LEAVE ManejoErrores;
        END IF;


         IF IFNULL(Var_EstatusSolici, Cadena_Vacia) <> Sol_StaInactiva THEN
            SET Par_ErrMen  := 'La solicitud no esta Inactiva.';
            IF(Par_Salida = Str_SI) THEN
                SELECT  '003' AS NumErr,
                         Par_ErrMen AS ErrMen,
                         'solicitudCreditoID' AS control,
                         Entero_Cero AS consecutivo;
            END IF;
            LEAVE ManejoErrores;
        END IF;


        SELECT Usu.SucursalUSuario, Usu.Estatus,    Pue.ClavePuestoID,      Pue.Estatus,     Pue.AtiendeSuc
        INTO Var_SucursalUsuario, Var_EstatusUsuario, Var_PuestoUsuario, Var_EstatusPuesto, Var_AtiendeSucursales
        FROM USUARIOS Usu
        INNER JOIN PUESTOS Pue ON Pue.ClavePuestoID = Usu.ClavePuestoID
        WHERE Usu.UsuarioID = Aud_Usuario;

        IF IFNULL(Var_EstatusUsuario, Cadena_Vacia) <> Usu_StaActivo THEN
            SET Par_ErrMen  := 'El Usuario se encuentra inactivo.';
            IF(Par_Salida = Str_SI) THEN
                SELECT  '004' AS NumErr,
                         Par_ErrMen AS ErrMen,
                         'solicitudCreditoID' AS control,
                         Entero_Cero AS consecutivo;
            END IF;
            LEAVE ManejoErrores;
        END IF;


        IF IFNULL(Var_SucursalUsuario, Entero_Cero) = Entero_Cero THEN
            SET Par_ErrMen  := 'El Usuario no tiene una sucursal asignada.';
            IF(Par_Salida = Str_SI) THEN
                SELECT  '005' AS NumErr,
                         Par_ErrMen AS ErrMen,
                         'solicitudCreditoID' AS control,
                         Entero_Cero AS consecutivo;
            END IF;
            LEAVE ManejoErrores;
        END IF;


        IF IFNULL(Var_SucursalUsuario, Entero_Cero) <> Var_SucursalSolici AND Var_AtiendeSucursales = Str_SI THEN
            SET Par_ErrMen  := 'No puede Regresar solicitudes de otras sucursales.';
            IF(Par_Salida = Str_SI) THEN
                SELECT  '006' AS NumErr,
                         Par_ErrMen AS ErrMen,
                         'solicitudCreditoID' AS control,
                         Entero_Cero AS consecutivo;
            END IF;
            LEAVE ManejoErrores;
        END IF;



        IF IFNULL(Var_PuestoUsuario, Cadena_Vacia) = Cadena_Vacia THEN
            SET Par_ErrMen  := 'El usuario no tiene un puesto asignado.';
            IF(Par_Salida = Str_SI) THEN
                SELECT  '007' AS NumErr,
                         Par_ErrMen AS ErrMen,
                         'solicitudCreditoID' AS control,
                         Entero_Cero AS consecutivo;
            END IF;
            LEAVE ManejoErrores;
        END IF;


        IF IFNULL(Var_EstatusPuesto, Cadena_Vacia) <> Usu_PuestoVigente THEN
            SET Par_ErrMen  := 'El puesto del usuario no se encuentra Vigente.';
            IF(Par_Salida = Str_SI) THEN
                SELECT  '008' AS NumErr,
                         Par_ErrMen AS ErrMen,
                         'solicitudCreditoID' AS control,
                         Entero_Cero AS consecutivo;
            END IF;
            LEAVE ManejoErrores;
        END IF;

        /*  Por el momento las solicitudes grupales regresan solicitud por solicitud, como si fuera individual
        -- Si la Solicitud es Individual solo elimina las firmas de esa solicitud
        if Var_NumGrupo > Entero_Cero then
                delete from ESQUEMAAUTFIRMA
                where SolicitudCreditoID = Par_Solicitud;
        else    -- Si la Solicitud es Grupal las firmas de todas las solicitudes de ese grupo
                delete from ESQUEMAAUTFIRMA
                where SolicitudCreditoID in (select SolicitudCreditoID
                                             from INTEGRAGRUPOSCRE
                                             where GrupoID = Var_NumGrupo);  --  si se vuelve a utillizar validar que ignore los integrantes rechazados
        end if;

        */

        -- se eliminan las firmas de la solicitud
        DELETE FROM ESQUEMAAUTFIRMA
                WHERE SolicitudCreditoID = Par_Solicitud;

        SET Par_NumErr := 0;
        SET Par_ErrMen := CONCAT("Las Firmas otorgadas a la solicitud ",Par_Solicitud," fueron eliminadas con Exito.");


        LEAVE ManejoErrores;
    END IF;
END ManejoErrores;  -- End del Handler de Errores
	IF (Par_Salida = Str_SI) THEN
		SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen AS ErrMen,
				varControl AS control,
				Entero_Cero AS consecutivo;
	END IF;

END TerminaStore$$