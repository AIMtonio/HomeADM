-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGB242200006REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGB242200006REP`;DELIMITER $$

CREATE PROCEDURE `REGB242200006REP`(
# ------------------------------------------------------------------------------------------- #
# - SP QUE GENERA EL REPORTE EN EXCEL Y CSV PARA EL REGULATORIO B 2422 ---------------------- #
# ------------------------------------------------------------------------------------------- #
    Par_Anio                INT,            -- Ano del reporte
    Par_Trimestre           INT,            -- Trimestre a reportar
    Par_TipoReporte         INT,            -- Tipo de Reporte Excel(1) o CSV(2)
    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),

    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
    )
TerminaStore:BEGIN
    -- Variables
    DECLARE Var_FechaInicio         DATE;       -- Fecha de inicio del periodo
    DECLARE Var_FechaFin            DATE;       -- Fecha de fin del periodo
    DECLARE Var_MesInicio           INT;        -- Mes de inicio del periodo
    DECLARE Var_MesFin              INT;        -- Mes de Fin del Periodo
    DECLARE Var_TiposTarjeta        VARCHAR(20); -- Tipos de Tarjeta a contar en el reporte

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
    DECLARE Tipo_Socap              INT;
    DECLARE Cadena_Vacia			VARCHAR(2);

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
    SET Cadena_Vacia		:= '';

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
    SET Tipo_Socap			:= 6;		-- Tipo Regulatorio Socap

    SELECT ClaveEntidad INTO Clave_Entidad FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID;
    SELECT ValorParametro INTO Var_TiposTarjeta FROM PARAMREGSERIER24 WHERE LlaveParametro = ClaveTipoTarjeta;


    SET Var_MesFin              := Par_Trimestre * TresMeses;
    SET Var_MesInicio           := Var_MesFin - DosMeses;

    SET Var_FechaInicio         := CONCAT(Par_Anio,'-',CASE Var_MesInicio WHEN Var_MesInicio < 10  THEN CONCAT(Entero_Cero,Var_MesInicio) ELSE Var_MesInicio END,'-01');
    SET Var_FechaFin            := CONCAT(Par_Anio,'-',CASE Var_MesFin    WHEN Var_MesFin    < 10  THEN CONCAT(Entero_Cero,Var_MesFin)    ELSE Var_MesFin    END,'-01');

    SET Periodo                 := DATE_FORMAT(Var_FechaFin,'%Y%m');
    -- Obtenemos el ultimo dia del mes para la fecha Final
    SET Var_FechaFin            := LAST_DAY(Var_FechaFin);


    # ------------------------------------------- #
    # TABLA PARA OBTENER EL NUMERO DE SUCURSALES  #
    # Y ATM POR MUNICIPIO SITI ------------------ #
    DROP TABLE IF EXISTS TMPSUCURSALESB2422;
    CREATE TEMPORARY TABLE  TMPSUCURSALESB2422(
        MunicipioID                 INT,
        CP                          VARCHAR(5),
        EstadoID                    INT,
        Total                       INT,
    PRIMARY KEY (EstadoID,CP)
    );

    DROP TABLE IF EXISTS DATREGULATORIOB2422;
    CREATE TEMPORARY TABLE  DATREGULATORIOB2422(
        MunicipioID                 INT,
        SitiMunicipio               VARCHAR(5),
        EstadoID                    INT,
        TipoInformacion             INT,
        Dato                        INT,
    PRIMARY KEY (SitiMunicipio,EstadoID,TipoInformacion)
    );


    -- Insertamos el numero de sucursales por municipio SITI
    INSERT INTO TMPSUCURSALESB2422
    SELECT Suc.MunicipioID,     MIN(Suc.CP) AS CP,      Suc.EstadoID,       COUNT(Suc.SucursalID) AS NumSucursales FROM
            SUCURSALES Suc      WHERE Suc.Estatus = Activa AND TipoSucursal = TipoAtencion
                                AND  FechaAlta <= Var_FechaFin GROUP BY Suc.EstadoID,Suc.CP;


    -- Insertamos los registros de la tabla
    INSERT INTO DATREGULATORIOB2422
    SELECT  Tmp.MunicipioID,Tmp.CP,Tmp.EstadoID,Tip.TipoInforID,
        CASE Tip.TipoInforID
            WHEN InfSucursales THEN  Tmp.Total
            ELSE Entero_Cero
        END
        FROM TMPSUCURSALESB2422 AS Tmp ,TIPOINFORMACION Tip
        WHERE Tip.TipoInstitID = Tipo_Socap;


    -- Insertamos el numero de ATM por municipio SITI
    DELETE FROM TMPSUCURSALESB2422;
    INSERT INTO TMPSUCURSALESB2422
        SELECT Suc.MunicipioID,MIN(Suc.CP),Suc.EstadoID,COUNT(Atm.CajeroID) AS NumCajeros
            FROM CATCAJEROSATM Atm, SUCURSALES Suc WHERE Atm.SucursalID = Suc.SucursalID
            AND Atm.Estatus = Activa GROUP BY Suc.EstadoID,Suc.CP;

    -- Actualizamos el numero de ATMS en la tabla
    UPDATE DATREGULATORIOB2422 Reg,TMPSUCURSALESB2422 Tmp
        SET Reg.Dato = Tmp.Total WHERE Reg.EstadoID = Tmp.EstadoID
        AND Reg.MunicipioID = Tmp.MunicipioID
        AND Reg.TipoInformacion = InfCajeros;


     -- Insertamos el numero de Tipo de ATM por municipio SITI
    DROP TABLE IF EXISTS TMPTIPOCAJEROATM;
    CREATE TEMPORARY TABLE TMPTIPOCAJEROATM
        SELECT Suc.MunicipioID, Suc.EstadoID,   cat.ClaveD2442 AS TipoCajero,   COUNT(Atm.CajeroID) AS NumCajeros FROM CATCAJEROSATM Atm,
            SUCURSALES Suc, CATTIPOCAJERO cat WHERE Atm.SucursalID = Suc.SucursalID
            AND Atm.TipoCajeroID = cat.TipoCajeroID
            AND Atm.Estatus = Activa GROUP BY Suc.EstadoID,Suc.CP,cat.ClaveD2442;

    -- Actualizamos el numero de ATMS en la tabla
    UPDATE DATREGULATORIOB2422 Reg,TMPTIPOCAJEROATM Tmp
        SET Reg.Dato = Tmp.NumCajeros WHERE Reg.EstadoID = Tmp.EstadoID
        AND Reg.MunicipioID = Tmp.MunicipioID
        AND Reg.TipoInformacion = Tmp.TipoCajero;


    -- NUMERO DE TARJETAS POR SUCURSAL
    DROP TABLE IF EXISTS TMPTARJETASDEBITOSUC;
    CREATE TABLE TMPTARJETASDEBITOSUC
        SELECT  tar.TarjetaDebID,   tar.FechaActivacion,    tar.Estatus,    tar.ClienteID,
                cli.SucursalOrigen, cli.NombreCompleto,     suc.CP,         suc.MunicipioID, suc.EstadoID
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
    CREATE INDEX idx_tmptarjetas_2 ON TMPTARJETASDEBITOSUC(CP);
    CREATE INDEX idx_tmptarjetas_3 ON TMPTARJETASDEBITOSUC(ClienteID);


    DROP TABLE IF EXISTS TMPCAMBIOSUCUR;
    CREATE TABLE TMPCAMBIOSUCUR
        SELECT ClienteID, MIN(Fecha) AS Fecha,Entero_Cero AS SucursalOrigen FROM HISCAMBIOSUCURCLI
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
        tmp.CP =  suc.CP,
        tmp.MunicipioID = suc.MunicipioID,
        tmp.EstadoID    = suc.EstadoID
        WHERE tmp.ClienteID = cam.ClienteID
        AND cam.SucursalOrigen = suc.SucursalID;


    DELETE FROM TMPSUCURSALESB2422;
    INSERT INTO TMPSUCURSALESB2422
        SELECT MunicipioID,MIN(CP),EstadoID,COUNT(TarjetaDebID) AS Total FROM
        TMPTARJETASDEBITOSUC GROUP  BY EstadoID, MunicipioID;


    UPDATE DATREGULATORIOB2422 reg,TMPSUCURSALESB2422 tar
        SET reg.Dato = tar.Total WHERE reg.EstadoID = tar.EstadoID
        AND reg.MunicipioID = tar.MunicipioID
        AND reg.TipoInformacion = InfNumTarDeb;



    -- Insertamos el numero de Empleados por Sucursal
    DELETE FROM TMPSUCURSALESB2422;
    INSERT INTO TMPSUCURSALESB2422
        SELECT Suc.MunicipioID,MIN(Suc.CP),Suc.EstadoID, COUNT(Emp.EmpleadoID) AS Total FROM EMPLEADOS AS Emp,
            SUCURSALES AS Suc WHERE Emp.SucursalID = Suc.SucursalID
            AND Suc.Estatus = Activa AND Suc.TipoSucursal = TipoAtencion
            AND (Emp.Estatus = Activa OR (Emp.Estatus = Inactiva AND DATE(Emp.FechaActual) > Var_FechaFin))
            AND Emp.FechaAlta <= Var_FechaFin
            GROUP BY Suc.EstadoID,Suc.CP ;

    -- Actualizamos el numero de Empleados por Sucursal
    UPDATE DATREGULATORIOB2422 Reg,TMPSUCURSALESB2422 Tmp
        SET Reg.Dato = Tmp.Total WHERE Reg.EstadoID = Tmp.EstadoID
        AND Reg.MunicipioID = Tmp.MunicipioID
        AND Reg.TipoInformacion = InfNumPersonal;

    -- NUMERO DE CLIENTES POR MUNICIPIO

    DROP TABLE IF EXISTS TMPNUMCLIENTES;
    CREATE TEMPORARY TABLE TMPNUMCLIENTES
        SELECT cli.ClienteID,cli.SucursalOrigen,cli.Sexo,cli.TipoPersona,suc.CP,suc.MunicipioID, suc.EstadoID
            FROM CLIENTES cli, SUCURSALES suc
            WHERE cli.SucursalOrigen = suc.SucursalID AND  cli.FechaAlta <= Var_FechaFin
            AND cli.EsMenorEdad = Var_NO
            AND (cli.Estatus = Activa OR ( cli.Estatus = Inactiva AND cli.FechaBaja > Var_FechaFin))
            AND cli.ClienteID <> ClienteInstitucion;

    CREATE INDEX idx_numclientes_1 ON TMPNUMCLIENTES(SucursalOrigen);
    CREATE INDEX idx_numclientes_2 ON TMPNUMCLIENTES(ClienteID);
    CREATE INDEX idx_numclientes_3 ON TMPNUMCLIENTES(EstadoID,MunicipioID,Sexo);

     UPDATE TMPNUMCLIENTES tmp, TMPCAMBIOSUCUR cam, SUCURSALES suc SET
        tmp.SucursalOrigen = cam.SucursalOrigen,
        tmp.CP =  suc.CP,
        tmp.MunicipioID = suc.MunicipioID,
        tmp.EstadoID    = suc.EstadoID
        WHERE tmp.ClienteID = cam.ClienteID
        AND cam.SucursalOrigen = suc.SucursalID;

    DROP TABLE IF EXISTS TMPCLIENTESMUN;
    CREATE TEMPORARY TABLE TMPCLIENTESMUN
        SELECT EstadoID,MunicipioID,Sexo,CASE WHEN Sexo = SexFemenino THEN InfNumMujeres ELSE InfNumHombres END AS Clave, COUNT(ClienteID) AS Total
            FROM TMPNUMCLIENTES WHERE TipoPersona IN(PersFisica,PersFisEmp) GROUP BY EstadoID,MunicipioID,Sexo;


    -- Actualizamos el numero de Clientes por sucursal - FISICAS
    UPDATE DATREGULATORIOB2422 Reg,TMPCLIENTESMUN Tmp
        SET Reg.Dato = Tmp.Total WHERE Reg.EstadoID = Tmp.EstadoID
        AND Reg.MunicipioID = Tmp.MunicipioID
        AND Reg.TipoInformacion = Tmp.Clave;


    DROP TABLE IF EXISTS TMPCLIENTESMUN;
    CREATE TEMPORARY TABLE TMPCLIENTESMUN
        SELECT EstadoID,MunicipioID,COUNT(ClienteID) AS Total
            FROM TMPNUMCLIENTES WHERE TipoPersona = PersMoral GROUP BY EstadoID,MunicipioID;

    -- Actualizamos el numero de Clientes por sucursal - MORALES
    UPDATE DATREGULATORIOB2422 Reg,TMPCLIENTESMUN Tmp
        SET Reg.Dato = Tmp.Total WHERE Reg.EstadoID = Tmp.EstadoID
        AND Reg.MunicipioID = Tmp.MunicipioID
        AND Reg.TipoInformacion = InfNumMorales;


    -- Total de Clientes por Sucursal
    DROP TABLE IF EXISTS TMPCLIENTESMUNTOTAL;
    CREATE TEMPORARY TABLE TMPCLIENTESMUNTOTAL
        SELECT EstadoID,MunicipioID,COUNT(ClienteID) AS Total
        FROM TMPNUMCLIENTES GROUP BY EstadoID,MunicipioID;

    UPDATE DATREGULATORIOB2422 Reg,TMPCLIENTESMUNTOTAL Tmp
        SET Reg.Dato = Tmp.Total WHERE Reg.EstadoID = Tmp.EstadoID
        AND Reg.MunicipioID = Tmp.MunicipioID
        AND Reg.TipoInformacion = InfNumTotSocios;



    /*
   * ---------------------------------------------------------------------------------------------------------------
   * SECCION CONSULTAS ATM
   * ---------------------------------------------------------------------------------------------------------------
   */
    -- Filtramos los movimientos en ATM en el Trimestre

    DELETE FROM TMPSUCURSALESB2422;
    INSERT INTO TMPSUCURSALESB2422
        SELECT  Suc.MunicipioID,MIN(Suc.CP),Suc.EstadoID,COUNT(Tar.DetalleATMID) NoTrans FROM TARDEBCONCIATMDET Tar, CATCAJEROSATM Atm, SUCURSALES Suc
            WHERE Tar.TerminalID = Atm.NumCajeroPROSA
            AND Atm.SucursalID = Suc.SucursalID
            AND Tar.FechaTransac BETWEEN Var_FechaInicio AND Var_FechaFin
            AND Tar.Descripcion LIKE CONCAT('%',TipoRetiro,'%')
            GROUP BY Suc.EstadoID,Suc.CP;

       -- Actualizamos el numero de Transaccion de ATM
    UPDATE DATREGULATORIOB2422 Reg,TMPSUCURSALESB2422 Tmp
        SET Reg.Dato = Tmp.Total WHERE Reg.EstadoID = Tmp.EstadoID
        AND Reg.MunicipioID = Tmp.MunicipioID
        AND Reg.TipoInformacion = InfTrancajeros;


    /*
   * ---------------------------------------------------------------------------------------------------------------
   * FIN SECCION CONSULTAS ATM
   * ---------------------------------------------------------------------------------------------------------------
   */


    --
    -- FIN DE CONSULTAS - SELECTS DEL REPORTE EXCEL y CSV
    --

    IF(Par_TipoReporte = Rep_Excel) THEN
        SELECT Periodo,Clave_Entidad AS ClaveEntidad,Subreporte,SitiMunicipio AS Municipio,EstadoID AS Estado,TipoInformacion, Dato
        FROM DATREGULATORIOB2422 ORDER BY SitiMunicipio;
    END IF;

    IF(Par_TipoReporte = Rep_CSV) THEN
        SELECT CONCAT(
            IFNULL(Subreporte,Cadena_Vacia),';',
            IFNULL(SitiMunicipio,Cadena_Vacia),';',
            IFNULL(EstadoID,Cadena_Vacia),';',
            IFNULL(TipoInformacion,Cadena_Vacia),';',
            IFNULL(Dato,Entero_Cero)) AS Valor
        FROM DATREGULATORIOB2422 ORDER BY SitiMunicipio;

    END IF;

    DROP TABLE IF EXISTS TMPSUCURSALESB2422;
    DROP TABLE IF EXISTS DATREGULATORIOB2422;
    DROP TABLE IF EXISTS TMPTARJETASDEBITOSUC;
    DROP TABLE IF EXISTS TMPCAMBIOSUCUR;
    DROP TABLE IF EXISTS TMPNUMCLIENTES;
    DROP TABLE IF EXISTS TMPCLIENTESMUN;
    DROP TABLE IF EXISTS TMPCLIENTESMUNTOTAL;

END TerminaStore$$