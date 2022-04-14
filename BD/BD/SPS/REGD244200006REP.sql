-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGD244200006REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGD244200006REP`;DELIMITER $$

CREATE PROCEDURE `REGD244200006REP`(
# ------------------------------------------------------------------------------------------- #
# - SP QUE GENERA EL REPORTE EN EXCEL Y CSV PARA EL REGULATORIO D 2442 ---------------------- #
# ------------------------------------------------------------------------------------------- #
    Par_Anio                INT,            -- Año del reporte
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
    DECLARE Var_FechaInicio     DATE;
    DECLARE Var_FechaFin        DATE;
    DECLARE Var_MesInicio       INT;
    DECLARE Var_MesFin          INT;
    DECLARE Var_FechaInicioUno  DATE;

    DECLARE Var_FechaInicioDos  DATE;
    DECLARE Var_FechaInicioTres DATE;
    DECLARE Var_FechaFinUno     DATE;
    DECLARE Var_FechaFinDos     DATE;
    DECLARE Var_FechaFinTres    DATE;

    DECLARE Var_TipoCueAho      VARCHAR(150);
    DECLARE Var_TipoCueVis      VARCHAR(150);
    DECLARE Var_CanalSucursal   INT;
    DECLARE Var_CanalATM        INT;
    DECLARE Var_CanalTPV        INT;
    DECLARE Var_MoviDepositos   VARCHAR(150);            -- Tipos de Movimientos correspondientes a Despositos

    DECLARE Var_MoviRetiros         VARCHAR(150);        -- Tipos de Movimientos correspondientes a Retiros
    DECLARE Var_InverRetiro         VARCHAR(150);        -- Inversiones --- Retiros
    DECLARE Var_InverDeposito       VARCHAR(150);        -- Inversiones --- Depositos
    DECLARE Var_TotalMovimientos    TEXT;       -- Total de movimientos a filtrar

    DECLARE Var_MostrarRegistros CHAR(1); -- Mostrar todos los registros
    DECLARE Var_CamSucOtros		 CHAR(1); -- Cambiar de canal a otros


    -- Constantes
    DECLARE Entero_Cero     INT;
    DECLARE Entero_Uno      INT;
    DECLARE Decimal_Cero    DECIMAL(2,1);
    DECLARE Rep_Excel       INT;
    DECLARE Rep_CSV         INT;

    DECLARE TipoAtencion    CHAR;
    DECLARE Activa          CHAR;
    DECLARE Tipo_Cajero     CHAR;
    DECLARE Tipo_Sucursal   CHAR;
    DECLARE Masculino       CHAR;

    DECLARE Femenino        CHAR;
    DECLARE TresMeses       INT;
    DECLARE DosMeses        INT;
    DECLARE Var_NO          CHAR;
    DECLARE Inactiva        CHAR;

    DECLARE PersonaFisica   CHAR;
    DECLARE PersonaFisEmp   CHAR;
    DECLARE Periodo         VARCHAR(6);
    DECLARE Clave_Entidad   VARCHAR(6);
    DECLARE Subreporte      VARCHAR(4);

    DECLARE UnaOperacion    INT;
    DECLARE DosCincoOper    INT;
    DECLARE SeisDiesOper    INT;
    DECLARE MasDeDiezOper   INT;
    DECLARE DepositoVista   INT;

    DECLARE DepositoAhorro  INT;
    DECLARE DepositoPlazo   INT;
    DECLARE OperDeposito    INT;
    DECLARE OperRetiro      INT;
    DECLARE DiaPrimero      VARCHAR(5);

    DECLARE DiezMeses       INT;
    DECLARE FrecUnoMin      INT;
    DECLARE FrecDosMin      INT;
    DECLARE FrecDosMax      INT;
    DECLARE FrecTresMin     INT;

    DECLARE FrecTresMax     INT;
    DECLARE FrecCuaMin      INT;
    DECLARE FrecCuaMax      INT;

    DECLARE LlaveCueDepositos   VARCHAR(20);
    DECLARE LlaveCueRetiros     VARCHAR(20);
    DECLARE LlaveInvDepositos   VARCHAR(20);

    DECLARE LlaveInvRetiros     VARCHAR(20);
    DECLARE TipoOrdinario       VARCHAR(30);
    DECLARE TipoVista           VARCHAR(30);
    DECLARE Est_Procesado       CHAR(1);
    DECLARE TipoLocal           VARCHAR(10);

    DECLARE Est_Conciliado      CHAR(1);
    DECLARE TipoRetiro          VARCHAR(15);
    DECLARE ProcesoCierre		VARCHAR(30);
    DECLARE Tipo_Socap			INT;
    DECLARE Tipo_CtaInst		INT;
    DECLARE Tipo_Ahorro			CHAR(1);

    DECLARE Mostrar_Todo		CHAR(1);
    DECLARE Var_SI				CHAR(1);
    DECLARE Canal_Otros			INT;


    -- Inicialización de constantes
    SET Entero_Cero         := 0;
    SET Entero_Uno          := 1;
    SET Decimal_Cero        := 0.0;
    SET Rep_Excel           := 1;       -- Tipo de Reporte en Excel
    SET Rep_CSV             := 2;       -- Tipo de reporte en CSV

    SET TipoAtencion        := 'A';     -- Sucursal de Atencion
    SET Activa              := 'A';     -- Tipo Estatus Activa
    SET Tipo_Cajero         := 'C';     -- Tipo Cajero
    SET Tipo_Sucursal       := 'S';     -- Tipo Sucursal
    SET Masculino           := 'M';     -- Sexo Masculino

    SET Femenino            := 'F';     -- Sexo Femenino
    SET TresMeses           := 3;
    SET DosMeses            := 2;
    SET Var_NO              := 'N';     -- Respuesta NO
    SET Inactiva            := 'I';     -- Tipo Estatus Inactiva

    SET PersonaFisica       := 'F';     -- Persona Fisica
    SET PersonaFisEmp       := 'A';     -- Persona Fisica con Actividad Empresarial
    SET Subreporte          := '2442';  -- Numero del reporte regulatorio
    SET DiaPrimero          := '-01';
    SET DiezMeses           := 10;

    SET LlaveCueDepositos   :=  'MoviDepositos';    -- Llave de parametro para movimientos de deposito
    SET LlaveCueRetiros     :=  'MoviRetiros' ;     -- Llave de parametro para movimientos de retiro
    SET LlaveInvDepositos   :=  'InverDeposito' ;   -- Llave de Parametro para movimientos de deposito de inversion
    SET LlaveInvRetiros     :=  'InverRetiro' ;     -- Llave de parametro para movimientos de retiro de inversion
    SET TipoOrdinario       := 	'AhorroOrdinario';				-- Tipo de Cuenta Ordinaria

    SET TipoVista           := 	'AhorroVista';				-- Tipo de Cuenta a la vista
    SET Est_Procesado       := 'P';                 -- Estauts de Transaccion Procesada
    SET TipoLocal           := 'WORKBENCH';     -- Transacciones locales
    SET Est_Conciliado      :=  'C';                -- Estatus de transaccion conciliada

    SET Var_CanalSucursal   := 206;     -- Canal de reporte Sucursal
    SET Var_CanalATM        := 207;     -- Canal de reporte Cajero ATM
    SET Var_CanalTPV        := 212;     -- Canal de reporte Terminal de Punto de Venta
    SET DepositoVista       := 33;      -- Cuenta Depósitos a la vista, expediente completo
    SET DepositoAhorro      := 35;      -- Cuenta Depósitos de ahorro, expediente completo

    SET DepositoPlazo       := 37;      -- Cuenta Depósitos a plazo, expediente completo
    SET OperDeposito        := 302;     -- Tipo de Operacion : Deposito
    SET OperRetiro          := 301;     -- Tipo de Operacion : Retiro
    SET DepositoVista       := 33;      -- Cuenta Depósitos a la vista, expediente completo
    SET DepositoAhorro      := 35;      -- Cuenta Depósitos de ahorro, expediente completo

    SET DepositoPlazo       := 37;      -- Cuenta Depósitos a plazo, expediente completo
    SET UnaOperacion        :=461;      -- Frecuencia 1 operacion
    SET DosCincoOper        :=462;      -- Frecuencia 2 - 5 operaciones
    SET SeisDiesOper        :=463;      -- Frecuencia 6 - 10 Operaciones
    SET MasDeDiezOper       :=464;      -- Frecuencia > 10 Operaciones

    SET FrecUnoMin          := 1;       -- Frecuencia 1
    SET FrecDosMin          := 2;       -- Frecuencia 2
    SET FrecDosMax          := 5;       -- Frecuencia 5
    SET FrecTresMin         := 6;       -- Frecuencia 6
    SET FrecTresMax         := 10;      -- Frecuencia 10

    SET FrecCuaMin          := 11;      -- Frecuencia 11
    SET TipoRetiro          := 'RETIRO'; -- Tipo de Transaccion ATM - Retiro de efectivo
    SET ProcesoCierre		:= 'CIERREGENERALPRO';
    SET Tipo_Socap          := 6;
    SET Tipo_Ahorro			:= 'A';

    SET Mostrar_Todo		:= 'T'; 	-- Mostrar todos los registros
    SET Var_SI				:= 'S';		-- Valor SI
    SET Canal_Otros			:= 213;		-- Canal de transaccion Otros


    SELECT ValorParametro INTO  Var_MoviDepositos FROM PARAMREGSERIER24 WHERE LlaveParametro = LlaveCueDepositos;
    SELECT ValorParametro INTO  Var_MoviRetiros   FROM PARAMREGSERIER24 WHERE LlaveParametro = LlaveCueRetiros;
    SELECT ValorParametro INTO  Var_InverRetiro   FROM PARAMREGSERIER24 WHERE LlaveParametro = LlaveInvRetiros;
    SELECT ValorParametro INTO  Var_InverDeposito   FROM PARAMREGSERIER24 WHERE LlaveParametro = LlaveInvDepositos;

    SET Var_TotalMovimientos   := CONCAT(Var_MoviDepositos,',',Var_MoviRetiros,',',Var_InverRetiro,',',Var_InverDeposito);



    /* -- Se calculan las fechas de los 3 meses del Trimestre -- */
    SET Var_MesFin              := Par_Trimestre * TresMeses;
    SET Var_MesInicio           := Var_MesFin - DosMeses;

    SET Var_FechaInicio         := CONCAT(Par_Anio,'-',CASE Var_MesInicio WHEN Var_MesInicio < DiezMeses  THEN CONCAT(Entero_Cero,Var_MesInicio) ELSE Var_MesInicio END,DiaPrimero);
    SET Var_FechaFin            := CONCAT(Par_Anio,'-',CASE Var_MesFin    WHEN Var_MesFin    < DiezMeses  THEN CONCAT(Entero_Cero,Var_MesFin)    ELSE Var_MesFin    END,DiaPrimero);

    SET Periodo             := DATE_FORMAT(Var_FechaFin,'%Y%m');
    -- Obtenemos el último día del mes para la fecha Final
    SET Var_FechaFin            := LAST_DAY(Var_FechaFin);

    SELECT ClaveEntidad,TipoCuenta INTO Clave_Entidad,Tipo_CtaInst FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID;


    -- Tabla principal para el reporte
    DROP TABLE IF EXISTS DATREGULATORIOD2442;
        CREATE TEMPORARY TABLE  DATREGULATORIOD2442(
        TipoCuenta                  INT,
        CanalTransaccion            INT,
        TipoOperacion               INT,
        Frecuencia                  INT,
        NumeroCuentas               INT,
        PRIMARY KEY (TipoCuenta,CanalTransaccion,TipoOperacion,Frecuencia)
    );

    -- Se crea una tabla para vaciar los depositos y retiros por mes.
    DROP TABLE IF EXISTS TMPREPCUENTASMOVS;
    CREATE TABLE IF NOT EXISTS TMPREPCUENTASMOVS (
        CuentaAhoID         VARCHAR(20),
        CantidadMov         DECIMAL(14,2),
        NumMov              INT(11),
        TipoMovimiento      VARCHAR(10),
        TipoCuenta          VARCHAR(10),
        ClienteID           VARCHAR(10),
        Mes					INT,
        PRIMARY KEY(Mes,CuentaAhoID,tipoMovimiento,tipoCuenta)
    );


        -- Creamos tabla temporal para agrupar los resultados.
    DROP TABLE IF EXISTS MONTOSSUCURSALD2442;
    CREATE TEMPORARY TABLE MONTOSSUCURSALD2442(
        TipoCuenta          VARCHAR(10),
        TipoMovimiento      VARCHAR(10),
        Cantidad            DECIMAL(16,2),
        Frecuencia          VARCHAR(10),
        NumMov              INT,
        NumCuentas          INT,
        PRIMARY KEY(TipoCuenta,TipoMovimiento,Frecuencia)
    );

    /* Tabla para filtrar la frecuencia de movimientos por cuenta en ATM */
    DROP TABLE IF EXISTS FRECUENCIAATMD2442;
    CREATE TABLE FRECUENCIAATMD2442(
        NumeroCuenta    VARCHAR(50),
        Frecuencia      INT,
        Mes				INT,
        PRIMARY KEY (Mes, NumeroCuenta)
    );

    # -- Tabla para filtrar los datos de HIS-CUENAHOMOV -- #
    DROP TABLE IF EXISTS TMPCUENAHOMOVD2442;
    CREATE TEMPORARY TABLE  TMPCUENAHOMOVD2442(
        NumeroMov           BIGINT,
        CuentaAhoID         BIGINT(12),
        CantidadMovimiento  DECIMAL(16,2),
        TipoMovAhoID        CHAR(4),
        Mes					INT,
        PRIMARY KEY (NumeroMov,CuentaAhoID)
    );



    -- Insertamos la estructura de la tabla
    INSERT INTO DATREGULATORIOD2442
        SELECT Tip.CuentaTransID,Can.CanalID,Tio.TipoOperacionID,Fre.FrecuenciaID,Entero_Cero
        FROM CATTIPOCUENTATRANS Tip,CATCANALES Can,
        CATTIPOOPERACION Tio,CATFRECUENCIA Fre
        WHERE Tip.TipoInstitID = Tipo_Socap;


    /*
   * ---------------------------------------------------------------------------------------------------------------
   * SECCION CONSULTAS DEPOSITO Y RETIRO DE CUENTAS DE AHORRO E INVERSIONES
   * ---------------------------------------------------------------------------------------------------------------
   */
    -- Filtramos los movimientos en HIS-CUENAHOMOV
    INSERT INTO TMPCUENAHOMOVD2442
    SELECT Cue.NumeroMov,Cue.CuentaAhoID,SUM(Cue.CantidadMov) AS CantidadMovimiento,MIN(Cue.TipoMovAhoID),MONTH(MIN(Cue.Fecha)) FROM
        `HIS-CUENAHOMOV` Cue
          WHERE FIND_IN_SET(Cue.TipoMovAhoID ,Var_TotalMovimientos) > Entero_Cero
        AND Cue.Fecha BETWEEN Var_FechaInicio AND Var_FechaFin
        GROUP BY Cue.NumeroMov,Cue.CuentaAhoID
        ORDER BY Cue.NumeroMov;



        -- Insertar Depositos
       INSERT INTO TMPREPCUENTASMOVS(CuentaAhoID,CantidadMov,NumMov,TipoMovimiento,TipoCuenta,ClienteID,Mes)
        SELECT reg.CuentaAhoID,SUM(reg.CantidadMovimiento)CantidadMov,COUNT(*) AS NumMov,OperDeposito AS TipoMovimiento,
            CASE WHEN ti.ClasificacionConta = Tipo_Ahorro  THEN DepositoAhorro ELSE DepositoVista END,cu.ClienteID, reg.Mes
        FROM TMPCUENAHOMOVD2442 AS reg
        INNER JOIN CUENTASAHO cu ON reg.CuentaAhoID=cu.CuentaAhoID
        INNER JOIN TIPOSCUENTAS ti ON cu.TipoCuentaID = ti.TipoCuentaID
        AND FIND_IN_SET(reg.TipoMovAhoID,Var_MoviDepositos) > Entero_Cero
        WHERE ti.TipoCuentaID <> Tipo_CtaInst
        GROUP BY reg.Mes, reg.CuentaAhoID, ti.ClasificacionConta, cu.ClienteID
        ORDER BY reg.CuentaAhoID;



        -- Insertar retiros
        INSERT INTO TMPREPCUENTASMOVS(CuentaAhoID,CantidadMov,NumMov,TipoMovimiento,TipoCuenta,ClienteID,Mes)
        SELECT reg.CuentaAhoID,SUM(reg.CantidadMovimiento)CantidadMov,COUNT(*) AS NumMov,OperRetiro AS TipoMovimiento,
            CASE  WHEN ti.ClasificacionConta = Tipo_Ahorro THEN DepositoAhorro ELSE DepositoVista END,cu.ClienteID, reg.Mes
        FROM TMPCUENAHOMOVD2442 AS reg
        INNER JOIN CUENTASAHO cu ON reg.CuentaAhoID=cu.CuentaAhoID
        INNER JOIN TIPOSCUENTAS ti ON cu.TipoCuentaID = ti.TipoCuentaID
        AND FIND_IN_SET(reg.TipoMovAhoID,Var_MoviRetiros) > Entero_Cero
        WHERE  ti.TipoCuentaID <> Tipo_CtaInst
        GROUP BY reg.Mes ,reg.CuentaAhoID, ti.ClasificacionConta, cu.ClienteID
        ORDER BY reg.CuentaAhoID;


        -- Insertar Inversiones
        INSERT INTO TMPREPCUENTASMOVS(CuentaAhoID,CantidadMov,NumMov,TipoMovimiento,TipoCuenta,ClienteID,Mes)
        SELECT reg.CuentaAhoID,SUM(reg.CantidadMovimiento)CantidadMov,COUNT(*) AS NumMov,
            CASE WHEN FIND_IN_SET(reg.TipoMovAhoID,Var_InverDeposito)  > Entero_Cero THEN OperDeposito
            WHEN FIND_IN_SET(reg.TipoMovAhoID,Var_InverRetiro)  > Entero_Cero THEN OperRetiro END AS TipoMovimiento,DepositoPlazo,cu.ClienteID, reg.Mes
            FROM TMPCUENAHOMOVD2442 AS reg
            INNER JOIN CUENTASAHO cu ON reg.CuentaAhoID=cu.CuentaAhoID
             INNER JOIN TIPOSCUENTAS ti ON cu.TipoCuentaID = ti.TipoCuentaID
            AND FIND_IN_SET(reg.TipoMovAhoID,CONCAT(Var_InverRetiro,',',Var_InverDeposito)) > Entero_Cero
            WHERE  ti.TipoCuentaID <> Tipo_CtaInst
            GROUP BY reg.Mes, reg.CuentaAhoID, reg.TipoMovAhoID, cu.ClienteID
            ORDER BY reg.CuentaAhoID;


    -- Insertamos los rsultados por tipo de cuenta
    INSERT INTO MONTOSSUCURSALD2442
        (SELECT TipoCuenta,TipoMovimiento,SUM(cantidadMov)AS cantidad,UnaOperacion AS Frecuencia, SUM(NumMov) AS NumMov,COUNT(DISTINCT(CuentaAhoID))
        FROM `TMPREPCUENTASMOVS`
        WHERE NumMov=FrecUnoMin
        GROUP BY TipoCuenta,TipoMovimiento)
    UNION
        (SELECT TipoCuenta,TipoMovimiento,SUM(cantidadMov)AS cantidad,DosCincoOper AS Frecuencia, SUM(NumMov) AS NumMov,COUNT(DISTINCT(CuentaAhoID))
        FROM `TMPREPCUENTASMOVS`
        WHERE NumMov>=FrecDosMin AND NumMov<=FrecDosMax
        GROUP BY TipoCuenta,TipoMovimiento)
    UNION
        (SELECT TipoCuenta,TipoMovimiento,SUM(cantidadMov)AS cantidad,SeisDiesOper AS Frecuencia,SUM(NumMov) AS NumMov,COUNT(DISTINCT(CuentaAhoID))
        FROM `TMPREPCUENTASMOVS`
        WHERE NumMov>=FrecTresMin AND NumMov<=FrecTresMax
        GROUP BY TipoCuenta,TipoMovimiento)
    UNION
        (SELECT TipoCuenta,TipoMovimiento,SUM(cantidadMov)AS cantidad,MasDeDiezOper AS Frecuencia,SUM(NumMov) AS NumMov,COUNT(DISTINCT(CuentaAhoID))
        FROM `TMPREPCUENTASMOVS`
        WHERE NumMov>=FrecCuaMin
       GROUP BY TipoCuenta,TipoMovimiento);


    -- actualizamos los montos en la tabla principal
    UPDATE DATREGULATORIOD2442 Reg,MONTOSSUCURSALD2442 Mon SET
        Reg.NumeroCuentas       =   Mon.NumCuentas
        WHERE Reg.TipoCuenta    =   Mon.TipoCuenta
        AND   Reg.TipoOperacion =   Mon.TipoMovimiento
        AND   Reg.Frecuencia    =   Mon.Frecuencia
        AND   Reg.CanalTransaccion = Var_CanalSucursal; -- Canal 206 de Sucursales

    /*
   * ---------------------------------------------------------------------------------------------------------------
   * FIN SECCION CONSULTAS DEPOSITO Y RETIRO DE CUENTAS DE AHORRO E INVERSIONES
   * ---------------------------------------------------------------------------------------------------------------
   */

   /*
   * ---------------------------------------------------------------------------------------------------------------
   * SECCION CONSULTAS ATM
   * ---------------------------------------------------------------------------------------------------------------
   */

    -- Insertamos en la tabla las frecuencias
    INSERT INTO FRECUENCIAATMD2442
    SELECT Tar.TarjetaDebID,COUNT(Tar.DetalleATMID) Frecuencia, MONTH(FechaTransac) FROM TARDEBCONCIATMDET Tar
        WHERE Tar.FechaTransac BETWEEN Var_FechaInicio AND Var_FechaFin
        AND Tar.Descripcion LIKE CONCAT('%',TipoRetiro,'%')
        GROUP BY MONTH(FechaTransac),TarjetaDebID;

    -- Insertamos las frecuencias en la tabla
    DELETE FROM MONTOSSUCURSALD2442;
    INSERT INTO MONTOSSUCURSALD2442
        (SELECT DepositoVista,OperRetiro,Entero_Cero,UnaOperacion,SUM(det1.Frecuencia),COUNT(det1.NumeroCuenta) AS cantidad
        FROM `FRECUENCIAATMD2442` AS det1
        WHERE det1.Frecuencia=FrecUnoMin)
    UNION
        (SELECT DepositoVista,OperRetiro,Entero_Cero,DosCincoOper,SUM(det2.Frecuencia),COUNT(det2.NumeroCuenta) AS cantidad
        FROM `FRECUENCIAATMD2442` AS det2
        WHERE det2.Frecuencia>=FrecDosMin AND Frecuencia<=FrecDosMax)
    UNION
        (SELECT DepositoVista,OperRetiro,Entero_Cero,SeisDiesOper,SUM(det3.Frecuencia),COUNT(det3.NumeroCuenta) AS cantidad
        FROM `FRECUENCIAATMD2442` AS det3
        WHERE det3.Frecuencia>=FrecTresMin AND Frecuencia<=FrecTresMax)
    UNION
        (SELECT DepositoVista,OperRetiro,Entero_Cero,MasDeDiezOper,SUM(det4.Frecuencia),COUNT(det4.NumeroCuenta) AS cantidad
        FROM `FRECUENCIAATMD2442` AS det4
        WHERE det4.Frecuencia>=FrecCuaMin);

    -- actualizamos los montos en la tabla principal
    UPDATE DATREGULATORIOD2442 Reg,MONTOSSUCURSALD2442 Mon SET
        Reg.NumeroCuentas       =   Mon.NumCuentas
        WHERE Reg.TipoCuenta    =   Mon.TipoCuenta
        AND   Reg.TipoOperacion =   Mon.TipoMovimiento
        AND   Reg.Frecuencia    =   Mon.Frecuencia
        AND   Reg.CanalTransaccion = Var_CanalATM;
    /*
   * ---------------------------------------------------------------------------------------------------------------
   * FIN SECCION CONSULTAS ATM
   * ---------------------------------------------------------------------------------------------------------------
   */


   /*
   * ---------------------------------------------------------------------------------------------------------------
   * SECCION CONSULTAS TPV
   * ---------------------------------------------------------------------------------------------------------------
   */

    DROP TABLE IF EXISTS TmpComprasD2442;
    CREATE TEMPORARY TABLE TmpComprasD2442
        SELECT TarDebMovID,TarjetaDebID,MontoOpe,NumeroTran,MONTH(DATE(SUBSTR(REPLACE(FechaHrOpe,'-',''),1,8))) AS Mes FROM TARDEBBITACORAMOVS
            WHERE DATE(SUBSTR(REPLACE(FechaHrOpe,'-',''),1,8)) BETWEEN Var_FechaInicio AND Var_FechaFin
            AND GiroNegocio <> Entero_Cero
            AND UPPER(TerminalID) <> TipoLocal
            AND Estatus = Est_Procesado;
            CREATE INDEX idx_compras1 ON TmpComprasD2442(TarDebMovID);

    INSERT INTO TmpComprasD2442
         SELECT FolioConcilia,NumCuenta,ImporteDestinoTotal,NumTransaccion, MONTH(FechaProceso) FROM TARDEBCONCILIADETA
         WHERE FechaProceso >= Var_FechaInicio
         AND EstatusConci = Est_Conciliado
         AND FechaConsumo < Var_FechaInicio;

    DROP TABLE IF EXISTS TmpExcluir;
    CREATE TEMPORARY TABLE TmpExcluir
        SELECT FolioConcilia,NumCuenta,ImporteDestinoTotal,NumTransaccion FROM TARDEBCONCILIADETA
         WHERE FechaProceso > Var_FechaFin
         AND EstatusConci = Est_Conciliado
         AND FechaConsumo <= Var_FechaFin;

     CREATE INDEX idx_exclu1 ON TmpExcluir(FolioConcilia);

     DELETE FROM TmpComprasD2442 WHERE
        TarDebMovID IN (SELECT FolioConcilia FROM TmpExcluir);


    -- -- Insertamos en la tabla las frecuencias de las compras PROSA
    DELETE FROM FRECUENCIAATMD2442;
    INSERT INTO FRECUENCIAATMD2442
        SELECT det.TarjetaDebID, COUNT(DISTINCT(det.TarDebMovID)) operaciones, det.Mes FROM TmpComprasD2442 det
        GROUP BY det.Mes,det.TarjetaDebID;

    -- Filtramos e Insertamos las frecuencias en la tabla
    DELETE FROM MONTOSSUCURSALD2442;
    INSERT INTO MONTOSSUCURSALD2442
        (SELECT DepositoVista,OperRetiro,Entero_Cero,UnaOperacion,SUM(det1.Frecuencia),COUNT(det1.NumeroCuenta) AS cantidad
        FROM `FRECUENCIAATMD2442` AS det1
        WHERE det1.Frecuencia=FrecUnoMin)
    UNION
        (SELECT DepositoVista,OperRetiro,Entero_Cero,DosCincoOper,SUM(det2.Frecuencia),COUNT(det2.NumeroCuenta) AS cantidad
        FROM `FRECUENCIAATMD2442` AS det2
        WHERE det2.Frecuencia>=FrecDosMin AND Frecuencia<=FrecDosMax)
    UNION
        (SELECT DepositoVista,OperRetiro,Entero_Cero,SeisDiesOper,SUM(det3.Frecuencia),COUNT(det3.NumeroCuenta) AS cantidad
        FROM `FRECUENCIAATMD2442` AS det3
        WHERE det3.Frecuencia>=FrecTresMin AND Frecuencia<=FrecTresMax)
    UNION
        (SELECT DepositoVista,OperRetiro,Entero_Cero,MasDeDiezOper,SUM(det4.Frecuencia),COUNT(det4.NumeroCuenta) AS cantidad
        FROM `FRECUENCIAATMD2442` AS det4
        WHERE det4.Frecuencia>=FrecCuaMin);

    -- actualizamos los montos en la tabla principal
    UPDATE DATREGULATORIOD2442 Reg,MONTOSSUCURSALD2442 Mon SET
        Reg.NumeroCuentas       =   Mon.NumCuentas
        WHERE Reg.TipoCuenta    =   Mon.TipoCuenta
        AND   Reg.TipoOperacion =   Mon.TipoMovimiento
        AND   Reg.Frecuencia    =   Mon.Frecuencia
        AND   Reg.CanalTransaccion = Var_CanalTPV;


	/*
    *  Validaciones adicionales
    **/
    SELECT MuestraRegistros, 	MostrarComoOtros
		INTO  Var_MostrarRegistros, Var_CamSucOtros
        FROM PARAMREGULATORIOS;


    /* Cambiar Canal de Sucursal por Otros */
	IF Var_CamSucOtros = Var_SI THEN

        DROP TABLE IF EXISTS TMP_REG2442SUC;
        CREATE TEMPORARY TABLE TMP_REG2442SUC
        SELECT TipoCuenta,TipoOperacion,Frecuencia,NumeroCuentas
			FROM DATREGULATORIOD2442
            WHERE CanalTransaccion = Var_CanalSucursal;

		UPDATE DATREGULATORIOD2442 Reg, TMP_REG2442SUC Tmp
			SET Reg.NumeroCuentas = Reg.NumeroCuentas + Tmp.NumeroCuentas
			WHERE Reg.TipoCuenta = Tmp.TipoCuenta
				AND Reg.CanalTransaccion = Canal_Otros
                AND Reg.TipoOperacion = Tmp.TipoOperacion
                AND Reg.Frecuencia = Tmp.Frecuencia;

		UPDATE DATREGULATORIOD2442 Reg
			SET Reg.NumeroCuentas = Entero_Cero
			WHERE Reg.CanalTransaccion = Var_CanalSucursal;

        DROP TABLE IF EXISTS TMP_REG2441SUC;
    END IF;


    /* Mostrar solo los registros con datos */
    IF Var_MostrarRegistros <> Mostrar_Todo THEN
		DELETE FROM DATREGULATORIOD2442
			WHERE NumeroCuentas = Entero_Cero;

    END IF;


    IF(Par_TipoReporte = Rep_Excel) THEN
        SELECT
            Periodo,                Clave_Entidad AS    ClaveEntidad,   Subreporte,             Reg.TipoCuenta AS TipoCuentaTrans,
            Reg.CanalTransaccion,   Reg.TipoOperacion,                  Reg.Frecuencia,         Reg.NumeroCuentas
        FROM DATREGULATORIOD2442 Reg;
    END IF;

    IF(Par_TipoReporte = Rep_CSV) THEN
        SELECT CONCAT(
            Subreporte,';',
            TipoCuenta,';',
            CanalTransaccion,';',
            TipoOperacion,';',
            Frecuencia,';',
            IFNULL(NumeroCuentas,Entero_Cero)) AS Valor
        FROM DATREGULATORIOD2442;

    END IF;

END TerminaStore$$