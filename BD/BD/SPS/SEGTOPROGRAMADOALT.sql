-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOPROGRAMADOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGTOPROGRAMADOALT`;DELIMITER $$

CREATE PROCEDURE `SEGTOPROGRAMADOALT`(
    Par_CreditoID             BIGINT(12),
    Par_GrupoID               INT(11),
    Par_FechaProgramada       DATE,
    Par_HoraProgramada        CHAR(5),
    Par_CategoriaID           INT(11),

    Par_PuestoResponsableID   INT(11),
    Par_PuestoSupervisorID    INT(11),
    Par_TipoGeneracion        CHAR(1),
    Par_SecSegtoForzado       INT(11),
    Par_FechaRegistro         DATE,

    Par_Estatus               CHAR(1),
    Par_EsForzado             CHAR(1),

    Par_Salida                CHAR(1),
    INOUT Par_NumErr          INT,
    INOUT Par_ErrMen          VARCHAR(400),

    Par_EmpresaID             INT(11),
    Aud_Usuario               INT(11),
    Aud_FechaActual           DATETIME,
    Aud_DireccionIP           VARCHAR(15),
    Aud_ProgramaID            VARCHAR(50),
    Aud_Sucursal              INT(11),
    Aud_NumTransaccion        BIGINT(20)
    )
TerminaStore: BEGIN


    DECLARE Par_SegtoPrograID   INT(11);
    DECLARE Var_NoEsForzado     CHAR(1);
    DECLARE Var_ProspectoID     INT;
    DECLARE Var_ClienteID       INT;
    DECLARE Var_SolicitudCre    INT;
    DECLARE Var_FormCobCom      CHAR(1);
    DECLARE Var_EstFondeo       CHAR(1);
    DECLARE Var_SaldoFondo      DECIMAL(14,2);
    DECLARE Var_TasaPasiva      DECIMAL(14,4);
    DECLARE Fon_ClienteID       INT(11);
    DECLARE Fon_CuentaAhoID     BIGINT(12);
    DECLARE Var_FecIniLin       DATE;
    DECLARE Var_FecMaxVenL      DATE;
    DECLARE Var_FecMaxAmort     DATE;
    DECLARE Var_FecFinLin       DATE;
    DECLARE Var_PeIguIntCap     CHAR(1);
    DECLARE Var_CicloCliente    INT;
    DECLARE Var_CicloGrupo      INT;
    DECLARE Var_CicloPondGrupo  INT;
    DECLARE Var_PonderaCiclo    CHAR(1);
    DECLARE Var_CicloActual     INT;
    DECLARE Var_SalCapConta     DECIMAL(14,2);
    DECLARE Var_ValidaCapConta  CHAR(1);
    DECLARE Var_PorcMaxCapConta DECIMAL(12,4);
    DECLARE Var_MonMaxPer       DECIMAL(14,2);


    DECLARE Entero_Cero             INT;
    DECLARE Decimal_Cero            DECIMAL(12,2);
    DECLARE Cadena_Vacia            CHAR(1);
    DECLARE Fecha_Vacia             DATE;
    DECLARE Par_NumErr              INT;
    DECLARE Par_ErrMen              VARCHAR(400);
    DECLARE SalidaNO                CHAR(1);
    DECLARE SalidaSI                CHAR(1);
    DECLARE SiPagaIVA               CHAR(1);
    DECLARE NoPagaIVA               CHAR(1);
    DECLARE EstInactiva             CHAR(1);
    DECLARE Estatus_Activo          CHAR(1);
    DECLARE Rec_Propios             CHAR(1);
    DECLARE Rec_Fondeo              CHAR(1);
    DECLARE Var_TipoFond            INT;
    DECLARE Var_TipPagCapC          CHAR(1);
    DECLARE PerIgualCapInt          CHAR(1);
    DECLARE PonderaCiclo_SI         CHAR(1);
    DECLARE Var_Estatus             CHAR(1);
    DECLARE ClienteInactivo         CHAR(1);
    DECLARE Var_Renovado            CHAR(1);
    DECLARE Var_Nuevo               CHAR(1);
    DECLARE Entero_Uno              INT(11);
    DECLARE Si_ValidaCapConta       CHAR(1);
    DECLARE Var_Control             VARCHAR(200);
    DECLARE Var_Consecutivo         INT(11);


    SET Entero_Cero     := 0;
    SET Decimal_Cero    := 0.0;
    SET Fecha_Vacia     := '1900-01-01';
    SET Cadena_Vacia    := '';
    SET SalidaSI        := 'S';
    SET SalidaNO        := 'N';
    SET SiPagaIVA       := 'S';
    SET NoPagaIVA       := 'N';
    SET EstInactiva     := 'I';

    SET Estatus_Activo  := 'A';
    SET Rec_Propios     := 'P';
    SET Rec_Fondeo      := 'F';
    SET Var_TipoFond    := 1;
    SET Var_TipPagCapC  := 'C';
    SET PerIgualCapInt  := 'S';
    SET PonderaCiclo_SI := 'S';
    SET ClienteInactivo := 'I';

    SET Var_Renovado    := 'R';
    SET Var_Nuevo       := 'N';
    SET Entero_Uno      := 1;
    SET Si_ValidaCapConta:= 'S';

    SET Var_NoEsForzado  := 'N';


    SET Par_NumErr  := 0;
    SET Par_ErrMen  := '';

ManejoErrores:BEGIN

        DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
                SET Par_NumErr  := 999;
                SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que',
                                ' esto le ocasiona. Ref: SP-SEGTOPROGRAMADOALT');
                SET Var_Control := 'sqlException';
            END;

    IF(Par_CreditoID = Entero_Cero AND Par_GrupoID = Entero_Cero) THEN
        SET Par_NumErr  :=  '001';
        SET Par_ErrMen  :=  'Especifique un el Numero de Credito o Grupo';
        SET Var_Control :=  'creditoID' ;
        SET Var_Consecutivo := Entero_Cero;
        LEAVE ManejoErrores;
    END IF;

    SET Aud_FechaActual := NOW();

    CALL FOLIOSAPLICAACT('SEGTOPROGRAMADO', Par_SegtoPrograID);

    IF (Par_FechaRegistro = Fecha_Vacia )THEN
        SET Par_FechaRegistro := (SELECT DATE_FORMAT(NOW(), '%Y-%m-%d'));
    END IF;

    INSERT INTO SEGTOPROGRAMADO (
        SegtoPrograID,      CreditoID,          GrupoID,                FechaProgramada,
        HoraProgramada,     CategoriaID,        PuestoResponsableID,    PuestoSupervisorID,
        TipoGeneracion,     SecSegtoForzado,    FechaRegistro,          Estatus,
        EsForzado,          EmpresaID,          Usuario,                FechaActual,
        DireccionIP,        ProgramaID,         Sucursal,               NumTransaccion)
    VALUES(
        Par_SegtoPrograID,  Par_CreditoID,      Par_GrupoID,            Par_FechaProgramada,
        Par_HoraProgramada, Par_CategoriaID,    Par_PuestoResponsableID,Par_PuestoSupervisorID,
        Par_TipoGeneracion, Par_SecSegtoForzado,Par_FechaRegistro,      Par_Estatus,
        Par_EsForzado,      Par_EmpresaID,      Aud_Usuario,            Aud_FechaActual,
        Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,           Aud_NumTransaccion);

END ManejoErrores;

    IF(Par_Salida =SalidaSI) THEN
        SELECT '000' AS NumErr,
                CONCAT("Seguimiento Manual Agregado Exitosamente: ",Par_SegtoPrograID)  AS ErrMen,
                'segtoPrograID' AS control,
                Par_SegtoPrograID AS consecutivo;
    END IF;

END TerminaStore$$