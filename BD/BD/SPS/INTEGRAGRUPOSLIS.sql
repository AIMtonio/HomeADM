-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INTEGRAGRUPOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `INTEGRAGRUPOSLIS`;DELIMITER $$

CREATE PROCEDURE `INTEGRAGRUPOSLIS`(
    Par_GrupoID         INT,
    Par_CicloGrupo      INT,

    Par_NumLis          TINYINT UNSIGNED,

    Par_EmpresaID       INT,
    Aud_Usuario         INT,
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT,
    Aud_NumTransaccion  BIGINT

	)
TerminaStore: BEGIN

/*  Declaracion de Variables   */
DECLARE Var_CicloActual     INT;

DECLARE Var_PermitePrepago  CHAR(1);
DECLARE Var_ProrrateoPago   CHAR(1);
DECLARE Var_ModificarPrepago CHAR(1);
DECLARE Var_TipoPrepago     CHAR(1);
DECLARE Var_INE             INT;

-- Declaracion de constantes
DECLARE Cadena_Vacia    	CHAR(1);
DECLARE Fecha_Vacia     	DATE;
DECLARE Entero_Cero    		INT;
DECLARE Decimal_Cero		DECIMAL(12,2);
DECLARE Str_SI          	CHAR(1);
DECLARE Str_NO          	CHAR(1);
DECLARE Esta_Activo     	CHAR(1);
DECLARE Esta_Vencido    	CHAR(1);
DECLARE Esta_Vigente    	CHAR(1);

DECLARE Si_Prorratea    	CHAR(1);
DECLARE Anticipado  		CHAR(1);
DECLARE Deduccion  			CHAR(1);
DECLARE Financiamiento  	CHAR(1);

DECLARE Lis_Principal       INT;
DECLARE Lis_AltaCred        INT;
DECLARE Lis_InsGrupo        INT;
DECLARE Lis_SolCGrupal      INT;
DECLARE Lis_SolMesaControl  INT;
DECLARE Lis_Integra         INT;
DECLARE Lis_IntegRev        INT;
DECLARE Lis_IntPagoAdela    INT;
DECLARE Lis_CuentaPrin      INT;
DECLARE Lis_CambioCondCal	INT;
DECLARE Lis_IntegraGrupo	INT;		-- Lista todos los integrantes de un grupo
DECLARE Lis_IntSoliGrupo	INT;
DECLARE Lis_CambioPuestoGpo	INT;
DECLARE Lis_Cancelacion		INT(11);
DECLARE Lis_Contrato        INT; -- Lista para regresar los datos requeridos en el contrato grupal CONSOL
DECLARE No_Asignada			CHAR(1);
DECLARE Si_PagaIVA			CHAR(1);
DECLARE Cre_Inactivo		CHAR(1);
DECLARE Cre_Autorizado		CHAR(1);
DECLARE Cre_Vigente			CHAR(1);
DECLARE Cre_Pagado			CHAR(1);
DECLARE Cre_Cancelado		CHAR(1);
DECLARE Cre_Vencido			CHAR(1);
DECLARE Cre_Castigado		CHAR(1);
DECLARE Cre_InactivoDes		CHAR(15);
DECLARE Cre_AutorizadoDes	CHAR(15);
DECLARE Cre_VigenteDes		CHAR(15);
DECLARE Cre_PagadoDes		CHAR(15);
DECLARE Cre_CanceladoDes	CHAR(15);
DECLARE Cre_VencidoDes		CHAR(15);
DECLARE Cre_CastigadoDes	CHAR(15);
DECLARE Int_StaActivo           CHAR(1);
DECLARE Int_StaRechazado        CHAR(1);




-- Asignacion de constantes
SET Cadena_Vacia            := '';
SET Fecha_Vacia             := '1900-01-01';
SET Entero_Cero             := 0;
SET Decimal_Cero			:= 0.0;
SET Str_SI                  := 'S';
SET Str_NO                  := 'N';

SET Var_INE         := 1;
SET Esta_Activo             := 'A';             -- Estatus del Integrante: Activo
SET Esta_Vencido            := 'B';             -- Estatus del Credito: Vencido
SET Esta_Vigente            := 'V';             -- Estatus del Credito: Vigente

SET Si_Prorratea            := 'S';	            -- Si Prorratea el Pago Grupal
SET Anticipado  			:= 'A';
SET Deduccion  				:= 'D';
SET Financiamiento  		:= 'F';

