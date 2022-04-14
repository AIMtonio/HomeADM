-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DESCNOMINAREALPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `DESCNOMINAREALPRO`;
DELIMITER $$

CREATE PROCEDURE `DESCNOMINAREALPRO`(
	/* SP PARA REGISTRAR LAS APLICACIONES DE PAGOS DE CREDITOS DE NOMINA EN TABLA REAL
        PARA AQUELLOS REGISTROS QUE SE HICIERON A TRAVES DE UN CARGA A CTA, VENTANILLA O PAGO DE CREDITO
        Y QUE CORRESPONDEN A UN FOLIO DE CARGA DE NOMINA Y QUE PRESENTAN MONTO NO APLICADO   */

	Par_CreditoID			BIGINT(12),		-- ID del credito

	Par_Salida          	CHAR(1),		-- Indica si espera un select de salida
	INOUT Par_NumErr		INT(11),		-- Numero de error
	INOUT Par_ErrMen		VARCHAR(400),	-- Mensaje de error

	Par_EmpresaID			INT(11),		-- Parametro de auditoria
	Aud_Usuario				INT(11),		-- Parametro de auditoria
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria
	Aud_Sucursal			INT(11),		-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT			-- Parametro de auditoria
	)
TerminaStore: BEGIN


DECLARE Var_InstitNominaID  INT(11);	    -- Variable para el id de la institucion de nomina
DECLARE Var_ConvenioID      BIGINT;         -- Varible para el ID de Convenio de Nomina
DECLARE Var_Control         VARCHAR(100);	-- Variable de control
DECLARE Var_NumeroAmort		INT(11);		-- Cantidad de amortizaciones afectadas
DECLARE Var_AmortizacionID	INT(11);		-- ID de la amortizacion
DECLARE Var_Offset			INT(11);		-- Variable de apoyo para obtener los rangos de registros
DECLARE Var_FechaVenci		DATE;			-- Fecha de vencimiento de la cuota
DECLARE Var_FechaExigible	DATE;			-- Fecha exigible de la cuota
DECLARE Var_AplicaTabla		CHAR(1);		-- Indica si el credito aplica tabla S:SI/N:NO
DECLARE Var_Domicilia       CHAR(1);        -- Indica si el Convenio Domicilia Pagos
DECLARE Var_Estatus         CHAR(1);        -- Estatus del Credito
DECLARE NumRegPendientes    INT(11);        -- Numero de Registros Pendientes por completar su Pago de Inst.
DECLARE Var_MontoPendienteFolio  DECIMAL(18,2); -- Monto Pendiente por Aplicar de los Folios de Nomina
DECLARE Var_MontoPorAplicar DECIMAL(14,2); -- Monto por Aplicar de los Folios Pendientes
DECLARE Var_MontoAmorti     DECIMAL(14,2); -- Monto de la Amortizacion
DECLARE Var_MontApliAmorti  DECIMAL(14,2); -- Monto Aplicado de Amortizacion
DECLARE NumFolios           INT(11);        -- Numero de Folios a Registrar
DECLARE NumAmorti           INT(11);        -- Numero de Amortizaciones
DECLARE Var_FolioNominaID   INT(11);        -- Folio de Nomina
DECLARE Var_FechaSistema    DATE;           -- Fecha del Sistema
DECLARE Var_EstFolio        CHAR(1);        -- Estatus del Folio
DECLARE Var_ClienteID       INT(11);        -- ClienteID
DECLARE Var_FolioCarga      INT(11);        -- Folio de Carga
DECLARE Var_FolioID         INT(11);        -- Folio ID

-- Declaracion de Constantes
DECLARE Estatus_Activo  CHAR(1);			-- Constante estatus activo 'A'
DECLARE Estatus_Vigente	CHAR(1);			-- Estatus vigente 'V'
DECLARE Cadena_Vacia    CHAR(1);			-- Constante cadena vacia
DECLARE Entero_Cero     INT(11);			-- Constante entero cero
DECLARE SalidaSI        CHAR(1);			-- Constante salida si
DECLARE Entero_Uno      INT(11);			-- Constante entero uno
DECLARE Cons_No			CHAR(1);			-- Constante NO
DECLARE Cons_Si			CHAR(1);			-- Constante SI

