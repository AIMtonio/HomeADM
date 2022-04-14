-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALENDARIOINGRESOSACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CALENDARIOINGRESOSACT`;
DELIMITER $$

CREATE PROCEDURE `CALENDARIOINGRESOSACT`(
	Par_InstitNominaID		INT(11),			-- Numero de Institucion Nomina
	Par_ConvenioNominaID    BIGINT UNSIGNED,			-- Numero de Convenio Nomina
    Par_Anio				INT(4),				-- Numero de Anio
    Par_UsuarioID			INT(11),			-- Número del Usuario que realiza la transaccion
    Par_NumAct				TINYINT UNSIGNED,

	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),
    Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
	)

TerminaStore: BEGIN
-- DECLARACION DE VARIABLES
DECLARE Var_Control			VARCHAR(100);
DECLARE Var_FechaRegistro	DATE;			-- Fecha Registro de la transaccion
DECLARE Hora_Actual         VARCHAR(11);	-- Hora Actual

-- DECLARACION DE CONSTANTES
DECLARE	Cadena_Vacia		CHAR(1);	-- Constante Cadena Vacia
DECLARE	Fecha_Vacia			DATE;		-- Constante Fecha Vacia
DECLARE	Entero_Cero			INT;		-- Constante Entero Cero
DECLARE SalidaSI			CHAR(1);			-- Salida Si
DECLARE SalidaNO			CHAR(1);			-- Salida No

DECLARE Act_Autoriza		INT;		-- Constante Autoriza
DECLARE Act_Desautoriza		INT;		-- Constante Desautoriza
DECLARE Act_AutorizaDes		VARCHAR(50);-- Constante Descripcion Autoriza
DECLARE Act_DesautorizaDes	VARCHAR(50);-- Constante Descripcion Desautoriza
DECLARE Est_Calend			CHAR(1);	-- Constante Estatus Default-R

-- ASIGNACION DE CONSTANTES
SET	Cadena_Vacia	:= '';
SET	Fecha_Vacia		:= '1900-01-01';
SET	Entero_Cero		:= 0;
SET SalidaSI        := 'S';
SET SalidaNO		:= 'N';

SET Act_Autoriza	:= 2;
SET Act_Desautoriza	:= 3;
SET Act_AutorizaDes	:= 'A';
SET Act_DesautorizaDes := 'D';
SET Est_Calend		:= 'R';


ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CALENDARIOINGRESOSACT');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

        IF( IFNULL(Par_InstitNominaID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:= 'El Numero de la Empresa Nomina se encuentra Vacio.';
			SET Var_Control	:= 'institNominaID';
			LEAVE ManejoErrores;
		END IF;

		IF( IFNULL(Par_ConvenioNominaID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 002;
			SET Par_ErrMen	:= 'El Numero de Convenio se encuentra vacio.';
			SET Var_Control	:= 'convenioNominaID';
			LEAVE ManejoErrores;
		END IF;


		IF( IFNULL(Par_Anio, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 003;
			SET Par_ErrMen	:= 'El Año se encuentra vacio.';
			SET Var_Control	:= 'anio';
			LEAVE ManejoErrores;
		END IF;

		SET Hora_Actual     := (SELECT DATE_FORMAT(NOW( ), "%H:%i:%S" ));
        SET Var_FechaRegistro := (SELECT  FechaSistema FROM PARAMETROSSIS);

        IF(Par_NumAct = Act_Autoriza) THEN
			SET Est_Calend		:= 'A';
			UPDATE CALENDARIOINGRESOS
				SET Estatus 	= Act_AutorizaDes
				WHERE InstitNominaID = Par_InstitNominaID
				AND ConvenioNominaID = Par_ConvenioNominaID
				AND Anio = Par_Anio;

			INSERT INTO HISCALENDARIOINGRESOS (
					InstitNominaID,		ConvenioNominaID,		Anio,				Estatus, 			FechaLimiteEnvio,
					FechaPrimerDesc,	FechaLimiteRecep,		NumCuotas,			FechaRegistro,		UsuarioID,
					Hora,				EmpresaID,				Usuario,			FechaActual,		DireccionIP,
					ProgramaID,			Sucursal,				NumTransaccion)

			SELECT 	InstitNominaID,		ConvenioNominaID,		Anio,				Est_Calend,			FechaLimiteEnvio,
					FechaPrimerDesc,	FechaLimiteRecep,		NumCuotas,			Var_FechaRegistro,	Par_UsuarioID,
					Hora_Actual,		Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal, 			Aud_NumTransaccion
			FROM CALENDARIOINGRESOS
			WHERE InstitNominaID = Par_InstitNominaID
			AND ConvenioNominaID = Par_ConvenioNominaID
			AND Anio = Par_Anio ;

		END IF;



		IF(Par_NumAct = Act_Desautoriza) THEN
			SET Est_Calend		:= 'D';
			UPDATE CALENDARIOINGRESOS
				SET Estatus 	= Act_DesautorizaDes
				WHERE InstitNominaID = Par_InstitNominaID
				AND ConvenioNominaID = Par_ConvenioNominaID
				AND Anio = Par_Anio;

			INSERT INTO HISCALENDARIOINGRESOS (
					InstitNominaID,		ConvenioNominaID,	Anio,					Estatus,			FechaLimiteEnvio,
					FechaPrimerDesc,	FechaLimiteRecep,	NumCuotas,				FechaRegistro,		UsuarioID,
					Hora,				EmpresaID,			Usuario,				FechaActual,		DireccionIP,
					ProgramaID,			Sucursal,			NumTransaccion)

			SELECT 	InstitNominaID,		ConvenioNominaID,	Anio,					Est_Calend,			FechaLimiteEnvio,
					FechaPrimerDesc,	FechaLimiteRecep,	NumCuotas,				Var_FechaRegistro,	Par_UsuarioID,
					Hora_Actual,		Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal, 		Aud_NumTransaccion
			FROM CALENDARIOINGRESOS
			WHERE InstitNominaID = Par_InstitNominaID
			AND ConvenioNominaID = Par_ConvenioNominaID
			AND Anio = Par_Anio ;
        END IF;

		 IF(Par_NumErr<>Entero_Cero)THEN
				SET Var_Control := 'hisCalendarioIngID';
				LEAVE ManejoErrores;
			END IF;

		SET Par_NumErr	:= 	Entero_Cero;
		SET Par_ErrMen	:= 'Calendario de Ingresos Actualizado Correctamente.';
		SET Var_Control	:= 'calendarioIngID';

	END ManejoErrores;

-- Si Par_Salida = S (SI)
	IF(Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr				AS NumErr,
				Par_ErrMen				AS ErrMen,
				Var_Control				AS Control,
				Par_InstitNominaID		AS Consecutivo;

	END IF;


END TerminaStore$$