SET Lis_Principal           := 1;               -- Lista: Principal
SET Lis_AltaCred            := 2;               -- Lista: para Alta de Credito
SET Lis_InsGrupo            := 3;               -- Lista: Instrumentacion del Grupo: Pagare, Desembolso
SET Lis_SolCGrupal          := 4;               -- Lista: Solicitud de Credito Grupal
SET Lis_SolMesaControl      := 5;               -- Lista: Creditos para Mesa de Control Grupal
SET Lis_Integra             := 6;               -- Tipo de Lista: Integrantes del Grupo
SET Lis_IntegRev            := 7;               -- Lista: Integrantes Reversa Desembolso
SET Lis_IntPagoAdela        := 8;               -- Lista: Integrantes deposito Garantia Liquida Adicional Ventanilla
SET Lis_CuentaPrin          := 9;
SET Lis_CambioCondCal		:= 10;				-- Lista de integrantes Para cambio de Condiciones de Calendario de Pagos
SET Lis_IntegraGrupo		:= 11;
SET Lis_IntSoliGrupo        := 12;  			-- Tipo de Lista: Integrantes del Grupo con Solicitudes Liberadas
SET Lis_CambioPuestoGpo     := 13;  			-- Tipo de Lista: Cambio de Puesto Integrantes Grupo
SET Lis_Cancelacion			:= 14;  			-- Tipo de Lista: Cancelacion de Créditos
SET Lis_Contrato            := 15; -- Lista para regresar los datos requeridos en el contrato grupal CONSOL
SET No_Asignada				:= 'N';
SET Si_PagaIVA				:= 'S';

SET Cre_Inactivo			:= 'I';
SET Cre_Autorizado			:= 'A';
SET Cre_Vigente				:= 'V';
SET Cre_Pagado				:= 'P';
SET Cre_Cancelado			:= 'C';
SET Cre_Vencido				:= 'B';
SET Cre_Castigado			:= 'K';
SET Cre_InactivoDes			:= 'INACTIVO';
SET Cre_AutorizadoDes		:= 'AUTORIZADO';
SET Cre_VigenteDes			:= 'VIGENTE';
SET Cre_PagadoDes			:= 'PAGADO';
SET Cre_CanceladoDes		:= 'CANCELADO';
SET Cre_VencidoDes			:= 'VENCIDO';
SET Cre_CastigadoDes		:= 'CASTIGADO';

SET Int_StaActivo           := 'A';     -- Integrante del Grupo: Activo
SET Int_StaRechazado        := 'R';     -- Integrante del Grupo: Rechazado


-- Lista Principal usada en Asignacion de Integrantes al Grupo
IF(Par_NumLis = Lis_Principal) THEN
    SELECT I.SolicitudCreditoID,
            CASE WHEN  I.ClienteID <> 0 AND I.ProspectoID = 0 THEN
                C.NombreCompleto
            ELSE CASE WHEN  I.ClienteID = 0 AND I.ProspectoID <> 0 THEN
                P.NombreCompleto
            ELSE CASE WHEN  I.ClienteID <> 0 AND I.ProspectoID <> 0 THEN
                C.NombreCompleto
            END
            END
            END AS Nombre,
            I.ClienteID,    I.ProspectoID,  Sol.ProductoCreditoID,
            FORMAT(Sol.MontoSolici,2),
            FORMAT(Sol.MontoAutorizado,2),
			I.Cargo,
			C.Sexo,
			C.EstadoCivil

    FROM SOLICITUDCREDITO Sol
    INNER JOIN INTEGRAGRUPOSCRE I ON Sol.SolicitudCreditoID = I.SolicitudCreditoID
    LEFT OUTER JOIN CLIENTES C ON I.ClienteID = C.ClienteID
    LEFT OUTER JOIN PROSPECTOS P ON I.ProspectoID = P.ProspectoID
    WHERE I.GrupoID = Par_GrupoID;
END IF;

-- Lista para grid de pantalla de alta de credito grupal
IF(Par_NumLis = Lis_AltaCred) THEN
    SELECT  Sol.SolicitudCreditoID, Sol.ClienteID,      Cte.NombreCompleto,     Sol.ProductoCreditoID,
            Sol.MontoAutorizado,    Sol.FechaInicio,  Sol.FechaVencimiento,   Sol.CreditoID,
            Sol.FechaRegistro
		FROM	SOLICITUDCREDITO Sol,
				INTEGRAGRUPOSCRE Inte,
				CLIENTES  Cte
			WHERE	Sol.SolicitudCreditoID = Inte.SolicitudCreditoID
           AND Cte.ClienteID = Sol.ClienteID
           AND Sol.ClienteID = Inte.ClienteID
           AND Inte.Estatus = Esta_Activo
           AND Inte.GrupoID  = Par_GrupoID;

