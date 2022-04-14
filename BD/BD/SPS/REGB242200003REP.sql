-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGB242200003REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGB242200003REP`;
DELIMITER $$


CREATE PROCEDURE `REGB242200003REP`(
# ------------------------------------------------------------------------------------------- #
# - SP QUE GENERA EL REPORTE EN EXCEL Y CSV PARA EL REGULATORIO B 2422 ---------------------- #
# ------------------------------------------------------------------------------------------- #
    Par_Anio                INT,            -- Anio del reporte
    Par_Trimestre           INT,            -- Trimestre a reportar
    Par_TipoReporte         INT,            -- Tipo de Reporte Excel(1) o CSV(2)

    Par_EmpresaID           INT(11),        -- Auditoria
    Aud_Usuario             INT(11),        -- Auditoria
    Aud_FechaActual         DATETIME,       -- Auditoria
    Aud_DireccionIP         VARCHAR(15),    -- Auditoria
    Aud_ProgramaID          VARCHAR(50),    -- Auditoria
    Aud_Sucursal            INT(11),        -- Auditoria
    Aud_NumTransaccion      BIGINT(20)      -- Auditoria
    )

TerminaStore:BEGIN

    -- Variables
    DECLARE Var_FechaInicio         DATE;       -- Fecha de inicio del periodo
    DECLARE Var_FechaFin            DATE;       -- Fecha de fin del periodo
    DECLARE Var_MesInicio           INT;        -- Mes de inicio del periodo
    DECLARE Var_MesFin              INT;        -- Mes de Fin del Periodo
    DECLARE Var_TiposTarjeta        VARCHAR(20);-- Tipos de Tarjeta a contar en el reporte

    DECLARE Var_FechaAhorro         DATE;       -- Maxima Fecha de consulta para las cuentas de ahorro
    DECLARE Var_ContarEmpleados     CHAR(1);    -- si el reporte tomara los empleados del sistema o no
    DECLARE Var_MostrarRegistros    CHAR(1);    -- Si se Muestran los Registros

    -- Constantes
    DECLARE Entero_Cero             INT;
    DECLARE Rep_Excel               INT;
    DECLARE Rep_CSV                 INT;
    DECLARE TipoAtencion            CHAR;
    DECLARE Activa                  CHAR;

    DECLARE Tipo_Cajero             CHAR;
    DECLARE Tipo_Sucursal           CHAR;
    DECLARE Masculino               CHAR;
    DECLARE Femenino                CHAR;
    DECLARE TresMeses               INT;

    DECLARE DosMeses                INT;
    DECLARE Var_NO                  CHAR;
    DECLARE Inactiva                CHAR;
    DECLARE PersonaFisica           CHAR;
    DECLARE PersonaFisEmp           CHAR;

    DECLARE Periodo                 VARCHAR(6);
    DECLARE Clave_Entidad           VARCHAR(6);
    DECLARE Subreporte              VARCHAR(4);
    DECLARE Fecha_Vacia             DATE;
    DECLARE ClaveTipoTarjeta        VARCHAR(50);

    DECLARE ClienteInstitucion      INT;
    DECLARE InfSucursales           SMALLINT;
    DECLARE InfCajeros              SMALLINT;
    DECLARE InfTrancajeros          SMALLINT;
    DECLARE InfNumTranTPV           SMALLINT;

    DECLARE InfNumTarDeb            SMALLINT;
    DECLARE InfNumPersonal          SMALLINT;
    DECLARE InfNumMujeres           SMALLINT;
    DECLARE InfNumHombres           SMALLINT;
    DECLARE InfNumMorales           SMALLINT;

    DECLARE InfNumTotSocios         SMALLINT;
    DECLARE EstCancela              SMALLINT;
    DECLARE EstBloqueado            SMALLINT;
    DECLARE EstActivada             SMALLINT;
    DECLARE PersFisica              CHAR(1);

    DECLARE SexFemenino             CHAR(1);
    DECLARE PersFisEmp              CHAR(1);
    DECLARE PersMoral               CHAR(1);
    DECLARE TipoRetiro              VARCHAR(15);
    DECLARE Tipo_Sofipo              INT;
    DECLARE Cadena_Vacia            VARCHAR(2);
    DECLARE Respuesta_Exito     VARCHAR(3);

    DECLARE Clave_NumAtm            INT;
    DECLARE Clave_NumAtmRetiros     INT;
    DECLARE Clave_NumAtmDepositos   INT;
    DECLARE Clave_NumAtmAmbos       INT;

    DECLARE ATM_Dispensador         INT;
    DECLARE ATM_Recolector          INT;
    DECLARE ATM_Ambos               INT;
    DECLARE Tipo_Externo            CHAR(1);
    DECLARE Tipo_Cliente            CHAR(1);
    DECLARE Tipo_Interno            CHAR(1);
    DECLARE Retiro_ATM              VARCHAR(2);
    DECLARE Est_Procesado           CHAR(1);
    DECLARE Est_Vigente             CHAR(1);
    DECLARE Est_Vencido             CHAR(1);
    DECLARE Clave_Mexico            VARCHAR(3);

    DECLARE Mostrar_Todo            CHAR(1);    -- Mostrar Todos los Registros
    DECLARE Cliente_Inst            INT(11);    -- Numero de la Institucion del cliente
    DECLARE Con_Sistema             CHAR(1);    -- Constante Registros de Empleados del Sistema
    DECLARE Con_Manual              CHAR(1);    -- Constante Registros de Empleados Manual
    DECLARE Con_DirOficial          CHAR(1);    -- Constante Direccion Oficial
    DECLARE Clave_Contigencia       INT(11);    -- Constante de Cierre por Contigencia Covid

    -- Inicializacion de constantes
    SET PersMoral           := 'M';             -- Persona Moral
    SET PersFisEmp          := 'A';             -- Persona Fisica con actividad empresarial
    SET PersFisica          := 'F';             -- Persona Fisica
    SET SexFemenino         := 'F';             -- Sexo Femenino
    SET TipoRetiro          := 'RETIRO';        -- Tipo de transaccion de cajero ATM
    SET Entero_Cero         := 0;               -- Entero con valor de cero
    SET Rep_Excel           := 1;               -- Reporte para formato excel
    SET Rep_CSV             := 2;               -- Reporte para formato Csv
    SET TipoAtencion        := 'A';             -- Tipo sucursal de atencion
    SET Activa              := 'A';             -- Estatus Activo
    SET Tipo_Cajero         := 'C';             -- Tipo Cajero
    SET Tipo_Sucursal       := 'S';             -- Tipo Sucursal
    SET Masculino           := 'M';             -- Sexo masculino
    SET TresMeses           := 3;
    SET DosMeses            := 2;
    SET Var_NO              := 'N';
    SET Inactiva            := 'I';
    SET PersonaFisica       := 'F';
    SET PersonaFisEmp       := 'A';
    SET Subreporte          := '2422';          -- Clave del Reporte SITI
    SET Fecha_Vacia         := '1900-01-01';
    SET ClaveTipoTarjeta    := 'TipoTarjetaDeb';    -- Llave para la tabla de parametros, que contiene el ID de las tarjetas a contar
    SET ClienteInstitucion  := 1;                   -- ID del cliente Institucion
    SET Cadena_Vacia        := '';

    SET InfSucursales       := 31;      -- Tipo de informacion Num Sucursales
    SET InfCajeros          := 33;      -- Tipo de informacion Num Cajeros
    SET InfTrancajeros      := 34;      -- Tipo de informacion Num Transaccion por cajero
    SET InfNumTranTPV       := 37;      -- Tipo de informacion Num Transacciones en TPV
    SET InfNumTarDeb        := 38;      -- Tipo de informacion Num de tarjetas debito entregadas
    SET InfNumPersonal      := 39;      -- Tipo de informacion Num de personal contratado
    SET InfNumMujeres       := 49;      -- Tipo de informacion Num de socios mujeres
    SET InfNumHombres       := 50;      -- Tipo de informacion Num de socios hombres
    SET InfNumMorales       := 51;      -- Tipo de informacion Num de socios morales
    SET InfNumTotSocios     := 52;      -- Tipo de informacion Num total de socios
    SET EstCancela          := 9;       -- Estatus tarjeta cancelada
    SET EstBloqueado        := 8;       -- Estatus Tarjeta bloquead
    SET EstActivada         := 7;       -- Estatus Tarjeta Activada
    SET Tipo_Sofipo         := 3;       -- Tipo Regulatorio Socap

    SET Respuesta_Exito          := '000';   -- Codigo de transaccion existosa
    SET Clave_NumAtm             := 53;
    SET Clave_NumAtmRetiros      := 54;
    SET Clave_NumAtmDepositos    := 55;
    SET Clave_NumAtmAmbos        := 56;

    SET ATM_Dispensador     := 1 ;
    SET ATM_Recolector      := 2 ;
    SET ATM_Ambos           := 5 ;
    SET Tipo_Externo        := 'E';
    SET Tipo_Cliente        := 'C';
    SET Tipo_Interno        := 'I';
    SET Retiro_ATM          := '01';
    SET Est_Procesado       := 'P';
    SET Est_Vigente         := 'V';
    SET Est_Vencido         := 'B';
    SET Clave_Mexico        := '484';
    SET Mostrar_Todo        := 'T';     -- Constante Todos
    SET Con_Sistema         := 'S';     -- Constante Sistema
    SET Con_Manual          := 'M';     -- Constante Manual
    SET Con_DirOficial      := 'S';     -- Constante Direccion Oficial
    SET Clave_Contigencia   := 90;
    SELECT MuestraRegistros,     ClaveEntidad,  ContarEmpleados
    INTO   Var_MostrarRegistros, Clave_Entidad, Var_ContarEmpleados
    FROM PARAMREGULATORIOS;

    SELECT ValorParametro INTO Var_TiposTarjeta FROM PARAMREGSERIER24 WHERE LlaveParametro = ClaveTipoTarjeta;
    SET Cliente_Inst    := (SELECT ClienteInstitucion FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID);

    SET Var_MesFin              := Par_Trimestre * TresMeses;
    SET Var_MesInicio           := Var_MesFin - DosMeses;

    SET Var_FechaInicio         := CONCAT(Par_Anio,'-',CASE Var_MesInicio WHEN Var_MesInicio < 10
                                            THEN CONCAT(Entero_Cero,Var_MesInicio) ELSE Var_MesInicio END,'-01');
    SET Var_FechaFin            := CONCAT(Par_Anio,'-',CASE Var_MesFin    WHEN Var_MesFin    < 10
                                            THEN CONCAT(Entero_Cero,Var_MesFin)    ELSE Var_MesFin    END,'-01');

    SET Periodo                 := DATE_FORMAT(Var_FechaFin,'%Y%m');
    -- Obtenemos el ultimo dia del mes para la fecha Final
    SET Var_FechaFin            := LAST_DAY(Var_FechaFin);


    # ------------------------------------------- #
    # TABLA PARA OBTENER EL NUMERO DE SUCURSALES  #
    # Y ATM POR MUNICIPIO SITI ------------------ #
    DROP TABLE IF EXISTS TMPSUCURSALESB2422;
    CREATE TEMPORARY TABLE  TMPSUCURSALESB2422(
        LocalidadID         INT,
        MunicipioID         INT,
        EstadoID            INT,
        Total               INT,
    PRIMARY KEY (EstadoID,MunicipioID,LocalidadID)
    );

    DROP TABLE IF EXISTS DATREGULATORIOB2422;
    CREATE TEMPORARY TABLE  DATREGULATORIOB2422(
        LocalidadID         INT,
        MunicipioID         INT,
        SitiMunicipio       VARCHAR(5),
        EstadoID            INT,
        TipoInformacion     INT,
        Dato                INT
    );


    -- Insertamos el numero de sucursales por municipio SITI
    INSERT INTO TMPSUCURSALESB2422
    SELECT  IFNULL(Suc.LocalidadID,Entero_Cero),      Suc.MunicipioID,       Suc.EstadoID,
        COUNT(Suc.SucursalID) AS NumSucursales
    FROM  SUCURSALES Suc
    WHERE Suc.Estatus = Activa
    AND  FechaAlta   <= Var_FechaFin
    GROUP BY Suc.EstadoID,Suc.MunicipioID,Suc.LocalidadID;

    -- Insertamos los registros de la tabla
    INSERT INTO DATREGULATORIOB2422
    SELECT Tmp.LocalidadID,     Tmp.MunicipioID,    Entero_Cero,    Tmp.EstadoID,   Tip.TipoInforID,
        CASE Tip.TipoInforID
            WHEN InfSucursales THEN  Tmp.Total
            ELSE Entero_Cero
        END
      FROM TMPSUCURSALESB2422 AS Tmp ,TIPOINFORMACION Tip
      WHERE Tip.TipoInstitID = Tipo_Sofipo;

    -- Eliminamos los registros que solo se utilizan para ATM
    DELETE FROM DATREGULATORIOB2422
    WHERE TipoInformacion IN (64,65,66,67);

    -- Insertamos los registros con localidad 0 para ATM
    INSERT INTO DATREGULATORIOB2422
    SELECT Entero_Cero,      Entero_Cero,  Entero_Cero,   Entero_Cero,
        Tip.TipoInforID,   Entero_Cero
        FROM TIPOINFORMACION Tip
    WHERE Tip.TipoInforID IN (64,65,66,67);

    -- Insertamos el numero de ATM por municipio SITI
    DELETE FROM TMPSUCURSALESB2422;
    INSERT INTO TMPSUCURSALESB2422
        SELECT Suc.LocalidadID, Suc.MunicipioID,Suc.EstadoID,COUNT(Atm.CajeroID) AS NumCajeros
    FROM CATCAJEROSATM Atm, SUCURSALES Suc
    WHERE Atm.SucursalID = Suc.SucursalID
    AND  ((Atm.Estatus   = Activa   AND Atm.FechaAlta <= Var_FechaFin)
    OR   (Atm.Estatus    = Inactiva AND Atm.FechaBaja >  Var_FechaInicio))
    GROUP BY Suc.EstadoID,Suc.MunicipioID,Suc.LocalidadID;

    -- Actualizamos el numero de ATMS en la tabla
    UPDATE DATREGULATORIOB2422 Reg,TMPSUCURSALESB2422 Tmp
        SET Reg.Dato = Tmp.Total
        WHERE Reg.EstadoID  = Tmp.EstadoID
        AND Reg.MunicipioID = Tmp.MunicipioID
        AND Reg.LocalidadID = Tmp.LocalidadID
        AND Reg.TipoInformacion = InfCajeros;


     -- Insertamos el numero de Tipo de ATM por municipio SITI
    DROP TABLE IF EXISTS TMPTIPOCAJEROATM;
    CREATE TEMPORARY TABLE TMPTIPOCAJEROATM
        SELECT Suc.LocalidadID, Suc.MunicipioID, Suc.EstadoID,   cat.ClaveD2442 AS TipoCajero,
               COUNT(Atm.CajeroID) AS NumCajeros
    FROM CATCAJEROSATM Atm,  SUCURSALES Suc, CATTIPOCAJERO cat
    WHERE Atm.SucursalID   = Suc.SucursalID
    AND   Atm.TipoCajeroID = cat.TipoCajeroID
    AND  ((Atm.Estatus     = Activa   AND Atm.FechaAlta <= Var_FechaFin)
    OR   (Atm.Estatus      = Inactiva AND Atm.FechaBaja > Var_FechaInicio))
    GROUP BY Suc.EstadoID,Suc.MunicipioID,Suc.LocalidadID,cat.ClaveD2442;

    -- Actualizamos el numero de ATMS en la tabla
    UPDATE DATREGULATORIOB2422 Reg,TMPTIPOCAJEROATM Tmp
        SET Reg.Dato = Tmp.NumCajeros
        WHERE Reg.EstadoID  = Tmp.EstadoID
        AND Reg.MunicipioID = Tmp.MunicipioID
        AND Reg.LocalidadID = Tmp.LocalidadID
        AND Reg.TipoInformacion = Tmp.TipoCajero;


    -- NUMERO DE TARJETAS POR SUCURSAL
    DROP TABLE IF EXISTS TMPTARJETASDEBITOSUC;
    CREATE TABLE TMPTARJETASDEBITOSUC
        SELECT  tar.TarjetaDebID,     tar.FechaActivacion,      tar.Estatus,     tar.ClienteID,
                cli.SucursalOrigen,   cli.NombreCompleto,       suc.MunicipioID, suc.EstadoID , suc.LocalidadID
            FROM TARJETADEBITO tar, CLIENTES cli, SUCURSALES suc,TIPOTARJETADEB tip
            WHERE   tar.ClienteID = cli.ClienteID
            AND cli.SucursalOrigen = suc.SucursalID
            AND tar.TipoTarjetaDebID = tip.TipoTarjetaDebID
            AND tar.FechaActivacion BETWEEN Var_FechaInicio AND Var_FechaFin
            AND tip.IdentificacionSocio = Var_NO
            AND ((tar.Estatus = EstCancela AND tar.FechaCancelacion > Var_FechaFin AND
                    (tar.FechaBloqueo = Fecha_Vacia OR tar.FechaBloqueo > Var_FechaFin))
                    OR tar.Estatus = EstActivada
                    OR (tar.Estatus = EstBloqueado AND tar.FechaBloqueo > Var_FechaFin) )
            AND (cli.Estatus = Activa OR (cli.Estatus = Inactiva AND cli.FechaBaja > Var_FechaFin));

    CREATE INDEX idx_tmptarjetas_1 ON TMPTARJETASDEBITOSUC(SucursalOrigen);
    CREATE INDEX idx_tmptarjetas_3 ON TMPTARJETASDEBITOSUC(ClienteID);


    DROP TABLE IF EXISTS TMPCAMBIOSUCUR;
    CREATE TABLE TMPCAMBIOSUCUR
        SELECT ClienteID,   MIN(Fecha) AS Fecha,  Entero_Cero AS SucursalOrigen
        FROM HISCAMBIOSUCURCLI
            WHERE DATE(Fecha) > Var_FechaFin
        GROUP BY ClienteID ;

    CREATE INDEX idx_cambiosucur_1 ON TMPCAMBIOSUCUR(ClienteID);
    CREATE INDEX idx_cambiosucur_2 ON TMPCAMBIOSUCUR(ClienteID,Fecha);

    UPDATE TMPCAMBIOSUCUR tmp,HISCAMBIOSUCURCLI cam SET
            tmp.SucursalOrigen = cam.SucursalOrigen
  WHERE tmp.ClienteID = cam.ClienteID
    AND tmp.Fecha = cam.Fecha;

    UPDATE TMPTARJETASDEBITOSUC tmp, TMPCAMBIOSUCUR cam, SUCURSALES suc SET
        tmp.SucursalOrigen = cam.SucursalOrigen,
        tmp.MunicipioID = suc.MunicipioID,
        tmp.EstadoID    = suc.EstadoID,
        tmp.LocalidadID = suc.LocalidadID
        WHERE tmp.ClienteID = cam.ClienteID
        AND cam.SucursalOrigen = suc.SucursalID;


    DELETE FROM TMPSUCURSALESB2422;
    INSERT INTO TMPSUCURSALESB2422
        SELECT LocalidadID, MunicipioID,EstadoID,COUNT(TarjetaDebID) AS Total
        FROM  TMPTARJETASDEBITOSUC
        GROUP  BY EstadoID, MunicipioID,LocalidadID;


    UPDATE DATREGULATORIOB2422 reg,TMPSUCURSALESB2422 tar
        SET   reg.Dato = tar.Total
        WHERE reg.EstadoID  = tar.EstadoID
        AND reg.MunicipioID = tar.MunicipioID
        AND reg.LocalidadID = tar.LocalidadID
        AND reg.TipoInformacion = InfNumTarDeb;



    -- Insertamos el numero de Empleados por Sucursal si es manual
    DELETE FROM TMPSUCURSALESB2422;
    IF (Var_ContarEmpleados = Con_Manual) THEN
        INSERT INTO TMPSUCURSALESB2422
            SELECT Suc.LocalidadID, Suc.MunicipioID,Suc.EstadoID, SUM(Emp.PersonalInterno) AS Total
                FROM TMPNUMEMPSUCURSAL AS Emp,  SUCURSALES AS Suc
                WHERE Emp.SucursalID = Suc.SucursalID
                AND Suc.Estatus = Activa
                AND Emp.Anio = Par_Anio
                AND Emp.Periodo = Par_Trimestre
                GROUP BY Suc.EstadoID,Suc.MunicipioID, Suc.LocalidadID ;

        -- Actualizamos el numero de Empleados por Sucursal
        UPDATE DATREGULATORIOB2422 Reg,TMPSUCURSALESB2422 Tmp
            SET Reg.Dato = Tmp.Total
            WHERE Reg.EstadoID = Tmp.EstadoID
            AND Reg.MunicipioID = Tmp.MunicipioID
            AND Reg.LocalidadID = Tmp.LocalidadID
            AND Reg.TipoInformacion = InfNumPersonal;

        DELETE FROM TMPSUCURSALESB2422;
        INSERT INTO TMPSUCURSALESB2422
            SELECT Suc.LocalidadID, Suc.MunicipioID,Suc.EstadoID, sum(Emp.PersonalExterno) as Total
                FROM TMPNUMEMPSUCURSAL AS Emp,  SUCURSALES AS Suc
                WHERE Emp.SucursalID = Suc.SucursalID
                AND Suc.Estatus = Activa
                AND Emp.Anio = Par_Anio
                and Emp.Periodo = Par_Trimestre
                GROUP BY Suc.EstadoID,Suc.MunicipioID, Suc.LocalidadID ;

        UPDATE DATREGULATORIOB2422 Reg,TMPSUCURSALESB2422 Tmp
            SET Reg.Dato = Tmp.Total
            WHERE Reg.EstadoID = Tmp.EstadoID
            AND Reg.MunicipioID = Tmp.MunicipioID
            AND Reg.LocalidadID = Tmp.LocalidadID
            AND Reg.TipoInformacion = 40; -- personal externo
     END IF;

    -- Si se tiene parametrizado que el conteo de empleados es por el sistema
    IF (Var_ContarEmpleados = Con_Sistema) THEN
        INSERT INTO TMPSUCURSALESB2422
            SELECT Suc.LocalidadID, Suc.MunicipioID,Suc.EstadoID, COUNT(Emp.EmpleadoID) AS Total
          FROM EMPLEADOS AS Emp,  SUCURSALES AS Suc
                WHERE Emp.SucursalID = Suc.SucursalID
                AND Suc.Estatus = Activa AND Suc.TipoSucursal = TipoAtencion
                AND (Emp.Estatus = Activa OR (Emp.Estatus = Inactiva AND DATE(Emp.FechaActual) > Var_FechaFin))
                AND Emp.FechaAlta <= Var_FechaFin
                GROUP BY Suc.EstadoID,Suc.MunicipioID, Suc.LocalidadID ;

        -- Actualizamos el numero de Empleados por Sucursal
        UPDATE DATREGULATORIOB2422 Reg,TMPSUCURSALESB2422 Tmp
            SET Reg.Dato = Tmp.Total
            WHERE Reg.EstadoID = Tmp.EstadoID
            AND Reg.MunicipioID = Tmp.MunicipioID
            AND Reg.LocalidadID = Tmp.LocalidadID
            AND Reg.TipoInformacion = InfNumPersonal;
    END IF;

    -- NUMERO DE CLIENTES POR MUNICIPIO

    DROP TABLE IF EXISTS TMPNUMCLIENTES;
    CREATE TEMPORARY TABLE TMPNUMCLIENTES
        SELECT cli.ClienteID,cli.SucursalOrigen,cli.Sexo,cli.TipoPersona,
        dir.MunicipioID, dir.EstadoID, dir.LocalidadID
        FROM CLIENTES cli
        LEFT OUTER JOIN DIRECCLIENTE dir
        ON cli.ClienteID = dir.ClienteID
        AND dir.Oficial = Con_DirOficial
        WHERE cli.FechaAlta <= Var_FechaFin
        AND cli.EsMenorEdad = Var_NO
        AND (cli.Estatus = Activa OR ( cli.Estatus = Inactiva AND cli.FechaBaja > Var_FechaFin))
        AND cli.ClienteID <> ClienteInstitucion;

    CREATE INDEX idx_numclientes_1 ON TMPNUMCLIENTES(SucursalOrigen);
    CREATE INDEX idx_numclientes_2 ON TMPNUMCLIENTES(ClienteID);
    CREATE INDEX idx_numclientes_3 ON TMPNUMCLIENTES(EstadoID,MunicipioID,Sexo);

    DROP TABLE IF EXISTS TMPCLIENTESMUN;
    CREATE TEMPORARY TABLE TMPCLIENTESMUN
        SELECT LocalidadID,   EstadoID,   MunicipioID,    Sexo,
         CASE WHEN Sexo = SexFemenino THEN InfNumMujeres ELSE InfNumHombres END AS Clave,
               COUNT(ClienteID) AS Total
    FROM TMPNUMCLIENTES
        WHERE TipoPersona IN(PersFisica,PersFisEmp)
        GROUP BY EstadoID,MunicipioID,LocalidadID,Sexo;


    INSERT INTO DATREGULATORIOB2422
        (   LocalidadID,    MunicipioID ,   SitiMunicipio ,EstadoID,TipoInformacion, Dato  )
    SELECT  LocalidadID,    MunicipioID,    Entero_Cero  , EstadoID, Clave,Total
    FROM TMPCLIENTESMUN;





    -- Actualizamos el numero de Clientes por sucursal - FISICAS

    DROP TABLE IF EXISTS TMPCLIENTESMUN;
    CREATE TEMPORARY TABLE TMPCLIENTESMUN
        SELECT LocalidadID,   EstadoID,   MunicipioID,    COUNT(ClienteID) AS Total
            FROM TMPNUMCLIENTES
            WHERE TipoPersona = PersMoral
            GROUP BY EstadoID,MunicipioID,LocalidadID;

    INSERT INTO DATREGULATORIOB2422
        (   LocalidadID,    MunicipioID ,   SitiMunicipio ,EstadoID,TipoInformacion, Dato  )
    SELECT  LocalidadID,    MunicipioID,    Entero_Cero  , EstadoID, InfNumMorales,Total
    FROM TMPCLIENTESMUN;

    -- Actualizamos el numero de Clientes por sucursal - MORALES


    -- Total de Clientes por Sucursal
    DROP TABLE IF EXISTS TMPCLIENTESMUNTOTAL;
    CREATE TEMPORARY TABLE TMPCLIENTESMUNTOTAL
        SELECT LocalidadID,     EstadoID,       MunicipioID,        SUM(Dato) AS Total
        FROM DATREGULATORIOB2422
        WHERE TipoInformacion IN (49,50,51)
        GROUP BY EstadoID,MunicipioID,LocalidadID;

    INSERT INTO DATREGULATORIOB2422
        (   LocalidadID,    MunicipioID ,   SitiMunicipio ,EstadoID,TipoInformacion, Dato  )
    SELECT  LocalidadID,    MunicipioID,    Entero_Cero  , EstadoID, InfNumTotSocios,Total
    FROM TMPCLIENTESMUNTOTAL;


    /*
   * ---------------------------------------------------------------------------------------------------------------
   * SECCION CONSULTAS ATM
   * ---------------------------------------------------------------------------------------------------------------
   */
    -- Filtramos los movimientos en ATM en el Trimestre

    DELETE FROM TMPSUCURSALESB2422;
    INSERT INTO TMPSUCURSALESB2422
        SELECT Suc.LocalidadID,     Suc.MunicipioID,    Suc.EstadoID,   COUNT(Tar.DetalleATMID) NoTrans
        FROM TARDEBCONCIATMDET Tar, CATCAJEROSATM Atm, SUCURSALES Suc
    WHERE Tar.TerminalID = Atm.NumCajeroPROSA
    AND Atm.SucursalID = Suc.SucursalID
    AND Tar.FechaTransac BETWEEN Var_FechaInicio AND Var_FechaFin
    AND Tar.Descripcion LIKE CONCAT('%',TipoRetiro,'%')
    GROUP BY Suc.EstadoID,Suc.MunicipioID,Suc.LocalidadID;

       -- Actualizamos el numero de Transaccion de ATM
    UPDATE DATREGULATORIOB2422 Reg,TMPSUCURSALESB2422 Tmp
        SET Reg.Dato = Tmp.Total
        WHERE Reg.EstadoID = Tmp.EstadoID
        AND Reg.MunicipioID = Tmp.MunicipioID
        AND Reg.LocalidadID = Tmp.LocalidadID
        AND Reg.TipoInformacion = InfTrancajeros;

     -- Cajeros con movimientos en el trimestre

    DROP TABLE IF EXISTS TMP_MOVATMGENERAL;
    CREATE TEMPORARY TABLE TMP_MOVATMGENERAL
    SELECT  MAX(Suc.LocalidadID) AS LocalidadID, MAX(Suc.MunicipioID) AS MunicipioID, MAX(Suc.EstadoID) AS EstadoID, Cat.TipoCajeroID,  COUNT(*) AS NumOperaciones,
          SUM(Tar.MontoTransac) AS ImporteOperaciones,    COUNT(DISTINCT(Tar.TerminalID)) AS NumCajeros
    FROM TARDEBCONCIATMDET Tar,CATCAJEROSATM Cat, SUCURSALES Suc
    WHERE Tar.TerminalID = Cat.NumCajeroPROSA
    AND   Cat.SucursalID = Suc.SucursalID
    AND   Tar.CodigoRespuesta = Respuesta_Exito
    AND   Tar.Descripcion LIKE CONCAT('%',TipoRetiro,'%')
    AND   DATE(Tar.FechaTransac) BETWEEN Var_FechaInicio AND Var_FechaFin
    GROUP BY Cat.EstadoID, Cat.LocalidadID, Cat.MunicipioID,Cat.TipoCajeroID,
             Suc.LocalidadID,   Suc.MunicipioID,    Suc.EstadoID;

    DROP TABLE IF EXISTS TMP_NUMATMLOC;
    CREATE TEMPORARY TABLE TMP_NUMATMLOC
    SELECT LocalidadID,   MunicipioID,    EstadoID,   SUM(NumCajeros) AS NumCajeros,
        SUM(ImporteOperaciones) AS ImporteOperaciones
    FROM TMP_MOVATMGENERAL
    GROUP BY EstadoID, MunicipioID, LocalidadID;


    -- Actualizamos el numero de Cajeros con almenos 1 transaccion (53)
    UPDATE DATREGULATORIOB2422 Reg,TMP_NUMATMLOC Tmp
        SET Reg.Dato = Tmp.NumCajeros
        WHERE Reg.EstadoID    = Tmp.EstadoID
        AND   Reg.MunicipioID = Tmp.MunicipioID
        AND   Reg.LocalidadID = Tmp.LocalidadID
        AND   Reg.TipoInformacion = Clave_NumAtm;

     -- Actualizamos el numero de Cajeros Solo Retiros con almenos 1 transaccion (54)
    UPDATE DATREGULATORIOB2422 Reg,TMP_MOVATMGENERAL Tmp
        SET   Reg.Dato        = Tmp.NumCajeros
        WHERE Reg.EstadoID    = Tmp.EstadoID
        AND   Reg.MunicipioID = Tmp.MunicipioID
        AND   Reg.LocalidadID = Tmp.LocalidadID
        AND   Reg.TipoInformacion = Clave_NumAtmRetiros
        AND   Tmp.TipoCajeroID= ATM_Dispensador;


       -- Actualizamos el numero de Cajeros Solo Depositos con almenos 1 transaccion (55)
    UPDATE DATREGULATORIOB2422 Reg,TMP_MOVATMGENERAL Tmp
        SET   Reg.Dato        = Tmp.NumCajeros
        WHERE Reg.EstadoID    = Tmp.EstadoID
        AND   Reg.MunicipioID = Tmp.MunicipioID
        AND   Reg.LocalidadID = Tmp.LocalidadID
        AND   Reg.TipoInformacion = Clave_NumAtmDepositos
        AND   Tmp.TipoCajeroID= ATM_Recolector;


       -- Actualizamos el numero de Cajeros Ambos con almenos 1 transaccion (56)
    UPDATE DATREGULATORIOB2422 Reg,TMP_MOVATMGENERAL Tmp
        SET   Reg.Dato        = Tmp.NumCajeros
        WHERE Reg.EstadoID    = Tmp.EstadoID
        AND   Reg.MunicipioID = Tmp.MunicipioID
        AND   Reg.LocalidadID = Tmp.LocalidadID
        AND   Reg.TipoInformacion = Clave_NumAtmAmbos
        AND   Tmp.TipoCajeroID= ATM_Ambos;



     -- Actualizamos el numero de Cajeros con almenos 1 transaccion (53)
    UPDATE DATREGULATORIOB2422 Reg,TMP_NUMATMLOC Tmp
        SET Reg.Dato = Tmp.ImporteOperaciones
        WHERE Reg.EstadoID    = Tmp.EstadoID
        AND   Reg.MunicipioID = Tmp.MunicipioID
        AND   Reg.LocalidadID = Tmp.LocalidadID
        AND   Reg.TipoInformacion = '57';




  /* --- Operaciones por Clientes internos y de otras Entidades  -- */
    DROP TABLE IF EXISTS TMP_MOVATM;

    CREATE TEMPORARY TABLE TMP_MOVATM
    SELECT Suc.LocalidadID,     Suc.EstadoID,     Suc.MunicipioID,  Tar.DetalleATMID,
        Tar.TerminalID,      Tar.TarjetaDebID, Tar.MontoTransac,
        CASE WHEN IFNULL(Deb.TarjetaDebID,Entero_Cero) = Entero_Cero THEN Tipo_Externo ELSE Tipo_Cliente END AS TipoCliente
    FROM CATCAJEROSATM Cat, SUCURSALES Suc,TARDEBCONCIATMDET Tar LEFT OUTER JOIN TARJETADEBITO Deb
    ON Tar.TarjetaDebID = Deb.TarjetaDebID
    WHERE Cat.NumCajeroPROSA = Tar.TerminalID
    AND Cat.SucursalID = Suc.SucursalID
    AND Tar.CodigoRespuesta = Respuesta_Exito
    AND DATE(Tar.FechaTransac) BETWEEN Var_FechaInicio AND Var_FechaFin
    AND Tar.Descripcion LIKE CONCAT('%',TipoRetiro,'%');

    CREATE INDEX idx_atm1 ON TMP_MOVATM(TarjetaDebID);
    CREATE INDEX idx_atm2 ON TMP_MOVATM(TipoCliente);

    DROP TABLE IF EXISTS TMP_OPERACIONESATMCLIENTES;

    CREATE TEMPORARY TABLE TMP_OPERACIONESATMCLIENTES
    SELECT LocalidadID,   EstadoID,   MunicipioID,    TipoCliente,    COUNT(*) AS NumOperaciones,
        SUM(MontoTransac) AS Importe
    FROM TMP_MOVATM
    GROUP BY EstadoID,MunicipioID,LocalidadID,TipoCliente;



    -- Actualizamos el numero de transacciones por clientes en cajeros (58)
    UPDATE DATREGULATORIOB2422 Reg,TMP_OPERACIONESATMCLIENTES Tmp
        SET Reg.Dato = Tmp.NumOperaciones
        WHERE Reg.EstadoID    = Tmp.EstadoID
        AND   Reg.MunicipioID = Tmp.MunicipioID
        AND   Reg.LocalidadID = Tmp.LocalidadID
        AND   Reg.TipoInformacion = '58'
        AND   Tmp.TipoCliente = Tipo_Cliente;


     -- Actualizamos el numero de transacciones por clientes en cajeros (58)
    UPDATE DATREGULATORIOB2422 Reg,TMP_OPERACIONESATMCLIENTES Tmp
        SET Reg.Dato = Tmp.Importe
        WHERE Reg.EstadoID    = Tmp.EstadoID
        AND   Reg.MunicipioID = Tmp.MunicipioID
        AND   Reg.LocalidadID = Tmp.LocalidadID
        AND   Reg.TipoInformacion = '59'
        AND   Tmp.TipoCliente = Tipo_Cliente;



    -- Actualizamos el numero de transacciones por no clientes nacionales en cajeros (58)
    UPDATE DATREGULATORIOB2422 Reg,TMP_OPERACIONESATMCLIENTES Tmp
        SET Reg.Dato = Tmp.NumOperaciones
        WHERE Reg.EstadoID    = Tmp.EstadoID
        AND   Reg.MunicipioID = Tmp.MunicipioID
        AND   Reg.LocalidadID = Tmp.LocalidadID
        AND   Reg.TipoInformacion = '60'
        AND   Tmp.TipoCliente = Tipo_Externo;


     -- Actualizamos el numero de transacciones por clientes en cajeros (58)
    UPDATE DATREGULATORIOB2422 Reg,TMP_OPERACIONESATMCLIENTES Tmp
        SET Reg.Dato = Tmp.Importe
        WHERE Reg.EstadoID    = Tmp.EstadoID
        AND   Reg.MunicipioID = Tmp.MunicipioID
        AND   Reg.LocalidadID = Tmp.LocalidadID
        AND   Reg.TipoInformacion = '61'
        AND   Tmp.TipoCliente = Tipo_Externo;




  /* -- Operaciones realizadas por Clientes en otras entidades */
    DROP TABLE IF EXISTS TMP_OTRASENTIDAES;

    CREATE TEMPORARY TABLE TMP_OTRASENTIDAES
    SELECT Entero_Cero AS LocalidadID,     Entero_Cero AS MunicipioID,     Entero_Cero AS EstadoID,
        COUNT(Tar.TarDebMovID) AS NumeroMovimientos,                        SUM(IFNULL(Tar.MontoOpe,Entero_Cero)) AS ImporteMovimientos
    FROM TARJETADEBITO Deb,TARDEBBITACORAMOVS Tar LEFT OUTER JOIN CATCAJEROSATM Cat
    ON Cat.NumCajeroPROSA = Tar.TerminalID
    WHERE Tar.TarjetaDebID = Deb.TarjetaDebID
    AND Tar.TipoOperacionID = Retiro_ATM
    AND Tar.Estatus = Est_Procesado
    AND Cat.NumCajeroPROSA IS NULL
    AND DATE(Tar.FechaHrOpe) BETWEEN Var_FechaInicio AND Var_FechaFin;

  -- Actualizamos el numero de Cajeros de otras entidades(56)
    UPDATE DATREGULATORIOB2422 Reg,TMP_OTRASENTIDAES Tmp
        SET   Reg.Dato        = Tmp.NumeroMovimientos
        WHERE Reg.EstadoID    = Tmp.EstadoID
        AND   Reg.MunicipioID = Tmp.MunicipioID
        AND   Reg.LocalidadID = Tmp.LocalidadID
        AND   Reg.TipoInformacion = '64';


  -- Actualizamos el importe de Cajerosde otras entidades (56)
    UPDATE DATREGULATORIOB2422 Reg,TMP_OTRASENTIDAES Tmp
        SET   Reg.Dato        = IFNULL(Tmp.ImporteMovimientos,Entero_Cero)
        WHERE Reg.EstadoID    = Tmp.EstadoID
        AND   Reg.MunicipioID = Tmp.MunicipioID
        AND   Reg.LocalidadID = Tmp.LocalidadID
        AND   Reg.TipoInformacion = '65';
    /*
   * ---------------------------------------------------------------------------------------------------------------
   * FIN SECCION CONSULTAS ATM
   * ---------------------------------------------------------------------------------------------------------------
   */


    /*  --- Numero de Acreditados y Ahorradores --- */

    DROP TABLE IF EXISTS TMP_ACREDITADOS;

    CREATE TEMPORARY TABLE TMP_ACREDITADOS
    SELECT Dir.LocalidadID,     Dir.MunicipioID,        Dir.EstadoID,       COUNT(Cre.ClienteID) as Acreditados
    FROM SALDOSCREDITOS Sal,CREDITOS Cre
        LEFT OUTER JOIN   DIRECCLIENTE Dir
        ON Cre.ClienteID = Dir.ClienteID
        AND Dir.Oficial = Con_DirOficial
    WHERE Sal.CreditoID = Cre.CreditoID
    AND Sal.FechaCorte  =  Var_FechaFin
    AND Sal.EstatusCredito IN  (Est_Vigente,Est_Vencido)
    GROUP BY Dir.EstadoID, Dir.MunicipioID, Dir.LocalidadID;


    SELECT MAX(Fecha) INTO Var_FechaAhorro
    FROM  `HIS-CUENTASAHO` WHERE Fecha <= Var_FechaFin;

    DROP TABLE IF EXISTS TMP_AHORRRADORES;

    CREATE TEMPORARY TABLE TMP_AHORRRADORES
    SELECT Dir.LocalidadID,     Dir.MunicipioID,        Dir.EstadoID,       COUNT(Dir.ClienteID) as Acreditados
    FROM `HIS-CUENTASAHO` His LEFT OUTER JOIN DIRECCLIENTE Dir
    ON His.ClienteID = Dir.ClienteID
    AND Dir.Oficial = Con_DirOficial
    WHERE His.Fecha =  Var_FechaAhorro
    AND   His.Estatus = Activa
    AND   His.ClienteID <>  Cliente_Inst
    GROUP BY Dir.EstadoID, Dir.MunicipioID, Dir.LocalidadID;


    INSERT INTO DATREGULATORIOB2422
        (   LocalidadID,    MunicipioID ,   SitiMunicipio ,EstadoID,TipoInformacion, Dato  )
    SELECT  LocalidadID,    MunicipioID,    Entero_Cero  , EstadoID, 30,Acreditados
    FROM TMP_ACREDITADOS;

    INSERT INTO DATREGULATORIOB2422
        (   LocalidadID,    MunicipioID ,   SitiMunicipio ,EstadoID,TipoInformacion, Dato  )
    SELECT  LocalidadID,    MunicipioID,    Entero_Cero  , EstadoID, 29,Acreditados
    FROM TMP_AHORRRADORES;


    -- Numero de Acreditados (30)

    -- Número de Sucursales cerradas temporalmente por contingencia sanitaria COVID 19
    INSERT INTO DATREGULATORIOB2422
        (   LocalidadID,    MunicipioID ,   SitiMunicipio ,EstadoID,TipoInformacion, Dato  )
    SELECT Suc.LocalidadID, Suc.MunicipioID, Entero_Cero, Suc.EstadoID, Clave_Contigencia, COUNT(Tmp.SucursalID) AS NumCajeros
    FROM TMPSUCURSALESCERRADAS Tmp, SUCURSALES Suc
    WHERE Tmp.SucursalID = Suc.SucursalID
      AND Tmp.FechaCierre <= Var_FechaFin
      AND Tmp.FechaApertura >= Var_FechaFin
    GROUP BY Suc.EstadoID,Suc.MunicipioID,Suc.LocalidadID;


    --
    -- FIN DE CONSULTAS - SELECTS DEL REPORTE EXCEL y CSV
    --

    ALTER TABLE DATREGULATORIOB2422 ADD COLUMN ClaveCNBV VARCHAR(20);

    UPDATE DATREGULATORIOB2422 Tem, LOCALIDADREPUB Loc SET
    Tem.ClaveCNBV = Loc.LocalidadCNBV
    WHERE Tem.EstadoID = Loc.EstadoID
    AND   Tem.MunicipioID = Loc.MunicipioID
    AND   Tem.LocalidadID = Loc.LocalidadID;

    IF Var_MostrarRegistros <> Mostrar_Todo THEN
        DELETE FROM DATREGULATORIOB2422
            WHERE Dato = Entero_Cero;
    END IF;

    IF(Par_TipoReporte = Rep_Excel) THEN
        SELECT Periodo,           Clave_Entidad AS ClaveEntidad,    Subreporte,               IFNULL(ClaveCNBV,Entero_Cero) AS Localidad,
         MunicipioID AS Municipio,  EstadoID AS Estado,          Clave_Mexico AS Pais,        TipoInformacion,   SUM(Dato) AS Dato
        FROM DATREGULATORIOB2422
        GROUP BY  EstadoID,MunicipioID,ClaveCNBV,TipoInformacion
        ORDER BY EstadoID,MunicipioID,ClaveCNBV,TipoInformacion;
    END IF;

    IF(Par_TipoReporte = Rep_CSV) THEN
        SELECT CONCAT(
            IFNULL(Subreporte,Cadena_Vacia),';',
            IFNULL(ClaveCNBV,Entero_Cero),';',
            IFNULL(MunicipioID,Entero_Cero),';',
            IFNULL(EstadoID,Entero_Cero),';',
            IFNULL(Clave_Mexico,Entero_Cero),';',
            IFNULL(TipoInformacion,Entero_Cero),';',
            IFNULL(SUM(Dato),Entero_Cero)) AS Valor
        FROM DATREGULATORIOB2422
        GROUP BY  EstadoID,MunicipioID,ClaveCNBV,TipoInformacion
        ORDER BY  EstadoID,MunicipioID,ClaveCNBV,TipoInformacion;

    END IF;

    DROP TABLE IF EXISTS TMPSUCURSALESB2422;
    DROP TABLE IF EXISTS DATREGULATORIOB2422;
    DROP TABLE IF EXISTS TMPTARJETASDEBITOSUC;
    DROP TABLE IF EXISTS TMPCAMBIOSUCUR;
    DROP TABLE IF EXISTS TMPNUMCLIENTES;
    DROP TABLE IF EXISTS TMPCLIENTESMUN;
    DROP TABLE IF EXISTS TMPCLIENTESMUNTOTAL;

END TerminaStore$$