DELIMITER ;
DROP PROCEDURE IF EXISTS `FECHASCALENDARIONOMCAL`;

DELIMITER $$
CREATE PROCEDURE `FECHASCALENDARIONOMCAL`(
    /* PROCEDIMIENTO QUE CALCULA LAS FECHA DE AL PRIMER AMORTIZACION PARA CREDITOS DE NOMINA*/
    Par_ConvenioNominaID     BIGINT UNSIGNED,
    Par_InstitNominaID       INT(11),
    Par_FechaDesembolsoCre   DATE,

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

    SET Fecha_Vacia             := '1900-01-01';
    SET Entero_Err              := -1;
    SET Entero_Cero             := 0;
    SET Entero_Uno              := 1;
    SET Var_No                  := 'N';
    SET Var_Si                  := 'S';
    SET Var_Activo              := 'A';

    SET Par_FechaDesembolsoCre  := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
    SET Var_FechaMes            := MONTH(Par_FechaDesembolsoCre);
    SET Var_FechaAnio           := YEAR(Par_FechaDesembolsoCre);
    SET Var_ManejaCalendario    := (SELECT ManejaCalendario FROM CONVENIOSNOMINA WHERE ConvenioNominaID = Par_ConvenioNominaID);
    SET Var_ManejaCalendario    := IFNULL(Var_ManejaCalendario,'N');
    SET Var_FechaSistema        := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
    SET Var_InstitNominaID      := (SELECT IFNULL(InstitNominaID, Entero_Cero) FROM INSTITNOMINA WHERE InstitNominaID=Par_InstitNominaID);

 ManejoErrores: BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
        SET Par_NumErr = 999;
        SET Par_ErrMen = CONCAT(    'El SAFI ha tenido un problema al concretar la operacion. ',
                                    'Disculpe las molestias que esto le ocasiona. Ref: SP-FECHASCALENDARIONOMCAL');
        SET Var_Control = 'sqlException';
    END;

    SET Par_ConvenioNominaID := IFNULL(Par_ConvenioNominaID, Entero_Cero);
    SET Par_InstitNominaID := IFNULL(Par_InstitNominaID, Entero_Cero);

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


    -- Si el Parametro Maneja Calendario esta encendido
     IF(Var_ManejaCalendario = Var_Si) THEN

         SET Var_ManejaFechaIniCal := (SELECT ManejaFechaIniCal FROM CONVENIOSNOMINA WHERE ConvenioNominaID = Par_ConvenioNominaID);
         SET Var_ManejaFechaIniCal := IFNULL(Var_ManejaFechaIniCal, Var_No);
         IF(Var_ManejaFechaIniCal = Var_No) THEN
            SET Var_FechaInicioCre := Par_FechaDesembolsoCre;
            /*****************FECHA DE VENCIMIENTO*******************/
            SELECT NumCuotas,CalendarioIngID
                INTO Var_NumCuotas, Var_CuotaID
            FROM CALENDARIOINGRESOS
            WHERE InstitNominaID = Par_InstitNominaID
            AND ConvenioNominaID = Par_ConvenioNominaID
            AND Anio >= Var_FechaAnio
            AND FechaLimiteEnvio > Par_FechaDesembolsoCre
            ORDER BY FechaLimiteEnvio ASC
            LIMIT 1;

            /*****************FECHA DE VENCIMIENTO*******************/

            SET Var_NumCuotas := IFNULL(Var_NumCuotas,Entero_Err);
            IF (Var_NumCuotas = Entero_Err) THEN
                SET Par_NumErr  := 004;
                SET Par_ErrMen  := 'No existe un <b>esquema de calendario</b> parametrizado para el convenio de nomina ';
                SET Var_Control := 'institNominaID';
                LEAVE ManejoErrores;
            END IF;

            -- VALIDACION SI EL NUMERO DE CUOTAS ES 0
            IF(Var_NumCuotas = Entero_Cero) THEN

                SELECT FechaPrimerDesc
                    INTO Var_FechaVenc
                FROM CALENDARIOINGRESOS
                WHERE InstitNominaID = Par_InstitNominaID
                AND ConvenioNominaID = Par_ConvenioNominaID
                AND Anio >= Var_FechaAnio
                AND FechaLimiteEnvio >Par_FechaDesembolsoCre
                ORDER BY FechaLimiteEnvio ASC
                LIMIT 1;


            END IF;

            -- VALIDACION SI EL NUMERO DE CUOTAS ES MAYOR A 0
            IF(Var_NumCuotas > Entero_Cero)THEN
                SET Var_CuotaID := Var_CuotaID + Var_NumCuotas;
                SELECT FechaPrimerDesc INTO Var_FechaVenc
                    FROM CALENDARIOINGRESOS
                    WHERE CalendarioIngID = Var_CuotaID
                    AND InstitNominaID = Par_InstitNominaID
                    AND ConvenioNominaID = Par_ConvenioNominaID;
            END IF;

            SET Var_FechaVenc := IFNULL(Var_FechaVenc, Fecha_Vacia);
            IF(Var_FechaVenc = Fecha_Vacia) THEN
                SET Par_NumErr  := 005;
                SET Par_ErrMen  := 'No existe un <b>esquema de calendario</b> parametrizado para el convenio de nomina ';
                SET Var_Control := 'institNominaID';
                LEAVE ManejoErrores;
            END IF;

        END IF; -- FIN MANEJA FECHA INICIAL NO


        -- MANEJA FECHA INICIAL SI
        IF(Var_ManejaFechaIniCal = Var_Si) THEN
            SET Var_NumCuotas := Entero_Err;
            SET Var_CuotaID   := Entero_Err;

            SELECT NumCuotas, CalendarioIngID
                INTO Var_NumCuotas, Var_CuotaID
            FROM CALENDARIOINGRESOS
            WHERE InstitNominaID = Par_InstitNominaID
            AND ConvenioNominaID = Par_ConvenioNominaID
            AND Anio >= Var_FechaAnio
            AND FechaLimiteEnvio >Par_FechaDesembolsoCre
            ORDER BY FechaLimiteEnvio ASC
            LIMIT 1;

            SET Var_NumCuotas := IFNULL(Var_NumCuotas,Entero_Err);
            IF (Var_NumCuotas = Entero_Err) THEN
                SET Par_NumErr  := 006;
                SET Par_ErrMen  := 'No existe un <b>esquema de calendario</b> parametrizado para el convenio de nomina ';
                SET Var_Control := 'institNominaID';
                LEAVE ManejoErrores;
            END IF;

            IF(Var_NumCuotas = Entero_Cero) THEN
                SELECT FechaLimiteEnvio, FechaPrimerDesc
                    INTO Var_FechaLimite, Var_FechaVenc
                FROM CALENDARIOINGRESOS
                WHERE CalendarioIngID = Var_CuotaID;

            END IF;

            IF(Var_NumCuotas > Entero_Cero) THEN
                SET Var_CuotaID := Var_CuotaID + Var_NumCuotas;
                SELECT  FechaLimiteEnvio,   FechaPrimerDesc
                    INTO Var_FechaLimite,   Var_FechaVenc
                    FROM CALENDARIOINGRESOS
                WHERE CalendarioIngID = Var_CuotaID ;
            END IF;

            SET Var_FechaLimite := IFNULL(Var_FechaLimite, Fecha_Vacia);
            IF(Var_FechaLimite = Fecha_Vacia) THEN
                SET Par_NumErr  := 005;
                SET Par_ErrMen  := 'No existe un <b>esquema de calendario</b> parametrizado para el convenio de nomina ';
                SET Var_Control := 'institNominaID';
                LEAVE ManejoErrores;
            END IF;

            CALL DIASHABILFESTIVOSCAL(DATE_FORMAT(Var_FechaLimite, '%Y-%m-%d'), Entero_Uno,"DF", Var_FechaInicioCre, Es_DiaHabil, Aud_EmpresaID,
                                        Aud_Usuario, Aud_FechaActual, Aud_DireccionIP,Aud_ProgramaID, Aud_Sucursal,Aud_NumTransaccion);
        END IF;

     END IF; -- FIN MANEJA CALENDARIO

    SET Var_FechaInicioCre :=  Var_FechaInicioCre;
    SET Var_FechaVenc := Var_FechaVenc;
    SET Var_Control := 'convenioNominaID';

 END ManejoErrores;

END TerminaStore$$