END IF;

-- Lista para Instrumentacion del Credito Grupal
-- Utilizada en Pagare Grupal y Desembolso Grupal
IF(Par_NumLis = Lis_InsGrupo) THEN

SELECT Cre.ProductoCreditoID, PCr.PermitePrepago, PCr.ModificarPrepago ,  PCr.ProrrateoPago
 INTO  Entero_Cero,           Var_PermitePrepago, Var_ModificarPrepago,   Var_ProrrateoPago

        FROM INTEGRAGRUPOSCRE Inte,
             SOLICITUDCREDITO Sol,
             CREDITOS Cre,
              PRODUCTOSCREDITO PCr
    WHERE Inte.GrupoID	= Par_GrupoID
    AND Cre.ClienteID = Sol.ClienteID
    AND Sol.ClienteID = Inte.ClienteID
    AND Sol.SolicitudCreditoID = Inte.SolicitudCreditoID
    AND Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
    AND Inte.Estatus = Esta_Activo
    AND Cre.ProductoCreditoID =  PCr.ProducCreditoID LIMIT 1;

        IF ( Var_PermitePrepago ='S') THEN
            IF(Var_ProrrateoPago = 'N') THEN
                IF(Var_ModificarPrepago = 'S')THEN
                    SET Var_TipoPrepago= 'S';
                ELSE
                      SET Var_TipoPrepago= 'N';
                END IF;
             ELSE
                  SET Var_TipoPrepago= 'N';
            END IF;
         ELSE
              SET Var_TipoPrepago= 'N';
        END IF;

    SELECT  Cre.CreditoID,      Cre. ClienteID,     Cte.NombreCompleto, Cre.ProductoCreditoID,
            Cre.MontoCredito,   Cre.FechaInicio,    Cre.FechaVencimien, Cre.Estatus, Cre.TipoPrepago,Var_TipoPrepago AS MostrarTipoPrepago
        FROM INTEGRAGRUPOSCRE Inte,
             CLIENTES  Cte,
             SOLICITUDCREDITO Sol,
             CREDITOS Cre
    WHERE Inte.GrupoID	= Par_GrupoID
    AND Cre.ClienteID = Sol.ClienteID
    AND Sol.ClienteID = Inte.ClienteID
    AND Sol.SolicitudCreditoID = Inte.SolicitudCreditoID
    AND Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
    AND Cte.ClienteID = Cre.ClienteID
    AND Inte.Estatus = Esta_Activo;

END IF;

-- Lista para grid de pantalla solicitud de credito grupal
IF(Par_NumLis = Lis_SolCGrupal) THEN
    SELECT  Inte.SolicitudCreditoID AS Solicitud,
            Sol.CreditoID AS Credito,
            Sol.ProductoCreditoID AS Producto,
            Prod.Descripcion AS ProductoDescri,
            Inte.ProspectoID AS Prospecto,
            Inte.ClienteID AS Cliente,
            Sol.MontoSolici AS MontoSolici,
            Sol.MontoAutorizado AS MontoAutorizado,
            Sol.FechaInicio AS FechaInicio,
            Sol.FechaVencimiento AS FechaVencimiento,
            Sol.Estatus AS SolEstatus,
            Inte.Estatus AS IntegEstatus,
            Inte.Cargo AS IntegCargo,
            CASE WHEN IFNULL(Inte.ClienteID, Entero_Cero) > 0 THEN  Cli.NombreCompleto
                                                             ELSE	  Pro.NombreCompleto
            END AS ClienteNombre,
            Sol.ComentarioEjecutivo AS ComentarioEjecutivo,
            Prod.RequiereGarantia AS RequiereGarantia,
            Prod.RequiereAvales AS RequiereAvales,
            Prod.PerAvaCruzados AS PerAvaCruzados,
            Prod.PerGarCruzadas AS PerGarCruzadas,
			CASE WHEN IFNULL(Inte.ClienteID, Entero_Cero) > 0 THEN  Cli.Sexo
                                                             ELSE	  Pro.Sexo
            END AS Sexo,
			CASE WHEN IFNULL(Inte.ClienteID, Entero_Cero) > 0 THEN  Cli.EstadoCivil
                                                             ELSE	  Pro.EstadoCivil
            END AS EstadoCivil, Ciclo
		FROM SOLICITUDCREDITO Sol
		INNER JOIN INTEGRAGRUPOSCRE Inte ON Sol.SolicitudCreditoID = Inte.SolicitudCreditoID
      LEFT JOIN PRODUCTOSCREDITO Prod ON Prod.ProducCreditoID  = Sol.ProductoCreditoID
		LEFT OUTER JOIN CLIENTES Cli ON Inte.ClienteID = Cli.ClienteID
		LEFT OUTER JOIN PROSPECTOS Pro ON Inte.ProspectoID = Pro.ProspectoID
		WHERE Inte.GrupoID = Par_GrupoID;

