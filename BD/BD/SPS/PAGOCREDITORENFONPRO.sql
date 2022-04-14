-- PAGOCREDITORENFONPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOCREDITORENFONPRO`;
DELIMITER $$

CREATE PROCEDURE `PAGOCREDITORENFONPRO`(
    /*SP PARA HACER EL PAGO DEL CREDITO FONDEADOR EN UNA RENOVACION*/

    Par_CreditoOrigenID     BIGINT(12),     -- Credito a renovar o reestructurar
    Par_CreditoDestinoID    BIGINT(12),     -- Credito renovador o reestructurador
    Par_EsReestructura      CHAR(1),        -- Parametro que indica si es reestructura
    Par_MonedaID            INT(11),        -- Parametro que indica el tipo de moneda

    Par_Salida              CHAR(1),        -- Par_Salida
    INOUT Par_NumErr        INT(11),        -- Numero de error
    INOUT Par_ErrMen        VARCHAR(400),   -- Mensaje de Error

    Aud_EmpresaID           INT(11),        -- Auditoria
    Aud_Usuario             INT(11),        -- Auditoria
    Aud_FechaActual         DATETIME,       -- Auditoria
    Aud_DireccionIP         VARCHAR(15),    -- Auditoria
    Aud_ProgramaID          VARCHAR(50),    -- Auditoria
    Aud_Sucursal            INT(11),        -- Auditoria
    Aud_NumTransaccion      BIGINT(20)      -- Auditoria
    )
TerminaStore: BEGIN

    DECLARE Cadena_Vacia                CHAR(1);            -- Constante Cadena
    DECLARE Entero_Cero                 INT;                -- Constante Entero
    DECLARE Fecha_Vacia                 DATE;               -- Constante Fecha
    DECLARE Var_SI                      CHAR(1);            -- Constante SI
    DECLARE Var_NO                      CHAR(1);            -- Constante NO

    DECLARE Var_EstatusReest            CHAR(1);            -- Variable para guardar el estatus de la reestructura
    DECLARE Estatus_Alta                CHAR(1);            -- Constante Estatus Alta
    DECLARE Var_Tamanio                 INT(11);            -- Variable para Consulta en el while
    DECLARE Var_TipoFondeo              CHAR(1);            -- Variable Tipo de Fondeo
    DECLARE Var_CreditoFonID            INT(11);            -- Variable ID del Credito Fondeo

    DECLARE Var_GrupoID                 INT;                -- Variable para guardar el id del grupo
    DECLARE Var_EstatusFondeo           CHAR(1);            -- Constante Estatus Fondeo
    DECLARE Var_AdeudoPasivo            DECIMAL(14,2);      -- Deuda del Credito Pasivo
    DECLARE Var_InstitutFondID          INT(11);            -- Institucion de la linea de fondeo
    DECLARE Var_LineaFondeoID           INT(11);            -- Linea de Fondeo

    DECLARE Var_InstitucionID           INT(11);            -- Institucion fondeadora
    DECLARE Var_NumCtaInstit            VARCHAR(20);        -- Num de Cta de la Institucion Fondeadora
    DECLARE Var_Control                 VARCHAR(100);       -- Variable de Control
    DECLARE Estatus_Desembolso          CHAR(1);            -- Constante Estatus Desembolso
    DECLARE Var_TotalAdeudo             DECIMAL(14,2);      -- Variable para guardar el total del adeudo

    DECLARE Par_Consecutivo             BIGINT;             -- Consecutivo
    DECLARE Salida_SI                   CHAR(1);            -- Constante Salida SI
    DECLARE OrigenReestructura          CHAR(1);            -- Constante Origen Reestructura
    DECLARE Estatus_Vigente             CHAR(1);            -- Constante Estatus Vigente
    DECLARE EstatusPagado               CHAR(1);            -- Constante Estatus Pagado
    DECLARE Var_ValIVAGen               DECIMAL(12,2);      -- Variable para guardar el IVA de interes
    DECLARE Var_IVASucurs               DECIMAL(8, 4);      -- Variable para guardar el IVA de la sucursal
    
    DECLARE Var_SucursalCte             INT(11);            -- Variable para guardar la sucursal del cliente
    DECLARE Var_CliPagIVA               CHAR(1);            -- Variable para almacenar si el cliente paga IVA
    DECLARE Estatus_Pagado              CHAR(1);            -- Constante Estatus Pagado
    DECLARE Var_MontoPago               DECIMAL(14,2);      -- Variable Monto de Pago
    DECLARE Var_Poliza                  BIGINT(20);         -- Variable Numero de Poliza

    SET Estatus_Alta        := 'A';             -- Estatus del registro en REESTRUCCREDITO, A=alta, C=cancelado, D=desembolsado
    SET Cadena_Vacia        := '';
    SET Fecha_Vacia         := '1900-01-01';
    SET Entero_Cero         := 0;
    SET Var_SI              := 'S';

    SET Var_NO              := 'N';
    SET Estatus_Desembolso  := 'D';             -- Estatus desembolsado
    SET Salida_SI           := 'S';
    SET OrigenReestructura  := 'R';             -- Tipo de Tratamiento: Reestructura
    SET Estatus_Vigente     := 'V';             -- Estatus vigente
    SET EstatusPagado       := 'P';             -- Estatus de Pagado
    SET Estatus_Pagado      := 'P';             -- Estatus del Credito: Pagado

    ManejoErrores: BEGIN
    
        DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
            SET Par_NumErr  := 999;
            SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                    'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGOCREDITORENFONPRO');
            SET Var_Control := 'SQLEXCEPTION';
        END;
        
        IF EXISTS (SELECT CreditoOrigenID FROM  REESTRUCCREDITO
                                                WHERE CreditoOrigenID = Par_CreditoOrigenID
                                                    AND Origen = OrigenReestructura
                                                    AND EstatusReest  = Estatus_Desembolso LIMIT 1) THEN
                SET Par_NumErr      := 001;
                SET Par_ErrMen      := 'No se Permite Renovar un Cr&eacute;dito Reestructura.';
                LEAVE ManejoErrores;
            END IF;

        IF EXISTS (SELECT CreditoOrigenID FROM  REESTRUCCREDITO
                                                WHERE CreditoOrigenID = Par_CreditoOrigenID
                                                    AND EstatusReest  = Estatus_Desembolso LIMIT 1) THEN
                SET Par_NumErr      := 002;
                SET Par_ErrMen      := 'El Cr&eacute;dito Relacionado ya Fue Renovado.';
                LEAVE ManejoErrores;
            END IF;
            
        IF (Par_EsReestructura = Var_NO) THEN
            SET Par_NumErr  := 003;
            SET Par_ErrMen  := 'El Producto de Cr&eacute;dito No Permite Renovaciones.';
            LEAVE ManejoErrores;
        END IF;
    
        SELECT FUNCIONTOTDEUDACRE(Par_CreditoOrigenID) INTO Var_TotalAdeudo;

        IF (Var_TotalAdeudo <= Entero_Cero) THEN
            SET Par_NumErr  := 004;
            SET Par_ErrMen  := CONCAT('El Cr&eacute;dito a ', Var_Tratamiento, '  No Presenta Adeudos.');
            LEAVE ManejoErrores;
        END IF;

        # Inicializacion de variables
         SELECT     Cli.SucursalOrigen,     Cli.PagaIVA
            INTO    Var_SucursalCte,        Var_CliPagIVA
        FROM CREDITOS Cre
            INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID
            INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
            INNER JOIN DESTINOSCREDITO Des ON  Cre.DestinoCreID       = Des.DestinoCreID
        WHERE Cre.CreditoID = Par_CreditoOrigenID;

        SET Var_ValIVAGen   := Entero_Cero;

        SELECT IVA INTO Var_IVASucurs FROM SUCURSALES WHERE SucursalID  = Var_SucursalCte;
        IF (Var_CliPagIVA = Var_SI) THEN
                SET Var_ValIVAGen  := Var_IVASucurs;
        END IF;

        SET Var_EstatusReest := Estatus_Alta;
        
        SELECT IFNULL(MAX(Consecutivo),Entero_Cero) INTO Var_Tamanio FROM TMPRENOVAAMORTICRED;

        SET Var_TipoFondeo   := (SELECT TipoFondeo  FROM CREDITOS where CreditoID = Par_CreditoDestinoID);

        SET Var_CreditoFonID := (SELECT CreditoFondeoID FROM RELCREDPASIVOAGRO WHERE CreditoID = Par_CreditoOrigenID AND EstatusRelacion=Estatus_Vigente);
        SET Var_CreditoFonID := IFNULL(Var_CreditoFonID,Entero_Cero);
        SET Var_GrupoID     := (SELECT GrupoID FROM CREDITOS WHERE CreditoID =Par_CreditoOrigenID);
        SET Var_GrupoID     := IFNULL(Var_GrupoID,Entero_Cero);

            IF(Var_CreditoFonID <> Entero_Cero) THEN
                    SET Var_EstatusFondeo := (SELECT  Estatus FROM CREDITOFONDEO WHERE CreditoFondeoID = Var_CreditoFonID);
                    
                    IF(Var_EstatusFondeo <> EstatusPagado) THEN
                        SELECT   ROUND( IFNULL(
                                SUM(ROUND(SaldoCapVigente,2) + ROUND(SaldoCapAtrasad,2) +
                                      ROUND(SaldoInteresPro + SaldoInteresAtra,2) + 
                                      ROUND(ROUND(SaldoInteresPro + SaldoInteresAtra, 2) * Var_ValIVAGen, 2) +
                                      ROUND(SaldoComFaltaPa,2) + ROUND(ROUND(SaldoComFaltaPa,2) * Var_ValIVAGen,2) +
                                      ROUND(SaldoOtrasComis,2) + ROUND(ROUND(SaldoOtrasComis,2) * Var_ValIVAGen,2) +
                                      ROUND(SaldoMoratorios,2) + ROUND(ROUND(SaldoMoratorios,2) * Var_ValIVAGen,2)
                                     ),
                                   Entero_Cero)
                            , 2)            
                            INTO Var_AdeudoPasivo  
                            FROM AMORTIZAFONDEO 
                            WHERE CreditoFondeoID   =  Var_CreditoFonID
                              AND Estatus   <> Estatus_Pagado; 

                   
                        # Credito grupal Adeudo  
                        IF(Var_GrupoID > Entero_Cero AND Var_AdeudoPasivo>Var_TotalAdeudo) THEN
                            SET Var_AdeudoPasivo := Var_TotalAdeudo;
                        END IF;
                    
                    SELECT  Cre.InstitutFondID, Cre.LineaFondeoID
                            INTO Var_InstitutFondID, Var_LineaFondeoID
                            FROM CREDITOFONDEO Cre,
                                 LINEAFONDEADOR Lin,
                                 INSTITUTFONDEO ins
                            WHERE Cre.CreditoFondeoID = Var_CreditoFonID
                             AND Cre.LineaFondeoID  = Lin.LineaFondeoID
                             AND ins.InstitutFondID = Lin.InstitutFondID;

                    SELECT  lin.InstitucionID,      lin.NumCtaInstit
                        INTO Var_InstitucionID,     Var_NumCtaInstit
                    FROM LINEAFONDEADOR lin
                        WHERE lin.LineaFondeoID    = Var_LineaFondeoID
                            AND lin.InstitutFondID = Var_InstitutFondID;

                        /* PAGO DEL CREDITO FONDEADOR*/
                        CALL PAGOCREDITOFONPRO(
                                 Var_CreditoFonID,   Var_AdeudoPasivo,      Par_MonedaID,    Var_SI,            Var_SI,
                                 Var_InstitucionID,  Var_NumCtaInstit,      Var_NO,          Var_MontoPago,     Var_Poliza,     
                                 Par_NumErr,         Par_ErrMen,            Par_Consecutivo, Aud_EmpresaID,     Aud_Usuario, 
                                 Aud_FechaActual,    Aud_DireccionIP,       Aud_ProgramaID,  Aud_Sucursal,      Aud_NumTransaccion);
                        
                        IF (Par_NumErr != Entero_Cero) THEN
                            SET Par_NumErr  := Par_NumErr;
                            SET Par_ErrMen  := Par_ErrMen;
                            LEAVE ManejoErrores;
                        END IF; 
                    END IF;
            END IF; 

    SET Par_NumErr  := '000';
    SET Par_ErrMen  :=  concat('Pago de Credito Realizado Exitosamente');

    END ManejoErrores;  -- END del Handler de Errores

    IF (Par_Salida = Salida_SI) THEN
        SELECT  Par_NumErr      AS NumErr,
                Par_ErrMen      AS ErrMen;
    END IF;

END TerminaStore$$