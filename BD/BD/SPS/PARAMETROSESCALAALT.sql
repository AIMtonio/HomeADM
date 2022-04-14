-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMETROSESCALAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMETROSESCALAALT`;DELIMITER $$

CREATE PROCEDURE `PARAMETROSESCALAALT`(

	Par_TipoPersona			CHAR(1),
	Par_TipoInstrumento		INT(11),
	Par_NacMoneda			CHAR(1),
	Par_LimiteInferior		DECIMAL(14,2),
	Par_MonedaComp			INT(11),

	Par_RolTitular			INT(11),
	Par_RolSuplente			INT(11),
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
DECLARE Var_FechaVigencia	DATE;


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
SET Var_FechaVigencia 	:= (SELECT FechaSistema FROM PARAMETROSSIS);

ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := '999';
            SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PARAMETROSESCALAALT');
			SET Var_Control := 'sqlException' ;
		END;

	IF(IFNULL(Par_TipoPersona,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_NumErr := 001;
            SET Par_ErrMen := CONCAT('El Tipo de Persona esta vacio.');
			SET Var_Control := 'tipoPersona' ;
            LEAVE ManejoErrores;
    END IF;

	IF(IFNULL(Par_TipoInstrumento,Entero_Cero)=Entero_Cero)THEN
			SET Par_NumErr := 002;
            SET Par_ErrMen := CONCAT('El Tipo de Instrumento esta vacio.');
			SET Var_Control := 'tipoInstrumento' ;
            LEAVE ManejoErrores;
    END IF;

	SELECT IFNULL(TipoInstruMonID,Entero_Cero)
      INTO Var_TipoInstruMonID
		  FROM TIPOINSTRUMMONE
			WHERE TipoInstruMonID = Par_TipoInstrumento;

	IF(IFNULL(Var_TipoInstruMonID,Entero_Cero)=Entero_Cero)THEN
			SET Par_NumErr := 003;
            SET Par_ErrMen := CONCAT('El Tipo de Instrumento No Existe.');
			SET Var_Control := 'tipoInstrumento' ;
            LEAVE ManejoErrores;
    END IF;

	IF(IFNULL(Par_NacMoneda,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_NumErr := 004;
            SET Par_ErrMen := CONCAT('La Nacionalidad de la Moneda esta vacia.');
			SET Var_Control := 'nacMoneda' ;
            LEAVE ManejoErrores;
    END IF;

	IF(IFNULL(Par_NacMoneda,Cadena_Vacia)!=MonedaNac AND IFNULL(Par_NacMoneda,Cadena_Vacia)!=MonedaExt)THEN
			SET Par_NumErr := 005;
            SET Par_ErrMen := CONCAT('La Nacionalidad de la Moneda no es valida.');
			SET Var_Control := 'nacMoneda' ;
            LEAVE ManejoErrores;
    END IF;

	IF(IFNULL(Par_LimiteInferior,Decimal_Cero)=Decimal_Cero)THEN
			SET Par_NumErr := 006;
            SET Par_ErrMen := CONCAT('El Limite Inferior esta vacio.');
			SET Var_Control := 'limiteInferior' ;
            LEAVE ManejoErrores;
    END IF;

	IF(IFNULL(Par_MonedaComp,Entero_Cero)=Entero_Cero)THEN
			SET Par_NumErr := 007;
            SET Par_ErrMen := CONCAT('El Tipo de Moneda de Comparacion esta vacia.');
			SET Var_Control := 'monedaComp' ;
            LEAVE ManejoErrores;
    END IF;

    SELECT IFNULL(MonedaId,Entero_Cero)
      INTO Var_MonedaId
		FROM MONEDAS
			WHERE MonedaId=Par_MonedaComp;

	IF(IFNULL(Var_MonedaId,Entero_Cero)=Entero_Cero)THEN
			SET Par_NumErr := 008;
            SET Par_ErrMen := CONCAT('El Tipo de Moneda de Comparacion No Existe.');
			SET Var_Control := 'monedaComp' ;
            LEAVE ManejoErrores;
    END IF;

	IF(IFNULL(Par_RolTitular,Entero_Cero)=Entero_Cero)THEN
			SET Par_NumErr := 009;
            SET Par_ErrMen := CONCAT('El Titular esta vacio.');
			SET Var_Control := 'rolTitular' ;
            LEAVE ManejoErrores;
    END IF;

	IF(IFNULL(Par_RolSuplente,Entero_Cero)=Entero_Cero)THEN
			SET Par_NumErr := 010;
            SET Par_ErrMen := CONCAT('El Suplente esta vacio.');
			SET Var_Control := 'rolSuplente' ;
            LEAVE ManejoErrores;
    END IF;

    SELECT IFNULL(RolID,Entero_Cero)
      INTO Var_RolID
		FROM ROLES
			WHERE RolID=Par_RolTitular;

	IF(IFNULL(Var_RolID,Entero_Cero)=Entero_Cero)THEN
			SET Par_NumErr := 011;
            SET Par_ErrMen := CONCAT('El Rol para Titular No Existe.');
			SET Var_Control := 'rolTitular' ;
            LEAVE ManejoErrores;
    END IF;

    SELECT IFNULL(RolID,Entero_Cero)
      INTO Var_RolID
		FROM ROLES
			WHERE RolID=Par_RolSuplente;

	IF(IFNULL(Var_RolID,Entero_Cero)=Entero_Cero)THEN
			SET Par_NumErr := 012;
            SET Par_ErrMen := CONCAT('El Rol para Suplente No Existe.');
			SET Var_Control := 'rolSuplente' ;
            LEAVE ManejoErrores;
    END IF;


	CALL FOLIOSAPLICAACT('PARAMETROSESCALA', Var_Consecutivo);

    INSERT INTO PARAMETROSESCALA (
		FolioID,			TipoPersona,		TipoInstrumento,		NacMoneda,			LimiteInferior,
		MonedaComp,			RolTitular,			RolSuplente,			FechaVigencia,		Estatus,
		EmpresaID,			Usuario,			FechaActual,			DireccionIP,		ProgramaID,
		SucursalID,			NumTransaccion)
	VALUES (
		Var_Consecutivo,	Par_TipoPersona,	Par_TipoInstrumento,	Par_NacMoneda,		Par_LimiteInferior,
		Par_MonedaComp,		Par_RolTitular,		Par_RolSuplente,		Var_FechaVigencia,	EstatusVigente,
		Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
		Aud_SucursalID,		Aud_NumTransaccion);

	SET Par_NumErr := 000;
	SET Par_ErrMen := CONCAT('Parametros Agregados Exitosamente');
	SET Var_Control := 'tipoPersona' ;

END ManejoErrores;

IF(IFNULL(Par_Salida,SalidaNo)=SalidaSi)THEN
	SELECT	Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Entero_Cero AS Consecutivo;
END IF;

END TerminaStore$$