END IF;


-- Lista de Creditos para Grid de Pantalla de Mesa de Control Grupal
IF(Par_NumLis = Lis_SolMesaControl) THEN

    SELECT	DISTINCT (Cre.CreditoID),   Cre. ClienteID,	    Cli.NombreCompleto, Sol.ProductoCreditoID,
            Cre.MontoCredito,	         Cre.FechaInicio,	 Cre.FechaVencimien,
            CASE WHEN IFNULL((CheckL.DocAceptado), Str_SI) = Str_NO THEN Str_NO
                                                                    ELSE Str_SI
            END AS CredCheckComp,
            Cre.Estatus,                Cre.CuentaID,       Sol.ComentarioMesaControl
        FROM INTEGRAGRUPOSCRE Inte
        INNER JOIN SOLICITUDCREDITO Sol ON Sol.SolicitudCreditoID = Inte.SolicitudCreditoID
        INNER JOIN CREDITOS Cre ON Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
        INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID
        LEFT JOIN CREDITODOCENT CheckL ON Cre.CreditoID  = CheckL.CreditoID AND CheckL.DocAceptado = Str_NO
        WHERE Inte.GrupoID	= Par_GrupoID
          AND Inte.Estatus  = Esta_Activo;

END IF;

/* Lista de Integrantes Activos con su Cuenta de Ahorro, para Cobranza Automatica */
IF(Par_NumLis = Lis_Integra) THEN

    SELECT CicloActual INTO Var_CicloActual
        FROM 	GRUPOSCREDITO
        WHERE GrupoID = Par_GrupoID;

    SET Var_CicloActual := IFNULL(Var_CicloActual, Entero_Cero);

    -- Verificamos el Ciclo del Grupo, Si es el Ciclo Actual o si es un Ciclo Anterior
    -- Entonces Buscamos los Integrantes en el Historico
    IF(Par_CicloGrupo = Var_CicloActual) THEN
        SELECT  Cre.CreditoID,  CuentaID
            FROM INTEGRAGRUPOSCRE Ing,
                 SOLICITUDCREDITO Sol,
                 CREDITOS Cre
            WHERE Ing.GrupoID               = Par_GrupoID
              AND Ing.Estatus               = Esta_Activo
              AND Ing.ProrrateaPago         = Si_Prorratea
              AND Ing.SolicitudCreditoID    = Sol.SolicitudCreditoID
              AND Sol.CreditoID             = Cre.CreditoID
              AND	(   Cre.Estatus		= Esta_Vigente
                   OR  Cre.Estatus		= Esta_Vencido	 );
    ELSE
        SELECT  Cre.CreditoID,  CuentaID
            FROM `HIS-INTEGRAGRUPOSCRE` Ing,
                 SOLICITUDCREDITO Sol,
                 CREDITOS Cre
            WHERE Ing.GrupoID               = Par_GrupoID
              AND Ing.Ciclo                = Par_CicloGrupo
              AND Ing.Estatus               = Esta_Activo
              AND Ing.ProrrateaPago         = Si_Prorratea
              AND Ing.SolicitudCreditoID    = Sol.SolicitudCreditoID
              AND Sol.CreditoID             = Cre.CreditoID
              AND	(   Cre.Estatus		= Esta_Vigente
                   OR  Cre.Estatus		= Esta_Vencido	 );
    END IF;

END IF;

