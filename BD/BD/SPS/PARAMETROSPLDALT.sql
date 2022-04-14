-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMETROSPLDALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMETROSPLDALT`;DELIMITER $$

CREATE PROCEDURE `PARAMETROSPLDALT`(

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
DECLARE Var_Consecutivo		INT(11);
DECLARE Var_FechaVigencia	DATE;


DECLARE Entero_Cero			INT;
DECLARE Decimal_Cero		DECIMAL(14,2);
DECLARE Cadena_Vacia		CHAR;
DECLARE	Fecha_Vacia			DATE;
DECLARE ValorSi 			CHAR(1);
DECLARE SalidaSi 			CHAR(1);
DECLARE EstatusVigente		char(1);


SET Entero_Cero			:= 0;
SET Decimal_Cero		:= 0.00;
SET Cadena_Vacia		:= '';
SET	Fecha_Vacia			:= '1900-01-01';
SET ValorSi 			:= 'S';
SET SalidaSi 			:= 'S';
SET EstatusVigente		:= 'V';

SET Aud_FechaActual		:= NOW();
SET Var_FechaVigencia 	:= (SELECT FechaSistema FROM PARAMETROSSIS);

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PARAMETROSPLDALT');
			SET Var_Control := 'sqlException' ;
		END;

    IF(IFNULL(Par_ClaveEntCasfim,Cadena_Vacia)=Cadena_Vacia)THEN
		SET	Par_NumErr		:= 001;
		SET	Par_ErrMen		:= 'La Clave de la Entidad Financiera se encuentra vacia.';
		SET Var_Control 	:= 'claveEntCasfim' ;
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


	CALL FOLIOSAPLICAACT('PARAMETROSPLD', Var_Consecutivo);

    INSERT INTO PARAMETROSPLD (
		FolioID, 				ClaveEntCasfim,			ClaveOrgSupervisor,		ClaveOrgSupervisorExt,		Estatus,
        FechaVigencia,	        EmpresaID,				Usuario,	 			FechaActual,				DireccionIP,
        ProgramaID,		        Sucursal,				NumTransaccion
	) VALUES (
		Var_Consecutivo,		Par_ClaveEntCasfim, 	Par_ClaveOrgSupervisor,	Par_ClaveOrgSupervisorExt,	EstatusVigente,
        Var_FechaVigencia,      Aud_EmpresaID,			Aud_Usuario,			Aud_FechaActual,			Aud_DireccionIP,
        Aud_ProgramaID,	        Aud_Sucursal,			Aud_NumTransaccion
	);

	SET	Par_NumErr		:= 000;
	SET	Par_ErrMen		:= CONCAT('Parametros Agregados Exitosamente. Folio: ', CONVERT(Var_Consecutivo,CHAR));
	SET Var_Control 	:= 'folioID' ;

END ManejoErrores;

IF(Par_Salida = SalidaSi) THEN
    SELECT 	Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS Control,
            Var_Consecutivo AS Consecutivo;
END IF;

END TerminaStore$$