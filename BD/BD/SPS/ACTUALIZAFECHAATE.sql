-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ACTUALIZAFECHAATE
DELIMITER ;
DROP PROCEDURE IF EXISTS `ACTUALIZAFECHAATE`;

DELIMITER $$
CREATE PROCEDURE `ACTUALIZAFECHAATE`(
    -- Realiza cambio de fechas en credito
    Par_CreditoID       INT(11),        -- Identificador del credito a modificar.

    Par_Salida			CHAR(1),		-- Parametro Establece si requiere Salida
	INOUT Par_NumErr	INT(11),		-- Parametro INOUT para el Numero de Error
	INOUT Par_ErrMen	VARCHAR(400),	-- Parametro INOUT para la Descripcion del Error


    /* Parametros de Auditoria */
    Aud_EmpresaID   	INT(11),        -- Parametro de auditoria
	Aud_Usuario			INT(11),        -- Parametro de auditoria
	Aud_FechaActual		DATETIME,       -- Parametro de auditoria
	Aud_DireccionIP		VARCHAR(15),    -- Parametro de auditoria
	Aud_ProgramaID		VARCHAR(50),    -- Parametro de auditoria
	Aud_Sucursal		INT(11),        -- Parametro de auditoria
	Aud_NumTransaccion	BIGINT(20)      -- Parametro de auditoria
)
TerminaStore: BEGIN

    -- Declaracion de Variables
    DECLARE Var_FolioID             INT(11);
    DECLARE Var_Control             VARCHAR(50);
    DECLARE Var_Consecutivo         INT(11);
    DECLARE Var_CreditoID           INT(11);
    DECLARE Var_FechaMinist         DATE;
    DECLARE Var_FechaInicioAmor     DATE;
    DECLARE Var_TipoPrepago         CHAR(1);
    DECLARE Var_FechaSistema        DATE;
    DECLARE Var_FechaRecep          DATE;
    -- Declaracion de Constates
    DECLARE Cadena_Vacia        CHAR(1);
    DECLARE Entero_Cero         INT(1);
    DECLARE SalidaSI            CHAR(1);
    DECLARE Con_Estatus_E       CHAR(1);
    DECLARE Con_Estatus_N       CHAR(1);
    DECLARE Con_Estatus_A       CHAR(1);
    DECLARE Con_Estatus_V       CHAR(1);
    DECLARE Con_Proceso_A       INT(1);         -- Proceso que se encarga de cambiar el estatusNomina del credito a A.
    DECLARE Con_Proceso_N       INT(1);         -- Proceso que se encarga de cambiar el estatusNomina del credito a N.
    DECLARE Con_Proceso_E       INT(1);         -- Proceso que se encarga de cambiar el estatusNomina del credito a E.


    -- Asignacion de Constantes
    SET Cadena_Vacia        :=  '';
    SET Entero_Cero         :=  0;
    SET SalidaSI            :=  'S';
    SET Aud_FechaActual     :=  NOW();
    SET Con_Estatus_E       := 'E';
    SET Con_Estatus_N       := 'N';
    SET Con_Estatus_A       := 'A';
    SET Con_Estatus_V       := 'V';
    SET Con_Proceso_A       := 1;
    SET Con_Proceso_N       := 2;
    SET Con_Proceso_E       := 3;

     -- Creacion de la tabla temporal que servira para almacenar los datos por secciones.
    DROP TABLE IF EXISTS TMPAMORTICRENOMINAARCH;
	CREATE TEMPORARY TABLE TMPAMORTICRENOMINAARCH(
        `AmortizacionID` 		    INT(4),
        `CreditoID` 			    BIGINT(12),
        `SaldoCapVigente`           DECIMAL(14,2),
        `SaldoCapAtrasa`            DECIMAL(14,2),
        `SaldoCapVencido`           DECIMAL(14,2),
        `SaldoCapVenNExi`           DECIMAL(14,2),
        `SaldoInteresOrd`           DECIMAL(14,4),
        `SaldoInteresAtr`           DECIMAL(14,4),
        `SaldoInteresVen`           DECIMAL(14,4),
        `SaldoInteresPro`           DECIMAL(14,4),
        `SaldoIntNoConta`           DECIMAL(12,4),
        `SaldoIVAInteres`           DECIMAL(14,2),
        `SaldoMoratorios`           DECIMAL(14,2),
        `SaldoIVAMorato`            DECIMAL(14,2),
        `SaldoComFaltaPa`           DECIMAL(14,2),
        `SaldoIVAComFalP`           DECIMAL(14,2),
        `MontoOtrasComisiones`      DECIMAL(14,2),
        `MontoIVAOtrasComisiones`   DECIMAL(14,2),
        `MontoIntOtrasComis`        DECIMAL(14,2),
        `MontoIVAIntComisi`         DECIMAL(14,2),
        `SaldoOtrasComis`           DECIMAL(14,2),
        `SaldoIVAComisi`            DECIMAL(14,2),
        `ProvisionAcum`             DECIMAL(14,4),
        `SaldoCapital`              DECIMAL(14,2),
        `NumProyInteres`            INT(11),
        `SaldoMoraVencido`          DECIMAL(14,2),
        `SaldoMoraCarVen`           DECIMAL(14,2),
        `MontoSeguroCuota`          DECIMAL(12,2),
        `IVASeguroCuota`            DECIMAL(12,2),
        `SaldoSeguroCuota`          DECIMAL(12,2),
        `SaldoIVASeguroCuota`       DECIMAL(12,2),
        `SaldoComisionAnual`        DECIMAL(14,2),
        `SaldoComisionAnualIVA`     DECIMAL(14,2),
        `SaldoNotCargoRev`          DECIMAL(14,2),
        `SaldoNotCargoSinIVA`       DECIMAL(14,2),
        `SaldoNotCargoConIVA`       DECIMAL(14,2),
        `SaldoIntOtrasComis`        DECIMAL(14,2),
        `SaldoIVAIntComisi`         DECIMAL(14,2),
        INDEX (AmortizacionID,CreditoID)
	);

    ManejoErrores: BEGIN

        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr  =  999;
            SET Par_ErrMen  =  CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                    'Disculpe las molestias que esto le ocasiona. Ref: SP-ACTUALIZAFECHAATE');
            SET Var_Control =  'SQLEXCEPTION';
        END;

        IF(Par_CreditoID = 300036210)THEN
			SET Var_FechaSistema	:= '2021-04-02';
		ELSE
			IF(Par_CreditoID = 300036228)THEN
				SET Var_FechaSistema	:= '2021-04-30';
			ELSE
				-- Se consulta la fecha del sistema de la tabla PARAMETROSSIS;
				SELECT FechaSistema INTO   Var_FechaSistema FROM   PARAMETROSSIS LIMIT 1;
			END IF;
				SELECT FechaSistema INTO   Var_FechaSistema FROM   PARAMETROSSIS LIMIT 1;
		END IF;

            SET Var_FechaMinist     := Var_FechaSistema;
            SET Var_FechaInicioAmor := Var_FechaSistema;

        -- Se obtiene el identificador del credito para la validacion de existencia
        SELECT IFNULL(CreditoID,Entero_Cero)
        INTO Var_CreditoID
        FROM CREDITOS WHERE CreditoID = Par_CreditoID;

        -- Se valida si el identificador del credito devolvio nulo.
        IF(IFNULL(Var_CreditoID, Entero_Cero) = Entero_Cero) THEN
            SET Par_NumErr  :=  001;
            SET Par_ErrMen  :=  CONCAT('El Credito no existe: ',Var_CreditoID);
            SET Var_Control :=  'creditoID';
            LEAVE ManejoErrores;
        END IF;


            SELECT  TipoPrepago
              INTO  Var_TipoPrepago
              FROM  CREDITOS
             WHERE  CreditoID = Par_CreditoID;

            -- Se realiza el proceso de respaldo de las amortizaciones antes de que estas sean eliminadas para el recalculo de las fechas.

            INSERT INTO TMPAMORTICRENOMINAARCH (
                AmortizacionID,             CreditoID,                      SaldoCapVigente,                    SaldoCapAtrasa,                 SaldoCapVencido,
                SaldoCapVenNExi,            SaldoInteresOrd,                SaldoInteresAtr,                    SaldoInteresVen,                SaldoInteresPro,
                SaldoIntNoConta,            SaldoIVAInteres,                SaldoMoratorios,                    SaldoIVAMorato,                 SaldoComFaltaPa,
                SaldoIVAComFalP,            MontoOtrasComisiones,           MontoIVAOtrasComisiones,            MontoIntOtrasComis,             MontoIVAIntComisi,
                SaldoOtrasComis,            SaldoIVAComisi,                 ProvisionAcum,                      SaldoCapital,                   NumProyInteres,
                SaldoMoraVencido,           SaldoMoraCarVen,                MontoSeguroCuota,                   IVASeguroCuota,                 SaldoSeguroCuota,
                SaldoIVASeguroCuota,        SaldoComisionAnual,             SaldoComisionAnualIVA,              SaldoNotCargoRev,               SaldoNotCargoSinIVA,
                SaldoNotCargoConIVA,        SaldoIntOtrasComis,             SaldoIVAIntComisi
            )
            SELECT
                Amor.AmortizacionID,         Amor.CreditoID,                  Amor.SaldoCapVigente,            Amor.SaldoCapAtrasa,             Amor.SaldoCapVencido,
                Amor.SaldoCapVenNExi,        Amor.SaldoInteresOrd,            Amor.SaldoInteresAtr,            Amor.SaldoInteresVen,            Amor.SaldoInteresPro,
                Amor.SaldoIntNoConta,        Amor.SaldoIVAInteres,            Amor.SaldoMoratorios,            Amor.SaldoIVAMorato,             Amor.SaldoComFaltaPa,
                Amor.SaldoIVAComFalP,        Amor.MontoOtrasComisiones,       Amor.MontoIVAOtrasComisiones,    Amor.MontoIntOtrasComis,         Amor.MontoIVAIntComisi,
                Amor.SaldoOtrasComis,        Amor.SaldoIVAComisi,             Amor.ProvisionAcum,              Amor.SaldoCapital,               Amor.NumProyInteres,
                Amor.SaldoMoraVencido,       Amor.SaldoMoraCarVen,            Amor.MontoSeguroCuota,           Amor.IVASeguroCuota,             Amor.SaldoSeguroCuota,
                Amor.SaldoIVASeguroCuota,    Amor.SaldoComisionAnual,         Amor.SaldoComisionAnualIVA,      Amor.SaldoNotCargoRev,           Amor.SaldoNotCargoSinIVA,
                Amor.SaldoNotCargoConIVA,    Amor.SaldoIntOtrasComis,         Amor.SaldoIVAIntComisi
            FROM AMORTICREDITO Amor
            WHERE Amor.CreditoID = Par_CreditoID;

            -- Se llama al SP que recalcula las fechas de las cuotas.
            CALL CREGENAMORTIZAPRO (
                Par_CreditoID,          Var_FechaMinist,        Var_FechaInicioAmor,        Var_TipoPrepago,        'N',
                Par_NumErr,             Par_ErrMen,             Aud_EmpresaID,              Aud_Usuario,            Aud_FechaActual,
                Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,               Aud_NumTransaccion
            );

            IF (Par_NumErr != Entero_Cero) THEN
				SET Var_Control	:= 'creditoID';
				LEAVE ManejoErrores;
			END IF;

            DELETE FROM PAGARECREDITO WHERE CreditoID = Par_CreditoID;

            -- Se llama al SP que crea el pagare del credito
            CALL PAGARECREDITOALT(
                Par_CreditoID,          'N',
                Par_NumErr,             Par_ErrMen,             Aud_EmpresaID,              Aud_Usuario,            Aud_FechaActual,
                Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,               Aud_NumTransaccion
            );

            IF (Par_NumErr != Entero_Cero) THEN
				SET Var_Control	:= 'creditoID';
				LEAVE ManejoErrores;
			END IF;

            -- Se modifica el estatus del amorticrédito.
            UPDATE AMORTICREDITO
            SET
                Estatus = Con_Estatus_V
            WHERE
                CreditoID = Par_CreditoID;

            -- Se realiza la recuperación de los saldos y montos de las amortizaciones generadas.

            UPDATE AMORTICREDITO AMOR
            INNER JOIN TMPAMORTICRENOMINAARCH TMP
            ON AMOR.AmortizacionID = TMP.AmortizacionID
            SET
                AMOR.SaldoCapVigente             = TMP.SaldoCapVigente,
                AMOR.SaldoCapAtrasa              = TMP.SaldoCapAtrasa,
                AMOR.SaldoCapVencido             = TMP.SaldoCapVencido,
                AMOR.SaldoCapVenNExi             = TMP.SaldoCapVenNExi,
                AMOR.SaldoInteresOrd             = TMP.SaldoInteresOrd,

                AMOR.SaldoInteresAtr             = TMP.SaldoInteresAtr,
                AMOR.SaldoInteresVen             = TMP.SaldoInteresVen,
                AMOR.SaldoInteresPro             = TMP.SaldoInteresPro,
                AMOR.SaldoIntNoConta             = TMP.SaldoIntNoConta,
                AMOR.SaldoIVAInteres             = TMP.SaldoIVAInteres,

                AMOR.SaldoMoratorios             = TMP.SaldoMoratorios,
                AMOR.SaldoIVAMorato              = TMP.SaldoIVAMorato,
                AMOR.SaldoComFaltaPa             = TMP.SaldoComFaltaPa,
                AMOR.SaldoIVAComFalP             = TMP.SaldoIVAComFalP,
                AMOR.MontoOtrasComisiones        = TMP.MontoOtrasComisiones,
                AMOR.MontoIVAOtrasComisiones     = TMP.MontoIVAOtrasComisiones,

                AMOR.MontoIntOtrasComis          = TMP.MontoIntOtrasComis,
                AMOR.MontoIVAIntComisi           = TMP.MontoIVAIntComisi,
                AMOR.SaldoOtrasComis             = TMP.SaldoOtrasComis,
                AMOR.SaldoIVAComisi              = TMP.SaldoIVAComisi,
                AMOR.ProvisionAcum               = TMP.ProvisionAcum,

                AMOR.SaldoCapital                = TMP.SaldoCapital,
                AMOR.NumProyInteres              = TMP.NumProyInteres,
                AMOR.SaldoMoraVencido            = TMP.SaldoMoraVencido,
                AMOR.SaldoMoraCarVen             = TMP.SaldoMoraCarVen,
                AMOR.MontoSeguroCuota            = TMP.MontoSeguroCuota,

                AMOR.IVASeguroCuota              = TMP.IVASeguroCuota,
                AMOR.SaldoSeguroCuota            = TMP.SaldoSeguroCuota,
                AMOR.SaldoIVASeguroCuota         = TMP.SaldoIVASeguroCuota,
                AMOR.SaldoComisionAnual          = TMP.SaldoComisionAnual,
                AMOR.SaldoComisionAnualIVA       = TMP.SaldoComisionAnualIVA,

                AMOR.SaldoNotCargoRev            = TMP.SaldoNotCargoRev,
                AMOR.SaldoNotCargoSinIVA         = TMP.SaldoNotCargoSinIVA,
                AMOR.SaldoNotCargoConIVA         = TMP.SaldoNotCargoConIVA,
                AMOR.SaldoIntOtrasComis          = TMP.SaldoIntOtrasComis,
                AMOR.SaldoIVAIntComisi           = TMP.SaldoIVAIntComisi

            WHERE AMOR.CreditoID = Par_CreditoID;

            -- Se actualiza el estado nomina del credito.
            UPDATE CREDITOS CR
            SET
                CR.EstatusNomina = Con_Estatus_N
            WHERE
                CR.CreditoID = Par_CreditoID;


        SET Par_NumErr      :=  0;
        SET Par_ErrMen      :=  CONCAT('Credito actualizado:', Var_FolioID);
        SET Var_Control     :=  'creditoID';
        SET Var_Consecutivo :=  Var_CreditoID;
    END ManejoErrores;

    IF(Par_Salida = SalidaSI) THEN
        SELECT  Par_NumErr      AS  NumErr,
                Par_ErrMen      AS  ErrMen,
                Var_Control     AS  Control,
                Var_Consecutivo AS  Consecutivo;
    END IF;

    DROP TABLE IF EXISTS TMPAMORTICRENOMINAARCH;

END TerminaStore$$
