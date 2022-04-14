-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRENOMINAARCHINSTALALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRENOMINAARCHINSTALALT`;

DELIMITER $$
CREATE PROCEDURE `CRENOMINAARCHINSTALALT`(
    -- STORE PARA LA ALTA DE LOS FOLIOS DE ARCHIVOS DE INSTALACION.
    Par_Descripcion     VARCHAR(100),   -- Descripcion breve de los creditos relacionados al folio
    Par_InstitucionID   INT(11),        -- Identificador de la Institucion de Nomina.
    Par_ConvenioID      INT(11),        -- Identificador del Convenio de Nomina.

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
    DECLARE Var_ConvenioNomina      INT(11);
    DECLARE Var_InstitucionNomina   INT(11);
    DECLARE Var_EstatusEnviado      CHAR(1);

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
    SET Var_EstatusEnviado  := 'E';

    ManejoErrores: BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr  =  999;
            SET Par_ErrMen  =  CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                    'Disculpe las molestias que esto le ocasiona. Ref: SP-CRENOMINAARCHINSTALALT');
            SET Var_Control =  'SQLEXCEPTION';
        END;

        -- Obtención del folio nuevo
        SELECT IFNULL(MAX(FolioID),Entero_Cero)+1
        INTO Var_FolioID
        FROM CRENOMINAARCHINSTAL;

        IF(IFNULL(Par_Descripcion, Cadena_Vacia)= Cadena_Vacia) THEN
            SET Par_NumErr  :=  001;
            SET Par_ErrMen  :=  'La Descripcion no Debe Estar Vacio';
            SET Var_Control :=  'descripcion';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_InstitucionID, Entero_Cero)= Entero_Cero) THEN
            SET Par_NumErr  :=  002;
            SET Par_ErrMen  :=  'La Institucion no Debe Estar Vacio';
            SET Var_Control :=  'institucionID';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_ConvenioID, Entero_Cero)= Entero_Cero) THEN
            SET Par_NumErr  :=  003;
            SET Par_ErrMen  :=  'El Convenio no Debe Estar Vacio';
            SET Var_Control :=  'convenioID';
            LEAVE ManejoErrores;
        END IF;

        -- Validaciones de existencia

        SELECT IFNULL(InstitNominaID,Entero_Cero)
        INTO Var_InstitucionNomina
        FROM INSTITNOMINA
        WHERE InstitNominaID = Par_InstitucionID;

        IF(IFNULL(Var_InstitucionNomina, Entero_Cero)= Entero_Cero) THEN
            SET Par_NumErr  :=  004;
            SET Par_ErrMen  :=  'La institucion de nomina no existe';
            SET Var_Control :=  'institucionID';
            LEAVE ManejoErrores;
        END IF;

        SELECT IFNULL(ConvenioNominaID,Entero_Cero)
        INTO Var_ConvenioNomina
        FROM CONVENIOSNOMINA
        WHERE ConvenioNominaID = Par_ConvenioID
        AND InstitNominaID = Par_InstitucionID;

        IF(IFNULL(Var_ConvenioNomina, Entero_Cero)= Entero_Cero) THEN
            SET Par_NumErr  :=  005;
            SET Par_ErrMen  :=  'El convenio de nomina no existe';
            SET Var_Control :=  'convenioID';
            LEAVE ManejoErrores;
        END IF;

        -- Inserccion de un nuevo registro en la tabla CRENOMINAARCHINSTAL
        INSERT INTO `CRENOMINAARCHINSTAL`(
            FolioID,        Descripcion,        InstitucionID,      ConvenioID,         Estatus,
            EmpresaID,      Usuario,            FechaActual,        DireccionIP,        ProgramaID,
            Sucursal,       NumTransaccion)
        VALUES  (
            Var_FolioID,    Par_Descripcion,    Par_InstitucionID,  Par_ConvenioID,     Var_EstatusEnviado,
            Aud_EmpresaID,  Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
            Aud_Sucursal,   Aud_NumTransaccion);

        SET Par_NumErr      :=  0;
        SET Par_ErrMen      :=  CONCAT('Registro Agregado con el folio:', Var_FolioID);
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
