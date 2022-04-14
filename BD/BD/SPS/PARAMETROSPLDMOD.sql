-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMETROSPLDMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMETROSPLDMOD`;DELIMITER $$

CREATE PROCEDURE `PARAMETROSPLDMOD`(

	Par_FolioID					INT(11),
	Par_ClaveEntCasfim			CHAR(7),
	Par_ClaveOrgSupervisor		CHAR(6),
	Par_ClaveOrgSupervisorExt	CHAR(3),
    Par_Salida          		CHAR(1),

    INOUT Par_NumErr    		INT,
    INOUT Par_ErrMen    		VARCHAR(400),

	Aud_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,

	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
					)
TerminaStore:BEGIN


DECLARE Var_Control			VARCHAR(20);


DECLARE Entero_Cero			INT;
DECLARE Decimal_Cero		DECIMAL(14,2);
DECLARE Cadena_Vacia		CHAR;
DECLARE	Fecha_Vacia			DATE;
DECLARE ValorSi 			CHAR(1);
DECLARE SalidaSi 			CHAR(1);


SET Entero_Cero			:= 0;
SET Decimal_Cero		:= 0.0;
SET Cadena_Vacia		:= '';
SET	Fecha_Vacia			:= '1900-01-01';
SET ValorSi 			:= 'S';
SET SalidaSi 			:= 'S';

SET Aud_FechaActual		:= NOW();

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PARAMETROSPLDMOD');
			SET Var_Control := 'sqlException' ;
		END;

    IF(IFNULL(Par_FolioID,Entero_Cero)=Entero_Cero)THEN
		SET	Par_NumErr		:= 001;
		SET	Par_ErrMen		:= 'El Numero de Folio se encuentra vacio.';
		SET Var_Control 	:= 'folioID' ;
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_ClaveOrgSupervisor,Cadena_Vacia)=Cadena_Vacia)THEN
		SET	Par_NumErr		:= 002;
		SET	Par_ErrMen		:= 'La Clave del Organo Supervisor se encuentra vacia.';
		SET Var_Control 	:= 'claveOrgSupervisor' ;
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_ClaveOrgSupervisorExt,Cadena_Vacia)=Cadena_Vacia)THEN
		SET	Par_NumErr		:= 003;
		SET	Par_ErrMen		:= 'La Extension del Organo Supervisor se encuentra vacia.';
		SET Var_Control 	:= 'claveOrgSupervisorExt' ;
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_ClaveEntCasfim,Cadena_Vacia)=Cadena_Vacia)THEN
		SET	Par_NumErr		:= 004;
		SET	Par_ErrMen		:= 'La Clave de la Entidad Financiera se encuentra vacia.';
		SET Var_Control 	:= 'claveEntCasfim' ;
        LEAVE ManejoErrores;
    END IF;

    UPDATE PARAMETROSPLD SET
		ClaveEntCasfim 			= Par_ClaveEntCasfim,
		ClaveOrgSupervisor		= Par_ClaveOrgSupervisor,
		ClaveOrgSupervisorExt	= Par_ClaveOrgSupervisorExt,
        EmpresaID				= Aud_EmpresaID,
        Usuario					= Aud_Usuario,
        FechaActual				= Aud_FechaActual,
		DireccionIP				= Aud_DireccionIP,

        ProgramaID				= Aud_ProgramaID,
        Sucursal				= Aud_Sucursal,
        NumTransaccion			= Aud_NumTransaccion
        WHERE FolioID			= Par_FolioID;

	SET	Par_NumErr		:= 000;
	SET	Par_ErrMen		:= CONCAT('Parametros Modificados Exitosamente. Folio: ', CONVERT(Par_FolioID, CHAR));
	SET Var_Control 	:= 'folioID' ;

END ManejoErrores;

IF(Par_Salida = SalidaSi) THEN
    SELECT 	Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS Control,
            Entero_Cero AS Consecutivo;
END IF;

END TerminaStore$$