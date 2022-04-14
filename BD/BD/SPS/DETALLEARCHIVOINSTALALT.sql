-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEARCHIVOINSTALALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `DETALLEARCHIVOINSTALALT`;

DELIMITER $$
CREATE PROCEDURE `DETALLEARCHIVOINSTALALT`(
    -- STORE PARA LA ALTA DE LOS DETALLES DE LOS ARCHIVOS DE INSTALACION.
    Par_FolioID         INT(11),        -- Identificador del folio del archivo de instalacion.
    Par_CreditoID       INT(11),        -- Identificador del Credito.
    Par_Estatus         CHAR(1),        -- Estado del detalle.
    Par_FechaLimite     DATE,           -- Fecha limite de envio del archivo de instalacion

    Par_Salida			CHAR(1),		-- Parametro Establece si requiere Salida
	INOUT Par_NumErr	INT(11),		-- Parametro INOUT para el Numero de Error
	INOUT Par_ErrMen	VARCHAR(400),	-- Parametro INOUT para la Descripcion del Error


    /* Parametros de Auditoria */
    Aud_EmpresaID   	INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

    -- Declaracion de Variables
    DECLARE Var_DetalleArchivoID    INT(11);
    DECLARE Var_Control             VARCHAR(50);
    DECLARE Var_Consecutivo         INT(11);
    DECLARE Var_ConvenioNomina      INT(11);
    DECLARE Var_InstitucionNomina   INT(11);

    -- Declaracion de Constates
    DECLARE Cadena_Vacia    CHAR(1);
    DECLARE Entero_Cero     INt(1);
    DECLARE Fecha_Vacia     DATE;
    DECLARE SalidaSI        CHAR(1);

    -- Asignacion de Constantes
    SET Cadena_Vacia        :=  '';
    SET Entero_Cero         :=  0;
    SET Fecha_Vacia         :=  '1900-01-01';
    SET SalidaSI            :=  'S';
    SET Aud_FechaActual     :=  NOW();

    ManejoErrores: BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr  =  999;
            SET Par_ErrMen  =  CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                    'Disculpe las molestias que esto le ocasiona. Ref: SP-CRENOMINAARCHINSTALALT');
            SET Var_Control =  'SQLEXCEPTION';
        END;

        -- Obtención del folio nuevo
        SELECT IFNULL(MAX(DetalleArchivoID),Entero_Cero)+1
        INTO Var_DetalleArchivoID
        FROM DETALLEARCHIVOINSTAL;

        IF(IFNULL(Par_FolioID, Entero_Cero)= Entero_Cero) THEN
            SET Par_NumErr  :=  002;
            SET Par_ErrMen  :=  'El FolioID se encuentra vacio';
            SET Var_Control :=  'folioID';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_CreditoID, Entero_Cero)= Entero_Cero) THEN
            SET Par_NumErr  :=  003;
            SET Par_ErrMen  :=  'El CreditoID esta vacio';
            SET Var_Control :=  'creditoID';
            LEAVE ManejoErrores;
        END IF;


        -- Inserccion de un nuevo registro en la tabla DETALLEARCHIVOINSTAL
        INSERT INTO `DETALLEARCHIVOINSTAL`(
            DetalleArchivoID,           FolioID,            CreditoID,          Estatus,            FechaLimiteRecep,
            EmpresaID,                  Usuario,            FechaActual,        DireccionIP,        ProgramaID,
            Sucursal,                   NumTransaccion)
        VALUES  (
            Var_DetalleArchivoID,       Par_FolioID,        Par_CreditoID,      Par_Estatus,        Par_FechaLimite,
            Aud_EmpresaID,              Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
            Aud_Sucursal,               Aud_NumTransaccion);

        SET Par_NumErr      :=  0;
        SET Par_ErrMen      :=  CONCAT('Registro Agregado con el ID:', Var_DetalleArchivoID);
        SET Var_Control     :=  'detalleArchivoID';
        SET Var_Consecutivo :=  Var_DetalleArchivoID;

    END ManejoErrores;

    IF(Par_Salida = SalidaSI) THEN
        SELECT  Par_NumErr      AS  NumErr,
                Par_ErrMen      AS  ErrMen,
                Var_Control     AS  Control,
                Var_Consecutivo AS  Consecutivo;
    END IF;

END TerminaStore$$
