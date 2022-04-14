-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISPARAMETROSESCALAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `HISPARAMETROSESCALAALT`;DELIMITER $$

CREATE PROCEDURE `HISPARAMETROSESCALAALT`(

	Par_FolioID 			INT(11),
	Par_TipoPersona			CHAR(1),
	Par_TipoInstrumento		INT(11),
	Par_NacMoneda			CHAR(1),
    Par_Salida          	CHAR(1),

    INOUT Par_NumErr    	INT,
    INOUT Par_ErrMen    	VARCHAR(400),

    Aud_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,

	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
    Aud_SucursalID			INT,
    Aud_NumTransaccion		BIGINT
				)
TerminaStore: BEGIN


DECLARE Var_Control			VARCHAR(20);
DECLARE Var_Consecutivo		INT(11);
DECLARE Var_TipoInstruMonID	INT(11);
DECLARE Var_MonedaId		INT(11);
DECLARE Var_RolID			INT(11);
DECLARE Var_FechaModif		DATE;

DECLARE Var_TipoPersona			CHAR(1);
DECLARE Var_TipoInstrumento		INT(11);
DECLARE Var_NacMoneda			CHAR(1);
DECLARE Var_LimiteInferior		DECIMAL(14,2);
DECLARE Var_MonedaComp			INT(11);
DECLARE Var_RolTitular			INT(11);
DECLARE Var_RolSuplente			INT(11);


DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT;
DECLARE Decimal_Cero	DECIMAL(12,2);
DECLARE MonedaNac		CHAR(1);
DECLARE MonedaExt		CHAR(1);
DECLARE SalidaSi		CHAR(1);
DECLARE SalidaNo		CHAR(1);
DECLARE EstatusVigente	char(1);


SET	Cadena_Vacia		:= '';
SET	Fecha_Vacia			:= '1900-01-01';
SET	Entero_Cero			:= 0;
SET Decimal_Cero		:= 0.0;
SET	MonedaNac			:= 'N';
SET	MonedaExt			:= 'E';
SET	SalidaSi			:= 'S';
SET	SalidaNo			:= 'N';
SET EstatusVigente		:= 'V';

SET Aud_FechaActual		:= NOW();
SET Var_FechaModif 	:= (SELECT FechaSistema FROM PARAMETROSSIS);

ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := '999';
            SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-HISPARAMETROSESCALAALT');
			SET Var_Control := 'sqlException' ;
		END;

	IF(IFNULL(Par_FolioID,Entero_Cero)=Entero_Cero)THEN
			SET Par_NumErr := 001;
            SET Par_ErrMen := CONCAT('El Numero de Folio esta vacio.');
			SET Var_Control := 'tipoInstrumento' ;
            LEAVE ManejoErrores;
    END IF;

    SELECT	TipoPersona,		TipoInstrumento,		NacMoneda,			LimiteInferior,		MonedaComp,
            RolTitular,			RolSuplente
	  INTO 	Var_TipoPersona,	Var_TipoInstrumento,	Var_NacMoneda,		Var_LimiteInferior,	Var_MonedaComp,
            Var_RolTitular,		Var_RolSuplente
		FROM PARAMETROSESCALA
			WHERE FolioID 			= Par_FolioID
				AND TipoPersona 	= Par_TipoPersona
				AND TipoInstrumento = Par_TipoInstrumento
				AND NacMoneda 		= Par_NacMoneda;


	CALL FOLIOSAPLICAACT('HISPARAMETROSESCALA', Var_Consecutivo);

    INSERT INTO HISPARAMETROSESCALA (
		FolioID,			TipoPersona,		TipoInstrumento,		NacMoneda,			LimiteInferior,
		MonedaComp,			RolTitular,			RolSuplente,			FechaModificacion,	EmpresaID,
        Usuario,			FechaActual,		DireccionIP,			ProgramaID,			SucursalID,
        NumTransaccion)
	VALUES (
		Var_Consecutivo,	Var_TipoPersona,	Var_TipoInstrumento,	Var_NacMoneda,		Var_LimiteInferior,
		Var_MonedaComp,		Var_RolTitular,		Var_RolSuplente,		Var_FechaModif,		Aud_EmpresaID,
        Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_SucursalID,
        Aud_NumTransaccion);

	SET Par_NumErr := 000;
	SET Par_ErrMen := CONCAT('Parametros Agregados Exitosamente al historico');
	SET Var_Control := 'tipoPersona' ;

END ManejoErrores;

IF(IFNULL(Par_Salida,SalidaNo)=SalidaSi)THEN
	SELECT	Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Entero_Cero AS Consecutivo;
END IF;

END TerminaStore$$