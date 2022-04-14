-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGD244100003REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGD244100003REP`;DELIMITER $$

CREATE PROCEDURE `REGD244100003REP`(
# ------------------------------------------------------------------------------------------- #
# - SP QUE GENERA EL REPORTE EN EXCEL Y CSV PARA EL REGULATORIO D 2441 ---------------------- #
# ------------------------------------------------------------------------------------------- #
    Par_Anio                INT,            -- Anio del reporte
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
    DECLARE Var_FechaInicio     DATE;           -- Fecha de inicio del trimestre
    DECLARE Var_FechaFin        DATE;           -- Fecha de Fin del trimestre
    DECLARE Var_MesInicio       INT;
    DECLARE Var_MesFin          INT;
    DECLARE Var_TipoCueAho      VARCHAR(150);

    DECLARE Var_TipoCueVis      VARCHAR(150);
    DECLARE Var_CanalSucursal   INT;
    DECLARE Var_CanalATM        INT;
    DECLARE Var_CanalTPV        INT;
    DECLARE Var_MoviDepositos  	VARCHAR(150);            -- Tipos de Movimientos correspondientes a Despositos

    DECLARE Var_MoviRetiros    		VARCHAR(150);        -- Tipos de Movimientos correspondientes a Retiros
    DECLARE Var_InverRetiro	   		VARCHAR(150);		-- Inversiones --- Retiros
    DECLARE Var_InverDeposito		VARCHAR(150);		-- Inversiones --- Depositos
    DECLARE Var_TotalMovimientos 	TEXT;		-- Total de Movimientos a filtrar
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

    DECLARE DepositoVista   INT;
    DECLARE DepositoAhorro  INT;
    DECLARE DepositoPlazo   INT;
    DECLARE OperDeposito    INT;
    DECLARE OperRetiro      INT;

    DECLARE DiaPrimero      	VARCHAR(5);
    DECLARE DiezMeses       	INT;
    DECLARE LlaveCueDepositos   VARCHAR(20);
    DECLARE LlaveCueRetiros     VARCHAR(20);
    DECLARE LlaveInvDepositos   VARCHAR(20);

    DECLARE LlaveInvRetiros     VARCHAR(20);
    DECLARE TipoOrdinario       VARCHAR(30);
    DECLARE TipoVista           VARCHAR(30);
    DECLARE Est_Procesado       CHAR(1);
    DECLARE TipoLocal           VARCHAR(10);

    DECLARE Est_Conciliado      CHAR(1);
    DECLARE TipoRetiro			VARCHAR(15);
    DECLARE ProcesoCierre		VARCHAR(30);
    DECLARE Tipo_Sofipo			INT;
    DECLARE Tipo_CtaInst		INT;
    DECLARE Tipo_Ahorro			CHAR(1);

    DECLARE Mostrar_Todo		CHAR(1);
    DECLARE Var_SI				CHAR(1);
    DECLARE Canal_Otros			INT;

    -- Inicializacion de constantes
    SET Entero_Cero         := 0;
    SET Entero_Uno          := 1;
    SET Decimal_Cero        := 0.0;
    SET Rep_Excel           := 1;
    SET Rep_CSV             := 2;

    SET TipoAtencion        := 'A';         -- Tipo de Sucursal de Atencion
    SET Activa              := 'A';			-- Tipo de Estatus Activa
    SET Tipo_Cajero         := 'C';			-- Tipo Cajero
    SET Tipo_Sucursal       := 'S';			-- Tipo Sucursal
    SET Masculino           := 'M';			-- Sexo Masculino

    SET Femenino            := 'F';			-- Sexo Femenino
    SET TresMeses           := 3;
    SET DosMeses            := 2;
    SET Var_NO              := 'N'; 		-- Respuesta NO
    SET Inactiva            := 'I';			-- Tipo Estatus Inactiva

    SET PersonaFisica       := 'F';			-- Persona Fisica
    SET PersonaFisEmp       := 'A'; 		-- Persona Fisica con actividad empresarial
    SET Subreporte          := '2441';		-- Clave del reporte
    SET DiaPrimero          := '-01';
    SET DiezMeses           := 10;

    SET LlaveCueDepositos   :=  'MoviDepositos';	-- Llave de parametro, Movientos a filtrar para depositos
    SET LlaveCueRetiros     :=  'MoviRetiros' ;		-- Llave de parametro, Movientos a filtrar para retiros
    SET LlaveInvDepositos   :=  'InverDeposito' ;	-- Llave de parametro, Movientos a filtrar para depositos de inversion
    SET LlaveInvRetiros     :=  'InverRetiro' ;		-- Llave de parametro, Movientos a filtrar para depositos de retiros
    SET TipoOrdinario       := 	'AhorroOrdinario';				-- Tipo de Cuenta Ordinaria

    SET TipoVista           := 	'AhorroVista';				-- Tipo de Cuenta a la vista
    SET Est_Procesado       := 	'P';					-- Esatus de transaccion prcesada
    SET TipoLocal           := 	'WORKBENCH';			-- Tipo de transaccion realizada por SAFI
    SET Est_Conciliado      :=  'C';				-- Estatus de Transaccion "Conciliado"
    SET Var_CanalSucursal   := 206;					-- Clave para Canal - Sucursal

    SET Var_CanalATM        := 207;					-- Clave para Canal: Cajero ATM
    SET Var_CanalTPV        := 212;    				-- Clave para Canal: Terminal Punto de Venta
    SET DepositoVista       := 112;  				-- Cuenta Depositos a la vista, expediente completo
    SET DepositoAhorro      := 114;  				-- Cuenta Depositos de ahorro, expediente completo
    SET DepositoPlazo       := 116;  				-- Cuenta Depositos a plazo, expediente completo

    SET OperDeposito        := 302; 				-- Tipo de Operacion : Deposito
    SET OperRetiro          := 301; 				-- Tipo de Operacion : Retiro
    SET TipoRetiro 			:= 'RETIRO';			-- Filtrar operaciones de retiro
    SET ProcesoCierre		:= 'CIERREGENERALPRO';
    SET Tipo_Sofipo			:= 3;
    SET Tipo_Ahorro			:= 'A';

    SET Mostrar_Todo		:= 'T'; 	-- Mostrar todos los registros
    SET Var_SI				:= 'S';		-- Valor SI
    SET Canal_Otros			:= 213;		-- Canal de transaccion Otros

    SELECT ValorParametro INTO  Var_MoviDepositos FROM PARAMREGSERIER24 WHERE LlaveParametro = LlaveCueDepositos;
    SELECT ValorParametro INTO  Var_MoviRetiros   FROM PARAMREGSERIER24 WHERE LlaveParametro = LlaveCueRetiros;
    SELECT ValorParametro INTO  Var_InverRetiro   FROM PARAMREGSERIER24 WHERE LlaveParametro = LlaveInvRetiros;
    SELECT ValorParametro INTO  Var_InverDeposito   FROM PARAMREGSERIER24 WHERE LlaveParametro = LlaveInvDepositos;


    SET Var_TotalMovimientos   := CONCAT(Var_MoviDepositos,',',Var_MoviRetiros,',',Var_InverRetiro,',',Var_InverDeposito);



    SELECT ClaveEntidad,TipoCuenta INTO Clave_Entidad,Tipo_CtaInst FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID;

    /* -- Se calculan las fechas de los 3 meses del Trimestre -- */
    SET Var_MesFin              := Par_Trimestre * TresMeses;
    SET Var_MesInicio           := Var_MesFin - DosMeses;
    SET Var_FechaInicio         := CONCAT(Par_Anio,'-',CASE Var_MesInicio WHEN Var_MesInicio < DiezMeses
									THEN CONCAT(Entero_Cero,Var_MesInicio) ELSE Var_MesInicio END,DiaPrimero);
    SET Var_FechaFin            := CONCAT(Par_Anio,'-',CASE Var_MesFin    WHEN Var_MesFin    < DiezMeses
									THEN CONCAT(Entero_Cero,Var_MesFin)    ELSE Var_MesFin    END,DiaPrimero);
    SET Periodo                 := DATE_FORMAT(Var_FechaFin,'%Y%m');
    SET Var_FechaFin            := LAST_DAY(Var_FechaFin);

    -- Tabla principal para el reporte
    DROP TABLE IF EXISTS DATREGULATORIOD2441;
    CREATE TEMPORARY TABLE  DATREGULATORIOD2441(
        TipoCuenta                  INT,
        CanalTransaccion            INT,
        TipoOperacion               INT,
        MontoOperaciones            DECIMAL(16,2),
        NumeroOperaciones           INT,
        NumeroSocios                INT,
        PRIMARY KEY (TipoCuenta,CanalTransaccion,TipoOperacion)
    );

    -- Se crea una tabla para vaciar los depositos y retiros por trimestre.
    DROP TABLE IF EXISTS TMPREPCUENTASMOVS;
    CREATE TABLE IF NOT EXISTS TMPREPCUENTASMOVS (
        CuentaAhoID         VARCHAR(20),
        CantidadMov         DECIMAL(14,2),
        NumMov              INT(11),
        TipoMovimiento      VARCHAR(10),
        TipoCuenta          VARCHAR(10),
        ClienteID           VARCHAR(10),
        PRIMARY KEY(CuentaAhoID,TipoMovimiento,TipoCuenta)
    );

    -- Tabla temporal para agrupar los resultados
    -- de los montos de operaciones por cuenta y tipo movimiento
    DROP TABLE IF EXISTS MONTOSSUCURSAL;
    CREATE TEMPORARY TABLE MONTOSSUCURSAL(
        TipoCuenta          VARCHAR(10),
        TipoMovimiento      VARCHAR(10),
        Cantidad            DECIMAL(16,2),
        NumMov              INT,
        Socios              INT,
        PRIMARY KEY(TipoCuenta,TipoMovimiento)
    );

    # -- TABLA PARA FILTRAR LOS MOVIMIENTOS DE ATM --#
    DROP TABLE IF EXISTS TMPMOVIMIENTOSATM;
    CREATE TEMPORARY TABLE  TMPMOVIMIENTOSATM(
        DetalleATMID        VARCHAR(40),
        TerminalID          VARCHAR(20),
        TarjetaDebID        VARCHAR(100) ,
        MontoTransac        DECIMAL(16,2),
        PRIMARY KEY(DetalleATMID,TerminalID)
    );

    # -- Tabla para filtrar los datos de HIS-CUENAHOMOV -- #
    DROP TABLE IF EXISTS TMPCUENAHOMOV;
    CREATE TEMPORARY TABLE  TMPCUENAHOMOV(
        NumeroMov           BIGINT,
        CuentaAhoID         BIGINT(12),
        CantidadMovimiento  DECIMAL(16,2),
        TipoMovAhoID        CHAR(4),
        TipoMov				INT(11) DEFAULT 0,
        PRIMARY KEY (NumeroMov,CuentaAhoID)
    );

    -- Insertamos la estructura de la tabla
    INSERT INTO DATREGULATORIOD2441
        SELECT Tip.CuentaTransID,		Can.CanalID,		Tio.TipoOperacionID,		Decimal_Cero,		Entero_Cero,
			   Entero_Cero
        FROM CATTIPOCUENTATRANS Tip,CATCANALES Can,CATTIPOOPERACION Tio
        WHERE Tip.TipoInstitID = Tipo_Sofipo;

    /*
   * ---------------------------------------------------------------------------------------------------------------
   * SECCION CONSULTAS DEPOSITO Y RETIRO DE CUENTAS DE AHORRO E INVERSIONES
   * ---------------------------------------------------------------------------------------------------------------
   */
    -- Filtramos los movimientos en HIS-CUENAHOMOV
    INSERT INTO TMPCUENAHOMOV
    SELECT Cue.NumeroMov,		Cue.CuentaAhoID,		SUM(Cue.CantidadMov) AS CantidadMovimiento,		MIN(Cue.TipoMovAhoID),
		Entero_Cero
		FROM `HIS-CUENAHOMOV` Cue
        WHERE FIND_IN_SET(Cue.TipoMovAhoID ,Var_TotalMovimientos) > Entero_Cero
        AND Cue.Fecha BETWEEN Var_FechaInicio AND Var_FechaFin
        GROUP BY Cue.NumeroMov,Cue.CuentaAhoID
        ORDER BY Cue.NumeroMov;

    INSERT INTO TMPREPCUENTASMOVS(CuentaAhoID,CantidadMov,NumMov,TipoMovimiento,TipoCuenta,ClienteID)
    SELECT reg.CuentaAhoID,		SUM(reg.CantidadMovimiento) CantidadMov,		COUNT(*) AS NumMov,		OperDeposito AS TipoMovimiento,
           CASE  WHEN ti.ClasificacionConta = Tipo_Ahorro THEN DepositoAhorro ELSE DepositoVista END,	cu.ClienteID
    FROM TMPCUENAHOMOV AS reg
    INNER JOIN CUENTASAHO cu ON reg.CuentaAhoID=cu.CuentaAhoID
    INNER JOIN TIPOSCUENTAS ti ON cu.TipoCuentaID = ti.TipoCuentaID
    AND FIND_IN_SET(reg.TipoMovAhoID,Var_MoviDepositos) > Entero_Cero
    WHERE ti.TipoCuentaID <> Tipo_CtaInst
    GROUP BY reg.CuentaAhoID, ti.ClasificacionConta, cu.ClienteID
    ORDER BY reg.CuentaAhoID;

    -- Insertar retiros
    INSERT INTO TMPREPCUENTASMOVS(CuentaAhoID,CantidadMov,NumMov,TipoMovimiento,TipoCuenta,ClienteID)
    SELECT reg.CuentaAhoID,		SUM(reg.CantidadMovimiento) CantidadMov,		COUNT(*) AS NumMov,		OperRetiro AS TipoMovimiento,
           CASE  WHEN ti.ClasificacionConta = Tipo_Ahorro THEN DepositoAhorro ELSE DepositoVista END,	cu.ClienteID
    FROM TMPCUENAHOMOV AS reg
    INNER JOIN CUENTASAHO cu ON reg.CuentaAhoID=cu.CuentaAhoID
    INNER JOIN TIPOSCUENTAS ti ON cu.TipoCuentaID = ti.TipoCuentaID
    AND FIND_IN_SET(reg.TipoMovAhoID,Var_MoviRetiros) > Entero_Cero
    WHERE ti.TipoCuentaID <> Tipo_CtaInst
    GROUP BY reg.CuentaAhoID, ti.ClasificacionConta, cu.ClienteID
    ORDER BY reg.CuentaAhoID;

    -- actualiza movimientos de inversiones
    UPDATE TMPCUENAHOMOV SET
		TipoMov = CASE WHEN FIND_IN_SET(TipoMovAhoID,Var_InverRetiro) > Entero_Cero THEN 301
					   WHEN FIND_IN_SET(TipoMovAhoID,Var_InverDeposito) > Entero_Cero THEN 302 END
	WHERE FIND_IN_SET(TipoMovAhoID,CONCAT(Var_InverRetiro,',',Var_InverDeposito)) > Entero_Cero;


    -- Insertar Inversiones
    INSERT INTO TMPREPCUENTASMOVS(CuentaAhoID,CantidadMov,NumMov,TipoMovimiento,TipoCuenta,ClienteID)
    SELECT reg.CuentaAhoID,		SUM(reg.CantidadMovimiento) CantidadMov,		COUNT(*) AS NumMov,
		   reg.TipoMov AS TipoMovimiento,
		   DepositoPlazo,		cu.ClienteID
	FROM TMPCUENAHOMOV AS reg
	INNER JOIN CUENTASAHO cu ON reg.CuentaAhoID=cu.CuentaAhoID
	INNER JOIN TIPOSCUENTAS ti ON cu.TipoCuentaID = ti.TipoCuentaID
	AND FIND_IN_SET(reg.TipoMovAhoID,CONCAT(Var_InverRetiro,',',Var_InverDeposito)) > Entero_Cero
	WHERE ti.TipoCuentaID <> Tipo_CtaInst
	GROUP BY reg.CuentaAhoID, reg.TipoMov, cu.ClienteID
	ORDER BY reg.CuentaAhoID;

    -- Insertamos los resultados por tipo de cuenta
    INSERT INTO MONTOSSUCURSAL
		SELECT TipoCuenta,		TipoMovimiento,		SUM(cantidadMov)AS cantidad,		SUM(NumMov) AS NumMov,		COUNT(DISTINCT(ClienteID))
		FROM `TMPREPCUENTASMOVS`
		GROUP BY TipoCuenta,TipoMovimiento;

    -- actualizamos los montos en la tabla principal
    UPDATE DATREGULATORIOD2441 Reg,MONTOSSUCURSAL Mon SET
        Reg.MontoOperaciones    =   Mon.Cantidad,
        Reg.NumeroOperaciones   =   Mon.NumMov,
        Reg.NumeroSocios        =   Mon.Socios
        WHERE Reg.TipoCuenta    =   Mon.TipoCuenta
        AND   Reg.TipoOperacion =   Mon.TipoMovimiento
        AND   Reg.CanalTransaccion = Var_CanalSucursal;
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
    -- Filtramos los movimientos en ATM en el Trimestre
    -- Agrupamos y calculamos los montos y el numero cuentas
    DELETE FROM MONTOSSUCURSAL;
    INSERT INTO MONTOSSUCURSAL
        SELECT DepositoVista,		OperRetiro,		SUM(Tar.MontoTransac) Importe,		COUNT(Tar.DetalleATMID) NoTrans,
            COUNT(DISTINCT(Tar.TarjetaDebID)) Cuentas FROM TARDEBCONCIATMDET Tar
		WHERE Tar.FechaTransac BETWEEN Var_FechaInicio AND Var_FechaFin
        AND Tar.Descripcion LIKE CONCAT('%',TipoRetiro,'%');

    -- actualizamos los montos en la tabla principal
    UPDATE DATREGULATORIOD2441 Reg,MONTOSSUCURSAL Mon SET
        Reg.MontoOperaciones    =   IFNULL(Mon.Cantidad,Entero_Cero),
        Reg.NumeroOperaciones   =   IFNULL(Mon.NumMov,Entero_Cero),
        Reg.NumeroSocios        =   IFNULL(Mon.Socios,Entero_Cero)
    WHERE Reg.TipoCuenta    =   Mon.TipoCuenta
	AND   Reg.TipoOperacion =   Mon.TipoMovimiento
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
	DROP TABLE IF EXISTS TmpCompras;
	CREATE TEMPORARY TABLE TmpCompras
	SELECT TarDebMovID,		TarjetaDebID,		MontoOpe,		NumeroTran
    FROM TARDEBBITACORAMOVS
	WHERE DATE(SUBSTR(REPLACE(FechaHrOpe,'-',''),1,8)) BETWEEN Var_FechaInicio AND Var_FechaFin
	AND GiroNegocio <> Entero_Cero
	AND UPPER(TerminalID) <> TipoLocal
	AND Estatus = Est_Procesado;
	CREATE INDEX idx_compras1 ON TmpCompras(TarDebMovID);

     INSERT INTO TmpCompras
	 SELECT FolioConcilia,		NumCuenta,		ImporteDestinoTotal,		NumTransaccion
     FROM TARDEBCONCILIADETA
	 WHERE FechaProceso >= Var_FechaInicio
	 AND EstatusConci = Est_Conciliado
	 AND FechaConsumo < Var_FechaInicio;

	DROP TABLE IF EXISTS TmpExcluir;
	CREATE TEMPORARY TABLE TmpExcluir
	SELECT FolioConcilia,		NumCuenta,		ImporteDestinoTotal,			NumTransaccion
    FROM TARDEBCONCILIADETA
	WHERE FechaProceso > Var_FechaFin
	AND EstatusConci = Est_Conciliado
	AND FechaConsumo <= Var_FechaFin;

	CREATE INDEX idx_exclu1 ON TmpExcluir(FolioConcilia);

	DELETE FROM TmpCompras WHERE
		TarDebMovID IN (SELECT FolioConcilia FROM TmpExcluir);

	DELETE FROM MONTOSSUCURSAL;
	INSERT INTO MONTOSSUCURSAL
    SELECT DepositoVista,		OperRetiro,		SUM(det.MontoOpe) monto,		COUNT(det.TarDebMovID) operaciones,
		   COUNT(DISTINCT(det.TarjetaDebID)) socios
	FROM TmpCompras det;



    -- actualizamos los montos en la tabla principal
    UPDATE DATREGULATORIOD2441 Reg,MONTOSSUCURSAL Mon SET
        Reg.MontoOperaciones    =   IFNULL(Mon.Cantidad,Entero_Cero),
        Reg.NumeroOperaciones   =   IFNULL(Mon.NumMov,Entero_Cero),
        Reg.NumeroSocios        =   IFNULL(Mon.Socios,Entero_Cero)
    WHERE Reg.TipoCuenta    =   Mon.TipoCuenta
    AND   Reg.TipoOperacion =   Mon.TipoMovimiento
    AND   Reg.CanalTransaccion = Var_CanalTPV;


   /*
   * ---------------------------------------------------------------------------------------------------------------
   * FIN SECCION CONSULTAS TPV
   * ---------------------------------------------------------------------------------------------------------------
   */

	SELECT MuestraRegistros, 	MostrarComoOtros
		INTO  Var_MostrarRegistros, Var_CamSucOtros
        FROM PARAMREGULATORIOS;


    /* Cambiar Canal de Sucursal por Otros */
	IF Var_CamSucOtros = Var_SI THEN

        DROP TABLE IF EXISTS TMP_REG2441SUC;
        CREATE TEMPORARY TABLE TMP_REG2441SUC
        SELECT TipoCuenta,TipoOperacion,MontoOperaciones,NumeroOperaciones,NumeroSocios
			FROM DATREGULATORIOD2441
            WHERE CanalTransaccion = Var_CanalSucursal;

		UPDATE DATREGULATORIOD2441 Reg, TMP_REG2441SUC Tmp
			SET Reg.MontoOperaciones = Reg.MontoOperaciones + Tmp.MontoOperaciones,
				Reg.NumeroOperaciones = Reg.NumeroOperaciones + Tmp.NumeroOperaciones,
				Reg.NumeroSocios = Reg.NumeroSocios + Tmp.NumeroSocios
			WHERE Reg.TipoCuenta = Tmp.TipoCuenta
				AND Reg.CanalTransaccion = Canal_Otros
                AND Reg.TipoOperacion = Tmp.TipoOperacion;

		UPDATE DATREGULATORIOD2441 Reg
			SET Reg.MontoOperaciones = Entero_Cero,
				Reg.NumeroOperaciones = Entero_Cero,
				Reg.NumeroSocios = Entero_Cero
			WHERE Reg.CanalTransaccion = Var_CanalSucursal;

        DROP TABLE IF EXISTS TMP_REG2441SUC;
    END IF;


    /* Mostrar solo los registros con datos */
    IF Var_MostrarRegistros <> Mostrar_Todo THEN
		DELETE FROM DATREGULATORIOD2441
			WHERE MontoOperaciones = Entero_Cero
				AND NumeroOperaciones = Entero_Cero
                AND NumeroSocios = Entero_Cero;

    END IF;



    IF(Par_TipoReporte = Rep_Excel) THEN
        SELECT
            Periodo,        Clave_Entidad AS ClaveEntidad,                          Subreporte,         TipoCuenta AS TipoCuentaTrans,     CanalTransaccion,
            TipoOperacion,  ROUND(MontoOperaciones,Entero_Cero) AS MontoOperacion,  NumeroOperaciones,  NumeroSocios AS NumeroClientes
        FROM DATREGULATORIOD2441;
    END IF;

    IF(Par_TipoReporte = Rep_CSV) THEN
        SELECT CONCAT(
            Subreporte,';',
            TipoCuenta,';',
            CanalTransaccion,';',
            TipoOperacion,';',
            IFNULL(ROUND(MontoOperaciones,Entero_Cero),Entero_Cero),';',
            IFNULL(NumeroOperaciones,Entero_Cero),';',
            IFNULL(NumeroSocios,Entero_Cero)) AS Valor
        FROM DATREGULATORIOD2441 ORDER BY TipoCuenta,CanalTransaccion;

    END IF;


    /* Se eliminan las tablas ocupadas para el reporte */
    DROP TABLE IF EXISTS DATREGULATORIOD2441;
    DROP TABLE IF EXISTS TMPREPCUENTASMOVS;
    DROP TABLE IF EXISTS MONTOSSUCURSAL;
    DROP TABLE IF EXISTS TMPMOVIMIENTOSATM;
    DROP TABLE IF EXISTS TMPCUENAHOMOV;

END TerminaStore$$