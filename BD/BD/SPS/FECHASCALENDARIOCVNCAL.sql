DELIMITER ;
DROP procedure IF EXISTS `FECHASCALENDARIOCVNCAL`;

DELIMITER $$
CREATE PROCEDURE `FECHASCALENDARIOCVNCAL`(
    /* PROCEDIMIENTO QUE CALCULA LAS FECHA DE AL PRIMER AMORTIZACION PARA CREDITOS DE NOMINA
        que MANEJA CALENDARIO Y QUE UTILIZA CON VALOR SI Maneja Fecha de Inicio Calendario */
    Par_ConvenioNominaID     BIGINT UNSIGNED,
    Par_InstitNominaID       INT(11),
    Par_FechaDesembolsoCre   DATE,
    Par_PagoCuota            CHAR(1),               -- Pago de la cuota (Semanal (S), Catorcenal(C) , Quincenal (Q), Mensual(M), P .- Periodo B.-Bimestral T.-Trimestral R.-TetraMestral E.-Semestral A.-Anual)
    Par_PagoFinAni           CHAR(1),               -- solo si el Pago es Mensual indica si es fin de mes (F) o por aniversario (A)

    INOUT Var_FechaInicioCre DATE,          # Parametro de Salida
    INOUT Var_FechaVenc      DATE,          # Parametro de Salida
    INOUT Par_NumErr        INT(11),        # Parametro de entrada/salida de numero de error
    INOUT Par_ErrMen        VARCHAR(400),   # Parametro de entrada/salida de mensaje de control de respuesta de acuerdo al desarrollador

    Aud_EmpresaID           INT(11),        # Parametros de auditoria
    Aud_Usuario             INT(11),        # Parametros de auditoria
    Aud_FechaActual         DATETIME,       # Parametros de auditoria
    Aud_DireccionIP         VARCHAR(15),    # Parametros de auditoria
    Aud_ProgramaID          VARCHAR(50),    # Parametros de auditoria
    Aud_Sucursal            INT(11),        # Parametros de auditoria
    Aud_NumTransaccion      BIGINT(20)      # Parametros de auditoria
)
TerminaStore: BEGIN
-- DECLARACION DE CONSTANTES
    DECLARE Fecha_Vacia             DATE;
    DECLARE Entero_Cero             INT(11);
    DECLARE Entero_Err              INT(11);