/*Lista para los Integrantes de la Reversa de Desembolso
y para pago de gl adicional en ventanilla */
IF(Par_NumLis = Lis_IntegRev) THEN

    SELECT CicloActual INTO Var_CicloActual
        FROM 	GRUPOSCREDITO
        WHERE GrupoID = Par_GrupoID;

    SET Var_CicloActual := IFNULL(Var_CicloActual, Entero_Cero);

    -- Verificamos el Ciclo del Grupo, Si es el Ciclo Actual o si es un Ciclo Anterior
    -- Entonces Buscamos los Integrantes en el Historico
    IF(Par_CicloGrupo = Var_CicloActual) THEN
        SELECT  Cre.CreditoID,  Cre.CuentaID,    Cre. ClienteID,     Cte.NombreCompleto, Inte.Cargo,
                FUNCIONCONPAGOANTCRE(Cre.CreditoID)
            FROM INTEGRAGRUPOSCRE Inte,
                 CLIENTES  Cte,
                 SOLICITUDCREDITO Sol,
                 CREDITOS Cre
        WHERE Inte.GrupoID	= Par_GrupoID
        AND Cre.ClienteID = Sol.ClienteID
        AND Sol.ClienteID = Inte.ClienteID
        AND Sol.SolicitudCreditoID = Inte.SolicitudCreditoID
        AND Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
        AND Cte.ClienteID = Cre.ClienteID
        AND Inte.Estatus = Esta_Activo;
    ELSE
        SELECT  Cre.CreditoID,  Cre.CuentaID,    Cre. ClienteID,     Cte.NombreCompleto, Inte.Cargo,
                FUNCIONCONPAGOANTCRE(Cre.CreditoID)
            FROM `HIS-INTEGRAGRUPOSCRE` Inte,
                 CLIENTES  Cte,
                 SOLICITUDCREDITO Sol,
                 CREDITOS Cre
        WHERE Inte.GrupoID	= Par_GrupoID
        AND Inte.Ciclo      = Par_CicloGrupo
        AND Cre.ClienteID = Sol.ClienteID
        AND Sol.ClienteID = Inte.ClienteID
        AND Sol.SolicitudCreditoID = Inte.SolicitudCreditoID
        AND Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
        AND Cte.ClienteID = Cre.ClienteID
        AND Inte.Estatus = Esta_Activo;
    END IF;

END IF;

/*Lista para los Integrantes de pago por adelantado o finiquito
en ventanilla */
IF(Par_NumLis = Lis_IntPagoAdela) THEN

    SELECT CicloActual INTO Var_CicloActual
        FROM 	GRUPOSCREDITO
        WHERE GrupoID = Par_GrupoID;

    SET Var_CicloActual := IFNULL(Var_CicloActual, Entero_Cero);

    -- Verificamos el Ciclo del Grupo, Si es el Ciclo Actual o si es un Ciclo Anterior
    -- Entonces Buscamos los Integrantes en el Historico
    IF(Par_CicloGrupo = Var_CicloActual) THEN
        SELECT  Cre.CreditoID,  Cre.CuentaID,    Cre. ClienteID,     Cte.NombreCompleto, Inte.Cargo,
                FUNCIONCONFINIQCRE(Cre.CreditoID) AS AdeudoTotal
            FROM INTEGRAGRUPOSCRE Inte,
                 CLIENTES  Cte,
                 SOLICITUDCREDITO Sol,
                 CREDITOS Cre
        WHERE Inte.GrupoID	= Par_GrupoID
        AND Cre.ClienteID = Sol.ClienteID
        AND Sol.ClienteID = Inte.ClienteID
        AND Sol.SolicitudCreditoID = Inte.SolicitudCreditoID
        AND Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
        AND Cte.ClienteID = Cre.ClienteID
        AND Inte.Estatus = Esta_Activo;
    ELSE
        SELECT  Cre.CreditoID,  Cre.CuentaID,    Cre. ClienteID,     Cte.NombreCompleto, Inte.Cargo,
                FUNCIONCONFINIQCRE(Cre.CreditoID) AS AdeudoTotal
            FROM `HIS-INTEGRAGRUPOSCRE` Inte,
                 CLIENTES  Cte,
                 SOLICITUDCREDITO Sol,
                 CREDITOS Cre
        WHERE Inte.GrupoID	= Par_GrupoID
        AND Inte.Ciclo      = Par_CicloGrupo
        AND Cre.ClienteID = Sol.ClienteID
        AND Sol.ClienteID = Inte.ClienteID
        AND Sol.SolicitudCreditoID = Inte.SolicitudCreditoID
        AND Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
        AND Cte.ClienteID = Cre.ClienteID
        AND Inte.Estatus = Esta_Activo;
    END IF;

END IF;


