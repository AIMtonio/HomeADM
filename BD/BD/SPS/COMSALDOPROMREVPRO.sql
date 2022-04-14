-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COMSALDOPROMREVPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `COMSALDOPROMREVPRO`;
DELIMITER $$


CREATE PROCEDURE `COMSALDOPROMREVPRO`(
	/*SP PARA REALIZAR LA REVERSA DEL SALDO PROMEDIO PAGADO*/
    Par_CobroID                     INT(11),                -- ID DEL COBRO
    Par_ComisionID                  INT(11),                -- ID DE LA COMISION
    Par_ClienteID                   INT(11),                -- CLIENTE ID
    Par_CuentaAhoID                 BIGINT(20),             -- CUENTA DE AHORRO DEL CLIENTE
    Par_SaldoComCobrado             DECIMAL(18,2),          -- SALDO DE COMISION COBRADO

    Par_IVAComCobrada               DECIMAL(18,2),          -- IVA DE LA COMISION COBRADA
    Par_TipoReversa                 INT(11),                -- TIPO DE REVERSA
    Par_MotivoProceso               VARCHAR(200),           -- MOTIVO DEL PROCESO
    Par_UsuarioAutoriza             INT(11),                -- USUARIO QUE AUTORIZA EL PROCESO
    INOUT Par_PolizaID              BIGINT,                 -- Numero de Poliza

    Par_Salida                      CHAR(1),                -- SALIDA
    INOUT Par_NumErr                INT(11),                -- NUMERO DE ERROR
    INOUT Par_ErrMen                VARCHAR(400),           -- MENSAJE DE ERROR
    Aud_EmpresaID                   INT(11),                -- AUDITORIA
    Aud_Usuario                     INT(11),                -- AUDITORIA

    Aud_FechaActual                 DATETIME,               -- AUDITORIA
    Aud_DireccionIP                 VARCHAR(15),            -- AUDITORIA
    Aud_ProgramaID                  VARCHAR(50),            -- AUDITORIA
    Aud_Sucursal                    INT(11),                -- AUDITORIA
    Aud_NumTransaccion              BIGINT(20)              -- AUDITORIA
)



