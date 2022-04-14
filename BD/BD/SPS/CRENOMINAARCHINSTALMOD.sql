-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRENOMINAARCHINSTALMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRENOMINAARCHINSTALMOD`;

DELIMITER $$
CREATE PROCEDURE `CRENOMINAARCHINSTALMOD`(
    -- STORE PARA LA MODIFICACION DEL ESTATUS DE LOS FOLIOS DE ARCHIVOS DE INSTALACION.
    Par_FolioID         INT(11),        -- Identificador de la Institucion de Nomina.
    Par_Estatus         CHAR(1),        -- Estatus del Folio del archivo de instalacion. E - Enviado. P - Procesado.

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
    DECLARE Var_FolioID             INT(11);
    DECLARE Var_Control             VARCHAR(50);
    DECLARE Var_Consecutivo         INT(11);

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
                                    'Disculpe las molestias que esto le ocasiona. Ref: SP-CRENOMINAARCHINSTALMOD');
            SET Var_Control =  'SQLEXCEPTION';
        END;

        -- Obtención del folio nuevo
        SELECT IFNULL(MAX(FolioID),Entero_Cero)+1
        INTO Var_FolioID
        FROM CRENOMINAARCHINSTAL;

        IF(IFNULL(Par_Estatus, Cadena_Vacia)= Cadena_Vacia) THEN
            SET Par_NumErr  :=  001;
            SET Par_ErrMen  :=  'El Estatus no Debe Estar Vacio';
            SET Var_Control :=  'estatus';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_FolioID, Entero_Cero)= Entero_Cero) THEN
            SET Par_NumErr  :=  002;
            SET Par_ErrMen  :=  'El Folio no Debe Estar Vacio';
            SET Var_Control :=  'folioID';
            LEAVE ManejoErrores;
        END IF;

        -- Validaciones de existencia

        SELECT IFNULL(FolioID,Entero_Cero)
        INTO Var_FolioID
        FROM CRENOMINAARCHINSTAL
        WHERE FolioID = Par_FolioID;

        IF(IFNULL(Var_FolioID, Entero_Cero)= Entero_Cero) THEN
            SET Par_NumErr  :=  005;
            SET Par_ErrMen  :=  'El Folio no existe';
            SET Var_Control :=  'folioID';
            LEAVE ManejoErrores;
        END IF;

        -- Modificacion de un registro de la tabla CRENOMINAARCHINSTAL
        UPDATE CRENOMINAARCHINSTAL AL
        SET
            AL.Estatus = Par_Estatus
        WHERE
            AL.FolioID = Par_FolioID;


        SET Par_NumErr      :=  0;
        SET Par_ErrMen      :=  CONCAT('Registro modificado con el folio:', Var_FolioID);
        SET Var_Control     :=  'folioID';
        SET Var_Consecutivo :=  Var_FolioID;

    END ManejoErrores;

    IF(Par_Salida = SalidaSI) THEN
        SELECT  Par_NumErr      AS  NumErr,
                Par_ErrMen      AS  ErrMen,
                Var_Control     AS  Control,
                Var_Consecutivo AS  Consecutivo;
    END IF;

END TerminaStore$$