-- Consulta si el cliente cuenta con una cuenta principal
IF(Par_NumLis = Lis_CuentaPrin) THEN
    SELECT Inte.ClienteID,
           CASE WHEN Ctas.Estatus = 'A' THEN 'Activo'
                WHEN Ctas.Estatus IS NULL THEN 'Cancel' END AS Estatus
            FROM INTEGRAGRUPOSCRE Inte
            INNER JOIN CLIENTES Cli ON Inte.ClienteID = Cli.ClienteID
            LEFT JOIN CUENTASAHO Ctas ON Inte.ClienteID = Ctas.ClienteID
            AND Ctas.EsPrincipal = 'S' AND Ctas.Estatus = 'A'
            WHERE Inte.GrupoID = Par_GrupoID AND Inte.Estatus = Int_StaActivo;
END IF;


-- Lista para grid de pantalla solicitud de credito grupal
IF(Par_NumLis = Lis_CambioCondCal) THEN
SET @montoCompuesto = Decimal_Cero;
    SELECT  Inte.SolicitudCreditoID AS Solicitud,	Inte.ProspectoID AS Prospecto,	Inte.ClienteID AS Cliente,
			Sol.MontoSolici AS MontoSolici,			Sol.Estatus AS SolEstatus,		Inte.Estatus AS IntegEstatus,
    		Inte.Cargo AS IntegCargo,       		CASE WHEN IFNULL(Inte.ClienteID, Entero_Cero) > 0 THEN
														Cli.NombreCompleto
														ELSE	  Pro.NombreCompleto  END AS ClienteNombre,		Sol.MontoSeguroVida AS MontoSeguroVida,
			Sol.ForCobroSegVida, @montoCompuesto := MontoSolici,

					CASE WHEN ForCobroSegVida = Financiamiento THEN
						@montoCompuesto := MontoSolici - MontoSeguroVida
						WHEN ForCobroSegVida = Deduccion	THEN
						@montoCompuesto := MontoSolici
						WHEN ForCobroSegVida = Anticipado	THEN
						@montoCompuesto := MontoSolici END AS MontoCalculado,

				   CASE WHEN ForCobroComAper = Financiamiento THEN
						@montoCompuesto := @montoCompuesto - MontoPorComAper - IVAComAper
						WHEN ForCobroComAper = Deduccion	THEN
						@montoCompuesto := @montoCompuesto + MontoPorComAper + IVAComAper
						WHEN ForCobroComAper = Anticipado	THEN
						@montoCompuesto := @montoCompuesto
						WHEN IFNULL(ForCobroComAper, Cadena_Vacia) = Cadena_Vacia	THEN
						@montoCompuesto := @montoCompuesto END AS MontoOriginal,

			Sol.ForCobroComAper AS ForCobroComAper ,
			(Sol.MontoPorComAper+Sol.IVAComAper) AS MontoComIva, Sol.Estatus AS Estatus,	IFNULL(Cli.CalificaCredito,No_Asignada) AS CalificaCredito,
			CASE WHEN IFNULL(Inte.ClienteID, Entero_Cero) > 0 THEN
														Cli.PagaIVA
														ELSE	  Si_PagaIVA  END AS PagaIVA
		FROM SOLICITUDCREDITO Sol
		INNER JOIN INTEGRAGRUPOSCRE Inte ON Sol.SolicitudCreditoID = Inte.SolicitudCreditoID
		LEFT OUTER JOIN CLIENTES Cli ON Inte.ClienteID = Cli.ClienteID
		LEFT OUTER JOIN PROSPECTOS Pro ON Inte.ProspectoID = Pro.ProspectoID
		WHERE Inte.GrupoID = Par_GrupoID;
END IF;


# Lista todos los integrantes de un grupo que tengan registrado un credito en el ciclo actual del grupo
IF(Par_NumLis = Lis_IntegraGrupo) THEN
    SELECT Cre.CreditoID,		Inte.SolicitudCreditoID,		Inte.ClienteID,		Cli.NombreCompleto,			Cre.MontoCredito,
		   Cre.FechaInicio,		Cre.FechaVencimien,
		   CASE Cre.Estatus
				WHEN Cre_Inactivo 	THEN Cre_InactivoDes
				WHEN Cre_Autorizado THEN Cre_AutorizadoDes
				WHEN Cre_Vigente 	THEN Cre_VigenteDes
				WHEN Cre_Pagado 	THEN Cre_PagadoDes
				WHEN Cre_Cancelado 	THEN Cre_CanceladoDes
				WHEN Cre_Vencido	THEN Cre_VencidoDes
				WHEN Cre_Castigado	THEN Cre_CastigadoDes
				ELSE Cadena_Vacia
		   END AS Estatus
            FROM INTEGRAGRUPOSCRE Inte
				 INNER JOIN SOLICITUDCREDITO Sol ON Inte.SolicitudCreditoID = Sol.SolicitudCreditoID
				 LEFT JOIN CREDITOS Cre ON Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
				 LEFT OUTER JOIN CLIENTES Cli ON Inte.ClienteID = Cli.ClienteID
            WHERE Inte.GrupoID = Par_GrupoID;
