-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMETROSOPRELALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMETROSOPRELALT`;DELIMITER $$

CREATE PROCEDURE `PARAMETROSOPRELALT`(

	Par_MonLimOPR			INT(11),
	Par_LimitInferior		DECIMAL(12,2),
	Par_FechaInicioVig		DATE,
	Par_FechaFinVig			DATE,
	Par_LimMenMicro			DECIMAL(12,2),

	Par_MondaLimMicro		INT(11),
    Par_Salida          	CHAR(1),
    INOUT Par_NumErr    	INT,
    INOUT Par_ErrMen    	VARCHAR(400),

	Par_EmpresaID			INT(11),

	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),

	Aud_NumTransaccion		BIGINT(20)
			)
TerminaStore: BEGIN


DECLARE Var_FechaInicioVig		DATE;
DECLARE Var_Control				VARCHAR(20);


DECLARE Cadena_Vacia           CHAR(1);
DECLARE Entero_Cero            INT;
DECLARE Fecha_Vacia			   DATE;
DECLARE Decimal_Cero		   DECIMAL(12,2);
DECLARE Si_Evalua			   CHAR(1);
DECLARE SalidaSi			   CHAR(1);


SET Cadena_Vacia			:= '';
SET Entero_Cero				:= 0;
SET Fecha_Vacia				:='1900-01-01';
SET Decimal_Cero			:=0.0;
SET Si_Evalua				:='S';
SET SalidaSi				:='S';


SET Var_FechaInicioVig		:= (SELECT FechaSistema FROM PARAMETROSSIS);

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PARAMETROSOPRELALT');
			SET Var_Control := 'sqlException' ;
		END;

	IF(IFNULL( Par_MonLimOPR, Entero_Cero)) = Entero_Cero THEN
		SET	Par_NumErr		:= 001;
		SET	Par_ErrMen		:= CONCAT('La Moneda de Limite Operaciones Relevantes esta vacia.');
		SET Var_Control 	:= 'monedaLimOPR' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL( Par_LimitInferior, Cadena_Vacia)) = Cadena_Vacia THEN
		SET	Par_NumErr		:= 002;
		SET	Par_ErrMen		:= CONCAT('El Limite Inferior para Operaciones Relevantes esta vacio.');
		SET Var_Control 	:= 'limiteInferior' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL( Par_MondaLimMicro, Entero_Cero)) = Entero_Cero THEN
		SET	Par_NumErr		:= 003;
		SET	Par_ErrMen		:= CONCAT('La Moneda de Operaciones de Microcredito esta vacia.');
		SET Var_Control 	:= 'monedaLimMicro' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL( Par_LimMenMicro, Cadena_Vacia)) = Cadena_Vacia THEN
		SET	Par_NumErr		:= 004;
		SET	Par_ErrMen		:= CONCAT('El Limite Inferior para Operaciones de Microcredito esta vacio.');
		SET Var_Control 	:= 'limMensualMicro' ;
		LEAVE ManejoErrores;
	END IF;

	INSERT INTO PARAMETROSOPREL(
		MonedaLimOPR,			LimiteInferior,		FechaInicioVig,			FechaFinVig,		LimMensualMicro,
		MonedaLimMicro,			EvaluaOpeAcumMes,	EmpresaID,				Usuario,			FechaActual,
		DireccionIP,			ProgramaID,			Sucursal,				NumTransaccion)
	VALUES(
		Par_MonLimOPR,			Par_LimitInferior, 	Var_FechaInicioVig,		Par_FechaFinVig,	Par_LimMenMicro,
		Par_MondaLimMicro,  	Si_Evalua,			Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

	SET	Par_NumErr		:= 000;
	SET	Par_ErrMen		:= CONCAT('Parametros Grabados Exitosamente.');
	SET Var_Control 	:= 'monedaLimOPR' ;

END ManejoErrores;

IF(Par_Salida = SalidaSi) THEN
    SELECT 	Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS Control,
            Par_MonLimOPR AS Consecutivo;
END IF;

END TerminaStore$$