TerminaStore: BEGIN
	-- DECLARACION DE VARIABLES
    DECLARE Var_Control             VARCHAR(50);            -- CONTROL
    DECLARE Var_Consecutivo         INT(11);                -- CONSICUTIVO
    DECLARE Var_FechaRegistro       DATE;                   -- FECHA DE REGISTRO
    DECLARE Var_SaldoTotal          DECIMAL(14,2);          -- SALDO TOTAL DE LA OPERACION
    DECLARE Var_SaldoTotalRev       DECIMAL(14,2);          -- SALDO TOTAL DE LA REVERSA
    DECLARE Var_SaldoActual         DECIMAL(14,2);          -- SALDO PENDIENTE DE COBRO
    DECLARE Var_IVASaldoActual      DECIMAL(14,2);          -- IVA PENDIENTE DE COBRO
    DECLARE Var_Estatus             CHAR(1);                -- ESTATUS
    DECLARE Var_NumeroRegistro      INT(11);                -- NUMERO DE REGISTRO
    DECLARE Var_FechaCobro          DATE;                   -- FECHA DE COBRO
    DECLARE Var_TotalReversa        DECIMAL(14,2);          -- TOTAL DE LA REVERSA
    DECLARE Var_ExisteComPendiente  CHAR(1);                -- EXISTE COMISION PENDIENTE DE COBRO
    DECLARE Var_MesCob              VARCHAR(2);             -- MES DE COBRO COMISION
    DECLARE Var_AnioCob             VARCHAR(4);             -- AÑO DE COBRO DE LA COMISION
    DECLARE Var_MesSis              VARCHAR(2);             -- MES DEL SISTEMA
    DECLARE Var_AnioSis             VARCHAR(4);             -- AÑO DEL SISTEMA
    DECLARE Var_SucCLiente          INT(11);                -- SUCURSAL DEL CLIENTE
    DECLARE Var_Poliza              BIGINT(20);             -- POLIZA CONTABLE
	DECLARE	Var_CuentaStr	        VARCHAR(20);

    -- DECLARACION DE CONSTANTES
    DECLARE Cadena_Vacia            CHAR(1);                -- CADENA VACIA
    DECLARE Entero_Cero             INT(11);                -- ENTERO CERO
    DECLARE Decimal_Cero            DECIMAL(12,2);          -- DICIMAL CERO
    DECLARE SalidaSI                CHAR(1);                 -- SALIDA SI
    DECLARE SalidaNO                CHAR(1);                 -- SALIDA SI

    DECLARE Act_Reversa             INT(11);                -- REVERSA DE COMISION
    DECLARE Act_Condonacion         INT(11);                -- CONDONACION
    DECLARE Con_Abono               CHAR(1);
    DECLARE Con_Cargo               CHAR(1);
    DECLARE Var_DescripcionMov      VARCHAR(150);           -- Descripcion de Movimiento
    DECLARE Var_DescripcionMovIVA   VARCHAR(150);           -- Descripcion de Movimiento
    DECLARE Var_TipoMovAhoIDCom     CHAR(4);                -- Tipo de Movimiento de Ahorro
    DECLARE Var_TipoMovAhoIDIVACom     CHAR(4);                -- Tipo de Movimiento de Ahorro
    DECLARE Con_Moneda              INT(11);                -- Tipo de Moneda
    DECLARE Var_NO                  CHAR(1);                -- Constante NO
    DECLARE Var_SI                  CHAR(1);                -- Constante SI
    DECLARE ConceptoAho             INT;                    -- CONCEPTOSAHORRO Abono a Cta
    DECLARE ConceptoAhoCom          INT;                    -- CONCEPTOSAHORRO Comision por Saldo Promedio
    DECLARE ConceptoAhoIVACom          INT;                 -- CONCEPTOSAHORRO IVA Comision por Saldo Promedio

    -- ASIGNACION DE CONSTANTES
    SET Cadena_Vacia                := "";
    SET Entero_Cero                 := 0;
    SET Decimal_Cero                := 0.0;
    SET SalidaSI                    := "S";
    SET SalidaNO                    := "N";

    SET Act_Condonacion             := 1;
    SET Act_Reversa                 := 2;
    SET Con_Abono                   := 'A';
    SET Con_Cargo                   := 'C';
    SET Var_DescripcionMov          := 'REVERSA COMISION SALDO PROMEDIO';
    SET Var_DescripcionMovIVA       := 'REVERSA IVA COMISION SALDO PROMEDIO';
    SET Var_TipoMovAhoIDCom         := '230';
    SET Var_TipoMovAhoIDIVACom      := '231';
    SET Con_Moneda                  := 1;
    SET Var_NO                      := 'N';
    SET ConceptoAho                 := 1;
    SET ConceptoAhoCom              := 35;
    SET ConceptoAhoIVACom           := 36;
    SET Var_SI                      := 'S';

     ManejoErrores:BEGIN 	#bloque para manejar los posibles errores
     DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
            SET Par_NumErr = 999;
            SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que  ',
                            'esto le ocasiona. Ref: SP-COMSALDOPROMREVPRO');
            SET Var_Control = 'sqlException' ;
        END;

    SELECT FechaSistema INTO  Var_FechaRegistro
        FROM PARAMETROSSIS LIMIT 1;

    SET Var_MesSis := MONTH(Var_FechaRegistro);
    SET Var_AnioSis := YEAR(Var_FechaRegistro);


    IF(Par_ClienteID = Entero_Cero)THEN
        SET Par_NumErr := 01;
        SET Par_ErrMen := 'El cliente esta vacio.';
        SET Var_Control := 'clienteID';
        LEAVE ManejoErrores;
    END IF;

    IF(Par_CuentaAhoID = Entero_Cero)THEN
        SET Par_NumErr := 02;
        SET Par_ErrMen := 'La cuenta esta vacia.';
        SET Var_Control := 'cuentaAhoID';
        LEAVE ManejoErrores;
    END IF;

    IF(Par_UsuarioAutoriza = Entero_Cero)THEN
        SET Par_NumErr := 03;
        SET Par_ErrMen := 'El usaurio que autoriza esta vacio.';
        SET Var_Control := 'usuarioAutoriza';
        LEAVE ManejoErrores;
    END IF;

    SELECT COUNT(ComisionID)
        INTO Var_NumeroRegistro
        FROM COMSALDOPROMCOBRADO
    WHERE ComisionID  = Par_ComisionID
    AND CobroID = Par_CobroID
    AND ComisionID!= Entero_Cero
    AND OrigenCobro=Con_Abono;

    IF(Var_NumeroRegistro=Entero_Cero)THEN
        SET Par_NumErr := 04;
        SET Par_ErrMen := 'No existe la comision.';
        SET Var_Control := 'clienteID';
        LEAVE ManejoErrores;
    END IF;

    SELECT   ComSaldoPromCob,       IVAComSalPromCob,        FechaCobro,         TotalCobrado
        INTO Var_SaldoActual,       Var_IVASaldoActual,      Var_FechaCobro,     Var_TotalReversa
    FROM COMSALDOPROMCOBRADO
    WHERE ComisionID  = Par_ComisionID
    AND CobroID = Par_CobroID;

    SET Var_SaldoTotalRev := IFNULL(Var_SaldoActual, Decimal_Cero)+IFNULL(Var_IVASaldoActual, Decimal_Cero);
    SET Var_SaldoTotal := IFNULL(Par_SaldoComCobrado, Decimal_Cero)+IFNULL(Par_IVAComCobrada, Decimal_Cero);
    SET Var_MesCob := MONTH(Var_FechaCobro);
    SET Var_AnioCob := YEAR(Var_FechaCobro);

    IF(Par_TipoReversa = Entero_Cero)THEN
        SET Par_NumErr := 05;
        SET Par_ErrMen := 'El el tipo de reversa esta vacio.';
        SET Var_Control := 'clienteID';
        LEAVE ManejoErrores;
    END IF;

    IF(Par_SaldoComCobrado = Decimal_Cero)THEN
        SET Par_NumErr := 06;
        SET Par_ErrMen := 'El saldo de la reversa esta vacio.';
        SET Var_Control := 'clienteID';
        LEAVE ManejoErrores;
    END IF;

    IF(Var_MesCob!=Var_MesSis OR Var_AnioCob!=Var_AnioSis)THEN
        SET Par_NumErr := 08;
        SET Par_ErrMen := CONCAT('La comision ',Par_ComisionID,' no corresponde al mes de <b>',Var_MesSis,'</b>.');
        SET Var_Control := 'clienteID';
        LEAVE ManejoErrores;
    END IF;

    SELECT CASE IFNULL(ComisionID, Entero_Cero) WHEN Entero_Cero THEN 'N' ELSE 'S' END
        INTO Var_ExisteComPendiente
        FROM COMSALDOPROMPEND
        WHERE ComisionID  = Par_ComisionID;

    IF(Var_ExisteComPendiente='S')THEN
        UPDATE COMSALDOPROMPEND
            SET ComSaldoPromCob     = (ComSaldoPromCob-Par_SaldoComCobrado),
                IVAComSalPromCob    = (IVAComSalPromCob-Par_IVAComCobrada),
                ComSaldoPromAct     = (ComSaldoPromAct+Par_SaldoComCobrado),
                IVAComSalPromAct    = (IVAComSalPromAct +Par_IVAComCobrada),
                Estatus             = 'V',

                EmpresaID		    = Aud_EmpresaID,
                Usuario             = Aud_Usuario,
                FechaActual 	    = Aud_FechaActual,
                DireccionIP 	    = Aud_DireccionIP,
                ProgramaID  	    = Aud_ProgramaID,
                Sucursal		    = Aud_Sucursal,
                NumTransaccion	    = Aud_NumTransaccion
            WHERE ComisionID        = Par_ComisionID;
    END IF;


    IF(Var_ExisteComPendiente='N')THEN
        CALL COMSALDOPROMPENDALT(Var_FechaRegistro,         Par_CuentaAhoID,        Par_SaldoComCobrado,          Par_IVAComCobrada,
                                Par_SaldoComCobrado,        Par_IVAComCobrada,        Entero_Cero,                  Entero_Cero,
                                Entero_Cero,                Entero_Cero,
                                Aud_EmpresaID,              Aud_Usuario,            Aud_FechaActual,                Aud_DireccionIP,
                                Aud_ProgramaID,             Aud_Sucursal,           Aud_NumTransaccion
                                );

        IF(Par_NumErr!=Entero_Cero)THEN
            LEAVE ManejoErrores;
        END IF;
    END IF;


    CALL COMSALDOPROMREVALT(Par_CuentaAhoID,           Var_FechaRegistro,              Var_FechaCobro,                Par_SaldoComCobrado,           Par_IVAComCobrada,
                            Var_TotalReversa,          Par_UsuarioAutoriza,            Par_MotivoProceso,             Par_TipoReversa,                 SalidaNO,
                            Par_NumErr,                Par_ErrMen,                    Aud_EmpresaID,                  Aud_Usuario,                     Aud_FechaActual,
                            Aud_DireccionIP,           Aud_ProgramaID,                Aud_Sucursal,                   Aud_NumTransaccion);

    IF(Par_NumErr!=Entero_Cero)THEN
            LEAVE ManejoErrores;
    END IF;

    -- SE REGREDA EL MONTO A LA CUENTA DEL CLIENTE
    SET Var_SucCLiente := (SELECT IFNULL(SucursalOrigen, 0) FROM CLIENTES WHERE ClienteID= Par_ClienteID);

    -- Movimiento Contable y Operativo  de Abono a Cta
    CALL CARGOABONOCTAPRO(Par_CuentaAhoID,          Par_ClienteID,          Aud_NumTransaccion,             Var_FechaRegistro,          Var_FechaRegistro,
                         Con_Abono,                 Par_SaldoComCobrado,    Var_DescripcionMov,             Par_CuentaAhoID,            Var_TipoMovAhoIDCom,
                         Con_Moneda,                Var_SucCLiente,         Var_NO,                         Entero_Cero,                Par_PolizaID,
                         Var_SI,                    ConceptoAhoCom,         Con_Abono,                      SalidaNO,                   Par_NumErr,
                         Par_ErrMen,                Entero_Cero,
                         Aud_EmpresaID,             Aud_Usuario,            Aud_FechaActual,                Aud_DireccionIP,            Aud_ProgramaID,
                         Aud_Sucursal,              Aud_NumTransaccion);

    IF(Par_NumErr!=Entero_Cero)THEN
            LEAVE ManejoErrores;
    END IF;

    SET Var_CuentaStr 	:= CONCAT("Cta.",CONVERT(Par_CuentaAhoID, CHAR));

    -- Movimiento Contable Cargo de Comision
    CALL POLIZASAHORROPRO(
        Par_PolizaID,		Aud_EmpresaID,		Var_FechaRegistro,      Par_ClienteID,		ConceptoAhoCom,
        Par_CuentaAhoID,	Con_Moneda,		    Par_SaldoComCobrado,    Decimal_Cero,		Var_DescripcionMov,
        Var_CuentaStr,		SalidaNO,			Par_NumErr,				Par_ErrMen,			Aud_Usuario,
        Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

    IF(Par_NumErr > Entero_Cero)THEN
        LEAVE ManejoErrores;
    END IF;

    -- Movimiento Contable y Operativo  de Abono a Cta IVA comision
    CALL CARGOABONOCTAPRO(Par_CuentaAhoID,          Par_ClienteID,          Aud_NumTransaccion,             Var_FechaRegistro,          Var_FechaRegistro,
                         Con_Abono,                 Par_IVAComCobrada,      Var_DescripcionMovIVA,          Par_CuentaAhoID,            Var_TipoMovAhoIDIVACom,
                         Con_Moneda,                Var_SucCLiente,         Var_NO,                         Entero_Cero,                Par_PolizaID,
                         Var_SI,                    ConceptoAhoCom,         Con_Abono,                      SalidaNO,                   Par_NumErr,
                         Par_ErrMen,                Entero_Cero,
                         Aud_EmpresaID,             Aud_Usuario,            Aud_FechaActual,                Aud_DireccionIP,            Aud_ProgramaID,
                         Aud_Sucursal,              Aud_NumTransaccion);

    IF(Par_NumErr!=Entero_Cero)THEN
            LEAVE ManejoErrores;
    END IF;

    -- Movimiento Contable Cargo de IVA Comision
    CALL POLIZASAHORROPRO(
        Par_PolizaID,		Aud_EmpresaID,		Var_FechaRegistro,      Par_ClienteID,		ConceptoAhoIVACom,
        Par_CuentaAhoID,	Con_Moneda,		    Par_IVAComCobrada,      Decimal_Cero,		Var_DescripcionMovIVA,
        Var_CuentaStr,		SalidaNO,			Par_NumErr,				Par_ErrMen,			Aud_Usuario,
        Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

    IF(Par_NumErr > Entero_Cero)THEN
        LEAVE ManejoErrores;
    END IF;

    -- SE ELIMINA EL REGISTRO DE LA TABLA DE COBRADOS
    DELETE FROM  COMSALDOPROMCOBRADO
        WHERE ComisionID  = Par_ComisionID
        AND CobroID = Par_CobroID;

    SET Par_NumErr  := 000;
    SET Par_ErrMen  := CONCAT('Reversa Realizada Exitosamente: Cuenta[<b>',Par_CuentaAhoID,'</b>]');
    SET Var_Control  := 'cuentaAhoID';


END ManejoErrores;

	IF(Par_Salida = SalidaSI) THEN
	 SELECT Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Par_CuentaAhoID AS Consecutivo;
	END IF;

END TerminaStore$$