END IF;


-- Lista para grid de pantalla autorizacion de solicitud grupal
IF(Par_NumLis = Lis_IntSoliGrupo) THEN
      SELECT  Inte.SolicitudCreditoID AS Solicitud,
            Sol.ProductoCreditoID AS Producto,
            Inte.ProspectoID AS Prospecto,
            Inte.ClienteID AS Cliente,
            Sol.MontoSolici AS MontoSolicitado,
			Sol.AporteCliente AS AporteCliente,
            Sol.FechaVencimiento AS FechaVencimiento,
            Sol.Estatus AS Estatus,
            CASE WHEN IFNULL(Inte.ClienteID, Entero_Cero) > 0 THEN  Cli.NombreCompleto
                                                             ELSE	  Pro.NombreCompleto
            END AS ClienteNombre,
			Prom.NombrePromotor AS NombrePromotor,
			Suc.NombreSucurs AS NombreSucursal,
            Sol.ComentarioEjecutivo AS ComentarioEjecutivo,
			UPPER(Cre.Descripcion) AS Descripcion,
			Sol.MontoAutorizado AS MontoAutorizado, IFNULL(Esq.EsquemaID,Entero_Cero) AS EsquemaID
		FROM SOLICITUDCREDITO Sol
		INNER JOIN GRUPOSCREDITO Gru ON Gru.GrupoID=Sol.GrupoID
		INNER JOIN INTEGRAGRUPOSCRE Inte ON Sol.SolicitudCreditoID = Inte.SolicitudCreditoID
      LEFT JOIN PRODUCTOSCREDITO Prod ON Prod.ProducCreditoID  = Sol.ProductoCreditoID
		LEFT OUTER JOIN CLIENTES Cli ON Inte.ClienteID = Cli.ClienteID
		LEFT OUTER JOIN PROSPECTOS Pro ON Inte.ProspectoID = Pro.ProspectoID
		LEFT OUTER JOIN PROMOTORES Prom ON Prom.PromotorID = Sol.PromotorID
		LEFT OUTER JOIN SUCURSALES Suc ON Suc.SucursalID = Sol.SucursalID
        LEFT OUTER JOIN CREDITOSPLAZOS Cre ON Cre.PlazoID = Sol.PlazoID
        LEFT OUTER JOIN ESQUEMAAUTORIZA Esq ON Esq.ProducCreditoID	= Prod.ProducCreditoID
			AND  (Sol.MontoSolici >= Esq.MontoInicial
			AND Sol.MontoSolici <= Esq.MontoFinal)
			AND Gru.CicloActual BETWEEN Esq.CicloInicial AND Esq.CicloFinal
		WHERE Inte.GrupoID = Par_GrupoID
			AND Gru.CicloActual = Par_CicloGrupo;



END IF;

-- Lista para grid de pantalla Cambio de Puesto Integrantes de Grupo
IF(Par_NumLis = Lis_CambioPuestoGpo) THEN
SELECT  Inte.GrupoID,Inte.SolicitudCreditoID AS Solicitud,
            Sol.ProductoCreditoID AS Producto,
            Inte.ProspectoID AS Prospecto,
            Inte.ClienteID AS Cliente,
            CASE WHEN IFNULL(Inte.ClienteID, Entero_Cero) > 0 THEN  Cli.NombreCompleto
				ELSE Pro.NombreCompleto END AS Nombre,
            Sol.MontoSolici AS MontoSolicitado,
			Sol.MontoAutorizado AS MontoAutorizado,
			Sol.FechaInicio AS FechaInicio,
            Sol.FechaVencimiento AS FechaVencimiento,
            Sol.Estatus AS EstatusSolicitud,
			IFNULL(Cre.CreditoID,Cadena_Vacia) AS Credito,
			IFNULL(Cre.Estatus,Cadena_Vacia) AS EstatusCredito,
			Inte.Cargo AS Cargo, Cre.pagareImpreso, Cre.MontoCredito
		FROM SOLICITUDCREDITO Sol
		INNER JOIN INTEGRAGRUPOSCRE Inte ON Sol.SolicitudCreditoID = Inte.SolicitudCreditoID
      LEFT JOIN PRODUCTOSCREDITO Prod ON Prod.ProducCreditoID  = Sol.ProductoCreditoID
		LEFT OUTER JOIN CLIENTES Cli ON Inte.ClienteID = Cli.ClienteID
		LEFT OUTER JOIN PROSPECTOS Pro ON Inte.ProspectoID = Pro.ProspectoID
		LEFT OUTER JOIN CREDITOS Cre ON Cre.SolicitudCreditoID = Sol.SolicitudCreditoID
		WHERE Inte.GrupoID = Par_GrupoID;

