-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COMSALDOPROMCOBPENDPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `COMSALDOPROMCOBPENDPRO`;
DELIMITER $$

CREATE PROCEDURE `COMSALDOPROMCOBPENDPRO`(
-- ========== SP PARA PAGO DE COMISIONES PENDIENTES ================================
    Par_CuentaAhoID                 BIGINT(20),             -- Cuenta de Ahorro del Cliente
    Par_MontoMov                    DECIMAL(14,2),          -- Monto de Saldo para realizar el Cobro de Comisiones Pendientes
	INOUT Par_MontoAplicado		    DECIMAL(12,2),          -- Monto de Pago que se Aplico para la Comision
	Par_Poliza		                BIGINT,                 -- Numero de Poliza para los movimientos

    Par_Salida                      CHAR(1),                -- Parametro de Salida
    INOUT Par_NumErr                INT(11),                -- Parametro Numero de Error
    INOUT Par_ErrMen                VARCHAR(400),           -- Parametro Mensaje de Error

    Aud_EmpresaID                   INT(11),                -- Parametro de Auditoria
    Aud_Usuario                     INT(11),                -- Parametro de Auditoria
    Aud_FechaActual                 DATETIME,               -- Parametro de Auditoria
    Aud_DireccionIP                 VARCHAR(15),            -- Parametro de Auditoria
    Aud_ProgramaID                  VARCHAR(50),            -- Parametro de Auditoria
    Aud_Sucursal                    INT(11),                -- Parametro de Auditoria
    Aud_NumTransaccion              BIGINT(20)              -- Parametro de Auditoria
)
TerminaStore: BEGIN

    -- Declaracion de Variables
    DECLARE Var_Control             VARCHAR(50);            -- Variable Control
    DECLARE Var_Consecutivo         INT(11);                -- Variable Consecutivo
    DECLARE Var_CuentaAhoID         BIGINT(20);             -- Variable Cuenta de Ahorro del Cliente
    DECLARE Var_ExisteMontoPen      DECIMAL(14,2);          -- Variable Existe Monto Pendiente a Cobrar
    DECLARE Var_Contador            INT(11);                -- Variable Auxiliar Contador
    DECLARE Var_ComSaldoPromOri     DECIMAL(14,2);          -- Variable Com Saldo Original
    DECLARE Var_IVAComSalPromOri    DECIMAL(14,2);          -- Variable Com Saldo IVA Original
    DECLARE Var_ComSaldoPromAct     DECIMAL(14,2);          -- Variable Com Saldo Pendiente de Pago
    DECLARE Var_IVAComSalPromAct    DECIMAL(14,2);          -- Variable Com Saldo IVA Pendiente de Pago
    DECLARE Var_MontoComApli        DECIMAL(14,2);          -- Variable Monto a Aplicar
    DECLARE Var_MontoIVAApli        DECIMAL(14,2);          -- Variable Monto IVA a Aplicar
    DECLARE Var_ClienteID           INT(11);                -- Variable Identificador Cliente
    DECLARE Var_PagaIVA             CHAR(1);                -- Variable Paga IVA Cliente
    DECLARE Var_Sucursal            INT(11);                -- Variable Sucursal Cliente
    DECLARE Var_IVA                 DECIMAL(12,2);          -- Variable IVA a Cobrar
    DECLARE Var_ComisionID          INT(11);                -- Variable Comision ID
    DECLARE Var_SaldoDispon         DECIMAL(14,2);          -- Variable Saldo Disponible del Cliente
    DECLARE Var_ComSaldoPen         DECIMAL(14,2);          -- Variable Saldo Pendiente despues del Cobro
    DECLARE Var_IVAComSaldoPen      DECIMAL(14,2);          -- Variable IVA Saldo Pendiente despues del Cobro
    DECLARE Var_SucCLiente          INT(11);                -- SUCURSAL DEL CLIENTE
	DECLARE	Var_CuentaStr	        VARCHAR(20);

    -- Declaracion de Constantes
    DECLARE Cadena_Vacia            CHAR(1);                -- Cadena Vacia
    DECLARE Entero_Cero             INT(11);                -- Entero Cero
    DECLARE Decimal_Cero            DECIMAL(12,2);          -- Decimal Cero
    DECLARE SalidaSI                CHAR(1);                -- SALIDA SI
    DECLARE SalidaNO                CHAR(1);                -- SALIDA SI
    DECLARE Est_Vigente             CHAR(1);                -- Constante VIGENTE
    DECLARE Entero_Uno              INT(11);                -- Constante ENTERO UNO
    DECLARE Con_NO                  CHAR(1);                -- Constante NO
    DECLARE Con_SI                  CHAR(1);                -- Constante SI
    DECLARE Est_Pagado              CHAR(1);                -- Constante Pagado en su totalidad
    DECLARE Var_FechaSis            DATE;                   -- Fecha de Sistema
    DECLARE Con_Abono               CHAR(1);
    DECLARE Con_Cargo               CHAR(1);
    DECLARE Var_DescripcionMov      VARCHAR(150);           -- Descripcion de Moviemiento
    DECLARE Var_DescripcionMovIVA   VARCHAR(150);           -- Descripcion de Moviemiento

    DECLARE Var_TipoMovAhoIDCom     CHAR(4);                -- Tipo de Movimiento de Ahorro
    DECLARE Var_TipoMovAhoIDIVACom     CHAR(4);                -- Tipo de Movimiento de Ahorro
    DECLARE Var_MonedaID            INT(11);
    DECLARE  ConceptoAho            INT;                    -- CONCEPTOSAHORRO Abono a Cta
    DECLARE  ConceptoAhoCom          INT;                    -- CONCEPTOSAHORRO Comision por Saldo Promedio
    DECLARE ConceptoAhoIVACom          INT;                 -- CONCEPTOSAHORRO IVA Comision por Saldo Promedio

    -- Seteo de Constantes
    SET Cadena_Vacia                := '';
    SET Entero_Cero                 := 0;
    SET Decimal_Cero                := 0.0;
    SET SalidaSI                    := 'S';
    SET SalidaNO                    := 'N';
    SET Est_Vigente                 := 'V';
    SET Entero_Uno                  := 1;
    SET Con_NO                      := 'N';
    SET Con_SI                      := 'S';
    SET Est_Pagado                  := 'P';
    SET Con_Abono                   := 'A';
    SET Con_Cargo                   := 'C';
    SET Var_DescripcionMov          := 'COMISION SALDO PROMEDIO';
    SET Var_DescripcionMovIVA       := 'IVA COMISION SALDO PROMEDIO';
    SET Var_TipoMovAhoIDCom         := '230';
    SET Var_TipoMovAhoIDIVACom      := '231';
    SET Var_MonedaID                := 1;
    SET ConceptoAho                 := 1;
    SET ConceptoAhoCom             := 35;
    SET ConceptoAhoIVACom             := 36;
    ManejoErrores:BEGIN 	-- bloque para manejar los posibles errores
        DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
            SET Par_NumErr = 999;
            SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que  ',
                            'esto le ocasiona. Ref: SP-COMSALDOPROMCOBPENDPRO');
            SET Var_Control = 'sqlException' ;
        END;

        SET Par_MontoAplicado := Decimal_Cero;
        SET Var_FechaSis := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

        IF(Par_CuentaAhoID = Entero_Cero)THEN
            SET Par_NumErr := 02;
            SET Par_ErrMen := 'La Cuenta esta Vacia.';
            SET Var_Control := 'cuentaAhoID';
            LEAVE ManejoErrores;
        END IF;

        SELECT CuentaAhoID,     ClienteID,        SaldoDispon
        INTO Var_CuentaAhoID,   Var_ClienteID,    Var_SaldoDispon
        FROM CUENTASAHO
        WHERE CuentaAhoID =  Par_CuentaAhoID;

        SET Var_CuentaAhoID := IFNULL(Var_CuentaAhoID,Entero_Cero);

         IF(Var_CuentaAhoID = Entero_Cero)THEN
            SET Par_NumErr := 02;
            SET Par_ErrMen := 'La Cuenta No Existe.';
            SET Var_Control := 'cuentaAhoID';
            LEAVE ManejoErrores;
        END IF;

        SELECT PagaIVA,     SucursalOrigen
        INTO Var_PagaIVA,   Var_Sucursal
        FROM CLIENTES
        WHERE ClienteID = Var_ClienteID;

        SET Var_PagaIVA := IFNULL(Var_PagaIVA,Con_NO);
        SET Var_Sucursal := IFNULL(Var_Sucursal, Entero_Cero);

        IF(Var_PagaIVA = Con_SI)THEN
            SET Var_IVA := (SELECT IVA FROM SUCURSALES WHERE SucursalID = Var_Sucursal);
            SET Var_IVA := IFNULL(Var_IVA, Decimal_Cero);
        ELSE
            SET Var_IVA := Decimal_Cero;
        END IF;

        -- Se valida si existe Montos de Comision Pendientes por Cubrir
        SELECT SUM(ComSaldoPromAct + IVAComSalPromAct)
        INTO Var_ExisteMontoPen
        FROM COMSALDOPROMPEND
        WHERE CuentaAhoID = Par_CuentaAhoID
            AND Estatus = Est_Vigente;

        SET Var_ExisteMontoPen := IFNULL(Var_ExisteMontoPen, Decimal_Cero);

        IF(Var_ExisteMontoPen > Decimal_Cero)THEN

            DELETE FROM TMPCOMSALDOPROMPEND WHERE NumTransaccion = Aud_NumTransaccion;

            SET @Consecutivo := Entero_Cero;

            INSERT INTO TMPCOMSALDOPROMPEND(
                RegComision,        ComisionPendienteID,        CuentaAhoID,    NumTransaccion)
            SELECT
                @Consecutivo:=(@Consecutivo+Entero_Uno),    ComisionID,     Par_CuentaAhoID,     Aud_NumTransaccion
            FROM COMSALDOPROMPEND
            WHERE CuentaAhoID = Par_CuentaAhoID
                AND Estatus = Est_Vigente;

            SET Var_Contador := (SELECT COUNT(*)
                                        FROM TMPCOMSALDOPROMPEND
                                        WHERE CuentaAhoID =  Par_CuentaAhoID
                                            AND  NumTransaccion = Aud_NumTransaccion);

            SET Var_Contador := IFNULL(Var_Contador, Entero_Cero);
            SET @FolioID := Entero_Uno;

            WHILE ( @FolioID <= Var_Contador)DO

                IF(Par_MontoMov > Decimal_Cero)THEN

                    SELECT COM.ComisionID,      COM.ComSaldoPromOri,    COM.IVAComSalPromOri,      COM.ComSaldoPromAct,        COM.IVAComSalPromAct
                    INTO Var_ComisionID,        Var_ComSaldoPromOri,    Var_IVAComSalPromOri,       Var_ComSaldoPromAct,        Var_IVAComSalPromAct
                    FROM COMSALDOPROMPEND AS COM
                        INNER JOIN TMPCOMSALDOPROMPEND AS TMP  ON TMP.ComisionPendienteID = COM.ComisionID
                    WHERE TMP.RegComision = @FolioID
                        AND COM.CuentaAhoID = Par_CuentaAhoID
                        AND TMP.NumTransaccion = Aud_NumTransaccion;

                    IF((Var_ComSaldoPromAct +Var_IVAComSalPromAct) > Entero_Cero)THEN

                        -- Se valida el Monto a Aplicar para las Comisiones pendientes
                        SET Var_MontoComApli = CASE  WHEN Par_MontoMov >= (Var_ComSaldoPromAct + Var_IVAComSalPromAct)
                                                    THEN Var_ComSaldoPromAct ELSE ROUND(( Par_MontoMov - ((Par_MontoMov/(1+Var_IVA))*Var_IVA)),2) END;
                        SET Var_MontoIVAApli = CASE WHEN Par_MontoMov >= (Var_ComSaldoPromAct + Var_IVAComSalPromAct)
                                                THEN Var_IVAComSalPromAct ELSE ROUND(((Par_MontoMov/(1+Var_IVA))*Var_IVA),2) END;

                        SET Par_MontoMov := Par_MontoMov - (Var_ComSaldoPromAct + Var_IVAComSalPromAct);

                        -- Se acutaliaza la variable INOUT para llevar control del Monto que se esta Aplicando
                        SET Par_MontoAplicado := Par_MontoAplicado + (Var_MontoComApli + Var_MontoIVAApli );

                        -- Se realiza el Alta de Registro de Comision Pendiente
                        CALL COMSALDOPROMCOBRADOALT(
                            Var_ComisionID,          Par_CuentaAhoID,           Var_ClienteID,          Var_SaldoDispon,        Var_MontoComApli,
                            Var_MontoIVAApli,        Con_NO,                    Par_NumErr,             Par_ErrMen,             Aud_EmpresaID,
                            Aud_Usuario,             Aud_FechaActual,           Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,
                            Aud_NumTransaccion);

                        -- Afectaciones Contables y Operativas Comision Saldo Prom
                        SET Var_SucCLiente := (SELECT IFNULL(SucursalOrigen, 0) FROM CLIENTES WHERE ClienteID= Var_ClienteID);

                        SET Var_CuentaStr 	:= CONCAT("Cta.",CONVERT(Par_CuentaAhoID, CHAR));

                        -- Movimiento Contable Abono de Comision
                        CALL POLIZASAHORROPRO(
                            Par_Poliza,			Aud_EmpresaID,		Var_FechaSis,	        Var_ClienteID,		ConceptoAhoCom,
                            Par_CuentaAhoID,	Var_MonedaID,		Decimal_Cero,			Var_MontoComApli,	Var_DescripcionMov,
                            Var_CuentaStr,		SalidaNO,			Par_NumErr,				Par_ErrMen,			Aud_Usuario,
                            Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

                        IF(Par_NumErr > Entero_Cero)THEN
                            LEAVE ManejoErrores;
                        END IF;

                        -- Movimiento Contable y Operativo Cargo de Comision
                        CALL CONTABAHORROPRO(
                            Par_CuentaAhoID,        Var_ClienteID   ,       Aud_NumTransaccion   ,  Var_FechaSis,       Var_FechaSis,
                            Con_Cargo,              Var_MontoComApli,       Var_DescripcionMov,     Par_CuentaAhoID,    Var_TipoMovAhoIDCom,
                            Var_MonedaID,           Var_SucCLiente,         Con_NO,                 Entero_Cero,        Par_Poliza,
                            Con_SI,                 ConceptoAho,            Con_Cargo,              SalidaNO,           Par_NumErr,
                            Par_ErrMen,             Entero_Cero,            Aud_EmpresaID,          Aud_Usuario,        Aud_FechaActual,
                            Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

                        IF(Par_NumErr > Entero_Cero)THEN
                            LEAVE ManejoErrores;
                        END IF;

                        -- Si el Cliente de la Cuenta Paga IVA se realiza los movimientos Operativos y Contables
                        IF(Var_MontoIVAApli > Entero_Cero)THEN
                            -- Movimiento Contable Abono de IVA Comision
                            CALL POLIZASAHORROPRO(
                                Par_Poliza,			Aud_EmpresaID,		Var_FechaSis,	        Var_ClienteID,		ConceptoAhoIVACom,
                                Par_CuentaAhoID,	Var_MonedaID,		Decimal_Cero,			Var_MontoIVAApli,	Var_DescripcionMovIVA,
                                Var_CuentaStr,		SalidaNO,			Par_NumErr,				Par_ErrMen,			Aud_Usuario,
                                Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

                            IF(Par_NumErr > Entero_Cero)THEN
                                LEAVE ManejoErrores;
                            END IF;

                            -- Movimiento Contable y Opereativo IVA Abono de Comision
                            CALL CONTABAHORROPRO(
                                Par_CuentaAhoID,        Var_ClienteID   ,       Aud_NumTransaccion   ,  Var_FechaSis,       Var_FechaSis,
                                Con_Cargo,              Var_MontoIVAApli,       Var_DescripcionMovIVA,     Par_CuentaAhoID,    Var_TipoMovAhoIDIVACom,
                                Var_MonedaID,           Var_SucCLiente,         Con_NO,                 Entero_Cero,        Par_Poliza,
                                Con_SI,                 ConceptoAho,            Con_Cargo,              SalidaNO,           Par_NumErr,
                                Par_ErrMen,             Entero_Cero,            Aud_EmpresaID,          Aud_Usuario,        Aud_FechaActual,
                                Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

                            IF(Par_NumErr > Entero_Cero)THEN
                                LEAVE ManejoErrores;
                            END IF;
                        END IF;

                        -- Se actualiza los Montos de Saldo Pendiente
                        UPDATE COMSALDOPROMPEND SET
                            ComSaldoPromAct     = ComSaldoPromAct - Var_MontoComApli,
                            IVAComSalPromAct    = IVAComSalPromAct - Var_MontoIVAApli,
                            ComSaldoPromCob     = ComSaldoPromCob + Var_MontoComApli,
                            IVAComSalPromCob    = IVAComSalPromCob + Var_MontoIVAApli,

                            EmpresaID		    = Aud_EmpresaID,
                            Usuario             = Aud_Usuario,
                            FechaActual 	    = Aud_FechaActual,
                            DireccionIP 	    = Aud_DireccionIP,
                            ProgramaID  	    = Aud_ProgramaID,
                            Sucursal		    = Aud_Sucursal,
                            NumTransaccion	    = Aud_NumTransaccion
                        WHERE ComisionID        = Var_ComisionID;

                        -- Se valida si el Monto Cubre el Saldo Pendiente de la Comision
                        SELECT ComSaldoPromAct, IVAComSalPromAct
                        INTO Var_ComSaldoPen,   Var_IVAComSaldoPen
                        FROM COMSALDOPROMPEND
                        WHERE ComisionID  = Var_ComisionID;

                        IF((Var_ComSaldoPen + Var_IVAComSaldoPen) <= Entero_Cero)THEN
                        -- Si no hay saldo pendiente por Cobrar se actualiza el Estatus
                            UPDATE COMSALDOPROMPEND SET
                                Estatus = Est_Pagado
                            WHERE ComisionID = Var_ComisionID;

                        -- Se da de alta al Historico
                            CALL COMSALDOPROMPENDHISALT(
                                Var_ComisionID,     SalidaNO,           Par_NumErr,         Par_ErrMen,         Aud_EmpresaID,
                                Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
                                Aud_NumTransaccion);
                        END IF;
                    END IF;

                END IF;

                SET @FolioID := @FolioID + Entero_Uno;
            END WHILE;
            DELETE FROM TMPCOMSALDOPROMPEND WHERE NumTransaccion = Aud_NumTransaccion;
        END IF;

        SET Par_ErrMen  := CONCAT('Cobro de Comsion Realizada Exitosamente');
        SET Par_NumErr  := 000;
        SET Var_Control  := 'cuentaAhoID' ;

	END ManejoErrores;

	IF(Par_Salida = SalidaSI) THEN
	 SELECT Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
            Par_MontoAplicado AS CampoGenerico;
	END IF;

END TerminaStore$$