-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CINTACIRCULOCREREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CINTACIRCULOCREREP`;

DELIMITER $$
CREATE PROCEDURE `CINTACIRCULOCREREP`(
    -- Reporte de la Cinta para Envio a Circulo de Credito.para Personas Fisicas y Persona Fisica con Actividad Empresarial
    Par_Fecha           DATE,
    Par_TipoReporte     INT(11),        -- Tipo de Reporte

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)

    )

TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_SumSaldoTot     DECIMAL(14,2);
DECLARE Var_SumSaldoVen     DECIMAL(14,2);
DECLARE Var_SumNumElem      INT;
DECLARE Var_DirecSuc        VARCHAR(200);
DECLARE Var_FecUltEnvio     DATE;

DECLARE Str_NumElementos    VARCHAR(10);
DECLARE Str_SumSaldoTot     VARCHAR(20);
DECLARE Str_SumSaldoVen     VARCHAR(20);

-- Declaracion de Constantes
DECLARE Entero_Cero     CHAR(1);
DECLARE Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia     VARCHAR(20);
DECLARE Pagos_Fijos     CHAR(1);
DECLARE Est_Castigo     CHAR(1);
DECLARE Cla_Castigo     CHAR(2);
DECLARE ClaveVentaCesion CHAR(2);
DECLARE Mon_Pesos       CHAR(2);
DECLARE Fre_Mensual     CHAR(1);
DECLARE Fre_Semestral   CHAR(1);
DECLARE Fre_Tetrameste  CHAR(1);
DECLARE Fre_Revolvente  CHAR(1);
DECLARE No_Revolvente   CHAR(1);
DECLARE Si_Revolvente   CHAR(1);
DECLARE SI_PagaIVA      CHAR(1);
DECLARE Pago_Vigente    CHAR(2);
DECLARE Est_Pagado      CHAR(1);
DECLARE Est_Vigente     CHAR(1);
DECLARE Iden_Licencia   INT;
DECLARE Iden_Elector    INT;
DECLARE Res_Titular     CHAR(1);
DECLARE Con_Otros       CHAR(2);
DECLARE PagoCapLibre    CHAR(1);
DECLARE Est_InverVig    CHAR(1);
DECLARE NatMovBloqueo   CHAR(1);
DECLARE BloqGarLiq      INT;
DECLARE BloqGarLiqAdi   INT;
DECLARE Est_GarAutorizada   CHAR(1);
DECLARE Char_Cero       CHAR(1);
DECLARE ConsConsolidado CHAR(2);
DECLARE ConsSI          CHAR(1);
-- Caracteres
DECLARE Guion           char(1);
DECLARE Punto           char(1);
DECLARE Coma            char(1);
DECLARE Diagonal        char(1);
DECLARE Con_ClienteCRCB INT(11);  -- RLAVIDA_T_12040

-- Asignacion de Tipo de Reporte
DECLARE Reporte_Semanal   INT(11);    -- Reporte Semanal
DECLARE Reporte_Mensual   INT(11);    -- Reporte Mensual
DECLARE Var_FechaInicio   DATE;     -- Fecha de Inicio
DECLARE Var_IdicadorDef     CHAR(1);        -- Identificador que se ocupa para identificar la fecha defuncion
DECLARE Var_EstatusDef      CHAR(1);        -- Estatus que se identifica la defuncion
DECLARE Var_FechIniMensual   DATE;  -- JCENTENO CS 10435
DECLARE Var_FechAntMensual    DATE;  -- JCENTENO CS 10435
DECLARE Var_ClienteEspecifico INT(11);  -- RLAVIDA_T_12040
DECLARE EstatusVendido      CHAR(1);        -- Estatus vendido

-- Asignacion de Constantes
SET Entero_Cero     := 0;               -- Entero en Cero
SET Cadena_Vacia    := '';              -- Cadena Vacia
SET Fecha_Vacia     := '1900-01-01';    -- Fecha Vacia
SET Pagos_Fijos     := 'F';             -- Pagos Fijos
SET Est_Castigo     := 'K';             -- Estatus del Credito Castigado
SET Cla_Castigo     := 'UP';            -- Clave del Castigo segun Circulo - Cuenta que Causa Quebranto
SET ClaveVentaCesion:= 'NV';            -- clave para cartera cedida
SET Mon_Pesos       := 'MX';            -- Pesos Mexicanos.
SET Fre_Mensual     := 'M';             -- Frecuencia del Pagos Mensual
SET Fre_Semestral   := 'E';             -- Frecuencia del Pagos Semestral
SET Fre_Tetrameste  := 'R';             -- Frecuencia del Pagos Tetramestral
SET Fre_Revolvente  := 'R';             -- Frecuencia del Pagos Revolvente
SET No_Revolvente   := 'N';             -- Tipo de Linea NO Revolvente
SET Si_Revolvente   := 'S';             -- Tipo de Linea SI Revolvente.
SET SI_PagaIVA      := 'S';             -- Si Paga IVA
SET Pago_Vigente    := 'V';             -- Pago del Credito Vigente o al Corriente
SET Est_Pagado      := 'P';             -- Estatus del Credito Pagado
SET Iden_Licencia   := 4;               -- Tipo de Identificacion: Licencia de Conducir
SET Iden_Elector    := 1;               -- Tipo de Identificacion: Credencial de Elector
SET Res_Titular     := 'I';             -- Tipo de Responsabilidad Individual (Titular)
SET Con_Otros       := 'OT';            -- Tipo de Contrato: Otros
SET PagoCapLibre    := 'L';             -- Tipo Pago Capital: Libre
SET Est_InverVig    := 'N';             -- Estatus Inversion: Vigente
SET NatMovBloqueo   := 'B';             -- Naturaleza Movimiento: Bloqueo
SET BloqGarLiq      := 8;               -- Tipo Bloqueo: Deposito por Garantia Liquida
SET BloqGarLiqAdi   := 10;              -- Tipo Bloqueo: Deposito por Garantia Liquida Adicional
SET Est_GarAutorizada   :='U';          -- Estatus de la Garantia Asignada: Autorizada
SET Char_Cero       := '0';             -- Char cero

set Guion           :='-';
set Punto           :='.';
set Coma            :=',';
set Diagonal        :='/';
SET Est_Vigente     :='V';
SET Var_IdicadorDef     :='Y';
SET Var_EstatusDef      :='R';
SET EstatusVendido  := 'X';
SET ConsConsolidado     := 'CO';
SET ConsSI         := 'S';
SET Con_ClienteCRCB := 24;  -- RLAVIDA_T_12040 -- CLIENTE ESPECIFICO CREDICLUB

-- Seteo de Tipo de Reporte
SET Reporte_Semanal := 1;
SET Reporte_Mensual := 2;

-- Direccion completa de la sucursal matriz
SELECT DirecCompleta INTO Var_DirecSuc
    FROM SUCURSALES Suc,
         PARAMETROSSIS Par
    WHERE Suc.SucursalID = Par.SucursalMatrizID;

-- La Informacion a Circulo se Reporta cada 15 Dias, con este Query
-- Calculamos el ultimo envio que se debio haber realizado
IF(DAYOFMONTH(Par_Fecha) <= 15) THEN
    SET Var_FecUltEnvio := DATE_SUB(Par_Fecha, INTERVAL DAYOFMONTH(Par_Fecha) DAY);
ELSE
    SET Var_FecUltEnvio := DATE_SUB(Par_Fecha, INTERVAL DAYOFMONTH(Par_Fecha) - 15 DAY);
END IF;

    -- Se elimina los registros de la tabla temporal
    DELETE FROM TMPREPCIRCULO
        WHERE Transaccion = Aud_NumTransaccion;



-- Reporte Semanal
IF( Par_TipoReporte = Reporte_Semanal ) THEN

  -- Se calcula la fecha de Inicio
  SET Var_FechaInicio := DATE_SUB(Par_Fecha, INTERVAL 7 DAY);

      -- Se inserta registros en la tabla temporal
      INSERT INTO TMPREPCIRCULO
      SELECT Sal.CreditoID, Aud_NumTransaccion, Sal.ClienteID,    Cli.SucursalOrigen,
           SUBSTRING(IFNULL(ApellidoPaterno, Cadena_Vacia), 1, 30) AS ApellidoPaterno,
           SUBSTRING(IFNULL(ApellidoMaterno, Cadena_Vacia), 1, 30) AS ApellidoMaterno,
           SUBSTRING(CONCAT(IFNULL(PrimerNombre, Cadena_Vacia),
                  CASE WHEN IFNULL(SegundoNombre, Cadena_Vacia) != Cadena_Vacia THEN
                      CONCAT(' ', SegundoNombre) ELSE Cadena_Vacia
                  END,
                  CASE WHEN IFNULL(TercerNombre, Cadena_Vacia) != Cadena_Vacia THEN
                       CONCAT(' ', TercerNombre) ELSE Cadena_Vacia
                  END),  1, 50) AS Nombre,

            CONVERT(IFNULL(FechaNacimiento, Fecha_Vacia), CHAR) AS FechaNac,
            SUBSTRING(RFCOficial, 1, 13) AS RFC, SUBSTRING(CURP, 1, 18) AS CURP,
            "MX" AS Nacion,
            CASE
                WHEN EstadoCivil = "S" THEN "S"
                WHEN EstadoCivil = "U" THEN "L"
                WHEN EstadoCivil = "SE" THEN "E"
                WHEN EstadoCivil = "D" THEN "D"
                WHEN EstadoCivil = "V" THEN "V"
                WHEN EstadoCivil = "CS" OR EstadoCivil = "CM"  OR EstadoCivil = "CC" THEN "C"
                ELSE Cadena_Vacia
            END AS Edocivil,

            CASE
                WHEN Sov.TipoViviendaID = 1 OR Sov.TipoViviendaID = 5 THEN "1"
                WHEN Sov.TipoViviendaID = 2 OR Sov.TipoViviendaID = 6 OR Sov.TipoViviendaID = 9 THEN "2"
                WHEN Sov.TipoViviendaID = 4 OR Sov.TipoViviendaID = 8 THEN "3"
                WHEN Sov.TipoViviendaID = 3 OR Sov.TipoViviendaID = 7 THEN "4"
                ELSE ""
            END AS TipoResidencia,
            Cli.Sexo, "PF" AS TipoPersona,
            "", "", "", "", "", -- Datos de las Direcciones
            REPLACE(REPLACE(REPLACE(REPLACE(IFNULL(Cli.Telefono,Cadena_Vacia) ,"-",""), ")", ""), "(", ""), " ", ""),
            "",
            CASE -- NombreEmpresa
        WHEN IFNULL(Cli.LugardeTrabajo, Cadena_Vacia) = Cadena_Vacia AND (Cli.OcupacionID = 20 OR Cli.OcupacionID = 21 ) THEN
            'Labores de Hogar'
        WHEN IFNULL(Cli.LugardeTrabajo, Cadena_Vacia) = Cadena_Vacia AND (Cli.OcupacionID = 30 OR Cli.OcupacionID = 62 OR Cli.OcupacionID = 99 ) THEN
            'Desempleado'
        WHEN  IFNULL(Cli.LugardeTrabajo, Cadena_Vacia) = Cadena_Vacia AND (Cli.OcupacionID = 40 OR Cli.OcupacionID = 41 OR Cli.OcupacionID = 42 OR Cli.OcupacionID = 43 ) THEN
                    'Estudiante'
                 WHEN IFNULL(Cli.LugardeTrabajo, Cadena_Vacia) = Cadena_Vacia AND (Cli.OcupacionID = 50 OR Cli.OcupacionID = 51 OR Cli.OcupacionID = 52 OR Cli.OcupacionID = 53 OR Cli.OcupacionID = 54 ) THEN
                    'Jubilados'
                 WHEN IFNULL(Cli.LugardeTrabajo, Cadena_Vacia) = Cadena_Vacia THEN
                    'Trabajador Independiente'
                 WHEN IFNULL(Cli.LugardeTrabajo, Cadena_Vacia) != Cadena_Vacia THEN
                     Cli.LugardeTrabajo
            END AS LugardeTrabajo,
            "", "","","","",    -- Datos del Domicilio del Trabajo
            REPLACE(REPLACE(REPLACE(REPLACE(IFNULL(Cli.TelTrabajo,Cadena_Vacia),"-",""), ")", ""), "(", ""), " ", ""),
            SUBSTRING(LTRIM(RTRIM(IFNULL(Cli.Puesto, Cadena_Vacia))), 1, 30),

            -- Tipo de Responsabilidad
            Res_Titular,
            -- Tipo de Contrato
            CASE WHEN Cre.EsConsolidado  = ConsSI THEN
                ConsConsolidado
            ELSE IFNULL(Des.ClaveCirculoCredito, Con_Otros)  END,

            Mon_Pesos,  Pagos_Fijos, Cre.NumAmortizacion,
            CASE    -- Frecuencia del Pago
                WHEN Cre.FrecuenciaCap != Fre_Semestral AND Cre.FrecuenciaCap != Fre_Tetrameste
                     AND COALESCE(Pro.EsRevolvente,No_Revolvente) = No_Revolvente THEN
                     Cre.FrecuenciaCap
                WHEN (Cre.FrecuenciaCap = Fre_Semestral OR Cre.FrecuenciaCap = Fre_Tetrameste)
                     AND COALESCE(Pro.EsRevolvente,No_Revolvente) = No_Revolvente THEN
                    Fre_Mensual
                WHEN  COALESCE(Pro.EsRevolvente,No_Revolvente) = SI_Revolvente THEN
                    Fre_Revolvente
            END,
            (Sal.SalCapVigente + Sal.SalCapAtrasado +
             Sal.SalCapVencido + Sal.SalCapVenNoExi), -- Saldo Insoluto de Capital

            (Sal.SalCapAtrasado + Sal.SalCapVencido), -- Saldo Vencido de Capital

            (Sal.SalIntAtrasado + Sal.SalIntVencido +
             Sal.SalIntProvision + Sal.SalIntNoConta), -- Saldo de Interes Total

            (Sal.SalIntAtrasado + Sal.SalIntVencido), -- Saldo de Interes Vencido

            (Sal.SalMoratorios + Sal.SaldoMoraVencido + Sal.SaldoMoraCarVen), -- Saldo de Moratorios
            (Sal.SalComFaltaPago + Sal.SaldoComServGar + SalOtrasComisi), -- Saldo de Comisiones

            Entero_Cero, Entero_Cero,   Cli.PagaIVA,  Pro.CobraIVAInteres,  Pro.CobraIVAMora,

            -- Total del Adeudo sin IVA
            (Sal.SalCapVigente + Sal.SalCapAtrasado + Sal.SalCapVencido + Sal.SalCapVenNoExi) +
            (Sal.SalIntAtrasado + Sal.SalIntVencido + Sal.SalIntProvision + Sal.SalIntNoConta) +
            (Sal.SalMoratorios + Sal.SaldoMoraVencido + Sal.SaldoMoraCarVen) + (Sal.SalComFaltaPago + Sal.SaldoComServGar + SalOtrasComisi),

            -- Total de Vencido sin IVA
            (Sal.SalCapAtrasado + Sal.SalCapVencido) +
            (Sal.SalIntAtrasado + Sal.SalIntVencido) +
            (Sal.SalMoratorios + Sal.SaldoMoraVencido + Sal.SaldoMoraCarVen) + (Sal.SalComFaltaPago + Sal.SaldoComServGar + SalOtrasComisi),


            Cre.MontoCuota, Cre.FechaInicio,
            Cadena_Vacia,  Sal.NoCuotasAtraso,

            CASE
                WHEN Sal.EstatusCredito = Est_Pagado THEN
                    CONVERT(IFNULL(Cre.FechTerminacion, Par_Fecha), CHAR)
                ELSE Cadena_Vacia
            END,

            CASE
                 WHEN Sal.NoCuotasAtraso = Entero_Cero THEN
                        Pago_Vigente
                 WHEN Sal.NoCuotasAtraso > Entero_Cero AND Sal.NoCuotasAtraso < 84 THEN
                        LPAD(CONVERT(Sal.NoCuotasAtraso, CHAR), 2, '0')
                 ELSE '84'              -- 84 Periodos de Atraso o Mas
            END,
            Cadena_Vacia,   Cadena_Vacia,           Entero_Cero,        Cadena_Vacia,   Cadena_Vacia,
            Entero_Cero,    Cadena_Vacia,           Cre.MontoCredito,   Cadena_Vacia,   Sal.EstatusCredito,
            Cadena_Vacia,   Cre.TipoPagoCapital,    Entero_Cero,        Entero_Cero,    Entero_Cero,
            Cre.MontoCredito, IFNULL(Cre.SolicitudCreditoID,Entero_Cero),'MX' AS OrigenDomicilio,
            'MX' AS RazonSocialDomicilio,
                CASE WHEN Cre.FechTraspasVenc != Fecha_Vacia AND Cre.FechTraspasVenc < Par_Fecha THEN
                  Cre.FechTraspasVenc
            ELSE Cadena_Vacia
        END
            ,Cadena_Vacia,Cadena_Vacia,Entero_Cero,Cli.Correo,
            CASE WHEN  IFNULL(Cli.LugardeTrabajo, Cadena_Vacia) = Cadena_Vacia THEN
                    'N'
                ELSE
                    'S'
            END AS TieneEmpleo,
        Cadena_Vacia AS FechaDefuncion,
        Cadena_Vacia AS IdicadorDef,
        Entero_Cero AS Monto,
        Fecha_Vacia AS FechaIngreso
        FROM SALDOSCREDITOS Sal
        INNER JOIN CREDITOS Cre ON Cre.CreditoID = Sal.CreditoID
        INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
        LEFT OUTER JOIN DESTINOSCREDITO Des ON Cre.DestinoCreID = Des.DestinoCreID
        LEFT OUTER JOIN CLIENTES Cli ON Cli.ClienteID = Sal.ClienteID
        LEFT OUTER JOIN SOCIODEMOVIVIEN Sov ON Sov.ClienteID = Sal.ClienteID
        LEFT OUTER JOIN DIRECCLIENTE Dir ON Dir.ClienteID = Sal.ClienteID
                                         AND Dir.Oficial = 'S'
		LEFT OUTER JOIN HISCREDITOSVENTACAR Vta ON Vta.CreditoID = Cre.CreditoID
			AND Vta.Fecha < Var_FechaInicio AND Vta.Tipo = 'PROCESADO'
        WHERE Cre.FechTerminacion BETWEEN Var_FechaInicio AND Par_Fecha
          AND Cre.FechTerminacion < Cre.FechaVencimien
          AND Sal.FechaCorte = Cre.FechTerminacion
          AND ( Cli.TipoPersona = "A" OR  Cli.TipoPersona = "F" )
          AND Cre.Estatus != 'C'
          AND Vta.CreditoID IS NULL;
          
		DROP TEMPORARY TABLE IF EXISTS TMPDATOSCLI;
		CREATE TEMPORARY TABLE TMPDATOSCLI(
			`CreditoID` bigint(12) NOT NULL COMMENT 'Numero de Credito',
			`Monto` decimal(14,2) DEFAULT NULL COMMENT 'Monto capturado en pantalla',
			`FechaIngreso` date DEFAULT NULL COMMENT 'Fecha de ingreso');
		INSERT INTO TMPDATOSCLI 
		SELECT 
			Sal.CreditoID,
			IFNULL(MAX(CliEco.Monto), Entero_Cero) AS Monto,
			IFNULL(MAX(NomiEmp.FechaIngreso), Fecha_Vacia) AS FechaIngreso
		FROM SALDOSCREDITOS Sal
		INNER JOIN CREDITOS Cre ON Cre.CreditoID = Sal.CreditoID
		INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
		LEFT JOIN CLIENTES Cli ON Cli.ClienteID = Sal.ClienteID
		LEFT JOIN CLIDATSOCIOE CliEco ON CliEco.ClienteID = Cli.ClienteID
		LEFT JOIN NOMINAEMPLEADOS NomiEmp ON NomiEmp.ClienteID = Cli.ClienteID
		LEFT OUTER JOIN HISCREDITOSVENTACAR Vta ON Vta.CreditoID = Cre.CreditoID
		AND Vta.Fecha < Par_Fecha AND Vta.Tipo = 'PROCESADO'
        WHERE (FechaCorte = Par_Fecha
        AND ( Cli.TipoPersona = "A"
          OR  Cli.TipoPersona = "F" )
         AND Cre.Estatus != 'C')
         OR (FechaCorte BETWEEN Var_FechaInicio AND Par_Fecha AND Sal.EstatusCredito='P' AND Cli.TipoPersona IN ("F","A")) -- CS JCENTENO tkt 12116
		AND Vta.CreditoID IS NULL
        GROUP BY Sal.CreditoID;
        
		UPDATE TMPREPCIRCULO AS TEMPCIR
        INNER JOIN TMPDATOSCLI AS TEMPDCLI ON TEMPCIR.CreditoID = TEMPDCLI.CreditoID
        SET TEMPCIR.Monto = TEMPDCLI.Monto,
        TEMPCIR.FechaIngreso = TEMPDCLI.FechaIngreso
        WHERE TEMPCIR.CreditoID = TEMPDCLI.CreditoID;
		
END IF;

-- Reporte Mensual
IF( Par_TipoReporte = Reporte_Mensual ) THEN
  -- RLAVIDA_CS_T_12040 SE condiciona para que esta parte solo se ejecute para el cliente crediclub ya que se solicito en su ticket
  SET Var_ClienteEspecifico := (SELECT IFNULL(ValorParametro,Con_ClienteCRCB)
                    FROM PARAMGENERALES
                    WHERE LlaveParametro = 'CliProcEspecifico');

  IF (Var_ClienteEspecifico = Con_ClienteCRCB) THEN
    -- JCENTENO CS 10435  inicio
    SET Var_FechIniMensual := (SELECT SUBDATE(Par_Fecha, DAYOFMONTH(Par_Fecha) - 1));
    SET Var_FechAntMensual := (SELECT DATE_SUB(Par_Fecha,interval 1 DAY));

    DROP TEMPORARY TABLE IF EXISTS TMPCSCREDPAG;
    CREATE TEMPORARY TABLE TMPCSCREDPAG
    SELECT
    MAX(cre.CreditoID) AS CreditoID,MAX(cre.ProductoCreditoID) AS ProductoCreditoID,
    MAX(cre.Estatus) AS Estatus,cl.TipoPersona,MAX(cre.FechTerminacion) AS FechTerminacion,
    MAX(cre.FechaVencimien) AS FechaVencimien, MAX(cl.ClienteID) AS ClienteID
    FROM
    CREDITOS cre INNER JOIN
    SALDOSCREDITOS sal ON cre.CreditoID=sal.CreditoID
    INNER JOIN CLIENTES cl ON cre.ClienteID=cl.ClienteID
    WHERE cre.FechTerminacion BETWEEN Var_FechIniMensual AND Var_FechAntMensual
    AND cre.Estatus='P'
    GROUP BY cre.CreditoID;

    ALTER TABLE TMPCSCREDPAG ADD INDEX(CreditoID);
    ALTER TABLE TMPCSCREDPAG ADD INDEX(FechTerminacion);
    ALTER TABLE TMPCSCREDPAG ADD INDEX(Estatus);

    -- Llenado de la tabla TMPREPCIRCULO creditos pagados en el transcurso del mes
    INSERT INTO TMPREPCIRCULO
        SELECT Sal.CreditoID, Aud_NumTransaccion, Sal.ClienteID,    Cli.SucursalOrigen,
               SUBSTRING(IFNULL(ApellidoPaterno, Cadena_Vacia), 1, 30) AS ApellidoPaterno,
               SUBSTRING(IFNULL(ApellidoMaterno, Cadena_Vacia), 1, 30) AS ApellidoMaterno,
               SUBSTRING(CONCAT(IFNULL(PrimerNombre, Cadena_Vacia),
                      CASE WHEN IFNULL(SegundoNombre, Cadena_Vacia) != Cadena_Vacia THEN
                          CONCAT(' ', SegundoNombre) ELSE Cadena_Vacia
                      END,
                      CASE WHEN IFNULL(TercerNombre, Cadena_Vacia) != Cadena_Vacia THEN
                           CONCAT(' ', TercerNombre) ELSE Cadena_Vacia
                      END),  1, 50) AS Nombre,

                CONVERT(IFNULL(FechaNacimiento, Fecha_Vacia), CHAR) AS FechaNac,
                SUBSTRING(RFCOficial, 1, 13) AS RFC, SUBSTRING(CURP, 1, 18) AS CURP,
                "MX" AS Nacion,
                CASE
                    WHEN EstadoCivil = "S" THEN "S"
                    WHEN EstadoCivil = "U" THEN "L"
                    WHEN EstadoCivil = "SE" THEN "E"
                    WHEN EstadoCivil = "D" THEN "D"
                    WHEN EstadoCivil = "V" THEN "V"
                    WHEN EstadoCivil = "CS" OR EstadoCivil = "CM"  OR EstadoCivil = "CC" THEN "C"
                    ELSE Cadena_Vacia
                END AS Edocivil,

                CASE
                    WHEN Sov.TipoViviendaID = 1 OR Sov.TipoViviendaID = 5 THEN "1"
                    WHEN Sov.TipoViviendaID = 2 OR Sov.TipoViviendaID = 6 OR Sov.TipoViviendaID = 9 THEN "2"
                    WHEN Sov.TipoViviendaID = 4 OR Sov.TipoViviendaID = 8 THEN "3"
                    WHEN Sov.TipoViviendaID = 3 OR Sov.TipoViviendaID = 7 THEN "4"
                    ELSE ""
                END AS TipoResidencia,
                Cli.Sexo, "PF" AS TipoPersona,
                "", "", "", "", "",
                REPLACE(REPLACE(REPLACE(REPLACE(IFNULL(Cli.Telefono,Cadena_Vacia) ,"-",""), ")", ""), "(", ""), " ", ""),
                "",
                CASE
            WHEN IFNULL(Cli.LugardeTrabajo, Cadena_Vacia) = Cadena_Vacia AND (Cli.OcupacionID = 20 OR Cli.OcupacionID = 21 ) THEN
                'Labores de Hogar'
            WHEN IFNULL(Cli.LugardeTrabajo, Cadena_Vacia) = Cadena_Vacia AND (Cli.OcupacionID = 30 OR Cli.OcupacionID = 62 OR Cli.OcupacionID = 99 ) THEN
                'Desempleado'
            WHEN  IFNULL(Cli.LugardeTrabajo, Cadena_Vacia) = Cadena_Vacia AND (Cli.OcupacionID = 40 OR Cli.OcupacionID = 41 OR Cli.OcupacionID = 42 OR Cli.OcupacionID = 43 ) THEN
                        'Estudiante'
                     WHEN IFNULL(Cli.LugardeTrabajo, Cadena_Vacia) = Cadena_Vacia AND (Cli.OcupacionID = 50 OR Cli.OcupacionID = 51 OR Cli.OcupacionID = 52 OR Cli.OcupacionID = 53 OR Cli.OcupacionID = 54 ) THEN
                        'Jubilados'
                     WHEN IFNULL(Cli.LugardeTrabajo, Cadena_Vacia) = Cadena_Vacia THEN
                        'Trabajador Independiente'
                     WHEN IFNULL(Cli.LugardeTrabajo, Cadena_Vacia) != Cadena_Vacia THEN
                         Cli.LugardeTrabajo
                END AS LugardeTrabajo,
                "", "","","","",
                REPLACE(REPLACE(REPLACE(REPLACE(IFNULL(Cli.TelTrabajo,Cadena_Vacia),"-",""), ")", ""), "(", ""), " ", ""),
                SUBSTRING(LTRIM(RTRIM(IFNULL(Cli.Puesto, Cadena_Vacia))), 1, 30),


                Res_Titular,

                IFNULL(Des.ClaveCirculoCredito, Con_Otros),

                Mon_Pesos,  Pagos_Fijos, Cre.NumAmortizacion,
                CASE
                    WHEN Cre.FrecuenciaCap != Fre_Semestral AND Cre.FrecuenciaCap != Fre_Tetrameste
                         AND COALESCE(Pro.EsRevolvente,No_Revolvente) = No_Revolvente THEN
                         Cre.FrecuenciaCap
                    WHEN (Cre.FrecuenciaCap = Fre_Semestral OR Cre.FrecuenciaCap = Fre_Tetrameste)
                         AND COALESCE(Pro.EsRevolvente,No_Revolvente) = No_Revolvente THEN
                        Fre_Mensual
                    WHEN  COALESCE(Pro.EsRevolvente,No_Revolvente) = SI_Revolvente THEN
                        Fre_Revolvente
                END,
                (Sal.SalCapVigente + Sal.SalCapAtrasado +
                 Sal.SalCapVencido + Sal.SalCapVenNoExi),

                (Sal.SalCapAtrasado + Sal.SalCapVencido),

                (Sal.SalIntAtrasado + Sal.SalIntVencido +
                 Sal.SalIntProvision + Sal.SalIntNoConta),

                (Sal.SalIntAtrasado + Sal.SalIntVencido),

                (Sal.SalMoratorios + Sal.SaldoMoraVencido + Sal.SaldoMoraCarVen),
                (Sal.SalComFaltaPago + Sal.SaldoComServGar + SalOtrasComisi),

                Entero_Cero, Entero_Cero,   Cli.PagaIVA,  Pro.CobraIVAInteres,  Pro.CobraIVAMora,


                (Sal.SalCapVigente + Sal.SalCapAtrasado + Sal.SalCapVencido + Sal.SalCapVenNoExi) +
                (Sal.SalIntAtrasado + Sal.SalIntVencido + Sal.SalIntProvision + Sal.SalIntNoConta) +
                (Sal.SalMoratorios + Sal.SaldoMoraVencido + Sal.SaldoMoraCarVen) + (Sal.SalComFaltaPago + Sal.SaldoComServGar + SalOtrasComisi),


                (Sal.SalCapAtrasado + Sal.SalCapVencido) +
                (Sal.SalIntAtrasado + Sal.SalIntVencido) +
                (Sal.SalMoratorios + Sal.SaldoMoraVencido + Sal.SaldoMoraCarVen) + (Sal.SalComFaltaPago + Sal.SaldoComServGar + SalOtrasComisi),


                Cre.MontoCuota, Cre.FechaInicio,
                Cadena_Vacia,  Sal.NoCuotasAtraso,

                CASE
                    WHEN Sal.EstatusCredito = Est_Pagado THEN
                        CONVERT(IFNULL(Cre.FechTerminacion, Par_Fecha), CHAR)
                    ELSE Cadena_Vacia
                END,

                CASE
                     WHEN Sal.NoCuotasAtraso = Entero_Cero THEN
                            Pago_Vigente
                     WHEN Sal.NoCuotasAtraso > Entero_Cero AND Sal.NoCuotasAtraso < 84 THEN
                            LPAD(CONVERT(Sal.NoCuotasAtraso, CHAR), 2, '0')
                     ELSE '84'
                END,
                Cadena_Vacia,   Cadena_Vacia,           Entero_Cero,        Cadena_Vacia,   Cadena_Vacia,
                Entero_Cero,    Cadena_Vacia,           Cre.MontoCredito,   Cadena_Vacia,   Sal.EstatusCredito,
                Cadena_Vacia,   Cre.TipoPagoCapital,    Entero_Cero,        Entero_Cero,    Entero_Cero,
                Cre.MontoCredito, IFNULL(Cre.SolicitudCreditoID,Entero_Cero),'MX' AS OrigenDomicilio,
                'MX' AS RazonSocialDomicilio,
                    CASE WHEN Cre.FechTraspasVenc != Fecha_Vacia AND Cre.FechTraspasVenc < Par_Fecha THEN
                      Cre.FechTraspasVenc
                ELSE Cadena_Vacia
            END
                ,Cadena_Vacia,Cadena_Vacia,Entero_Cero,Cli.Correo,
                CASE WHEN  IFNULL(Cli.LugardeTrabajo, Cadena_Vacia) = Cadena_Vacia THEN
                        'N'
                    ELSE
                        'S'
                END AS TieneEmpleo,
        		Cadena_Vacia AS FechaDefuncion,
        		Cadena_Vacia AS IdicadorDef

            FROM SALDOSCREDITOS Sal
            INNER JOIN CREDITOS Cre ON Cre.CreditoID = Sal.CreditoID
        INNER JOIN TMPCSCREDPAG tmpcs   ON tmpcs.CreditoID=Cre.CreditoID   -- Agrega temporal con creditos pagados en el trancurso del mes.
            INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
            LEFT OUTER JOIN DESTINOSCREDITO Des ON Cre.DestinoCreID = Des.DestinoCreID
            LEFT OUTER JOIN CLIENTES Cli ON Cli.ClienteID = Sal.ClienteID
            LEFT OUTER JOIN SOCIODEMOVIVIEN Sov ON Sov.ClienteID = Sal.ClienteID
            LEFT OUTER JOIN DIRECCLIENTE Dir ON Dir.ClienteID = Sal.ClienteID
                                             AND Dir.Oficial = 'S'
            WHERE Sal.FechaCorte = tmpcs.FechTerminacion
            and  Cli.TipoPersona in("A","F")
             AND Cre.Estatus != 'C';
    -- Fin JCENTENO CS 10435
  END IF;-- FIN RLAVIDA CS T_12040

  SET Var_FechaInicio :=  DATE_FORMAT(Par_Fecha,'%Y-%m-01');  -- CS tkt 12116
  INSERT INTO TMPREPCIRCULO
    SELECT DISTINCT Sal.CreditoID, Aud_NumTransaccion, Sal.ClienteID,    Cli.SucursalOrigen,
           SUBSTRING(IFNULL(ApellidoPaterno, Cadena_Vacia), 1, 30) AS ApellidoPaterno,
           SUBSTRING(IFNULL(ApellidoMaterno, Cadena_Vacia), 1, 30) AS ApellidoMaterno,
           SUBSTRING(CONCAT(IFNULL(PrimerNombre, Cadena_Vacia),
                  CASE WHEN IFNULL(SegundoNombre, Cadena_Vacia) != Cadena_Vacia THEN
                      CONCAT(' ', SegundoNombre) ELSE Cadena_Vacia
                  END,
                  CASE WHEN IFNULL(TercerNombre, Cadena_Vacia) != Cadena_Vacia THEN
                       CONCAT(' ', TercerNombre) ELSE Cadena_Vacia
                  END),  1, 50) AS Nombre,

            CONVERT(IFNULL(FechaNacimiento, Fecha_Vacia), CHAR) AS FechaNac,
            SUBSTRING(RFCOficial, 1, 13) AS RFC, SUBSTRING(CURP, 1, 18) AS CURP,
            "MX" AS Nacion,
            CASE
                WHEN EstadoCivil = "S" THEN "S"
                WHEN EstadoCivil = "U" THEN "L"
                WHEN EstadoCivil = "SE" THEN "E"
                WHEN EstadoCivil = "D" THEN "D"
                WHEN EstadoCivil = "V" THEN "V"
                WHEN EstadoCivil = "CS" OR EstadoCivil = "CM"  OR EstadoCivil = "CC" THEN "C"
                ELSE Cadena_Vacia
            END AS Edocivil,

            CASE
                WHEN Sov.TipoViviendaID = 1 OR Sov.TipoViviendaID = 5 THEN "1"
                WHEN Sov.TipoViviendaID = 2 OR Sov.TipoViviendaID = 6 OR Sov.TipoViviendaID = 9 THEN "2"
                WHEN Sov.TipoViviendaID = 4 OR Sov.TipoViviendaID = 8 THEN "3"
                WHEN Sov.TipoViviendaID = 3 OR Sov.TipoViviendaID = 7 THEN "4"
                ELSE ""
            END AS TipoResidencia,
            Cli.Sexo, "PF" AS TipoPersona,
            "", "", "", "", "",
            REPLACE(REPLACE(REPLACE(REPLACE(IFNULL(Cli.Telefono,Cadena_Vacia) ,"-",""), ")", ""), "(", ""), " ", ""),
            "",
            CASE
        WHEN IFNULL(Cli.LugardeTrabajo, Cadena_Vacia) = Cadena_Vacia AND (Cli.OcupacionID = 20 OR Cli.OcupacionID = 21 ) THEN
            'Labores de Hogar'
        WHEN IFNULL(Cli.LugardeTrabajo, Cadena_Vacia) = Cadena_Vacia AND (Cli.OcupacionID = 30 OR Cli.OcupacionID = 62 OR Cli.OcupacionID = 99 ) THEN
            'Desempleado'
        WHEN  IFNULL(Cli.LugardeTrabajo, Cadena_Vacia) = Cadena_Vacia AND (Cli.OcupacionID = 40 OR Cli.OcupacionID = 41 OR Cli.OcupacionID = 42 OR Cli.OcupacionID = 43 ) THEN
                    'Estudiante'
                 WHEN IFNULL(Cli.LugardeTrabajo, Cadena_Vacia) = Cadena_Vacia AND (Cli.OcupacionID = 50 OR Cli.OcupacionID = 51 OR Cli.OcupacionID = 52 OR Cli.OcupacionID = 53 OR Cli.OcupacionID = 54 ) THEN
                    'Jubilados'
                 WHEN IFNULL(Cli.LugardeTrabajo, Cadena_Vacia) = Cadena_Vacia THEN
                    'Trabajador Independiente'
                 WHEN IFNULL(Cli.LugardeTrabajo, Cadena_Vacia) != Cadena_Vacia THEN
                     Cli.LugardeTrabajo
            END AS LugardeTrabajo,
            "", "","","","",
            REPLACE(REPLACE(REPLACE(REPLACE(IFNULL(Cli.TelTrabajo,Cadena_Vacia),"-",""), ")", ""), "(", ""), " ", ""),
            SUBSTRING(LTRIM(RTRIM(IFNULL(Cli.Puesto, Cadena_Vacia))), 1, 30),


            Res_Titular,

            CASE WHEN Cre.EsConsolidado = ConsSI THEN
                ConsConsolidado
            ELSE
                IFNULL(Des.ClaveCirculoCredito, Con_Otros)  END,

            Mon_Pesos,  Pagos_Fijos, Cre.NumAmortizacion,
            CASE
                WHEN Cre.FrecuenciaCap != Fre_Semestral AND Cre.FrecuenciaCap != Fre_Tetrameste
                     AND COALESCE(Pro.EsRevolvente,No_Revolvente) = No_Revolvente THEN
                     Cre.FrecuenciaCap
                WHEN (Cre.FrecuenciaCap = Fre_Semestral OR Cre.FrecuenciaCap = Fre_Tetrameste)
                     AND COALESCE(Pro.EsRevolvente,No_Revolvente) = No_Revolvente THEN
                    Fre_Mensual
                WHEN  COALESCE(Pro.EsRevolvente,No_Revolvente) = SI_Revolvente THEN
                    Fre_Revolvente
            END,
            (Sal.SalCapVigente + Sal.SalCapAtrasado +
             Sal.SalCapVencido + Sal.SalCapVenNoExi),

            (Sal.SalCapAtrasado + Sal.SalCapVencido),

            (Sal.SalIntAtrasado + Sal.SalIntVencido +
             Sal.SalIntProvision + Sal.SalIntNoConta),

            (Sal.SalIntAtrasado + Sal.SalIntVencido),

            (Sal.SalMoratorios + Sal.SaldoMoraVencido + Sal.SaldoMoraCarVen),
            (Sal.SalComFaltaPago + Sal.SaldoComServGar + SalOtrasComisi),

            Entero_Cero, Entero_Cero,   Cli.PagaIVA,  Pro.CobraIVAInteres,  Pro.CobraIVAMora,


            (Sal.SalCapVigente + Sal.SalCapAtrasado + Sal.SalCapVencido + Sal.SalCapVenNoExi) +
            (Sal.SalIntAtrasado + Sal.SalIntVencido + Sal.SalIntProvision + Sal.SalIntNoConta) +
            (Sal.SalMoratorios + Sal.SaldoMoraVencido + Sal.SaldoMoraCarVen) + (Sal.SalComFaltaPago + Sal.SaldoComServGar + SalOtrasComisi),


            (Sal.SalCapAtrasado + Sal.SalCapVencido) +
            (Sal.SalIntAtrasado + Sal.SalIntVencido) +
            (Sal.SalMoratorios + Sal.SaldoMoraVencido + Sal.SaldoMoraCarVen) + (Sal.SalComFaltaPago +  Sal.SaldoComServGar + SalOtrasComisi),


            Cre.MontoCuota, Cre.FechaInicio,
            Cadena_Vacia,  Sal.NoCuotasAtraso,

            CASE
                WHEN Sal.EstatusCredito = Est_Pagado THEN
                    CONVERT(IFNULL(Cre.FechTerminacion, Par_Fecha), CHAR)
                ELSE Cadena_Vacia
            END,

            CASE
                 WHEN Sal.NoCuotasAtraso = Entero_Cero THEN
                        Pago_Vigente
                 WHEN Sal.NoCuotasAtraso > Entero_Cero AND Sal.NoCuotasAtraso < 84 THEN
                        LPAD(CONVERT(Sal.NoCuotasAtraso, CHAR), 2, '0')
                 ELSE '84'
            END,
            Cadena_Vacia,   Cadena_Vacia,           Entero_Cero,        Cadena_Vacia,   Cadena_Vacia,
            Entero_Cero,    Cadena_Vacia,           Cre.MontoCredito,   Cadena_Vacia,   Sal.EstatusCredito,
            Cadena_Vacia,   Cre.TipoPagoCapital,    Entero_Cero,        Entero_Cero,    Entero_Cero,
            Cre.MontoCredito, IFNULL(Cre.SolicitudCreditoID,Entero_Cero),'MX' AS OrigenDomicilio,
            'MX' AS RazonSocialDomicilio,
                CASE WHEN Cre.FechTraspasVenc != Fecha_Vacia AND Cre.FechTraspasVenc < Par_Fecha THEN
                  Cre.FechTraspasVenc
            ELSE Cadena_Vacia
        END
            ,Cadena_Vacia,Cadena_Vacia,Entero_Cero,Cli.Correo,
            CASE WHEN  IFNULL(Cli.LugardeTrabajo, Cadena_Vacia) = Cadena_Vacia THEN
                    'N'
                ELSE
                    'S'
            END AS TieneEmpleo,
        Cadena_Vacia AS FechaDefuncion,
        Cadena_Vacia AS IdicadorDef,
		Entero_Cero AS Monto,
		Fecha_Vacia AS FechaIngreso

        FROM SALDOSCREDITOS Sal
        INNER JOIN CREDITOS Cre ON Cre.CreditoID = Sal.CreditoID
        INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
        LEFT OUTER JOIN DESTINOSCREDITO Des ON Cre.DestinoCreID = Des.DestinoCreID
        LEFT OUTER JOIN CLIENTES Cli ON Cli.ClienteID = Sal.ClienteID
        LEFT OUTER JOIN SOCIODEMOVIVIEN Sov ON Sov.ClienteID = Sal.ClienteID
        LEFT OUTER JOIN DIRECCLIENTE Dir ON Dir.ClienteID = Sal.ClienteID
                                         AND Dir.Oficial = 'S'

        LEFT OUTER JOIN HISCREDITOSVENTACAR Vta ON Vta.CreditoID = Cre.CreditoID
		AND Vta.Fecha < Par_Fecha AND Vta.Tipo = 'PROCESADO'
        WHERE (FechaCorte = Par_Fecha
        AND ( Cli.TipoPersona = "A"
          OR  Cli.TipoPersona = "F" )
         AND Cre.Estatus != 'C')
         OR (FechaCorte BETWEEN Var_FechaInicio AND Par_Fecha AND Sal.EstatusCredito='P' AND Cli.TipoPersona IN ("F","A")) -- CS JCENTENO tkt 12116
	 AND Vta.CreditoID IS NULL; -- CS JCENTENO tkt 12116
     
     DROP TEMPORARY TABLE IF EXISTS TMPDATOSCLI;
		CREATE TEMPORARY TABLE TMPDATOSCLI(
			`CreditoID` bigint(12) NOT NULL COMMENT 'Numero de Credito',
			`Monto` decimal(14,2) DEFAULT NULL COMMENT 'Monto capturado en pantalla',
			`FechaIngreso` date DEFAULT NULL COMMENT 'Fecha de ingreso');
		INSERT INTO TMPDATOSCLI 
		SELECT 
			Sal.CreditoID,
			IFNULL(MAX(CliEco.Monto), Entero_Cero) AS Monto,
			IFNULL(MAX(NomiEmp.FechaIngreso), Fecha_Vacia) AS FechaIngreso
		FROM SALDOSCREDITOS Sal
		INNER JOIN CREDITOS Cre ON Cre.CreditoID = Sal.CreditoID
		INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
		LEFT JOIN CLIENTES Cli ON Cli.ClienteID = Sal.ClienteID
		LEFT JOIN CLIDATSOCIOE CliEco ON CliEco.ClienteID = Cli.ClienteID
		LEFT JOIN NOMINAEMPLEADOS NomiEmp ON NomiEmp.ClienteID = Cli.ClienteID
		LEFT OUTER JOIN HISCREDITOSVENTACAR Vta ON Vta.CreditoID = Cre.CreditoID
		AND Vta.Fecha < Par_Fecha AND Vta.Tipo = 'PROCESADO'
        WHERE (FechaCorte = Par_Fecha
        AND ( Cli.TipoPersona = "A"
          OR  Cli.TipoPersona = "F" )
         AND Cre.Estatus != 'C')
         OR (FechaCorte BETWEEN Var_FechaInicio AND Par_Fecha AND Sal.EstatusCredito='P' AND Cli.TipoPersona IN ("F","A")) -- CS JCENTENO tkt 12116
		AND Vta.CreditoID IS NULL
        GROUP BY Sal.CreditoID;
        
		UPDATE TMPREPCIRCULO AS TEMPCIR
        INNER JOIN TMPDATOSCLI AS TEMPDCLI ON TEMPCIR.CreditoID = TEMPDCLI.CreditoID
        SET TEMPCIR.Monto = TEMPDCLI.Monto,
        TEMPCIR.FechaIngreso = TEMPDCLI.FechaIngreso
        WHERE TEMPCIR.CreditoID = TEMPDCLI.CreditoID;

END IF;


	-- INICIO Notas de Cargo

	DROP TEMPORARY TABLE IF EXISTS TMPEXIGIBLESNOTASCARGOCIRCULO;
	CREATE TEMPORARY TABLE TMPEXIGIBLESNOTASCARGOCIRCULO (
		CreditoID				BIGINT(12),
		Monto					DECIMAL(14,2),
		MontoExigible			DECIMAL(14,2),
		PRIMARY KEY (CreditoID)
	);

	DROP TEMPORARY TABLE IF EXISTS TMPPAGOSNOTASCARGOCIRCULO;
	CREATE TEMPORARY TABLE TMPPAGOSNOTASCARGOCIRCULO (
		CreditoID				BIGINT(12),
		Monto					DECIMAL(14,2),
		PRIMARY KEY (CreditoID)
	);

	-- Montos de notas de cargo registradas a fecha corte
	INSERT INTO TMPEXIGIBLESNOTASCARGOCIRCULO (	CreditoID,			Monto,									MontoExigible	)
									SELECT		NTC.CreditoID,		ROUND(SUM(ROUND(NTC.Monto, 2)), 2),		Entero_Cero
										FROM	NOTASCARGO NTC
										INNER JOIN TMPREPCIRCULO TMP ON TMP.CreditoID = NTC.CreditoID AND NTC.FechaRegistro <= Par_Fecha
										INNER JOIN AMORTICREDITO AMO ON AMO.CreditoID = NTC.CreditoID AND NTC.AmortizacionID = AMO.AmortizacionID AND AMO.FechaExigible <= Par_Fecha
										GROUP BY NTC.CreditoID, AMO.CreditoID;

	-- Montos pagados de notas de cargo a fechas exigibles
	INSERT INTO TMPPAGOSNOTASCARGOCIRCULO (	CreditoID,			Monto	)
								SELECT		DET.CreditoID,		ROUND(SUM(ROUND(DET.MontoNotasCargo, 2)), 2)
									FROM	TMPEXIGIBLESNOTASCARGOCIRCULO TMP
									INNER JOIN DETALLEPAGCRE DET ON DET.CreditoID = TMP.CreditoID AND DET.FechaPago <= Par_Fecha
									INNER JOIN AMORTICREDITO AMO ON DET.CreditoID = AMO.CreditoID and DET.AmortizacionID = AMO.AmortizacionID AND AMO.FechaExigible <= Par_Fecha
									GROUP BY DET.CreditoID, AMO.CreditoID;

	-- Exigible de notas de cargo a fecha corte
	UPDATE TMPEXIGIBLESNOTASCARGOCIRCULO NTC
		INNER JOIN TMPPAGOSNOTASCARGOCIRCULO PAG ON NTC.CreditoID = PAG.CreditoID
	SET	NTC.MontoExigible = ROUND(NTC.Monto - PAG.Monto, 2);

	UPDATE TMPEXIGIBLESNOTASCARGOCIRCULO
	SET	MontoExigible = Entero_Cero
	WHERE MontoExigible < Entero_Cero;

	UPDATE TMPREPCIRCULO TMP
		INNER JOIN TMPEXIGIBLESNOTASCARGOCIRCULO NTC ON NTC.CreditoID = TMP.CreditoID
	SET	TMP.Comisiones		= ROUND(TMP.Comisiones + NTC.MontoExigible, 2),
		TMP.TotalDeuda		= ROUND(TMP.TotalDeuda + NTC.MontoExigible, 2),
		TMP.TotalVencido	= ROUND(TMP.TotalVencido + NTC.MontoExigible, 2);

	DROP TEMPORARY TABLE IF EXISTS TMPPAGOSNOTASCARGOCIRCULO;
	DROP TEMPORARY TABLE IF EXISTS TMPEXIGIBLESNOTASCARGOCIRCULO;

	-- FIN Notas de Cargo


-- agrega update
-- Ticket 10044
    UPDATE TMPREPCIRCULO TMP
    INNER JOIN CREDITOS Cre ON TMP.CreditoID = Cre.CreditoID
        SET TMP.FrecuenciaPago = CASE
        WHEN Cre.FrecuenciaCap = 'P' THEN
          CASE WHEN (Cre.PeriodicidadCap/30) = 1 THEN
            'M'
          END
        WHEN Cre.FrecuenciaCap = 'L' THEN
          CASE
            -- Mensual
            WHEN (SELECT DATEDIFF(MAX(FechaVencim), MAX(FechaInicio))
                FROM AMORTICREDITO WHERE CreditoID = Cre.CreditoID AND Estatus != 'P') IN(28,29,30,31)
                                OR
              (SELECT DATEDIFF(MAX(FechaVencim), MAX(FechaInicio))
                FROM AMORTICREDITO WHERE CreditoID = Cre.CreditoID) IN(28,29,30,31) THEN
                                Fre_Mensual
            -- Bimestral
            WHEN (SELECT DATEDIFF(MIN(FechaVencim), MIN(FechaInicio))
                FROM AMORTICREDITO WHERE CreditoID = Cre.CreditoID AND Estatus != 'P') IN(60,61) THEN
                                'B'
            -- Trimestral
                        WHEN (SELECT TIMESTAMPDIFF(month,MIN(FechaInicio),  MIN(FechaVencim))
                FROM AMORTICREDITO WHERE CreditoID = Cre.CreditoID AND Estatus != 'P') = 3 THEN
                                'T'
                                -- SEMESTRAL
            WHEN (SELECT TIMESTAMPDIFF(month,MIN(FechaInicio),  MIN(FechaVencim))
                FROM AMORTICREDITO WHERE CreditoID = Cre.CreditoID AND Estatus != 'P') = 6 THEN
                                'E'
            -- Anual
            WHEN (SELECT TIMESTAMPDIFF(year,MAX(FechaInicio),  MAX(FechaVencim))
                FROM AMORTICREDITO WHERE CreditoID = Cre.CreditoID AND Estatus != 'P') = 1
              OR
                            (SELECT TIMESTAMPDIFF(year,MIN(FechaInicio),  MIN(FechaVencim))
                FROM AMORTICREDITO WHERE CreditoID = Cre.CreditoID AND Estatus != 'P') = 1

                                THEN
                'A'
            -- Una Sola Exhibición
                        WHEN (SELECT COUNT(CreditoID) FROM AMORTICREDITO WHERE CreditoID = Cre.CreditoID) IN (1,2) THEN
                'U'
            WHEN (SELECT DATEDIFF(MIN(FechaVencim), MIN(FechaInicio))
                        FROM AMORTICREDITO WHERE CreditoID = Cre.CreditoID AND Estatus != 'P' AND AmortizacionID = 2) = 14 THEN
                'C'
                        ELSE
                        TMP.FrecuenciaPago
            END
                        ELSE
          TMP.FrecuenciaPago
                    END;
    -- fin de lo agregado

    -- Actualizamos la Direccion del Cliente
    UPDATE TMPREPCIRCULO Tem, DIRECCLIENTE Dir
        LEFT JOIN COLONIASREPUB Col ON Col.ColoniaID = Dir.ColoniaID  AND Dir.MunicipioID = Col.MunicipioID AND Dir.EstadoID = Col.EstadoID
        LEFT JOIN MUNICIPIOSREPUB Mun ON Mun.EstadoID = Dir.EstadoID AND Mun.MunicipioID = Dir.MunicipioID
        LEFT JOIN ESTADOSREPUB Est ON Est.EstadoID = Dir.EstadoID
        LEFT JOIN TIPOASENTAMIENTO Tia ON Tia.TipoAsentamientoID = Col.TipoAsenta

   SET
   Tem.TipoAsentamiento = IFNULL(Tia.ClaveCirculoCre, Char_Cero),
   Tem.CalleyNumero  =
        SUBSTRING(
            CONCAT(LTRIM(RTRIM((Dir.Calle))),
                CASE WHEN RTRIM(LTRIM(IFNULL(Dir.NumeroCasa, 'SN'))) IN (Cadena_Vacia, ' SN ', '0')   THEN ' SN ' ELSE CONCAT(" NUM ", LTRIM(RTRIM(IFNULL(Dir.NumeroCasa, 'SN')))) END,
                CASE WHEN RTRIM(LTRIM(IFNULL(Dir.NumInterior, Cadena_Vacia))) IN (Cadena_Vacia, 'NA', 'SN', '0')   THEN Cadena_Vacia ELSE CONCAT(" INT ", LTRIM(RTRIM(Dir.NumInterior))) END,
                CASE WHEN RTRIM(LTRIM(IFNULL(Dir.Manzana, Cadena_Vacia))) IN (Cadena_Vacia, 'NA', 'SN', '0')   THEN Cadena_Vacia ELSE CONCAT(" MZ ", LTRIM(RTRIM(Dir.Manzana))) END,
                CASE WHEN RTRIM(LTRIM(IFNULL(Dir.Lote, Cadena_Vacia))) IN (Cadena_Vacia, 'NA', 'SN', '0')   THEN Cadena_Vacia ELSE CONCAT(" LT ", LTRIM(RTRIM(Dir.Lote))) END,
                CASE WHEN RTRIM(LTRIM(IFNULL(Dir.Piso, Cadena_Vacia))) IN (Cadena_Vacia, 'NA', 'SN', '0')   THEN Cadena_Vacia ELSE CONCAT(" PISO ", LTRIM(RTRIM(Dir.Piso))) END
                ),1,80),
    Tem.Colonia = SUBSTRING((IFNULL(Col.Asentamiento, Cadena_Vacia)),1,65),
    Tem.Municipio = SUBSTRING(RTRIM(LTRIM(IFNULL(Mun.Nombre, Cadena_Vacia))), 1, 65),
    Tem.Estado = IFNULL(Est.EqCirCre, Cadena_Vacia),
    Tem.CodigoPostal = IFNULL(Dir.CP, Cadena_Vacia),

    Tem.TipoDomicilio = CASE Dir.TipoDireccionID
                            WHEN 2 THEN 'N'
                            WHEN 3 THEN 'E'
                            else 'C'
                        END
    WHERE Tem.ClienteID = Dir.ClienteID
      AND Tem.Transaccion = Aud_NumTransaccion
      AND Dir.Oficial = 'S';


    -- Consideraciones de no tener direccion o es nulo
    UPDATE TMPREPCIRCULO Tem set
        CalleyNumero = 'NA SN'
        WHERE IFNULL(CalleyNumero, Cadena_Vacia) = Cadena_Vacia;

    -- Actualizamos los Datos del IVA y Total a Pagar
    UPDATE TMPREPCIRCULO Tem, SUCURSALES Suc SET
        Tem.TasaIVAInt = Suc.IVA,

        Tem.TotalVencido = TotalVencido +
                            ROUND(
                            (    Tem.InteresVencido *
                                    (CASE
                                        WHEN Tem.CobraIVAInt = SI_PagaIVA AND
                                              Tem.ClientePagaIVA = SI_PagaIVA THEN Suc.IVA
                                        ELSE Entero_Cero
                                        END)) +
                            (   Tem.Moratorios *
                                    (CASE
                                        WHEN Tem.CobraIVAMor = SI_PagaIVA AND
                                             Tem.ClientePagaIVA = SI_PagaIVA THEN Suc.IVA
                                        ELSE Entero_Cero
                                     END)) +

                            (   Tem.Comisiones *
                                    (CASE
                                        WHEN Tem.ClientePagaIVA = SI_PagaIVA THEN Suc.IVA
                                        ELSE Entero_Cero
                                     END) ), 2),


        Tem.TotalDeuda = Tem.TotalInteres + TotalCapital + Moratorios + Comisiones +
                        ROUND(
                        (    Tem.TotalInteres *
                                (CASE
                                    WHEN Tem.CobraIVAInt = SI_PagaIVA AND
                                          Tem.ClientePagaIVA = SI_PagaIVA THEN Suc.IVA
                                    ELSE Entero_Cero
                                    end)) +
                        (   Tem.Moratorios *
                                (CASE
                                    WHEN Tem.CobraIVAMor = SI_PagaIVA AND
                                         Tem.ClientePagaIVA = SI_PagaIVA THEN Suc.IVA
                                    ELSE Entero_Cero
                                 end)) +

                        (   Tem.Comisiones *
                                (CASE
                                    WHEN Tem.ClientePagaIVA = SI_PagaIVA THEN Suc.IVA
                                    ELSE Entero_Cero
                                 end) ), 2),

        Tem.TotalIVA =  ROUND(
                        (Tem.TotalInteres *
                                (CASE
                                    WHEN Tem.CobraIVAInt = SI_PagaIVA AND
                                          Tem.ClientePagaIVA = SI_PagaIVA THEN Suc.IVA
                                    ELSE Entero_Cero
                                    end)) +
                        (   Tem.Moratorios *
                                (CASE
                                    WHEN Tem.CobraIVAMor = SI_PagaIVA AND
                                         Tem.ClientePagaIVA = SI_PagaIVA THEN Suc.IVA
                                    ELSE Entero_Cero
                                 end)) +

                        (   Tem.Comisiones *
                                (CASE
                                    WHEN Tem.ClientePagaIVA = SI_PagaIVA THEN Suc.IVA
                                    ELSE Entero_Cero
                                 end) ), 2)

    WHERE Suc.SucursalID = Tem.SucursalID
      AND Tem.Transaccion = Aud_NumTransaccion;

       -- Agregado ticket 11510 Aeuan

    UPDATE TMPREPCIRCULO T
    SET T.MontoPagar = (SELECT ROUND(AVG(IFNULL(A.Capital,0.00)+IFNULL(A.Interes,0.00)+IFNULL(A.IvaInteres,0.00)),2) AS MontoPagar
              FROM AMORTICREDITO A WHERE A.CreditoID = T.CreditoID)
        WHERE T.MontoPagar = 0
        AND T.TotalDeuda > 0;
    -- Fin Agregado ticket 11510 Aeuan

    -- Actualizamos el monto del Pago
    UPDATE TMPREPCIRCULO Tem SET
        Tem.MontoPagar = (CASE
                            WHEN Tem.MontoPagar >= Tem.TotalDeuda THEN Tem.TotalDeuda
                            ELSE Tem.MontoPagar
                          end )
        WHERE Tem.Transaccion = Aud_NumTransaccion;

    -- Actualizamos la fehca de primer Incumplimiento
       UPDATE TMPREPCIRCULO Dat
        INNER JOIN SALDOSCREDITOS Sal ON Dat.CreditoID = Sal.CreditoID
            SET Dat.FechaPrimIncumplimiento = IFNULL(DATE_format(Sal.FechaCorte,'%Y%m%d'), Cadena_Vacia)
            WHERE Sal.salCapAtrasado <> Entero_Cero;

    -- Actualizamos la Licencia de Conducir
    UPDATE TMPREPCIRCULO Tem, IDENTIFICLIENTE Idc SET
        Tem.NumLicenciaConducir = SUBSTRING(Idc.NumIdentific,1,20)
        WHERE Tem.ClienteID = Idc.ClienteID
          AND Idc.TipoIdentiID = Iden_Licencia;

    -- Actualizamos la Credencial de Elector
    UPDATE TMPREPCIRCULO Tem, IDENTIFICLIENTE Idc SET
        Tem.ClaveElectorIFE = SUBSTRING(Idc.NumIdentific,1,20)
        WHERE Tem.ClienteID = Idc.ClienteID
          AND Idc.TipoIdentiID = Iden_Elector;

    -- Actualizamos Dependientes
    UPDATE TMPREPCIRCULO Tem SET
        Tem.NumeroDependientes = (SELECT IFNULL(COUNT(Dep.DependienteID), Entero_Cero)
                                    FROM SOCIODEMODEPEND Dep
                                    WHERE Dep.ClienteID = Tem.ClienteID);

    -- Total de Pagos Reportados
    UPDATE TMPREPCIRCULO Tem set
        Tem.NumPagosEfectuados = (SELECT IFNULL(COUNT(Amo.CreditoID), Entero_Cero)
                                    FROM AMORTICREDITO Amo
                                    WHERE Amo.CreditoID = Tem.CreditoID
                                     AND  Amo.Estatus = Est_Pagado
                                     AND FechaLiquida <= Par_Fecha);



    -- Actualizamos los Datos del Empleo
    UPDATE TMPREPCIRCULO Tem, DIRECCLIENTE Dir
        LEFT JOIN COLONIASREPUB Col ON Col.ColoniaID = Dir.ColoniaID  AND Dir.MunicipioID = Col.MunicipioID AND Dir.EstadoID = Col.EstadoID
        LEFT JOIN MUNICIPIOSREPUB Mun ON Mun.EstadoID = Dir.EstadoID AND Mun.MunicipioID = Dir.MunicipioID
        LEFT JOIN ESTADOSREPUB Est ON Est.EstadoID = Dir.EstadoID
        LEFT JOIN TIPOASENTAMIENTO Tia ON Tia.TipoAsentamientoID = Col.TipoAsenta

   SET
   Tem.TipoAsentamientoTrabajo = IFNULL(Tia.ClaveCirculoCre, Char_Cero),
   Tem.CalleyNumeroTra  =
        SUBSTRING(
            CONCAT(LTRIM(RTRIM(Dir.Calle)) ,
                CASE WHEN RTRIM(LTRIM(IFNULL(Dir.NumeroCasa, 'SN'))) IN (Cadena_Vacia, ' SN ', '0')   THEN ' SN ' ELSE CONCAT(" NUM ", LTRIM(RTRIM(ifnull(Dir.NumeroCasa, 'SN')))) END,
                CASE WHEN RTRIM(LTRIM(IFNULL(Dir.NumInterior, Cadena_Vacia))) IN (Cadena_Vacia, 'NA', 'SN', '0')   THEN Cadena_Vacia ELSE CONCAT(" INT ", LTRIM(RTRIM(Dir.NumInterior))) END,
                CASE WHEN RTRIM(LTRIM(IFNULL(Dir.Manzana, Cadena_Vacia))) IN (Cadena_Vacia, 'NA', 'SN', '0')   THEN Cadena_Vacia ELSE CONCAT(" MZ ", LTRIM(RTRIM(Dir.Manzana))) END,
                CASE WHEN RTRIM(LTRIM(IFNULL(Dir.Lote, Cadena_Vacia))) IN (Cadena_Vacia, 'NA', 'SN', '0')   THEN Cadena_Vacia ELSE CONCAT(" LT ", LTRIM(RTRIM(Dir.Lote))) END,
                CASE WHEN RTRIM(LTRIM(IFNULL(Dir.Piso, Cadena_Vacia))) IN (Cadena_Vacia, 'NA', 'SN', '0')   THEN Cadena_Vacia ELSE CONCAT(" PISO ", LTRIM(RTRIM(Dir.Piso))) END
                ),1,80),
    Tem.ColoniaTra = SUBSTRING((IFNULL(Col.Asentamiento, Cadena_Vacia)),1,65),
    Tem.MunicipioTra = SUBSTRING(RTRIM(LTRIM(IFNULL(Mun.Nombre, Cadena_Vacia))), 1, 65),
    Tem.EstadoTra = IFNULL(Est.EqCirCre, Cadena_Vacia),
    Tem.CodigoPostalTra = IFNULL(Dir.CP, Cadena_Vacia)

    WHERE Tem.ClienteID = Dir.ClienteID
      AND Tem.Transaccion = Aud_NumTransaccion
      AND Dir.TipoDireccionID = 3;           -- Tipo de Direccion del Trabajo

    -- actualizamos las direcciones de los clientes que no tienen un empleo o son propietarios
    UPDATE TMPREPCIRCULO Tem,CLIENTES Cli ,DIRECCLIENTE Dir
        LEFT JOIN COLONIASREPUB Col ON Col.ColoniaID = Dir.ColoniaID  AND Dir.MunicipioID = Col.MunicipioID AND Dir.EstadoID = Col.EstadoID
        LEFT JOIN MUNICIPIOSREPUB Mun ON Mun.EstadoID = Dir.EstadoID AND Mun.MunicipioID = Dir.MunicipioID
        LEFT JOIN ESTADOSREPUB Est ON Est.EstadoID = Dir.EstadoID
        LEFT JOIN TIPOASENTAMIENTO Tia ON Tia.TipoAsentamientoID = Col.TipoAsenta
   SET
   Tem.TipoAsentamientoTrabajo = IFNULL(Tia.ClaveCirculoCre, Char_Cero),
   Tem.CalleyNumeroTra  =
        SUBSTRING(
            CONCAT(LTRIM(RTRIM(Dir.Calle)) ,
                CASE WHEN RTRIM(LTRIM(IFNULL(Dir.NumeroCasa, 'SN'))) IN (Cadena_Vacia, ' SN ', '0')   THEN ' SN ' ELSE CONCAT(" NUM ", LTRIM(RTRIM(ifnull(Dir.NumeroCasa, 'SN')))) END,
                CASE WHEN RTRIM(LTRIM(IFNULL(Dir.NumInterior, Cadena_Vacia))) IN (Cadena_Vacia, 'NA', 'SN', '0')   THEN Cadena_Vacia ELSE CONCAT(" INT ", LTRIM(RTRIM(Dir.NumInterior))) END,
                CASE WHEN RTRIM(LTRIM(IFNULL(Dir.Manzana, Cadena_Vacia))) IN (Cadena_Vacia, 'NA', 'SN', '0')   THEN Cadena_Vacia ELSE CONCAT(" MZ ", LTRIM(RTRIM(Dir.Manzana))) END,
                CASE WHEN RTRIM(LTRIM(IFNULL(Dir.Lote, Cadena_Vacia))) IN (Cadena_Vacia, 'NA', 'SN', '0')   THEN Cadena_Vacia ELSE CONCAT(" LT ", LTRIM(RTRIM(Dir.Lote))) END,
                CASE WHEN RTRIM(LTRIM(IFNULL(Dir.Piso, Cadena_Vacia))) IN (Cadena_Vacia, 'NA', 'SN', '0')   THEN Cadena_Vacia ELSE CONCAT(" PISO ", LTRIM(RTRIM(Dir.Piso))) END
                ),1,80),
    Tem.ColoniaTra = SUBSTRING((IFNULL(Col.Asentamiento, Cadena_Vacia)),1,65),
    Tem.MunicipioTra = SUBSTRING(RTRIM(LTRIM(IFNULL(Mun.Nombre, Cadena_Vacia))), 1, 65),
    Tem.EstadoTra = IFNULL(Est.EqCirCre, Cadena_Vacia),
    Tem.CodigoPostalTra = IFNULL(Dir.CP, Cadena_Vacia)

    WHERE Tem.ClienteID = Dir.ClienteID
      AND Tem.ClienteID = Cli.ClienteID
      AND Tem.Transaccion = Aud_NumTransaccion
      AND Dir.Oficial = 'S'
      AND Cli.OcupacionID IN (20,21,30,62,99,40,41,42,43,50,51,52,53,54);

    -- Actualizamos la Fecha de Ultimo Pago
    UPDATE TMPREPCIRCULO Tem SET
        Tem.FechaUltPago = CONVERT(IFNULL( (SELECT MAX(FechaPago)
                                        FROM DETALLEPAGCRE Dep
                                        WHERE Tem.CreditoID = Dep.CreditoID
                                          AND Dep.FechaPago <= Par_Fecha ),
                                  Cadena_Vacia), CHAR)
        WHERE Tem.Transaccion = Aud_NumTransaccion;

    -- Consideracion en Dias de Gracia
    UPDATE TMPREPCIRCULO Tem SET
        Tem.NoCuotasAtraso   = Entero_Cero,
        Tem.PagoActual = Pago_Vigente
        WHERE Tem.TotalVencido   <= Entero_Cero
          AND Tem.Transaccion = Aud_NumTransaccion;

    -- Validaciones si el Credito esta Pagado
    UPDATE TMPREPCIRCULO Tem SET
        Tem.TotalCapital    = Entero_Cero,
        Tem.TotalDeuda      = Entero_Cero,
        Tem.TotalVencido    = Entero_Cero,
        Tem.MontoPagar      = Entero_Cero
        WHERE Tem.FechaCierre != Cadena_Vacia
          AND Tem.Transaccion = Aud_NumTransaccion;

    UPDATE TMPREPCIRCULO Tem SET
        Tem.TotalVencido    = Entero_Cero
        WHERE Tem.NoCuotasAtraso <= Entero_Cero
          AND Tem.Transaccion = Aud_NumTransaccion;

    -- Actualizamos el Historico de Pagos, cuando es el Primer envio o Reporte del Credito
    UPDATE TMPREPCIRCULO Tem SET
        Tem.HisPago    = Tem.PagoActual
        WHERE Tem.FechaInicio > Var_FecUltEnvio;

    SELECT COUNT(TotalDeuda), SUM(ROUND(TotalDeuda,0)), SUM(ROUND(TotalVencido,0)) INTO
            Var_SumNumElem, Var_SumSaldoTot,    Var_SumSaldoVen
        FROM TMPREPCIRCULO
        WHERE Transaccion = Aud_NumTransaccion;

    SET Var_SumNumElem  := IFNULL(Var_SumNumElem, Entero_Cero);
    SET Var_SumSaldoTot := ROUND(IFNULL(Var_SumSaldoTot, Entero_Cero), 0);
    SET Var_SumSaldoVen := ROUND(IFNULL(Var_SumSaldoVen, Entero_Cero), 0);

    SET Str_NumElementos := CONVERT(Var_SumNumElem, CHAR);
    SET Str_SumSaldoTot := CONVERT(Var_SumSaldoTot, CHAR);
    SET Str_SumSaldoVen := CONVERT(Var_SumSaldoVen, CHAR);

    -- Consideraciones de Cartera Castigada
    UPDATE TMPREPCIRCULO Tem, CRECASTIGOS Cas SET
        ClavePrevencion = Cla_Castigo,
        TotalCapital = Cas.CapitalCastigado,
        CapitalVencido = Cas.CapitalCastigado,
        TotalInteres = Cas.InteresCastigado,
        InteresVencido = Cas.InteresCastigado,

        TotalCapital= Cas.CapitalCastigado,
        TotalDeuda=Cas.CapitalCastigado+Cas.InteresCastigado,
        MontoPagar= Cas.CapitalCastigado+Cas.InteresCastigado,
        TotalVencido=Cas.CapitalCastigado+Cas.InteresCastigado,

        FechaCierre = Cas.Fecha,
        PagoActual = LPAD(CONVERT(IFNULL( (SELECT Sal.NoCuotasAtraso
                                                FROM SALDOSCREDITOS Sal
                                                WHERE Sal.CreditoID = Tem.CreditoID
                                                 AND Sal.FechaCorte = FUNCIONDIAHABILANT(Cas.Fecha,1,1))
                                                , 84), CHAR), 2, '0')
          WHERE Tem.Transaccion = Aud_NumTransaccion
            AND Tem.EstatusCredito = Est_Castigo
            AND Tem.CreditoID = Cas.CreditoID;

    UPDATE TMPREPCIRCULO Tem SET
        PagoActual = CASE
                         WHEN Tem.PagoActual = '00' THEN
                                Pago_Vigente
                         WHEN (PagoActual = Pago_Vigente) THEN
                                PagoActual 
                        WHEN CONVERT(Tem.PagoActual, unsigned) > 84 THEN
                            '84'              -- 84 Periodos de Atraso o Mas 
                    END
        WHERE Tem.Transaccion = Aud_NumTransaccion
          AND (Tem.PagoActual = '00' OR (CASE  WHEN (PagoActual = Pago_Vigente) THEN
                                0 
                        WHEN CONVERT(Tem.PagoActual, unsigned) > 0 THEN
                            Tem.PagoActual              -- 84 Periodos de Atraso o Mas 
                    END > 84) )
          AND Tem.EstatusCredito = Est_Castigo;


    -- Eliminamos carateres no validos (Puntos, Comas, Guiones , Diagonales)
    -- Estos cambios a raiz de que la informacion migrada de Sacimex incluye simbolos no permitidos y ocasionaba rechazos.

    UPDATE TMPREPCIRCULO
    SET ApellidoPaterno=replace(ApellidoPaterno,Punto,Cadena_Vacia),
            ApellidoMaterno=replace(ApellidoMaterno,Punto,Cadena_Vacia),
            Nombre=replace(Nombre,Punto,Cadena_Vacia)
     WHERE Transaccion = Aud_NumTransaccion;

    UPDATE TMPREPCIRCULO
    SET ApellidoPaterno=replace(ApellidoPaterno,Coma,Cadena_Vacia),
            ApellidoMaterno=replace(ApellidoMaterno,Coma,Cadena_Vacia),
            Nombre=replace(Nombre,Coma,Cadena_Vacia)
     WHERE Transaccion = Aud_NumTransaccion;

    UPDATE TMPREPCIRCULO
    SET ApellidoPaterno=replace(ApellidoPaterno,Guion,Cadena_Vacia),
            ApellidoMaterno=replace(ApellidoMaterno,Guion,Cadena_Vacia),
            Nombre=replace(Nombre,Guion,Cadena_Vacia)
     WHERE Transaccion = Aud_NumTransaccion;

    UPDATE TMPREPCIRCULO
    SET ApellidoPaterno=replace(ApellidoPaterno,Diagonal,Cadena_Vacia),
            ApellidoMaterno=replace(ApellidoMaterno,Diagonal,Cadena_Vacia),
            Nombre=replace(Nombre,Diagonal,Cadena_Vacia)
     WHERE Transaccion = Aud_NumTransaccion;


    -- Si el Cliente Solo trae Apellido Materno.
    update TMPREPCIRCULO Tem set
        ApellidoMaterno = 'NO PROPORCIONADO'
        where ifnull(ApellidoMaterno, Cadena_Vacia) = Cadena_Vacia;

    -- Consideraciones de no tener apellido Paterno, o que este nulo, o es igual a X
    UPDATE TMPREPCIRCULO Tem set
        ApellidoPaterno = ApellidoMaterno,
        ApellidoMaterno = 'NO PROPORCIONADO'
        WHERE (IFNULL(ApellidoPaterno, Cadena_Vacia) = Cadena_Vacia OR IFNULL(ApellidoPaterno,Cadena_Vacia) = 'X');

    -- Actualizamos la Fecha de Nacimiento a las Personas que tienen mas de 100 anos.
    UPDATE TMPREPCIRCULO Tem set
            FechaNacimiento = DATE_SUB(CURDATE(),INTERVAL 100 YEAR)
            WHERE
                TIMESTAMPDIFF(YEAR,Tem.FechaNacimiento,CURDATE())>100;


    # Obtenemos la Fecha de Ultimo Pago para obtener el monto del ultimo pago
    DROP TEMPORARY TABLE IF EXISTS TMPFECHAPAGO;
    CREATE TEMPORARY TABLE TMPFECHAPAGO (
        SELECT Dep.CreditoID, MAX(FechaPago) AS Fecha,Entero_Cero AS Monto,
                      MAX(Dep.Transaccion) AS Transaccion
            FROM  DETALLEPAGCRE Dep
                INNER JOIN TMPREPCIRCULO Tmp
                    ON Dep.CreditoID = Tmp.CreditoID
            WHERE Dep.FechaPago < Par_Fecha
            AND Tmp.Transaccion = Aud_NumTransaccion
            GROUP BY Dep.CreditoID);

    # Se obtiene el monto del ultimo pago
    DROP TEMPORARY TABLE IF EXISTS TMPMONTOPAGO;
    CREATE TEMPORARY TABLE TMPMONTOPAGO(
        SELECT Dep.CreditoID,SUM(MontoTotPago) AS MontoTotPago
        FROM DETALLEPAGCRE Dep
            INNER JOIN TMPFECHAPAGO Tmp
                ON Tmp.CreditoID = Dep.CreditoID
                  AND Dep.Transaccion = Tmp.Transaccion
            WHERE Dep.FechaPago = Tmp.Fecha
            GROUP BY Dep.CreditoID);

    # Actualizamos el monto del ultimo pago
    UPDATE TMPREPCIRCULO Tem
        INNER JOIN TMPMONTOPAGO Tmp
            ON Tem.CreditoID = Tmp.CreditoID
            SET Tem.MontoUltimoPago = Tmp.MontoTotPago
        WHERE Tem.Transaccion = Aud_NumTransaccion;

        -- Agregado ticket 11510 reestructura aeuan
UPDATE TMPREPCIRCULO T
  INNER JOIN CREDITOS C ON C.CreditoID = T.CreditoID
    SET T.FechaInicio = (SELECT IFNULL(MIN(FechaInicio), Fecha_Vacia) AS FechaInicio
              FROM AMORTICREDITO WHERE CreditoID = T.CreditoID)
  WHERE C.TipoCredito = 'R';
-- Fin Agregado ticket 11510  reestructura aeuan

    # Actualizamos el plazo en dias
    UPDATE TMPREPCIRCULO Tem SET
        Tem.PlazoMeses = IFNULL((SELECT Dias FROM CREDITOS Cre
                            INNER JOIN CREDITOSPLAZOS Pla
                            WHERE Tem.CreditoID = Cre.CreditoID
                            AND Cre.PlazoID = Pla.PlazoID),
                            Entero_Cero)
        WHERE Tem.Transaccion = Aud_NumTransaccion;

    -- Obtenemos el monto asignada de la garantia
    DROP TEMPORARY TABLE IF EXISTS TMPMONTOASIGNAGARANTIA;
    CREATE TEMPORARY TABLE TMPMONTOASIGNAGARANTIA(
    SELECT Tem.CreditoID,Tem.SolicitudCreditoID,IFNULL(ROUND(SUM(MontoAsignado),Entero_Cero),Entero_Cero) AS MontoAsignado
    FROM TMPREPCIRCULO Tem
        LEFT JOIN ASIGNAGARANTIAS Gar
            ON (Gar.CreditoID=Tem.CreditoID OR Gar.SolicitudCreditoID = Tem.SolicitudCreditoID)
                AND Gar.Estatus = Est_GarAutorizada
            WHERE Tem.TipoPagoCapital != PagoCapLibre
                AND Tem.Transaccion = Aud_NumTransaccion
            GROUP BY Tem.CreditoID, Tem.SolicitudCreditoID);

    -- Actualizamos el valor del activo de valuacion (Monto Asignado a la Garantia)
    UPDATE TMPREPCIRCULO Tem
        INNER JOIN TMPMONTOASIGNAGARANTIA Tmp
            ON Tmp.CreditoID=Tem.CreditoID
        SET Tem.ValorActivoValuacion = Tmp.MontoAsignado
            WHERE Tem.Transaccion = Aud_NumTransaccion;

    -- Obtenemos el monto de la garantia liquida
    DROP TEMPORARY TABLE IF EXISTS TMPMONTOGARANTIALIQ;
    CREATE TEMPORARY TABLE TMPMONTOGARANTIALIQ(
    SELECT Tem.CreditoID,IFNULL(ROUND(SUM(MontoBloq),Entero_Cero),Entero_Cero) AS MontoGarantia
    FROM TMPREPCIRCULO Tem
        LEFT JOIN  BLOQUEOS Blo
        ON Tem.CreditoID = Blo.Referencia
            AND NatMovimiento = NatMovBloqueo
            AND TiposBloqID IN (BloqGarLiq,BloqGarLiqAdi)
                AND FolioBloq = Entero_Cero
        WHERE Tem.TipoPagoCapital != PagoCapLibre
            AND Tem.Transaccion = Aud_NumTransaccion
        GROUP BY Tem.CreditoID);

    -- Actualizamos el valor del activo de valuacion (Monto Garantia Liquida)
    UPDATE TMPREPCIRCULO Tem
        INNER JOIN TMPMONTOGARANTIALIQ Tmp
            ON Tmp.CreditoID=Tem.CreditoID
        SET Tem.ValorActivoValuacion = Tem.ValorActivoValuacion + Tmp.MontoGarantia
            WHERE Tem.Transaccion = Aud_NumTransaccion;

    -- Obtenemos el monto de la garantia en inversiones
    DROP TEMPORARY TABLE IF EXISTS TMPMONTOGARANTIAINV;
    CREATE TEMPORARY TABLE TMPMONTOGARANTIAINV(
    SELECT Tem.CreditoID,IFNULL(ROUND(SUM(MontoEnGar),Entero_Cero),Entero_Cero) AS MontoGarantiaInv
    FROM TMPREPCIRCULO Tem
        LEFT JOIN CREDITOINVGAR Inc
        ON Tem.CreditoID = Inc.CreditoID
        LEFT JOIN INVERSIONES Inv
        ON Inv.InversionID = Inc.InversionID
                AND Inv.Estatus = Est_InverVig
        WHERE Tem.TipoPagoCapital != PagoCapLibre
            AND Tem.Transaccion = Aud_NumTransaccion
        GROUP BY Tem.CreditoID);

    -- Actualizamos el valor del activo de valuacion (Monto Garantia Inversion)
    UPDATE TMPREPCIRCULO Tem
        INNER JOIN TMPMONTOGARANTIAINV Tmp
            ON Tmp.CreditoID=Tem.CreditoID
        SET Tem.ValorActivoValuacion = Tem.ValorActivoValuacion + Tmp.MontoGarantiaInv
            WHERE Tem.Transaccion = Aud_NumTransaccion;

    -- Actualizamos el Pago Actual (SALDO VENCIDO es igual a cero  el PAGO ACTUAL debe ser igual a V)
    UPDATE TMPREPCIRCULO Tem
        SET Tem.NoCuotasAtraso = Entero_Cero,
            Tem.PagoActual     = Pago_Vigente
        WHERE
            Tem.EstatusCredito      = Est_Vigente
        AND ROUND(Tem.TotalVencido) = Entero_Cero
        AND Tem.PagoActual          <> Pago_Vigente
        AND NoCuotasAtraso          <> Entero_Cero
        AND Tem.Transaccion         = Aud_NumTransaccion;

    DROP TEMPORARY TABLE IF EXISTS CSTMPREPCIRCULO;
    CREATE temporary TABLE CSTMPREPCIRCULO
        SELECT  MAX(TMPRC.CreditoID) as CreditoID,
            datediff(MAX(AMOR.FechaVencim),MAX(AMOR.FechaInicio)) as FrecuenciaPago
      FROM TMPREPCIRCULO TMPRC
          INNER JOIN AMORTICREDITO AMOR ON TMPRC.CreditoID=AMOR.CreditoID
      GROUP BY AMOR.CreditoID;

    UPDATE TMPREPCIRCULO  TMPRC INNER JOIN CSTMPREPCIRCULO ACT
        ON TMPRC.CreditoID=ACT.CreditoID
    SET TMPRC.FrecuenciaPago=
        CASE WHEN ACT.FrecuenciaPago=7 THEN 'S'
         WHEN ACT.FrecuenciaPago=14 THEN 'C'
         WHEN ACT.FrecuenciaPago=15 THEN 'Q'
         WHEN ACT.FrecuenciaPago=30 THEN 'M'
         WHEN ACT.FrecuenciaPago=60 THEN 'B'
         WHEN ACT.FrecuenciaPago=90 THEN 'T'
         WHEN ACT.FrecuenciaPago=365 THEN 'A'
         -- IALDANA
         WHEN ACT.FrecuenciaPago IN(31, 29, 28, 27) THEN 'M'
         WHEN (SELECT COUNT(CreditoID) FROM AMORTICREDITO WHERE CreditoID = TMPRC.CreditoID) THEN 'U'
        END
        WHERE TMPRC.FrecuenciaPago='P';

    UPDATE TMPREPCIRCULO SET
      PagoActual='V'
    WHERE TotalVencido < 1;

    UPDATE TMPREPCIRCULO
    SET FrecuenciaPago="A" WHERE FrecuenciaPago="L";  
	
    	-- T_14691 by hussein chan inicia
    
     DROP TABLE IF EXISTS TMPNUMPAGCASCIN;

	CREATE TABLE TMPNUMPAGCASCIN
    SELECT Cre.CreditoID, COUNT(Amo.AmortizacionID) AS NumPag
      FROM AMORTICREDITO Amo, CRECASTIGOS Cre
    WHERE Amo.CreditoID = Cre.CreditoID
      AND Amo.FechaLiquida = Cre.Fecha
      AND Cre.Fecha <= Par_Fecha
      GROUP BY Cre.CreditoID;

  UPDATE TMPREPCIRCULO Cre, TMPNUMPAGCASCIN Pag
    SET Cre.PagoActual = Pag.NumPag,
		Cre.NoCuotasAtraso = Pag.NumPag
  WHERE Cre.CreditoID = Pag.CreditoID;
	
    DROP TABLE IF EXISTS TMPNUMPAGCASCIN;
  
	-- T_14691 by hussein chan termina
  
    UPDATE TMPREPCIRCULO set
    TotalCapital=0,
    TotalVencido=0,
    TotalDeuda=0
    WHERE
	CONVERT(ROUND(TotalDeuda, Entero_Cero), CHAR)=Entero_Cero AND
	CONVERT(ROUND(MontoPagar, Entero_Cero), CHAR)=Entero_Cero AND
    CONVERT(ROUND(TotalCapital, Entero_Cero), CHAR)=Entero_Cero AND
    CONVERT(ROUND(TotalVencido, Entero_Cero), CHAR)=Entero_Cero;


    -- CS JCENTENO 11111
    UPDATE TMPREPCIRCULO set
    CentroTrabajo='Trabajador Independiente'
    WHERE CentroTrabajo='0';

	-- CS JCENTENO 11111
     UPDATE TMPREPCIRCULO Tem  INNER JOIN CREDITOS Cre
     ON Tem.CreditoID=Cre.CreditoID AND Cre.NumAmortizacion=1
     SET Tem.MontoPagar=Cre.MontoCredito
     WHERE Tem.MontoPagar=Entero_Cero AND Cre.Estatus NOT IN ('P');  -- CS JCENTENO tkt 12116  exceptua los pagados

  -- CS JCENTENO 11111
     UPDATE TMPREPCIRCULO Tem  INNER JOIN CREDITOS Cre
     ON Tem.CreditoID=Cre.CreditoID AND Cre.NumAmortizacion=1
     SET Tem.MontoPagar=Cre.MontoCredito
     WHERE Tem.MontoPagar=Entero_Cero;

    -- CS JCENTENO tkt 11111
    UPDATE TMPREPCIRCULO Rep
    INNER JOIN TMPCIRCULOCREDSALDOSCERO Tmp ON Rep.CreditoID = Tmp.CreditoID
    SET
    	CapitalVencido=0,
    	InteresVencido=0,
    	TotalVencido=0;

      -- CS JCENTENO tkt 12116 excluye creditos que no tienen vida
      DELETE FROM  TMPREPCIRCULO WHERE
      EstatusCredito='P' AND
      FechaCierre=FechaInicio AND
      FechaUltPago=FechaCierre AND
      FechaUltPago=FechaInicio;


    UPDATE TMPREPCIRCULO TMP, CARCREDITOSUSPENDIDO CC
        SET TMP.FechaDefuncion = REPLACE(DATE_FORMAT(CC.FechaDefuncion, "%d-%m-%Y"),'-',''),
            TMP.IndicadorDef = Var_IdicadorDef,
            TMP.ClavePrevencion = Cla_Castigo
        WHERE Estatus = Var_EstatusDef
            AND CC.CreditoID = TMP.CreditoID;
			
 
    SELECT  CreditoID,                                              ApellidoPaterno,                                            IFNULL(ApellidoMaterno,Cadena_Vacia) AS ApellidoMaterno,
            Cadena_Vacia AS ApellidoAdicional,                      IFNULL(Nombre,Cadena_Vacia) AS Nombre,                      IFNULL(FechaNacimiento,Cadena_Vacia) AS FechaNacimiento,
            RFC,                                                    IFNULL(CURP,Cadena_Vacia) AS CURP,                          Cadena_Vacia AS NumeroSeguridadSocial,
            Nacionalidad,                                           IFNULL(EstadoCivil,Cadena_Vacia)AS EstadoCivil,             IFNULL(TipoResidencia,Cadena_Vacia) AS TipoResidencia,
            Sexo,                                                   TipoPersona,                                                IFNULL(CalleYNumero,Cadena_Vacia) AS CalleYNumero,
            IFNULL(Colonia,Cadena_Vacia) AS Colonia,                IFNULL(Municipio,Cadena_Vacia)AS Municipio,                 Estado,
            IFNULL(CodigoPostal,Cadena_Vacia)AS CodigoPostal,       IFNULL(TelefonoDom,Cadena_Vacia) AS TelefonoDom,            IFNULL(TipoDomicilio,Cadena_Vacia) AS TipoDomicilio,
            IFNULL(CentroTrabajo,Cadena_Vacia) AS CentroTrabajo,    IFNULL(CalleYNumeroTra,Cadena_Vacia)AS CalleYNumeroTra,     IFNULL(ColoniaTra,Cadena_Vacia) AS ColoniaTra,
            IFNULL(MunicipioTra,Cadena_Vacia) AS MunicipioTra,      IFNULL(EstadoTra,Cadena_Vacia) AS EstadoTra,                IFNULL(CodigoPostalTra,Cadena_Vacia) AS CodigoPostalTra,
            IFNULL(TelefonoTra,Cadena_Vacia) AS TelefonoTra,        IFNULL(PuestoTra,Cadena_Vacia) AS PuestoTra,                IFNULL(TipoRespons,Cadena_Vacia) AS TipoRespons,
            IFNULL(TipoContrato,Cadena_Vacia) AS TipoContrato,      IFNULL(Moneda,Cadena_Vacia) AS Moneda,                      IFNULL(TipoCuenta,Cadena_Vacia)AS TipoCuenta,
            IFNULL(FrecuenciaPago,Cadena_Vacia) AS FrecuenciaPago,  CONVERT(FechaInicio, CHAR) AS FechaInicio,                  IFNULL(FechaUltPago,Cadena_Vacia) AS FechaUltPago,
            IFNULL(PagoActual,Cadena_Vacia) AS PagoActual,          IFNULL(CONVERT(NumAmortizacion, CHAR),Cadena_Vacia) AS NumAmortizacion,         CONVERT(ROUND(TotalCapital, Entero_Cero), CHAR) AS TotalCapital,
            CONVERT(ROUND(TotalDeuda, Entero_Cero), CHAR) AS TotalDeuda,    CONVERT(ROUND(MontoPagar, Entero_Cero), CHAR) AS MontoPagar,
            CONVERT(NoCuotasAtraso, CHAR) AS NoCuotasAtraso,                CONVERT(ROUND(TotalVencido, Entero_Cero), CHAR) AS TotalVencido,
            IFNULL(FechaCierre,Cadena_Vacia) AS FechaCierre,                IFNULL(NumLicenciaConducir,Cadena_Vacia) AS NumLicenciaConducir ,
            IFNULL(ClaveElectorIFE,Cadena_Vacia) AS ClaveElectorIFE,        CONVERT(NumeroDependientes, CHAR) AS NumDependientes,       TipoAsentamiento,           TipoAsentamientoTrabajo,
            CONVERT(NumPagosEfectuados, CHAR) AS NumPagosReportados,        IFNULL(HisPago,Cadena_Vacia) AS HisPago,                    IFNULL(Var_DirecSuc,Cadena_Vacia) AS DireccionMatriz,
            Str_NumElementos AS NumElementos,                               Str_SumSaldoTot AS SumSaldoTot,                             Str_SumSaldoVen AS SumSaldoVen,
            CONVERT(ROUND(CreditoMaximo,Entero_Cero), CHAR) AS CreditoMaximo,   IFNULL(NumCreditoAnterior,Cadena_Vacia)AS NumCreditoAnterior,       ClavePrevencion,
            CASE WHEN ValorActivoValuacion = Entero_Cero THEN Cadena_Vacia ELSE ROUND(ValorActivoValuacion, Entero_Cero) END AS ValorActivoValuacion,
            CASE WHEN MontoUltimoPago = Entero_Cero THEN Entero_Cero ELSE ROUND(MontoUltimoPago, Entero_Cero) END AS MontoUltimoPago,   PlazoMeses,
            CASE WHEN MontoCreditoOriginacion = Entero_Cero THEN Cadena_Vacia ELSE ROUND(MontoCreditoOriginacion, Entero_Cero) END AS MontoCreditoOriginacion, OrigenDomicilio,
            RazonSocialDomicilio,   FechaCarteraVencida,    FormaPAgoInteres,   DiasVencimiento,    IFNULL(CorreoElectronico,Cadena_Vacia) AS CorreoElectronico ,TotalInteres,
            FechaPrimIncumplimiento AS FechaPrimerIncumplimiento, FechaDefuncion, IndicadorDef, Monto, FechaIngreso
        FROM TMPREPCIRCULO
        WHERE Transaccion = Aud_NumTransaccion;


    DELETE FROM TMPREPCIRCULO
        WHERE Transaccion = Aud_NumTransaccion;

END TerminaStore$$