END IF;
IF(Par_NumLis = Lis_Cancelacion) THEN
	SELECT CicloActual INTO Var_CicloActual
        FROM 	GRUPOSCREDITO
        WHERE GrupoID = Par_GrupoID;
	SET Var_CicloActual := IFNULL(Var_CicloActual, Entero_Cero);

    -- Verificamos el Ciclo del Grupo, Si es el Ciclo Actual o si es un Ciclo Anterior
    -- Entonces Buscamos los Integrantes en el Historico
    IF(Par_CicloGrupo = Var_CicloActual) THEN
        SELECT CRED.CreditoID,INTE.ClienteID,CLI.NombreCompleto,CRED.MontoCredito, FNTOTALINTERESCREDITO(CRED.CreditoID) AS Interes,
			CRED.AporteCliente AS MontoGarantia,
			CRED.ComAperPagado AS MontoComApertura,
			'0' AS IVAComisionApert,
			CRED.Estatus
			FROM INTEGRAGRUPOSCRE AS INTE
				INNER JOIN SOLICITUDCREDITO AS SOL ON INTE.SolicitudCreditoID = SOL.SolicitudCreditoID
				INNER JOIN CREDITOS AS CRED ON SOL.SolicitudCreditoID = CRED.SolicitudCreditoID
				INNER JOIN CLIENTES AS CLI ON CRED.ClienteID = CLI.ClienteID
				WHERE CRED.GrupoID = Par_GrupoID;
	ELSE
		SELECT CRED.CreditoID,INTE.ClienteID,CLI.NombreCompleto,CRED.MontoCredito, FNTOTALINTERESCREDITO(CRED.CreditoID) AS Interes,
			CRED.AporteCliente AS MontoGarantia,
			CRED.ComAperPagado AS MontoComApertura,
			'0' AS IVAComisionApert,
			CRED.Estatus
			FROM `HIS-INTEGRAGRUPOSCRE` AS INTE
				INNER JOIN SOLICITUDCREDITO AS SOL ON INTE.SolicitudCreditoID = SOL.SolicitudCreditoID
				INNER JOIN CREDITOS AS CRED ON SOL.SolicitudCreditoID = CRED.SolicitudCreditoID
				INNER JOIN CLIENTES AS CLI ON CRED.ClienteID = CLI.ClienteID
				WHERE CRED.GrupoID = Par_GrupoID
					AND INTE.Ciclo = Par_CicloGrupo;
	END IF;
END IF;
-- Lista para contrato CONSOL
IF(Par_NumLis = Lis_Contrato) THEN

    SELECT CL.NombreCompleto AS NombreCliente, CL.RFC AS RFC, ID.NumIdentific AS FolioINE, D.DireccionCompleta AS Direccion,
            C.MontoCredito AS MontoCredito, DC.Descripcion AS DestinoCredito
        FROM CREDITOS AS C
        INNER JOIN INTEGRAGRUPOSCRE AS I ON I.SolicitudCreditoID = C.SolicitudCreditoID
        INNER JOIN CLIENTES AS CL ON CL.ClienteID = C.ClienteID
        INNER JOIN IDENTIFICLIENTE AS ID ON ID.ClienteID = C.ClienteID AND ID.TipoIdentiID = Var_INE
        INNER JOIN DIRECCLIENTE AS D ON D.ClienteID = C.ClienteID AND D.Oficial = Str_SI
        INNER JOIN DESTINOSCREDITO AS DC ON DC.DestinoCreID = C.DestinoCreID
        WHERE I.GrupoID = Par_GrupoID;

END IF;
END TerminaStore$$