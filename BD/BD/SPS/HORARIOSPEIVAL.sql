-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HORARIOSPEIVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `HORARIOSPEIVAL`;DELIMITER $$

CREATE PROCEDURE `HORARIOSPEIVAL`(



	Par_NumEmpre		INT(11),
	Par_NumSucur		INT(11),
    Par_NumVal			TINYINT UNSIGNED,

	Par_Salida			CHAR(1),
    INOUT Par_NumErr	INT,
    INOUT Par_ErrMen	VARCHAR(400),

	Par_EmpresaID		INT(11),
    Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(20),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(11)
)
TerminaStore:BEGIN


	DECLARE Var_Control	        VARCHAR(200);
	DECLARE	Var_Estatus			CHAR(1);
	DECLARE Var_HoraInicio      TIME;
	DECLARE Var_HoraFin         TIME;
	DECLARE Var_HoraAct         TIME;
	DECLARE Var_FechaActCat     DATE;
	DECLARE	Var_FechaSis		DATE;
	DECLARE	Var_FechaHabil		DATE;
	DECLARE	Var_EsHabil			CHAR(1);


	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Entero_Cero			INT;
	DECLARE Decimal_Cero		DECIMAL;
	DECLARE Salida_SI			CHAR(1);
	DECLARE	Salida_NO			CHAR(1);
	DECLARE	Estatus_Act     	CHAR(1);
	DECLARE Habil_SI			CHAR(1);
	DECLARE Habil_NO			CHAR(1);
	DECLARE	Val_HoOpera     	INT;
	DECLARE	Val_ActCat	     	INT;




	SET Cadena_Vacia		:= '';
	SET Entero_Cero			:= 0;
	SET Decimal_Cero		:= 0.00;
	SET Salida_SI			:= 'S';
	SET Salida_NO			:= 'N';
	SET Estatus_Act         := 'A';
	SET Habil_SI			:= 'S';
	SET Habil_NO			:= 'N';
	SET	Val_HoOpera			:= 1;
	SET	Val_ActCat			:= 2;


	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operación. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-HORARIOSPEIVAL');
				SET Var_Control = 'sqlException';
			END;

		IF(IFNULL(Par_EmpresaID,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr := 001;
			SET Par_ErrMen :='El numero de la Empresa esta vacio.';
			SET Var_Control:=  'empresaID' ;
			LEAVE ManejoErrores;
		END IF;

		IF(ISNULL(Aud_Sucursal)) THEN
			SET Par_NumErr := 002;
			SET Par_ErrMen :='El numero de la sucursal esta vacio.';
			SET Var_Control:=  'sucursal' ;
			LEAVE ManejoErrores;
		END IF;

		SELECT	HorarioInicio,	HorarioFin,		UltActCat
		  INTO	Var_HoraInicio, Var_HoraFin,	Var_FechaActCat
			FROM  PARAMETROSSPEI
			WHERE	EmpresaID = Par_EmpresaID;

		SELECT	FechaSistema	INTO	Var_FechaSis
			FROM PARAMETROSSIS;

		SET Var_HoraAct := (SELECT CURTIME());

		CALL DIASFESTIVOSCAL(
			CURDATE(),		0,					Var_FechaHabil,		Var_EsHabil,		Par_EmpresaID,
			Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

		IF(Par_NumVal = Val_HoOpera) THEN

			IF(Var_EsHabil = Habil_SI)THEN
				IF(Var_HoraAct < Var_HoraInicio || Var_HoraAct > Var_HoraFin) THEN
					SET Par_NumErr := 100;
					SET Par_ErrMen := 'El Usuario No Puede Operar, Está fuera del Horario de Operaciones SPEI.';
					SET Var_Control :=  'HoraActual' ;
					LEAVE ManejoErrores;
				ELSE
					IF(Var_FechaSis > Var_FechaActCat) THEN
						SET Par_NumErr := 101;
						SET Par_ErrMen := 'Los Catalogos Se Encuentran Desactualizado.';
						SET Var_Control :=  'HoraActual' ;
						LEAVE ManejoErrores;
					ELSE
						SET Par_NumErr := 000;
						SET Par_ErrMen := 'Validacion de Horario Exitosa.';
						SET Var_Control:=  'HoraActual' ;
						LEAVE ManejoErrores;
					END IF;
				END IF;
			ELSE
				SET Par_NumErr := 102;
				SET Par_ErrMen := 'El Usuario No Puede Operar, Está fuera de Día de operaciones SPEI.';
				SET Var_Control :=  'HoraActual' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_NumVal = Val_ActCat) THEN
			IF(Var_EsHabil = Habil_SI) THEN
				IF(Var_HoraAct < Var_HoraInicio || Var_HoraAct > Var_HoraFin) THEN
					SET Par_NumErr := 100;
					SET Par_ErrMen := 'El Usuario No Puede Operar, Está fuera del Horario de Operaciones SPEI.';
					SET Var_Control :=  'HoraActual' ;
					LEAVE ManejoErrores;
				ELSE
					IF(Var_FechaSis = Var_FechaActCat) THEN
						SET Par_NumErr := 101;
						SET Par_ErrMen := 'Los Catalogos Se Encuentran Actualizados.';
						SET Var_Control :=  'HoraActual' ;
						LEAVE ManejoErrores;
					ELSE
						SET Par_NumErr := 000;
						SET Par_ErrMen := 'Validacion de Horario Exitosa.';
						SET Var_Control:=  'HoraActual' ;
						LEAVE ManejoErrores;
					END IF;
				END IF;
			ELSE
				SET Par_NumErr := 102;
				SET Par_ErrMen := 'El Usuario No Puede Operar, Está fuera de Día de operaciones SPEI.';
				SET Var_Control :=  'HoraActual' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;

	END ManejoErrores;

		IF(Par_Salida = Salida_SI )THEN
			SELECT	Par_NumErr AS NumErr ,
					Par_ErrMen AS ErrMen,
					Var_Control AS control;
		END IF;

END  TerminaStore$$