-- DECLARACION DE VARIABLES
    DECLARE Var_FechaMes            INT(11);
    DECLARE Var_FechaAnio           INT(11);
    DECLARE Var_ManejaCalendario    CHAR(1);
    DECLARE Var_FechaSistema        DATE;
    DECLARE Var_FechaLimite         DATE;
    DECLARE Var_InstitNominaID      INT(11);
    DECLARE Var_ManejaFechaIniCal   CHAR(1);
    DECLARE Var_No                  CHAR(1);
    DECLARE Var_Si                  CHAR(1);
    DECLARE Var_NumCuotas           INT(11);
    DECLARE Var_CuotaID             INT(11);

    DECLARE Var_Activo              CHAR(1);
    DECLARE Entero_Uno              INT(11);
    DECLARE Es_DiaHabil             CHAR(1);
    DECLARE Var_Control             VARCHAR(20);
    DECLARE Var_FechaVencimiento    DATE;
    DECLARE PagoSemanal             CHAR(1);    -- Pago Semanal (S)
    DECLARE PagoCatorcenal          CHAR(1);    -- Pago Catorcenal (C)
    DECLARE PagoQuincenal           CHAR(1);    -- Pago Quincenal (Q)
    DECLARE PagoMensual             CHAR(1);    -- Pago Mensual (M)
    DECLARE Var_EsHabil             CHAR(1);
    DECLARE Var_CuotaOrig           INT(11);
    DECLARE Var_CalendarioID        INT(11);
    DECLARE Var_CalendarioIngID     INT(11);
    DECLARE Var_ValCalendario       INT(11);
    SET Fecha_Vacia             := '1900-01-01';
    SET Entero_Err              := -1;
    SET Entero_Cero             := 0;
    SET Entero_Uno              := 1;
    SET Var_No                  := 'N';
    SET Var_Si                  := 'S';
    SET Var_Activo              := 'A';
    SET PagoSemanal             := 'S'; -- PagoSemanal
    SET PagoCatorcenal          := 'C'; -- PagoCatorcenal
    SET PagoQuincenal           := 'Q'; -- PagoQuincenal
    SET PagoMensual             := 'M'; -- PagoMensual

    SET Par_FechaDesembolsoCre  := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

    SET Var_FechaMes            := MONTH(Par_FechaDesembolsoCre);
    SET Var_FechaAnio           := YEAR(Par_FechaDesembolsoCre);
    SET Var_ManejaCalendario    := (SELECT ManejaCalendario FROM CONVENIOSNOMINA WHERE ConvenioNominaID = Par_ConvenioNominaID);
    SET Var_ManejaCalendario    := IFNULL(Var_ManejaCalendario,'N');
    SET Var_FechaSistema        := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
    SET Var_InstitNominaID      := (SELECT IFNULL(InstitNominaID, Entero_Cero) FROM INSTITNOMINA WHERE InstitNominaID=Par_InstitNominaID);
    SET Var_NumCuotas           := Entero_Err;
    SET Var_CuotaID             := Entero_Err;
    SET Par_ConvenioNominaID    := IFNULL(Par_ConvenioNominaID, Entero_Cero);
    SET Par_InstitNominaID      := IFNULL(Par_InstitNominaID, Entero_Cero);
    SET Var_CuotaOrig           := Entero_Cero;

 ManejoErrores: BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
        SET Par_NumErr = 999;
        SET Par_ErrMen = CONCAT(    'El SAFI ha tenido un problema al concretar la operacion. ',
                                    'Disculpe las molestias que esto le ocasiona. Ref: SP-FECHASCALENDARIOCVNCAL');
        SET Var_Control = 'sqlException';
	END;

    IF(Par_ConvenioNominaID = Entero_Cero) THEN
        SET Par_NumErr  := 001;
        SET Par_ErrMen  := 'El convenio esta vacio';
        SET Var_Control := 'convenioNominaID';
        LEAVE ManejoErrores;
    END IF;

    IF(Par_InstitNominaID = Entero_Cero) THEN
        SET Par_NumErr  := 002;
        SET Par_ErrMen  := 'La institucion de nomina esta vacia';
        SET Var_Control := 'institNominaID';
        LEAVE ManejoErrores;
    END IF;

    IF(Var_InstitNominaID = Entero_Cero) THEN
        SET Par_NumErr  := 003;
        SET Par_ErrMen  := 'La institucion de nomina no existe';
        SET Var_Control := 'institNominaID';
        LEAVE ManejoErrores;
    END IF;

    SELECT CalendarioIngID, NumCuotas INTO Var_CalendarioIngID, Var_NumCuotas
        FROM CALENDARIOINGRESOS
            WHERE InstitNominaID    = Par_InstitNominaID
            AND ConvenioNominaID    = Par_ConvenioNominaID
            AND Anio                >= Var_FechaAnio
            AND FechaLimiteEnvio    >= Par_FechaDesembolsoCre
        ORDER BY FechaLimiteEnvio ASC
        LIMIT 1;

    /*****************FECHA DE VENCIMIENTO*******************/
    DROP TABLE IF EXISTS TMP_FECHA_CALENDARIOS;
    CREATE TEMPORARY TABLE TMP_FECHA_CALENDARIOS(
        CalendarioID    INT,
        InstitNominaID  INT,
        ConvenioNominaID INT,
        Anio INT,
        NumCuotas INT,
        CalendarioIngID INT,
        FechaLimiteEnvio DATE,
        FechaPrimerDesc DATE,
        PRIMARY KEY (CalendarioID),
        INDEX IDX_FECHA(FechaLimiteEnvio)
    );
    set @calendarioid := 0;

    INSERT INTO TMP_FECHA_CALENDARIOS
    SELECT (@calendarioid := @calendarioid+1),InstitNominaID,ConvenioNominaID,
            Anio, NumCuotas,        CalendarioIngID, FechaLimiteEnvio, FechaPrimerDesc
    FROM CALENDARIOINGRESOS
        WHERE InstitNominaID    = Par_InstitNominaID
        AND ConvenioNominaID    = Par_ConvenioNominaID
        AND Anio                >= Var_FechaAnio
        AND FechaLimiteEnvio    < Par_FechaDesembolsoCre
    ORDER BY FechaLimiteEnvio;

    SELECT MAX(CalendarioID)  INTO Var_CalendarioID FROM TMP_FECHA_CALENDARIOS;
    SET Var_CalendarioID := IFNULL(Var_CalendarioID, 0);

    IF(Var_CalendarioID = 0) THEN
        set @calendarioid := 0;
        INSERT INTO TMP_FECHA_CALENDARIOS
        SELECT (@calendarioid := @calendarioid+1),InstitNominaID,ConvenioNominaID,
                Anio, NumCuotas,        CalendarioIngID, FechaLimiteEnvio, FechaPrimerDesc
        FROM CALENDARIOINGRESOS
            WHERE InstitNominaID    = Par_InstitNominaID
            AND ConvenioNominaID    = Par_ConvenioNominaID
            AND Anio                >= Var_FechaAnio
            AND FechaLimiteEnvio    >= Par_FechaDesembolsoCre
        ORDER BY FechaLimiteEnvio ASC
        limit 1;

        SELECT MAX(CalendarioID)  INTO Var_CalendarioID FROM TMP_FECHA_CALENDARIOS;
        SET Var_CalendarioID := IFNULL(Var_CalendarioID, 0);
    END IF;

    SELECT      NumCuotas,   date_add(FechaLimiteEnvio,interval 1 day),     Var_FechaVenc
        INTO    Var_CuotaID, Var_FechaLimite,   Var_FechaVenc
    FROM TMP_FECHA_CALENDARIOS
        WHERE CalendarioID  = Var_CalendarioID;

    SET Var_CuotaID := IFNULL(Var_CuotaID,Entero_Err);
    IF (Var_CuotaID = Entero_Err) THEN
        SET Par_NumErr  := 004;
        SET Par_ErrMen  := 'No existe un <b>esquema de calendario</b> parametrizado para el convenio de nomina ';
        SET Var_Control := 'institNominaID';
        LEAVE ManejoErrores;
    END IF;


    IF(Var_NumCuotas > Entero_Cero) THEN
        SET Var_CuotaID := Var_CuotaID + Var_NumCuotas;
    END IF;

    IF(Var_FechaLimite >  Var_FechaSistema) THEN

         SELECT CalendarioIngID INTO Var_ValCalendario
            FROM TMP_FECHA_CALENDARIOS
            WHERE InstitNominaID    = Par_InstitNominaID
            AND ConvenioNominaID    = Par_ConvenioNominaID
            LIMIT 1;
        SET Var_ValCalendario :=IFNULL(Var_ValCalendario, Entero_Cero);
        INSERT INTO TMP_FECHA_CALENDARIOS
        SELECT (@calendarioid := @calendarioid+1),InstitNominaID,ConvenioNominaID,
                Anio, NumCuotas,        CalendarioIngID, FechaLimiteEnvio, FechaPrimerDesc
        FROM CALENDARIOINGRESOS
            WHERE InstitNominaID    = Par_InstitNominaID
            AND ConvenioNominaID    = Par_ConvenioNominaID
            AND Anio                >= Var_FechaAnio
            AND FechaLimiteEnvio    >= Par_FechaDesembolsoCre
            AND CalendarioIngID     != Var_ValCalendario
        ORDER BY FechaLimiteEnvio ASC;

        SELECT CalendarioID  INTO Var_CalendarioID
            FROM TMP_FECHA_CALENDARIOS
            WHERE InstitNominaID    = Par_InstitNominaID
            AND ConvenioNominaID    = Par_ConvenioNominaID
            AND Anio                >= Var_FechaAnio
            AND FechaLimiteEnvio    >= Par_FechaDesembolsoCre
        ORDER BY FechaLimiteEnvio ASC
        LIMIT 1;

    END IF;


    IF(Var_FechaLimite <=  Var_FechaSistema) THEN
        SET Var_FechaLimite := Var_FechaSistema;

        INSERT INTO TMP_FECHA_CALENDARIOS
        SELECT (@calendarioid := @calendarioid+1),InstitNominaID,ConvenioNominaID,
                Anio, NumCuotas,        CalendarioIngID, FechaLimiteEnvio, FechaPrimerDesc
        FROM CALENDARIOINGRESOS
            WHERE InstitNominaID    = Par_InstitNominaID
            AND ConvenioNominaID    = Par_ConvenioNominaID
            AND Anio                >= Var_FechaAnio
            AND FechaLimiteEnvio    >= Par_FechaDesembolsoCre
        ORDER BY FechaLimiteEnvio ASC;

       SELECT CalendarioID  INTO Var_CalendarioID
            FROM TMP_FECHA_CALENDARIOS
            WHERE InstitNominaID    = Par_InstitNominaID
            AND ConvenioNominaID    = Par_ConvenioNominaID
            AND Anio                >= Var_FechaAnio
            AND FechaLimiteEnvio    >= Par_FechaDesembolsoCre
        ORDER BY FechaLimiteEnvio ASC
        LIMIT 1;

    END IF;

    SET Var_CalendarioID := Var_CalendarioID + Var_CuotaID;

    SELECT      FechaPrimerDesc
        INTO    Var_FechaVenc
    FROM TMP_FECHA_CALENDARIOS
        WHERE CalendarioID = Var_CalendarioID ;

    SET Var_FechaLimite := IFNULL(Var_FechaLimite, Fecha_Vacia);
    IF(Var_FechaLimite = Fecha_Vacia) THEN
        SET Par_NumErr  := 005;
        SET Par_ErrMen  := 'No existe un <b>esquema de calendario</b> parametrizado para el convenio de nomina ';
        SET Var_Control := 'institNominaID';
        LEAVE ManejoErrores;
    END IF;

    -- se calcula la fecha de inicio con base a la fecha del calendario del convenio
    CASE Par_PagoCuota
        -- Semanales: Se requiere que la fecha de inicio de devengamiento comience 7 días antes tomando de la ----------------------------------
        -- primer fecha de descuento que se indica en el calendario de ingresos. ---------------------------------------------------------------
        WHEN PagoSemanal        THEN
            SET Var_FechaInicioCre :=  CONVERT( DATE_ADD(Var_FechaVenc, INTERVAL 7*-1 DAY),DATE);
            -- SI ESTA FECHA ES MENOR A  LA FECHA LIMITE SE TOMARA COMO INICIO LA FECHA LIMITE
            IF ( Var_FechaInicioCre < Var_FechaLimite) THEN
                IF(Var_FechaInicioCre< Var_FechaSistema)THEN
                    SET Var_FechaInicioCre := Var_FechaSistema;
                ELSE
                    SET Var_FechaInicioCre = Var_FechaLimite;
                END IF;
            END IF;

        --  Catorcenales: Se requiere que la fecha de inicio de devengamiento comience 14 días antes tomando de la -----------------------------
        -- primer fecha de descuento que se indica en el calendario de ingresos. ---------------------------------------------------------------
       WHEN PagoCatorcenal     THEN
            SET Var_FechaInicioCre :=  CONVERT( DATE_ADD(Var_FechaVenc, INTERVAL 14*-1 DAY),DATE);
            -- SI ESTA FECHA ES MENOR A  LA FECHA LIMITE SE TOMARA COMO INICIO LA FECHA LIMITE
            IF ( Var_FechaInicioCre < Var_FechaLimite) THEN
                IF(Var_FechaInicioCre< Var_FechaSistema)THEN
                    SET Var_FechaInicioCre := Var_FechaSistema;
                ELSE
                    SET Var_FechaInicioCre = Var_FechaLimite;
                END IF;
            END IF;

        -- SECCION QUINCENAL:  Se requiere que la fecha de inicio de devengamiento comience el 1 o 15 de cada mes, -----------------------------
        -- tomando en consideración la fecha de primer descuento que se indica en el calendario de ingresos. -----------------------------------
        WHEN PagoQuincenal THEN
            SET Var_FechaInicioCre :=  CONVERT( DATE_ADD(Var_FechaVenc, INTERVAL 15*-1 DAY),DATE);
            -- SI ESTA FECHA ES MENOR A  LA FECHA LIMITE SE TOMARA COMO INICIO LA FECHA LIMITE
            IF ( Var_FechaInicioCre < Var_FechaLimite) THEN
                IF(Var_FechaInicioCre< Var_FechaSistema)THEN
                    SET Var_FechaInicioCre := Var_FechaSistema;
                ELSE
                    SET Var_FechaInicioCre = Var_FechaLimite;
                END IF;
            END IF;
            -- SI ESTA FECHA ES MENOR A  LA FECHA LIMITE SE TOMARA COMO INICIO LA FECHA LIMITE
            IF ( CAST(DATEDIFF(Var_FechaVenc, Var_FechaInicioCre)AS SIGNED)>15) THEN
                IF(Var_FechaInicioCre< Var_FechaSistema)THEN
                    SET Var_FechaInicioCre := Var_FechaSistema;
                ELSE
                    SET Var_FechaInicioCre = Var_FechaLimite;
                END IF;
            END IF;
            -- SI LA DIFERENCIA EN DIAS DE FECHA DE VENCIMIENTO Y FECHA INICIO CREDITO ES MENOR A QUINCE
            IF ( CAST(DATEDIFF(Var_FechaVenc, Var_FechaInicioCre)AS SIGNED)<15) THEN
                SET Var_FechaInicioCre :=  CONVERT( DATE_ADD(Var_FechaVenc, INTERVAL 15*-1 DAY),DATE);

                IF ( Var_FechaInicioCre < Var_FechaLimite) THEN
                    IF(Var_FechaInicioCre< Var_FechaSistema)THEN
                        SET Var_FechaInicioCre := Var_FechaSistema;
                    ELSE
                        SET Var_FechaInicioCre = Var_FechaLimite;
                    END IF;
                END IF;
            END IF;

             /** FIN SECCION VALIDACIONES **/
            IF (Par_PagoFinAni = 'D') THEN
                SET Var_FechaInicioCre :=  CONVERT( DATE_ADD(Var_FechaVenc, INTERVAL 15*-1 DAY),DATE);
                IF ( Var_FechaInicioCre < Var_FechaLimite) THEN
                    IF(Var_FechaInicioCre< Var_FechaSistema)THEN
                        SET Var_FechaInicioCre := Var_FechaSistema;
                    ELSE
                        SET Var_FechaInicioCre = Var_FechaLimite;
                    END IF;
                END IF;
            END IF;

        -- Mensuales: Se requiere que la fecha de inicio de devengamiento comience el 1 de cada mes, -------------------------------------------
        -- tomando en consideración la fecha de primer descuento que se indica en el calendario de ingresos. -----------------------------------
        WHEN PagoMensual THEN
            SET Var_FechaInicioCre :=  CONVERT( DATE_ADD(Var_FechaVenc, INTERVAL 30*-1 DAY),DATE);
            -- SI ESTA FECHA ES MENOR A  LA FECHA LIMITE SE TOMARA COMO INICIO LA FECHA LIMITE
            IF ( Var_FechaInicioCre < Var_FechaLimite) THEN

                IF(Var_FechaInicioCre< Var_FechaSistema)THEN
                    SET Var_FechaInicioCre := Var_FechaSistema;
                ELSE
                    SET Var_FechaInicioCre = Var_FechaLimite;
                END IF;
            END IF;

            -- SI ESTA FECHA ES MENOR A  LA FECHA LIMITE SE TOMARA COMO INICIO LA FECHA LIMITE
            IF ( CAST(DATEDIFF(Var_FechaVenc, Var_FechaInicioCre)AS SIGNED)>30) THEN
                IF(Var_FechaInicioCre< Var_FechaSistema)THEN
                    SET Var_FechaInicioCre := Var_FechaSistema;
                ELSE
                    SET Var_FechaInicioCre = Var_FechaLimite;
                END IF;
            END IF;
        ELSE
            SET Var_FechaInicioCre := Par_FechaDesembolsoCre;
    END CASE;


    SET Var_FechaInicioCre :=  Var_FechaInicioCre;
    SET Var_FechaVenc := Var_FechaVenc;
    SET Var_Control := 'convenioNominaID';

 END ManejoErrores;

END TerminaStore$$