-- Seteo de Constantes
SET Estatus_Activo  := 'A';
SET Estatus_Vigente	:= 'V';
SET Cadena_Vacia    := '';
SET Entero_Cero     := 0;
SET SalidaSI        := 'S';
SET Var_Offset		:= 0;
SET Entero_Uno		:= 1;
SET Cons_No			:= 'N';
SET Cons_Si			:= 'S';

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				set Par_NumErr = 999;
				set Par_ErrMen = concat('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-DESCNOMINAREALPRO');
						SET Var_Control = 'sqlException' ;
			END;


	-- Se obtiene la Fecha Actual del Sistema
	SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS);

    SELECT InstitNominaID, ConvenioNominaID, Estatus,       ClienteID
    INTO Var_InstitNominaID, Var_ConvenioID, Var_Estatus,   Var_ClienteID
    FROM CREDITOS
    WHERE CreditoID = Par_CreditoID;

    -- Se verifica si Domicilia Pagos
    SET Var_Domicilia := (SELECT DomiciliacionPagos
                            FROM CONVENIOSNOMINA
                            WHERE ConvenioNominaID = Var_ConvenioID
                                AND InstitNominaID = Var_InstitNominaID);
    SET Var_Domicilia := IFNULL(Var_Domicilia, Cons_No);

    -- Se vericia si Aplica Tabla Real o No
	SET Var_AplicaTabla := (SELECT AplicaTabla
                                FROM  INSTITNOMINA
                                    WHERE InstitNominaID = Var_InstitNominaID);
	SET Var_AplicaTabla := IFNULL(Var_AplicaTabla,Cons_No);

    -- Verifica que si existe Registros Pendientes por Aplicar para el Pago de Inst
    SELECT COUNT(*)
        INTO NumRegPendientes
        FROM BEPAGOSNOMINA
        WHERE CreditoID = Par_CreditoID
            AND EmpresaNominaID = Var_InstitNominaID
            AND MontoPagos > MontoAplicado;

	-- verificar si el credito cumple las condiciones de Nomina.
	IF (Var_AplicaTabla = Cons_Si AND Var_Domicilia = Cons_No
        AND NumRegPendientes > Entero_Cero) THEN

        DELETE FROM FOLIOSPENDIENTESNOM
            WHERE CreditoID = Par_CreditoID
            AND NumTransaccion = Aud_NumTransaccion;
        -- Se insertan los Registros de los Folios por Aplicar
        SET @Consecutivo := Entero_Cero;
        INSERT INTO FOLIOSPENDIENTESNOM(
            Folio,              FolioNominaID,         FolioCargaID,       CreditoID,      MontoPago,
            MontoAplicado,      MontoPendiente,         NumTransaccion)
        SELECT @Consecutivo:=(@Consecutivo+Entero_Uno),  FolioNominaID,     FolioCargaID,      Par_CreditoID,       MontoPagos,
           MontoAplicado,      (MontoPagos - MontoAplicado),     Aud_NumTransaccion
        FROM BEPAGOSNOMINA
        WHERE CreditoID = Par_CreditoID
            AND EmpresaNominaID = Var_InstitNominaID
            AND  MontoPagos > MontoAplicado;

        -- Se verifica si tene registros
        SELECT COUNT(*)
        INTO NumFolios
        FROM FOLIOSPENDIENTESNOM
        WHERE CreditoID = Par_CreditoID
            AND NumTransaccion = Aud_NumTransaccion;

        -- Se inserta las Amortizaciones que se vieron afectadas en el Pago de Credito
        DELETE FROM AMORTICREPAGNOMINA
            WHERE CreditoID = Par_CreditoID
            AND NumTransaccion = Aud_NumTransaccion;

        SET @Consecutivo := Entero_Cero;
        INSERT INTO AMORTICREPAGNOMINA(
            ConsecutivoID,      CreditoID,      AmortizacionID,         MontoAmorti,        MontoPorAplicar,
            NumTransaccion)
        SELECT @Consecutivo:=(@Consecutivo+Entero_Uno), Par_CreditoID,     AmortizacionID,   SUM(MontoTotPago),     SUM(MontoTotPago),
            Aud_NumTransaccion
            FROM DETALLEPAGCRE
            WHERE CreditoID = Par_CreditoID
            AND NumTransaccion = Aud_NumTransaccion
            GROUP BY AmortizacionID;

         -- Se verifica si tene registros
        SELECT COUNT(*)
        INTO NumAmorti
        FROM AMORTICREPAGNOMINA
        WHERE CreditoID = Par_CreditoID
            AND NumTransaccion = Aud_NumTransaccion;

        -- Se dan valores a las Variables Contadores de Registros en caso de ser nullos
        SET NumFolios := IFNULL(NumFolios, Entero_Cero);
        SET NumAmorti := IFNULL(NumAmorti, Entero_Cero);

        IF(NumFolios > Entero_Cero AND NumAmorti > Entero_Cero) THEN

            SET @FolioID := Entero_Uno;
            CicloFolio: WHILE(@FolioID <= NumFolios)DO

                SELECT  FolioNominaID,      FolioCargaID,       MontoPendiente
                INTO    Var_FolioID,      Var_FolioCarga,     Var_MontoPendienteFolio
                FROM FOLIOSPENDIENTESNOM
                WHERE CreditoID = Par_CreditoID
                    AND NumTransaccion = Aud_NumTransaccion
                    AND Folio =  @FolioID;


                SET @RegAmorti := Entero_Uno;
                CicloAmorti: WHILE (@RegAmorti <= NumAmorti)DO

                    SELECT AmortizacionID,         MontoAmorti,        MontoPorAplicar
                    INTO Var_AmortizacionID,       Var_MontoAmorti,    Var_MontoPorAplicar
                    FROM AMORTICREPAGNOMINA
                    WHERE  CreditoID = Par_CreditoID
                        AND NumTransaccion = Aud_NumTransaccion
                        AND ConsecutivoID = @RegAmorti;

                    IF(Var_MontoPorAplicar != Entero_Cero AND Var_MontoPendienteFolio != Entero_Cero)THEN
                        IF(Var_MontoPendienteFolio >= Var_MontoAmorti)THEN
                            -- Si el Monto de la Amortizacion es Igual al Monto Pendiente por Aplicar del Folio
                            SET Var_MontApliAmorti = Var_MontoAmorti;
                        ELSE
                            -- Si el Monto Pendiente Por Aplicar del Folio es menor al del Monto de la Amortizacion
                            SET Var_MontApliAmorti = Var_MontoPendienteFolio;
                        END IF;

                        -- Se actualiza el Monto por Aplicar
                        UPDATE AMORTICREPAGNOMINA SET
                            MontoPorAplicar = MontoPorAplicar - Var_MontApliAmorti
                        WHERE CreditoID = Par_CreditoID
                            AND NumTransaccion = Aud_NumTransaccion
                            AND ConsecutivoID = @RegAmorti;

                        -- Se actualiza el Monto Pendiente del Folio
                        SET Var_MontoPendienteFolio := Var_MontoPendienteFolio - Var_MontApliAmorti;

                        -- Se obtiene los datos de la Amortizacion
                        SELECT FechaVencim,  FechaExigible
                        INTO Var_FechaVenci, Var_FechaExigible
                        FROM AMORTICREDITO
                        WHERE NumTransaccion = Aud_NumTransaccion
                            AND CreditoID = Par_CreditoID
                            AND AmortizacionID = Var_AmortizacionID;


                        SET Var_EstFolio := (SELECT MAX(Estatus) FROM DESCNOMINAREAL WHERE FolioCargaID = Var_FolioCarga);
                        SET Var_EstFolio := IFNULL(Var_EstFolio, Estatus_Activo);

                        SET Var_FolioNominaID	:= (SELECT IFNULL(MAX(FolioNominaID),Entero_Cero) + Entero_Uno  FROM DESCNOMINAREAL);

                        -- Se inserta el Registro a la Tabla Real
                        INSERT INTO DESCNOMINAREAL (
                            FolioNominaID,		FolioCargaID,		EmpresaNominaID,	FechaCarga,		CreditoID,
                            AmortizacionID,		MontoPago,			Estatus,			EstatPagBanco,	FechaPagoIns,
                            MontoAplicado,		FechaAplicacion,	FechaVencimiento,	FechaExigible,	ClienteID,
                            EmpresaID,			Usuario,			FechaActual,		DireccionIP,	ProgramaID,
                            Sucursal, 			NumTransaccion)
                        VALUES(
                            Var_FolioNominaID,		Var_FolioCarga,		    Var_InstitNominaID,	    Var_FechaSistema,	Par_CreditoID,
                            Var_AmortizacionID,		Var_MontoPorAplicar,	Var_EstFolio,			Estatus_Vigente,	Var_FechaSistema,
                            Var_MontoPorAplicar,	Var_FechaSistema,	    Var_FechaVenci, 		Var_FechaExigible,	Var_ClienteID,
                            Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
                            Aud_Sucursal,			Aud_NumTransaccion);

                        -- Se actualiza el monto Aplicado para el Folio
                        UPDATE BEPAGOSNOMINA SET
                            MontoAplicado = MontoAplicado + Var_MontoPorAplicar
                        WHERE CreditoID = Par_CreditoID
                            AND EmpresaNominaID = Var_InstitNominaID
                            AND FolioCargaID = Var_FolioCarga
                            AND FolioNominaID = Var_FolioID;

                    END IF;

                    SET @RegAmorti := @RegAmorti + Entero_Uno;
                END WHILE CicloAmorti;



                SET @FolioID := @FolioID + Entero_Uno;
            END WHILE CicloFolio;
        END IF;

        -- Se eliminan los Registros de las Tablas de Apoyo
        DELETE FROM FOLIOSPENDIENTESNOM
            WHERE CreditoID = Par_CreditoID
            AND NumTransaccion = Aud_NumTransaccion;

        DELETE FROM AMORTICREPAGNOMINA
            WHERE CreditoID = Par_CreditoID
            AND NumTransaccion = Aud_NumTransaccion;

	END IF; -- Fin if aplica tabla

		SET Par_NumErr  := 000;
        SET Par_ErrMen  := 'Registro de aplicacion de pago realizado Exitosamente';

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Entero_Cero AS consecutivo;
END IF;

END TerminaStore$$