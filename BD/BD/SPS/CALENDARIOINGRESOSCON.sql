-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALENDARIOINGRESOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CALENDARIOINGRESOSCON`;
DELIMITER $$

CREATE PROCEDURE `CALENDARIOINGRESOSCON`(
    Par_InstitNominaID      INT(11),            -- Numero de Institucion Nomina
    Par_ConvenioNominaID    BIGINT UNSIGNED,    -- Numero de Convenio Nomina
    Par_Anio                INT(4),             -- Numero de Anio
    Par_Estatus             CHAR(1),            -- Estatus del Calendario de Ingresos

    Par_NumCon              TINYINT UNSIGNED,   -- Numero de Lista
    -- AUDITORIA
    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
    )

TerminaStore: BEGIN

    -- DECLARACION DE VARIABLES
    DECLARE Var_Estatus         CHAR(1);
    DECLARE Var_MesFechaSis     INT(11);    -- Mes de la fecha de Sistema
    DECLARE Var_AnioFechaSis    INT(11);    -- Anio de la fecha de Sistema
    DECLARE Var_FechaSis        DATE;       -- Fecha del sistema

    -- DECLARACION DE CONSTANTES
    DECLARE Cadena_Vacia        CHAR(1);    -- Constante Cadena Vacia
    DECLARE Fecha_Vacia         DATE;       -- Constante Fecha Vacia
    DECLARE Entero_Cero         INT;        -- Constante Entero Cero
    DECLARE Incremento          INT(1);     -- Constante Incremento
    DECLARE Con_Principal       INT(11);    -- Consulta Principal de Calendario de Ingresos
    DECLARE Con_Estatus         INT(11);    -- Consulta de Estatus del Calendario de Ingresos
    DECLARE Con_FechaLimEnv     INT(11);    -- Consulta de Fecha Limite de Envio
    DECLARE Var_FechaInicioCre  DATE;       -- Fecha de inicio del credito
    DECLARE Var_FechaVenc       DATE;       -- Fecha vencimiento

    -- ASIGNACION DE CONSTANTES
    SET Cadena_Vacia    := '';
    SET Fecha_Vacia     := '1900-01-01';
    SET Entero_Cero     := 0;
    SET Con_Principal   := 1;
    SET Con_Estatus     := 2;
    SET Con_FechaLimEnv := 3;

    SELECT MONTH(FechaSistema), YEAR(FechaSistema), FechaSistema
        INTO Var_MesFechaSis,   Var_AnioFechaSis,   Var_FechaSis
        FROM PARAMETROSSIS
        WHERE EmpresaID=1;

    -- 1.- Consulta Principal de Calendario de Ingresos
    IF(Par_NumCon = Con_Principal) THEN
        SELECT InstitNominaID,      ConvenioNominaID,   Anio,       Estatus,    FechaRegistro,
               FechaLimiteEnvio,    FechaPrimerDesc,	FechaLimiteRecep,		NumCuotas
        FROM CALENDARIOINGRESOS
        WHERE InstitNominaID = Par_InstitNominaID
        AND ConvenioNominaID = Par_ConvenioNominaID
        AND Anio = Par_Anio;
    END IF;

    -- 2.- Consulta de Estatus del Calendario de Ingresos
    IF(Par_NumCon = Con_Estatus) THEN
        SELECT IFNULL(Estatus,Cadena_Vacia) INTO Var_Estatus
        FROM CALENDARIOINGRESOS
        WHERE InstitNominaID = Par_InstitNominaID
        AND ConvenioNominaID = Par_ConvenioNominaID
        AND Anio = Par_Anio LIMIT 1;

        IF(Var_Estatus != Cadena_Vacia)THEN
            SELECT Estatus
            FROM CALENDARIOINGRESOS
            WHERE InstitNominaID = Par_InstitNominaID
            AND ConvenioNominaID = Par_ConvenioNominaID
            AND Anio = Par_Anio LIMIT 1;
        ELSE
            SELECT 'R' AS Estatus;
        END IF;
    END IF;

    -- 3.- Consulta de Fecha Limite de Envio
    IF(Par_NumCon = Con_FechaLimEnv) THEN

        SELECT InstitNominaID,      ConvenioNominaID,   Anio,       Estatus,    FechaRegistro,
               FechaLimiteEnvio,    FechaPrimerDesc,	FechaLimiteRecep,		NumCuotas,
               FNFECHASCALENDARIONOMCAL(Par_ConvenioNominaID, Par_InstitNominaID, Var_FechaSis) AS FechaPrimerAmorti
        FROM CALENDARIOINGRESOS
        WHERE InstitNominaID = Par_InstitNominaID
        AND ConvenioNominaID = Par_ConvenioNominaID
        AND Anio >= Var_AnioFechaSis
        AND FechaLimiteEnvio >Var_FechaSis
        ORDER BY FechaLimiteEnvio ASC
        LIMIT 1;

    END IF;


END TerminaStore$$
